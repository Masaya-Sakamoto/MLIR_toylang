#!/bin/bash

WORKSPACE_DIR=$(pwd)
DEVCONTAINER_DIR="$WORKSPACE_DIR/.devcontainer"
LLVM_DIR='~/llvm-project'
LLVM_BUILD_DIR="$LLVM_DIR/build"
LLVM_BUILD_SCRIPT="$DEVCONTAINER_DIR/buildLLVM.sh"
LLVM_REPO_URL="https://github.com/llvm/llvm-project.git"
LLVM_CHECKOUT="release/21.x"

# Clone LLVM Project if not already present or empty
if [ ! -d "$LLVM_DIR" ] || [ -z "$(ls -A $LLVM_DIR)" ]; then
    git clone $LLVM_REPO_URL -b $LLVM_CHECKOUT --depth 1;
else
    git fetch;
    git checkout $LLVM_CHECKOUT;
    git pull;
fi

# Build LLVM if not already built
if [ ! -d "$LLVM_BUILD_DIR" ] || [ -z "$(ls -A $LLVM_BUILD_DIR)" ]; then
    mkdir -p $LLVM_BUILD_DIR;
    cd $LLVM_BUILD_DIR;
    ${LLVM_BUILD_SCRIPT};
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
