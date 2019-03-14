#!/bin/bash
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
PROJECT_NAME=${1}
BUILD_TYPE=${2}
CODE_COVERAGE=${3}
REQUIRED_SANITIZERS=${4}
OPTIONAL_SANITIZERS=${5}
CLANG_TIDY_PATH=${6}

cd build-${BUILD_TYPE}                                               && \
conan build .. --configure                                           && \
cmake .. -D${PROJECT_NAME}_CODE_COVERAGE="${CODE_COVERAGE}"       \
   -D${PROJECT_NAME}_REQUIRED_SANITIZERS="${REQUIRED_SANITIZERS}" \
   -D${PROJECT_NAME}_OPTIONAL_SANITIZERS="${OPTIONAL_SANITIZERS}" \
   -D${PROJECT_NAME}_CLANG_TIDY_PATH="${CLANG_TIDY_PATH}"
