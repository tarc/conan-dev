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
    cmake_3_15_7
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
    cd "$DEVENV_ROOT"
    rm -rf ./hello
    mkdir -p hello
    cd hello
    conan new cmake_lib -d name=hello -d version=0.1
    conan create . -o "hello/*:shared=True" -tf=""
  '';

  scripts.bootstrap-chat.exec = ''
    cd "$DEVENV_ROOT"
    rm -rf ./chat
    mkdir -p chat
    cd chat
    conan new cmake_lib -d name=chat -d version=0.1 -d requires=hello/0.1
    conan create . -o "chat/*:shared=True" -o "hello/*:shared=True" -tf=""
  '';

  scripts.bootstrap-app.exec = ''
    cd "$DEVENV_ROOT"
    rm -rf ./app
    mkdir -p app
    cd app
    conan new cmake_exe -d name=app -d version=0.1 -d requires=chat/0.1
    conan create . -o "chat/*:shared=True" -o "hello/*:shared=True" -tf=""
  '';

  scripts.bootstrap-autoapp.exec = ''
    cd "$DEVENV_ROOT"
    rm -rf ./autoapp
    mkdir -p autoapp
    cd autoapp
    conan new autotools_exe -d name=autoapp -d version=0.1 -d requires=chat/0.1
    conan create . -o "chat/*:shared=True" -o "hello/*:shared=True"
  '';

  scripts.test-other-client-can-link-autotools.exec = ''
    conan remove "*" -c
    bootstrap-hello
    bootstrap-chat
    bootstrap-autoapp
  '';

  languages.cplusplus = {
    enable = true;
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
