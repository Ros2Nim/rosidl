import std / [strutils, strformat, sequtils, tables]
import patty, regex

const PACKAGE_NAME_MESSAGE_typSEPARATOR* = "/"
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

let VALID_PACKAGE_NAME_PATTERN: Regex = re"""(?x)
    ^
    (?!.*__)    # no consecutive underscores
    (?!.*_$)    # no underscore at the end
    [a-z]       # first character must be alpha
    [a-z0-9_]*  # followed by alpha, numeric, and underscore
    $
    """

let 
    VALID_FIELD_NAME_PATTERN = VALID_PACKAGE_NAME_PATTERN
    # relaxed patterns used for compatibility with ROS 1 messages
    # VALID_FIELD_NAME_PATTERN = re.compile("^[A-Za-z][A-Za-z0-9_]*$")
    VALID_MESSAGE_NAME_PATTERN = re"^[A-Z][A-Za-z0-9]*$"
    # relaxed patterns used for compatibility with ROS 1 messages
    # VALID_MESSAGE_NAME_PATTERN = re.compile("^[A-Za-z][A-Za-z0-9]*$")
    VALID_CONSTANT_NAME_PATTERN = re"^[A-Z]([A-Z0-9_]?[A-Z0-9]+)*$"

proc is_valid_field_name*(name: string): bool =
    var m: RegexMatch
    if name.match(VALID_FIELD_NAME_PATTERN, m):
        return m.groupFirstCapture(0, name) == name

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
            name = name[0..^len(suffix)]
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
        return m.groupFirstCapture(0, name) == name

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
        string_upper_bound*: int

    Type* = ref object of BaseType
        is_array*: bool
        is_upper_bound*: bool
        array_size*: int

    BaseField* = ref object of RootObj
        annotations*: TableRef[string, seq[string]]
    
    Constant* = ref object of BaseField
        typ*: string
        name*: string
        value*: MsgVal

    Field* = ref object of BaseField
        name*: string
        typ*: Type
        default_value*: MsgVal


proc `$`*(self: BaseType): string =
    if self.pkg_name != "":
        return self.pkg_name & "/" & self.typ
    result = self.typ
    if self.string_upper_bound > -1:
        result.add STRING_UPPER_BOUND_TOKEN & $self.string_upper_bound

proc `$`*(self: Type): string =
    result = $(self.BaseType)
    if self.is_array:
        result.add '['
        if self.is_upper_bound:
            result.add ARRAY_UPPER_BOUND_TOKEN
        if self.array_size > -1:
            result.add $self.array_size
        result.add ']'

proc parse_primitive_value_string(typ: Type, value_string: string): MsgVal
proc parse_value_string(typ: Type, value_string: string): MsgVal
proc parse_string_array_value_string(element_string: string, expected_size: int): seq[string]

proc is_primitive_type*(self: BaseType): bool =
    return self.pkg_name == ""

proc is_dynamic_array*(self: Type): bool =
    return self.is_array and (self.array_size > -1 or self.is_upper_bound)

proc is_fixed_size_array*(self: Type): bool =
    return self.is_array and self.array_size > -1 and not self.is_upper_bound

proc setupBaseType*(result: var BaseType, typstring: string, context_package_name="") =
    new result
    # check for primitive types
    if typstring in PRIMITIVE_TYPES:
        result.pkg_name = ""
        result.typ = typstring
        result.string_upper_bound = -1

    elif typstring.startswith("string%s" % STRING_UPPER_BOUND_TOKEN) or
            typstring.startswith("wstring%s" % STRING_UPPER_BOUND_TOKEN):
        result.pkg_name = ""
        result.typ = typstring.split(STRING_UPPER_BOUND_TOKEN, 1)[0]
        let upper_bound_string = typstring[len(result.typ) +
                                          len(STRING_UPPER_BOUND_TOKEN) .. ^1]

        var ex = newException(ValueError, ("the upper bound of the string type `$1` must " &
                        "be a valid integer value > 0") % [typstring])
        try:
            result.string_upper_bound = parseInt(upper_bound_string)
        except ValueError:
            raise ex
        if result.string_upper_bound <= 0:
            raise ex

    else:
        # split non-primitive type information
        let parts = typstring.split(PACKAGE_NAME_MESSAGE_typSEPARATOR)
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

        result.string_upper_bound = -1

proc newBaseType*(typstring: string, context_package_name=""): BaseType =
    new result
    result.setupBaseType(typstring, context_package_name)

proc newType*(typstring: string, context_package_name=""): Type =
    result.new

    # check for array brackets
    var typstring = typstring
    result.is_array = "]" in typstring

    result.array_size = -1
    result.is_upper_bound = false
    if result.is_array:
        let index: int = typstring.find("[")
        if index == -1:
            raise newException(ValueError, ("the type ends with `]` but does not " &
                            "contain a `[`") % [typstring])
        var array_size_string = typstring[index + 1..^1]
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
                result.array_size = parseInt(array_size_string)
            except ValueError:
                raise ex
            # check valid range
            if result.array_size <= 0:
                raise ex

        typstring = typstring[0..<index]

    result.BaseType.setupBaseType(typstring, context_package_name)

proc newConstant*(primitive_type, name, value_string: string): Constant =
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
    result.typ = typ
    if not is_valid_field_name(name):
        raise newException(ValueError, "`$1` is an invalid field name. " % [name])
    result.name = name
    if default_value_string == "":
        result.default_value = MNone()
    else:
        result.default_value =
            parse_value_string(typ, default_value_string)
    result.annotations.new



variantp Items:
    IField(f: Field)
    IConstant(c: Constant)
    INone

type
    MessageSpecification* = ref object
        pkg_name*: string
        msg_name*: string
        fields*: seq[Field]
        constants*: seq[Constant]
        annotations*: TableRef[string, seq[string]]

proc newMessageSpecification*(pkg_name, msg_name: string, fields: seq[Field], constants: seq[Constant]): MessageSpecification =
    new result
    result.pkg_name = pkg_name
    result.msg_name = msg_name
    result.fields = fields
    result.constants = constants

    let
        field_names = fields.mapIt(it.name)
        duplicate_field_names = toCountTable(field_names)
    
    var dupes: seq[string]
    for f, c in duplicate_field_names:
        if c > 1: dupes.add f
    
    if dupes.len() > 0:
        raise newException(ValueError,
                "the fields iterable contains duplicate names: $1" % [dupes.join(",")])

proc extract_file_level_comments(message_string: string): (seq[string], seq[string]) =
    var lines = message_string.splitlines()
    var index = 0
    for idx, line in lines:
        if line.startsWith(COMMENT_DELIMITER):
            var ln = line
            ln.removePrefix(COMMENT_DELIMITER)
            result[0].add ln
        else:
            index = idx
            break
    for idx in 0..<index: result[1].add lines[idx]

proc lstrip(line: string, sep = Whitespace): string = line.strip(leading=true, trailing=false, sep)
proc rstrip(line: string, sep = Whitespace): string = line.strip(leading=false, trailing=true, sep)

proc partition(line, sep: string): (string, string) =
    let ln = line.split(sep)
    (ln[0], ln[1])

proc parse_primitive_value_string(typ: Type, value_string: string): MsgVal =
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
                "must be either `true` / `1` or `false` / `0`")
        return MBool(vstr in true_values)

    if primitive_type in ["byte", "char"]:
        # same as uint8
        let ex = newException(InvalidValue,
                $primitive_type & " / " & value_string &
                          "must be a valid integer value >= 0 and <= 255")
        return MByte parseInt(value_string).byte

    if primitive_type in ["float32", "float64"]:
        try:
            return MFloat parseFloat(value_string)
        except ValueError:
            raise newException(InvalidValue,
                $primitive_type & " / " & value_string &
                "must be a floating point number using `.` as the separator")

    if primitive_type in [
        "int8", "uint8",
        "int16", "uint16",
        "int32", "uint32",
        "int64", "uint64",
    ]:
        # determine lower and upper bound
        let is_unsigned = primitive_type.startswith("u")

        if is_unsigned:
            let val = parseUInt(primitive_type)
            result = 
                case primitive_type:
                of "uint8": MUInt(uint8 val)
                of "uint16": MUInt(uint16 val)
                of "uint32": MUInt(uint32 val)
                of "uint64": MUInt(uint64 val)
                else:
                    raise newException(ValueError, "unknown type")
        else:
            let val = parseInt(primitive_type)
            result = 
                case primitive_type:
                of "int8": MInt(int8 val)
                of "int16": MInt(int16 val)
                of "int32": MInt(int32 val)
                of "int64": MInt(int64 val)
                else:
                    raise newException(ValueError, "unknown type")

    if primitive_type in ["string", "wstring"]:
        # remove outer quotes to allow leading / trailing spaces in the string
        var value_string = value_string
        for quote in ["'", "\""]:
            if value_string.startswith(quote) and value_string.endswith(quote):
                value_string = value_string[1..^1]
                var m: RegexMatch
                if value_string .match(re("(?<!\\)" & quote), m):
                    raise newException(InvalidValue,
                        $primitive_type & " / " & value_string &
                        "string inner quotes not properly escaped")
                value_string = value_string.replace("\\" & quote, quote)
                break

        # check that value is in valid range
        if len(value_string) > typ.string_upper_bound:
            raise newException(InvalidValue,
                $typ.typ & " / " & value_string &
                "string must not exceed the maximum length of $1 characters" %
                [$typ.string_upper_bound])

        return MString value_string

    raise newException(InvalidValue,
                "unknown primitive type `$1`" % [primitive_type])


proc parse_message_string*(pkg_name, msg_name, message_string: string): MessageSpecification =
    var
        fields: seq[Field]
        constants: seq[Constant]
        message_string = message_string.replace("\t", " ")
    
    let
        (message_comments, lines) = extract_file_level_comments(message_string)
    
    var
        current_comments: seq[string]
        comment_lines: seq[BaseField]
        last_element: BaseField

    for line in lines:
        var line = line.strip(leading=true, trailing=false, Whitespace)

        # ignore empty lines
        if line == "":
            # file-level comments stop at the first empty line
            continue

        var index = line.find(COMMENT_DELIMITER)

        # comment
        var comment = ""
        if index >= 0:
            comment = line[index..^1].lstrip({COMMENT_DELIMITER})
            line = line[0..<index]

        if comment != "":
            if line.strip() != "":
                # indented comment line
                # append to previous field / constant if available or ignore
                if not last_element.isNil:
                    last_element.annotations.mgetOrPut("comment", @[]).add(comment)
                continue
            # collect "unused" comments
            current_comments.add(comment)

            line = line.strip(leading=false, trailing=true)
            if line != "":
                continue

        let (typstring, mrest) = line.partition(" ")
        var rest = mrest.lstrip()

        if rest == "":
            raise newException(InvalidFieldDefinition,line)

        index = rest.find(CONSTANT_SEPARATOR)
        if index == -1:
            # line contains a field
            let (field_name, mdefault_value_string) = rest.partition(" ")
            let default_value_string = mdefault_value_string.lstrip()
            try:
                fields.add(newField(
                    newType(typstring, context_package_name=pkg_name),
                    field_name, default_value_string))
            except Exception as err:
                # echo( fmt"Error processing "{line}" of "{pkg}/{msg}": "{err}"",)
                raise err
            last_element = fields[-1]

        else:
            # line contains a constant
            var (name, value) = rest.partition($CONSTANT_SEPARATOR)
            name = name.rstrip()
            value = value.lstrip()
            constants.add(newConstant(typstring, name, value))
            last_element = constants[-1]

        # add "unused" comments to the field / constant
        last_element.annotations.mgetOrPut("comment", @[]).add current_comments
        current_comments = @[]

    # msg = MessageSpecification(pkg_name, msg_name, fields, constants)
    # msg.annotations["comment"] = message_comments

    # # condense comment lines, extract special annotations
    # process_comments(msg)
    # for field in fields:
    #     process_comments(field)
    # for constant in constants:
    #     process_comments(constant)

    # return msg


proc process_comments(instance: BaseField) =
    if "comment" in instance.annotations:
        var lines = instance.annotations["comment"]

        # look for a unit in brackets
        # the unit should not contains a comma since it might be a range
        let
            comment = lines.join("\n")
            matches = comment.findall(re"(\s*\[([^,\]]+)\])")
        
        if len(matches) == 1:
            ## checkme
            instance.annotations["unit"].add matches[0].groupFirstCapture(0, comment)
            # remove the unit from the comment
            for i, line in lines:
                lines[i] = line.replace(matches[0].groupFirstCapture(0, line), "")

        # remove empty leading lines

        while lines.len() > 0 and lines[0] == "":
            lines.delete(0)
        # remove empty trailing lines
        while lines.len() > 0 and lines[^1] == "":
            lines.delete(lines.high)
        # remove consecutive empty lines
        var length = len(lines)
        var i = 1
        while i < length:
            if lines[i] == "" and lines[i - 1] == "":
                lines[i - 1..<i + 1] = [""]
                length -= 1
                continue
            i += 1
        if lines.len() > 0:
            var text = lines.join("\n")
            instance.annotations["comment"] = dedent(text).split("\n")

proc parse_value_string(typ: Type, value_string: string): MsgVal =
    if typ.is_primitive_type() and not typ.is_array:
        return parse_primitive_value_string(typ, value_string)

    if typ.is_primitive_type() and typ.is_array:
        # check for array brackets
        if not value_string.startswith("[") or not value_string.endswith("]"):
            raise newException(InvalidValue,
                "array value must start with `[` and end with `]`")
        var elements_string = value_string[1..^1]

        var value_strings: seq[string]
        if typ.typ in ["string", "wstring"]:
            # String arrays need special processing as the comma can be part of a quoted string
            # and not a separator of array elements
            value_strings = parse_string_array_value_string(
                elements_string, typ.array_size)
        else:
            # value_strings = elements_string.split(",") if elements_string else []
            if elements_string != "":
                value_strings = elements_string.split(",")
        if typ.array_size > -1:
            # check for exact size
            if not typ.is_upper_bound and len(value_strings) != typ.array_size:
                raise newException(InvalidValue,
                    $typ & " / " & value_string &
                    "array must have exactly $1 elements, not $2" %
                    [$typ.array_size, $len(value_strings)])
            # check for upper bound
            if typ.is_upper_bound and len(value_strings) > typ.array_size:
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


proc parse_string_array_value_string(element_string: string, expected_size: int): seq[string] =
    # Walks the string, if start with quote (" or ") find next unescapted quote,
    # returns a list of string elements
    var value_strings: seq[string]
    var element_string: string
    while len(element_string) > 0:
        element_string = element_string.lstrip({' '})
        if element_string[0] == ',':
            raise newException(ValueError,"unxepected `,` at beginning of [%s]" % [element_string])
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
