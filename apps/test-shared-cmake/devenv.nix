{
  config,
  ...
}:
let
  cfg = config.playPython;
in
{
  inherit (cfg.packages) stdenv;

  packages = with cfg.packages; [
    clang_20
    git-wrapped
    pkg-config_0_28
    autoconf
    automake
    libtool_2
    ninja_1_10_2
    meson
    scons
    bazel_7
    premake5
    qbs_2_6_0
    emscripten
    node
    intel-oneapi-toolkit
  ];

  scripts.bootstrap-hello.exec = ''
    set -euo pipefail
    set -x
    cd "$DEVENV_ROOT"
    rm -rf ./hello
    mkdir -p hello
    cd hello
    conan new cmake_lib -d name=hello -d version=0.1
    conan create . -o "hello/*:shared=True" -tf=""
  '';

  scripts.bootstrap-chat.exec = ''
    set -euo pipefail
    set -x
    cd "$DEVENV_ROOT"
    rm -rf ./chat
    mkdir -p chat
    cd chat
    conan new cmake_lib -d name=chat -d version=0.1 -d requires=hello/0.1
    conan create . -o "chat/*:shared=True" -o "hello/*:shared=True" -tf=""
  '';

  scripts.bootstrap-app.exec = ''
    set -euo pipefail
    set -x
    cd "$DEVENV_ROOT"
    rm -rf ./app
    mkdir -p app
    cd app
    conan new cmake_exe -d name=app -d version=0.1 -d requires=chat/0.1
    conan create . -o "chat/*:shared=True" -o "hello/*:shared=True" -tf=""
  '';

  scripts.bootstrap-autoapp.exec = ''
    set -euo pipefail
    set -x
    cd "$DEVENV_ROOT"
    rm -rf ./autoapp
    mkdir -p autoapp
    cd autoapp
    conan new autotools_exe -d name=autoapp -d version=0.1 -d requires=chat/0.1
    conan install . -o "chat/*:shared=True" -o "hello/*:shared=True" --build=missing -g VirtualRunEnv
    . ./build-release/conan/conanrun.sh && \
      conan create . -o "chat/*:shared=True" -o "hello/*:shared=True" --build=missing
  '';

  scripts.bootstrap-mylib.exec = ''
    set -euo pipefail
    set -x
    cd "$DEVENV_ROOT"
    rm -rf ./mylib
    mkdir -p mylib
    cd mylib
    bazel_output_root_dir=$(mktemp -d)
    conan new bazel_7_lib -d name=mylib -d version=1.0 -d output_root_dir="$bazel_output_root_dir"
    conan create .
  '';

  scripts.test-other-client-can-link-cmake.exec = ''
    set -euo pipefail
    set -x
    conan remove "*" -c
    bootstrap-hello
    bootstrap-chat
    bootstrap-app
    cd "$DEVENV_ROOT"
    rm -rf ./build
    mkdir -p build
    cd build
    conan install --requires="app/0.1@" -o "chat*:shared=True" -o "hello/*:shared=True" -g VirtualRunEnv
    . ./conanrun.sh && app
  '';

  scripts.test-other-client-can-link-autotools.exec = ''
    set -euo pipefail
    set -x
    conan remove "*" -c
    bootstrap-hello
    bootstrap-chat
    bootstrap-autoapp
    cd "$DEVENV_ROOT"
    rm -rf ./build
    mkdir -p build
    cd build
    conan install --requires="autoapp/0.1@" -o "chat*:shared=True" -o "hello/*:shared=True" -g VirtualRunEnv
    . ./conanrun.sh && autoapp
  '';

  scripts.test-base-test-basic-lib.exec = ''
    set -euo pipefail
    set -x
    conan remove "*" -c
    bootstrap-mylib
  '';

  languages.cplusplus = {
    enable = true;
    cmake = {
      package = cfg.packages.cmake_3_15_7;
    };
    conan = {
      enable = true;
      config = {
        profiles = {
          settings.compiler."compiler.cppstd" = "17";
          settings._.build_type = "Release";
        };
        offline = true;
      };
    };
  };
}
