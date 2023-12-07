import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

// #docregion
class BackgroundWorker {
  final Isolate _isolate;
  final ReceivePort _mainIsolateReceivePort;
  final SendPort _workerIsolateSendPort;

  /// Initialize the background worker isolate, and define how to handle
  /// future messages received from that isolate
  static Future<(Isolate, ReceivePort, SendPort)> _startWorker() async {
    final mainIsolateReceivePort = ReceivePort();
    final connection = Completer<SendPort>();

    mainIsolateReceivePort.listen((dynamic message) {
      if (message is SendPort) {
        connection.complete(message);
      } else if (message is String) {
        /// Receive messages from the worker isolate
        /// Domain specific code goes here
        print(message);
      }
    });

    final Isolate isolate;
    try {
      isolate = await Isolate.spawn<SendPort>(
        _workerIsolateEntryPoint,
        mainIsolateReceivePort.sendPort,
      );
    } on Object {
      mainIsolateReceivePort.close();
      rethrow;
    }

    final workerIsolateSendPort = await connection.future;
    return (isolate, mainIsolateReceivePort, workerIsolateSendPort);
  }

  BackgroundWorker._(
    this._isolate,
    this._mainIsolateReceivePort,
    this._workerIsolateSendPort,
  );

  /// Code executed on the spawned isolate
  static Future<void> _workerIsolateEntryPoint(
    SendPort sendPortToMainApp,
  ) async {
    final receivePortInSpawnedIsolate = ReceivePort();
    sendPortToMainApp.send(receivePortInSpawnedIsolate.sendPort);

    await for (var message in receivePortInSpawnedIsolate) {
      if (message is String) {
        final dartObjects = jsonDecode(message);
        sendPortToMainApp.send(dartObjects);
      } else if (message == null) {
        receivePortInSpawnedIsolate.close();
        break;
      } else {
        // Will terminate isolate.
        throw UnsupportedError(
            'Message sent to isolate port has an unexpected type: $message');
      }
    }
  }

  /*
      Public facing API
   */
  /// Public factory constructor
  static Future<BackgroundWorker> spawn() async {
    final (isolate, receivePort, sendPort) = await _startWorker();
    return BackgroundWorker._(
      isolate,
      receivePort,
      sendPort,
    );
  }

  Future<void> parse(String message) async {
    _workerIsolateSendPort.send(message);
  }

  void close() {
    _mainIsolateReceivePort.close();
  }
}

// Elsewhere in app
void parseJsonInBackground() async {
  var backgroundWorker = await BackgroundWorker.spawn();
  await backgroundWorker.parse('{"key": "value"}');
  backgroundWorker.close();
}
// #enddocregion

void main() {
  parseJsonInBackground();
}
