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
PROFILE=${2}
BUILD_TYPE=${3}
CODE_COVERAGE=${4}
REQUIRED_SANITIZERS=${5}
OPTIONAL_SANITIZERS=${6}
CLANG_TIDY_PATH=${7}

if [[ ${PROJECT_NAME} == "" ]]
then
   echo "First parameter must be the project's name."
   exit 1
fi

if [[ ${PROFILE} == "" ]]
then
   echo "Second parameter must be the project's profile."
   exit 2
fi

if [[ ${BUILD_TYPE} != "Debug"          && \
      ${BUILD_TYPE} != "Release"        && \
      ${BUILD_TYPE} != "RelWithDebInfo" && \
      ${BUILD_TYPE} != "MinSizeRel" ]]
then
   echo "Third parameter must be one of:"
   echo "   Debug"
   echo "   Release"
   echo "   RelWithDebInfo"
   echo "   MinSizeRel"
   exit 3
fi

if [[ ${CODE_COVERAGE} != "Off"  && \
      ${CODE_COVERAGE} != "gcov" && \
      ${CODE_COVERAGE} != "LLVMSourceCoverage" ]]
then
   echo "Fourth parameter must be one of:"
   echo "   Off"
   echo "   gcov"
   echo "   LLVMSourceCoverage"
   exit 4
fi

# bash config/hooks/clang-format.sh                                 && \
bash config/scripts/pre-install.sh ${BUILD_TYPE}                  && \
bash config/scripts/conan-install.sh ${BUILD_TYPE} ${PROFILE}     && \
bash config/scripts/build-configure.sh ${PROJECT_NAME}        \
                                       ${BUILD_TYPE}          \
                                       ${CODE_COVERAGE}       \
                                       ${REQUIRED_SANITIZERS} \
                                       ${OPTIONAL_SANITIZERS} \
                                       ${CLANG_TIDY_PATH}         && \
bash config/scripts/build.sh ${BUILD_TYPE}                        && \
bash config/scripts/test.sh ${BUILD_TYPE}
