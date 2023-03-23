##  Copyright 2015-2018 Open Source Robotics Foundation, Inc.
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
  ./u16string, ./primitives_sequence, ./visibility_control


proc rosidl_runtime_c_U16String_init*(str: ptr rosidl_runtime_c_U16String): bool {.
    importc: "rosidl_runtime_c__U16String__init",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Initialize a rosidl_runtime_c__U16String structure.
                              ##  The contents of rosidl_runtime_c__U16String are initialized to a single null character.
                              ##  The string initially has size 0 and capacity 1.
                              ##  Size represents the size of the contents of the string, while capacity represents the overall
                              ##  storage of the string (counting the null terminator).
                              ##  All strings must be null-terminated.
                              ##  The rosidl_runtime_c__U16String structure should be deallocated using the given function
                              ##  rosidl_runtime_c__U16String__fini() when it is no longer needed.
                              ##  Calling this function with an already initialized U16 string sequence structure will leak
                              ##  memory.
                              ##
                              ##  \param[inout] str a pointer to a U16 string structure
                              ##  \return true if successful, false if the passed string pointer is null
                              ##    or the memory allocation failed
                              ##

proc rosidl_runtime_c_U16String_fini*(str: ptr rosidl_runtime_c_U16String) {.
    importc: "rosidl_runtime_c__U16String__fini",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Deallocate the memory of the rosidl_runtime_c__U16String structure.
                              ##
                              ##  Calling the function with an already deallocated sequence is a no-op.
                              ##
                              ##  \param[inout] str a pointer to a U16 string structure to be finalized
                              ##

proc rosidl_runtime_c_U16String_are_equal*(lhs: ptr rosidl_runtime_c_U16String;
    rhs: ptr rosidl_runtime_c_U16String): bool {.
    importc: "rosidl_runtime_c__U16String__are_equal",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Check for rosidl_runtime_c__U16String structure equality.
                              ##
                              ##  \param[in] lhs a pointer to the left hand side of the equality operator.
                              ##  \param[in] lhs a pointer to the right hand side of the equality operator.
                              ##  \return true if rosidl_runtime_c__U16String structures are equal
                              ##    in size and content, otherwise false.
                              ##

proc rosidl_runtime_c_U16String_copy*(input: ptr rosidl_runtime_c_U16String;
                                      output: ptr rosidl_runtime_c_U16String): bool {.
    importc: "rosidl_runtime_c__U16String__copy",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Copy rosidl_runtime_c__U16String structure content.
                              ##
                              ##  This functions performs a deep copy, as opposed to the shallow copy that
                              ##  plain assignment yields.
                              ##
                              ##  \param[in] input a pointer to a rosidl_runtime_c__U16String structure
                              ##    to copy from.
                              ##  \param[out] output a pointer to an initialized rosidl_runtime_c__U16String
                              ##    structure to copy into.
                              ##  \return true if successful, false if either pointer is null or memory
                              ##    allocation fails.
                              ##

proc rosidl_runtime_c_U16String_assignn*(str: ptr rosidl_runtime_c_U16String;
    value: ptr uint16; n: csize_t): bool {.
    importc: "rosidl_runtime_c__U16String__assignn",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Assign the uint16_t value of n characters to the rosidl_runtime_c__U16String structure.
                              ##
                              ##  This function returns `false` if memory cannot be allocated,
                              ##  if the input uint16_t pointer is null or if the size is higher than SIZE_MAX.
                              ##  In both cases no error message is set.
                              ##
                              ##  \param[inout] str a pointer to a U16 string structure
                              ##  \param[in] value points to a sequence of 16 bit chars
                              ##  \param[in] n size of the value string
                              ##  \return true if successful, false if the passed string pointer is null
                              ##    or if the passed value pointer is null or if the size is higher than SIZE_MAX
                              ##    or if the memory reallocation failed.
                              ##

proc rosidl_runtime_c_U16String_assignn_from_char*(
    str: ptr rosidl_runtime_c_U16String; value: cstring; n: csize_t): bool {.
    importc: "rosidl_runtime_c__U16String__assignn_from_char",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Assign the c string pointer value of n characters to the rosidl_runtime_c__U16String structure.
                              ##
                              ##  This function is identical to rosidl_runtime_c__U16String__assignn() except the type of the
                              ##  value is c string pointer
                              ##
                              ##  \see rosidl_runtime_c__U16String__assignn()
                              ##
                              ##  \param[inout] str a pointer to a U16 string structure
                              ##  \param[in] value points to a sequence of 16 bit chars
                              ##  \param[in] n size of the value string
                              ##  \return true if successful, false if the passed string pointer is null
                              ##    or if the passed value pointer is null or if the size is higher than SIZE_MAX
                              ##    or if the memory reallocation failed.
                              ##

proc rosidl_runtime_c_U16String_assign*(str: ptr rosidl_runtime_c_U16String;
                                        value: ptr uint16): bool {.
    importc: "rosidl_runtime_c__U16String__assign",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Assign the uint16_t pointer to the rosidl_runtime_c__U16String structure.
                              ##
                              ##  This function is identical to rosidl_runtime_c__U16String__assignn() except the length of the
                              ##  uint16_t does not have to be given.
                              ##  rosidl_runtime_c__U16String__len() is being used to determine the length of the passed string.
                              ##
                              ##  \see rosidl_runtime_c__U16String__assignn()
                              ##
                              ##  \param[inout] str a pointer to a rosidl_runtime_c__U16String structure
                              ##  \param[in] value points to a sequence of 16 bit chars
                              ##  \return true if successful, false if the passed string pointer is null
                              ##    or if the passed value pointer is null or if the size is higher than SIZE_MAX
                              ##    or if the memory reallocation failed.
                              ##

proc rosidl_runtime_c_U16String_len*(value: ptr uint16): csize_t {.
    importc: "rosidl_runtime_c__U16String__len",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Get the length of the uint16_t pointer.
                              ##
                              ##  This function returns the length of the input value pointer.
                              ##
                              ##  \param[in] value points to a sequence of 16 bit chars for which the first null char is
                              ##    determined
                              ##  \return the size of the input value pointer or zero if the pointer is NULL
                              ##

proc rosidl_runtime_c_U16String_resize*(str: ptr rosidl_runtime_c_U16String;
                                        n: csize_t): bool {.
    importc: "rosidl_runtime_c__U16String__resize",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Resize the uint16_t pointer.
                              ##
                              ##  This function resize the input value pointer.
                              ##
                              ##  \param[in] n the new size of the internal buffer
                              ##  \return true if successful, false if the passed string pointer is null
                              ##    or if the size is higher than SIZE_MAX or if the memory reallocation failed.
                              ##

proc rosidl_runtime_c_U16String_sequence_init*(
    sequence: ptr rosidl_runtime_c_U16String_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__U16String__Sequence__init",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Initialize a U16 string sequence structure.
                              ##
                              ##  The rosidl_runtime_c__U16String__Sequence is initialized to the size passed to the function.
                              ##  The U16 string sequence structure should be deallocated using the given
                              ##  function rosidl_runtime_c__U16String__Sequence__fini() when it is no longer needed.
                              ##  Calling this function with an already initialized U16 string sequence structure will leak
                              ##  memory.
                              ##
                              ##  \param[inout] sequence a pointer to a U16 string sequence structure
                              ##  \param[in] size represents the size of the U16 string
                              ##  \return true if successful, false if the passed string pointer is null
                              ##    or the memory allocation failed
                              ##

proc rosidl_runtime_c_U16String_sequence_fini*(
    sequence: ptr rosidl_runtime_c_U16String_sequence) {.
    importc: "rosidl_runtime_c__U16String__Sequence__fini",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Deallocate the memory of the string sequence structure.
                              ##
                              ##  Calling the function with an already deallocated sequence is a no-op.
                              ##
                              ##  \param[inout] sequence a pointer to a U16 string to be finalized
                              ##

proc rosidl_runtime_c_U16String_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_U16String_sequence;
    rhs: ptr rosidl_runtime_c_U16String_sequence): bool {.
    importc: "rosidl_runtime_c__U16String__Sequence__are_equal",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Check for rosidl_runtime_c__U16String__Sequence structure equality.
                              ##
                              ##  \param[in] lhs a pointer to the left hand side of the equality operator.
                              ##  \param[in] lhs a pointer to the right hand side of the equality operator.
                              ##  \return true if rosidl_runtime_c__U16String__Sequence structures are equal
                              ##    in size and content, otherwise false.
                              ##

proc rosidl_runtime_c_U16String_sequence_copy*(
    input: ptr rosidl_runtime_c_U16String_sequence;
    output: ptr rosidl_runtime_c_U16String_sequence): bool {.
    importc: "rosidl_runtime_c__U16String__Sequence__copy",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Copy a U16 string sequence content.
                              ##
                              ##  This functions performs a deep copy, as opposed to the shallow copy
                              ##  that plain assignment yields.
                              ##
                              ##  \param[in] input a pointer to a rosidl_runtime_c__String__Sequence
                              ##    structure to copy from.
                              ##  \param[out] output a pointer to an initialized rosidl_runtime_c__String__Sequence
                              ##    structure to copy into.
                              ##  \return true if successful, false if either pointer is null or memory
                              ##    allocation fails.
                              ##

proc rosidl_runtime_c_U16String_sequence_create*(size: csize_t): ptr rosidl_runtime_c_U16String_sequence {.
    importc: "rosidl_runtime_c__U16String__Sequence__create",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Create a U16 string sequence structure with a specific size.
                              ##
                              ##  The U16 string sequence initially has size and capacity equal to the size
                              ##  argument.
                              ##  The U16 string sequence structure should be deallocated using the given
                              ##  function rosidl_runtime_c__U16String__Sequence__destroy() when it is no longer needed.
                              ##
                              ##  \param[in] size of the desired U16 string
                              ##  \return a U16 string sequence if initialization was successfully, otherwise NULL.
                              ##

proc rosidl_runtime_c_U16String_sequence_destroy*(
    sequence: ptr rosidl_runtime_c_U16String_sequence) {.
    importc: "rosidl_runtime_c__U16String__Sequence__destroy",
    header: "rosidl_runtime_c/u16string_functions.h".}
  ##
                              ##  Destroy a U16 string sequence structure.
                              ##
                              ##  Calling the function with an already deallocated sequence is a no-op.
                              ##
                              ##  \param[inout] sequence a pointer to a U16 string sequence to be finalized
                              ## 