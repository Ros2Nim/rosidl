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

  test "parse basic1":
    var srv_spec = parse_service_string("pkg", "Foo", "---")
    check srv_spec.pkg_name == "pkg"
    check srv_spec.srv_name == "Foo"
    check srv_spec.request.base_type.pkg_name == "pkg"
    check srv_spec.request.base_type.typ == "Foo_Request"
    check len(srv_spec.request.fields) == 0
    check len(srv_spec.request.constants) == 0
    check srv_spec.response.base_type.pkg_name == "pkg"
    check srv_spec.response.base_type.typ == "Foo_Response"
    check len(srv_spec.response.fields) == 0
    check len(srv_spec.response.constants) == 0

  test "parse basic2":
    var srv_spec = parse_service_string("pkg", "Foo", "#comment\n---\n \n  # comment")
    check len(srv_spec.request.fields) == 0
    check len(srv_spec.request.constants) == 0
    check len(srv_spec.response.fields) == 0
    check len(srv_spec.response.constants) == 0

    expect(InvalidFieldDefinition):
        discard parse_service_string("pkg", "Foo", "bool  # comment\n---")

  test "parse basic2":
    var srv_spec = parse_service_string("pkg", "Foo", "bool foo\n---\nint8 bar")
    check len(srv_spec.request.fields) == 1
    check srv_spec.request.fields[0].typ.typ == "bool"
    check srv_spec.request.fields[0].name == "foo"
    check srv_spec.request.fields[0].default_value.isNone
    check len(srv_spec.request.constants) == 0
    check len(srv_spec.response.fields) == 1
    check srv_spec.response.fields[0].typ.typ == "int8"
    check srv_spec.response.fields[0].name == "bar"
    check srv_spec.response.fields[0].default_value.isNone
    check len(srv_spec.response.constants) == 0

  test "parse basic3":
    var srv_spec = parse_service_string("pkg", "Foo", "bool foo 1\n---\nint8 bar 2")
    check len(srv_spec.request.fields) == 1
    check srv_spec.request.fields[0].typ.typ == "bool"
    check srv_spec.request.fields[0].name == "foo"
    check srv_spec.request.fields[0].default_value.isSome
    check len(srv_spec.request.constants) == 0
    check len(srv_spec.response.fields) == 1
    check srv_spec.response.fields[0].typ.typ == "int8"
    check srv_spec.response.fields[0].name == "bar"
    check srv_spec.response.fields[0].default_value.get == MInt 2
    check len(srv_spec.response.constants) == 0

  test "parse basic3":
    var srv_spec = parse_service_string("pkg", "Foo", "bool FOO=1\n---\nint8 BAR=2")
    check len(srv_spec.request.fields) == 0
    check len(srv_spec.request.constants) == 1
    check srv_spec.request.constants[0].typ == "bool"
    check srv_spec.request.constants[0].name == "FOO"
    # check srv_spec.request.constants[0].value
    check len(srv_spec.response.fields) == 0
    check len(srv_spec.response.constants) == 1
    check srv_spec.response.constants[0].typ == "int8"
    check srv_spec.response.constants[0].name == "BAR"
    check srv_spec.response.constants[0].value == MInt 2
    
  test "parse_service_string":
    expect(InvalidServiceSpecification):
        discard parse_service_string("pkg", "Foo", "")
