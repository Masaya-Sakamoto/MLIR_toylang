cmake_minimum_required(VERSION 3.20)
project(ToyCh1 CXX C)

# LLVM/MLIRはC++17を要求します
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# システムにインストールされたLLVMとMLIRを探します
# (Cmakeが見つけられない場合、-DLLVM_DIR=... -DMLIR_DIR=... でパスを指定する必要があります)
# find_package(LLVM REQUIRED CONFIG
#     COMPONENTS
#         Support
# )
find_package(MLIR REQUIRED CONFIG
    COMPONENTS
        Support
)

# LLVM/MLIRのインクルードパスを追加します
include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})

# コンパイル定義（-D... フラグなど）を追加します
add_compile_definitions(${LLVM_DEFINITIONS} ${MLIR_DEFINITIONS})

# プロジェクトローカルの "include" ディレクトリをインクルードパスに追加します
# これにより、#include "toy/AST.h" などが可能になります
include_directories(include)

# 実行ファイル "toyc-ch1" を定義します
# 元の add_toy_chapter の代わりとなる標準的なCMakeコマンドです
add_executable(toyc-ch1
  toyc.cpp
  parser/AST.cpp
)

# 必要なライブラリをリンクします
target_link_libraries(toyc-ch1
  PRIVATE
    # ソースコード (Lexer.h, AST.hなど) が llvm/ADT や llvm/Support を
    # 多用しているため、LLVM::Support が必要です
    # LLVM::Support

    # 元のファイルが MLIRSupport にリンクしていたため、
    # MLIR::Support をリンクします (今後の章でも必要になります)
    # MLIR::Support
)

# LLVMがRTTIなしでビルドされている場合、プロジェクト側もRTTIを無効にする必要があります
if(NOT LLVM_ENABLE_RTTI)
  set_target_properties(toyc-ch1 PROPERTIES COMPILE_FLAGS "-fno-rtti")
endif()