{ pkgs, ... }:
{
  settings = {
    excludes = [
      "*.toml"
      "nix/packages/*"
      "nix/build-support/*/*.sh"
      "nix/build-support/*/*.nix"
      "nix/build-support/*/*.bash"
    ];
  };

  settings.formatter = {
    embedmd = {
      command = "${pkgs.embedmd}/bin/embedmd";
      includes = [ "README.md" ];
    };

    deno = {
      excludes = [ "README.md" ];
    };
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
