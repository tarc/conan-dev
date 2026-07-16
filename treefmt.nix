{ pkgs, ... }:
{
  settings = {
    excludes = [
      "*.toml"
      "nix/packages/cmake-3.15.7/check-pc-files-hook.sh"
      "nix/packages/cmake-3.15.7/setup-hook.sh"
      "nix/packages/cmake-3.27.9/check-pc-files-hook.sh"
      "nix/packages/cmake-3.27.9/setup-hook.sh"
      "nix/packages/cmake-4.1.2/check-pc-files-hook.sh"
      "nix/packages/cmake-4.1.2/setup-hook.sh"
      "nix/build-support/*/*.sh"
      "nix/build-support/*/*.nix"
      "nix/build-support/*/*.bash"
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
