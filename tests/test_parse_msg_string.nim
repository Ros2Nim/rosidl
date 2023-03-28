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
  
  test "issues":
    expect(InvalidResourceName):
        discard parse_message_string("pkg", "Foo", "Ty_pe foo")
    expect(ValueError):
        discard parse_message_string("pkg", "Foo", "bool] foo")
    expect(ValueError):
        discard parse_message_string("pkg", "Foo", "bool[max]] foo")
    expect(ValueError):
        discard parse_message_string("pkg", "Foo", "bool foo\nbool foo")
    # check "foo" in $(e.value)

  test "const":
    var msg_spec = parse_message_string("pkg", "Foo", "bool FOO=1")
    check len(msg_spec.fields) == 0
    check len(msg_spec.constants) == 1
    check msg_spec.constants[0].typ == "bool"
    check msg_spec.constants[0].name == "FOO"
    check msg_spec.constants[0].value == MBool true

  test "const issues":
    expect(ValueError):
        discard parse_message_string("pkg", "Foo", "pkg/Bar foo=1")
    expect(ValueError):
        discard parse_message_string("pkg", "Foo", "bool foo=1")
    expect(ValueError):
        discard parse_message_string("pkg", "Foo", "bool FOO=1\nbool FOO=1")
  
suite "message comments":
  test "basic":
    # multi line file-level comment
    var msg_spec = parse_message_string("pkg", "Foo", "# comment 1\n#\n# comment 2\nbool value")
    check len(msg_spec.annotations) == 1
    check "comment" in msg_spec.annotations
    check len(msg_spec.annotations["comment"]) == 3
    echo "COMMENT: ", msg_spec.annotations["comment"]
    check msg_spec.annotations["comment"][0] == "comment 1"
    check msg_spec.annotations["comment"][1] == ""
    check msg_spec.annotations["comment"][2] == "comment 2"

    check len(msg_spec.fields) == 1
    check len(msg_spec.fields[0].annotations) == 1
    check "comment" in msg_spec.fields[0].annotations
    check len(msg_spec.fields[0].annotations["comment"]) == 0

  test "file-level comment separated from field-level comment":
    var msg_spec = parse_message_string("pkg", "Foo", "# comment 1\n\n# comment 2\nbool value")
    check len(msg_spec.annotations) == 1
    check "comment" in msg_spec.annotations
    check len(msg_spec.annotations["comment"]) == 1
    check msg_spec.annotations["comment"] == ["comment 1"]

    check len(msg_spec.fields) == 1
    check len(msg_spec.fields[0].annotations) == 1
    check "comment" in msg_spec.fields[0].annotations
    echo "COMMENT: ", msg_spec.annotations["comment"]
    echo "FIELDS: ", msg_spec.fields
    check len(msg_spec.fields[0].annotations["comment"]) == 1
    check msg_spec.fields[0].annotations["comment"][0] == "comment 2"

  test "file-level comment, trailing and indented field-level comment":
    var msg_spec = parse_message_string(
        "pkg", "Foo", "# comment 1\nbool value  # comment 2\n   # comment 3\nbool value2")
    check len(msg_spec.annotations) == 1
    check "comment" in msg_spec.annotations
    check len(msg_spec.annotations["comment"]) == 1
    check msg_spec.annotations["comment"] == ["comment 1"]

    check len(msg_spec.fields) == 2
    check len(msg_spec.fields[0].annotations) == 1
    check "comment" in msg_spec.fields[0].annotations
    check len(msg_spec.fields[0].annotations["comment"]) == 2
    check msg_spec.fields[0].annotations["comment"][0] == "comment 2"
    check msg_spec.fields[0].annotations["comment"][1] == "comment 3"

    check len(msg_spec.fields[1].annotations) == 1
    check "comment" in msg_spec.fields[1].annotations
    check len(msg_spec.fields[1].annotations["comment"]) == 0

  test "trailing field-level comment, next field-level comment":
    var msg_spec = parse_message_string(
        "pkg", "Foo", "bool value  # comment 2\n# comment 3\nbool value2")
    check len(msg_spec.annotations) == 1
    check "comment" in msg_spec.annotations
    check len(msg_spec.annotations["comment"]) == 0

    check len(msg_spec.fields) == 2
    check len(msg_spec.fields[0].annotations) == 1
    check "comment" in msg_spec.fields[0].annotations
    check len(msg_spec.fields[0].annotations["comment"]) == 1
    check msg_spec.fields[0].annotations["comment"][0] == "comment 2"

    check len(msg_spec.fields[1].annotations) == 1
    check "comment" in msg_spec.fields[1].annotations
    check len(msg_spec.fields[1].annotations["comment"]) == 1
    check msg_spec.fields[1].annotations["comment"][0] == "comment 3"

  test "field-level comment with a unit":
    var msg_spec = parse_message_string(
        "pkg", "Foo", "bool value  # comment [unit]")

    check len(msg_spec.fields) == 1
    check len(msg_spec.fields[0].annotations) == 2
    check "comment" in msg_spec.fields[0].annotations
    check len(msg_spec.fields[0].annotations["comment"]) == 1
    check msg_spec.fields[0].annotations["comment"][0] == "comment"

    check "unit" in msg_spec.fields[0].annotations
    echo "UNIT: ", msg_spec.fields[0].annotations["unit"]
    check msg_spec.fields[0].annotations["unit"][0] == "unit"