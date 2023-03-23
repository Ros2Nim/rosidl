import std / [ macros, strutils ]

proc parse_message_string(pkg_name, msg_name, message_string: string) =
    var
      fields: seq[Field]
      constants: seq[Constant]
      last_element = ""  # either a field or a constant
    # replace tabs with spaces
    message_string = message_string.replace("\t", " ")


template msg*(msg: string): untyped =
  dedent(msg)


when isMainModule:
  import unittest

  let mval = msg"""
  bool data 
  """

  echo "mval: ", mval