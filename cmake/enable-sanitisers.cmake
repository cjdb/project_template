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

# Check that AddressSanitizer doesn't clash with any of:
#     ThreadSanitizer
#     MemorySanitizer
#     SafeStack
#     ShadowCallStack
#
function(flag_incompatible_sanitizers required optional)
   set(joined "${required}")
   list(APPEND joined "${optional}")
   list(FIND joined "AddressSanitizer" asan_result)

   if(asan_result GREATER -1)
      list(FIND joined "ThreadSanitizer" tsan_result)
      if(tsan_result GREATER -1)
         message(SEND_ERROR "Cannot enable both AddressSanitizer and ThreadSanitizer.")
      endif()

      list(FIND joined "MemorySanitizer" msan_result)
      list(FIND joined "MemorySanitizerWithOrigins" msan_origin_result)
      if(msan_result GREATER -1 OR msan_origin_result GREATER -1)
         message(SEND_ERROR "Cannot enable both AddressSanitizer and MemorySanitizer.")
      endif()

      list(FIND joined "SafeStack" safe_stack_result)
      if(safe_stack_result GREATER -1)
         message(SEND_ERROR "Cannot enable both AddressSanitizer and SafeStack.")
      endif()

      list(FIND joined "ShadowCallStack" shadow_call_stack_result)
      if (shadow_call_stack_result GREATER -1)
         message(SEND_ERROR "Cannot enable both AddressSanitizer and ShadowCallStack.")
      endif()
   endif()
endfunction()

flag_incompatible_sanitizers(
   "${${PROJECT_NAME}_REQUIRED_SANITIZERS}"
   "${${PROJECT_NAME}_OPTIONAL_SANITIZERS}")

find_package(Sanitizer
   REQUIRED COMPONENTS ${${PROJECT_NAME}_REQUIRED_SANITIZERS}
   OPTIONAL_COMPONENTS ${${PROJECT_NAME}_OPTIONAL_SANITIZERS})
