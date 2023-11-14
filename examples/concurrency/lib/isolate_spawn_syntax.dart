import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

// #docregion
class BackgroundWorker {
  late Isolate _isolate;
  late SendPort workerIsolateSendPort;

  Future<void> initIsolate() async {
    // Create a recieve port to recieve messages from spawned isolate
    final mainIsolateReceivePort = ReceivePort();
    mainIsolateReceivePort.listen((dynamic message) {
      if (message is SendPort) {
        workerIsolateSendPort = message;
      } else if (message is String) {
        print(message);
      }
    });

    _isolate = await Isolate.spawn(
      _workerIsolateEntryPoint,
      mainIsolateReceivePort.sendPort,
    );
  }

  static void _workerIsolateEntryPoint(dynamic message) {
    final receivePortInSpawnedIsolate = ReceivePort();
    late SendPort sendPortToMainApp;

    if (message is SendPort) {
      sendPortToMainApp = message;
      sendPortToMainApp.send(receivePortInSpawnedIsolate.sendPort);
    }

// This listener callback will be called each time a subsequent message
// is sent from the main isolate to the worker isolate
    receivePortInSpawnedIsolate.listen((dynamic message) async {
      if (message is String) {
        final dartObjects = jsonDecode(message);
        sendPortToMainApp.send(dartObjects);
      } else {
        throw const SocketException(
            'Message sent to isolate port has an unexpected type');
      }
    });
  }

  void dispose() {
    _isolate.kill();
  }
}

// Elsewhere in app
void startProcessInBackground(String jsonBlob) {
  BackgroundWorker().workerIsolateSendPort.send(jsonBlob);
}
// #enddocregion
