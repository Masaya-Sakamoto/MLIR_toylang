#!/bin/bash

source $WORKSPACE_DIR/environments

# Print environment variables for verification
echo "========== buildLLVM.sh =========="
echo "WORKSPACE_DIR: $WORKSPACE_DIR"
echo "DEVCONTAINER_DIR: $DEVCONTAINER_DIR"
echo "LLVM_DIR: $LLVM_DIR"
echo "LLVM_BUILD_DIR: $LLVM_BUILD_DIR"
echo "LLVM_BUILD_SCRIPT: $LLVM_BUILD_SCRIPT"
echo "LLVM_REPO_URL: $LLVM_REPO_URL"
echo "LLVM_VERSION: $LLVM_VERSION"
echo "LLVM_CHECKOUT: $LLVM_CHECKOUT"
echo "install prefix: $CUSTOM_LLVM_INSTALL_PREFIX"
echo "=================================="

echo "Building LLVM version: $LLVM_VERSION"

# Build LLVM with MLIR and specific configurations
# source: https://www.youtube.com/watch?v=KYaojNbujKM&list=PLlONLmJCfHTo9WYfsoQvwjsa5ZB6hjOG5&index=2

cmake -G Ninja ../llvm \
   -DCMAKE_INSTALL_PREFIX=$CUSTOM_LLVM_INSTALL_PREFIX \
   -DLLVM_PARALLEL_COMPILE_JOBS=$BUILD_NUM_JOBS \
   -DLLVM_PARALLEL_LINK_JOBS=1 \
   -DLLVM_BUILD_EXAMPLES=ON \
   -DLLVM_TARGETS_TO_BUILD="X86;AMDGPU;BPF;NVPTX;RISCV;WebAssembly;AArch64;ARM;" \
   -DCMAKE_BUILD_TYPE=Release \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DLLVM_CCACHE_BUILD=ON \
   -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
   -DLLVM_ENABLE_PROJECTS='clang;lldb;lld;mlir;clang-tools-extra;compiler-rt' \
   -DCMAKE_C_COMPILER=clang \
   -DCMAKE_CXX_COMPILER=clang++ \
   -DLLVM_ENABLE_LLD=ON

# Check cmake configuration result and exit on failure
if [ $? -ne 0 ]; then
    echo "CMake configuration failed. Cleaning up build directory..."
    cd ..
    rm -rf build
    exit 1
fi

# Build and test LLVM
cmake --build .
cmake --build . --target check-mlir

# Install LLVM
sudo cmake -DCMAKE_INSTALL_PREFIX=$CUSTOM_LLVM_INSTALL_PREFIX -P cmake_install.cmake
