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
include(add_basic_project_implementation)

# \brief Builds an executable.
# \param prefix A string that prefixes the filename that will be removed from its path. Everything
#               that prefixes the prefix will _also_ be removed.
# \param file The name of the source file.
#
function(add_${PROJECT_NAME}_executable prefix file)
   add_basic_project_executable(prefix file)
endfunction()

# \brief Builds a library.
# \param prefix A string that prefixes the filename that will be removed from its path. Everything
#               that prefixes the prefix will _also_ be removed.
# \param file The name of the source file.
#
function(add_${PROJECT_NAME}_library prefix file)
   add_basic_project_library(prefix file)
endfunction()



# \brief Builds a test executable and creates a test target (for CTest).
# \param prefix A string that prefixes the filename that will be removed from its path. Everything
#               that prefixes the prefix will _also_ be removed.
# \param file The name of the source file.
#
function(add_${PROJECT_NAME}_test prefix file)
   add_basic_project_test(prefix file)
endfunction()

# \brief Builds a benchmark executable and creates a test target (for CTest).
# \param prefix A string that prefixes the filename that will be removed from its path. Everything
#               that prefixes the prefix will _also_ be removed.
# \param file The name of the source file.
#
function(add_${PROJECT_NAME}_benchmark prefix file)
   add_basic_project_benchmark(prefix file)
endfunction()
