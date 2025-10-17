#!/bin/bash

# get llvm version from input arguments
# example: ./buildLLVM.sh -llvm_version 21.x
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -llvm_version)
        LLVM_VERSION="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        shift # past argument
        ;;
    esac
done

echo "Building LLVM version: $LLVM_VERSION"

# Build LLVM with MLIR and specific configurations
# source: https://www.youtube.com/watch?v=KYaojNbujKM&list=PLlONLmJCfHTo9WYfsoQvwjsa5ZB6hjOG5&index=2

CUSTOM_LLVM_INSTALL_PREFIX="/usr/local/llvm-$LLVM_VERSION"

cmake -G Ninja ../llvm \
   -DCMAKE_INSTALL_PREFIX=$CUSTOM_LLVM_INSTALL_PREFIX \
   -DLLVM_PARALLES_COMPILE_JOBS=4 \
   -DLLVM_PARALLEL_LINK_JOBS=1 \
   -DLLVM_BUILD_EXAMPLES=ON \
   -DLLVM_TARGETS_TO_BUILD="x86_64" \
   -DCMAKE_BUILD_TYPE=Release \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DLLVM_CCACHE_BUILD=ON \
   -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
   -DLLVM_ENABLE_PROJECTS='clang;lldb;lld;mlir;clang-tools-extra;compiler-rt' \
   -DCMAKE_C_COMPILER=clang \
   -DCMAKE_CXX_COMPILER=clang++ \
   -DLLVM_ENABLE_LLD=ON

cmake --build .
cmake --build . --target check-mlir
sudo cmake -DCMAKE_INSTALL_PREFIX=$CUSTOM_LLVM_INSTALL_PREFIX -P cmake_install.cmake
