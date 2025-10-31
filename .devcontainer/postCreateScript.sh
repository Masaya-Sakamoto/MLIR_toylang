#!/bin/bash

# Set environment variable
source environments

# Print environment variables for verification
echo "====== postCreateScript.sh ======="
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


# Clone LLVM Project if not already present or empty
if [ ! -d "$LLVM_DIR" ] || [ -z "$(ls -A $LLVM_DIR/.git)" ]; then
    git clone $LLVM_REPO_URL -b $LLVM_CHECKOUT --depth 1 $LLVM_DIR;
    # Check if not `.git` exists and if the clone failed.
    if [ -d ! "$LLVM_DIR/.git" ]; then
        rm -rf $LLVM_DIR;
        echo "Error: Failed to clone LLVM repository.";
        exit 1;
    fi
else
    cd $LLVM_DIR;
    git fetch;
    git checkout $LLVM_CHECKOUT;
    git pull;
fi

# Build & Install LLVM if not already built
if [ ! -d "$LLVM_BUILD_DIR" ] || [ -z "$(ls -A $LLVM_BUILD_DIR)" ]; then
    mkdir -p $LLVM_BUILD_DIR;
    cd $LLVM_BUILD_DIR;
    ${LLVM_BUILD_SCRIPT}
    cd $WORKSPACE_DIR;
else
    echo "LLVM build directory already exists and is not empty. Skipping build.";
fi

# # Add LLVM tools to PATH if not already present
# if [[ ":$PATH:" != *":$WORKSPACE_DIR/llvm-project/build/bin:"* ]]; then
#     echo "export PATH=\$PATH:$WORKSPACE_DIR/llvm-project/build/bin" >> ~/.bashrc;
#     export PATH=$PATH:$WORKSPACE_DIR/llvm-project/build/bin;
# fi

# # Add LLVM libraries to LD_LIBRARY_PATH if not already present
# if [[ ":$LD_LIBRARY_PATH:" != *":$WORKSPACE_DIR/llvm-project/build/lib:"* ]]; then
#     echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$WORKSPACE_DIR/llvm-project/build/lib" >> ~/.bashrc;
#     export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$WORKSPACE_DIR/llvm-project/build/lib;
# fi

# # Add LLVM headers to CPLUS_INCLUDE_PATH if not already present
# if [[ ":$CPLUS_INCLUDE_PATH:" != *":$WORKSPACE_DIR/llvm-project/build/include:"* ]]; then
#     echo "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:$WORKSPACE_DIR/llvm-project/build/include" >> ~/.bashrc;
#     export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:$WORKSPACE_DIR/llvm-project/build/include;
# fi
