import std / [ macros, strutils ]

import msg_parser

proc parse_message_string(pkg_name, msg_name, message_string: string) =


template msg*(msg: string): untyped =
  dedent(msg)


when isMainModule:
  import unittest

  let mval = msg"""
  bool data 
  """

  echo "mval: ", mval