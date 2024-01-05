// ignore_for_file: unused_field, body_might_complete_normally_nullable, unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

// #docregion constructor
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;
// #enddocregion constructor
  static Future<Worker> spawn() async {
    // Create a receive port and add its initial message handler
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };
    // Spawn the isolate.
    try {
      await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return Worker._(receivePort, sendPort);
  }

// #docregion parse-json
  Future<Object?> parseJson(String message) async {
    _commands.send(message);
  }
// #enddocregion parse-json

// #docregion constructor
  Worker._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }
// #enddocregion constructor

// #docregion handle-response
  void _handleResponsesFromIsolate(dynamic message) {
    if (message is RemoteError) {
      throw message;
    } else {
      print(message);
    }
  }
// #enddocregion handle-response

// #docregion handle-commands
  static void _handleCommandsToIsolate(
      ReceivePort receivePort, SendPort sendPort) {
    receivePort.listen((message) {
      try {
        final jsonData = jsonDecode(message as String);
        sendPort.send(jsonData);
      } catch (e) {
        sendPort.send(RemoteError(e.toString(), ''));
      }
    });
  }
// #enddocregion handle-commands

// #docregion start-isolate
  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }
// #enddocregion start-isolate
}
