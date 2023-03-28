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
