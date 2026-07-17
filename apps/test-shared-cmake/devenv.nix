{
  pkgs,
  config,
  ...
}:
let
  cfg = config.playPython;
in
{
  inherit (cfg.packages) stdenv;

  packages = with cfg.packages; [
    pkgs.conan

    # play-python packages:
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
}
