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
        check base_type.string_upper_bound == int.none

  test "strings":
    for string_type in ["string", "wstring"]:
        var base_type = newBaseType("$1<=23" % [string_type])
        check base_type.pkg_name == ""
        check base_type.typ == string_type
        check base_type.string_upper_bound.get == 23

        expect ValueError:
          discard newBaseType("$1<=upperbound" % string_type)
        expect ValueError:
          discard newBaseType("$1<=0" % string_type)

  test "package name":
    var base_type = newBaseType("pkg/Msg")
    check base_type.pkg_name == "pkg"
    check base_type.typ == "Msg"
    check base_type.string_upper_bound == int.none

    base_type = newBaseType("Msg", "pkg")
    check base_type.pkg_name == "pkg"
    check base_type.typ == "Msg"
    check base_type.string_upper_bound == int.none

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
    # check Constant("bool", "FOO", "1") != 23

    check newConstant("bool", "FOO", "1") == newConstant("bool", "FOO", "1")
    check newConstant("bool", "FOO", "1") != newConstant("bool", "FOO", "0")
    check newConstant("bool", "FOO", "1") != newConstant("bool", "BAR", "1")
    check newConstant("bool", "FOO", "1") != newConstant("byte", "FOO", "1")

    check $(newConstant("bool", "FOO", "1")) == "bool FOO=true"

    check $(newConstant("string", "FOO", "foo")) == "string FOO='foo'"
    check $(newConstant("wstring", "FOO", "foo")) == "wstring FOO='foo'"


suite "fields":

  test "field_constructor":
    var typ = newType("bool")
    var field = newField(typ, "foo")
    check field.typ == typ
    check field.name == "foo"
    check field.default_value == MsgVal.none

    field = newField(typ, "foo", "1")
    check field.default_value.isSome

    # with pytest.raises(NameError):
    expect ValueError:
        discard newField(typ, "foo bar")

  test "field array constructor":
    var typ = newType("bool[2]")
    check typ.is_array == true
    var field = newField(typ, "foo", "[false, true]")
    check field.default_value.get.aval == [MBool false, MBool true]

  test "field empty array constructor":
    let typ = newType("bool[]")
    let field = newField(typ, "foo", "[false, true, false]")
    check field.default_value.get.aval == [MBool false, MBool true, MBool false]

  test "field 3 array constructor":
    let typ = newType("bool[3]")
    expect InvalidValue:
        discard newField(typ, "foo", "[false, true]")

  test "field methods":
    check (newField(newType("bool"), "foo", "1") ==
            newField(newType("bool"), "foo", "true"))

suite "type xtors":
  test "type basics":
    let typ = newType("bool")
    check typ.pkg_name == ""
    check typ.typ == "bool"
    check typ.string_upper_bound == int.none
    check not typ.is_array
    check typ.array_size == int.none
    check not typ.is_upper_bound

  test "type array basics":
    let typ = newType("bool[]")
    check typ.pkg_name == ""
    check typ.typ == "bool"
    check typ.string_upper_bound == int.none
    check typ.is_array
    check typ.array_size == int.none
    check not typ.is_upper_bound