# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter "t").
#
# To run these tests, simply execute `nimble test`.

import unittest
import strutils

import rosidl/msg_parser

suite "names":

  test "package names":
    for valid_package_name in ["foo", "foo_bar"]:
      check is_valid_package_name(valid_package_name)
  test "invalid package names":
    for invalid_package_name in ["_foo", "foo_", "foo__bar", "foo-bar"]:
      echo "invalid_package_name: ", invalid_package_name
      check not is_valid_package_name(invalid_package_name)
