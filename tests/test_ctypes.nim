# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter "t").
#
# To run these tests, simply execute `nimble test`.

import unittest
import strutils
import macros

import rosidl/msg_parser
import rosidl/ctypes

{.passC: "-I../deps/local/std_msgs -Ideps/local/std_msgs".}

importcRosMsgFile("../deps/local/std_msgs/std_msgs/msg/Bool.msg")

suite "message ctypes":

  test "test bool message file":
    echo "test"
    let mpath = "deps/local/std_msgs/std_msgs/msg/Bool.msg"
    let msg = parse_message_file(mpath)

    echo "MSG: "
    echo msg

  test "test bool message":
    echo "bool: ", typeof StdMsgsBool
    var x: StdMsgsBool
    echo "StdMsgsBool: ", x
