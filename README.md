# Conan development environment (devenv)

```sh
git clone ssh://git@codeberg.org/tarcisio/conan-dev.git
cd conan-dev
git submodule update --init --remote
cd apps/conan
devenv allow
```

After the above commands finish executing:

```sh
init-conan-submodule
```

## Profile activation

[embedmd]:# (./apps/conan/devenv.nix nix /.*profiles.user/ /# profiles.user/ s/tarci/username/ dedent)
```nix
profiles.user."username" = {
  extends = [
    # "testIntelCc"
    "testAll"
  ];
}; # profiles.user
```

### Profile: `testIntelCc`

```sh
single-test test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC -s
```

### Profile: `testAll`

```sh
all-tests
```

## References

### Docs

The reference for packaging Python applications is in the
[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/stable/), in the
[Languages and frameworks](https://nixos.org/manual/nixpkgs/stable/#chap-language-support)
chapter:

- [Python](https://nixos.org/manual/nixpkgs/stable/#python)
