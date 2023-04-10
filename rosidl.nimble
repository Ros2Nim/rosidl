version       = "0.3.1"
author        = "Jaremy Creechley"
description   = "RosIDL (ROS2) Interface"
license       = "MIT"

srcDir        = "src"
skipDirs      = @["deps"]

requires "nim >= 1.6.0"

requires "https://github.com/elcritch/patty.git == 0.3.5"
requires "https://github.com/Ros2Nim/rcutils.git"
requires "https://github.com/Ros2Nim/ros_cdr.git"
requires "regex"

