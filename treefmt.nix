{ pkgs, ... }:
{
  settings = {
    excludes = [
      "*.toml"
      "packages/cmake/check-pc-files-hook.sh"
      "packages/cmake/setup-hook.sh"
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
