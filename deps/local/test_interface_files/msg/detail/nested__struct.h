// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from test_interface_files:msg/Nested.idl
// generated code does not contain a copyright notice

#ifndef TEST_INTERFACE_FILES__MSG__DETAIL__NESTED__STRUCT_H_
#define TEST_INTERFACE_FILES__MSG__DETAIL__NESTED__STRUCT_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// Constants defined in the message

// Include directives for member types
// Member 'basic_types_value'
#include "test_interface_files/msg/detail/basic_types__struct.h"

/// Struct defined in msg/Nested in the package test_interface_files.
typedef struct test_interface_files__msg__Nested
{
  test_interface_files__msg__BasicTypes basic_types_value;
} test_interface_files__msg__Nested;

// Struct for a sequence of test_interface_files__msg__Nested.
typedef struct test_interface_files__msg__Nested__Sequence
{
  test_interface_files__msg__Nested * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} test_interface_files__msg__Nested__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // TEST_INTERFACE_FILES__MSG__DETAIL__NESTED__STRUCT_H_
