version       = "0.2.1"
author        = "Jaremy Creechley"
description   = "RosIDL (ROS2) Interface"
license       = "MIT"

srcDir        = "src"
skipDirs      = @["doc"]
installExt = @["nim"]
bin = @["rosidl"]

requires "nim >= 1.6.0"

requires "https://github.com/Ros2Nim/rcutils.git"
requires "https://github.com/Ros2Nim/rosidl_runtime_c.git >= 0.3.1"

