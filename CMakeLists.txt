#
#  Copyright 2019 Christopher Di Bella
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
cmake_minimum_required(VERSION 3.13)

set(CJDB_PROJECT_NAME "PROJECT_NAME")

project(${CJDB_PROJECT_NAME} CXX)
add_library(${CJDB_PROJECT_NAME} INTERFACE)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON)

include("${CMAKE_BINARY_DIR}/conan_paths.cmake" REQUIRED)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(options)
include(enable-sanitisers)
include(enable-clang-tidy)
include(build)

find_package(CodeCoverage REQUIRED)

enable_testing()
include(CTest)

set(PROJECT_DIRECTORY_PREFIX "${CJDB_PROJECT_NAME}")
add_subdirectory(source)
add_subdirectory(test)
