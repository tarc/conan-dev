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
  1. Make sure that the git submodule at `apps/conan/conan` has been initialized (otherwize you can initialize it with `init-conan-submodule`)
  2. Enter in the `apps/conan/conan` directory from the root of this repository and run `git describe --tags --abbrev=0` to get the latest released version, used only as a human-readable version label
  3. Run `git rev-parse HEAD` to get the current hash commit of the conan submodule. If this commit is local only, fail informing this fact. For this step to pass, the commit should be also on the origin remote (`git branch -r --contains HEAD` contains `origin/nix-tests`)
  4. Before editing anything, compare the commit from step 3 against the current `revision` value already in @nix/packages/conan-develop2/package.nix (the let binding), and remember whether they differ — this drives steps 6 and 7 below, so decide it now, before the file is touched
  5. Update the version in @nix/packages/conan-develop2/package.nix to the latest released version from step 2, if necessary. It's the `version` attribute in the `python3Packages.buildPythonApplication` call
  6. If step 4 found the commit changed, update the commit hash in @nix/packages/conan-develop2/package.nix (it's in the let binding, the `revision` variable) to the latest commit from step 3
  7. If step 4 found the commit changed, run `nix store prefetch-file --unpack --hash-type sha256 --json "https://github.com/tarc/conan/archive/<commit>.tar.gz" | jq -r .hash`, substituting the commit placeholder with the value from step 3, then update the `hash` attribute in the `src = fetchFromGitHub` call in @nix/packages/conan-develop2/package.nix to the result. `--unpack` is required: `fetchFromGitHub` hashes the *unpacked* source tree (recursive/NAR mode), not the raw tarball bytes, so hashing the compressed file directly (e.g. with `nix hash file`) would produce a value that never matches what `nix build` computes
  8. If step 4 found the commit changed, run `devenv build conanDev.packages.conan` to verify the updated package actually builds (this also runs its test suite via `pytestCheckHook`). If it fails with a "Missing required secrets: CACHIX_AUTH_TOKEN" error, retry as `CACHIX_AUTH_TOKEN=dummy devenv build conanDev.packages.conan` — that secret is only needed to push to the build cache, not to build. If the build fails for any other reason, stop here, leave the file edits in place, and report the failure instead of committing
  9. Commit the changes if the version or the commit hash (and therefore the NAR hash) were updated, and step 8 either succeeded or was skipped because nothing changed
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

======================= 22 passed, 16 skipped in 19.62s ========================
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
