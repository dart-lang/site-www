// ignore_for_file: unused_field

// #docregion main
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

class BackgroundWorker {
  BackgroundWorker() {
    _initIsolate();
  }

  late Isolate _isolate;
  late SendPort _sendPortToWorkerIsolate;
  final Completer<void> _isolateReady = Completer<void>();

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

  // This method will be called whenever [sendPortToMainIsolate.send] is used
  // to send a message from the worker isolate back to the main isolate
  void _handleMessageToMainIsolate(dynamic message) {
    // The initial message will be a send port, which allows us to send
    // future messages to the worker isolate
    if (message is SendPort) {
      _sendPortToWorkerIsolate = message;
      _isolateReady.complete();
      // Subsequent messages will be data that has been fetched from
      // the network, and decoded into Dart objects
    } else if (message is List<Photo>) {
      // T0D0: handle successful Photo fetch
    } else {
      throw const SocketException(
          'Unexpected message type coming from the spawned isolate');
    }
  }

  // This method must be static
  // This method is the your one and only chance to communicate with the
  // worker isolate.
  // This is the only code that will be run, exactly once, when the isolate is
  // spawned, and it will be passed as an argument the second argument passed
  // to Isolate.spawn()
  // This method needs to accomplish several goals:
  //   - It needs to handle the initial message -- the send port from the main
  //   isolate
  //   - It needs to create another Port, one that can continue to receive
  //   messages from the main isolate. And, it needs to send the
  //   corresponding sendPort back to the main isolate.
  //   - It needs to add a listener to the new Port, so it can handle
  //   messages that the main isolate sends to the worker over time.
  static void _workerIsolateEntryPoint(dynamic message) {
    // This [ReceivePort] will allow the spawned worker isolate to receive
    // future methods from the main app isolate
    final receivePortInSpawnedIsolate = ReceivePort();

    // This [SendPort] will be passed back to the main isolate, which allows the
    // main app isolate to send future messages to the worker isolate
    final sendPortToSpawnedIsolate = receivePortInSpawnedIsolate.sendPort;

    // This [SendPort] will come from the main app isolate as the initial
    // message, and allow this isolate to pass messages back to the main app.
    late SendPort sendPortToMainApp;

    // The initial message will always be a SendPort, because that's the
    // second argument passed to Isolate.spawn.
    // With that SendPort, this isolate can send the
    // [sendPortToSpawnedIsolate] back to the main app isolate,
    // which will allow the main app to send more messages
    // to this isolate in the future.
    // Thus, completing the logic needed to set up 2-way communication
    // between the main isolate and a worker isolate
    if (message is SendPort) {
      sendPortToMainApp = message;
      sendPortToMainApp.send(sendPortToSpawnedIsolate);
    }

    // This listener callback will be called each time a subsequent message
    // is sent from the main isolate to the worker isolate
    receivePortInSpawnedIsolate.listen((dynamic message) async {
      if (message is String) {
        // This code makes a network request, and will receive a JSON blob
        final client = http.Client();
        final uri = Uri.parse('https://jsonplaceholder.typicode.com/$message');
        final response = await client.get(uri);

        // returns a list of Maps that represent individual json objects
        final dynamic jsonData = jsonDecode(response.body) as List<dynamic>;

        switch (message) {
          case 'photos':
            final photos = jsonData.map((dynamic element) {
              final data = element as Map<String, dynamic>;
              return Photo.fromJson(data);
            }).toList();
            sendPortToMainApp.send(photos);
          case 'comments':
          // T0D0: add support for fetching comments
          default:
            // T0D0: add support for other resources.
            throw Exception('Resource endpoint sent to isolate port has an '
                'unexpected type. The options are: photos, albums, T0D0s, and'
                ' users');
        }
      } else {
        throw const SocketException(
            'Message sent to isolate port has an unexpected type');
      }
    });
  }
}
// #enddocregion main

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String thumbnailUrl;

  Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> data) {
    return Photo(
      albumId: data['albumId'] as int,
      id: data['id'] as int,
      title: data['title'] as String,
      thumbnailUrl: data['thumbnailUrl'] as String,
    );
  }
}
