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
find_package(Boost REQUIRED)
find_package(Clang REQUIRED)
find_package(CodeCoverage REQUIRED)
# find_package(Concepts) FEATURE: Uncomment if you want to write C++20 concepts with GCC 6-9
# find_package(doctest REQUIRED) FIXME
find_package(range-v3 REQUIRED)

# System packages, don't disable
find_package(ClangTidy REQUIRED)

include(basic_project-sanitizers)
include(basic_project-iwyu)
