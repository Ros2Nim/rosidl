
import 
  rosidl_runtime_c/action_type_support_struct,
  rosidl_runtime_c/message_initialization,
  rosidl_runtime_c/message_type_support_struct,
  rosidl_runtime_c/primitives_sequence,
  rosidl_runtime_c/primitives_sequence_functions,
  rosidl_runtime_c/rstring,
  rosidl_runtime_c/sequence_bound,
  rosidl_runtime_c/service_type_support_struct,
  rosidl_runtime_c/string_bound,
  rosidl_runtime_c/string_functions,
  rosidl_runtime_c/u16string,
  rosidl_runtime_c/u16string_functions,
  rosidl_runtime_c/visibility_control,
  rosidl_typesupport_introspection_c/field_types,
  rosidl_typesupport_introspection_c/identifier,
  rosidl_typesupport_introspection_c/message_introspection,
  rosidl_typesupport_introspection_c/service_introspection,
  rosidl_typesupport_introspection_c/visibility_control

export
  action_type_support_struct,
  message_initialization,
  message_type_support_struct,
  primitives_sequence,
  primitives_sequence_functions,
  rstring,
  sequence_bound,
  service_type_support_struct,
  string_bound,
  string_functions,
  u16string,
  u16string_functions,
  visibility_control,
  field_types,
  identifier,
  message_introspection,
  service_introspection,
  visibility_control

static:
  echo "BEFORE INSTALL"
  when defined(clib):
    echo "INSTALL CLIB"
  else:
    echo "DON'T INSTALL CLIB"