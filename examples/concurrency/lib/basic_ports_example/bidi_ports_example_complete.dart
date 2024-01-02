import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'dart:isolate';

/// Creates new isolate and bi-directional ports to communicate between them.
///
/// Calls [remote] in the new isolate, with an incoming command stream -subscription),
/// and a port for sending responses.
/// The command stream is paused, and should be resumed when ready to work.
///
/// Returns a triple of the remote isolate,
/// a stream of responses, connected to the remote response port,
/// and a command send-port connected to the remote command stream.
/// The response stream is paused and should be resumed when ready.
///
/// Further communication is handled entirely by the [remote] function and
/// local code using the returned stream and port.

typedef BackgroundWorkerCommunication = (
  Isolate isolate,
  ReceivePort receivePort,
  SendPort sendPort
);
typedef WorkerInitializationCallback = void Function(
  ReceivePort receivePort,
  SendPort sendPort,
);

/// [startWorker] spawns the new isolate
// RemoteWorker is a function that is executed on the new isolate
Future<BackgroundWorkerCommunication> startWorker(
  WorkerInitializationCallback initRemoteWorker,
) async {
  // TODO(ewindmill) explain difference between RawReceivePort and ReceivePort
  // The receive port used for the initial connection message,
  // and reused for the later two-way communication.

  final initPort = RawReceivePort();

  // Completed when the remote isolate has sent their command send-port.
  final connection = Completer<(ReceivePort, SendPort)>.sync();

  // this callback will be executed when the main thread receives a send port
  // back from the setup port
  // commandPort = send port from spawned isolate

  initPort.handler = (initialMessage) {
    final commandPort = initialMessage as SendPort;
    connection
        .complete((ReceivePort.fromRawReceivePort(initPort), commandPort));
  };

  // If isolate spawn fails, report that error.
  final Isolate isolate;
  try {
    isolate = await Isolate.spawn(
        _remoteStartUp, (initRemoteWorker, initPort.sendPort));
  } on Object {
    initPort.close();
    rethrow;
  }

  // Otherwise wait for the initial message, which must come.
  // responsePort is the port that recieves responses. The replacement of
  // `initPort` above.
  final (ReceivePort responsePort, SendPort commandPort) =
      await connection.future;

  // Now we're ready to receives messages from the other end,
  // and `commandPort` sends messages to them.
  return (isolate, responsePort, commandPort);
}

/// equivalent of "initRemoteWorker" in other examples
/// Initial set-up code run in the remote isolate by [startWorker].
///
/// The `remoteWorker` is the remote-worker code passed to [startWorker].
void _remoteStartUp(
  (
    WorkerInitializationCallback initRemoteWorkerCallback,
    SendPort mainIsolateSentPort
  ) message,
) {
  final (remoteWorker, mainIsolateSentPort) = message;
  final spawnedIsolateReceivePort = ReceivePort();
  mainIsolateSentPort.send(spawnedIsolateReceivePort.sendPort);
  remoteWorker(spawnedIsolateReceivePort, mainIsolateSentPort);
}

/// A service for parsing JSON text in another isolate.
class RemoteJsonParser {
  /// Command token sent to shut down remote isolate.
  static const _shutdownToken = 'shutdown';

  /// Port receiving responses from remote isolate.
  ///
  /// Created by [startWorker].
  final ReceivePort _responses;

  /// Port for sending commands to remote isolate.
  ///
  /// Created by [startWorker].
  final SendPort _commands;

  /// Each request gets a new ID, so responses can be received in any order.
  int _idCounter = 0;

  /// Whether [close] has been called.
  bool _closed = false;

  /// Currently active requests' result completers, indexed by request ID.
  final Map<int, Completer<Object?>> _requests = {};

  RemoteJsonParser._(this._responses, this._commands) {
    _responses.listen(_handleResponse);
  }

  /// Spawn a new isolate running a remote JSON parsing service.
  ///
  /// Returns a `RemoteJsonParser` which provides JSON parsing
  /// happening in the new isolate.
  static Future<RemoteJsonParser> spawn() async {
    // Doesn't use the isolate.
    // Could use `Isolate.kill` if it didn't have a shutdown protocol.
    final (_, responses, commands) = await startWorker(_remoteInit);
    return RemoteJsonParser._(responses, commands);
  }

  /// Handles response from remote isolate.
  ///
  /// Message is always a pair of request ID, and either a [RemoteError]
  /// or a decoded JSON object structure.
  void _handleResponse(dynamic message) {
    final (int id, Object? response) = message as (int, Object?);
    final completer = _requests.remove(id)!;
    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      completer.complete(response);
    }
    if (_closed && _requests.isEmpty) _responses.close();
  }

  /// The remote worker function passed to [startWorker].
  ///
  /// Receives commands on [commands], responds on [responses].
  static void _remoteInit(ReceivePort commands, SendPort responses) {
    // React to incoming commands.
    commands.listen((dynamic message) {
      // Command is either the shutdown token, or pair of ID and JSON text.
      if (message == _shutdownToken) {
        commands.close();
        return;
      }
      final (int id, String jsonText) = message as (int, String);
      try {
        final jsonData = jsonDecode(jsonText);
        responses.send((id, jsonData));
      } catch (e) {
        responses.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  /// Parse [jsonText] in remote isolate.
  ///
  /// Returns the parsed object structure, or throws if parsing failed.
  Future<Object?> parse(String jsonText) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _requests[id] = completer;
    _commands.send((id, jsonText));
    return await completer.future;
  }

  /// Close this remote JSON parser.
  ///
  /// Will end the remote isolate when all prior requrests have been
  /// repsonded to.
  /// The [parse] method cannot be used after calling [close].
  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send(_shutdownToken);
      if (_requests.isEmpty) _responses.close();
    }
  }
}

/// Example usage.
void main() async {
  var rp = await RemoteJsonParser.spawn();
  print(await rp.parse('"banana"'));
  print(await rp.parse('[true, false, null, 1, "string"]'));
  print(await Future.wait([rp.parse('"yes"'), rp.parse('"no"')]));
  rp.close();
}
