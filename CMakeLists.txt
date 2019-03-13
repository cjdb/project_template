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

project("basic_project" CXX)
add_library(${PROJECT_NAME} INTERFACE)

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/macros.cmake")
include(CMakeDependentOption)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# clang-tidy options
option(${PROJECT_NAME}_ENABLE_CLANG_TIDY "Builds with clang-tidy, if available. Defaults to ON." ON)

set(${PROJECT_NAME}_CLANG_TIDY_PATH "/usr/bin/clang-tidy" CACHE
   STRING "Sets the path for clang-tidy. Defaults to \"/usr/bin/clang-tidy\".")

# IWYU options
option(${PROJECT_NAME}_ENABLE_IWYU "Builds with IWYU, if available. Defaults to ON." ON)

set(${PROJECT_NAME}_IWYU_PATH "/usr/bin/iwyu" CACHE
   STRING "Sets the path for IWYU. Defaults to \"/usr/bin/iwyu\".")

# Options for sanitizers
set(valid_sanitizer_options
   ""
   AddressSanitizer           # see https://clang.llvm.org/docs/AddressSanitizer.html
   UndefinedBehaviorSanitizer # see https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
   ThreadSanitizer            # see https://clang.llvm.org/docs/ThreadSanitizer.html
   MemorySanitizer            # see https://clang.llvm.org/docs/MemorySanitizer.html
   MemorySanitizerWithOrigins # see https://clang.llvm.org/docs/MemorySanitizer.html#origin-tracking
   ControlFlowIntegrity       # see https://clang.llvm.org/docs/ControlFlowIntegrity.html
   DataFlowSanitizer          # see https://clang.llvm.org/docs/DataFlowSanitizer.html
   ShadowCallStack            # see https://clang.llvm.org/docs/ShadowCallStack.html
   SafeStack                  # see https://clang.llvm.org/docs/SafeStack.html
)
basic_project_enumerated_option(
   OPTION_NAME ${PROJECT_NAME}_REQUIRED_SANITIZERS
   DESCRIPTION
      "Enables a list of sanitizers in Debug mode."
      "The list of sanitizers must be available to the compiler."
      "ControlFlowIntegrity is not enabled in Debug mode: it is only enabled in Release modes."
   TYPE STRING LIST
   EXPECTS ${valid_sanitizer_options}
   DEFAULT_VALUE UndefinedBehaviorSanitizer)

basic_project_enumerated_option(
   OPTION_NAME ${PROJECT_NAME}_OPTIONAL_SANITIZERS
   DESCRIPTION
      "Enables a list of sanitizers in Debug mode."
      "Sanitizers not available to the compiler are ignored."
      "ControlFlowIntegrity is not enabled in Debug mode: it is only enabled in Release modes."
   TYPE STRING LIST
   EXPECTS ${valid_sanitizer_options}
   DEFAULT_VALUE AddressSanitizer ControlFlowIntegrity)

option(${PROJECT_NAME}_SANITIZE_RELEASE "Turns on sanitizers in Release modes. Defaults to OFF." OFF)

# Coverage options
basic_project_enumerated_option(
   OPTION_NAME ${PROJECT_NAME}_CODE_COVERAGE
   DESCRIPTION "Enables/disables code coverage. Options are Off, GCov, and LLVMSourceCoverage."
   TYPE STRING LIST
   EXPECTS Off gcov LLVMSourceCoverage
   DEFAULT_VALUE gcov)

include("${CMAKE_BINARY_DIR}/conan_paths.cmake" REQUIRED)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Project configuration
include(enable-sanitisers)
include(enable-clang-tidy)
include(enable-iwyu)
include(add_build_targets)

find_package(CodeCoverage REQUIRED)

enable_testing()
include(CTest)

set(PROJECT_DIRECTORY_PREFIX "${PROJECT_NAME}")
add_subdirectory(source)
add_subdirectory(test)
