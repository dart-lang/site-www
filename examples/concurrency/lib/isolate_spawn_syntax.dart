import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

// #docregion
class Worker {
  late SendPort _sendPort;
  final Completer<void> _isolateReady = Completer.sync();

  Future<void> parseJson(String message) async {
    await _isolateReady.future;
    _sendPort.send(message);
  }

  Future<void> spawn(Function(Map<String, dynamic>) onReceiveMessage) async {
    final receivePort = ReceivePort();
    receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        _isolateReady.complete();
      } else if (message is Map<String, dynamic>) {
        onReceiveMessage(message);
      }
    });
    await Isolate.spawn(_readAndComputeOnIsolate, receivePort.sendPort);
  }

  static void _readAndComputeOnIsolate(SendPort port) {
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    receivePort.listen((dynamic message) async {
      if (message is String) {
        final decoded = jsonDecode(message);
        port.send(decoded);
      }
    });
  }
}
// #enddocregion

// This method represents your app-specific functionality.
// After the Isolate decodes a large bit of json, it will be received here
void onReceiveMessage(Map<String, dynamic> message) {
  print(message);
}

void main() async {
  final worker = Worker();
  await worker.spawn(onReceiveMessage);
  await worker.parseJson('{"key":"value"}');
}
