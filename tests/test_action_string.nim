# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter "t").
#
# To run these tests, simply execute `nimble test`.

import unittest
import strutils

import rosidl/msg_parser

suite "actions":

  test "valid_action_string":
    discard parse_action_string("pkg", "Foo",
                  "bool foo\n---\nint8 bar\n---")

  test "valid_action_string1":
    var spec = parse_action_string("pkg", "Foo", "bool foo\n---\nint8 bar\n---\nbool foo")
    # Goal checks
    check spec.goal.base_type.pkg_name == "pkg"
    check spec.goal.msg_name == "Foo_Goal"
    check len(spec.goal.fields) == 1
    check len(spec.goal.constants) == 0
    # Result checks
    check spec.result.base_type.pkg_name == "pkg"
    check spec.result.msg_name == "Foo_Result"
    check len(spec.result.fields) == 1
    check len(spec.result.constants) == 0
    # Feedback checks
    check spec.feedback.base_type.pkg_name == "pkg"
    check spec.feedback.msg_name == "Foo_Feedback"
    check len(spec.feedback.fields) == 1
    check len(spec.feedback.constants) == 0