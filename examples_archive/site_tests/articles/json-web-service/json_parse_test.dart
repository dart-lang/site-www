import 'dart:convert';

main() {
  String listAsJson = '["Dart",0.8]'; // input List of data
  List parsedList = JSON.decode(listAsJson);
  print(parsedList[0]); // Dart
  print(parsedList[1]); // 0.8

  String mapAsJson = '{"language":"dart"}';  // input Map of data
  Map parsedMap = JSON.decode(mapAsJson);
  print(parsedMap["language"]); // dart
}