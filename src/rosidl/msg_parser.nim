import std / [strutils, strformat, re, tables]

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
        value*: bool
        annotations*: Table[string, seq[string]]

    Field* = ref object
        name*: string
        typ*: Type

proc is_primitive_type*(self: BaseType): bool =
    return self.pkg_name == ""

proc is_dynamic_array*(self: Type): bool =
    return self.is_array and (self.array_size > -1 or self.is_upper_bound)

proc is_fixed_size_array*(self: Type): bool =
    return self.is_array and self.array_size > -1 and not self.is_upper_bound

proc newBaseType*(type_string: string, context_package_name=""): BaseType =
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

        var ex = newException(ValueError, ("the upper bound of the string type '$1' must " &
                        "be a valid integer value > 0") % [type_string])
        try:
            result.string_upper_bound = parseInt(upper_bound_string)
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
            raise newException(InvalidResourceName,
                "'$1' is an invalid package name. " % [result.pkg_name])
        if not is_valid_message_name(result.typ):
            raise newException(InvalidResourceName,
                "'$1' is an invalid message name." % [result.typ])

        result.string_upper_bound = -1

proc newType*(type_string: string, context_package_name=""): Type =
    new result
    # check for array brackets
    var type_string = type_string
    result.is_array = type_string[-1] == ']'

    result.array_size = -1
    result.is_upper_bound = false
    if result.is_array:
        let index: int = type_string.find('[')
        if index == -1:
            raise newException(ValueError, ("the type ends with ']' but does not " &
                            "contain a '['") % [type_string])
        var array_size_string = type_string[index + 1..^1]
        # get array limit
        if array_size_string != "":

            # check if the limit is an upper bound
            result.is_upper_bound = array_size_string.startswith(
                ARRAY_UPPER_BOUND_TOKEN)
            if result.is_upper_bound:
                array_size_string = array_size_string[
                    len(ARRAY_UPPER_BOUND_TOKEN)..^1]

            let ex = newException(ValueError, (
                "the size of array type '$1' must be a valid integer " &
                "value > 0 optionally prefixed with '$2' if it is only " &
                "an upper bound") %
                [ARRAY_UPPER_BOUND_TOKEN, type_string])
            try:
                result.array_size = parseInt(array_size_string)
            except ValueError:
                raise ex
            # check valid range
            if result.array_size <= 0:
                raise ex

        type_string = type_string[0..<index]

    result.base = newBaseType(
        type_string,
        context_package_name=context_package_name)

proc newConstant*(primitive_type, name, value_string: string): Constant =
    if primitive_type notin PRIMITIVE_TYPES:
        raise newException(ValueError,
                        "the constant type '$1' must be a primitive type" %
                        [primitive_type])
    result.typ = primitive_type
    if not is_valid_constant_name(name):
        raise newException(ValueError, "'{}' is an invalid constant name." % [name])
    result.name = name
    if value_string is "":
        raise newException(ValueError, "the constant value must not be 'None'")

    result.value = parse_primitive_value_string(
        newType(primitive_type), value_string)




