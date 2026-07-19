{
  pkgs,
  lib,
  config,
  ...
}:
let
  python = config.languages.python;
  cfg = config.playPython;

  # Settings:
  conftestUser = pkgs.writeTextFile {
    name = "conf";
    text = ''
      import os
      import pathlib
      import platform
      import uuid
      from shutil import which

      import pytest

      from conan.internal.api.detect.detect_vs import vs_installation_path


      MacOS_arm = all([platform.system() == "Darwin", platform.machine() == "arm64"])
      homebrew_root = "/opt/homebrew" if MacOS_arm else "/usr/local"
      windows_choco_root = "C:/ProgramData/chocolatey/lib/"
      msys2_path = os.getenv("MSYS2_PATH", "C:/msys64")

      tools_locations = {
          "clang": {
              "exe": "clang",
              "default": "20",
              "20": {
                "path": {
                      'Windows': 'C:/Program Files/LLVM/bin',  # by choco
                      'Linux': "${cfg.packages.clang_20}/bin"
                }
              }
          },
          'visual_studio': {"default": "15",
                            "15": {"disabled": not vs_installation_path("15")},
                            "16": {"disabled": not vs_installation_path("16")},
                            "17": {"disabled": not vs_installation_path("17")},
                            "18": {"disabled": not vs_installation_path("18")}},
          'pkg_config': {
              "exe": "pkg-config",
              "default": "0.28",
              "${lib.versions.majorMinor cfg.packages.pkg-config_0_29_2.version}": {
                  "path": {
                      'Windows': "skip-tests",
                      'Darwin': "${cfg.packages.pkg-config_0_29_2}/bin",
                      'Linux': "${cfg.packages.pkg-config_0_29_2}/bin",
                  }
              },
              "0.28": {
                  "path": {
                      # Using chocolatey in Windows -> choco install pkgconfiglite --version 0.28
                      'Windows': f"{windows_choco_root}/pkgconfiglite/tools/pkg-config-lite-0.28-1/bin",
                      'Darwin': "${cfg.packages.pkg-config_0_28}/bin",
                      'Linux': "${cfg.packages.pkg-config_0_28}/bin"
                  }
              }
          },
          'autotools': {"exe": "autoconf"},
          'shared': {
              'default': 'all',
              'all': {
                  'path': {'Linux': 'skip-tests'}
              }
          },
          'cmake': {
              "default": "3.15",
              "3.15": {
                  "path": {'Windows': 'C:/tools/cmake/3.15.7/cmake-3.15.7-win64-x64/bin',
                           'Darwin': '/Users/runner/Applications/CMake/3.15.7/bin',
                           'Linux': "${cfg.packages.cmake_3_15_7}/bin"}
              },
              "3.23": {
                  "path": {'Windows': 'C:/tools/cmake/3.23.5/cmake-3.23.5-windows-x86_64/bin',
                           'Darwin': '/Users/runner/Applications/CMake/3.23.5/bin',
                           'Linux': "skip-tests"}
              },
              "3.27": {
                  "path": {'Windows': 'C:/tools/cmake/3.27.9/cmake-3.27.9-windows-x86_64/bin',
                           'Darwin': '/Users/runner/Applications/CMake/3.27.9/bin',
                           'Linux': "${cfg.packages.cmake_3_27_9}/bin"}
              },
              "${lib.versions.majorMinor cfg.packages.cmake_4_1_2.version}": {},
              "4.3": {
                  "path": {'Windows': 'C:/tools/cmake/4.3.4/cmake-4.3.4-windows-x86_64/bin',
                           'Darwin': '/Users/runner/Applications/CMake/4.3.4/bin',
                           'Linux': "skip-tests"}
              }
          },
          'ninja': {
              "default": "1.10.2",
              "1.10.2": {
                  "path": {'Windows': f'{windows_choco_root}/ninja/tools',
                           'Linux': '${cfg.packages.ninja_1_10_2}/bin',
                           'Darwin': '${cfg.packages.ninja_1_10_2}/bin'}
              }
          },
          # This is the non-msys2 mingw, which is 32 bits x86 arch
          'mingw': {
              "disabled": True,
              "platform": "Windows",
              "default": "system",
              "exe": "mingw32-make",
              "system": {"path": {'Windows': "C:/ProgramData/mingw64/mingw64/bin"}},
          },
          'mingw32': {
              "platform": "Windows",
              "default": "system",
              "exe": "mingw32-make",
              "system": {"path": {'Windows': f"{msys2_path}/mingw32/bin"}},
          },
          'ucrt64': {
              "platform": "Windows",
              "default": "system",
              "exe": "mingw32-make",
              "system": {"path": {'Windows': f"{msys2_path}/ucrt64/bin"}},
          },
          'mingw64': {
              "platform": "Windows",
              "default": "system",
              "exe": "mingw32-make",
              "system": {"path": {'Windows': f"{msys2_path}/mingw64/bin"}},
          },
          'msys2': {
              "platform": "Windows",
              "default": "system",
              "exe": "make",
              "system": {"path": {'Windows': f"{msys2_path}/usr/bin"}},
          },
          'msys2_clang64': {
              "platform": "Windows",
              "default": "system",
              "exe": "clang",
              "system": {"path": {'Windows': f"{msys2_path}/clang64/bin"}},
          },
          'msys2_mingw64_clang64': {
              "platform": "Windows",
              "default": "system",
              "exe": "clang",
              "system": {"path": {'Windows': f"{msys2_path}/mingw64/bin"}},
          },
          'cygwin': {
              "platform": "Windows",
              "default": "system",
              "exe": "make",
              "system": {"path": {'Windows': "C:/tools/cygwin/bin"}},
          },
          'meson': {},
          'bazel': {
              "default": "7.x",
              "6.x": {"path": {'Linux': "skip-tests",
                               'Windows': 'C:/tools/bazel/6.6.0',
                               'Darwin': '/Users/runner/Applications/bazel/6.6.0'}},
              "7.x": {"path": {'Linux': '${cfg.packages.bazel_7}/bin',
                               'Windows': 'C:/tools/bazel/7.6.2',
                               'Darwin': '${cfg.packages.bazel_7}/bin'}},
              "8.x": {"path": {'Linux': '${cfg.packages.bazel_8}/bin',
                               'Windows': 'C:/tools/bazel/8.4.2',
                               'Darwin': '${cfg.packages.bazel_8}/bin'}},
              "9.x": {"path": {'Linux': '${cfg.packages.bazel_9}/bin',
                               'Windows': 'C:/tools/bazel/9.1.0',
                               'Darwin': '${cfg.packages.bazel_9}/bin'}},
          },
          'mylib': {
              'default': 'all',
              'all': {
                  'path': {'Linux': 'skip-tests'}
              }
          },
          'premake': {
              "exe": "premake5",
              "default": "5.0.0",
              "5.0.0": {
                  "path": {'Linux': '${cfg.packages.premake5}/bin',
                           'Windows': 'skip-tests',
                           'Darwin': 'skip-tests'}
              }
          },
          'xcodegen': {"platform": "Darwin"},
          'apt_get': {"disabled": True},
          'brew': {"disabled": True},
          'android_ndk': {
              "platform": "Darwin",
              "exe": "ndk-build",
              "default": "system",
              "system": {
                  "path": {'Darwin': os.getenv("ANDROID_NDK"),
                           'Linux': os.getenv("ANDROID_NDK_ROOT"),
                           'Windows': "skip-tests"}
              }
          },
          "qbs": {
              "exe": "qbs",
              "default": "2.6.0",
              "2.6.0": {
                  "path": {'Linux': '${cfg.packages.qbs_2_6_0}/bin'}
              }
          },
          "git": {
              "exe": "git",
              "default": "wrapped",
              "wrapped": {
                  "path": {'Linux': '${cfg.packages.git-wrapped}/bin',
                           'Darwin': '${cfg.packages.git-wrapped}/bin'}
              }
          },
          "scons": {},
          "emcc": {},
          "node": {},
          "intel_oneapi": {
              "default": "2026.0",
              "exe": "icpx",
              "2026.0": {
                  "path": {"Linux": "${cfg.packages.intel-oneapi-toolkit}/compiler/2026.0/bin"},
                  "root": {"Linux": "${cfg.packages.intel-oneapi-toolkit}"}
              }
          },
          "ldd": {
              "exe": "ldd",
              "default": "system",
              "system": {
                  "path": {'Linux': "${cfg.packages.libc_bin}/bin"}
              }
          }
      }
    '';
    destination = "/conf/conftest_user.py";
  };
in
{
  # inherit (cfg.packages) stdenv;
  # inherit (cfg.packages.intel-oneapi-toolkit) stdenv;
  # stdenv = cfg.packages.libcxxStdenv_useLLVM;
  # stdenv = cfg.packages.multiStdenv;

  packages = with cfg.packages; [
    # python_3_11_6
    # python_3_12_3
    # clang_20
    # cmake_3_15_7
    cmake_4_1_2
    # git-wrapped
    # pkg-config_0_28
    # pkg-config_0_29_2
    # autoconf
    # automake
    # libtool_2
    # ninja_1_10_2
    # meson
    # scons
    # bazel_8
    # premake5
    # qbs_2_6_0
    # emscripten
    # node
    intel-oneapi-toolkit
    # pkgs.coreutils-full
  ];

  languages = {
    python = {
      enable = true;
      directory = "./conan";
      uv = {
        enable = true;
        sync.enable = true;
      };
      venv = {
        enable = true;
      };
    };
  };

  enterShell = ''
    export VENV_PATH="$DEVENV_STATE/venv"
    ${python.uv.package}/bin/uv pip install --python "$VENV_PATH/bin/python" -r conan/conans/requirements.txt
    ${python.uv.package}/bin/uv pip install --python "$VENV_PATH/bin/python" -r conan/conans/requirements_server.txt
    ${python.uv.package}/bin/uv pip install --python "$VENV_PATH/bin/python" -r conan/conans/requirements_dev.txt
  '';

  enterTest = ''
    cd "$DEVENV_ROOT/conan"
    export PYTHONPATH=$PYTHONPATH:$(pwd)
    python -m pytest .
  '';

  scripts = {
    all-tests.exec = ''
      cd "$DEVENV_ROOT/conan"
      export PYTHONPATH=$PYTHONPATH:$(pwd)
      echo "PYTHONPATH: ''${PYTHONPATH@Q}"
      if [[ -f ./test/conftest_user.py ]];
      then
        rm -f ./test/conftest_user.py
      fi
      cp ${conftestUser}/conf/conftest_user.py ./test/conftest_user.py
      echo "./test/conftest_user.py"
      cat ./test/conftest_user.py
      python -m pytest .
    '';

    single-test.exec = ''
      cd "$DEVENV_ROOT/conan"
      export PYTHONPATH=$PYTHONPATH:$(pwd)
      echo "PYTHONPATH: ''${PYTHONPATH@Q}"
      if [[ -f ./test/conftest_user.py ]];
      then
        rm -f ./test/conftest_user.py
      fi
      cp ${conftestUser}/conf/conftest_user.py ./test/conftest_user.py
      echo "./test/conftest_user.py"
      cat ./test/conftest_user.py
      python -m pytest "$@"
    '';
  };

  android = {
    enable = true;
    ndk.enable = true;
  };
}
