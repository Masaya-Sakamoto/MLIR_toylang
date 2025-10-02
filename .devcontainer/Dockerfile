FROM mcr.microsoft.com/devcontainers/base:dev-debian13

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install basic development tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        curl \
        neovim \
        python3 \
        ca-certificates \
        cmake \
        ninja-build \
        clang \
        lld \
        libclang-rt-dev \
        ccache \
        iputils-ping \
        gh \
        && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace