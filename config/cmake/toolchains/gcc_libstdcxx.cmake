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
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
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
    "${CMAKE_CXX_FLAGS}"
    -fdiagnostics-color=always
    -fstack-protector
    -fvisibility=hidden
    -pedantic
    -static-libgcc
    -Werror
    -Wall
    -Wattributes
    -Wcast-align
    -Wconversion
    -Wdouble-promotion
    -Wextra
    -Wformat=2
    -Wnon-virtual-dtor
    -Wnull-dereference
    -Wodr
    -Wold-style-cast
    -Woverloaded-virtual
    -Wshadow
    -Wsign-conversion
    -Wsign-promo
    -Wunused
    -Wno-cxx-attribute-extension
    -Wno-gnu-include-next
    -Wno-ignored-attributes
    -Wno-private-header
    -Wno-unused-command-line-argument
    -ftemplate-backtrace-limit=0
)
