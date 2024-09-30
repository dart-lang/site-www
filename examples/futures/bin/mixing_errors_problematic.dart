// ignore_for_file: strict_raw_type, unused_local_variable

import 'dart:io';

import 'package:examples_util/ellipsis.dart';

import 'mixing_errors_util.dart';

// #docregion parse
Future<int> parseAndRead(Map<String, dynamic> data) {
  final filename = obtainFilename(data); // Could throw.
  final file = File(filename);
  return file.readAsString().then((contents) {
    return parseFileData(contents); // Could throw.
  });
}
// #enddocregion parse

// #docregion main
void main() {
  parseAndRead(data).catchError((e) {
    print('Inside catchError');
    print(e);
    return -1;
  });
}

// Program Output:
//   Unhandled exception:
//   <error from obtainFilename>
//   ...
// #enddocregion main

// #docregion fragile
Future fragileFunc() {
  return Future.sync(() {
    final x = someFunc(); // Unexpectedly throws in some rare cases.
    var y = 10 / x; // x should not equal 0.
    ellipsis();
  });
}
// #enddocregion fragile
