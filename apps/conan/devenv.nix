{
  config,
  ...
}:
let
  python = config.languages.python;
  cfg = config.conanDev;

  # Settings:
  deselectExpression = ''
    --deselect="test/functional/toolchains/cmake/test_shared_cmake.py::test_other_client_can_link_autotools" \
    --deselect="test/functional/toolchains/gnu/test_v2_autotools_template.py::test_autotools_lib_template" \
    --deselect="test/functional/toolchains/google/test_bazel.py::test_basic_lib" \
    --deselect="test/functional/toolchains/google/test_bazel.py::test_basic_lib_9x" \
    --deselect="test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_cmake" \
    --deselect="test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_autotools" \
    --deselect="test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_gnutoolchain" \
    --deselect="test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_sycl_meson" \
    --deselect="test/unittests/tools/env/test_env_files.py::test_env_files_sh[None]" \
  '';
  deselectAllExpression = deselectExpression + ''
    --deselect="test/functional/toolchains/intel/test_intel_cc.py::TestIntelCC::test_intel_oneapi_and_icpx" \
  '';
  deselectTestOverwriteReadOnlyFileExpression = deselectAllExpression + ''
    --deselect="test/functional/command/test_config_install.py::TestConfigInstall::test_overwrite_read_only_file" \
  '';
in
{
  profiles = {
    testIntelCc.module = {
      inherit (cfg.packages.intel-oneapi-toolkit_2026_0_1_27) stdenv;

      packages = with cfg.packages; [
        cmake_3_15_7
      ];

      scripts = {
        all-tests.exec = ''
          cd "${config.git.root}/apps/conan/conan"
          export PYTHONPATH=$PYTHONPATH:$(pwd)
          echo "PYTHONPATH: ''${PYTHONPATH@Q}" >&2
          if [[ -f ./test/conftest_user.py ]];
          then
            rm -f ./test/conftest_user.py
          fi
          cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
          echo "./test/conftest_user.py" >&2
          cat ./test/conftest_user.py >&2
          python -m pytest ${deselectExpression} .
        '';

        single-test.exec = ''
          cd "${config.git.root}/apps/conan/conan"
          export PYTHONPATH=$PYTHONPATH:$(pwd)
          echo "PYTHONPATH: ''${PYTHONPATH@Q}" >&2
          if [[ -f ./test/conftest_user.py ]];
          then
            rm -f ./test/conftest_user.py
          fi
          cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
          echo "./test/conftest_user.py" >&2
          cat ./test/conftest_user.py >&2
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
          cd "${config.git.root}/apps/conan/conan"
          export PYTHONPATH=$PYTHONPATH:$(pwd)
          echo "PYTHONPATH: ''${PYTHONPATH@Q}" >&2
          if [[ -f ./test/conftest_user.py ]];
          then
            rm -f ./test/conftest_user.py
          fi
          cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
          echo "./test/conftest_user.py" >&2
          cat ./test/conftest_user.py >&2
          python -m pytest ${deselectAllExpression} .
        '';

        functional-tests.exec = ''
          cd "${config.git.root}/apps/conan/conan"
          export PYTHONPATH=$PYTHONPATH:$(pwd)
          echo "PYTHONPATH: ''${PYTHONPATH@Q}" >&2
          if [[ -f ./test/conftest_user.py ]];
          then
            rm -f ./test/conftest_user.py
          fi
          cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
          echo "./test/conftest_user.py" >&2
          cat ./test/conftest_user.py >&2
          python -m pytest ${deselectTestOverwriteReadOnlyFileExpression} test/functional/
        '';

        functional-toolchains-tests.exec = ''
          cd "${config.git.root}/apps/conan/conan"
          export PYTHONPATH=$PYTHONPATH:$(pwd)
          echo "PYTHONPATH: ''${PYTHONPATH@Q}" >&2
          if [[ -f ./test/conftest_user.py ]];
          then
            rm -f ./test/conftest_user.py
          fi
          cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
          echo "./test/conftest_user.py" >&2
          cat ./test/conftest_user.py >&2
          python -m pytest ${deselectTestOverwriteReadOnlyFileExpression} \
            test/functional/revisions_test.py \
            test/functional/subsystems_build_test.py \
            test/functional/test_local_recipes_index.py \
            test/functional/test_profile_detect_api.py \
            test/functional/test_third_party_patch_flow.py \
            test/functional/tools_versions_test.py \
            test/functional/toolchains/
        '';

        functional-cmake-toolchain-tests.exec = ''
          cd "${config.git.root}/apps/conan/conan"
          export PYTHONPATH=$PYTHONPATH:$(pwd)
          echo "PYTHONPATH: ''${PYTHONPATH@Q}" >&2
          if [[ -f ./test/conftest_user.py ]];
          then
            rm -f ./test/conftest_user.py
          fi
          cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
          echo "./test/conftest_user.py" >&2
          cat ./test/conftest_user.py >&2
          python -m pytest ${deselectTestOverwriteReadOnlyFileExpression} test/functional/toolchains/cmake/test_cmake_toolchain.py
        '';

        single-test.exec = ''
          cd "${config.git.root}/apps/conan/conan"
          export PYTHONPATH=$PYTHONPATH:$(pwd)
          echo "PYTHONPATH: ''${PYTHONPATH@Q}" >&2
          if [[ -f ./test/conftest_user.py ]];
          then
            rm -f ./test/conftest_user.py
          fi
          cp ${cfg.packages.conftestUser}/conf/conftest_user.py ./test/conftest_user.py
          echo "./test/conftest_user.py" >&2
          cat ./test/conftest_user.py >&2
          python -m pytest ${deselectAllExpression} "$@"
        '';
      };
    };
  }; # profiles

  languages = {
    python = {
      enable = true;
      directory = "${config.git.root}/apps/conan/conan";
      uv = {
        enable = true;
        sync.enable = true;
      };
      venv = {
        enable = true;
      };
    };
  };

  scripts = {
    init-conan-submodule.exec = ''
      set -euo pipefail
      set -x
      git submodule update --init --remote
      cd "${config.git.root}/apps/conan/conan"
      git checkout nix-tests
      git remote add upstream git@github.com:conan-io/conan.git 2>/dev/null
    '';

    get-conan-submodule.exec = ''
      set -euo pipefail
      set -x
      cd "${config.git.root}/apps/conan"
      path=$(git config --file ../../.gitmodules --get submodule.conan.path)
      url=$(git config --file ../../.gitmodules --get submodule.conan.url)
      branch=$(git config --file ../../.gitmodules --get submodule.conan.branch)
      echo "Conan submodule path: ''${path@Q}"
      echo "Conan submodule url: ''${url@Q}"
      echo "Conan submodule branch: ''${branch@Q}"
    '';

    update-conan-submodule.exec = ''
      set -euo pipefail
      set -x
      cd "${config.git.root}/apps/conan/conan"
      git checkout nix-tests
      git fetch upstream
      git rebase upstream/develop2
    '';

    change-conan-submodule.exec = ''
      set -euo pipefail
      cd "${config.git.root}/apps/conan"
      path=$(git config --file ../../.gitmodules --get submodule.conan.path)
      url=$(git config --file ../../.gitmodules --get submodule.conan.url)
      if [ -z "''${1:-}" ]; then
          echo "Error: Missing required argument"
          echo "Usage: $0 <URL>"
          exit 1
      fi
      if [[ ''${1:-} != ''${url:-} ]]; then
        echo "Updating Conan submodule from ''${url@Q} to ''${1@Q}"
        git submodule set-url -- "$path" "$1"
      fi
    '';
  };

  enterShell = ''
    export VENV_PATH="$DEVENV_STATE/venv"
    if [[ ! -f conan/conans/requirements.txt ]];
    then
      git submodule update --init --remote
    fi
    ${python.uv.package}/bin/uv pip install --python "$VENV_PATH/bin/python" -r "${config.git.root}/apps/conan/conan/conans/requirements.txt"
    ${python.uv.package}/bin/uv pip install --python "$VENV_PATH/bin/python" -r "${config.git.root}/apps/conan/conan/conans/requirements_server.txt"
    ${python.uv.package}/bin/uv pip install --python "$VENV_PATH/bin/python" -r "${config.git.root}/apps/conan/conan/conans/requirements_dev.txt"
  '';
}
