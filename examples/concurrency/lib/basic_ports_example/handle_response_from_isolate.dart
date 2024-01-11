// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

// #docregion
class Worker {
  late SendPort _sendPort;

  // spawn method

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
    } else if (message is Map<String, dynamic>) {
      print(message);
    }
  }

// rest of class..
// #enddocregion

  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
  }

  static void _startRemoteIsolate(SendPort port) {
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    receivePort.listen((dynamic message) async {
      final decoded = jsonDecode(message as String);
      port.send(decoded);
    });
  }

  Future<void> parseJson(String message) async {
    // TODO: Define a public method that can
    // be used to send messages to the worker isolate.
  }
}
