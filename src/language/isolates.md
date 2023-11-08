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



## How isolates work

Most modern devices have multi-core CPUs.
To take advantage of multiple cores,
developers sometimes use shared-memory threads running concurrently.
However, shared-state concurrency is
[error prone](https://en.wikipedia.org/wiki/Race_condition#In_software) and
can lead to complicated code.

Instead of threads, all Dart code runs inside of isolates.
Each isolate has its own memory heap,
ensuring that none of the state in an isolate is accessible from
any other isolate.



Using isolates, your Dart code can perform multiple independent tasks at once,
using additional processor cores if they're available.
Isolates are like threads or processes,
but each isolate has its own memory and a single thread running an event loop.




### The main isolate

You often don't need to think about isolates at all.
Dart programs run in the main isolate by default.
It's the thread where a program starts to run and execute,
as shown in the following figure:

![A figure showing a main isolate, which runs `main()`, responds to events, and then exits](/assets/img/language/concurrency/basics-main-isolate.png)

Even single-isolate programs can execute smoothly.
Before continuing to the next line of code, these apps use
[async-await][] to wait for asynchronous operations to complete.
A well-behaved app starts quickly,
getting to the event loop as soon as possible.
The app then responds to each queued event promptly,
using asynchronous operations as necessary.

[async-await]: {{site.url}}/codelabs/async-await



### Event handling





Each isolate message can deliver one object,
which includes anything that's transitively reachable from that object.
Not all object types are sendable, and
the send fails if any transitively reachable object is unsendable.
For example, you can send an object of type `List<Object>` only if
none of the objects in the list is unsendable.
If one of the objects is, say, a `Socket`, then
the send fails because sockets are unsendable.

For information on the kinds of objects that you can send in messages,
see the API reference documentation for the [`send()` method][].



[`send()` method]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/SendPort/send.html

## Code examples

This section discusses some examples
that use the `Isolate` API
to implement isolates.

### Implementing a simple worker isolate

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
If you're using Flutter,
you can use [Flutter's `compute` function][]
instead of `Isolate.run()`.
On the [web](#web), the `compute` function falls back
to running the specified function on the current event loop.
Use `Isolate.run()` when targeting native platforms only,
for a more ergonomic API.
{{site.alert.end}}

[native and non-native platforms]: /overview#platform
[Flutter's `compute` function]: {{site.flutter-api}}/flutter/foundation/compute.html

#### Running an existing method in a new isolate

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

#### Sending closures with isolates

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

### Sending multiple messages between isolates

`Isolate.run()` abstracts a handful of lower-level,
isolate-related API to simplify isolate management:

* [`Isolate.spawn()`][] and [`Isolate.exit()`][]
* [`ReceivePort`][] and [`SendPort`][]

[`Isolate.exit()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/Isolate/exit.html
[`Isolate.spawn()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/Isolate/spawn.html
[`ReceivePort`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/SendPort-class.html

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

