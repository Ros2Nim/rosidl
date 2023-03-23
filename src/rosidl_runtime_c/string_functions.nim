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
  rstring, ./primitives_sequence, ./visibility_control


proc rosidl_runtime_c_String_init*(str: ptr rosidl_runtime_c_String): bool {.
    importc: "rosidl_runtime_c__String__init",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Initialize a rosidl_runtime_c__String structure.
                              ##
                              ##  The contents of rosidl_runtime_c__String are initialized to a single null character ('\0').
                              ##  The string initially has size 0 and capacity 1.
                              ##  Size represents the size of the contents of the string, while capacity represents the overall
                              ##  storage of the string (counting the null terminator).
                              ##  All strings must be null-terminated.
                              ##  The rosidl_runtime_c__String structure should be deallocated using the given function
                              ##  rosidl_runtime_c__String__fini() when it is no longer needed.
                              ##  Calling this function with an already initialized U16 string sequence structure will leak
                              ##  memory.
                              ##
                              ##  \param[inout] str a pointer to a rosidl_runtime_c__String structure
                              ##  \return true if successful, false if the passed string pointer is null
                              ##    or the memory allocation failed
                              ##

proc rosidl_runtime_c_String_fini*(str: ptr rosidl_runtime_c_String) {.
    importc: "rosidl_runtime_c__String__fini",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Deallocate the memory of the rosidl_runtime_c__String structure.
                              ##
                              ##  Calling the function with an already deallocated sequence is a no-op.
                              ##
                              ##  \param[inout] str a pointer to a rosidl_runtime_c__String structure to be finalized
                              ##

proc rosidl_runtime_c_String_copy*(input: ptr rosidl_runtime_c_String;
                                   output: ptr rosidl_runtime_c_String): bool {.
    importc: "rosidl_runtime_c__String__copy",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Copy rosidl_runtime_c__String structure content.
                              ##
                              ##  This functions performs a deep copy, as opposed to the shallow copy that
                              ##  plain assignment yields.
                              ##
                              ##  \param[in] input a pointer to a rosidl_runtime_c__String structure
                              ##    to copy from.
                              ##  \param[out] output a pointer to an initialized rosidl_runtime_c__String
                              ##    structure to copy into.
                              ##  \return true if successful, false if either pointer is null or memory
                              ##    allocation fails.
                              ##

proc rosidl_runtime_c_String_are_equal*(lhs: ptr rosidl_runtime_c_String;
                                        rhs: ptr rosidl_runtime_c_String): bool {.
    importc: "rosidl_runtime_c__String__are_equal",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Check for rosidl_runtime_c__String structure equality.
                              ##
                              ##  \param[in] lhs a pointer to the left hand side of the equality operator.
                              ##  \param[in] lhs a pointer to the right hand side of the equality operator.
                              ##  \return true if rosidl_runtime_c__String structures are equal in size and content,
                              ##    otherwise false.
                              ##

proc rosidl_runtime_c_String_assignn*(str: ptr rosidl_runtime_c_String;
                                      value: cstring; n: csize_t): bool {.
    importc: "rosidl_runtime_c__String__assignn",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Assign the c string pointer of n characters to the rosidl_runtime_c__String structure.
                              ##
                              ##  \param[inout] str a pointer to a string structure
                              ##  \param[in] value c string pointer to be assigned
                              ##  \param[in] n size of the value string
                              ##  \return true if successful, false if the passed string pointer is null
                              ##    or if the passed value pointer is null or if the size is higher than SIZE_MAX
                              ##    or if the memory reallocation failed.
                              ##

proc rosidl_runtime_c_String_assign*(str: ptr rosidl_runtime_c_String;
                                     value: cstring): bool {.
    importc: "rosidl_runtime_c__String__assign",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Assign the c string pointer to the rosidl_runtime_c__String structure.
                              ##
                              ##
                              ##  This function is identical to rosidl_runtime_c__String__assignn() except the length of the
                              ##  c string does not have to be given and therefore the c string must be null terminated.
                              ##
                              ##  \see rosidl_runtime_c__String__assignn()
                              ##
                              ##  \param[inout] str a pointer to a rosidl_runtime_c__String structure
                              ##  \param[in] value c string pointer to be assigned
                              ##  \return true if successful, false if the passed string pointer is null
                              ##    or if the passed value pointer is null or if the size is higher than SIZE_MAX
                              ##    or if the memory reallocation failed.
                              ##

proc rosidl_runtime_c_String_sequence_init*(
    sequence: ptr rosidl_runtime_c_String_sequence; size: csize_t): bool {.
    importc: "rosidl_runtime_c__String__Sequence__init",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Initialize a rosidl_runtime_c__String__Sequence__init structure.
                              ##
                              ##  The rosidl_runtime_c__String__Sequence is initialized with the size passed to the function.
                              ##  The rosidl_runtime_c__String__Sequence structure should be deallocated using the given function
                              ##  rosidl_runtime_c__String__Sequence__fini() when it is no longer needed.
                              ##  Calling this function with an already initialized U16 string sequence structure will leak
                              ##  memory.
                              ##
                              ##  \param[inout] sequence a pointer to a string sequence
                              ##  \param[in] size represents the size of the string sequence
                              ##  \return true if successful, false if the passed string pointer is null
                              ##    or the memory allocation failed
                              ##

proc rosidl_runtime_c_String_sequence_fini*(
    sequence: ptr rosidl_runtime_c_String_sequence) {.
    importc: "rosidl_runtime_c__String__Sequence__fini",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Deallocate the memory of the string sequence structure.
                              ##
                              ##  Calling the function with an already deallocated sequence is a no-op.
                              ##
                              ##  \param[inout] sequence a pointer to a string sequence to be finalized
                              ##

proc rosidl_runtime_c_String_sequence_are_equal*(
    lhs: ptr rosidl_runtime_c_String_sequence;
    rhs: ptr rosidl_runtime_c_String_sequence): bool {.
    importc: "rosidl_runtime_c__String__Sequence__are_equal",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Check for rosidl_runtime_c__String__Sequence structure equality.
                              ##
                              ##  \param[in] lhs a pointer to the left hand side of the equality operator.
                              ##  \param[in] lhs a pointer to the right hand side of the equality operator.
                              ##  \return true if rosidl_runtime_c__String__Sequence structures are equal
                              ##    in size and content, otherwise false.
                              ##

proc rosidl_runtime_c_String_sequence_copy*(
    input: ptr rosidl_runtime_c_String_sequence;
    output: ptr rosidl_runtime_c_String_sequence): bool {.
    importc: "rosidl_runtime_c__String__Sequence__copy",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Copy rosidl_runtime_c__String__Sequence structure content.
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

proc rosidl_runtime_c_String_sequence_create*(size: csize_t): ptr rosidl_runtime_c_String_sequence {.
    importc: "rosidl_runtime_c__String__Sequence__create",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Create a rosidl_runtime_c__String__Sequence structure with a specific size.
                              ##
                              ##  The string sequence initially has size and capacity equal to the size argument passed to the
                              ##  function.
                              ##  The rosidl_runtime_c__String__Sequence structure should be deallocated using the given function
                              ##  rosidl_runtime_c__String__Sequence__destroy() when it is no longer needed.
                              ##
                              ##  \param[in] size of the desired string sequence
                              ##  \return a string sequence if initialization was successfully, otherwise NULL.
                              ##

proc rosidl_runtime_c_String_sequence_destroy*(
    sequence: ptr rosidl_runtime_c_String_sequence) {.
    importc: "rosidl_runtime_c__String__Sequence__destroy",
    header: "rosidl_runtime_c/string_functions.h".}
  ##
                              ##  Destroy a rosidl_runtime_c__String__Sequence structure.
                              ##
                              ##  Calling the function with an already deallocated sequence is a no-op.
                              ##
                              ##  \param[inout] sequence a pointer to a string sequence to be finalized
                              ## 