---
title: Isolates
description: Information on writing isolates in Dart.
short-title: Isolates
prevpage:
  url: /language/async
  title: Asynchronous support
nextpage:
  url: /null-safety
  title: Sound Null Safety
---

<?code-excerpt path-base="concurrency"?>

<style>
  article img {
    padding: 15px 0;
  }
</style>

This page discusses some examples that use the `Isolate` API to implement 
isolates.

Isolates are most commonly used in Flutter applications, when you 
need to perform large computations that might otherwise cause the 
UI to become unresponsive.
They’re also useful in many server-side applications. In general, 
you should use isolates whenever your application is handling computations that 
are large enough to temporarily block other computations.

While there aren't any rules about when you _must_ use isolates, here are
common situations in which you can consider using isolates:

- Parsing and decoding exceptionally large JSON blobs.
- Processing and compressing photos, audio and video.
- Converting audio and video files.
- Performing complex searching and filtering on large lists or within
  filesystems.
- Performing I/O, such as communicating with a database.
- Handling a large volume of network requests.

## Implementing a simple worker isolate

These examples implement a main isolate
that spawns a simple worker isolate.
[`Isolate.run()`][] simplifies the steps behind
setting up and managing worker isolates:

1. Spawns (starts and creates) an isolate
2. Runs a function on the spawned isolate
3. Captures the result
4. Returns the result to the main isolate
5. Terminates the isolate once work is complete
6. Checks, captures, and throws exceptions and errors back to the main isolate

[`Isolate.run()`]: {{site.dart-api}}/dev/dart-isolate/Isolate/run.html

{{site.alert.flutter-note}} 
If you're using Flutter, you can use [Flutter's `compute` function][]
instead of `Isolate.run()`.
{{site.alert.end}}

[Flutter's `compute` function]: {{site.flutter-api}}/flutter/foundation/compute.html

### Running an existing method in a new isolate

The main isolate contains the code that spawns a new isolate:

<?code-excerpt "lib/simple_worker_isolate.dart (main)"?>
```dart
const String filename = 'with_keys.json';

void main() async {
  // Read some data.
  final jsonData = await Isolate.run(_readAndParseJson);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}
```

The spawned isolate executes the function
passed as the first argument, `_readAndParseJson`:

<?code-excerpt "lib/simple_worker_isolate.dart (spawned)"?>
```dart
Future<Map<String, dynamic>> _readAndParseJson() async {
  final fileData = await File(filename).readAsString();
  final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
  return jsonData;
}
```

1. `Isolate.run()` spawns an isolate, the background worker,
   while `main()` waits for the result.

2. The spawned isolate executes the argument passed to `run()`:
   the function `_readAndParseJson()`.

3. `Isolate.run()` takes the result from `return`
   and sends the value back to the main isolate,
   shutting down the worker isolate.

4. The worker isolate *transfers* the memory holding the result
   to the main isolate. It *does not copy* the data.
   The worker isolate performs a verification pass to ensure
   the objects are allowed to be transferred.

`_readAndParseJson()` is an existing,
asynchronous function that could just as easily
run directly in the main isolate.
Using `Isolate.run()` to run it instead enables concurrency.
The worker isolate completely abstracts the computations
of `_readAndParseJson()`. It can complete without blocking the main isolate.

The result of `Isolate.run()` is always a Future,
because code in the main isolate continues to run.
Whether the computation the worker isolate executes
is synchronous or asynchronous doesn't impact the
main isolate, because it's running concurrently either way.

For the complete program, check out the [send_and_receive.dart][] sample.

[send_and_receive.dart]: https://github.com/dart-lang/samples/blob/main/isolates/bin/send_and_receive.dart

### Sending closures with isolates

You can also create a simple worker isolate with `run()` using a
function literal, or closure, directly in the main isolate.

<?code-excerpt "lib/simple_isolate_closure.dart"?>
```dart
const String filename = 'with_keys.json';

void main() async {
  // Read some data.
  final jsonData = await Isolate.run(() async {
    final fileData = await File(filename).readAsString();
    final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
    return jsonData;
  });

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}
```

This example accomplishes the same as the previous.
A new isolate spawns, computes something, and sends back the result.

However, now the isolate sends a [closure][].
Closures are less limited than typical named functions,
both in how they function and how they're written into the code.
In this example, `Isolate.run()` executes what looks like local code, concurrently.
In that sense, you can imagine `run()` to work like a control flow operator
for "run in parallel".

[closure]: /language/functions#anonymous-functions

## Sending multiple messages between isolates with ports

`Isolate.run()` abstracts a handful of lower-level,
isolate-related API to simplify isolate management:

* [`Isolate.spawn()`][] and [`Isolate.exit()`][]
* [`ReceivePort`][] and [`SendPort`][]
* [`SendPort.send()` method][]

[`Isolate.exit()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/Isolate/exit.html
[`Isolate.spawn()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/Isolate/spawn.html
[`ReceivePort`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/SendPort-class.html
[`SendPort.send()` method]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}
/dart-isolate/SendPort/send.html

### ReceivePorts and SendPorts

This long-lived communication between isolates is set up with 
two classes (in addition to Isolate): ReceivePort and SendPort. 
These ports are the only way isolates can communicate with each other.

Ports behave similarly to Streams, in which the StreamController or Sink is 
created in one isolate, and the listener is set up in the other isolate. In 
this analogy, the StreamController is called a SendPort, and you can “add” 
messages with the [`send()` method][]. ReceivePorts are the listeners, and 
when these listeners receive a new message, 
they call a provided callback with the message as an argument.

[`send()` method]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}
/dart-isolate/SendPort/send.html

#### Setting up ports

Setting up a port requires a few steps, which must be done in a specific 
order. The following figure shows the conceptual steps required to spawn a 
new isolate and establish 2-way communication between it and the main isolate.

A newly spawned isolate only has the information it got through the 
`Isolate.spawn` call.  If the main isolate needs to communicate with the new 
isolate, you must give it a way to reach out to you,
because you can't reach into it. 
That's where the "isolate" in the name comes from.

The traditional way to do that is to first create a [`ReceivePort`][], 
then pass its [`SendPort`][] to the new isolate when spawning it.
The new isolate then creates its own `ReceivePort`, and sends its `SendPort` 
back on the send port it was given.
The original isolate receives this send port, which concludes the set-up.
Now both sides has both a way to send and receive messages, and the real 
communication can start.

{{site.alert.note}}
This diagram, and the following diagram, are high-level and intended to 
convey the concepts necessary to use isolates, but actual implementation 
requires a bit more code. A full code example is shown later on this page.  
{{site.alert.end}}

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/ports-setup.png)

#### Passing messages using the ports

Along with creating the ports and setting up communication, you’ll also need 
to tell the ports what to do when they receive messages. This is done using 
the listen method on each of the respective ReceivePorts.

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/ports-passing-messages.png)

### Ports example

This example demonstrates how you can set up a long-lived worker isolate 
with 2-way communication between it and the main isolate. The goal of this 
code is to make an HTTP request to [Typicode][] for photo data, and convert the JSON response into a List of Photo objects. This work will be done in the worker isolate. To communicate with the isolate, the main isolate will send strings to the worker isolate that define which endpoint to request data from (for example, “photos”). The isolate will send back a message of type List<Photo>. The class also contains a very simple public interface to trigger messages to the isolate, and to read resulting data from the worker isolate.

[Typicode]: https://jsonplaceholder.typicode.com

#### 1: Define the outline of the BackgroundWorker class

<?code-excerpt "lib/ports_example/ports_example_step_1.dart"?>
```dart
import 'dart:async';
import 'dart:isolate';

class BackgroundWorker {
  BackgroundWorker();

  late Isolate _isolate;

  // This method will create the worker isolate
  Future<void> _initIsolate() async {}

  // This method will handle messages that are sent from the worker isolate back to the main isolate
  void _handleMessageToMainIsolate(dynamic message) {}

  // This method will handle messages that are sent from the main isolate to the worker
  static void _workerIsolateEntryPoint(dynamic message) {}
}
```

The three methods stubbed here will contain all the functionality for this
worker.

- `Future<void> _initIsolate() async` is the method that will spawn the worker
  isolate. It will also create the ReceivePort (and consequently, the SendPort)
  associated with the main isolate
- `_handleMessageToMainIsolate(dynamic message)` is the method that will be
  called whenever a message is received in the main isolate’s ReceivePort, via
  the SendPort.send() method. This method is responsible for receiving the
  worker isolate’s SendPort as its first message, and assigning it to a local
  variable. All subsequent messages will be Dart Objects stuffed with data from
  Typicode.
- Similarly, `static void _workerIsolateEntryPoint(dynamic message)` is the
  entry point to the isolate. This method will be called exactly once on the
  worker isolate when it initially spawns. This is the only opportunity you’ll
  have to set up other code that needs to be run on the worker isolate in the
  future. You can think of this method as the “main” function for the worker
  isolate.

#### 2: Spawn the new isolate

**Note:** The code needed to spawn a worker long-lived isolate is not linear. 
Much of the code in this snippet relies on code that is not yet written.

<?code-excerpt "lib/ports_example/ports_example_step_2.dart"?>
```dart
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
``` 

The `_initIsolate` method has been updated to…

- create a ReceivePort, and assign it to `sendPortToMainIsolate`. This port is
  where messages are emitted when sent from the worker isolate.
- create a variable for the `ReceivePort.sendPort`. This is purely to make the
  code more readable for this example. This variable will not be used outside
  this method.
- add a listener to the receive port. Now, when a new message is emitted to this
  isolate, the method `_handleMessageToMainIsolate` will be called with the
  message as an argument.
- spawn the worker isolate via `Isolate.spawn`. This method requires two
  arguments. The first argument is a callback that will be called when the
  isolate spawns. The second argument required by `Isolate.spawn` is what will
  be passed to the callback when the isolate runs it. So, when the isolate runs,
  the first thing it will do is
  call `_workerIsolateEntryPoint(sendPortToMainIsolate)`.

#### 3: Complete the isolate entry point method

<?code-excerpt "lib/ports_example/ports_example_step_3.dart"?>
```dart
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
          // TODO: add support for fetching comments
          default:
            // TODO: add support for other resources.
            throw Exception('Resource endpoint sent to isolate port has an '
                'unexpected type. The options are: photos, albums, TODOs, and'
                ' users');
        }
      } else {
        throw const SocketException(
            'Message sent to isolate port has an unexpected type');
      }
    });
  }
}
```

The `_workerIsolateEntryPoint` method has been updated to…

- create a ReceivePort, which will be listened to for messages that are emitted
  from the main isolate. This first message sent, which is the send port passed
  to Isolate.spawn, is not sent via the ports you’re setting up, so this
  listener will not be triggered when this method is invoked.
  The `receivePortInSpawnedIsolate.listen` callback will be called on each
  subsequent message sent to the worker isolate.
- create a variable called `sendPortToSpawnedIsolate` and assigns the newly
  created ReceivePort’s send port to it. This send port will be sent back to the
  main isolate.
- check to see if the message being sent via Isolate.spawn is a SendPort, which
  it should be. If it is, it assigns that SendPort to a local variable, so that
  this isolate can send messages back to the main isolate in the future. Within
  this if-clause, the worker isolate is also sending its own SendPort back to
  the main isolate. (This completes the set up of 2-way communication.)
- add a listener callback to the worker isolate’s ReceivePort. This callback is
  what will be called on all subsequent messages sent to the isolate. For this
  example, that means this callback will be making the HTTP request to Typicode,
  decoding json, and sending the List of Photos objects back to the main
  isolate.

#### 4: Complete the isolate entry point method

This snippet adds the completed code for the method `_handleMessageToMainIsolate`, as well as needed variables for the class `_sendPortToWorkerIsolate` and a completer called `_isolateReady`.

<?code-excerpt "lib/ports_example/ports_example_step_4.dart"?>
```dart
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
      // TODO: handle successful Photo fetch
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
          // TODO: add support for fetching comments
          default:
            // TODO: add support for other resources.
            throw Exception('Resource endpoint sent to isolate port has an '
                'unexpected type. The options are: photos, albums, TODOs, and'
                ' users');
        }
      } else {
        throw const SocketException(
            'Message sent to isolate port has an unexpected type');
      }
    });
  }
}
```
The `_handleMessageToMainIsolate` has been updated to handle the two possible
messages that our isolate could send back to the main isolate.

First, it will send back a SendPort as the first message, and this method will
assign that port to a local variable, and then it will complete the _
isolateReady completer. This completer will stop the consumers of this class
from requesting work from the worker isolate until the 2-way communication is
established. In the next snippet, you can see how that completer is being used.

Secondly, the `_handleMessageToMainIsolate` method will handle messages from the
worker isolate that are of type `List<Photo>`. In this case, it will add those
photos to a StreamController, which is shown in the next snippet.

As a reminder, this method is given to the `ReceivePort.listener` in
the `_initIsolate` method.

### Complete code example

This final snippet adds code that is needed to make this class compile, but it’s not needed to understand or use isolates. The new code adds the public facing API for this class.

<?code-excerpt "lib/ports_example/ports_example_complete.dart"?>
```dart
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
  final StreamController<List<Photo>> _outboundStreamController =
      StreamController();
  Stream<List<Photo>> get photos => _outboundStreamController.stream;

  void fetchTypicodeDataFromNetwork(String resource) async {
    await _isolateReady.future;
    _sendPortToWorkerIsolate.send(resource);
  }

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
      // TODO: handle successful Photo fetch
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
          // TODO: add support for fetching comments
          default:
            // TODO: add support for other resources.
            throw Exception('Resource endpoint sent to isolate port has an '
                'unexpected type. The options are: photos, albums, TODOs, and'
                ' users');
        }
      } else {
        throw const SocketException(
            'Message sent to isolate port has an unexpected type');
      }
    });
  }

  void dispose() {
    _outboundStreamController.close();
    _isolate.kill();
  }
}

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
```
