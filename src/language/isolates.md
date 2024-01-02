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

You should use isolates whenever your application is handling computations that 
are large enough to temporarily block other computations.
The most common example is in [Flutter][] applications, when you 
need to perform large computations that might otherwise cause the 
UI to become unresponsive.

There aren't any rules about when you _must_ use isolates, 
but here are some more situations where they can be useful:

- Parsing and decoding exceptionally large JSON blobs.
- Processing and compressing photos, audio and video.
- Converting audio and video files.
- Performing complex searching and filtering on large lists or within
  file systems.
- Performing I/O, such as communicating with a database.
- Handling a large volume of network requests.

[Flutter]: {{site.flutter}}/perf/isolates

## Implementing a simple worker isolate

These examples implement a main isolate
that spawns a simple worker isolate.
[`Isolate.run()`][] simplifies the steps behind
setting up and managing worker isolates:

1. Spawns (starts and creates) an isolate.
2. Runs a function on the spawned isolate.
3. Captures the result.
4. Returns the result to the main isolate.
5. Terminates the isolate once work is complete.
6. Checks, captures, and throws exceptions and errors back to the main isolate.

[`Isolate.run()`]: {{site.dart-api}}/dev/dart-isolate/Isolate/run.html

{{site.alert.flutter-note}} 
If you're using Flutter, you can use [Flutter's `compute` function][]
instead of `Isolate.run()`.
{{site.alert.end}}

[Flutter's `compute` function]: {{site.flutter-api}}/flutter/foundation/compute.html

### Running an existing method in a new isolate

1. Call `run()` to spawn a new isolate (a [background worker][]),
   directly in the [main isolate][] while `main()` waits for the result:

<?code-excerpt "lib/simple_worker_isolate.dart (main)"?>
```dart
const String filename = 'with_keys.json';

void main() async {
  // Spawn a new isolate to read some data.
  final jsonData = await Isolate.run(_readAndParseJson);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}
```

2. Pass the worker isolate the function you want it to execute
   as its first argument. In this example, it's the existing function `_readAndParseJson()`:

<?code-excerpt "lib/simple_worker_isolate.dart (spawned)"?>
```dart
Future<Map<String, dynamic>> _readAndParseJson() async {
  final fileData = await File(filename).readAsString();
  final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
  return jsonData;
}
```

3. `Isolate.run()` takes the result `_readAndParseJson()` returns
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
[background worker]: /language/concurrency#background-workers
[main isolate]: /language/concurrency#the-main-isolate

### Sending closures with isolates

You can also create a simple worker isolate with `run()` using a
function literal, or closure, directly in the main isolate.

<?code-excerpt "lib/simple_isolate_closure.dart"?>
```dart
const String filename = 'with_keys.json';

void main() async {
  // Spawn a new isolate to read some data.
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
In this example, `Isolate.run()` executes what looks like local code, 
concurrently. In that sense, you can imagine `run()` to work like a 
control flow operator for "run in parallel".

[closure]: /language/functions#anonymous-functions

## Sending multiple messages between isolates with ports

Short-lived isolates are convenient to use,
but require performance overhead to spawn new isolates
and to copy objects from one isolate to another.
If your code relies on repeatedly running the same computation 
using `Isolate.run`, you might improve performance by instead creating
long-lived isolates that don’t exit immediately.

To do this, you can use some of the low-level isolate APIs that 
`Isolate.run` abstracts:

* [`Isolate.spawn()`][] and [`Isolate.exit()`][]
* [`ReceivePort`][] and [`SendPort`][]
* [`SendPort.send()` method][]


This section goes over the steps required to spawn a
new isolate and establish 2-way communication between it and 
the [main isolate][].
The first example introduces the process at a high-level, 
and the second example gradually adds more practical, 
real-world functionality to the first.

[`Isolate.exit()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/Isolate/exit.html
[`Isolate.spawn()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/Isolate/spawn.html
[`ReceivePort`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/SendPort-class.html
[`SendPort.send()` method]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/SendPort/send.html
[main isolate]: /language/concurrency#isolates


### `ReceivePort` and `SendPort`

Setting up long-lived communication between isolates requires
two classes (in addition to `Isolate`): `ReceivePort` and `SendPort`.
These ports are the only way isolates can communicate with each other.

A `ReceivePort` is an object that handles messages that are sent from other
isolates. Those messages are sent via a `SendPort`.

{{site.alert.note}}
`SendPort` objects are associated with exactly one `ReceivePort`,
but a single `ReceivePort` can have many `SendPorts`.
The `ReceivePort` creates a `SendPort` when it is created itself.
You can create new `SendPorts` that
can send messages to an existing `ReceivePort`.
{{site.alert.note}}

Ports behave similarly to [`Stream`][] objects 
(in fact, receive ports implement `Stream`!)
You can think of a `SendPort` and `ReceivePort` like
Stream's `StreamController` and listeners, respectively.
A `SendPort` is like a `StreamController` because you "add" messages to them
with the [`send()` method][], and those messages are handled by a listener,
in this case the `ReceivePort`. Handling messages received by
the `RecievePort` is done by calling a provided callback with the message as
an argument.

#### Setting up ports

A newly spawned isolate only has the information it receives through the
`Isolate.spawn` call. If you need the main isolate to continue to communicate
with a spawned isolate past its initial creation, you must set up a 
communication channel where the spawned isolate can send messages to the 
main isolate. Isolates can only communicate via message passing. 
They can’t “see”  inside each others’ memory, 
which is where the name “isolate” comes from.

To set up this 2-way communication, first create a [`ReceivePort`][] 
in the main isolate, then pass its [`SendPort`][] as an argument to the 
new isolate when spawning it with `Isolate.spawn`.
The new isolate then creates its own `ReceivePort`, and sends _its_ `SendPort`
back on the `SendPort` it was passed by the main isolate.
The main isolate receives this `SendPort`, and
now both sides have an open channel to send and receive messages.

{{site.alert.note}}
The diagrams in this section are high-level and intended to convey the 
_concept_ of using ports for isolates. Actual implementation requires 
a bit more code, which you will find 
[later on this page](#basic-ports-example).  
{{site.alert.end}}

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/ports-setup.png)

1. Create a `ReceivePort` in the main isolate. The `SendPort` is created
   automatically as a property on the `ReceivePort`.
2. Spawn the worker isolate with `Isolate.spawn()`
3. Pass a reference to `ReceivePort.sendPort` as the first message to the
   worker isolate.
4. Create another new `ReceivePort` in the worker isolate.
5. Pass a reference to the worker isolate's `ReceivePort.sendPort` as the
   first message _back_ to the main isolate.

Along with creating the ports and setting up communication, you’ll also need
to tell the ports what to do when they receive messages. This is done using
the `listen` method on each respective `ReceivePort`.

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/ports-passing-messages.png)

1. Send a message via the main isolate’s reference to the worker isolate's
   `SendPort`.
2. Receive and handle the message via a listener on the worker isolate's
   `ReceivePort`. This is where the computation you want to move off the
   main isolate is executed.
3. Send a return message via the worker isolate's reference to the main
   isolate's `SendPort`.
4. Receive the message via a listener on the main isolate's `ReceivePort`.

### Basic ports example

This example demonstrates how you can set up a long-lived worker isolate
with 2-way communication between it and the main isolate.
The code uses the example of sending JSON text to a new isolate,
where the JSON will be parsed and decoded,
before being sent back to the main isolate.

{{site.alert.warn}}
This example is meant to teach the _bare minimum_ needed to
spawn a new isolate that can send and receive multiple messages over time.

It does not cover important pieces of functionality that are expected
in production software, like error handling, shutting down ports,
and message sequencing.

The [Robust ports example][] in the next section covers this functionality and
discusses some of the issues that can arise without it.
{{site.alert.warn}}

#### Step 1: Define the worker class

First, create a class for your background worker isolate. 
This class contains all the functionality you need to:

- Spawn an isolate.
- Send messages to that isolate.
- Have the isolate decode some JSON.
- Send the decoded JSON back to the main isolate.

The class will expose two public methods: one that will spawn the worker 
isolate, and one that will handle sending messages to that worker isolate.

After this code snippet, the remaining snippets will fill in the class methods, 
one-by-one.

<?code-excerpt "lib/basic_ports_example/start.dart"?>
```dart
class Worker {
  Future<void> spawn() async {
  // TODO: Add functionality to spawn a worker isolate.
 }

  void _handleResponsesFromIsolate(dynamic message) {
    // TODO: Define code that should be executed on the worker isolate.
}

  static void _startRemoteIsolate(SendPort port) {
    // TODO: Handle messages sent back from the worker isolate.
  }

  Future parseJson(String message) async {
   // TODO: Define a public method that can 
 // be used to send messages to the worker isolate.
  }
}
```

#### Step 2: Spawn a worker isolate

The `Worker.spawn` method is where you will group the code for creating the 
worker isolate and ensuring it can receive and send messages.

- First, create a `ReceivePort`. This allows the main isolate to receive
  messages sent from the newly spawned worker isolate.
- Next, add a listener to the receive port to handle messages the worker isolate
  will send back. The callback passed to the
  listener, `_handleMessagesFromIsolate`, will be covered
  in [step 4](#step-4-handle-messages-on-the-main-isolate).
- Finally, spawn the worker isolate with `Isolate.spawn`. It expects two
  arguments: a function to be executed on the worker isolate (covered in step
  3), and the `sendPort` property of the receive port.

<?code-excerpt "lib/basic_ports_example/spawn.dart"?>
```dart
  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
}
```

The `receivePort.sendPort` argument will be passed to the
callback (`_handleMessagesFromIsolate`) as an argument when it’s called on the
worker isolate. This is the first step in ensuring that the worker isolate has a
way to send messages back to the main isolate.

#### Step 3: Execute code on the worker isolate

In this step, you define the method `_isolateEntryPoint` that is sent to the
worker isolate to be executed when it spawns. This method is like the “main”
method for the worker isolate.

- First, create another new `ReceivePort`. This port will be used to receive
  future messages from the main isolate.
- Next, send that port’s  `SendPort` back to the main isolate.
- Finally, add a listener to the new `ReceivePort`. This listener handles
  messages the main isolate sends to the worker isolate.

<?code-excerpt "lib/basic_ports_example/start_remote_isolate.dart"?>
```dart
  static void _startRemoteIsolate(SendPort port) {
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    receivePort.listen((dynamic message) async {
      final decoded = jsonDecode(message as String);
      port.send(decoded);
    }); 
  }
```

The listener on the worker’s `ReceivePort` decodes the JSON passed from the main
isolate, and then sends the decoded JSON back to the main isolate.

This listener is the entry point for messages sent from the main isolate to the
worker isolate. **This is the only chance you have to tell the isolate what code
to execute in the future.**

#### Step 4: Handle messages on the main isolate

Finally, you need to tell the main isolate how to handle messages sent from the
worker isolate back to the main isolate. To do so, you need to fill in
the `_handleResponsesFromIsolate` method. Recall that this method is passed to
the `Worker.spawn` method, as described
in [step 2](#step-2-spawn-a-worker-isolate):

<?code-excerpt "lib/basic_ports_example/spawn.dart"?>
```dart
  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
}
```

Also recall that you sent a `SendPort` back to the main isolate
in [step 3](step-3-execute-code-on-worker-isolate). This method handles the
receipt of that `SendPort`, as well as handling future messages (which will be
decoded JSON).

- First, check if the message is a `SendPort`. If so, assign that port to the
  classes `_sendPort` property so it can be used to send messages later.
- Next, check if the message is of type `Map<String, dynamic>`, the expected
  type of decoded JSON. If so, handle that message with your
  application-specific logic. In this example, the message is printed. 

<?code-excerpt "lib/basic_ports_example/handle_response_from_isolate.dart"?>
```dart
class Worker {
  late SendPort _sendPort;

  // spawn method

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
    } else if (message is Map<String, dynamic>) {
      print(message);
    }
  }

// rest of class..
```

#### Step 5: Add a completer to ensure your isolate is set-up

To complete the class, define a public method called `parseJson`, which is
responsible for sending messages to the worker isolate. It also needs to ensure
that messages can be sent before the isolate is fully set up. You will handle
this by using a [`Completer`][].

- First, add a class-level property called a `Completer` and name
  it `_isolateReady`.
- Next, add a call to `complete()` on the completer in
  the `_handleResponsesFromIsolate` method (created in step 4) if the message is
  a `SendPort`.
- Finally, in the `parseJson` method, add `await _isolateReady.future` before
  adding `_sendPort.send`. This ensures that no message can be sent to the
  worker isolate until it is spawned _and_ has sent its `SendPort` back to the
  main isolate.

<?code-excerpt "lib/basic_ports_example/parse_json.dart"?>
```dart
class Worker {
  late SendPort _sendPort;
  final Completer _isolateReady = Completer.sync(); // New

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete(); // New
    } else if (message is Map<String, dynamic>) {
      print(message);
    }
  }

  // New
  Future parseJson(String message) async {
    await _isolateReady.future;
    _sendPort.send(message);
  }
// rest of class..
```

#### Complete example

<details>
<summary>Expand to see complete example</summary>

<?code-excerpt "lib/basic_ports_example/complete.dart"?>
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

void main() async {
  final worker = Worker();
  await worker.spawn();
  await worker.parseJson('{"key":"value"}');
}

class Worker {
  late SendPort _sendPort;
  final Completer<void> _isolateReady = Completer.sync();

  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
    } else if (message is Map<String, dynamic>) {
      print(message);
    }
  }

  static void _startRemoteIsolate(SendPort port) {
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    receivePort.listen((dynamic message) async {
      if (message is String) {
        final transformed = jsonDecode(message);
        port.send(transformed);
      }
    });
  }

  Future<void> parseJson(String message) async {
    await _isolateReady.future;
    _sendPort.send(message);
  }
}
```
</details>