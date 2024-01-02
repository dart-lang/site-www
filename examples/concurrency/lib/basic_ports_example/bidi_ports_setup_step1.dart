import 'dart:async';
import 'dart:isolate';

Future<void> startWorker() async {
  // Step 1a: Create local port.
  final initPort = RawReceivePort();

  // Step 1b: Be ready to receive remote send-port, and repurpose the initial receive port.
  final connection = Completer<(ReceivePort, SendPort)>.sync();
  initPort.handler = (initialMessage) {
    final commandPort = initialMessage as SendPort;
    // (Create `ReceivePort` immediately, it buffers any events that arrive
    // before it's listened to.)
    connection
        .complete((ReceivePort.fromRawReceivePort(initPort), commandPort));
  };

  // Step 1c: Start remote isolate, passing send port to it.
  //          If that fails, report the error and clean up.
  try {
    await Isolate.spawn(_remoteStartUp, initPort.sendPort);
  } on Object {
    initPort.close();
    rethrow;
  }

  // Step 1d: Wait for the send port.
  final (ReceivePort responsePort, SendPort commandPort) =
      await connection.future;

  // Now have SendPort and ReceivePort in local isolate.
}

/// Code run by [Isolate.spawn] in new isolate.
void _remoteStartUp(SendPort responsePort) {
  final ReceivePort commandPort = ReceivePort();
  responsePort.send(commandPort.sendPort);
  // Now have SendPort and ReceivePort in remote isolate.
}
