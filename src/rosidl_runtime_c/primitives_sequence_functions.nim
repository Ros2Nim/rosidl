##  Copyright 2015 Open Source Robotics Foundation, Inc.
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

import
  ./primitives_sequence, ./visibility_control

##
##  \def ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)
##
##  \brief Allocate the memory for the sequence.
##
##  Calling the function with an already allocated sequence will leak the
##  previously allocated memory.
##
##  param sequence a pointer to a sequence struct
##  param size the number of items to allocate in the sequence, both sequence
##    fields `size` and `capacity` are set to this parameter
##  return true if successful, false if the passed sequence pointer is null
##    or the memory allocation failed
##

##
##  \def ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_FINI(STRUCT_NAME)
##
##  \brief Deallocate the memory of the sequence.
##
##  Calling the function with an already deallocated sequence is a no-op.
##
##  param sequence a pointer to a sequence struct
##

##
##  \def ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)
##
##  \brief Check for sequence equality.
##
##  param lhs a pointer to a sequence struct
##  param rhs a pointer to another sequence struct
##

##
##  \def ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)
##
##  \brief Copy the sequence.
##
##  param input a pointer to the sequence to copy from
##  param output a pointer to an initialized sequence to copy to
##  return true if successful, false if either pointer is null or memory
##    allocation fails.
##

##
##  \def ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_FUNCTIONS(STRUCT_NAME)
##
##  \brief See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME),
##  #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_FINI(STRUCT_NAME),
##  #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME), and
##  #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME).
##


proc rosidl_runtime_c_float_sequence_init*(
    sequence: ptr rosidl_runtime_c_float_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__float__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##
                              ##  \defgroup primitives_sequence_functions__basic_types Sequence functions for all basic types.
                              ##
                              ## @{
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_float_sequence_fini*(
    sequence: ptr rosidl_runtime_c_float_sequence) {.
    importc: "rosidl_runtime_c__float__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_float_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_float_sequence;
    rhs: ptr rosidl_runtime_c_float_sequence): bool {.
    importc: "rosidl_runtime_c__float__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_float_sequence_copy*(
    input: ptr rosidl_runtime_c_float_sequence;
    output: ptr rosidl_runtime_c_float_sequence): bool {.
    importc: "rosidl_runtime_c__float__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_double_sequence_init*(
    sequence: ptr rosidl_runtime_c_double_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__double__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_double_sequence_fini*(
    sequence: ptr rosidl_runtime_c_double_sequence) {.
    importc: "rosidl_runtime_c__double__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_double_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_double_sequence;
    rhs: ptr rosidl_runtime_c_double_sequence): bool {.
    importc: "rosidl_runtime_c__double__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_double_sequence_copy*(
    input: ptr rosidl_runtime_c_double_sequence;
    output: ptr rosidl_runtime_c_double_sequence): bool {.
    importc: "rosidl_runtime_c__double__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_long_double_sequence_init*(
    sequence: ptr rosidl_runtime_c_long_double_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__long_double__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_long_double_sequence_fini*(
    sequence: ptr rosidl_runtime_c_long_double_sequence) {.
    importc: "rosidl_runtime_c__long_double__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_long_double_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_long_double_sequence;
    rhs: ptr rosidl_runtime_c_long_double_sequence): bool {.
    importc: "rosidl_runtime_c__long_double__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_long_double_sequence_copy*(
    input: ptr rosidl_runtime_c_long_double_sequence;
    output: ptr rosidl_runtime_c_long_double_sequence): bool {.
    importc: "rosidl_runtime_c__long_double__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_char_sequence_init*(
    sequence: ptr rosidl_runtime_c_char_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__char__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_char_sequence_fini*(
    sequence: ptr rosidl_runtime_c_char_sequence) {.
    importc: "rosidl_runtime_c__char__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_char_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_char_sequence;
    rhs: ptr rosidl_runtime_c_char_sequence): bool {.
    importc: "rosidl_runtime_c__char__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_char_sequence_copy*(
    input: ptr rosidl_runtime_c_char_sequence;
    output: ptr rosidl_runtime_c_char_sequence): bool {.
    importc: "rosidl_runtime_c__char__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_wchar_sequence_init*(
    sequence: ptr rosidl_runtime_c_wchar_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__wchar__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_wchar_sequence_fini*(
    sequence: ptr rosidl_runtime_c_wchar_sequence) {.
    importc: "rosidl_runtime_c__wchar__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_wchar_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_wchar_sequence;
    rhs: ptr rosidl_runtime_c_wchar_sequence): bool {.
    importc: "rosidl_runtime_c__wchar__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_wchar_sequence_copy*(
    input: ptr rosidl_runtime_c_wchar_sequence;
    output: ptr rosidl_runtime_c_wchar_sequence): bool {.
    importc: "rosidl_runtime_c__wchar__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_boolean_sequence_init*(
    sequence: ptr rosidl_runtime_c_boolean_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__boolean__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_boolean_sequence_fini*(
    sequence: ptr rosidl_runtime_c_boolean_sequence) {.
    importc: "rosidl_runtime_c__boolean__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_boolean_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_boolean_sequence;
    rhs: ptr rosidl_runtime_c_boolean_sequence): bool {.
    importc: "rosidl_runtime_c__boolean__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_boolean_sequence_copy*(
    input: ptr rosidl_runtime_c_boolean_sequence;
    output: ptr rosidl_runtime_c_boolean_sequence): bool {.
    importc: "rosidl_runtime_c__boolean__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_octet_sequence_init*(
    sequence: ptr rosidl_runtime_c_octet_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__octet__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_octet_sequence_fini*(
    sequence: ptr rosidl_runtime_c_octet_sequence) {.
    importc: "rosidl_runtime_c__octet__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_octet_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_octet_sequence;
    rhs: ptr rosidl_runtime_c_octet_sequence): bool {.
    importc: "rosidl_runtime_c__octet__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_octet_sequence_copy*(
    input: ptr rosidl_runtime_c_octet_sequence;
    output: ptr rosidl_runtime_c_octet_sequence): bool {.
    importc: "rosidl_runtime_c__octet__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_uint8_sequence_init*(
    sequence: ptr rosidl_runtime_c_uint8_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__uint8__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_uint8_sequence_fini*(
    sequence: ptr rosidl_runtime_c_uint8_sequence) {.
    importc: "rosidl_runtime_c__uint8__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_uint8_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_uint8_sequence;
    rhs: ptr rosidl_runtime_c_uint8_sequence): bool {.
    importc: "rosidl_runtime_c__uint8__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_uint8_sequence_copy*(
    input: ptr rosidl_runtime_c_uint8_sequence;
    output: ptr rosidl_runtime_c_uint8_sequence): bool {.
    importc: "rosidl_runtime_c__uint8__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_int8_sequence_init*(
    sequence: ptr rosidl_runtime_c_int8_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__int8__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_int8_sequence_fini*(
    sequence: ptr rosidl_runtime_c_int8_sequence) {.
    importc: "rosidl_runtime_c__int8__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_int8_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_int8_sequence;
    rhs: ptr rosidl_runtime_c_int8_sequence): bool {.
    importc: "rosidl_runtime_c__int8__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_int8_sequence_copy*(
    input: ptr rosidl_runtime_c_int8_sequence;
    output: ptr rosidl_runtime_c_int8_sequence): bool {.
    importc: "rosidl_runtime_c__int8__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_uint16_sequence_init*(
    sequence: ptr rosidl_runtime_c_uint16_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__uint16__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_uint16_sequence_fini*(
    sequence: ptr rosidl_runtime_c_uint16_sequence) {.
    importc: "rosidl_runtime_c__uint16__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_uint16_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_uint16_sequence;
    rhs: ptr rosidl_runtime_c_uint16_sequence): bool {.
    importc: "rosidl_runtime_c__uint16__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_uint16_sequence_copy*(
    input: ptr rosidl_runtime_c_uint16_sequence;
    output: ptr rosidl_runtime_c_uint16_sequence): bool {.
    importc: "rosidl_runtime_c__uint16__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_int16_sequence_init*(
    sequence: ptr rosidl_runtime_c_int16_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__int16__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_int16_sequence_fini*(
    sequence: ptr rosidl_runtime_c_int16_sequence) {.
    importc: "rosidl_runtime_c__int16__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_int16_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_int16_sequence;
    rhs: ptr rosidl_runtime_c_int16_sequence): bool {.
    importc: "rosidl_runtime_c__int16__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_int16_sequence_copy*(
    input: ptr rosidl_runtime_c_int16_sequence;
    output: ptr rosidl_runtime_c_int16_sequence): bool {.
    importc: "rosidl_runtime_c__int16__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_uint32_sequence_init*(
    sequence: ptr rosidl_runtime_c_uint32_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__uint32__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_uint32_sequence_fini*(
    sequence: ptr rosidl_runtime_c_uint32_sequence) {.
    importc: "rosidl_runtime_c__uint32__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_uint32_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_uint32_sequence;
    rhs: ptr rosidl_runtime_c_uint32_sequence): bool {.
    importc: "rosidl_runtime_c__uint32__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_uint32_sequence_copy*(
    input: ptr rosidl_runtime_c_uint32_sequence;
    output: ptr rosidl_runtime_c_uint32_sequence): bool {.
    importc: "rosidl_runtime_c__uint32__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_int32_sequence_init*(
    sequence: ptr rosidl_runtime_c_int32_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__int32__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_int32_sequence_fini*(
    sequence: ptr rosidl_runtime_c_int32_sequence) {.
    importc: "rosidl_runtime_c__int32__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_int32_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_int32_sequence;
    rhs: ptr rosidl_runtime_c_int32_sequence): bool {.
    importc: "rosidl_runtime_c__int32__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_int32_sequence_copy*(
    input: ptr rosidl_runtime_c_int32_sequence;
    output: ptr rosidl_runtime_c_int32_sequence): bool {.
    importc: "rosidl_runtime_c__int32__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_uint64_sequence_init*(
    sequence: ptr rosidl_runtime_c_uint64_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__uint64__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_uint64_sequence_fini*(
    sequence: ptr rosidl_runtime_c_uint64_sequence) {.
    importc: "rosidl_runtime_c__uint64__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_uint64_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_uint64_sequence;
    rhs: ptr rosidl_runtime_c_uint64_sequence): bool {.
    importc: "rosidl_runtime_c__uint64__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_uint64_sequence_copy*(
    input: ptr rosidl_runtime_c_uint64_sequence;
    output: ptr rosidl_runtime_c_uint64_sequence): bool {.
    importc: "rosidl_runtime_c__uint64__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_int64_sequence_init*(
    sequence: ptr rosidl_runtime_c_int64_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__int64__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(STRUCT_NAME)

proc rosidl_runtime_c_int64_sequence_fini*(
    sequence: ptr rosidl_runtime_c_int64_sequence) {.
    importc: "rosidl_runtime_c__int64__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(STRUCT_NAME)

proc rosidl_runtime_c_int64_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_int64_sequence;
    rhs: ptr rosidl_runtime_c_int64_sequence): bool {.
    importc: "rosidl_runtime_c__int64__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(STRUCT_NAME)

proc rosidl_runtime_c_int64_sequence_copy*(
    input: ptr rosidl_runtime_c_int64_sequence;
    output: ptr rosidl_runtime_c_int64_sequence): bool {.
    importc: "rosidl_runtime_c__int64__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}

proc rosidl_runtime_c_bool_sequence_init*(
    sequence: ptr rosidl_runtime_c_boolean_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__bool__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ## @}
                              ##
                              ##  \defgroup primitives_sequence_functions__legacy Sequence functions for legacy types for backward compatibility.
                              ##
                              ## @{
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(bool)

proc rosidl_runtime_c_bool_sequence_fini*(
    sequence: ptr rosidl_runtime_c_boolean_sequence) {.
    importc: "rosidl_runtime_c__bool__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_FINI(bool)

proc rosidl_runtime_c_bool_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_boolean_sequence;
    rhs: ptr rosidl_runtime_c_boolean_sequence): bool {.
    importc: "rosidl_runtime_c__bool__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(bool)

proc rosidl_runtime_c_bool_sequence_copy*(
    input: ptr rosidl_runtime_c_boolean_sequence;
    output: ptr rosidl_runtime_c_boolean_sequence): bool {.
    importc: "rosidl_runtime_c__bool__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(bool)

proc rosidl_runtime_c_byte_sequence_init*(
    sequence: ptr rosidl_runtime_c_octet_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__byte__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(byte)

proc rosidl_runtime_c_byte_sequence_fini*(
    sequence: ptr rosidl_runtime_c_octet_sequence) {.
    importc: "rosidl_runtime_c__byte__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_FINI(byte)

proc rosidl_runtime_c_byte_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_octet_sequence;
    rhs: ptr rosidl_runtime_c_octet_sequence): bool {.
    importc: "rosidl_runtime_c__byte__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(byte)

proc rosidl_runtime_c_byte_sequence_copy*(
    input: ptr rosidl_runtime_c_octet_sequence;
    output: ptr rosidl_runtime_c_octet_sequence): bool {.
    importc: "rosidl_runtime_c__byte__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(byte)

proc rosidl_runtime_c_float32_sequence_init*(
    sequence: ptr rosidl_runtime_c_float_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__float32__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(float32)

proc rosidl_runtime_c_float32_sequence_fini*(
    sequence: ptr rosidl_runtime_c_float_sequence) {.
    importc: "rosidl_runtime_c__float32__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_FINI(float32)

proc rosidl_runtime_c_float32_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_float_sequence;
    rhs: ptr rosidl_runtime_c_float_sequence): bool {.
    importc: "rosidl_runtime_c__float32__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(float32)

proc rosidl_runtime_c_float32_sequence_copy*(
    input: ptr rosidl_runtime_c_float_sequence;
    output: ptr rosidl_runtime_c_float_sequence): bool {.
    importc: "rosidl_runtime_c__float32__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(float32)

proc rosidl_runtime_c_float64_sequence_init*(
    sequence: ptr rosidl_runtime_c_double_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__float64__Sequence__init",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_INIT(float64)

proc rosidl_runtime_c_float64_sequence_fini*(
    sequence: ptr rosidl_runtime_c_double_sequence) {.
    importc: "rosidl_runtime_c__float64__Sequence__fini",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_FINI(float64)

proc rosidl_runtime_c_float64_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_double_sequence;
    rhs: ptr rosidl_runtime_c_double_sequence): bool {.
    importc: "rosidl_runtime_c__float64__Sequence__are_equal",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_EQ(float64)

proc rosidl_runtime_c_float64_sequence_copy*(
    input: ptr rosidl_runtime_c_double_sequence;
    output: ptr rosidl_runtime_c_double_sequence): bool {.
    importc: "rosidl_runtime_c__float64__Sequence__copy",
    header: "rosidl_runtime_c/primitives_sequence_functions.h".}
  ##
                              ##  See #ROSIDL_RUNTIME_C__DECLARE_PRIMITIVE_SEQUENCE_COPY(float64)
## @}
