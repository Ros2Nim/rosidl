import std / [strutils, sequtils, macros, genasts]

import msg_parser

import os

type
  RosSeq*[T] = object
    data*: UncheckedArray[T]
    size*: csize_t
    capacity*: csize_t

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

macro importcRosMsgFile*(mpath: typed): untyped =
  ## import RosMsg using external C Structs 
  let msg = parse_message_static(mpath.strVal)
  let pkgNim = msg.base_type.pkg_name.
                    split("_").
                    mapIt(it.capitalizeAscii()).
                    join("")
  let msgNim = msg.msg_name.
                    split("_").
                    mapIt(it.capitalizeAscii()).
                    join("")
  let MsgHdr = "$1/msg/detail/$2__struct.h" % [
                    msg.base_type.pkg_name,
                    msg.msg_name.toLower()]
  let MsgNameN = ident(pkgNim & msgNim)
  let MsgNameC = "$1__msg__$2" % [
                    msg.base_type.pkg_name,
                    msg.msg_name]

  var tres = quote do:
    type
      `MsgNameN`* {.importc: `MsgNameC`, header: `MsgHdr`.} = object
        field*: int
  
  var recList = nnkRecList.newTree()
  for field in msg.fields:
    recList.add nnkIdentDefs.newTree(
      nnkPostfix.newTree(ident("*"), ident(field.name)),
      ident(field.typ.typ),
      newEmptyNode(),
    )
  tres[0][^1][^1] = recList
  result = nnkStmtList.newTree(tres)

# macro rosMsgFunc*(): untyped =
#   let FuncHdr = "$1/msg/detail/$2__functions.h" % [msg.base_type.pkg_name, msg.msg_name.toLower()]
