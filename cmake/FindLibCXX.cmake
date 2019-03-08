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
include(FindPackageHandleStandardArgs)
include(CheckCXXCompilerFlag)
include(CMakePushCheckState)

add_library(${PROJECT_NAME}::LibCXX INTERFACE IMPORTED)
set(${PROJECT_NAME}_LIBCXX_FOUND ON)

if(TARGET ${PROJECT_NAME}::LIBCXX_${${PROJECT_NAME}_LLVM_VERSION} OR NOT ${PROJECT_NAME}_ENABLE_LIBCXX)
   return()
endif()

unset(LIBCXX_INCLUDE_DIR CACHE)
find_path(LIBCXX_INCLUDE_DIR
   NAMES "vector"
   PATHS "${${PROJECT_NAME}_LIBCXX_ROOT_DIR}"
   PATH_SUFFIXES "include/c++/v1"
   NO_DEFAULT_PATH)
find_package_handle_standard_args(LibCXX REQUIRED_VARS LIBCXX_INCLUDE_DIR)

find_path(LIBCXXABI_DIR "${${PROJECT_NAME}_LIBCXXABI_ROOT_DIR}/lib")

set_target_properties(
   ${PROJECT_NAME}::LIBCXX_${${PROJECT_NAME}_LLVM_VERSION}
   PROPERTIES
      INTERFACE_COMPILE_OPTIONS "-stdlib=libc++ -nostdinc++ -cxx-isystem ${LIBCXX_INCLUDE_DIR}"
      INTERFACE_LINK_LIBRARIES "-L ${LIBCXXABI_DIR} -Wl,-rpath,${LIBCXXABI_DIR} -lc++abi")
set_property(TARGET ${PROJECT_NAME}::LIBCXX APPEND PROPERTY
   INTERFACE_LINK_LIBRARIES ${PROJECT_NAME}::LIBCXX_${${PROJECT_NAME}_LLVM_VERSION})

find_package_handle_standard_args(libcxx REQUIRED_VARS ${PROJECT_NAME}_LIBCXX_FOUND)
