{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/main";
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks.url = "github:cachix/git-hooks.nix";
    mk-shell-bin.url = "github:tarc/nix-mk-shell-bin";
    nix2container.url = "github:nlewo/nix2container";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    devenv.inputs.nixpkgs.follows = "nixpkgs";
    devenv.inputs.flake-parts.follows = "flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.inputs.flake-parts.follows = "flake-parts";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      ...
    }:
    {

    };
}
