// ignore_for_file: constant_identifier_names, non_constant_identifier_names, type_annotate_public_apis
import 'dart:math';

// #docregion const-names
const PI = 3.14;
const kDefaultTimeout = 1000;
final URL_SCHEME = new RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = new Random();
}
// #enddocregion const-names

oneLineIf(dynamic overflowChars, dynamic other) {
  // #docregion one-line-if-wrap
  if (overflowChars != other.overflowChars)
    return overflowChars < other.overflowChars;
  // #enddocregion one-line-if-wrap
}
