// Step 2: Decide on how to use the receive/send ports.
// This example leaves it to the user, by returning the local port-pair,
// and letting them provide a function to use the remote port-pair.
// (Could also return the new `Isolate`, if we have a use for it.
// Or send a reference to the current isolate to the other new isolate,
// to keep symmetry.)

// Step 2a: Update API to return local port-pair,
//          and accept a function that gets the remote port-pair.
import 'dart:async';
import 'dart:isolate';

Future<(ReceivePort responsePort, SendPort commandPort)> startWorker(
    void Function(ReceivePort commandPort, SendPort responsePort)
        workerCode) async {
  final initPort = RawReceivePort();
  final connection = Completer<(ReceivePort, SendPort)>.sync();
  initPort.handler = (initialMessage) {
    final commandPort = initialMessage as SendPort;
    connection
        .complete((ReceivePort.fromRawReceivePort(initPort), commandPort));
  };

  try {
    // Step 2b: Pass the remote worker code to the remote isolate too,
    //          along with the response send-port.
    await Isolate.spawn(_remoteStartUp, (workerCode, initPort.sendPort));
  } on Object {
    initPort.close();
    rethrow;
  }

  // Step 2c:
  // Return the local port-pair as promised.
  return await connection.future;
}

/// Code run by [Isolate.spawn] in new isolate.
void _remoteStartUp(
    (
      void Function(ReceivePort, SendPort) workerCode,
      SendPort responsePort
    ) message) {
  final (workerCode, responsePort) = message;
  final ReceivePort commandPort = ReceivePort();
  responsePort.send(commandPort.sendPort);
  // Step 2d: Run the user function in the remote isolate, after the port-pair is ready.
  workerCode(commandPort, responsePort);
}
