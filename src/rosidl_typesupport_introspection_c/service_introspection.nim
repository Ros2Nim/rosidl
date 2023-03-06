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
  rosidl_runtime_c/service_type_support_struct, rcutils/types/rcutils_ret,
  rosidl_runtime_c/service_type_support_struct,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/service_type_support_struct,
  rosidl_runtime_c/service_type_support_struct, ./message_introspection,
  ./message_introspection, rosidl_runtime_c/message_initialization,
  ./message_introspection, ./visibility_control, ./visibility_control,
  ./message_introspection

type

  rosidl_typesupport_introspection_c_ServiceMembers* {.
      importc: "rosidl_typesupport_introspection_c__ServiceMembers",
      header: "rosidl_typesupport_introspection_c/service_introspection.h",
      bycopy.} = object ##  This struct provides introspection information for one service definition.
                         ##  A service is comprised of two interfaces: the request and the response.
    service_namespace* {.importc: "service_namespace_".}: cstring ##
                              ##  The namespace in which the service resides, e.g. "example_messages__srv" for
                              ##  example_messages/srv
    service_name* {.importc: "service_name_".}: cstring ##
                              ##  The name of the service, e.g. "AddTwoInts"
    request_members* {.importc: "request_members_".}: ptr rosidl_typesupport_introspection_c_MessageMembers ##
                              ##  A pointer to the introspection information structure for the request interface.
    response_members* {.importc: "response_members_".}: ptr rosidl_typesupport_introspection_c_MessageMembers ##
                              ##  A pointer to the introspection information structure for the response interface.
    event_members* {.importc: "event_members_".}: ptr rosidl_typesupport_introspection_c_MessageMembers ##
                              ##  A pointer to the introspection information structure for the event interface.

