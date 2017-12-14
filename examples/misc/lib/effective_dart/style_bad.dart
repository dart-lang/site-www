// ignore_for_file: constant_identifier_names, non_constant_identifier_names, type_annotate_public_apis
import 'dart:math';

int HTTPConnection, UiHandler, IoStream, HTTPRequest, ID, Db;
List list = <int>[
  // #docregion acronyms-and-abbreviations
  HTTPConnection,
  UiHandler,
  IoStream,
  HTTPRequest,
  ID,
  Db,
  // #enddocregion acronyms-and-abbreviations
];

//----------------------------------------------------------------------------

// #docregion const-names
const PI = 3.14;
const kDefaultTimeout = 1000;
final URL_SCHEME = new RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = new Random();
}
// #enddocregion const-names
