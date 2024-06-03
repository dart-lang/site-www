---
title: dart:async
description: Learn about the major features in Dart's dart:async library.
prevpage:
  url: /libraries/dart-core
  title: dart:core
nextpage:
  url: /libraries/dart-math
  title: dart:math
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

Asynchronous programming often uses callback functions, but Dart
provides alternatives: [Future][] and [Stream][] objects. A
Future is like a promise for a result to be provided sometime in the
future. A Stream is a way to get a sequence of values, such as events.
Future, Stream, and more are in the
dart:async library ([API reference][dart:async]).

:::note
You don't always need to use the Future or Stream APIs directly.
The Dart language supports asynchronous coding using
keywords such as `async` and `await`.
Check out the [asynchronous programming codelab](/codelabs/async-await)
for details.
:::

The dart:async library works in both web apps and command-line apps. To
use it, import dart:async:

<?code-excerpt "misc/lib/library_tour/async/future.dart (import)"?>
```dart
import 'dart:async';
```

:::tip
You don't need to import dart:async to use the Future and
Stream APIs, because dart:core exports those classes.
:::

## Future

Future objects appear throughout the Dart libraries, often as the object
returned by an asynchronous method. When a future *completes*, its value
is ready to use.


### Using await

Before you directly use the Future API, consider using `await` instead.
Code that uses `await` expressions can be easier to understand
than code that uses the Future API.

Consider the following function.  It uses Future's `then()` method
to execute three asynchronous functions in a row,
waiting for each one to complete before executing the next one.

<?code-excerpt "misc/lib/library_tour/async/future.dart (run-using-future)"?>
```dart
void runUsingFuture() {
  // ...
  findEntryPoint().then((entryPoint) {
    return runExecutable(entryPoint, args);
  }).then(flushThenExit);
}
```

The equivalent code with await expressions
looks more like synchronous code:

<?code-excerpt "misc/lib/library_tour/async/future.dart (run-using-async-await)"?>
```dart
Future<void> runUsingAsyncAwait() async {
  // ...
  var entryPoint = await findEntryPoint();
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
}
```

An `async` function can catch exceptions from Futures.
For example:

<?code-excerpt "misc/lib/library_tour/async/future.dart (catch)"?>
```dart
var entryPoint = await findEntryPoint();
try {
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
} catch (e) {
  // Handle the error...
}
```

:::important
Async functions return Futures. If you don't want your function to return a
future, then use a different solution. For example, you might call an `async`
function from your function.
:::

For more information on using `await` and related Dart language features,
see the [asynchronous programming codelab](/codelabs/async-await).


### Basic usage

You can use `then()` to schedule code that runs when the future completes. For
example, [`Client.read()`][] returns a Future, since HTTP requests
can take a while. Using `then()` lets you run some code when that Future
has completed and the promised string value is available:

<?code-excerpt "misc/lib/library_tour/async/basic.dart (then)"?>
```dart
httpClient.read(url).then((String result) {
  print(result);
});
```

Use `catchError()` to handle any errors or exceptions that a Future
object might throw.

<?code-excerpt "misc/lib/library_tour/async/basic.dart (catch-error)"?>
```dart
httpClient.read(url).then((String result) {
  print(result);
}).catchError((e) {
  // Handle or ignore the error.
});
```

The `then().catchError()` pattern is the asynchronous version of
`try`-`catch`.

:::important
Be sure to invoke `catchError()` on the result of `then()`—not on
the result of the original `Future`. Otherwise, the
`catchError()` can handle errors only from the original Future's computation,
but not from the handler registered by `then()`.
:::

[`Client.read()`]: {{site.pub-api}}/http/latest/http/Client/read.html

### Chaining multiple asynchronous methods

The `then()` method returns a Future, providing a useful way to run
multiple asynchronous functions in a certain order. 
If the callback registered with `then()` returns a Future, 
`then()` returns a Future that will complete
with the same result as the Future returned from the callback. 
If the callback returns a value of any other type,
`then()` creates a new Future that completes with the value.

<?code-excerpt "misc/lib/library_tour/async/future.dart (then-chain)"?>
```dart
Future result = costlyQuery(url);
result
    .then((value) => expensiveWork(value))
    .then((_) => lengthyComputation())
    .then((_) => print('Done!'))
    .catchError((exception) {
  /* Handle exception... */
});
```

In the preceding example, the methods run in the following order:

1.  `costlyQuery()`
2.  `expensiveWork()`
3.  `lengthyComputation()`

Here is the same code written using await:

<?code-excerpt "misc/lib/library_tour/async/future.dart (then-chain-as-await)"?>
```dart
try {
  final value = await costlyQuery(url);
  await expensiveWork(value);
  await lengthyComputation();
  print('Done!');
} catch (e) {
  /* Handle exception... */
}
```


### Waiting for multiple futures

Sometimes your algorithm needs to invoke many asynchronous functions and
wait for them all to complete before continuing. Use the [Future.wait()][]
static method to manage multiple Futures and wait for them to complete:

<?code-excerpt "misc/lib/library_tour/async/future.dart (wait)" replace="/elideBody;/\/* ... *\//g"?>
```dart
Future<void> deleteLotsOfFiles() async =>  ...
Future<void> copyLotsOfFiles() async =>  ...
Future<void> checksumLotsOfOtherFiles() async =>  ...

await Future.wait([
  deleteLotsOfFiles(),
  copyLotsOfFiles(),
  checksumLotsOfOtherFiles(),
]);
print('Done with all the long steps!');
```

`Future.wait()` returns a future which completes once all the provided
futures have completed. It completes either with their results,
or with an error if any of the provided futures fail. 

### Handling errors for multiple futures

You can also wait for parallel operations on an [iterable]({{site.dart-api}}/{{site.sdkInfo.channel}}/dart-async/FutureIterable/wait.html)
or [record]({{site.dart-api}}/{{site.sdkInfo.channel}}/dart-async/FutureRecord2/wait.html)
of futures.

These extensions return a future with the resulting values of all provided
futures. Unlike `Future.wait`, they also let you handle errors. 

If any future in the collection completes with an error, `wait` completes with a
[`ParallelWaitError`][]. This allows the caller to handle individual errors and
dispose successful results if necessary.

When you _don't_ need the result values from each individual future,
use `wait` on an _iterable_ of futures:

```dart
void main() async {
  Future<void> delete() async =>  ...
  Future<void> copy() async =>  ...
  Future<void> errorResult() async =>  ...
  
  try {
    // Wait for each future in a list, returns a list of futures:
    var results = await [delete(), copy(), errorResult()].wait;

    } on ParallelWaitError<List<bool?>, List<AsyncError?>> catch (e) {

    print(e.values[0]);    // Prints successful future
    print(e.values[1]);    // Prints successful future
    print(e.values[2]);    // Prints null when the result is an error

    print(e.errors[0]);    // Prints null when the result is successful
    print(e.errors[1]);    // Prints null when the result is successful
    print(e.errors[2]);    // Prints error
  }

}
```

When you _do_ need the individual result values from each future,
use `wait` on a _record_ of futures.
This provides the additional benefit that the futures can be of different types:

```dart
void main() async {
  Future<int> delete() async =>  ...
  Future<String> copy() async =>  ...
  Future<bool> errorResult() async =>  ...

  try {    
    // Wait for each future in a record, returns a record of futures:
    (int, String, bool) result = await (delete(), copy(), errorResult()).wait;
  
  } on ParallelWaitError<(int?, String?, bool?),
      (AsyncError?, AsyncError?, AsyncError?)> catch (e) {
    // ...
    }

  // Do something with the results:
  var deleteInt  = result.$1;
  var copyString = result.$2;
  var errorBool  = result.$3;
}
```

## Stream

Stream objects appear throughout Dart APIs, representing sequences of
data. For example, HTML events such as button clicks are delivered using
streams. You can also read a file as a stream.


### Using an asynchronous for loop

Sometimes you can use an asynchronous for loop (`await for`)
instead of using the Stream API.

Consider the following function.
It uses Stream's `listen()` method
to subscribe to a list of files,
passing in a function literal that searches each file or directory.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (listen)" replace="/listen/[!$&!]/g"?>
```dart
void main(List<String> arguments) {
  // ...
  FileSystemEntity.isDirectory(searchPath).then((isDir) {
    if (isDir) {
      final startingDir = Directory(searchPath);
      startingDir.list().[!listen!]((entity) {
        if (entity is File) {
          searchFile(entity, searchTerms);
        }
      });
    } else {
      searchFile(File(searchPath), searchTerms);
    }
  });
}
```

The equivalent code with await expressions,
including an asynchronous for loop (`await for`),
looks more like synchronous code:

<?code-excerpt "misc/lib/library_tour/async/stream.dart (await-for)" replace="/await for/[!$&!]/g"?>
```dart
void main(List<String> arguments) async {
  // ...
  if (await FileSystemEntity.isDirectory(searchPath)) {
    final startingDir = Directory(searchPath);
    [!await for!] (final entity in startingDir.list()) {
      if (entity is File) {
        searchFile(entity, searchTerms);
      }
    }
  } else {
    searchFile(File(searchPath), searchTerms);
  }
}
```

:::important
Before using `await for`, make sure that it makes the code clearer and that
you really do want to wait for all of the stream's results. For example, you
usually should **not** use `await for` for DOM event listeners, because the
DOM sends endless streams of events. If you use `await for` to register two
DOM event listeners in a row, then the second kind of event is never handled.
:::

For more information on using `await` and related
Dart language features, see the
[asynchronous programming codelab](/codelabs/async-await).


### Listening for stream data

To get each value as it arrives, either use `await for` or
subscribe to the stream using the `listen()` method:

<?code-excerpt "misc/lib/library_tour/async/stream_web.dart (listen)" replace="/listen/[!$&!]/g"?>
```dart
// Add an event handler to a button.
submitButton.onClick.[!listen!]((e) {
  // When the button is clicked, it runs this code.
  submitData();
});
```

In this example, the `onClick` property is a `Stream` object provided by
the submit button.

If you care about only one event, you can get it using a property such
as `first`, `last`, or `single`. To test the event before handling it,
use a method such as `firstWhere()`, `lastWhere()`, or `singleWhere()`.
{% comment %}
{PENDING: example}
{% endcomment %}

If you care about a subset of events, you can use methods such as
`skip()`, `skipWhile()`, `take()`, `takeWhile()`, and `where()`.
{% comment %}
{PENDING: example}
{% endcomment %}


### Transforming stream data

Often, you need to change the format of a stream's data before you can
use it. Use the `transform()` method to produce a stream with a
different type of data:

<?code-excerpt "misc/lib/library_tour/async/stream.dart (transform)"?>
```dart
var lines =
    inputStream.transform(utf8.decoder).transform(const LineSplitter());
```

This example uses two transformers. First it uses utf8.decoder to
transform the stream of integers into a stream of strings. Then it uses
a LineSplitter to transform the stream of strings into a stream of
separate lines. These transformers are from the dart:convert library (see the
[dart:convert section](/libraries/dart-convert)).
{% comment %}
  PENDING: add onDone and onError. (See "Streaming file contents".)
{% endcomment %}


### Handling errors and completion

How you specify error and completion handling code
depends on whether you use an asynchronous for loop (`await for`)
or the Stream API.

If you use an asynchronous for loop,
then use try-catch to handle errors.
Code that executes after the stream is closed
goes after the asynchronous for loop.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (read-file-await-for)" replace="/try|catch/[!$&!]/g"?>
```dart
Future<void> readFileAwaitFor() async {
  var config = File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines =
      inputStream.transform(utf8.decoder).transform(const LineSplitter());
  [!try!] {
    await for (final line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } [!catch!] (e) {
    print(e);
  }
}
```

If you use the Stream API,
then handle errors by registering an `onError` listener.
Run code after the stream is closed by registering
an `onDone` listener.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (on-done)" replace="/onDone|onError/[!$&!]/g"?>
```dart
var config = File('config.txt');
Stream<List<int>> inputStream = config.openRead();

inputStream.transform(utf8.decoder).transform(const LineSplitter()).listen(
    (String line) {
  print('Got ${line.length} characters from stream');
}, [!onDone!]: () {
  print('file is now closed');
}, [!onError!]: (e) {
  print(e);
});
```


## More information

For some examples of using Future and Stream in command-line apps,
check out the [dart:io documentation][].
Also see these articles, codelabs, and tutorials:

- [Asynchronous programming: futures, async, await](/codelabs/async-await)
- [Futures and error handling](/libraries/async/futures-error-handling)
- [Asynchronous programming: streams](/tutorials/language/streams)
- [Creating streams in Dart](/libraries/async/creating-streams)
- [Dart asynchronous programming: Isolates and event loops](/language/concurrency)


[Future.wait()]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-async/Future/wait.html
[Future]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-async/Future-class.html
[`ParallelWaitError`]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-async/ParallelWaitError-class.html
[Stream]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-async/Stream-class.html
[dart:async]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-async/dart-async-library.html
[dart:io documentation]: /libraries/dart-io
