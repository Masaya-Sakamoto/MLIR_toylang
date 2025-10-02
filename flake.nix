# flake.nix
{
  description = "A development environment for MLIR";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # LLVM/MLIRのビルドに必要なパッケージセット
        llvmPackages = pkgs.llvmPackages_latest;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            # MLIR/LLVM本体とClangコンパイラ
            llvmPackages.llvm
            llvmPackages.mlir
            llvmPackages.clang

            # ビルドツール
            pkgs.cmake
            pkgs.ninja
            pkgs.pkg-config

            # その他必要なツール
            pkgs.git
            pkgs.python3
            pkgs.gdb # デバッガ
          ];

          # 環境変数の設定 (オプション)
          # shellHook = ''
          #   export SOME_ENV_VAR="value"
          # '';
        };
      });
}