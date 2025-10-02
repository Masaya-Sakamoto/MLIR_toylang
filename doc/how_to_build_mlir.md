### configure phase

```shell
cmake -G Ninja ../llvm \
   -DLLVM_ENABLE_PROJECTS=mlir \
   -DLLVM_BUILD_EXAMPLES=ON \
   -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
   -DCMAKE_BUILD_TYPE=Release \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_ENABLE_LLD=ON \
   -DLLVM_CCACHE_BUILD=ON \
   -DLLVM_USE_SANITIZER="Address;Undefined" \
   -DMLIR_INCLUDE_INTEGRATION_TESTS=ON
```

### build process:

```shell
cmake --build . --target check-mlir
```

### issues: 

2025/10/2:

```shell
$ cmake --build . --target check-mlir
[4745/4746] Running the MLIR regression tests
FAIL: MLIR :: Integration/Dialect/Linalg/CPU/unpack-dynamic-inner-tile.mlir (1559 of 2878)
******************** TEST 'MLIR :: Integration/Dialect/Linalg/CPU/unpack-dynamic-inner-tile.mlir' FAILED ********************
Exit Code: 1

Command Output (stdout):
--
# RUN: at line 10
rm -f /workspaces/MLIR_toylang/llvm-project/build/tools/mlir/test/Integration/Dialect/Linalg/CPU/Output/unpack-dynamic-inner-tile.mlir.tmp && /workspaces/MLIR_toylang/llvm-project/build/bin/mlir-opt /workspaces/MLIR_toylang/llvm-project/mlir/test/Integration/Dialect/Linalg/CPU/unpack-dynamic-inner-tile.mlir -transform-interpreter -test-transform-dialect-erase-schedule --lower-vector-mask | /workspaces/MLIR_toylang/llvm-project/build/bin/mlir-opt -test-lower-to-llvm -o /workspaces/MLIR_toylang/llvm-project/build/tools/mlir/test/Integration/Dialect/Linalg/CPU/Output/unpack-dynamic-inner-tile.mlir.tmp && /workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner /workspaces/MLIR_toylang/llvm-project/build/tools/mlir/test/Integration/Dialect/Linalg/CPU/Output/unpack-dynamic-inner-tile.mlir.tmp -e main -entry-point-result=void -shared-libs=/workspaces/MLIR_toylang/llvm-project/build/lib/libmlir_runner_utils.so,/workspaces/MLIR_toylang/llvm-project/build/lib/libmlir_c_runner_utils.so | /workspaces/MLIR_toylang/llvm-project/build/bin/FileCheck /workspaces/MLIR_toylang/llvm-project/mlir/test/Integration/Dialect/Linalg/CPU/unpack-dynamic-inner-tile.mlir
# executed command: rm -f /workspaces/MLIR_toylang/llvm-project/build/tools/mlir/test/Integration/Dialect/Linalg/CPU/Output/unpack-dynamic-inner-tile.mlir.tmp
# executed command: /workspaces/MLIR_toylang/llvm-project/build/bin/mlir-opt /workspaces/MLIR_toylang/llvm-project/mlir/test/Integration/Dialect/Linalg/CPU/unpack-dynamic-inner-tile.mlir -transform-interpreter -test-transform-dialect-erase-schedule --lower-vector-mask
# executed command: /workspaces/MLIR_toylang/llvm-project/build/bin/mlir-opt -test-lower-to-llvm -o /workspaces/MLIR_toylang/llvm-project/build/tools/mlir/test/Integration/Dialect/Linalg/CPU/Output/unpack-dynamic-inner-tile.mlir.tmp
# executed command: /workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner /workspaces/MLIR_toylang/llvm-project/build/tools/mlir/test/Integration/Dialect/Linalg/CPU/Output/unpack-dynamic-inner-tile.mlir.tmp -e main -entry-point-result=void -shared-libs=/workspaces/MLIR_toylang/llvm-project/build/lib/libmlir_runner_utils.so,/workspaces/MLIR_toylang/llvm-project/build/lib/libmlir_c_runner_utils.so
# .---command stderr------------
# | ==147053==WARNING: invalid path to external symbolizer!
# | ==147053==WARNING: Failed to use and restart external symbolizer!
# | 
# | =================================================================
# | ==147053==ERROR: LeakSanitizer: detected memory leaks
# | 
# | Direct leak of 148 byte(s) in 1 object(s) allocated from:
# |     #0 0x62371ae53203  (/workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner+0x7d91203) (BuildId: 236530509492e8664198c72f7c843cf11f024b09)
# |     #1 0x719573957091  (<unknown module>)
# |     #2 0x719573957050  (<unknown module>)
# |     #3 0x62371d0c9706  (/workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner+0xa007706) (BuildId: 236530509492e8664198c72f7c843cf11f024b09)
# |     #4 0x62371d0c5285  (/workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner+0xa003285) (BuildId: 236530509492e8664198c72f7c843cf11f024b09)
# |     #5 0x62371ae8d803  (/workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner+0x7dcb803) (BuildId: 236530509492e8664198c72f7c843cf11f024b09)
# |     #6 0x71957433dca7  (/lib/x86_64-linux-gnu/libc.so.6+0x29ca7) (BuildId: def5460e3cee00bfee25b429c97bcc4853e5b3a8)
# | 
# | SUMMARY: AddressSanitizer: 148 byte(s) leaked in 1 allocation(s).
# `-----------------------------
# error: command failed with exit status: 1
# executed command: /workspaces/MLIR_toylang/llvm-project/build/bin/FileCheck /workspaces/MLIR_toylang/llvm-project/mlir/test/Integration/Dialect/Linalg/CPU/unpack-dynamic-inner-tile.mlir

--

********************
FAIL: MLIR :: Integration/Dialect/SparseTensor/CPU/reshape_dot.mlir (1574 of 2878)
******************** TEST 'MLIR :: Integration/Dialect/SparseTensor/CPU/reshape_dot.mlir' FAILED ********************
Exit Code: 1

Command Output (stdout):
--
# RUN: at line 21
/workspaces/MLIR_toylang/llvm-project/build/bin/mlir-opt /workspaces/MLIR_toylang/llvm-project/mlir/test/Integration/Dialect/SparseTensor/CPU/reshape_dot.mlir --sparsifier="enable-runtime-library=true" |  /workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner -e main -entry-point-result=void -shared-libs=/workspaces/MLIR_toylang/llvm-project/build/lib/libmlir_c_runner_utils.so,/workspaces/MLIR_toylang/llvm-project/build/lib/libmlir_runner_utils.so | /workspaces/MLIR_toylang/llvm-project/build/bin/FileCheck /workspaces/MLIR_toylang/llvm-project/mlir/test/Integration/Dialect/SparseTensor/CPU/reshape_dot.mlir
# executed command: /workspaces/MLIR_toylang/llvm-project/build/bin/mlir-opt /workspaces/MLIR_toylang/llvm-project/mlir/test/Integration/Dialect/SparseTensor/CPU/reshape_dot.mlir --sparsifier=enable-runtime-library=true
# executed command: /workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner -e main -entry-point-result=void -shared-libs=/workspaces/MLIR_toylang/llvm-project/build/lib/libmlir_c_runner_utils.so,/workspaces/MLIR_toylang/llvm-project/build/lib/libmlir_runner_utils.so
# .---command stderr------------
# | ==147881==WARNING: invalid path to external symbolizer!
# | ==147881==WARNING: Failed to use and restart external symbolizer!
# | 
# | =================================================================
# | ==147881==ERROR: LeakSanitizer: detected memory leaks
# | 
# | Direct leak of 208 byte(s) in 1 object(s) allocated from:
# |     #0 0x5c250f03b203  (/workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner+0x7d91203) (BuildId: 236530509492e8664198c72f7c843cf11f024b09)
# |     #1 0x7a61e79d67e1  (<unknown module>)
# |     #2 0x7a61e79d7449  (<unknown module>)
# | 
# | Direct leak of 184 byte(s) in 1 object(s) allocated from:
# |     #0 0x5c250f03b203  (/workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner+0x7d91203) (BuildId: 236530509492e8664198c72f7c843cf11f024b09)
# |     #1 0x7a61e79d6634  (<unknown module>)
# |     #2 0x7a61e79d7449  (<unknown module>)
# | 
# | Direct leak of 184 byte(s) in 1 object(s) allocated from:
# |     #0 0x5c250f03b203  (/workspaces/MLIR_toylang/llvm-project/build/bin/mlir-runner+0x7d91203) (BuildId: 236530509492e8664198c72f7c843cf11f024b09)
# |     #1 0x7a61e79d5cb5  (<unknown module>)
# |     #2 0x7a61e79d73b0  (<unknown module>)
# | 
# | SUMMARY: AddressSanitizer: 576 byte(s) leaked in 3 allocation(s).
# `-----------------------------
# error: command failed with exit status: 1
# executed command: /workspaces/MLIR_toylang/llvm-project/build/bin/FileCheck /workspaces/MLIR_toylang/llvm-project/mlir/test/Integration/Dialect/SparseTensor/CPU/reshape_dot.mlir

--

********************
********************
Failed Tests (2):
  MLIR :: Integration/Dialect/Linalg/CPU/unpack-dynamic-inner-tile.mlir
  MLIR :: Integration/Dialect/SparseTensor/CPU/reshape_dot.mlir


Testing Time: 160.97s

Total Discovered Tests: 3358
  Skipped          :    3 (0.09%)
  Unsupported      :  233 (6.94%)
  Passed           : 3119 (92.88%)
  Expectedly Failed:    1 (0.03%)
  Failed           :    2 (0.06%)
FAILED: tools/mlir/test/CMakeFiles/check-mlir /workspaces/MLIR_toylang/llvm-project/build/tools/mlir/test/CMakeFiles/check-mlir 
cd /workspaces/MLIR_toylang/llvm-project/build/tools/mlir/test && /usr/bin/python3 /workspaces/MLIR_toylang/llvm-project/build/./bin/llvm-lit -sv /workspaces/MLIR_toylang/llvm-project/build/tools/mlir/test
ninja: build stopped: subcommand failed.
```