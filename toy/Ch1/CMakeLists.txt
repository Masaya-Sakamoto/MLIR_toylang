cmake_minimum_required(VERSION 3.20)
project(ToyCh1 CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. 最初に MLIR を検索します
# これにより MLIR::Support ターゲットと、
# MLIR が依存する LLVM コンポーネントリスト (MLIR_LLVM_COMPONENTS_TO_LINK) が定義されます
find_package(MLIR REQUIRED CONFIG
    COMPONENTS
        Support
)

# 2. 次に LLVM を検索します
# ★★★ ここが最重要ポイントです ★★★
# COMPONENTS には、MLIRが必要とするもの (${MLIR_LLVM_COMPONENTS_TO_LINK}) と、
# Toy (Ch1) が直接必要とするもの (Support) の両方を含めます。
find_package(LLVM REQUIRED CONFIG
    COMPONENTS
        Support
        ${MLIR_LLVM_COMPONENTS_TO_LINK}
)

# LLVM/MLIRのインクルードパスを追加します
# (MLIR と LLVM の両方から取得します)
include_directories(${MLIR_INCLUDE_DIRS})
include_directories(${LLVM_INCLUDE_DIRS})

# コンパイル定義（-D... フラグなど）を追加します
add_compile_definitions(${MLIR_DEFINITIONS})
add_compile_definitions(${LLVM_DEFINITIONS})

# プロジェクトローカルの "include" ディレクトリをインクルードパスに追加します
include_directories(include)

# 実行ファイル "toyc-ch1" を定義します
add_executable(toyc-ch1
  toyc.cpp
  parser/AST.cpp
)

# 必要なライブラリをリンクします
target_link_libraries(toyc-ch1
  PRIVATE
    # Toyのヘッダ (AST.h, Lexer.h) が llvm/ADT/StringRef などを
    # 直接インクルードしているため、LLVM::Support が必要です。
    LLVM::Support

    # 元々 MLIRSupport にリンクしていたため、MLIR::Support が必要です。
    MLIR::Support
)

# LLVMがRTTIなしでビルドされている場合、プロジェクト側もRTTIを無効にする必要があります
if(NOT LLVM_ENABLE_RTTI)
  set_target_properties(toyc-ch1 PROPERTIES COMPILE_FLAGS "-fno-rtti")
endif()