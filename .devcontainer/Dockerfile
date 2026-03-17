FROM mlir-dev:latest AS mlir-dev-base
FROM mcr.microsoft.com/devcontainers/base:debian13 AS devcontainer
COPY --chmod=755 entrypoint.sh /
COPY --from=mlir-dev-base /usr/local/llvm /usr/local/llvm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    neovim \
    ca-certificates \
    cmake \
    gdb \
    && rm -rf /var/lib/apt/lists/*

RUN cd ${LLVM_INSTALL_PREFIX} && ldconfig
ENV PATH="/usr/local/llvm/bin:${PATH}"

WORKDIR /workspace