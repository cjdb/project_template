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

# \brief Provides build settings common for all targets.
# \param target The target to apply the target to.
#
function(add_impl target libraries)
   # Warnings
   target_compile_options("${target}" PRIVATE
      $<$<CXX_COMPILER_ID:MSVC>:
         /permissive-
         /analyze
         /W4
         /w14242 # 'identfier': conversion from 'type1' to 'type1', possible loss of data
         /w14254 # 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
         /w14263 # 'function': member function does not override any base class virtual member function
         /w14265 # 'classname': class has virtual functions, but destructor is not virtual instances of this class may not be destructed correctly
         /w14287 # 'operator': unsigned/negative constant mismatch
         /we4289 # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside the for-loop scope
         /w14296 # 'operator': expression is always 'boolean_value'
         /w14311 # 'variable': pointer truncation from 'type1' to 'type2'
         /w14545 # expression before comma evaluates to a function which is missing an argument list
         /w14546 # function call before comma missing argument list
         /w14547 # 'operator': operator before comma has no effect; expected operator with side-effect
         /w14549 # 'operator': operator before comma has no effect; did you intend 'operator'?
         /w14555 # expression has no effect; expected expression with side-effect
         /w14619 # pragma warning: there is no warning number 'number'
         /w14640 # Enable warning on thread un-safe static member initialization
         /w14826 # Conversion from 'type1' to 'type_2' is sign-extended. This may cause unexpected runtime behavior.
         /w14905 # wide string literal cast to 'LPSTR'
         /w14906 # string literal cast to 'LPWSTR'
         /w14928 # illegal copy-initialization; more than one user-defined conversion has been implicitly applied
         >
      $<$<CXX_COMPILER_ID:GNU>:
         -Wall
         -Wextra
         -Wcast-align
         -Wconversion
         -Wdouble-promotion
         -Wnon-virtual-dtor
         -Wold-style-cast
         -Woverloaded-virtual
         -Wpedantic
         -Wshadow
         -Wsign-conversion
         -Wsign-promo
         -Wunused
         -Wformat=2
         -Wodr
         -Wno-attributes
         $<$<NOT:$<VERSION_LESS:${CMAKE_CXX_COMPILER_VERSION},6>>:
            -Wnull-dereference>
         >
      $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>:
         -Weverything
         -Wno-unused-command-line-argument
         -Wno-missing-prototypes
         -Wno-c++98-compat
         -Wno-c++98-compat-pedantic
         -Wno-padded>)
   # Warnings as errors
   target_compile_options("${target}" PRIVATE
      $<$<CXX_COMPILER_ID:MSVC>:
         /WX>
      $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>:
         -Werror>)
   # Strict C++
   target_compile_options("${target}" PRIVATE
      $<$<CXX_COMPILER_ID:MSVC>:
            /permissive-
      >
      $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>:
         -pedantic
      >
   )
   # Compiler features
   target_compile_options("${target}" PRIVATE
      $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>:
         -fdiagnostics-color=always
         -fvisibility=default
         $<$<CONFIG:Debug>:
            -fstack-protector-all>
      >)

   target_include_directories("${target}" PUBLIC "${PROJECT_SOURCE_DIR}/include")

   foreach(i ${libraries})
      message(STATUS "Linking ${i} with ${target}")
      target_link_libraries("${target}" PUBLIC ${i})
   endforeach()

   target_link_libraries("${target}" PRIVATE
      $<$<BOOL:${CJDB_CODE_COVERAGE}>:CodeCoverage::all>
      $<$<OR:$<CONFIG:Debug>,$<BOOL:${${PROJECT_NAME}_SANITIZE_RELEASE}>>:Sanitizer::all>
      $<$<AND:$<NOT:$<CONFIG:Debug>>,$<BOOL:${Sanitizer_ControlFlowIntegrity_FOUND}>>:Sanitizer::ControlFlowIntegrity>)

   target_compile_options(
      "${target}" PRIVATE
      $<$<AND:$<NOT:$<CONFIG:Debug>>,$<BOOL:${Sanitizer_ControlFlowIntegrity_FOUND}>>:
         -fvisibility=default>
      $<$<OR:$<CONFIG:Debug>,$<BOOL:${${PROJECT_NAME}_SANITIZE_RELEASE}>>:
         $<$<OR:$<BOOL:${Sanitizer_Memory_FOUND}>,$<BOOL:${Sanitizer_MemoryWithOrigins_FOUND}>>:
            -fno-omit-frame-pointer -fno-optimize-sibling-calls
            $<$<BOOL:${Sanitizer_MemoryWithOrigins_FOUND}>:
               -fsanitize-memory-track-origins=2>>>)

   add_compile_options(-DRANGES_DEEP_STL_INTEGRATION=1)
endfunction()

# \brief Produces a target name for compiling a translation unit.
# \param prefix A string that prefixes the filename that will be removed from its path. Everything
#               that prefixes the prefix will _also_ be removed.
# \param file The name of the source file.
# \returns A sans-prefix path that is dot separated.
#
function(name_target prefix file)
   get_filename_component(sublibrary "${file}.cpp" ABSOLUTE)
   string(REGEX REPLACE ".cpp$" "" sublibrary "${sublibrary}")
   string(REPLACE "/" "." sublibrary "${sublibrary}")
   string(REGEX REPLACE "^.*${prefix}[.]" "" sublibrary "${sublibrary}")
   set(target "${sublibrary}" PARENT_SCOPE)
endfunction()

# \see add_${PROJECT_NAME}_executable
#
function(add_basic_project_executable prefix file)
   name_target("${prefix}" "${file}")
   add_executable("${target}" "${file}.cpp")

   set(libraries "")
   if(${ARGC} GREATER 2)
      set(libraries ${ARGV})
      list(SUBLIST libraries 2 ${ARGC} libraries)
   endif()
   add_impl("${target}" "${libraries}")
endfunction()

# \see add_${PROJECT_NAME}_library
#
function(add_basic_project_library prefix file)
   name_target("${prefix}" "${file}")
   add_library("${target}" "${file}.cpp")

   set(libraries "")
   if(${ARGC} GREATER 2)
      set(libraries ${ARGV})
      list(SUBLIST libraries 2 ${ARGC} libraries)
   endif()
   add_impl("${target}" "${libraries}")
endfunction()

# \see add_${PROJECT_NAME}_test
#
function(add_basic_project_test prefix file)
   name_target("${prefix}" "${file}")
   name_target("${prefix}" "${file}")
   add_executable("${target}" "${file}.cpp")

   set(libraries "")
   if(${ARGC} GREATER 2)
      set(libraries ${ARGV})
      list(SUBLIST libraries 2 ${ARGC} libraries)
   endif()
   add_impl("${target}" "${libraries}")

   add_test("test.${target}" "${target}")
endfunction()

# \see add_${PROJECT_NAME}_benchmark
#
function(add_basic_project_benchmark prefix file)
   build_executable(${ARGV})
   name_target("${prefix}" "${file}")
   target_link_libraries("${target}" PRIVATE benchmark::benchmark)
   add_test("benchmark.${target}" "${target}")
endfunction()
