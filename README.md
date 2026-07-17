# Play Python

## Failing tests

- `apps/conan/conan/test/functional/toolchains/cmake/test_shared_cmake.py`
- `apps/conan/conan/test/functional/toolchains/gnu/test_v2_autotools_template.py`
- `apps/conan/conan/test/functional/toolchains/google/test_bazel.py`
- `apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py`
- `apps/conan/conan/test/functional/tools/system/python_manager_test.py`
- `apps/conan/conan/test/unittests/tools/env/test_env_files.py`

### Failed Tests

```text
FAILED test/functional/toolchains/cmake/test_shared_cmake.py::test_other_client_can_link_autotools - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/cmake/test_shared_cmake.py:89
FAILED test/functional/toolchains/gnu/test_v2_autotools_template.py::test_autotools_lib_template - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/gnu/test_v2_autotools_template.py:32
FAILED test/functional/toolchains/google/test_bazel.py::test_basic_lib - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/google/test_bazel.py:87
FAILED test/functional/toolchains/google/test_bazel.py::test_basic_lib_9x - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/google/test_bazel.py:96
FAILED test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_icpx - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py:66
FAILED test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_cmake - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py:95
FAILED test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_autotools - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py:106
FAILED test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_gnutoolchain - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py:119
FAILED test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_meson - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/toolchains/intel/test_intel_cc.py:130
FAILED test/functional/tools/system/python_manager_test.py::test_build_uv_manager - Failed: /home/tarci/projects/play-python/apps/conan/conan/test/functional/tools/system/python_manager_test.py:213
FAILED test/unittests/tools/env/test_env_files.py::test_env_files_sh[None] - AssertionError: assert 'MyVar1=OldVar1!!' in 'MyVar=MyValue!!\nMyVar1=MyValue1!!\nMyVar2=OldVar2 MyValue2!!\nMyVar3=MyValue3 OldVar3 with spaces!!\nMyV...
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
