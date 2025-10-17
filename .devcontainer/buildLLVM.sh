#!/bin/bash

# Build LLVM with MLIR and specific configurations
# source: https://www.youtube.com/watch?v=KYaojNbujKM&list=PLlONLmJCfHTo9WYfsoQvwjsa5ZB6hjOG5&index=2

cmake -G Ninja ../llvm \
   -DLLVM_ENABLE_PROJECTS=mlir \
   -DLLVM_BUILD_EXAMPLES=ON \
   -DLLVM_TARGETS_TO_BUILD="Native" \
   -DCMAKE_BUILD_TYPE=Release \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_ENABLE_LLD=ON \
   -DLLVM_CCACHE_BUILD=ON \
   -DLLVM_USE_SANITIZER="Address;Undefined";
   ninja;