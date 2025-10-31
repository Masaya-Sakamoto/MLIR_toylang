cmake_minimum_required(VERSION 3.20)
project(ToyCh1 CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(LLVM REQUIRED CONFIG)
find_package(MLIR REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

# LLVMの定義とインクルードパスを追加
include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})
separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})

# プロジェクトローカルの "include" ディレクトリ
include_directories(include)

# 実行ファイルの定義
add_executable(toyc-ch1
  toyc.cpp
  parser/AST.cpp
)

# LLVM/MLIRのコンポーネントを使用してリンク
llvm_map_components_to_libnames(llvm_libs Support Core)

target_link_libraries(toyc-ch1
  PRIVATE
    ${llvm_libs}
)

# LLVMがRTTIなしの場合
if(NOT LLVM_ENABLE_RTTI)
  message(STATUS "LLVM not enabled RTTI")
  target_compile_options(toyc-ch1 PRIVATE -fno-rtti)
endif()