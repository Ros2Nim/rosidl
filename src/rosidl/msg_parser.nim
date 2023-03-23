import std / [strutils, strformat, re]

const PACKAGE_NAME_MESSAGE_TYPE_SEPARATOR* = "/"
const COMMENT_DELIMITER* = "#"
const CONSTANT_SEPARATOR* = "="
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

type
    InvalidSpecification* = object of Exception
    InvalidActionSpecification* = object of InvalidSpecification
    InvalidServiceSpecification* = object of InvalidSpecification
    InvalidResourceName* = object of InvalidSpecification
    InvalidFieldDefinition* = object of InvalidSpecification
    UnknownMessageType* = object of InvalidSpecification
    InvalidValue* = object of Exception

type
    BaseType* = ref object
        pkg_name*: string
        typ*: string
        string_upper_bound*: int
    Type* = ref object
        is_array*: bool
        array_size*: bool
        is_upper_bound*: bool

    Constant* = ref object

    Field* = ref object
        name*: string
        typ*: Type

proc is_valid_package_name(name: string): bool =
    if name =~ VALID_PACKAGE_NAME_PATTERN:
        return matches[0] == name


proc is_valid_field_name(name: string): bool =
    if name =~ VALID_FIELD_NAME_PATTERN:
        return matches[0] == name


proc is_valid_message_name(name: string): bool =
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


proc is_valid_constant_name(name: string): bool =
    if name =~ VALID_CONSTANT_NAME_PATTERN:
        return matches[0] == name

proc new*(typ: typedesc[BaseType], type_string: string, context_package_name=""): BaseType =
    new result
    # check for primitive types
    if type_string in PRIMITIVE_TYPES:
        result.pkg_name = ""
        result.typ = type_string
        result.string_upper_bound = -1

    elif type_string.startswith("string%s" % STRING_UPPER_BOUND_TOKEN) or
            type_string.startswith("wstring%s" % STRING_UPPER_BOUND_TOKEN):
        result.pkg_name = ""
        result.typ = type_string.split(STRING_UPPER_BOUND_TOKEN, 1)[0]
        let upper_bound_string = type_string[len(result.typ) +
                                          len(STRING_UPPER_BOUND_TOKEN) .. ^1]

        var ex = newException(TypeError, ("the upper bound of the string type "%s" must " &
                        "be a valid integer value > 0") % [type_string])
        try:
            result.string_upper_bound = int(upper_bound_string)
        except ValueError:
            raise ex
        if result.string_upper_bound <= 0:
            raise ex

    else:
        # split non-primitive type information
        let parts = type_string.split(PACKAGE_NAME_MESSAGE_TYPE_SEPARATOR)
        if not (len(parts) == 2 or
                (len(parts) == 1 and context_package_name isnot "")):
            raise newException(InvalidResourceName, type_string)

        if len(parts) == 2:
            # either the type string contains the package name
            result.pkg_name = parts[0]
            result.typ = parts[1]
        else:
            # or the package name is provided by context
            result.pkg_name = context_package_name
            result.typ = type_string
        if not is_valid_package_name(result.pkg_name):
            raise InvalidResourceName(
                "'$1' is an invalid package name. It should have the pattern '$2'" % [
                    result.pkg_name, VALID_PACKAGE_NAME_PATTERN.pattern])
        if not is_valid_message_name(result.type):
            raise InvalidResourceName(
                "'$1' is an invalid message name. It should have the pattern '$2'" % [
                    result.type, VALID_MESSAGE_NAME_PATTERN.pattern])

        result.string_upper_bound = -1
