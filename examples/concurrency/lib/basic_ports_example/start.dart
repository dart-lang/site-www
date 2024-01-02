// ignore_for_file: unused_field, unused_element
import 'dart:isolate';

// #docregion
class Worker {
  Future<void> spawn() async {
    // TODO: Add functionality to spawn a worker isolate.
  }

  void _handleResponsesFromIsolate(dynamic message) {
    // TODO: Define code that should be executed on the worker isolate.
  }

  static void _startRemoteIsolate(SendPort port) {
    // TODO: Handle messages sent back from the worker isolate.
  }

  Future parseJson(String message) async {
    // TODO: Define a public method that can
    // be used to send messages to the worker isolate.
  }
}
// #enddocregion
