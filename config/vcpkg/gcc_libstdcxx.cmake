#
#  Copyright Christopher Di Bella
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
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)

set(VCPKG_INSTALL_OPTIONS "--clean-after-build")
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_FILE}")
set(VCPKG_TARGET_TRIPLET gcc_libstdcxx)

set(TRIPLE x86_64-unknown-linux-gnu)
set(TOOLCHAIN_ROOT "/usr")
set(CMAKE_C_COMPILER "${TOOLCHAIN_ROOT}/bin/gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_ROOT}/bin/g++")
set(CMAKE_CXX_COMPLIER_TARGET ${TRIPLE})

set(CMAKE_AR "${TOOLCHAIN_ROOT}/bin/ar")
set(CMAKE_RC_COMPILER "${TOOLCHAIN_ROOT}/bin/rc")
set(CMAKE_RANLIB "${TOOLCHAIN_ROOT}/bin/ranlib")

string(
  JOIN " " CMAKE_CXX_FLAGS
  -fdiagnostics-color=always
  -fstack-protector-strong
  -fvisibility=hidden
  -rtlib=compiler-rt
  -unwindlib=libunwind
  -pedantic
  -ftemplate-backtrace-limit=0
  -fuse-ld=gold
)
