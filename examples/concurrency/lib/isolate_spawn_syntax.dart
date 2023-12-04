import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

// #docregion
class BackgroundWorker {
  final Isolate _isolate;
  final SendPort _workerIsolateSendPort;

  static Future<BackgroundWorker> initialize() async {
    final mainIsolateReceivePort = ReceivePort();
    late SendPort workerIsolateSendPort;

    await mainIsolateReceivePort.forEach((dynamic message) {
      if (message is SendPort) {
        workerIsolateSendPort = message;
      } else if (message is String) {
        /// Receive messages from the worker isolate
        /// Domain specific code goes here
        print(message);
      }
    });

    var isolate = await Isolate.spawn<SendPort>(
      _workerIsolateEntryPoint,
      mainIsolateReceivePort.sendPort,
    );

    return BackgroundWorker._(
      isolate,
      workerIsolateSendPort,
    );
  }

  void send(String message) {
    _workerIsolateSendPort.send(message);
  }

  BackgroundWorker._(
    this._isolate,
    this._workerIsolateSendPort,
  );

  static Future<void> _workerIsolateEntryPoint(
    SendPort sendPortToMainApp,
  ) async {
    final receivePortInSpawnedIsolate = ReceivePort();
    sendPortToMainApp.send(receivePortInSpawnedIsolate.sendPort);

    await for (var message in receivePortInSpawnedIsolate) {
      if (message is String) {
        final dartObjects = jsonDecode(message);
        sendPortToMainApp.send(dartObjects);
      }
      if (message == null) {
        // Protocol for exiting.
        receivePortInSpawnedIsolate.close();
        break;
      } else {
        // Will terminate isolate.
        throw UnsupportedError(
            'Message sent to isolate port has an unexpected type: $message');
      }
    }
  }

  void dispose() {
    _isolate.kill();
  }
}

// Elsewhere in app
void startProcessInBackground(String jsonBlob) async {
  var backgroundWorker = await BackgroundWorker.initialize();
  backgroundWorker.send(jsonBlob);
}
// #enddocregion
