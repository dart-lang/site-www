import 'dart:convert';
import 'dart:io';

const String filename = 'with_keys.json';

// #docregion
void main() {
  // Read some data.
  final fileData = _readFileSync(filename);
  final jsonData = jsonDecode(fileData);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}

String _readFileSync(String filename) {
  final file = File(filename);
  final contents = file.readAsStringSync();
  return contents.trim();
}
// #enddocregion
