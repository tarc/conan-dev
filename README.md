# Conan development environment (devenv)

## Profile: `testIntelCc`

```sh
cd apps/conan
single-test test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC -s
```

## Profile: `testAll`

```sh
cd apps/conan
all-tests
```

## References

### Docs

The reference for packaging Python applications is in the
[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/stable/), in the
[Languages and frameworks](https://nixos.org/manual/nixpkgs/stable/#chap-language-support)
chapter:

- [Python](https://nixos.org/manual/nixpkgs/stable/#python)
