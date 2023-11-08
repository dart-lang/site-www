---
title: Isolates
description: Information on writing isolates in Dart.
short-title: Isolates
prevpage:
  url: /language/async
  title: Asynchronous support
nextpage:
  url: /language/null-safety
  title: Null safety
---

<?code-excerpt path-base="concurrency"?>

<style>
  article img {
    padding: 15px 0;
  }
</style>

This page discusses some examples that use the `Isolate` API to implement 
isolates.

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

### Sending closures with isolates

You can also create a simple worker isolate with `run()` using a
function literal, or closure, directly in the main isolate.

<?code-excerpt "lib/simple_isolate_closure.dart (main)"?>
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

This long-lived communication between isolates is set up with two classes (in addition to Isolate): ReceivePort and SendPort. These ports are the only way isolates can communicate with each other.

Ports behave similarly to Streams, in which the StreamController or Sink is 
created in one isolate, and the listener is set up in the other isolate. In 
this analogy, the StreamConroller is called a SendPort, and you can “add” 
messages with the [`send()` method][]. ReceivePorts are the listeners, and 
when these listeners receive a new message, they call a provided callback with the message as an argument.

[`send()` method]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}
/dart-isolate/SendPort/send.html

#### Setting up ports

Setting up a port requires a few steps, which must be done in a specific order. The following figure shows the conceptual steps required to spawn a new isolate and establish 2-way communication between it and the main isolate.

{{site.alert.note}}
This diagram, and the following diagram, are high-level and intended to convey the concepts necessary to use isolates, but actual implementation requires a bit more code. A full code example is shown later on this page.  
{{site.alert.end}}

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/port-setup.png)

#### Passing messages using the ports

Along with creating the ports and setting up communication, you’ll also need to tell the ports what to do when they receive messages. This is done using the listen method on each of the respective ReceivePorts.

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/port-passing-messages.png)

### Ports example

This example demonstrates how you can set up a long-lived worker isolate 
with 2-way communication between it and the main isolate. The goal of this 
code is to make an HTTP request to [Typicode][https://jsonplaceholder.typicode.com] for photo data, and convert the JSON response into a List of Photo objects. This work will be done in the worker isolate. To communicate with the isolate, the main isolate will send strings to the worker isolate that define which endpoint to request data from (for example, “photos”). The isolate will send back a message of type List<Photo>. The class also contains a very simple public interface to trigger messages to the isolate, and to read resulting data from the worker isolate.

#### 1: Define the outline of the BackgroundWorker class

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

import 'main.dart';

class BackgroundWorker {
  BackgroundWorker() {}

  late Isolate _isolate;

  // This method will create the worker isolate
  Future<void> _initIsolate() async {}
  
  // This method will handle messages that are sent from the worker isolate back to the main isolate
  void _handleMessageToMainIsolate(dynamic message) {}

  // This method will handle messages that are sent from the main isolate to the worker
  static void _workerIsolateEntryPoint(dynamic message) {}
}

```



You can use these primitives directly for more granular
control over isolate functionality. For example, `run()` shuts
down its isolate after returning a single message.
What if you want to allow multiple messages to pass between isolates?
You can set up your own isolate much the same way `run()` is implemented,
just utilizing the [`send()` method][] of `SendPort` in a slightly different way.

One common pattern, which the following figure shows,
is for the main isolate to send a request message to the worker isolate,
which then sends one or more reply messages.

![A figure showing the main isolate spawning the isolate and then sending a request message, which the worker isolate responds to with a reply message; two request-reply cycles are shown](/assets/img/language/concurrency/isolate-custom-bg-worker.png)

Check out the [long_running_isolate.dart][] sample,
which shows how to spawn a long-running isolate
that receives and sends messages multiple times between isolates.

{% assign samples = "https://github.com/dart-lang/samples/tree/main/isolates" %}

[isolate samples]: {{ samples }}
[send_and_receive.dart]: {{ samples }}/bin/send_and_receive.dart
[long_running_isolate.dart]: {{ samples }}/bin/long_running_isolate.dart

