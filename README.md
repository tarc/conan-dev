<div align="center">

# Conan development environment

**Development tools for the [Conan C/C++ Package Manager](https://conan.io/)**

_A [devenv](https://devenv.sh/) powered project._

<p>
<a href="https://ci.codeberg.org/repos/17706" target="_blank">
  <img src="https://ci.codeberg.org/api/badges/17706/status.svg" alt="status-badge" />
</a>
<a href="https://devenv.sh" target="_blank">
  <img src="https://devenv.sh/assets/devenv-badge.svg"/>
</a>
</p>

</div>

To get started, clone this repository and allow `devenv` to set up the environment:

```sh
git clone ssh://git@codeberg.org/tarcisio/conan-dev.git
cd conan-dev
devenv --from path:apps/conan allow
```

In the `apps/conan/devenv.yaml` file, the default profile is set as:

[embedmd]:# (./apps/conan/devenv.yaml yaml /profile:.*/)
```yaml
profile: testAll
```

It's also possible to specify the profile directly:

```sh
devenv --from path:apps/conan --profile testIntelCc allow
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
  set -euo pipefail
  set -x
  git submodule update --init --remote
  cd "${config.git.root}/apps/conan/conan"
  git checkout nix-tests
  git remote add upstream git@github.com:conan-io/conan.git 2>/dev/null
'';
```


## References

### Docs

The reference for packaging Python applications is in the
[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/stable/), in the
[Languages and frameworks](https://nixos.org/manual/nixpkgs/stable/#chap-language-support)
chapter:

- [Python](https://nixos.org/manual/nixpkgs/stable/#python)
