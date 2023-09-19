---
title: Concurrency in Dart
description: >-
  Use isolates to enable parallel code execution on multiple processor cores.
short-title: Concurrency
prevpage:
  url: /language/async
  title: Async
---

<?code-excerpt path-base="concurrency"?>

<style>
  article img {
    padding: 15px 0;
  }
</style>

Dart supports concurrent programming with async-await, isolates, and
classes such as `Future` and `Stream`.
This page gives an overview of async-await, `Future`, and `Stream`,
but it's mostly about isolates.

Within an app, all Dart code runs in an _isolate._
Each Dart isolate has a single thread of execution and
shares no mutable objects with other isolates.
To communicate with each other,
isolates use message passing.
Many Dart apps use only one isolate, the _main isolate_.
You can create additional isolates to enable
parallel code execution on multiple processor cores.

Although Dart's isolate model is built with underlying primitives
such as processes and threads
that the operating system provides,
the Dart VM's use of these primitives
is an implementation detail that this page doesn't discuss.

## Asynchrony types and syntax

If you're already familiar with `Future`, `Stream`, and async-await,
then you can skip ahead to the [isolates section][].

[isolates section]: #how-isolates-work


### Future and Stream types

The Dart language and libraries use `Future` and `Stream` objects to
represent values to be provided in the future.
For example, a promise to eventually provide an `int` value
is typed as `Future<int>`.
A promise to provide a series of `int` values
has the type `Stream<int>`.

As another example, consider the dart:io methods for reading files.
The synchronous `File` method [`readAsStringSync()`][]
reads a file synchronously,
blocking until the file is either fully read or an error occurs.
The method then either returns an object of type `String`
or throws an exception.
The asynchronous equivalent, [`readAsString()`][],
immediately returns an object of type `Future<String>`.
At some point in the future,
the `Future<String>` completes with either a string value or an error.

[`readAsStringSync()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/File/readAsStringSync.html
[`readAsString()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/File/readAsString.html


#### Why asynchronous code matters

It matters whether a method is synchronous or asynchronous
because most apps need to do more than one thing at a time.

Asynchronous computations are often the result of performing computations
outside of the current Dart code; 
this includes computations that don't complete immediately, 
and where you aren't willing to block your Dart code waiting for the result.
For example, an app might start an HTTP request,
but need to update its display or respond to user input
before the HTTP request completes.
Asynchronous code helps apps stay responsive.

These scenarios include operating system calls like
non-blocking I/O, performing an HTTP request, or communicating with a browser. 
Other scenarios include waiting for computations
performed in another Dart isolate as described below, 
or maybe just waiting for a timer to trigger. 
All of these processes either run in a different thread, 
or are handled by the operating system or the Dart runtime, 
which allows Dart code to run concurrently with the computation.


### The async-await syntax

The `async` and `await` keywords provide
a declarative way to define asynchronous functions
and use their results.

Here's an example of some synchronous code
that blocks while waiting for file I/O:

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
to let other Dart code (such as event handlers) use the CPU
while native code (file I/O) executes.
Using `await` also has the effect of
converting the `Future<String>` returned by `_readFileAsync()` into a `String`.
As a result, the `contents` variable has the implicit type `String`.

{{site.alert.note}}
  The `await` keyword works only in functions that
  have `async` before the function body.
{{site.alert.end}}

As the following figure shows,
the Dart code pauses while `readAsString()` executes non-Dart code,
in either the Dart virtual machine (VM) or the operating system (OS).
Once `readAsString()` returns a value, Dart code execution resumes.

![Flowchart-like figure showing app code executing from start to exit, waiting for native I/O in between](/assets/img/language/concurrency/basics-await.png)

If you'd like to learn more about using `async`, `await`, and futures,
visit the [asynchronous programming codelab][].

[asynchronous programming codelab]: /codelabs/async-await


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
No shared state between isolates means concurrency complexities like 
[mutexes or locks](https://en.wikipedia.org/wiki/Lock_(computer_science))
and [data races](https://en.wikipedia.org/wiki/Race_condition#Data_race)
won't occur in Dart. That said,
isolates don't prevent race conditions all together.


Using isolates, your Dart code can perform multiple independent tasks at once,
using additional processor cores if they're available.
Isolates are like threads or processes,
but each isolate has its own memory and a single thread running an event loop.

{{site.alert.info}}
  **Platform note:**
    Only the [Dart Native platform][] implements isolates.
    To learn more about the Dart Web platform,
    see the [Concurrency on the web](#concurrency-on-the-web) section.
{{site.alert.end}}

[Dart Native platform]: /overview#platform

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


### Event handling

In a client app, the main isolate's event queue might contain
repaint requests and notifications of tap and other UI events.
For example, the following figure shows a repaint event,
followed by a tap event, followed by two repaint events.
The event loop takes events from the queue in first in, first out order.

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/event-loop.png)

Event handling happens on the main isolate after `main()` exits.
In the following figure, after `main()` exits,
the main isolate handles the first repaint event.
After that, the main isolate handles the tap event,
followed by a repaint event.

![A figure showing the main isolate executing event handlers, one by one](/assets/img/language/concurrency/event-handling.png)

If a synchronous operation takes too much processing time,
the app can become unresponsive.
In the following figure, the tap-handling code takes too long,
so subsequent events are handled too late.
The app might appear to freeze,
and any animation it performs might be jerky.

![A figure showing a tap handler with a too-long execution time](/assets/img/language/concurrency/event-jank.png)

In client apps, the result of a too-lengthy synchronous operation is often
[janky (non-smooth) UI animation][jank].
Worse, the UI might become completely unresponsive.

[jank]: {{site.flutter-docs}}/perf/rendering-performance


### Background workers

If your app's UI becomes unresponsive due to 
a time-consuming computation—[parsing a large JSON file][json], 
for example—consider offloading that computation to a worker isolate,
often called a _background worker._
A common case, shown in the following figure,
is spawning a simple worker isolate that
performs a computation and then exits.
The worker isolate returns its result in a message when the worker exits.

[json]: {{site.flutter-docs}}/cookbook/networking/background-parsing

![A figure showing a main isolate and a simple worker isolate](/assets/img/language/concurrency/isolate-bg-worker.png)

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

A worker isolate can perform I/O
(reading and writing files, for example), set timers, and more.
It has its own memory and
doesn't share any state with the main isolate.
The worker isolate can block without affecting other isolates.

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

{% comment %}
TODO:
Should create a diagram for the current example.
Previous example's diagram and text for reference:

  The following figure illustrates the communication between
  the main isolate and the worker isolate:
  
  ![A figure showing the previous snippets of code running in the main isolate and in the worker isolate](/assets/img/language/concurrency/isolate-api.png)
{% endcomment %}

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


## Performance and isolate groups

When an isolate calls [`Isolate.spawn()`][],
the two isolates have the same executable code
and are in the same _isolate group_.
Isolate groups enable performance optimizations such as sharing code;
a new isolate immediately runs the code owned by the isolate group.
Also, `Isolate.exit()` works only when the isolates
are in the same isolate group.

In some special cases,
you might need to use [`Isolate.spawnUri()`][],
which sets up the new isolate with a copy of the code
that's at the specified URI.
However, `spawnUri()` is much slower than `spawn()`,
and the new isolate isn't in its spawner's isolate group.
Another performance consequence is that message passing
is slower when isolates are in different groups.

[`Isolate.spawnUri()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/Isolate/spawnUri.html

{{site.alert.flutter-note}}
  Flutter doesn't support `Isolate.spawnUri()`.
{{site.alert.end}}

<a id="web"></a>
## Concurrency on the web

All Dart apps can use `async-await`, `Future`, and `Stream`
for non-blocking, interleaved computations.
The [Dart web platform][], however, does not support isolates.
Dart web apps can use [web workers][] to
run scripts in background threads
similar to isolates.
Web workers' functionality and capabilities
differ somewhat from isolates, though.

For instance, when web workers send data between threads,
they copy the data back and forth.
Data copying can be very slow, though,
especially for large messages. 
Isolates do the same, but also provide APIs
that can more efficiently _transfer_
the memory that holds the message instead.

Creating web workers and isolates also differs.
You can only create web workers by declaring
a separate program entrypoint and compiling it separately.
Starting a web worker is similar to using `Isolate.spawnUri` to start an isolate.
You can also start an isolate with `Isolate.spawn`,
which requires fewer resources because it
[reuses some of the same code and data](#performance-and-isolate-groups)
as the spawning isolate. 
Web workers don't have an equivalent API.

[Dart web platform]: /overview#platform
[web workers]: https://developer.mozilla.org/docs/Web/API/Web_Workers_API/Using_web_workers
