import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

void main() async {
  final worker = Worker();
  await worker.spawn();
  await worker.parseJson('{"key":"value"}');
}

// #docregion handleResponses parseJson
class Worker {
  late SendPort _sendPort;
  final Completer<void> _isolateReady = Completer.sync();
// #enddocregion handleResponses parseJson

// #docregion spawn
  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
  }
// #enddocregion spawn

// #docregion handleResponses
  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
    } else if (message is Map<String, dynamic>) {
      print(message);
    }
  }
// #enddocregion handleResponses

// #docregion startRemoteIsolate
  static void _startRemoteIsolate(SendPort port) {
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    receivePort.listen((dynamic message) async {
      if (message is String) {
        final transformed = jsonDecode(message);
        port.send(transformed);
      }
    });
  }
// #enddocregion startRemoteIsolate

// #docregion parseJson
  Future<void> parseJson(String message) async {
    await _isolateReady.future;
    _sendPort.send(message);
  }
// #enddocregion parseJson
}
