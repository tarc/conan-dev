{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  # Bootstrap settings:
  stdenv = pkgs.multiStdenv;
  libc_bin = pkgs.multiStdenv.cc.libc_bin;

  # Toolchain settings:
  python_3_11_6 = inputs.nixpkgs-python.packages.${stdenv.system}."3.11.6";
  python_3_12_3 = inputs.nixpkgs-python.packages.${stdenv.system}."3.12.3";
  cmake_3_15_7 = pkgs.callPackage ./packages/cmake-3.15.7/package.nix { };
  cmake_3_27_9 = pkgs.callPackage ./packages/cmake-3.27.9/package.nix { };
  cmake_4_1_2 = pkgs.callPackage ./packages/cmake-4.1.2/package.nix { };
  qbs_2_6_0 = pkgs.callPackage ./packages/qbs-2.6.0/package.nix { };
  ninja_1_10_2 = pkgs.callPackage ./packages/ninja/package.nix { ninjaRelease = "1.10"; };
  pkg-config-unwrapped_0_28 = pkgs.callPackage ./packages/pkg-config-unwrapped-0.28/package.nix { };
  pkg-config-unwrapped_0_29_2 =
    pkgs.callPackage ./packages/pkg-config-unwrapped-0.29.2/package.nix
      { };
  pkg-config_0_28 = pkgs.callPackage ./build-support/pkg-config-wrapper {
    pkg-config = pkg-config-unwrapped_0_28;
  };
  pkg-config_0_29_2 = pkgs.callPackage ./build-support/pkg-config-wrapper {
    pkg-config = pkg-config-unwrapped_0_29_2;
  };
  clang =
    llvmPackageSelect:
    let
      stdenv = pkgs.overrideCC ((llvmPackageSelect pkgs).libcxxStdenv.override {
        targetPlatform.useLLVM = true;
        targetPlatform.linker = "lld";
      }) (llvmPackageSelect pkgs).clangUseLLVM;
    in
    stdenv.cc;
  clang_20 = clang (pkgs: pkgs.llvmPackages_20);
  autoconf = pkgs.autoconf;
  automake = pkgs.automake;
  libtool_2 = pkgs.libtool_2;
  meson = pkgs.meson;
  scons = pkgs.scons;
  bazel_7 = pkgs.bazel_7;
  bazel_8 = pkgs.bazel_8;
  bazel_9 = pkgs.bazel_9;
  premake5 = pkgs.premake5;
  emscripten = pkgs.emscripten;
  node = pkgs.nodejs;
  intel-oneapi-toolkit = pkgs.intel-oneapi-toolkit;

  # Tools:
  git-wrapped = pkgs.writeShellApplication {
    name = "git";
    runtimeInputs = [
      pkgs.git
    ];
    text = ''
      passed=false
      for arg in "$@"; do
        case "$arg" in
          diff)
            passed=true
            ;;
        esac
      done
      if [ "$passed" = true ];
      then
        git "$@" --no-ext-diff
      else
        git "$@"
      fi
    '';
  };
in
{
  options = {
    playPython.packages = pkgs.lib.mkOption {
      type = config.lib.types.outputOf (lib.types.lazyAttrsOf (lib.types.raw or lib.types.unspecified));
      description = "The package set used in play-python projects";
      defaultText = lib.literalMD "The set of packages that are known to work with Conan tests";
    };
  };

  config = {
    playPython.packages = lib.mkDefault {
      inherit
        stdenv
        libc_bin

        python_3_11_6
        python_3_12_3
        cmake_3_15_7
        cmake_3_27_9
        cmake_4_1_2
        qbs_2_6_0
        ninja_1_10_2
        pkg-config-unwrapped_0_28
        pkg-config-unwrapped_0_29_2
        pkg-config_0_28
        pkg-config_0_29_2
        clang_20
        autoconf
        automake
        libtool_2
        meson
        scons
        bazel_7
        bazel_8
        bazel_9
        premake5
        emscripten
        node
        intel-oneapi-toolkit

        git-wrapped
        ;
    };

    treefmt = {
      enable = true;
      config = ../treefmt.nix;
    };
  };
}
