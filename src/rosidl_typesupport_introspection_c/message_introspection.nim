##  Copyright 2014-2015 Open Source Robotics Foundation, Inc.
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
  ../rosidl_runtime_c/message_initialization,
  ../rosidl_runtime_c/message_type_support_struct,
  ../rosidl_runtime_c/visibility_control,
  ../rosidl_runtime_c/visibility_control,
  ../rosidl_runtime_c/message_type_support_struct,
  ../rosidl_runtime_c/message_type_support_struct, ./visibility_control,
  ./visibility_control

type

  rosidl_typesupport_introspection_c_MessageMember* {.
      importc: "rosidl_typesupport_introspection_c__MessageMember",
      header: "rosidl_typesupport_introspection_c/message_introspection.h",
      bycopy.} = object     ##  Structure used to describe a single field of an interface type.
    name* {.importc: "name_".}: cstring ##  The name of the field.
    type_id* {.importc: "type_id_".}: uint8 ##  The type of the field as a value of the field types enum
                                            ##  rosidl_typesupport_introspection_c_field_types.
                                            ##  e.g. rosidl_typesupport_introspection_c__ROS_TYPE_FLOAT
    string_upper_bound* {.importc: "string_upper_bound_".}: csize_t ##
                              ##  If the field is a string, the upper bound on the length of the string.
    members* {.importc: "members_".}: ptr rosidl_message_type_support_t ##
                              ##  If the type_id_ value is rosidl_typesupport_introspection_c__ROS_TYPE_MESSAGE,
                              ##  this points to an array describing the fields of the sub-interface.
    is_array* {.importc: "is_array_".}: bool ##  True if this field is an array type, false if it is any other type. An
                                             ##  array has the same value for / type_id_.
    array_size* {.importc: "array_size_".}: csize_t ##
                              ##  If is_array_ is true, this contains the number of members in the array.
    is_upper_bound* {.importc: "is_upper_bound_".}: bool ##
                              ##  If is_array_ is true, this specifies if the array has a maximum size. If it is true, the
                              ##  value in array_size_ is the maximum size.
    offset* {.importc: "offset_".}: uint32 ##  The bytes into the interface's in-memory representation that this field can be found at.
    default_value* {.importc: "default_value_".}: pointer ##
                              ##  If the interface has a default value, this points to it.
    size_function* {.importc: "size_function".}: proc (a1: pointer): csize_t ##
                              ##  If is_array_ is true, a pointer to a function that gives the size of one member of the array.
    get_const_function* {.importc: "get_const_function".}: proc (a1: pointer;
        index: csize_t): pointer ##  If is_array_ is true, a pointer to a function that gives a const pointer to the member of the
                                 ##  array indicated by index.
    get_function* {.importc: "get_function".}: proc (a1: pointer; index: csize_t): pointer ##
                              ##  If is_array_ is true, a pointer to a function that gives a pointer to the member of the
                              ##  array indicated by index.
    fetch_function* {.importc: "fetch_function".}: proc (a1: pointer;
        index: csize_t; a3: pointer) ##  Pointer to a function that fetches (i.e. copies) an item from
                                     ##  an array or sequence member. It takes a pointer to the member,
                                     ##  an index (which is assumed to be valid), and a pointer to a
                                     ##  pre-allocated value (which is assumed to be of the correct type).
                                     ##
                                     ##  Available for array and sequence members.
    assign_function* {.importc: "assign_function".}: proc (a1: pointer;
        index: csize_t; a3: pointer) ##  Pointer to a function that assigns (i.e. copies) a value to an
                                     ##  item in an array or sequence member. It takes a pointer to the
                                     ##  member, an index (which is assumed to be valid), and a pointer
                                     ##  to an initialized value (which is assumed to be of the correct
                                     ##  type).
                                     ##
                                     ##  Available for array and sequence members.
    resize_function* {.importc: "resize_function".}: proc (a1: pointer;
        size: csize_t): bool ##  If is_array_ is true, a pointer to a function that resizes the array.


  rosidl_typesupport_introspection_c_MessageMembers* {.
      importc: "rosidl_typesupport_introspection_c__MessageMembers",
      header: "rosidl_typesupport_introspection_c/message_introspection.h",
      bycopy.} = object     ##  Structure used to describe all fields of a single interface type.
    message_namespace* {.importc: "message_namespace_".}: cstring ##
                              ##  The namespace in which the interface resides, e.g. "example_messages__msg" for
                              ##  example_messages/msg
    message_name* {.importc: "message_name_".}: cstring ##
                              ##  The name of the interface, e.g. "Int16"
    member_count* {.importc: "member_count_".}: uint32 ##
                              ##  The number of fields in the interface
    size_of* {.importc: "size_of_".}: csize_t ##  The size of the interface structure in memory
    members* {.importc: "members_".}: ptr rosidl_typesupport_introspection_c_MessageMember ##
                              ##  A pointer to the array that describes each field of the interface
    init_function* {.importc: "init_function".}: proc (a1: pointer;
        a2: rosidl_runtime_c_message_initialization) ##
                              ##  The function used to initialise the interface's in-memory representation
    fini_function* {.importc: "fini_function".}: proc (a1: pointer) ##
                              ##  The function used to clean up the interface's in-memory representation

