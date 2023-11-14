// ignore_for_file: unused_element
import 'dart:io';

// #docregion
Future<String> _readFileAsync(String filename) {
  final file = File(filename);

  // .then() returns a Future
  return file.readAsString().then((contents) {
    return contents.trim();
  });
}
// #enddocregion
