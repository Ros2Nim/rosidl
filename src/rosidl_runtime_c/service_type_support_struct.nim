import rcutils/allocator

##  Copyright 2015-2016 Open Source Robotics Foundation, Inc.
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
  rcutils/types/rcutils_ret, ./message_type_support_struct, ./visibility_control


type

  rosidl_service_typesupport_handle_function* = proc (
      a1: ptr rosidl_service_type_support_t; a2: cstring): ptr rosidl_service_type_support_t

  rosidl_service_introspection_info_t* {.
      importc: "rosidl_service_introspection_info_t",
      header: "rosidl_runtime_c/service_type_support_struct.h", bycopy.} = object
    event_type* {.importc: "event_type".}: uint8
    stamp_sec* {.importc: "stamp_sec".}: int32
    stamp_nanosec* {.importc: "stamp_nanosec".}: uint32
    client_gid* {.importc: "client_gid".}: array[16, uint8]
    sequence_number* {.importc: "sequence_number".}: int64


  rosidl_event_message_create_handle_function_function* = proc (
      info: ptr rosidl_service_introspection_info_t;
      allocator: ptr rcutils_allocator_t; request_message: pointer;
      response_message: pointer): pointer ##  Creates a ServiceEvent message for the service.
                                          ##
                                          ##  Instantiates a ServiceEvent message with the given info and request/response message.
                                          ##  The message is allocated using the given allocator and must be deallocated using
                                          ##  the rosidl_service_introspection_destroy_handle
                                          ##
                                          ##  \param[in] info POD fields of service_msgs/msg/ServiceEventInfo to be passed from rcl
                                          ##  \param[in] allocator The allocator to use for allocating the ServiceEvent message
                                          ##  \param[in] request_message type-erased handle to request message from rcl. Can be NULL.
                                          ##  \param[in] response_message type-erased handle to request message from rcl. Can be NULL.
                                          ##  \return The built ServiceEvent message. Will return NULL if the message could not be built.
                                          ##

  rosidl_event_message_destroy_handle_function_function* = proc (
      event_message: pointer; allocator: ptr rcutils_allocator_t): bool ##
                              ##  Destroys a ServiceEvent message
                              ##
                              ##  Destroys a ServiceEvent message returned by a rosidl_service_introspection_message_create_handle
                              ##  by calling the corresponding __fini function then deallocating
                              ##
                              ##  \param[in] event_message The message to destroy.
                              ##  \param[in] allocator The allocator to use for deallocating the message.
                              ##

  rosidl_service_type_support_t* {.importc: "rosidl_service_type_support_t", header: "rosidl_runtime_c/service_type_support_struct.h",
                                   bycopy.} = object ##
                              ##  Contains rosidl service type support data
    typesupport_identifier* {.importc: "typesupport_identifier".}: cstring ##
                              ##  String identifier for the type_support.
    data* {.importc: "data".}: pointer ##  Pointer to the service type support library
    `func`* {.importc: "func".}: rosidl_service_typesupport_handle_function ##
                              ##  Pointer to the service type support handler function
    event_message_create_handle_function*
        {.importc: "event_message_create_handle_function".}: rosidl_event_message_create_handle_function_function ##
                              ##  Pointer to function to create the introspection message
    event_message_destroy_handle_function*
        {.importc: "event_message_destroy_handle_function".}: rosidl_event_message_destroy_handle_function_function ##
                              ##  Pointer to function to finalize the introspection message
    event_typesupport* {.importc: "event_typesupport".}: ptr rosidl_message_type_support_t ##
                              ##  Service event message typesupport




proc get_service_typesupport_handle*(handle: ptr rosidl_service_type_support_t;
                                     identifier: cstring): ptr rosidl_service_type_support_t {.
    importc: "get_service_typesupport_handle",
    header: "rosidl_runtime_c/service_type_support_struct.h".}
  ##
                              ##  Get the service type support handle specific to this identifier.
                              ##
                              ##  The handle's message typesupport identifier function is returned or if the parameters are NULL
                              ##  then an assert will happen.
                              ##
                              ##  \param handle Handle to service type support
                              ##  \param identifier The typesupport identifier to get the handle function for
                              ##  \return The associated service typesupport handle function.
                              ##

proc get_service_typesupport_handle_function*(
    handle: ptr rosidl_service_type_support_t; identifier: cstring): ptr rosidl_service_type_support_t {.
    importc: "get_service_typesupport_handle_function",
    header: "rosidl_runtime_c/service_type_support_struct.h".}
  ##
                              ##  Get the service type support handle function specific to this identifier.
                              ##
                              ##  If the identifier is the same as this handle's typesupport_identifier the handle is simply
                              ##  returned or if the parameters are NULL then an assert will happen.
                              ##
                              ##  \param handle Handle to service type support
                              ##  \param identifier The typesupport identifier to get the handle function for
                              ##  \return if the identifier match's the handle's identifier then the handle's function
                              ##    is returned.
                              ##
##  Get the service type support given a provided action and package.
##
##  \param PkgName Name of the package that contains the service
##  \param SrvSubfolder name of the subfolder (for example: srv)
##  \param SrvName service name
##  \return a rosidl_service_type_support_t struct if founded, otherwise NULL.
##
