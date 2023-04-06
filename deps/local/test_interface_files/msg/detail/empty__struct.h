// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from test_interface_files:msg/Empty.idl
// generated code does not contain a copyright notice

#ifndef TEST_INTERFACE_FILES__MSG__DETAIL__EMPTY__STRUCT_H_
#define TEST_INTERFACE_FILES__MSG__DETAIL__EMPTY__STRUCT_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// Constants defined in the message

/// Struct defined in msg/Empty in the package test_interface_files.
typedef struct test_interface_files__msg__Empty
{
  uint8_t structure_needs_at_least_one_member;
} test_interface_files__msg__Empty;

// Struct for a sequence of test_interface_files__msg__Empty.
typedef struct test_interface_files__msg__Empty__Sequence
{
  test_interface_files__msg__Empty * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} test_interface_files__msg__Empty__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // TEST_INTERFACE_FILES__MSG__DETAIL__EMPTY__STRUCT_H_
