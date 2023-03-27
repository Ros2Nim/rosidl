# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter "t").
#
# To run these tests, simply execute `nimble test`.

import unittest
import strutils

import rosidl/msg_parser


suite "base type constructor":
  setup:
    let primitive_types = [
        "bool",
        "byte",
        "char",
        "float32",
        "float64",
        "int8",
        "uint8",
        "int16",
        "uint16",
        "int32",
        "uint32",
        "int64",
        "uint64",
        "string",
        "wstring",
    ]

  test "primitives":
    for primitive_type in primitive_types:
        var base_type = newBaseType(primitive_type)
        check base_type.pkg_name == ""
        check base_type.typ == primitive_type
        check base_type.string_upper_bound == -1

  test "strings":
    for string_type in ["string", "wstring"]:
        var base_type = newBaseType("$1<=23" % [string_type])
        check base_type.pkg_name == ""
        check base_type.typ == string_type
        check base_type.string_upper_bound == 23

        expect ValueError:
          discard newBaseType("$1<=upperbound" % string_type)
        expect ValueError:
          discard newBaseType("$1<=0" % string_type)

  test "package name":
    var base_type = newBaseType("pkg/Msg")
    check base_type.pkg_name == "pkg"
    check base_type.typ == "Msg"
    check base_type.string_upper_bound == -1

    base_type = newBaseType("Msg", "pkg")
    check base_type.pkg_name == "pkg"
    check base_type.typ == "Msg"
    check base_type.string_upper_bound == -1

    expect InvalidResourceName:
      discard newBaseType("Foo")

    expect InvalidResourceName:
      discard newBaseType("pkg name/Foo")

    expect InvalidResourceName:
      discard newBaseType("pkg/Foo Bar")


# test "base type methods":
#     check BaseType("bool").is_primitive_type()
#     check not BaseType("pkg/Foo").is_primitive_type()
#     check BaseType("bool") != 23
#     check BaseType("pkg/Foo") == BaseType("pkg/Foo")
#     check BaseType("bool") != BaseType("pkg/Foo")
#     {BaseType("bool"): None}
#     check str(BaseType("pkg/Foo")) == "pkg/Foo"
#     check str(BaseType("bool")) == "bool"
#     check str(BaseType("string<=5")) == "string<=5"
#     check str(BaseType("wstring<=5")) == "wstring<=5"