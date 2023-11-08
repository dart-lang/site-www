---
title: Concurrency in Dart
description: >-
  Use isolates to enable parallel code execution on multiple processor cores.
short-title: Concurrency
prevpage:
  url: /language/modifier-reference
  title: Class modifiers reference
nextpage:
  url: /language/async
  title: Async
---

<?code-excerpt path-base="concurrency"?>

<style>
  article img {
    padding: 15px 0;
  }
</style>

Concurrent programming in Dart refers to both asynchronous APIs, like `Future`
and `Stream`, and `isolates`, which allow you to move processes to separate
cores. All Dart code runs in isolates.

An isolate is like a small space on your machine that has its own isolated
memory. If you’re coming from another language that supports multiple threads,
you’ll find that isolates are similar, but are crucially different in that
isolates can’t share memory. Most Dart apps run all their code in a single
isolate, the main isolate, but you can create more isolates if you need them.
When you spawn a new isolate, it will have its own isolated memory heap, and it
will have its own event loop. The event loop is what makes asynchronous and
concurrent programming possible in Dart.

## Event Loop

Dart’s runtime model is based on an event loop. This event loop is responsible
for executing the code of your program, collecting and processing events,
running garbage collection processes, and more. As your application runs, all
events are added to a queue, called the event queue. Events can be anything from
requests to repaint the UI, to user taps and keystrokes, to i/o from the disk.
Because your app can’t predict what order these events will happen, it runs this
event loop that processes events in the order they're queued, one at a time.

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/event-loop.png)

Implementing an event loop might resemble this:

```dart
while (eventQueue.waitForEvent()) {
  eventQueue.processNextEvent();
}
```

Even though this event loop is synchronous and runs on a single thread, most
Dart applications need to do more than one thing at a time. For example, a
client application might need to execute an HTTP request, while also listening
for a user to tap a button. To handle this, Dart offers many async APIs, like
Futures, Streams, and async-await. These APIs are built around this event loop.

For example, consider making a network request:
```dart
http.get('https://example.com').then((response) {
  if (response.statusCode == 200) {
    print('Success!')'
  }  
}
```

When this code is processed by the event loop, it will immediately call the
first clause - `http.get`, and return a `Future`. It will also tell the event
loop to take note that sometime in the future, a specific event will happen (
which is in this case an HTTP response), and when that event happens, it should
execute the callback passed to `then`.

![Figure showing async events being added to an event loop and holding onto 
a callback to execute later.](/assets/img/language/concurrency/async-event-loop.png)

This same model is basically how the event loop handles all other 
asynchronous events in Dart, such as [`Streams`][].

[`Streams`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html

## Asynchrony types and syntax

If you're already familiar with `Future`, `Stream`, and async-await,
then you can skip ahead to the [isolates section][].

[isolates section]: #how-isolates-work

### Future type syntax

A promise to eventually provide a string value is typed as `Future<String>`.
This is an example of a function that returns a Future:

<?code-excerpt "lib/future_syntax.dart"?>
```dart
Future<String> _readFileAsync(String filename) {
  final file = File(filename);

  // .then() returns a Future
  return file.readAsString().then((contents) {
    return contents.trim();
  });
}
```

### The async-await syntax

The `async` and `await` keywords provide a declarative way to define
asynchronous functions and use their results.

Here's an example of some synchronous code that blocks while waiting for file
I/O:

<?code-excerpt "lib/sync_number_of_keys.dart"?>
```dart
const String filename = 'with_keys.json';

void main() {
  // Read some data.
  final fileData = _readFileSync();
  final jsonData = jsonDecode(fileData);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}

String _readFileSync() {
  final file = File(filename);
  final contents = file.readAsStringSync();
  return contents.trim();
}
```

Here's similar code, but with changes (highlighted) to make it asynchronous:

<?code-excerpt "lib/async_number_of_keys.dart" replace="/async|await|readAsString\(\)/[!$&!]/g; /Future<\w+\W/[!$&!]/g;"?>
{% prettify dart tag=pre+code %}
const String filename = 'with_keys.json';

void main() [!async!] {
// Read some data.
final fileData = [!await!] _readFileAsync();
final jsonData = jsonDecode(fileData);

// Use that data.
print('Number of JSON keys: ${jsonData.length}');
}

[!Future<String>!] _readFileAsync() [!async!] {
final file = File(filename);
final contents = [!await!] file.[!readAsString()!];
return contents.trim();
}
{% endprettify %}

The `main()` function uses the `await` keyword in front of `_readFileAsync()`
to let other Dart code (such as event handlers) use the CPU while native code (
file I/O) executes. Using `await` also has the effect of converting
the `Future<String>` returned by `_readFileAsync()` into a `String`. As a
result, the `contents` variable has the implicit type `String`.

{{site.alert.note}} 
The `await` keyword works only in functions that have `async` before the 
function body. 
{{site.alert.end}}

As the following figure shows, the Dart code pauses while `readAsString()`
executes non-Dart code, in either the Dart virtual machine (VM) or the operating
system (OS). Once `readAsString()` returns a value, Dart code execution resumes.

![Flowchart-like figure showing app code executing from start to exit, waiting for native I/O in between](/assets/img/language/concurrency/basics-await.png)

### Stream syntax

Dart also supports asynchronous code in the form of streams. Streams are used to
provide values in the future and repeatedly over time. A promise to provide a
series of `int` values over time has the type `Stream<int>`.

This example will return a new int value every second.
<?code-excerpt "lib/stream_syntax.dart"?>
```dart
Stream<int> stream = Stream.periodic(const Duration(seconds: 1), (i) => i * i);
```

### await-for and yield

Await-for is a type of for loop that executes each subsequent iteration of the
loop as new values are provided. In other words, it’s used to “loop over”
streams. In this example, a new value will be returned from the function
sumStream as new values are emitted from the stream that’s provided as an
argument. The yield keyword is used rather than return in functions that return
streams of values. 

<?code-excerpt "lib/await_for_syntax.dart"?>
```dart
Stream<int> sumStream(Stream<int> stream) async* {
  var sum = 0;
  await for (final value in stream) {
    yield sum += value;
  }
}
```

If you'd like to learn more about using `async`, `await`, `Stream`s and 
`Future`s,  visit the [asynchronous programming codelab][].

[asynchronous programming codelab]: /codelabs/async-await

## Isolates

Dart also supports concurrency via isolates. Most modern devices have multi-core
CPUs. To take advantage of multiple cores, developers sometimes use
shared-memory threads running concurrently. However, shared-state concurrency is
[error prone](https://en.wikipedia.org/wiki/Race_condition#In_software) and can
lead to complicated code.

Instead of threads, all Dart code runs inside of isolates. Each isolate has its
own memory heap, ensuring that none of the state in an isolate is accessible
from any other isolate. Isolates can only communicate to each other via message
passing. No shared state between isolates means concurrency complexities like
[mutexes or locks](https://en.wikipedia.org/wiki/Lock_(computer_science))
and [data races](https://en.wikipedia.org/wiki/Race_condition#Data_race)
won't occur in Dart. That said, isolates don't prevent race conditions all
together. For more information on this concurrency model, read about
the [Actor model](https://en.wikipedia.org/wiki/Actor_model).

Using isolates, your Dart code can perform multiple independent tasks at once,
using additional processor cores if they’re available. Isolates are like threads
or processes, but each isolate has its own memory and a single thread running an
event loop. 

{{site.alert.info}}
**Platform note:**
Only the [Dart Native platform][] implements isolates.
To learn more about the Dart Web platform,
see the [Concurrency on the web](#concurrency-on-the-web) section.
{{site.alert.end}}

[Dart Native platform]: /overview#platform

### The main isolate

In most cases, you don't need to think about isolates at all. Dart programs run
in the main isolate by default. It’s the thread where a program starts to run
and execute, as shown in the following figure:

![A figure showing a main isolate, which runs `main()`, responds to events, and then exits](/assets/img/language/concurrency/basics-main-isolate.png)

Even single-isolate programs can execute smoothly. Before continuing to the next
line of code, these apps use async-await to wait for asynchronous operations to
complete. A well-behaved app starts quickly, getting to the event loop as soon
as possible. The app then responds to each queued event promptly, using
asynchronous operations as necessary.

### The isolate life cycle

As the following figure shows,
every isolate starts by running some Dart code,
such as the `main()` function.
This Dart code might register some event listeners—to
respond to user input or file I/O, for example.
When the isolate's initial function returns,
the isolate stays around if it needs to handle events.
After handling the events, the isolate exits.

![A more general figure showing that any isolate runs some code, optionally responds to events, and then exits](/assets/img/language/concurrency/basics-isolate.png)


### Event Handling

In a client app, the main isolate's event queue might contain repaint requests
and notifications of tap and other UI events. For example, the following figure
shows a repaint event, followed by a tap event, followed by two repaint events.
The event loop takes events from the queue in first in, first out order.

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/event-loop.png)

Event handling happens on the main isolate after `main()` exits. In the
following figure, after `main()` exits, the main isolate handles the first
repaint event. After that, the main isolate handles the tap event, followed by a
repaint event.

![A figure showing the main isolate executing event handlers, one by one](/assets/img/language/concurrency/event-handling.png)

If a synchronous operation takes too much processing time, the app can become
unresponsive. In the following figure, the tap-handling code takes too long, so
subsequent events are handled too late. The app might appear to freeze, and any
animation it performs might be jerky.

![A figure showing a tap handler with a too-long execution time](/assets/img/language/concurrency/event-jank.png)

In client apps, the result of a too-lengthy synchronous operation is often
[janky (non-smooth) UI animation][jank]. Worse, the UI might become completely
unresponsive.

[jank]: {{site.flutter-docs}}/perf/rendering-performance

### Background workers

If your app's UI becomes unresponsive due to a time-consuming
computation—[parsing a large JSON file][json], for example—consider offloading
that computation to a worker isolate, often called a _background worker._
A common case, shown in the following figure, is spawning a simple worker
isolate that performs a computation and then exits. The worker isolate returns
its result in a message when the worker exits.

[json]: {{site.flutter-docs}}/cookbook/networking/background-parsing

![A figure showing a main isolate and a simple worker isolate](/assets/img/language/concurrency/isolate-bg-worker.png)

A worker isolate can perform I/O
(reading and writing files, for example), set timers, and more. It has its own
memory and doesn't share any state with the main isolate. The worker isolate can
block without affecting other isolates.

## Isolate syntax

There are two recommended ways to work with isolates in Dart: [`Isolate.run()`][] and
[`Isolate.spawn()`][]. Which method you use depends on the use-case.

For doing a single computation on a separate thread, use the static
method `Isolate.run`. When you need to create an isolate that will handle
multiple messages over time, or a background worker, use the `Isolate.spawn`
method.

[`Isolate.run()`]: {{site.dart-api}}/dev/dart-isolate/Isolate/run.html
[`Isolate.run()`]: {{site.dart-api}}/dev/dart-isolate/Isolate/spawn.html

### Isolate.run

The static Isolate.run method requires one argument: a callback that will be 
ran on the newly spawned isolate.

<?code-excerpt "lib/isolate_run_syntax.dart"?>
```dart
int slowFib(int n) => n <= 1 ? 1 : slowFib(n - 1) + slowFib(n - 2);

// Compute without blocking current isolate.
void fib40() async {
  await Isolate.run(() => slowFib(40));
}
```
{{site.alert.info}}
In most cases, `Isolate.run` is the recommended API to run processes in the background.
{{site.alert.end}}

### Isolate.spawn

Creating background worker isolates requires some work to set up 2-way 
communication between the main isolate and the worker isolate. This code 
snippet shows the bare-minimum needed to create a long-lived isolate. You 
can see a more detailed code example and explanation on the [Isolates][] page.

[Isolates]: /language/isolates

<?code-excerpt "lib/isolate_spawn_syntax.dart"?>
```dart
class BackgroundWorker {
  late Isolate _isolate;
  late SendPort workerIsolateSendPort;

  Future<void> initIsolate() async {
    // Create a recieve port to recieve messages from spawned isolate
    final mainIsolateReceivePort = ReceivePort();
    mainIsolateReceivePort.listen((dynamic message) {
      if (message is SendPort) {
        workerIsolateSendPort = message;
      } else if (message is String) {
        print(message);
      }
    });

    _isolate = await Isolate.spawn(
      _workerIsolateEntryPoint,
      mainIsolateReceivePort.sendPort,
    );
  }

  static void _workerIsolateEntryPoint(dynamic message) {
    final receivePortInSpawnedIsolate = ReceivePort();
    late SendPort sendPortToMainApp;

    if (message is SendPort) {
      sendPortToMainApp = message;
      sendPortToMainApp.send(receivePortInSpawnedIsolate.sendPort);
    }

// This listener callback will be called each time a subsequent message
// is sent from the main isolate to the worker isolate
    receivePortInSpawnedIsolate.listen((dynamic message) async {
      if (message is String) {
        final dartObjects = jsonDecode(message);
        sendPortToMainApp.send(dartObjects);
      } else {
        throw const SocketException(
            'Message sent to isolate port has an unexpected type');
      }
    });
  }

  void dispose() {
    _isolate.kill();
  }
}

// Elsewhere in app
void startProcessInBackground(String jsonBlob) {
  BackgroundWorker().workerIsolateSendPort.send(jsonBlob);
}
```

## Performance and isolate groups

When an isolate calls [`Isolate.spawn()`][], the two isolates have the same
executable code and are in the same _isolate group_. Isolate groups enable
performance optimizations such as sharing code; a new isolate immediately runs
the code owned by the isolate group. Also, `Isolate.exit()` works only when the
isolates are in the same isolate group.

In some special cases, you might need to use [`Isolate.spawnUri()`][], which
sets up the new isolate with a copy of the code that's at the specified URI.
However, `spawnUri()` is much slower than `spawn()`, and the new isolate isn't
in its spawner's isolate group. Another performance consequence is that message
passing is slower when isolates are in different groups.

[`Isolate.spawnUri()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/Isolate/spawnUri.html

## Limitations of isolates

Isolates are most commonly used in Flutter applications, when you need to do
large computations that would cause the UI to become unresponsive, but they’re
also useful in many server-side applications. In general, isolates are useful
whenever your application is handling computations that are large enough to
temporarily block other computations.

While there isn’t one hard-and-fast rule about when to use isolates, there are
common situations in which you can consider using isolates. The most common uses
for isolates are:

- Parsing and decoding exceptionally large JSON blobs
- Processing and compressing photos, audio and video
- Converting audio and video files
- Performing complex searching and filtering on large lists or within
  filesystems
- Performing I/O, such as communicating with a database
- Handling a large volume of network requests

### Isolates aren't threads

If you’re coming to Dart from a language with multithreading, it’d be reasonable
to expect isolates to behave like threads, but that isn’t the case. Isolates
have their own memory heaps, ensuring that none of the state in an isolate is
accessible from any other isolate. Therefore, isolates are limited by their
access to their own memory. For example, if you have an application with a
global mutable variable called `configuration`, that variable will be a separate
variable in your spawned isolate. If you mutate that variable in the spawned
isolate, it will remain untouched in the main isolate. This is how isolates are
meant to function, and it's important to keep in mind when you’re considering
using isolates.

### Message types

`message`s sent via SendPort can be almost any type of Dart object, but there
are a few exceptions:

- Objects with native resources (subclasses of e.g. NativeFieldWrapperClass1). A
  Socket object for example refers internally to objects that have native
  resources attached and can therefore not be sent.
- ReceivePort
- DynamicLibrary
- Finalizable
- Finalizer
- NativeFinalizer
- Pointer
- UserTag
- MirrorReference
- Instances of classes that either themselves are marked with @pragma
  ('vm:isolate-unsendable'), extend or implement such classes cannot be sent
  through the ports.

Apart from those exceptions any object can be sent. See documentation for
  [`SendPort`][] for more information.

[`SendPort`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/SendPort-class.html

<a id="web"></a>
## Concurrency on the web

All Dart apps can use `async-await`, `Future`, and `Stream`
for non-blocking, interleaved computations. The [Dart web platform][], however,
does not support isolates. Dart web apps can use [web workers][] to run scripts
in background threads similar to isolates. Web workers' functionality and
capabilities differ somewhat from isolates, though.

For instance, when web workers send data between threads, they copy the data
back and forth. Data copying can be very slow, though, especially for large
messages. Isolates do the same, but also provide APIs that can more efficiently
_transfer_
the memory that holds the message instead.

Creating web workers and isolates also differs. You can only create web workers
by declaring a separate program entrypoint and compiling it separately. Starting
a web worker is similar to using `Isolate.spawnUri` to start an isolate. You can
also start an isolate with `Isolate.spawn`, which requires fewer resources
because it
[reuses some of the same code and data](#performance-and-isolate-groups)
as the spawning isolate. Web workers don't have an equivalent API.

[Dart web platform]: /overview#platform
[web workers]: https://developer.mozilla.org/docs/Web/API/Web_Workers_API/Using_web_workers


## Additional Resources

- If you’re using many isolates, consider
  the [IsolateNameServer][https://api.flutter.dev/flutter/dart-ui/IsolateNameServer-class.html] class
  in Flutter, or
  the [pub package][https://pub.dev/packages/isolate_name_server] that clones
  the functionality for Dart applications not using Flutter.
- Dart’s Isolates are an implementation of
  the [Actor model](https://en.wikipedia.org/wiki/Actor_model).
- Additional documentation on Isolate APIs
    - [`Isolate.exit()`][]
    - [`Isolate.spawn()`][]
    - [`ReceivePort`][]
    - [`SendPort`][]

[`Isolate.exit()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/Isolate/exit.html
[`Isolate.spawn()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/Isolate/spawn.html
[`ReceivePort`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/SendPort-class.html