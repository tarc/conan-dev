<div align="center">

# Conan development environment

**Development tools for the [Conan C/C++ Package Manager](https://conan.io/)**

_A [devenv](https://devenv.sh/) powered project._

<p>
<a href="https://ci.codeberg.org/repos/17706" target="_blank">
  <img src="https://ci.codeberg.org/api/badges/17706/status.svg" alt="status-badge" />
</a>
</p>

</div>

To get started, clone this repository and allow `devenv` to set up the environment:

```sh
git clone ssh://git@codeberg.org/tarcisio/conan-dev.git
cd conan-dev/apps/conan
devenv allow
```

After the above commands finish executing, run the following:

```sh
init-conan-submodule
```

The `init-conan-submodule` script initializes a git submodule with a fork of the [Conan source code repository](https://github.com/conan-io/conan):

[embedmd]:# (./.gitmodules)
```gitmodules
[submodule "conan"]
	path = apps/conan/conan
	url = https://github.com/tarc/conan.git
	branch = nix-tests
```

and checkout a specific branch with minor changes on the test suite:

[embedmd]:# (./apps/conan/devenv.nix nix /.*init-conan-submodule/ /'';/ dedent)
```nix
init-conan-submodule.exec = ''
  git submodule update --init --remote
  cd "$DEVENV_ROOT/conan"
  git checkout nix-tests
  git remote add upstream git@github.com:conan-io/conan.git 2>/dev/null
'';
```

## Profile activation

Two profiles are available:

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
