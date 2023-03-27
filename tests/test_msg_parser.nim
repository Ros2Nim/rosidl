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


  test "base type methods":
    check newBaseType("bool").is_primitive_type()
    check not newBaseType("pkg/Foo").is_primitive_type()
    # check newBaseType("bool") != 23
    check newBaseType("pkg/Foo") == newBaseType("pkg/Foo")
    check newBaseType("bool") != newBaseType("pkg/Foo")
    check $(newBaseType("pkg/Foo")) == "pkg/Foo"
    check $(newBaseType("bool")) == "bool"
    check $(newBaseType("string<=5")) == "string<=5"
    check $(newBaseType("wstring<=5")) == "wstring<=5"

suite "constants":
  setup:
    var value = newConstant("bool", "FOO", "1")

  test "bad values":
    expect ValueError:
        discard newConstant("pkg/Foo", "FOO", "")

    expect ValueError:
        discard newConstant("bool", "FOO BAR", "")

    expect InvalidValue:
        discard newConstant("bool", "FOO")

  test "constant methods":
    # assert Constant("bool", "FOO", "1") != 23

    check newConstant("bool", "FOO", "1") == newConstant("bool", "FOO", "1")
    check newConstant("bool", "FOO", "1") != newConstant("bool", "FOO", "0")
    check newConstant("bool", "FOO", "1") != newConstant("bool", "BAR", "1")
    check newConstant("bool", "FOO", "1") != newConstant("byte", "FOO", "1")

    check $(newConstant("bool", "FOO", "1")) == "bool FOO=true"

    check $(newConstant("string", "FOO", "foo")) == "string FOO='foo'"
    check $(newConstant("wstring", "FOO", "foo")) == "wstring FOO='foo'"

