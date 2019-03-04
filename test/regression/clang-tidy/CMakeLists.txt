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

# Tests for checks that are disabled
add_basic_project_test("${PROJECT_DIRECTORY_PREFIX}" -cert-dcl21-cpp)
add_basic_project_test("${PROJECT_DIRECTORY_PREFIX}" -cert-dcl59-cpp)
add_basic_project_test("${PROJECT_DIRECTORY_PREFIX}" -google-build-namespaces)
add_basic_project_test("${PROJECT_DIRECTORY_PREFIX}" -google-build-using-namespace)
add_basic_project_test("${PROJECT_DIRECTORY_PREFIX}" -google-runtime-int)
add_basic_project_test("${PROJECT_DIRECTORY_PREFIX}" -google-runtime-references)
add_basic_project_test("${PROJECT_DIRECTORY_PREFIX}" -readability-named-parameter)
add_basic_project_test("${PROJECT_DIRECTORY_PREFIX}" -readability-uppercase-literal-suffix)
