import 'dart:io';

import 'mixing_errors_util.dart';

// #docregion parse
Future<int> parseAndRead(Map<String, dynamic> data) {
  return Future.sync(() {
    final fileName = obtainFileName(data); // Could throw.
    final file = File(fileName);
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
  });
}

// Program Output:
//   Inside catchError
//   <error from obtainFileName>
// #enddocregion main
