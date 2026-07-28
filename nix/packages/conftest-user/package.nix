{
  lib,
  pkgs,
  bazel_7,
  bazel_8,
  bazel_9,
  clang_20,
  cmake_3_15_7,
  cmake_3_27_9,
  cmake_4_1_2,
  git-wrapped,
  intel-oneapi-toolkit_2026_0_0_198,
  libc_bin,
  ninja_1_10_2,
  pkg-config_0_28,
  pkg-config_0_29_2,
  premake5,
  qbs_2_6_0,
  intelOpenapiToolkit ? intel-oneapi-toolkit_2026_0_0_198,
}:
let
  oneapiPath =
    if intelOpenapiToolkit == null then "skip-tests" else "${intelOpenapiToolkit}/compiler/2026.0/bin";
  oneapiRoot = if intelOpenapiToolkit == null then "" else "${intelOpenapiToolkit}";
in
pkgs.writeTextFile {
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
                    'Linux': "${clang_20}/bin"
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
            "${lib.versions.majorMinor pkg-config_0_29_2.version}": {
                "path": {
                    'Windows': "skip-tests",
                    'Darwin': "${pkg-config_0_29_2}/bin",
                    'Linux': "${pkg-config_0_29_2}/bin",
                }
            },
            "0.28": {
                "path": {
                    # Using chocolatey in Windows -> choco install pkgconfiglite --version 0.28
                    'Windows': f"{windows_choco_root}/pkgconfiglite/tools/pkg-config-lite-0.28-1/bin",
                    'Darwin': "${pkg-config_0_28}/bin",
                    'Linux': "${pkg-config_0_28}/bin"
                }
            }
        },
        'autotools': {"exe": "autoconf"},
        'cmake': {
            "default": "3.15",
            "3.15": {
                "path": {'Windows': 'C:/tools/cmake/3.15.7/cmake-3.15.7-win64-x64/bin',
                         'Darwin': '/Users/runner/Applications/CMake/3.15.7/bin',
                         'Linux': "${cmake_3_15_7}/bin"}
            },
            "3.23": {
                "path": {'Windows': 'C:/tools/cmake/3.23.5/cmake-3.23.5-windows-x86_64/bin',
                         'Darwin': '/Users/runner/Applications/CMake/3.23.5/bin',
                         'Linux': "skip-tests"}
            },
            "3.27": {
                "path": {'Windows': 'C:/tools/cmake/3.27.9/cmake-3.27.9-windows-x86_64/bin',
                         'Darwin': '/Users/runner/Applications/CMake/3.27.9/bin',
                         'Linux': "${cmake_3_27_9}/bin"}
            },
            "${lib.versions.majorMinor cmake_4_1_2.version}": {},
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
                         'Linux': '${ninja_1_10_2}/bin',
                         'Darwin': '${ninja_1_10_2}/bin'}
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
            "7.x": {"path": {'Linux': '${bazel_7}/bin',
                             'Windows': 'C:/tools/bazel/7.6.2',
                             'Darwin': '${bazel_7}/bin'}},
            "8.x": {"path": {'Linux': '${bazel_8}/bin',
                             'Windows': 'C:/tools/bazel/8.4.2',
                             'Darwin': '${bazel_8}/bin'}},
            "9.x": {"path": {'Linux': '${bazel_9}/bin',
                             'Windows': 'C:/tools/bazel/9.1.0',
                             'Darwin': '${bazel_9}/bin'}},
        },
        'premake': {
            "exe": "premake5",
            "default": "5.0.0",
            "5.0.0": {
                "path": {'Linux': '${premake5}/bin',
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
                "path": {'Darwin': "skip-tests",
                         'Linux': "skip-tests",
                         'Windows': "skip-tests"}
            }
        },
        "qbs": {
            "exe": "qbs",
            "default": "2.6.0",
            "2.6.0": {
                "path": {'Linux': '${qbs_2_6_0}/bin'}
            }
        },
        "git": {
            "exe": "git",
            "default": "wrapped",
            "wrapped": {
                "path": {'Linux': '${git-wrapped}/bin',
                         'Darwin': '${git-wrapped}/bin'}
            }
        },
        "scons": {},
        "emcc": {},
        "node": {},
        "intel_oneapi": {
            "default": "2026.0",
            "exe": "icpx",
            "2026.0": {
                "path": {"Linux": "${oneapiPath}"},
                "root": {"Linux": "${oneapiRoot}"}
            }
        },
        "ldd": {
            "exe": "ldd",
            "default": "system",
            "system": {
                "path": {'Linux': "${libc_bin}/bin"}
            }
        }
    }
  '';
  destination = "/conf/conftest_user.py";
}
