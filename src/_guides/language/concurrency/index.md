---
title: Concurrency in Dart
description: [PENDING.]
---

<style>
  img {
    padding: 15px 0;
  }
}

</style>

Dart supports concurrent programming with async-await, isolates, and
classes such as `Future` and `Stream`.
Because Dart code executes in a predictable sequence that
can’t be interrupted by other Dart code,
sometimes Dart is called a _single-threaded language._
Still, the Dart language and libraries give you the option of
using concurrency and parallel execution on multiple processors,
making your apps more responsive.

{{site.alert.info}}
  **Platform note:**
  All apps can use async-wait, `Future`, and `Stream`.
  Isolates work only on the [Dart Native platform][];
  Dart web apps can use [web workers][] instead.
{{site.alert.end}}

[Dart Native platform]: /overview#platform
[web workers]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers



## Background: asynchrony types and syntax

If you’re already familiar with `Future`, `Stream`, and async-await,
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
The method then returns an object of type `String`.
The asynchronous equivalent, [`readAsString()`][],
immediately returns an object of type `Future<String>`.
At some point in the future,
the `Future<String>` completes with either a string value or an error.

[`readAsStringSync()`]: https://api.dart.dev/stable/dart-io/File/readAsStringSync.html
[`readAsString()`]: https://api.dart.dev/stable/dart-io/File/readAsString.html

Why does it matter whether a method is synchronous or asynchronous?
It matters because most apps need to do more than one thing at a time.
For example, an app might start an HTTP request,
but need to update its display or respond to user input
before the HTTP request completes.
Asynchronous code helps apps stay responsive.

### The async-await syntax
The `async` and `await` keywords provide a declarative way to define asynchronous functions and use their results.

Here’s an example of some synchronous code that blocks while waiting for file I/O:

```dart
void main() {
  // Read some data.
  final fileData = _readFileSync();
  final jsonData = jsonDecode(fileData);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}

String _readFileSync() {
  final file = File(filename);
  return file.readAsStringSync();
}
```

Here’s similar code, but with changes (highlighted) to make it asynchronous:

{% prettify dart tag=pre+code %}
[!Future<void>!] main() [!async!] {
  // Read some data.
  final fileData = [!await!] _readFileAsync();
  final jsonData = jsonDecode(fileData);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}

[!Future<String>!] _readFileAsync() [!async!] {
  final file = File(filename);
  return [!await!] file.[!readAsString()!];
}
{% endprettify %}

The `main()` function uses the `await` keyword in front of `_readFileAsync()`
to let other Dart code (such as event handlers) use the CPU
while native code (file I/O) executes.
Using `await` also has the effect of
converting the `Future<String>` returned by `_readFileAsync()` into a `String`.
As a result, the `fileData` variable has the implicit type `String`.

{{site.alert.note}}
  The `await` keyword works only in functions that
  have `async` before the function body.
{{site.alert.end}}

As the following figure shows,
the Dart code pauses while `readAsString()` executes non-Dart code,
in either the Dart virtual machine (VM) or the operating system (OS).
Once `readAsString()` returns a value, Dart code execution resumes.

![Flowchart-like figure showing app code executing from start to exit, waiting for native I/O in between](/guides/language/concurrency/images/basics-await.png)

If you’d like to learn more about using `async`, `await`, and futures,
visit the [asynchronous programming codelab][].

[asynchronous programming codelab]: /codelabs/async-await


## How isolates work

Most modern devices have multi-core CPUs.
To take advantage of all those cores,
developers sometimes use shared-memory threads running concurrently.
However, shared-state concurrency is
[error prone](https://en.wikipedia.org/wiki/Deadlock) and
can lead to complicated code.

Instead of threads, all Dart code runs inside of isolates.
Each isolate has its own memory heap,
ensuring that none of the state in an isolate is accessible from
any other isolate.
Because there’s no shared memory, you don’t have to worry about
[mutexes or locks](https://en.wikipedia.org/wiki/Lock_(computer_science)).

Using isolates, your Dart code can perform multiple independent tasks at once,
using additional processors if they’re available.
Isolates are like threads or processes,
but each isolate has its own memory and a single thread running an event loop.

You often don’t need to think about isolates at all.
A typical Dart app executes all its code in a single isolate
called the main isolate, as shown in the following figure:

![A figure showing a main isolate, which runs `main()`, responds to events, and then exits](/guides/language/concurrency/images/basics-main-isolate.png)

Even single-isolate programs can execute smoothly
by using async-await to wait for asynchronous operations to complete
before continuing to the next line of code.
A well-behaved app starts quickly,
getting to the event loop as soon as possible.
The app then responds to each queued event promptly,
using asynchronous operations as necessary.

As the following figure shows,
every isolate starts by running some Dart code,
such as the `main()` function.
This Dart code might register some event listeners —
to respond to user input or file I/O, for example.
When the isolate's initial function returns,
the isolate stays around if it needs to handle events.
After handling the events, the isolate exits.

![A more general figure showing that any isolate runs some code, optionally responds to events, and then exits](/guides/language/concurrency/images/basics-isolate.png)

In a client app, the main isolate’s event queue might contain
repaint requests and notifications of tap and other UI events, like this:
***[PENDING: describe the figure in more detail.]***

![PENDING: alt text here](/guides/language/concurrency/images/event-loop.png)

The event handling happens on the main isolate after `main()` exits:
***[PENDING: describe the figure in more detail.]***

![PENDING: alt text here](/guides/language/concurrency/images/event-handling.png)

If a synchronous operation takes too much processing time,
the app can become unresponsive.
In the following figure, the tap-handling code takes too long,
so subsequent events are handled too late:
***[PENDING: describe the figure in more detail.]***

![PENDING: alt text here](/guides/language/concurrency/images/event-jank.png)

In client apps, the result of a too-lengthy synchronous operation is often
[janky (non-smooth) UI animation][jank].
Worse, the UI might become completely unresponsive.

[jank]: https://docs.flutter.dev/perf/rendering


### Using a single-task background worker

If your app’s UI becomes unresponsive due to a time-consuming computation —
[parsing a large JSON file][json], for example —
consider offloading that computation to a background worker.
A common case, which is supported by the [Flutter `compute()` function][],
is spawning an isolate that performs a computation and then exits:
***[PENDING: describe the figure in a little more detail.]***

[json]: https://docs.flutter.dev/cookbook/networking/background-parsing)
 [Flutter `compute()` function]: https://docs.flutter.dev/cookbook/networking/background-parsing#4-move-this-work-to-a-separate-isolate

![PENDING: alt text here](/guides/language/concurrency/images/isolate-bg-worker.png)

A background worker can perform I/O
(reading and writing files, for example), set timers, and more.
It has its own memory (including its own copy of code) and
doesn’t share any state with the main isolate.


### Using the Isolate API

Sometimes you might need to use the `Isolate` API directly.
For example, you might use the `Isolate` API if
your Dart Native app needs any of the following:

* A background worker like what `compute()` supports,
  but that might not be running in a Flutter app
* A background worker that can
  handle multiple requests or send multiple replies,
  as shown in the following figure
* Some other custom isolate behavior

![PENDING: alt text here](/guides/language/concurrency/images/isolate-custom-bg-worker.png)
<br>
***[PENDING: The top arrow should be labeled "Create isolate: Isolate.spawn()"]***

As the preceding figure shows,
to use the `Isolate` API you start with the `Isolate.spawn()` method.
Isolates then communicate by passing messages.

{{site.alert.info}}
  **API note:**
  When an isolate calls `Isolate.spawn()`,
  it sets up the new isolate with a copy of the calling isolate’s code.
  In some special cases —
  for example, when implementing tools like `dart pub run` —
  you might need to use the much slower `Isolate.spawnUri()`,
  which sets up the new isolate with a copy of the code at the specified URI.
{{site.alert.end}}

Each isolate message can deliver one object,
which includes anything that’s transitively reachable from that object.
Not all object types are sendable, and
the send fails if any transitively reachable object is unsendable.
For example, you can send an object of type `List<Object>` only if
none of the objects in the list is unsendable.
If one of the objects is, say, a `Socket`, then
the send fails because sockets are unsendable.

For information on the kinds of objects that you can send in messages,
see the API reference documentation for the [`send()` method][].

[`send()` method]: https://api.dart.dev/stable/dart-isolate/SendPort/send.html

{{site.alert.tip}}
  The `send()` method can be slow.
  When possible,
  avoid using `send()` to send large amounts of data.
  Instead, send the data when the worker isolate exits,
  as described in the next section.
{{site.alert.end}}


#### Spawning a simple background worker

This section shows the implementation for a
main isolate and the simple background worker that it spawns.
The result is similar to what the Flutter `compute()` function provides.

Here’s the code for the main isolate:

```dart
Future<void> main() async {
  // Read some data.
  final jsonData = await _spawnIsolate();

  // Use that data
  print('number of JSON keys = ${jsonData.length}');
}

// Spawns an isolate and waits for the first message
Future<Map<String, dynamic>> _spawnIsolate() async {
  final p = ReceivePort();
  await Isolate.spawn(_readAndParseJson, p.sendPort);
  return await p.first;
}
```

The `_spawnIsolate()` function contains the code that
_spawns_ (creates and starts) the isolate for the background worker,
and then returns the result:

1. Before spawning the isolate, the code creates a [`ReceivePort`][],
   which enables the background worker
   to send messages to the main isolate.

2. Next is the call to `Isolate.spawn()`,
   which creates and start the isolate for the background worker.
   The first argument to `Isolate.spawn()` is the function that
   the background worker executes: `_readAndParseJson`.
   The second argument is the [`SendPort`][]
   that the background worker can use to send messages to the main isolate.
   The code doesn't _create_ a `SendPort`;
   it uses the `sendPort` property of the `ReceivePort`.

3. Once the isolate is spawned, the code waits for the result.
   The `ReceivePort` class implements `Stream`,
   so this code can use the [`first`][] property to get
   the single message that the background worker sends.

[`ReceivePort`]: https://api.dart.dev/stable/dart-isolate/ReceivePort-class.html
[`SendPort`]: https://api.dart.dev/stable/dart-isolate/SendPort-class.html
[`first`]: https://api.dart.dev/stable/dart-async/Stream/first.html

The spawned isolate executes the following code:

```dart
Future _readAndParseJson(SendPort p) async {
  final fileData = await File(filename).readAsString();
  final jsonData = jsonDecode(fileData);
  Isolate.exit(p, jsonData);
}
```

The interesting line is the last one, which exits the isolate,
sending `jsonData` to the `SendPort`.
Message passing between isolates normally involves data copying,
and thus can be slow and increases with the size of the message —
O(n) in big O notation.
However, when you send the data using `Isolate.exit()`,
then the memory that holds the message in the exiting isolate isn’t copied,
but instead is transferred to the receiving isolate.
That transfer is quick and completes in constant time — O(1).

{{site.alert.version-note}}
  `Isolate.exit()` was added in 2.15.
  Previous releases support only explicit message passing,
  using `Isolate.send()`.
{{site.alert.end}}

The following figure summarizes the communication between
the main isolate and the second isolate:

![PENDING: alt text here](/guides/language/concurrency/images/isolate-api.png)


#### Other examples

For more examples of using the Isolate API, see the following:

* ***[PENDING: link to example 4 in Isolate snippets][]***,
  which shows how to send a message from
  the main isolate to the spawned isolate.
  It’s otherwise similar to the preceding example.
* ***[PENDING: link to example 5 in Isolate snippets][]***,
  which shows how to spawn a long-running isolate that
  receives and sends multiple times.

-------------------

## NOTES/QUESTIONS/TODOs (TO BE DELETED)

TODO:
* Ask John to publish examples 4 & 5 in dart-lang/samples; link to them
  (remove Other examples section if they aren't up by the time this page is
  published).
* Use macros in links to API & Flutter docs.
* Add alt text to figures.
* Decide whether to keep figure captions or delete them. Whatever we decide, format & use them consistently.
* Use code excerpts.
* In text before figures, describe the figure content well enough to help people who translate the page or have accessibility issues.
* Add a description in the yaml section.
* Maybe add a figure up high in the doc? (if so, what?)
* Search for and resolve all PENDING items.
* Delete this section.

Qs:
* We say that Isolate.spawn() sets up the new isolate with a "copy of [the calling isolate's] code". Is that accurate? Should it instead be something like "with read access to the calling isolate's code"?
* The figures are by the index file, under images. Should we instead use the asset system? E.g., see the source for the following figure:

<img src="{% asset number-class-hierarchy.svg @path %}" alt="Object is the parent of num, which is the parent of int and double">


[`BigInt`]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/BigInt-class.html
[`fixnum`]: {{site.pub-pkg}}/fixnum
