FROM mlir-dev AS mlirdev
FROM mcr.microsoft.com/devcontainers/base:debian13
COPY --chmod=755 entrypoint.sh /

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    neovim \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN --from=mlirdev ${LLVM_INSTALL_PREFIX} ${LLVM_INSTALL_PREFIX}

WORKDIR /workspace