import 'dart:async';
import 'dart:isolate';

class BackgroundWorker {
  BackgroundWorker() {
    _initIsolate();
  }

  late Isolate _isolate;

  Future<void> _initIsolate() async {
    // This receive port will receive messages from the spawned worker
    // isolate that are put into the [sendPortToMainIsolate].
    final mainIsolateReceivePort = ReceivePort();

    // This send port is sent to the spawned isolate, so the isolate can put
    // messages in, which will emit from the [receivePortFromIsolate].
    final sendPortToMainIsolate = mainIsolateReceivePort.sendPort;

    // When a message is passed from the worker isolate to the
    // [mainIsolateReceivePort], the [_handleMessageToMainIsolate] callback
    // is called with the message as an argument.
    mainIsolateReceivePort.listen(_handleMessageToMainIsolate);

    // Spawn the worker isolate.
    // The first argument passed to Isolate.spawn is a callback, which will
    // be called whenever a message is sent from the main isolate to the
    // worker isolate, via the [SendPort.send] method.
    // The second argument passed is the message that will be sent via
    // [SendPort.send]. In this case, I'm sending the sendPort that the
    // worker isolate will need to send messages back to the main isolate
    _isolate = await Isolate.spawn(
      _workerIsolateEntryPoint,
      sendPortToMainIsolate,
    );
  }

// This method will handle messages that are sent from the worker isolate back to the main isolate
  void _handleMessageToMainIsolate(dynamic message) {}

// This method will handle messages that are sent from the main isolate to the worker
  static void _workerIsolateEntryPoint(dynamic message) {}
}
