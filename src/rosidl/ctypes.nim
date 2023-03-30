import std / [strutils, macros]

import msg_parser

import os

macro rosMsg*(pkg, name, msg: string): untyped =
  let msg = dedent(msg.strVal)
  echo "MSG: ", msg

  let mtype = parse_message_string(pkg.strVal, name.strVal, msg)

  echo "MTYPE: "
  echo mtype

  result = quote do:
    discard ""

proc parse_message_static*(message_filename: string, pkg_name = ""): MessageSpecification {.compileTime.} =
  echo "parse_message_static: ", message_filename
  var msg_name = splitFile(message_filename).name
  var pkg_name = pkg_name
  if pkg_name == "":
      pkg_name = message_filename.splitFile.dir.parentDir.lastPathPart()

  var h = staticRead(message_filename)
  result = parse_message_string(pkg_name, msg_name, h)

macro rosMsgFile*(mpath: typed): untyped =
  let msg = parse_message_static(mpath.strVal)
  echo "ROS MSG: "
  echo repr msg
  echo ""
  echo "msg_name: ", msg.msg_name
  echo "pkg_name: ", msg.base_type.pkg_name

  for field in msg.fields:
    echo "  field:name: ", field.name
    echo "  field:typ: ", field.typ
    echo "  field:defVal: ", field.default_value
  
  echo ""
