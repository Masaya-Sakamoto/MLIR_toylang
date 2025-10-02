# Dockerfile
FROM nixos/nix:latest

# Nix Flakesを有効にする
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

# VS Code Serverの依存関係であるglibcとlibstdc++(gccに含まれる)をコンテナにグローバルインストールする
RUN nix profile install nixpkgs#glibc nixpkgs#gcc

# 作業ディレクトリを作成
WORKDIR /workspace

# flake.nixとflake.lockをコピーして、依存関係を先にインストールしておく
# これにより、コンテナの再ビルドが高速になります
COPY flake.nix ./
# 初回ビルド時はflake.lockがないため、COPYに失敗しないようにしています
COPY flake.lock* ./

# nix developコマンドを実行して、flake.nixに定義されたパッケージをインストール
# --command true を付けることで、シェルには入らずインストールだけ実行する
RUN nix develop --command true

# このDockerfileはDevContainer用なので、ENTRYPOINTやCMDは不要です