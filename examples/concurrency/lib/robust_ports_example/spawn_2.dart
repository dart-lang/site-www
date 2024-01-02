import 'dart:async';
import 'dart:isolate';

// #docregion
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;

  static Future<Worker> spawn() async {
    // Create a receive port and add it's initial message handler
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };
    // Spawn the isolate
    final Isolate isolate;
    try {
      isolate = await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return Worker._(sendPort, receivePort);
  }
// #enddocregion

  Future<Object?> parseJson(String message) async {
    // TODO: ensure the port is still open
    _commands.send(message);
  }

  Worker._(this._commands, this._responses) {
    // TODO: initialize main isolate receive port listener
  }

  void _handleResponsesFromIsolate(dynamic message) {
    // TODO: Handle messages sent back from the worker isolate.
  }

  static void _handleCommandsToIsolate(ReceivePort rp, SendPort sp) async {
    // TODO: Handle messages sent back from the worker isolate.
  }

  static void _startRemoteIsolate(SendPort sp) {
    // TODO: Initialize worker isolate's ports
  }
}
