#!/bin/bash

WORKSPACE_DIR=$(pwd)

# Clone LLVM Project if not already present or empty
if [ ! -d "llvm-project" ] || [ -z "$(ls -A llvm-project)" ]; then
    git clone https://github.com/llvm/llvm-project.git -b release/21.x --depth 1;
fi

# Build LLVM if not already built
if [ ! -d "llvm-project/build" ] || [ -z "$(ls -A llvm-project/build)" ]; then
    mkdir -p llvm-project/build;
    cd llvm-project/build;
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
   cd ../..;
fi

# Add LLVM tools to PATH if not already present
if [[ ":$PATH:" != *":$WORKSPACE_DIR/llvm-project/build/bin:"* ]]; then
    echo "export PATH=\$PATH:$WORKSPACE_DIR/llvm-project/build/bin" >> ~/.bashrc;
    export PATH=$PATH:$WORKSPACE_DIR/llvm-project/build/bin;
fi

# Add LLVM libraries to LD_LIBRARY_PATH if not already present
if [[ ":$LD_LIBRARY_PATH:" != *":$WORKSPACE_DIR/llvm-project/build/lib:"* ]]; then
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$WORKSPACE_DIR/llvm-project/build/lib" >> ~/.bashrc;
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$WORKSPACE_DIR/llvm-project/build/lib;
fi

# Add LLVM headers to CPLUS_INCLUDE_PATH if not already present
if [[ ":$CPLUS_INCLUDE_PATH:" != *":$WORKSPACE_DIR/llvm-project/build/include:"* ]]; then
    echo "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$WORKSPACE_DIR/llvm-project/build/include" >> ~/.bashrc;
    export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:$WORKSPACE_DIR/llvm-project/build/include;
fi
