// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from test_interface_files:srv/Empty.idl
// generated code does not contain a copyright notice

#ifndef TEST_INTERFACE_FILES__SRV__DETAIL__EMPTY__STRUCT_H_
#define TEST_INTERFACE_FILES__SRV__DETAIL__EMPTY__STRUCT_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// Constants defined in the message

/// Struct defined in srv/Empty in the package test_interface_files.
typedef struct test_interface_files__srv__Empty_Request
{
  uint8_t structure_needs_at_least_one_member;
} test_interface_files__srv__Empty_Request;

// Struct for a sequence of test_interface_files__srv__Empty_Request.
typedef struct test_interface_files__srv__Empty_Request__Sequence
{
  test_interface_files__srv__Empty_Request * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} test_interface_files__srv__Empty_Request__Sequence;


// Constants defined in the message

/// Struct defined in srv/Empty in the package test_interface_files.
typedef struct test_interface_files__srv__Empty_Response
{
  uint8_t structure_needs_at_least_one_member;
} test_interface_files__srv__Empty_Response;

// Struct for a sequence of test_interface_files__srv__Empty_Response.
typedef struct test_interface_files__srv__Empty_Response__Sequence
{
  test_interface_files__srv__Empty_Response * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} test_interface_files__srv__Empty_Response__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // TEST_INTERFACE_FILES__SRV__DETAIL__EMPTY__STRUCT_H_
