import std / [strutils, strformat, sequtils, tables, options]
import patty, regex
export options, tables

const PACKAGE_NAME_MESSAGE_TYPE_SEPARATOR* = "/"
const COMMENT_DELIMITER* = '#'
const CONSTANT_SEPARATOR* = '='
const ARRAY_UPPER_BOUND_TOKEN* = "<="
const STRING_UPPER_BOUND_TOKEN* = "<="

const SERVICE_REQUEST_RESPONSE_SEPARATOR* = "---"
const SERVICE_REQUEST_MESSAGE_SUFFIX* = "_Request"
const SERVICE_RESPONSE_MESSAGE_SUFFIX* = "_Response"
const SERVICE_EVENT_MESSAGE_SUFFIX* = "_Event"

const ACTION_REQUEST_RESPONSE_SEPARATOR* = "---"
const ACTION_GOAL_SUFFIX* = "_Goal"
const ACTION_RESULT_SUFFIX* = "_Result"
const ACTION_FEEDBACK_SUFFIX* = "_Feedback"

const ACTION_GOAL_SERVICE_SUFFIX* = "_Goal"
const ACTION_RESULT_SERVICE_SUFFIX* = "_Result"
const ACTION_FEEDBACK_MESSAGE_SUFFIX* = "_Feedback"

const PRIMITIVE_TYPES* = [
    "bool",
    "byte",
    "char",
    # TODO reconsider wchar
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
    # TODO duration and time
    "duration",  # for compatibility only
    "time",  # for compatibility only
]

const 
    VALID_PACKAGE_NAME_PATTERN: Regex = re"^([a-z][a-z0-9_]*)$"

    VALID_FIELD_NAME_PATTERN = VALID_PACKAGE_NAME_PATTERN
    # relaxed patterns used for compatibility with ROS 1 messages
    # VALID_FIELD_NAME_PATTERN = re.compile("^[A-Za-z][A-Za-z0-9_]*$")
    VALID_MESSAGE_NAME_PATTERN = re"^([A-Z][A-Za-z0-9]*)$"
    # relaxed patterns used for compatibility with ROS 1 messages
    # VALID_MESSAGE_NAME_PATTERN = re.compile("^[A-Za-z][A-Za-z0-9]*$")
    VALID_CONSTANT_NAME_PATTERN = re"^([A-Z]([A-Z0-9_]?[A-Z0-9]+)*)$"

proc is_valid_field_name*(name: string): bool =
    var m: RegexMatch
    if name.match(VALID_FIELD_NAME_PATTERN, m):
        return m.groupFirstCapture(0, name) == name and 
                not name.endswith("_") and "__" notin name

proc is_valid_message_name*(name: string): bool =
    var name = name
    let prefix = "Sample_"
    if name.startswith(prefix):
        name = name[len(prefix)..^1]
    let suffixes = [
        SERVICE_REQUEST_MESSAGE_SUFFIX,
        SERVICE_RESPONSE_MESSAGE_SUFFIX,
        ACTION_GOAL_SERVICE_SUFFIX,
        ACTION_RESULT_SERVICE_SUFFIX,
        ACTION_FEEDBACK_MESSAGE_SUFFIX,
    ]
    for suffix in suffixes:
        if name.endswith(suffix):
            name = name[0 ..< ^len(suffix)]
    # echo "IS_VALID_MESSAGE_NAME: ", name
    var m: RegexMatch
    if name.match(VALID_MESSAGE_NAME_PATTERN, m):
        return m.groupFirstCapture(0, name) == name

proc is_valid_constant_name*(name: string): bool =
    var m: RegexMatch
    if name.match(VALID_CONSTANT_NAME_PATTERN, m):
        return m.groupFirstCapture(0, name) == name

proc is_valid_package_name*(name: string): bool =
    var m: RegexMatch
    if name.match(VALID_PACKAGE_NAME_PATTERN, m):
        return m.groupFirstCapture(0, name) == name and
                not name.endswith("_") and "__" notin name

type
    InvalidSpecification* = object of Exception
    InvalidActionSpecification* = object of InvalidSpecification
    InvalidServiceSpecification* = object of InvalidSpecification
    InvalidResourceName* = object of InvalidSpecification
    InvalidFieldDefinition* = object of InvalidSpecification
    UnknownMessageType* = object of InvalidSpecification
    InvalidValue* = object of Exception

variantp MsgVal:
  MNone
  MBool(bval: bool)
  MByte(cval: byte)
  MInt(ival: int64)
  MUInt(uval: uint64)
  MFloat(fval: float)
  MString(sval: string)
  MArray(aval: seq[MsgVal])

type
    BaseType* = ref object of RootObj
        pkg_name*: string
        typ*: string
        string_upper_bound*: Option[int]

    Type* = ref object of BaseType
        is_array*: bool
        is_upper_bound*: bool
        array_size*: Option[int]

    BaseField* = ref object of RootObj
        annotations*: Table[string, seq[string]]
    
    Constant* = ref object of BaseField
        typ*: string
        name*: string
        value*: MsgVal

    Field* = ref object of BaseField
        name*: string
        typ*: Type
        default_value*: Option[MsgVal]

proc is_primitive_type*(self: BaseType): bool =
    return self.pkg_name == ""

proc is_dynamic_array*(self: Type): bool =
    return self.is_array and (self.array_size.isSome or self.is_upper_bound)

proc is_fixed_size_array*(self: Type): bool =
    return self.is_array and self.array_size.isSome and not self.is_upper_bound

proc empty*(self: MsgVal): bool = return self.kind == MsgValKind.MNone

proc `==`*(x, y: BaseType): bool =
    result = x.pkg_name == y.pkg_name and 
        x.typ == y.typ and
        x.string_upper_bound == y.string_upper_bound

proc `==`*(x, y: Type): bool =
    result =
        x.BaseType == y.BaseType and
        x.is_array == y.is_array  and 
        x.is_upper_bound == y.is_upper_bound and 
        x.array_size == y.array_size 

proc `==`*(x, y: BaseField): bool =
    result = x.annotations == y.annotations

proc `==`*(x, y: Constant): bool =
    result =
        x.BaseField == y.BaseField and
        x.typ == y.typ and 
        x.name == y.name and
        x.value == y.value

proc `==`*(x, y: Field): bool =
    result =
        x.BaseField == y.BaseField and
        x.name == y.name and 
        x.typ == y.typ and 
        x.default_value == y.default_value 

proc `$`*(self: BaseType): string =
    if self.pkg_name != "":
        return self.pkg_name & "/" & self.typ
    result = self.typ
    if self.string_upper_bound.isSome:
        result.add STRING_UPPER_BOUND_TOKEN & $self.string_upper_bound.get()

proc `$`*(self: Type): string =
    result = $(self.BaseType)
    if self.is_array:
        result.add '['
        if self.is_upper_bound:
            result.add ARRAY_UPPER_BOUND_TOKEN
        if self.array_size.isSome:
            result.add $self.array_size.get
        result.add ']'

proc `$`*(self: MsgVal): string =
    match self:
        MNone: ""
        MBool(bval): $bval
        MByte(cval): $cval
        MInt(ival): $ival
        MUInt(uval): $uval
        MFloat(fval): $fval
        MString(sval): $sval
        MArray(aval): aval.mapIt($it).join(", ")

proc `$`*(self: Constant): string =
    var value = $self.value
    if self.typ in ["string", "wstring"]:
        value = "'$1'" % [$value]
    return "$1 $2=$3" % [$self.typ, self.name, value]

proc `$`*(self: Field): string =
    result = "$1 $2" % [$(self.typ), self.name]
    if self.default_value.isSome:
        if self.typ.is_primitive_type() and not self.typ.is_array and
                self.typ.typ in ["string", "wstring"]:
            result.add " '%s'" % [$self.default_value.get]
        else:
            result.add " %s" % [$self.default_value.get]

proc parse_primitive_value_string*(typ: Type, value_string: string): MsgVal
proc parse_value_string*(typ: Type, value_string: string): MsgVal
proc parse_string_array_value_string*(element_string: string, expected_size: int): seq[string]

proc setupBaseType*(result: var BaseType, typstring: string, context_package_name="") =
    assert not result.isNil
    # check for primitive types
    if typstring in PRIMITIVE_TYPES:
        result.pkg_name = ""
        result.typ = typstring
        result.string_upper_bound = int.none

    elif typstring.startswith("string$1" % STRING_UPPER_BOUND_TOKEN) or
            typstring.startswith("wstring$1" % STRING_UPPER_BOUND_TOKEN):
        result.pkg_name = ""
        result.typ = typstring.split(STRING_UPPER_BOUND_TOKEN, 1)[0]
        let upper_bound_string = typstring[len(result.typ) +
                                          len(STRING_UPPER_BOUND_TOKEN) .. ^1]

        var ex = newException(ValueError, ("the upper bound of the string type `$1` must " &
                        "be a valid integer value > 0") % [typstring])
        try:
            result.string_upper_bound = some(parseInt(upper_bound_string))
        except ValueError:
            raise ex
        if result.string_upper_bound.get() <= 0:
            raise ex

    else:
        # split non-primitive type information
        let parts = typstring.split(PACKAGE_NAME_MESSAGE_TYPE_SEPARATOR)
        if not (len(parts) == 2 or
                (len(parts) == 1 and context_package_name isnot "")):
            raise newException(InvalidResourceName, typstring)

        if len(parts) == 2:
            # either the type string contains the package name
            result.pkg_name = parts[0]
            result.typ = parts[1]
        else:
            # or the package name is provided by context
            result.pkg_name = context_package_name
            result.typ = typstring
        if not is_valid_package_name(result.pkg_name):
            raise newException(InvalidResourceName,
                "`$1` is an invalid package name. " % [result.pkg_name])
        if not is_valid_message_name(result.typ):
            raise newException(InvalidResourceName,
                "`$1` is an invalid message name." % [result.typ])

        result.string_upper_bound = int.none

proc newBaseType*(typstring: string, context_package_name=""): BaseType =
    new result
    result.setupBaseType(typstring, context_package_name)

proc newType*(typstring: string, context_package_name=""): Type =
    new result

    # check for array brackets
    var typstring = typstring
    result.is_array = "]" in typstring

    result.array_size = int.none
    result.is_upper_bound = false
    if result.is_array:
        let index: int = typstring.find("[")
        if index == -1:
            raise newException(ValueError, ("the type ends with `]` but does not " &
                            "contain a `[`") % [typstring])
        var array_size_string = typstring[index + 1 ..< ^1]
        # get array limit
        if array_size_string != "":

            # check if the limit is an upper bound
            result.is_upper_bound = array_size_string.startswith(
                ARRAY_UPPER_BOUND_TOKEN)
            if result.is_upper_bound:
                array_size_string = array_size_string[
                    len(ARRAY_UPPER_BOUND_TOKEN)..^1]

            let ex = newException(ValueError, (
                "the size of array type `$1` must be a valid integer " &
                "value > 0 optionally prefixed with `$2` if it is only " &
                "an upper bound") %
                [ARRAY_UPPER_BOUND_TOKEN, typstring])
            try:
                result.array_size = some parseInt(array_size_string)
            except ValueError:
                raise ex
            # check valid range
            if result.array_size.get <= 0:
                raise ex

        typstring = typstring[0..<index]

    result.BaseType.setupBaseType(typstring, context_package_name)

proc newConstant*(primitive_type, name: string, value_string = ""): Constant =
    new result
    if primitive_type notin PRIMITIVE_TYPES:
        raise newException(ValueError,
                        "the constant type `$1` must be a primitive type" %
                        [primitive_type])
    result.typ = primitive_type
    if not is_valid_constant_name(name):
        raise newException(ValueError, "`$1` is an invalid constant name." % [name])
    result.name = name
    if value_string is "":
        raise newException(ValueError, "the constant value must not be empty")

    result.value = parse_primitive_value_string(
        newType(primitive_type), value_string)

proc newField*(typ: Type, name: string, default_value_string=""): Field =
    new result
    result.typ = typ
    if not is_valid_field_name(name):
        raise newException(ValueError, "`$1` is an invalid field name. " % [name])
    result.name = name
    if default_value_string == "":
        result.default_value = MsgVal.none
    else:
        result.default_value =
            some parse_value_string(typ, default_value_string)


proc lstrip*(line: string, sep = Whitespace): string = line.strip(leading=true, trailing=false, sep)
proc rstrip*(line: string, sep = Whitespace): string = line.strip(leading=false, trailing=true, sep)

proc partition*(line, sep: string): (string, string) =
    let ln = line.split(sep, maxsplit=1)
    # echo "partition: ", repr ln
    if ln.len() == 0:
        ("", "")
    elif ln.len() == 1:
        (ln[0], "")
    else:
        (ln[0], ln[1])

proc parse_value_string*(typ: Type, value_string: string): MsgVal =
    if typ.is_primitive_type() and not typ.is_array:
        return parse_primitive_value_string(typ, value_string)

    if typ.is_primitive_type() and typ.is_array:
        # check for array brackets
        if not value_string.startswith("[") or not value_string.endswith("]"):
            raise newException(InvalidValue,
                "array value must start with `[` and end with `]`")
        var elements_string = value_string[1 ..< ^1]

        var value_strings: seq[string]
        if typ.typ in ["string", "wstring"]:
            # String arrays need special processing as the comma can be part of a quoted string
            # and not a separator of array elements
            value_strings = parse_string_array_value_string(
                elements_string, typ.array_size.get)
        else:
            # value_strings = elements_string.split(",") if elements_string else []
            if elements_string != "":
                value_strings = elements_string.split(",")
        if typ.array_size.isSome:
            # check for exact size
            if not typ.is_upper_bound and len(value_strings) != typ.array_size.get:
                raise newException(InvalidValue,
                    $typ & " / " & value_string &
                    "array must have exactly $1 elements, not $2" %
                    [$typ.array_size, $len(value_strings)])
            # check for upper bound
            if typ.is_upper_bound and len(value_strings) > typ.array_size.get:
                raise newException(InvalidValue,
                    $typ & " / " & value_string &
                    "array must have not more than $1 elements, not $2" %
                    [$typ.array_size, $len(value_strings)])

        # parse all primitive values one by one
        var values: seq[MsgVal]
        for index, element_string in value_strings:
            var element_string = element_string.strip()
            try:
                var base_type = newType($BaseType(typ))
                values.add parse_primitive_value_string(base_type, element_string)
            except InvalidValue:
                raise newException(InvalidValue,
                    $typ & " / " & value_string &
                    "element $1 with $2" % [$index, getCurrentExceptionMsg()])
        return MArray(values)

    raise newException(ValueError,
        "parsing string values into type `$1` is not supported" % [$typ])

proc parse_primitive_value_string*(typ: Type, value_string: string): MsgVal =
    if not typ.is_primitive_type() or typ.is_array:
        raise newException(ValueError,"the passed type must be a non-array primitive type")
    let primitive_type = typ.typ

    if primitive_type == "bool":
        let
            true_values = ["true", "1"]
            false_values = ["false", "0"]

        let vstr = value_string.toLowerAscii()
        if vstr notin true_values and vstr notin false_values:
            raise newException(InvalidValue,
                $primitive_type & " / " & value_string &
                " must be either `true` / `1` or `false` / `0`")
        return MBool(vstr in true_values)

    if primitive_type in ["byte", "char"]:
        # same as uint8
        return MByte parseInt(value_string).byte

    if primitive_type in ["float32", "float64"]:
        try:
            return MFloat parseFloat(value_string)
        except ValueError:
            raise newException(InvalidValue,
                $primitive_type & " / " & value_string &
                " must be a floating point number using `.` as the separator")

    if primitive_type in [
        "int8", "uint8",
        "int16", "uint16",
        "int32", "uint32",
        "int64", "uint64",
    ]:
        # determine lower and upper bound
        let is_unsigned = primitive_type.startswith("u")

        if is_unsigned:
            let val = parseUInt(value_string)
            result = 
                case primitive_type:
                of "uint8": MUInt(uint8 val)
                of "uint16": MUInt(uint16 val)
                of "uint32": MUInt(uint32 val)
                of "uint64": MUInt(uint64 val)
                else:
                    raise newException(ValueError, "unknown type")
            return
        else:
            let val = parseInt(value_string)
            result = 
                case primitive_type:
                of "int8": MInt(int8 val)
                of "int16": MInt(int16 val)
                of "int32": MInt(int32 val)
                of "int64": MInt(int64 val)
                else:
                    raise newException(ValueError, "unknown type")
            return

    if primitive_type in ["string", "wstring"]:
        # remove outer quotes to allow leading / trailing spaces in the string
        var value_string = value_string
        let qchar = value_string[0]
        if qchar in ['"', '\'']:
            ## probably close enough?
            value_string = unescape(value_string, $qchar, $qchar)

        # check that value is in valid range
        if typ.string_upper_bound.isSome and
                len(value_string) > typ.string_upper_bound.get:
            raise newException(InvalidValue,
                $typ.typ & " / " & value_string &
                " string must not exceed the maximum length of $1 characters" %
                [$typ.string_upper_bound])

        return MString value_string

    raise newException(InvalidValue,
                "unknown primitive type `$1`" % [primitive_type])


proc find_matching_end_quote(str, quote: string): int =
    # Given a string, walk it and find the next unescapted quote
    # returns the index of the ending quote if successful, -1 otherwise
    var str = str
    var ending_quote_idx = -1
    var final_quote_idx = 0
    while len(str) > 0:
        ending_quote_idx = str[1..^1].find(quote)
        if ending_quote_idx == -1:
            return -1
        if str[ending_quote_idx..<ending_quote_idx + 2] != "\\" & quote:
            # found a matching end quote that is not escaped
            return final_quote_idx + ending_quote_idx
        else:
            str = str[ending_quote_idx + 2..^1]
            final_quote_idx = ending_quote_idx + 2
    return -1


proc parse_string_array_value_string*(element_string: string, expected_size: int): seq[string] =
    # Walks the string, if start with quote (" or ") find next unescapted quote,
    # returns a list of string elements
    var value_strings: seq[string]
    var element_string: string
    while len(element_string) > 0:
        element_string = element_string.lstrip({' '})
        if element_string[0] == ',':
            raise newException(ValueError,"unxepected `,` at beginning of [$1]" % [element_string])
        if len(element_string) == 0:
            return value_strings
        var quoted_value = false
        var end_quote_idx = -1
        for quote in ["\"", "'"]:
            if element_string.startswith(quote):
                quoted_value = true
                end_quote_idx = find_matching_end_quote(element_string, quote)
                if end_quote_idx == -1:
                    raise newException(ValueError, "string [$1] incorrectly quoted\n$2" % [
                        $element_string, $value_strings])
                else:
                    var value_string = ""
                    value_string = element_string[1..<end_quote_idx + 1]
                    value_string = value_string.replace("\\" & quote, quote)
                    value_strings.add(value_string)
                    element_string = element_string[end_quote_idx + 2..^1]
        if not quoted_value:
            var next_comma_idx = element_string.find(",")
            if next_comma_idx == -1:
                value_strings.add(element_string)
                element_string = ""
            else:
                value_strings.add(element_string[0..<next_comma_idx])
                element_string = element_string[next_comma_idx..^1]
        element_string = element_string.lstrip({' '})
        if len(element_string) > 0 and element_string[0] == ',':
            element_string = element_string[1..^1]
    return value_strings
