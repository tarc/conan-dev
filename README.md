# Play Python

## Failing tests

- `apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py`

### Failed Tests

```text
FAILED test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_icpx - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py:66
FAILED test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_cmake - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py:95
FAILED test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_autotools - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py:106
FAILED test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_gnutoolchain - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py:119
FAILED test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_meson - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py:130
```

## References

### Docs

The reference for packaging Python applications is in the
[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/stable/), in the
[Languages and frameworks](https://nixos.org/manual/nixpkgs/stable/#chap-language-support)
chapter:

- [Python](https://nixos.org/manual/nixpkgs/stable/#python)

/tmp/tmpphh0i4zhconans/pathwithoutspaces/.conan2/p/b/app1f622d2283625/b/configure
--prefix=/ '--bindir=${prefix}/bin' '--sbindir=${prefix}/bin'
'--libdir=${prefix}/lib' '--includedir=${prefix}/include'
'--oldincludedir=${prefix}/include'

g++ -o conftest -m64 -O3
-I/tmp/tmpphh0i4zhconans/pathwithoutspaces/.conan2/p/chatf680fdfeb0a52/p/include
-I/tmp/tmpphh0i4zhconans/pathwithoutspaces/.conan2/p/hello3352325fad212/p/include
-DNDEBUG
-L/tmp/tmpphh0i4zhconans/pathwithoutspaces/.conan2/p/chatf680fdfeb0a52/p/lib
-L/tmp/tmpphh0i4zhconans/pathwithoutspaces/.conan2/p/hello3352325fad212/p/lib
-m64 conftest.cpp -lchat -lhello
