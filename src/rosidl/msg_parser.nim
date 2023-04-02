import std / [strutils, strformat, sequtils, tables, options]
import regex, patty
export options, tables

import primitives_parser
export primitives_parser

## Parse Messages
## 

type
    MessageSpecification* = ref object
        base_type*: BaseType
        msg_name*: string
        fields*: seq[Field]
        constants*: seq[Constant]
        annotations*: Table[string, seq[string]]

proc newMessageSpecification*(pkg_name, msg_name: string, fields: seq[Field], constants: seq[Constant]): MessageSpecification =
    new result
    result.base_type = newBaseType(pkg_name & PACKAGE_NAME_MESSAGE_TYPE_SEPARATOR & msg_name)
    result.msg_name = msg_name
    result.fields = fields
    result.constants = constants

    template checkDupes(fields, named: untyped) =
        let
            field_names = fields.mapIt(it.name)
            duplicate_field_names = toCountTable(field_names)
        
        var dupes: seq[string]
        for f, c in duplicate_field_names:
            if c > 1: dupes.add f
        
        if dupes.len() > 0:
            raise newException(ValueError,
                    "the $1 iterable contains duplicate names: $2" % [named, dupes.join(",")])
    
    fields.checkDupes("fields")
    constants.checkDupes("consts")

proc `$`*(self: MessageSpecification): string =
    ## """Output an equivalent .msg IDL string."""
    result = "# " & $(self.base_type) & "\n"
    for constant in self.constants:
        result.add($(constant))
        result.add("\n")
    for field in self.fields:
        result.add($(field))
        result.add("\n")
    # Get rid of last newline
    result.stripLineEnd()
    
proc process_comments(instance: BaseField or MessageSpecification) =
    if "comment" in instance.annotations:
        var lines = instance.annotations["comment"]

        # look for a unit in brackets
        # the unit should not contains a comma since it might be a range
        let
            comment = lines.join("\n")
            matches = comment.findall(re"(\s*\[([^,\]]+)\])")
        
        # echo "MATCHES: ", matches
        
        if len(matches) == 1:
            ## checkme
            # echo "MATCH[0]: ", matches[0]
            let comment = matches[0].groupFirstCapture(1, comment)
            instance.annotations.mgetOrPut("unit", @[]).add(comment)
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


proc extract_file_level_comments*(message_string: string): (seq[string], seq[string]) =
    var lines = message_string.splitlines()
    var index = 0
    for idx, line in lines:
        # var line = line.strip()
        var line = line
        if line.startsWith(COMMENT_DELIMITER):
            line.removePrefix(COMMENT_DELIMITER)
            result[0].add line
        else:
            index = idx
            break
    for idx in index..lines.high:
        result[1].add lines[idx]

proc parse_message_string*(pkg_name, msg_name, message_string: string): MessageSpecification =
    var
        fields: seq[Field]
        constants: seq[Constant]
        message_string = message_string.replace("\t", " ")
    
    let
        (message_comments, lines) = extract_file_level_comments(message_string)
    
    # echo "(message_comments, lines) ", (message_comments, lines)

    var
        current_comments: seq[string]
        last_element: BaseField

    for line in lines:
        var line = line.strip(leading=false, trailing=true, Whitespace)

        # ignore empty lines
        if line == "":
            # file-level comments stop at the first empty line
            # echo "found empty line, end file level comments"
            continue

        var index = line.find(COMMENT_DELIMITER)
        # echo "INDEX: ", index

        # comment
        var comment = string.none
        if index >= 0:
            comment = some line[index..^1].lstrip({COMMENT_DELIMITER})
            line = line[0..<index]

        # echo "LINE COMMENT: ", comment
        if comment.isSome:
            # echo "found line comment: ", repr line
            if line != "" and line.strip() == "":
                # indented comment line
                # append to previous field / constant if available or ignore
                if not last_element.isNil:
                    last_element.annotations.mgetOrPut("comment", @[]).add(comment.get)
                # echo "skip comment indented..."
                continue
            # collect "unused" comments
            current_comments.add(comment.get)

            line = line.strip(leading=false, trailing=true)
            if line == "":
                # echo "ignore empty line"
                continue

        let (typstring, mrest) = line.partition(" ")
        var rest = mrest.lstrip()

        if rest == "":
            raise newException(InvalidFieldDefinition, line)

        index = rest.find(CONSTANT_SEPARATOR)
        if index == -1:
            # line contains a field
            # echo "found field"
            let (field_name, mdefault_value_string) = rest.partition(" ")
            let default_value_string = mdefault_value_string.lstrip()
            try:
                fields.add(newField(
                    newType(typstring, context_package_name=pkg_name),
                    field_name, default_value_string))
            except Exception as err:
                # echo( fmt"Error processing "{line}" of "{pkg}/{msg}": "{err}"",)
                raise err
            last_element = fields[^1]

        else:
            # line contains a constant
            var (name, value) = rest.partition($CONSTANT_SEPARATOR)
            name = name.rstrip()
            value = value.lstrip()
            constants.add(newConstant(typstring, name, value))
            last_element = constants[^1]

        # add "unused" comments to the field / constant
        # echo "CURRENT_COMMENTS: ", current_comments
        last_element.annotations.mgetOrPut("comment", @[]).add current_comments
        current_comments = @[]

    var msg = newMessageSpecification(pkg_name, msg_name, fields, constants)
    msg.annotations["comment"] = message_comments

    # condense comment lines, extract special annotations
    process_comments(msg)
    for field in fields:
        process_comments(field)
    for constant in constants:
        process_comments(constant)

    return msg

type
    ServiceSpecification* = ref object
        pkg_name*: string
        srv_name*: string
        request*: MessageSpecification
        response*: MessageSpecification

proc newServiceSpecification*(
        pkg_name, srv_name: string,
        request, response: MessageSpecification
): ServiceSpecification =
    new result
    result.pkg_name = pkg_name
    result.srv_name = srv_name
    result.request = request
    result.response = response

proc `$`*(self: ServiceSpecification): string =
    ## """Output an equivalent .srv IDL string."""
    result = ["# ", $(self.pkg_name), "/", $(self.srv_name), "\n"].join("")
    result.add($(self.request))
    result.add("\n---\n")
    result.add($(self.response))

proc parse_service_string*(pkg_name, srv_name, message_string: string): ServiceSpecification =
    var lines = message_string.splitlines()
    # var separator_indices = [
    #     index for index, line in enumerate(lines) if line == SERVICE_REQUEST_RESPONSE_SEPARATOR]
    var separator_indices: seq[int]
    for index, line in lines:
        if line == SERVICE_REQUEST_RESPONSE_SEPARATOR:
            separator_indices.add index

    if separator_indices.len == 0:
        raise newException(InvalidServiceSpecification,
            "Could not find separator '%s' between request and response" %
            SERVICE_REQUEST_RESPONSE_SEPARATOR)

    if len(separator_indices) != 1:
        raise newException(InvalidServiceSpecification,
            "Could not find unique separator '%s' between request and response" %
            SERVICE_REQUEST_RESPONSE_SEPARATOR)

    var request_message_string = join(lines[0..<separator_indices[0]], "\n")
    var request_message = parse_message_string(
        pkg_name, srv_name & SERVICE_REQUEST_MESSAGE_SUFFIX, request_message_string)

    var response_message_string = join(lines[separator_indices[0] + 1 .. ^1], "\n")
    var response_message = parse_message_string(
        pkg_name, srv_name & SERVICE_RESPONSE_MESSAGE_SUFFIX, response_message_string)

    result = ServiceSpecification(
                pkg_name: pkg_name,
                srv_name: srv_name,
                request: request_message,
                response: response_message)


type
    ActionSpecification* = ref object
        pkg_name*: string
        action_name*: string
        goal*: MessageSpecification
        result*: MessageSpecification
        feedback*: MessageSpecification

proc newActionSpecification*(
        pkg_name, action_name: string,
        goal, results, feedback: MessageSpecification
): ActionSpecification =
    result.pkg_name = pkg_name
    result.action_name = action_name
    result.goal = goal
    result.result = results
    result.feedback = feedback

proc parse_action_string*(pkg_name, action_name, action_string: string): ActionSpecification =
    var lines = action_string.splitlines()
    # var separator_indices = [
    #     index for index, line in enumerate(lines) if line == ACTION_REQUEST_RESPONSE_SEPARATOR]
    var separator_indices: seq[int]
    for index, line in lines:
        if line == ACTION_REQUEST_RESPONSE_SEPARATOR:
            separator_indices.add index
    
    if len(separator_indices) != 2:
        raise newException(InvalidActionSpecification,
            "Number of '%s' separators nonconformant with action definition" %
            ACTION_REQUEST_RESPONSE_SEPARATOR)

    var goal_string = join(lines[0..<separator_indices[0]], "\n")
    var result_string = join(lines[separator_indices[0] + 1 ..< separator_indices[1]], "\n")
    var feedback_string = join(lines[separator_indices[1] + 1 .. ^1], "\n")

    var goal_message = parse_message_string(
        pkg_name, action_name & ACTION_GOAL_SUFFIX, goal_string)
    var result_message = parse_message_string(
        pkg_name, action_name & ACTION_RESULT_SUFFIX, result_string)
    var feedback_message = parse_message_string(
        pkg_name, action_name & ACTION_FEEDBACK_SUFFIX, feedback_string)
    # ---------------------------------------------------------------------------------------------
    return ActionSpecification(pkg_name: pkg_name,
                                action_name: action_name,
                                goal: goal_message,
                                result: result_message,
                                feedback: feedback_message)

import os

proc parse_message_file*(message_filename: string, pkg_name = ""): MessageSpecification =
    var msg_name = splitFile(message_filename).name
    var pkg_name = pkg_name
    if pkg_name == "":
        pkg_name = message_filename.splitFile.dir.parentDir.lastPathPart()

    var h = open(message_filename)
    return parse_message_string(pkg_name, msg_name, h.readAll())

proc parse_service_file*(pkg_name, interface_filename: string): ServiceSpecification =
    var srv_name = splitFile(interface_filename).name
    var pkg_name = pkg_name
    if pkg_name == "":
        pkg_name = splitFile(interface_filename).dir.lastPathPart()

    var h = open(interface_filename)
    return parse_service_string( pkg_name, srv_name, h.readAll())

proc parse_action_file*(pkg_name, interface_filename: string): ActionSpecification =
    var action_name  = splitFile(interface_filename).name
    var pkg_name = pkg_name
    if pkg_name == "":
        pkg_name = splitFile(interface_filename).dir.lastPathPart()
    var h = open(interface_filename)
    return parse_action_string(pkg_name, action_name, h.readAll())