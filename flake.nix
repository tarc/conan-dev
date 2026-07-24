{
  inputs = {

    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs = {
        nixpkgs-lib.follows = "nixpkgs";
      };
    };
    nix = {
      url = "github:cachix/nix/devenv-2.34";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks-nix.follows = "git-hooks";
        nixpkgs-23-11.follows = "";
        nixpkgs-regression.follows = "";
      };
    };
    cachix = {
      url = "github:cachix/cachix/latest";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        git-hooks.follows = "git-hooks";
        devenv.follows = "";
      };
    };
    nixd = {
      url = "github:nix-community/nixd";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    crate2nix = {
      url = "github:rossng/crate2nix/ba5dd398e31ee422fbe021767eb83b0650303a6e";
      flake = false;
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      flake = false;
    };
  };

  outputs =
    {
      ...
    }:
    {

    };
}
