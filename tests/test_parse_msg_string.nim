# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter "t").
#
# To run these tests, simply execute `nimble test`.

import unittest
import strutils

import rosidl/msg_parser

suite "msg parse":

  test "test_parse_message_string":
    var msg_spec = parse_message_string("pkg", "Foo", "")
    check msg_spec.base_type.pkg_name == "pkg"
    check msg_spec.base_type.typ == "Foo"
    check len(msg_spec.fields) == 0
    check len(msg_spec.constants) == 0

  test "comment ":
    var msg_spec = parse_message_string("pkg", "Foo", "#comment\n \n  # comment")
    check len(msg_spec.fields) == 0
    check len(msg_spec.constants) == 0

  test "invalid ":
    expect(InvalidFieldDefinition):
      discard parse_message_string("pkg", "Foo", "bool  # comment")

  test "named field":
    var msg_spec = parse_message_string("pkg", "Foo", "bool foo")
    check len(msg_spec.fields) == 1
    check msg_spec.fields[0].typ.typ == "bool"
    check msg_spec.fields[0].name == "foo"
    check msg_spec.fields[0].default_value.isNone
    check len(msg_spec.constants) == 0

  test "named default field":
    var msg_spec = parse_message_string("pkg", "Foo", "bool foo 1")
    check len(msg_spec.fields) == 1
    check msg_spec.fields[0].typ.typ == "bool"
    check msg_spec.fields[0].name == "foo"
    check msg_spec.fields[0].default_value.isSome == true
    check len(msg_spec.constants) == 0