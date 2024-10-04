import 'dart:io';

import 'mixing_errors_util.dart';

// #docregion parse
Future<int> parseAndRead(Map<String, dynamic> data) {
  return Future.sync(() {
    final filename = obtainFilename(data); // Could throw.
    final file = File(filename);
    return file.readAsString().then((contents) {
      return parseFileData(contents); // Could throw.
    });
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
//   Inside catchError
//   <error from obtainFilename>
// #enddocregion main
