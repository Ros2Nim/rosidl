
// ROS_CFLAGS  ?= -I$(ROS_DIR)/include
// ROS_LDFLAGS ?= -L$(ROS_DIR)/lib
// ROS_LDFLAGS += -lrcl -lrmw -lrcutils \
// 	-lrosidl_runtime_c -lrosidl_typesupport_c \
// 	-lrosidl_typesupport_introspection_c \
// 	-lfastcdr -lfastrtps -lrmw_fastrtps_cpp \

#include <rcl/rcl.h>
#include <rosidl_runtime_c/message_type_support_struct.h>
#include <std_msgs/msg/string.h>

rcl_node_t node = rcl_get_zero_initialized_node();
rcl_node_options_t node_ops = rcl_node_get_default_options();
rcl_ret_t ret = rcl_node_init(&node, "node_name", "/my_namespace", &node_ops);
// ... error handling

const rosidl_message_type_support_t * ts = ROSIDL_GET_MSG_TYPE_SUPPORT(std_msgs, msg, String);
rcl_publisher_t publisher = rcl_get_zero_initialized_publisher();
rcl_publisher_options_t publisher_ops = rcl_publisher_get_default_options();
ret = rcl_publisher_init(&publisher, &node, ts, "chatter", &publisher_ops);
// ... error handling, and on shutdown do finalization:

ret = rcl_publisher_fini(&publisher, &node);
// ... error handling for rcl_publisher_fini()

ret = rcl_node_fini(&node);
// ... error handling for rcl_deinitialize_node()

/* Basic nominal test of a publisher.
 */
TEST_F(CLASSNAME(TestPublisherFixture, RMW_IMPLEMENTATION), test_publisher_nominal) {
  rcl_ret_t ret;
  rcl_publisher_t publisher = rcl_get_zero_initialized_publisher();
  const rosidl_message_type_support_t * ts =
    ROSIDL_GET_MSG_TYPE_SUPPORT(test_msgs, msg, BasicTypes);
  constexpr char topic_name[] = "chatter";
  constexpr char expected_topic_name[] = "/chatter";
  rcl_publisher_options_t publisher_options = rcl_publisher_get_default_options();
  ret = rcl_publisher_init(&publisher, this->node_ptr, ts, topic_name, &publisher_options);
  ASSERT_EQ(RCL_RET_OK, ret) << rcl_get_error_string().str;
  OSRF_TESTING_TOOLS_CPP_SCOPE_EXIT(
  {
    rcl_ret_t ret = rcl_publisher_fini(&publisher, this->node_ptr);
    EXPECT_EQ(RCL_RET_OK, ret) << rcl_get_error_string().str;
  });
  EXPECT_EQ(strcmp(rcl_publisher_get_topic_name(&publisher), expected_topic_name), 0);
  test_msgs__msg__BasicTypes msg;
  test_msgs__msg__BasicTypes__init(&msg);
  msg.int64_value = 42;
  ret = rcl_publish(&publisher, &msg, nullptr);
  test_msgs__msg__BasicTypes__fini(&msg);
  ASSERT_EQ(RCL_RET_OK, ret) << rcl_get_error_string().str;
}

/* Basic nominal test of a publisher with a string.
 */
TEST_F(CLASSNAME(TestPublisherFixture, RMW_IMPLEMENTATION), test_publisher_nominal_string) {
  rcl_ret_t ret;
  rcl_publisher_t publisher = rcl_get_zero_initialized_publisher();
  const rosidl_message_type_support_t * ts =
    ROSIDL_GET_MSG_TYPE_SUPPORT(test_msgs, msg, Strings);
  constexpr char topic_name[] = "chatter";
  rcl_publisher_options_t publisher_options = rcl_publisher_get_default_options();
  ret = rcl_publisher_init(&publisher, this->node_ptr, ts, topic_name, &publisher_options);
  ASSERT_EQ(RCL_RET_OK, ret) << rcl_get_error_string().str;
  OSRF_TESTING_TOOLS_CPP_SCOPE_EXIT(
  {
    rcl_ret_t ret = rcl_publisher_fini(&publisher, this->node_ptr);
    EXPECT_EQ(RCL_RET_OK, ret) << rcl_get_error_string().str;
  });
  test_msgs__msg__Strings msg;
  test_msgs__msg__Strings__init(&msg);
  ASSERT_TRUE(rosidl_runtime_c__String__assign(&msg.string_value, "testing"));
  ret = rcl_publish(&publisher, &msg, nullptr);
  test_msgs__msg__Strings__fini(&msg);
  ASSERT_EQ(RCL_RET_OK, ret) << rcl_get_error_string().str;
}