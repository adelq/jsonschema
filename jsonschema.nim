import json
import strutils
import re

type ValidationError = object of ValueError

proc validate(node: JsonNode, schema: JsonNode) =
  discard

proc items(item_list: seq[JsonNode], node: JsonNode, schema: JsonNode) =
  let instance = node.getElems()
  for index, value in pairs(instance):
    validate(value, schema)

proc minimum(minimum: float, node: JsonNode, schema: JsonNode) =
  var
    failed: bool
    cmp: string
  let instance = node.getFNum()
  if getBVal(schema["exclusiveminimum"]):
    failed = instance <= minimum
    cmp = "less than or equal to"
  else:
    failed = instance < minimum
    cmp = "less than"
  if failed:
    raise newException(
      ValidationError,
      "$# is $# the minimum of $#".format(instance, cmp, minimum))

proc maximum(maximum: float, node: JsonNode, schema: JsonNode) =
  var
    failed: bool
    cmp: string
  let instance = node.getFNum()
  if getBVal(schema["exclusiveMaximum"]):
    failed = instance >= maximum
    cmp = "greater than or equal to"
  else:
    failed = instance > maximum
    cmp = "greater than"
  if failed:
    raise newException(
      ValidationError,
      "$# is $# the maximum of $#".format(instance, cmp, maximum))

proc pattern(pattern: string, node: JsonNode, schema: JsonNode) =
  if not getStr(node).contains(pattern):
    raise newException(ValidationError, "$# does not match $#".format(node, $pattern))
