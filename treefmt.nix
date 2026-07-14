{ pkgs, ... }:
{
  settings = {
    excludes = [
      "*.toml"
      "packages/cmake-3.15.7-old/check-pc-files-hook.sh"
      "packages/cmake-3.15.7-old/setup-hook.sh"
      "packages/cmake-3.15.7/check-pc-files-hook.sh"
      "packages/cmake-3.15.7/setup-hook.sh"
      "packages/cmake-3.27.9/check-pc-files-hook.sh"
      "packages/cmake-3.27.9/setup-hook.sh"
      "packages/cmake-4.1.2/check-pc-files-hook.sh"
      "packages/cmake-4.1.2/setup-hook.sh"
      "build-support/*/*.sh"
      "build-support/*/*.nix"
      "build-support/*/*.bash"
    ];
  };

  programs = {
    deadnix.enable = true;
    deno.enable = pkgs.stdenv.hostPlatform.system != "riscv64-linux";
    mdsh.enable = true;
    nixfmt.enable = true;
    shellcheck.enable = pkgs.stdenv.hostPlatform.system != "riscv64-linux";
    shfmt.enable = pkgs.stdenv.hostPlatform.system != "riscv64-linux";
    yamlfmt.enable = true;
  };
}
