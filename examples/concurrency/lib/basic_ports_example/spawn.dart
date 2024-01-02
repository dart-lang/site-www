// ignore_for_file: unused_field

import 'dart:async';
import 'dart:isolate';

class Worker {
  // #docregion
  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
  }
  // #enddocregion

  void _handleResponsesFromIsolate(dynamic message) {
    // TODO: Define code that should be executed on the worker isolate.
  }

  static void _startRemoteIsolate(SendPort port) {
    // TODO: Handle messages sent back from the worker isolate.
  }

  Future<void> parseJson(String message) async {
    // TODO: Define a public method that can
    // be used to send messages to the worker isolate.
  }
}
