{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  # Bootstrap settings:
  multiStdenv = pkgs.multiStdenv;
  libc_bin = pkgs.multiStdenv.cc.libc_bin;
  libcxxStdenv_useLLVM = pkgs.overrideCC (pkgs.llvmPackages.libcxxStdenv.override {
    targetPlatform.useLLVM = true;
    targetPlatform.linker = "lld";
  }) pkgs.llvmPackages.clangUseLLVM;
  intel-oneapi-toolkit_2026_0_0_198 =
    pkgs.callPackage ./packages/intel-oneapi-toolkit/package-2026.0.0.198.nix
      { };
  intel-oneapi-toolkit_2026_0_0_198_libcxxStdenv_useLLVM =
    pkgs.callPackage ./packages/intel-oneapi-toolkit/package-2026.0.0.198.nix
      { stdenv = libcxxStdenv_useLLVM; };

  kit = intel-oneapi-toolkit_2026_0_0_198;
  oneapiCCUnwrapped = kit.stdenv.cc.cc.overrideAttrs (old: {
    passthru = (old.passthru or { }) // {
      langCC = true;
    };
  });
  oneapiCC = pkgs.wrapCCWith {
    cc = oneapiCCUnwrapped;
    gccForLibs = pkgs.gcc.cc;
    extraPackages = [ kit ];
    extraBuildCommands = ''
      ln -s $out/bin/clang++ $out/bin/icpx
      ln -s $out/bin/clang   $out/bin/icx

      echo "export CXX=\"$out/bin/icpx\"" >> $out/nix-support/setup-hook
      echo "export CC=\"$out/bin/icx\"" >> $out/nix-support/setup-hook

      echo "export ONEAPI_ROOT=\"${kit}\"" >> $out/nix-support/setup-hook
    '';
  };
  oneapiStdenv = pkgs.overrideCC pkgs.stdenv oneapiCC;

  # Toolchain settings:
  python_3_11_6 = inputs.nixpkgs-python.packages.${pkgs.stdenv.system}."3.11.6";
  python_3_12_3 = inputs.nixpkgs-python.packages.${pkgs.stdenv.system}."3.12.3";
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

  # Tools:
  conan_2_28_1 = pkgs.callPackage ./packages/conan-2.28.1/package.nix { };
  conan_2_30_0 = pkgs.callPackage ./packages/conan-2.30.0/package.nix { };
  conan = pkgs.callPackage ./packages/conan-develop2/package.nix { };
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
  embedmd = pkgs.callPackage ./packages/embedmd/package.nix { };
  mdsh_0_9_2 = pkgs.callPackage ./packages/mdsh-0.9.2/package.nix { };
  mdsh_0_9_3 = pkgs.callPackage ./packages/mdsh-0.9.3/package.nix { mdsh = mdsh_0_9_2; };
  devenv = pkgs.callPackage ./packages/devenv/package.nix { };

  # Configuration
  cfg = config.intelOpenapiToolkit;
  intelOpenapiToolkit = if cfg.enable then cfg.package else null;
  conftestUser = pkgs.callPackage ./packages/conftest-user/package.nix {
    intelOpenapiToolkit = intelOpenapiToolkit;
  };
in
{
  options = {
    conanDev.packages = pkgs.lib.mkOption {
      type = config.lib.types.outputOf (lib.types.lazyAttrsOf (lib.types.raw or lib.types.unspecified));
      description = "The package set used in the conan-dev projects";
      defaultText = lib.literalMD "The set of packages that are known to work with Conan tests";
    };
    intelOpenapiToolkit = {
      enable = lib.mkEnableOption "Enable Intel oneAPI Toolkit testing";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.intel-oneapi-toolkit_2026_0_0_198;
        defaultText = lib.literalExpression "pkgs.intel-oneapi-toolkit_2026_0_0_198";
        description = "The Intel oneAPI Toolkit package to use.";
      };
    };
  };

  config = {
    conanDev.packages = lib.mkDefault {
      inherit
        multiStdenv
        libc_bin
        libcxxStdenv_useLLVM
        intel-oneapi-toolkit_2026_0_0_198
        intel-oneapi-toolkit_2026_0_0_198_libcxxStdenv_useLLVM
        oneapiStdenv

        #
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

        conan_2_28_1
        conan_2_30_0
        conan
        git-wrapped
        embedmd
        mdsh_0_9_2
        mdsh_0_9_3
        devenv

        conftestUser
        ;
    };

    packages = [
      pkgs.embedmd
      pkgs.mdsh
    ];

    overlays = [
      (_final: _prev: {
        inherit (config.conanDev.packages)
          cmake_3_15_7
          cmake_3_27_9
          cmake_4_1_2
          devenv
          embedmd
          git-wrapped
          intel-oneapi-toolkit_2026_0_0_198
          libc_bin
          ninja_1_10_2
          pkg-config_0_28
          pkg-config_0_29_2
          qbs_2_6_0
          ;

        mdsh = config.conanDev.packages.mdsh_0_9_3;
      })
    ];

    git-hooks = {
      hooks = {
        embedmd = {
          enable = true;
          name = "Embed code snippets in README";
          entry = "embedmd ${config.git.root}/README.md";
          types = [
            "text"
            "nix"
          ];
          pass_filenames = false;
        };
      };
    };

    treefmt = {
      enable = true;
      config = ../treefmt.nix;
    };
  };
}
