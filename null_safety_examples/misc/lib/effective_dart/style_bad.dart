// ignore_for_file: constant_identifier_names, non_constant_identifier_names, type_annotate_public_apis, curly_braces_in_flow_control_structures
import 'dart:math';

// #docregion const-names
const PI = 3.14;
const DefaultTimeout = 1000;
final URL_SCHEME = RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = Random();
}
// #enddocregion const-names

dynamic oneLineIf(dynamic overflowChars, dynamic other) {
  // #docregion one-line-if-wrap
  if (overflowChars != other.overflowChars)
    return overflowChars < other.overflowChars;
  // #enddocregion one-line-if-wrap
}
