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
  set -euo pipefail
  set -x
  git submodule update --init --remote
  cd "$DEVENV_ROOT/conan"
  git checkout nix-tests
  git remote add upstream git@github.com:conan-io/conan.git 2>/dev/null
'';
```

## Profile activation

Two profiles are available:

[embedmd]:# (./apps/conan/devenv.nix nix /.*profiles = {/ /}; # profiles/ dedent)
```nix
profiles = {
  testIntelCc.module = {
    inherit (cfg.packages.intel-oneapi-toolkit_2026_0_0_198) stdenv;

    packages = with cfg.packages; [
      cmake_3_15_7
    ];

    scripts = {
      all-tests.exec = ''
        cd "$DEVENV_ROOT/conan"
        export PYTHONPATH=$PYTHONPATH:$(pwd)
        echo "PYTHONPATH: ''${PYTHONPATH@Q}"
        if [[ -f ./test/conftest_user.py ]];
        then
          rm -f ./test/conftest_user.py
        fi
        cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
        echo "./test/conftest_user.py"
        cat ./test/conftest_user.py
        python -m pytest ${deselectExpression} .
      '';

      single-test.exec = ''
        cd "$DEVENV_ROOT/conan"
        export PYTHONPATH=$PYTHONPATH:$(pwd)
        echo "PYTHONPATH: ''${PYTHONPATH@Q}"
        if [[ -f ./test/conftest_user.py ]];
        then
          rm -f ./test/conftest_user.py
        fi
        cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
        echo "./test/conftest_user.py"
        cat ./test/conftest_user.py
        python -m pytest ${deselectExpression} "$@"
      '';
    };
  };

  testAll.module = {
    stdenv = cfg.packages.multiStdenv;

    packages = with cfg.packages; [
      python_3_11_6
      python_3_12_3
      clang_20
      cmake_3_15_7
      # cmake_3_27_9
      # cmake_4_1_2 # Breaks `TestIntelCC::test_intel_oneapi_and_icpx`
      git-wrapped
      autoconf
      automake
      libtool_2
      ninja_1_10_2
      meson
      scons
      emscripten
      node
    ];

    scripts = {
      all-tests.exec = ''
        cd "$DEVENV_ROOT/conan"
        export PYTHONPATH=$PYTHONPATH:$(pwd)
        echo "PYTHONPATH: ''${PYTHONPATH@Q}"
        if [[ -f ./test/conftest_user.py ]];
        then
          rm -f ./test/conftest_user.py
        fi
        cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
        echo "./test/conftest_user.py"
        cat ./test/conftest_user.py
        python -m pytest ${deselectAllExpression} .
      '';

      functional-tests.exec = ''
        cd "$DEVENV_ROOT/conan"
        export PYTHONPATH=$PYTHONPATH:$(pwd)
        echo "PYTHONPATH: ''${PYTHONPATH@Q}"
        if [[ -f ./test/conftest_user.py ]];
        then
          rm -f ./test/conftest_user.py
        fi
        cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
        echo "./test/conftest_user.py"
        cat ./test/conftest_user.py
        python -m pytest ${deselectTestOverwriteReadOnlyFileExpression} test/functional/
      '';

      functional-cmake-toolchain-tests.exec = ''
        cd "$DEVENV_ROOT/conan"
        export PYTHONPATH=$PYTHONPATH:$(pwd)
        echo "PYTHONPATH: ''${PYTHONPATH@Q}"
        if [[ -f ./test/conftest_user.py ]];
        then
          rm -f ./test/conftest_user.py
        fi
        cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
        echo "./test/conftest_user.py"
        cat ./test/conftest_user.py
        python -m pytest ${deselectTestOverwriteReadOnlyFileExpression} test/functional/toolchains/cmake/test_cmake_toolchain.py
      '';

      single-test.exec = ''
        cd "$DEVENV_ROOT/conan"
        export PYTHONPATH=$PYTHONPATH:$(pwd)
        echo "PYTHONPATH: ''${PYTHONPATH@Q}"
        if [[ -f ./test/conftest_user.py ]];
        then
          rm -f ./test/conftest_user.py
        fi
        cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
        echo "./test/conftest_user.py"
        cat ./test/conftest_user.py
        python -m pytest ${deselectAllExpression} "$@"
      '';
    };

    android = {
      enable = true;
      ndk.enable = true;
    };
  };
}; # profiles
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
