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

# clang-tidy options
option(CJDB_ENABLE_CLANG_TIDY
   "Determines if clang-tidy is enabled or disabled. Enabled by default."
   ON)
set(CJDB_CLANG_TIDY_PATH
   "/usr/bin/clang-tidy"
   CACHE STRING
      "Sets the path for clang-tidy. Set to \"/usr/bin/clang-tidy\" by default.")

# IWYU options
option(CJDB_ENABLE_IWYU
   "Switch determines if include-what-you-use is enabled or disabled. Enabled by default."
   ON)
set(CJDB_IWYU_PATH
   "/usr/bin/iwyu"
   CACHE STRING
      "Sets the path for IWYU. Set to \"/usr/bin/iwyu\" by default.")

# Coverage options
set(cjdb_code_coverage_options Off gcov LLVMSourceCoverage)
set(CJDB_CODE_COVERAGE "gcov"
   CACHE STRING "Enables/disables code coverage. Options are Off, GCov, and LLVMSourceCoverage.")
set_property(CACHE CJDB_CODE_COVERAGE PROPERTY STRINGS ${cjdb_code_coverage_options})

if(NOT CJDB_CODE_COVERAGE IN_LIST cjdb_code_coverage_options)
   message(FATAL_ERROR "CJDB_CODE_COVERAGE must be one of ${cjdb_code_coverage_options}.")
endif()
