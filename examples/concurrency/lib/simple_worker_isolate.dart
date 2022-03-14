import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

const String filename = 'with_keys.json';

// #docregion main
void main() async {
  // Read some data.
  final jsonData = await _parseInBackground();

  // Use that data
  print('Number of JSON keys: ${jsonData.length}');
}

// Spawns an isolate and waits for the first message
Future<Map<String, dynamic>> _parseInBackground() async {
  final p = ReceivePort();
  await Isolate.spawn(_readAndParseJson, p.sendPort);
  return await p.first as Map<String, dynamic>;
}
// #enddocregion main

// #docregion spawned
Future<void> _readAndParseJson(SendPort p) async {
  final fileData = await File(filename).readAsString();
  final jsonData = jsonDecode(fileData);
  Isolate.exit(p, jsonData);
}
// #enddocregion spawned
