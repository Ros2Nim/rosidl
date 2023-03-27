# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter "t").
#
# To run these tests, simply execute `nimble test`.

import unittest
import strutils

import rosidl/msg_parser

suite "primitives":

  test "parse_primitive_value_string_string":
    var value: MsgVal

    value = parse_primitive_value_string( newType("string"), "foo")
    check $value == "foo"

    value = parse_primitive_value_string(
        newType("string"), "\"foo\"")
    echo repr value
    check $value == "foo"

    value = parse_primitive_value_string(
        newType("string"), "'foo'")
    check $value == "foo"

    # value = parse_primitive_value_string(
    #     newType("string"), "\"foo ")
    # check $value == "\"foo "

    value = parse_primitive_value_string(
        newType("string<=3"), "foo")
    check $value == "foo"

    expect(InvalidValue):
        discard parse_primitive_value_string(
            newType("string<=3"), "foobar")



  test "more strings":
    var value: MsgVal


    value = parse_primitive_value_string(
        newType("string"), "'\"fo\"o'")
    check $value == "\"fo\"o"

  #   value = parse_primitive_value_string(
  #       newType("string"), "\"fo\"o")
  #   check value == "\"fo"o"

  #   value = parse_primitive_value_string(
  #       newType("string"), r"""""foo""""")
  #   check value == "\"foo""

