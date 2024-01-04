// ignore_for_file: unused_field, body_might_complete_normally_nullable, unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

// #docregion vars
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
// #enddocregion vars

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
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, message));
    return await completer.future;
  }
// #enddocregion parse-json

// #docregion constructor
  Worker._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }
// #enddocregion constructor

// #docregion handle-response
  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object? response) = message as (int, Object?); // New
    final completer = _activeRequests.remove(id)!; // New

    if (response is RemoteError) {
      completer.completeError(response); // Updated
    } else {
      completer.complete(response); // Updated
    }
  }
// #enddocregion handle-response

// #docregion handle-commands
  static void _handleCommandsToIsolate(
      ReceivePort receivePort, SendPort sendPort) {
    receivePort.listen((message) {
      final (int id, String jsonText) = message as (int, String); // New
      try {
        final jsonData = jsonDecode(jsonText);
        sendPort.send((id, jsonData)); // Updated
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
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
