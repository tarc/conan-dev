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

[embedmd]:# (./apps/conan/devenv.nix nix /.*init-conan-submodule.exec/ /'';/ dedent)
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


## Usage

### Update Conan submodule

```sh > text $
update-conan-submodule
```

<!-- BEGIN mdsh -->
```text
Your branch is up to date with 'origin/nix-tests'.
Current branch nix-tests is up to date.
```
<!-- END mdsh -->

### Testing

```sh > text $
functional-cmake-toolchain-tests
```

<!-- BEGIN mdsh -->
```text
============================= test session starts ==============================
platform linux -- Python 3.14.7, pytest-9.1.1, pluggy-1.6.0
rootdir: /home/tarci/projects/conan-dev/apps/conan/conan
configfile: pytest.ini
plugins: cov-7.1.0, xdist-3.8.0
collected 38 items

test/functional/toolchains/cmake/test_cmake_toolchain.py sss...s.....sss [ 39%]
sss...........sssss.s..                                                  [100%]

======================= 22 passed, 16 skipped in 16.71s ========================
```
<!-- END mdsh -->

```sh > text $
single-test test/functional/test_profile_detect_api.py -s
```

<!-- BEGIN mdsh -->
```text
============================= test session starts ==============================
platform linux -- Python 3.14.7, pytest-9.1.1, pluggy-1.6.0
rootdir: /home/tarci/projects/conan-dev/apps/conan/conan
configfile: pytest.ini
plugins: cov-7.1.0, xdist-3.8.0
collected 9 items

test/functional/test_profile_detect_api.py s.s......

========================= 7 passed, 2 skipped in 0.19s =========================
```
<!-- END mdsh -->

## References

### Docs

The reference for packaging Python applications is in the
[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/stable/), in the
[Languages and frameworks](https://nixos.org/manual/nixpkgs/stable/#chap-language-support)
chapter:

- [Python](https://nixos.org/manual/nixpkgs/stable/#python)
