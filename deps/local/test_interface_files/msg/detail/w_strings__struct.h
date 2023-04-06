// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from test_interface_files:msg/WStrings.idl
// generated code does not contain a copyright notice

#ifndef TEST_INTERFACE_FILES__MSG__DETAIL__W_STRINGS__STRUCT_H_
#define TEST_INTERFACE_FILES__MSG__DETAIL__W_STRINGS__STRUCT_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// Constants defined in the message

// Include directives for member types
// Member 'wstring_value'
// Member 'wstring_value_default1'
// Member 'wstring_value_default2'
// Member 'wstring_value_default3'
// Member 'array_of_wstrings'
// Member 'bounded_sequence_of_wstrings'
// Member 'unbounded_sequence_of_wstrings'
#include "rosidl_runtime_c/u16string.h"

// constants for array fields with an upper bound
// bounded_sequence_of_wstrings
enum
{
  test_interface_files__msg__WStrings__bounded_sequence_of_wstrings__MAX_SIZE = 3
};

/// Struct defined in msg/WStrings in the package test_interface_files.
typedef struct test_interface_files__msg__WStrings
{
  rosidl_runtime_c__U16String wstring_value;
  rosidl_runtime_c__U16String wstring_value_default1;
  rosidl_runtime_c__U16String wstring_value_default2;
  rosidl_runtime_c__U16String wstring_value_default3;
  /// wstring WSTRING_CONST="Hello world!"
  /// wstring<=22 bounded_wstring_value
  /// wstring<=22 bounded_wstring_value_default1 "Hello world!"
  rosidl_runtime_c__U16String array_of_wstrings[3];
  rosidl_runtime_c__U16String__Sequence bounded_sequence_of_wstrings;
  rosidl_runtime_c__U16String__Sequence unbounded_sequence_of_wstrings;
} test_interface_files__msg__WStrings;

// Struct for a sequence of test_interface_files__msg__WStrings.
typedef struct test_interface_files__msg__WStrings__Sequence
{
  test_interface_files__msg__WStrings * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} test_interface_files__msg__WStrings__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // TEST_INTERFACE_FILES__MSG__DETAIL__W_STRINGS__STRUCT_H_
