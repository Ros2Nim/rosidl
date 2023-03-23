import std / [strutils, strformat, sequtils, re, tables]
import patty

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

let VALID_PACKAGE_NAME_PATTERN: Regex = rex"""
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
    if name =~ VALID_FIELD_NAME_PATTERN:
        return matches[0] == name

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
    if name =~ VALID_MESSAGE_NAME_PATTERN:
        return matches[0] == name

proc is_valid_constant_name*(name: string): bool =
    if name =~ VALID_CONSTANT_NAME_PATTERN:
        return matches[0] == name

proc is_valid_package_name*(name: string): bool =
    if name =~ VALID_PACKAGE_NAME_PATTERN:
        return matches[0] == name

type
    InvalidSpecification* = object of Exception
    InvalidActionSpecification* = object of InvalidSpecification
    InvalidServiceSpecification* = object of InvalidSpecification
    InvalidResourceName* = object of InvalidSpecification
    InvalidFieldDefinition* = object of InvalidSpecification
    UnknownMessageType* = object of InvalidSpecification
    InvalidValue* = object of Exception

variantp MsgVal:
  MBool(bval: bool)
  MByte(cval: byte)
  MInt(ival: int64)
  MUInt(uval: uint64)
  MFloat(fval: float)
  MString(sval: string)

type
    BaseType* = ref object
        pkg_name*: string
        typ*: string
        string_upper_bound*: int

    Type* = ref object
        is_array*: bool
        is_upper_bound*: bool
        array_size*: int
        base*: BaseType

    Constant* = ref object
        typ*: string
        name*: string
        value*: MsgVal
        annotations*: Table[string, seq[string]]

    Field* = ref object
        name*: string
        typ*: Type


proc parse_primitive_value_string(typ: Type, value_string: string): MsgVal

proc is_primitive_type*(self: BaseType): bool =
    return self.pkg_name == ""

proc is_primitive_type*(self: Type): bool =
    return self.base.pkg_name == ""

proc is_dynamic_array*(self: Type): bool =
    return self.is_array and (self.array_size > -1 or self.is_upper_bound)

proc is_fixed_size_array*(self: Type): bool =
    return self.is_array and self.array_size > -1 and not self.is_upper_bound

proc newBaseType*(typstring: string, context_package_name=""): BaseType =
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

proc newType*(typstring: string, context_package_name=""): Type =
    new result
    # check for array brackets
    var typstring = typstring
    result.is_array = ']' in typstring

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

    result.base = newBaseType(
        typstring,
        context_package_name=context_package_name)

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
        result.default_value = None
    else:
        self.default_value = parse_value_string(
            type_, default_value_string)

    self.annotations = {}



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
        annotations*: Table[string, seq[string]]

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

proc parse_message_string*(pkg_name, msg_name, message_string: string): MessageSpecification =
    var
        fields: seq[Field]
        constants: seq[Constant]
        message_string = message_string.replace("\t", " ")
    
    let
        (message_comments, lines) = extract_file_level_comments(message_string)
    
    var
        current_comments: seq[string]
        comment_lines: seq[Items]
        last_element: Items

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
                match last_element:
                    INone:
                        discard
                    IConstant(c):
                        c.annotations.mgetOrPut("comment", @[]).add(comment)
                    IField(f):
                        discard
                        # f.annotations.mgetOrPut("comment", @[]).add(comment)
                continue
            # collect "unused" comments
            current_comments.add(comment)

            line = line.strip(leading=false, trailing=true)
            if line != "":
                continue

        let (type_string, mrest) = line.partition(" ")
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
                    newType(type_string, context_package_name=pkg_name),
                    field_name, default_value_string))
            except Exception as err:
                print(
                    "Error processing '{line}' of '{pkg}/{msg}': '{err}'".format(
                        line=line, pkg=pkg_name, msg=msg_name, err=err),
                    file=sys.stderr)
                raise
            last_element = fields[-1]

        else:
            # line contains a constant
            name, _, value = rest.partition(CONSTANT_SEPARATOR)
            name = name.rstrip()
            value = value.lstrip()
            constants.append(Constant(type_string, name, value))
            last_element = constants[-1]

        # add "unused" comments to the field / constant
        comment_lines = last_element.annotations.setdefault(
            'comment', [])
        comment_lines += current_comments
        current_comments = []

    msg = MessageSpecification(pkg_name, msg_name, fields, constants)
    msg.annotations['comment'] = message_comments

    # condense comment lines, extract special annotations
    process_comments(msg)
    for field in fields:
        process_comments(field)
    for constant in constants:
        process_comments(constant)

    return msg

proc parse_primitive_value_string(typ: Type, value_string: string): MsgVal =
    if not typ.is_primitive_type() or typ.is_array:
        raise newException(ValueError,"the passed type must be a non-array primitive type")
    let primitive_type = typ.base.typ

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
                if value_string =~ re("(?<!\\)" & quote):
                    raise newException(InvalidValue,
                        $primitive_type & " / " & value_string &
                        "string inner quotes not properly escaped")
                value_string = value_string.replace("\\" & quote, quote)
                break

        # check that value is in valid range
        if len(value_string) > typ.base.string_upper_bound:
            raise newException(InvalidValue,
                $typ.base.typ & " / " & value_string &
                "string must not exceed the maximum length of $1 characters" %
                [$typ.base.string_upper_bound])

        return MString value_string

    raise newException(InvalidValue,
                "unknown primitive type `$1`" % [primitive_type])

