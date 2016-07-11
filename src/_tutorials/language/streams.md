---
title: "Asynchronous Programming: Streams"
description: "Learn how to consume single-subscriber and broadcast streams."

prevpage:
  url: /tutorials/language/futures
  title: "Asynchronous Programming: Futures"
---

<div class="panel" markdown="1">

#### <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>What's the point?

* Streams provide an asynchronous sequence of data.
* Data sequences include user-generated events and data read from files.
* You can process a stream using either **await for** or listen() from the Stream API.
* Streams provide a way to respond to errors.
* There are two kinds of streams: single subscription or broadcast.

</div>

Asynchronous programming in Dart is characterized by the
Future and Stream classes.

A Future represents a computation that doesn't complete immediately.
Where a normal function returns the result, an asynchronous function
returns a Future, which will eventually contain the result.
The future will tell you when the result is ready.

A stream is a sequence of asynchronous events.
It is like an asynchronous Iterable&mdash;where, instead of getting
the next event when you ask for it, the stream tells you that
there is an event when it is ready.

## Receiving stream events {#receiving-stream-events}

Streams can be created in many ways, which is a topic for another
article, but they can all be used in the same way: the _asynchronous
for loop_ (commonly just called **await for**)
iterates over the events of a stream like the **for loop** iterates
over an Iterable. For example:

{% prettify dart %}
Future<int> sumStream(Stream<int> stream) [[highlight]]async[[/highlight]] {
  var sum = 0;
  [[highlight]]await for[[/highlight]] (var value in stream) {
    sum += value;
  }
  return sum;
}
{% endprettify %}

This code simply receives each event of a stream of integer events,
adds them up, and returns (a future of) the sum.
When the loop body ends,
the function is paused until the next event arrives or the stream is done.

The function is marked with the `async` keyword, which is required
when using the **await for** loop.

The following example tests the previous code by
generating a simple stream of integers using an `async*` function:

{% comment %}
https://gist.github.com/Sfshaza/15d5ef986238c97dbc14

import 'dart:async';

Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  await for (var value in stream) {
    sum += value;
  }
  return sum;
}

Stream<int> countStream(int to) async* {
  for (int i = 1; i <= to; i++) {
    yield i;
  }
}

main() async {
  var stream = countStream(10);
  var sum = await sumStream(stream);
  print(sum); // 55
}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-dart-prefix}}?id=15d5ef986238c97dbc14&horizontalRatio=70&verticalRatio=80"
    width="100%"
    height="500px"
    style="border: 1px solid #ccc;">
</iframe>

<aside class="alert alert-info" markdown="1">
**Note:**
Click run ( {% img 'run.png' %} )
to see the result in the **Console output**.
</aside>

## Error events {#error-events}

Streams are done when there are no more events in them,
and the code receiving the events is notified of this just as
it is notified that a new event arrives.
When reading events using an **await for** loop,
the loops stops when the stream is done.

In some cases, an error happens before the stream is done;
perhaps the network failed while fetching a file from a remote server,
or perhaps the code creating the events has a bug,
but someone needs to know about it.

Streams can also deliver error events like it delivers data events.
Most streams will stop after the first error,
but it is possible to have streams that deliver more than one error,
and streams that deliver more data after an error event.
In this document we only discuss streams that deliver at most one error.

When reading a stream using **await for**, the error is thrown by the
loop statement. This ends the loop, as well. You can catch the
error using **try-catch**.  The following example throws an
error when the loop iterator equals 4:

{% comment %}
https://gist.github.com/Sfshaza/38feef09be9b1e7b5136

import 'dart:async';

Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  try {
    await for (var value in stream) {
      sum += value;
    }
  } catch (error) {
    return -1;
  }
  return sum;
}

Stream<int> countStream(int to) async* {
  for (int i = 1; i <= to; i++) {
    if (i == 4) {
      throw "Whoops!";  // Intentional error
    } else {
      yield i;
    }
  }
}

main() async {
  var stream = countStream(10);
  var sum = await sumStream(stream);
  print(sum); // -1
}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-dart-prefix}}?id=38feef09be9b1e7b5136&horizontalRatio=70&verticalRatio=80"
    width="100%"
    height="450px"
    style="border: 1px solid #ccc;">
</iframe>

<aside class="alert alert-info" markdown="1">
**Note:**
Click run ( {% img 'run.png' %} )
to see the result in the **Console output**.
</aside>


## Working with streams {#working-with-streams}

It's easy to work with streams by looping through the events and
handling them one at a time.
For example, finding the last positive integer in a stream can
be done by testing the value in an **await for** loop:

{% comment %}
https://gist.github.com/Sfshaza/da80b1e7eed75db53ef3

import 'dart:async';

Future<int> lastPositive(Stream<int> stream) async {
  var lastValue = null;
  await for (var value in stream) {
    if (value < 0) continue;
    lastValue = value;
  }
  return lastValue;
}

main() async {
  var data = [1, -2, 3, -4, 5, -6, 7, -8, 9, -10];
  var stream = new Stream.fromIterable(data);
  var lastPositive = await lastPositive(stream);
  print(lastPositive); // 9
}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-dart-prefix}}?id=da80b1e7eed75db53ef3&horizontalRatio=70&verticalRatio=80"
    width="100%"
    height="450px"
    style="border: 1px solid #ccc;">
</iframe>

<aside class="alert alert-info" markdown="1">
**Note:**
Click run ( {% img 'run.png' %} )
to see the result in the **Console output**.
</aside>

The Stream class contains a number of helper methods that can do
common operations on a stream for you,
similar to the methods on an Iterable.
For example, the previous code could be written using
`lastWhere()` from the Stream API.

Try replacing the `lastPositive()` function with the following:

{% prettify dart %}
Future<int> lastPositive(Stream<int> stream) {
  return stream.lastWhere((x) => x >= 0);
}
{% endprettify %}

## The two kinds of streams {#two-kinds-of-streams}

The are two kinds of streams.

### Single subscription streams {#single-subscription-streams}

The most common kind of stream contains a sequence of events that
are parts of a larger whole.
Events need to be delivered in the correct order and without
missing any of them.
This is the kind of stream you get when you read a file or receive
a web request.

Such a stream can only be listened to once.
Listening again later could mean missing out on initial events,
and then the rest of the stream makes no sense.
When you start listening,
the data will be fetched and provided in chunks.

### Broadcast streams {#broadcast-streams}

The other kind of stream is intended for individual messages that
can be handled one at a time. This kind of stream can be used for
mouse events in a browser, for example.

You can start listening to such a stream at any time,
and you get the events that are fired while you listen.
More than one listener can listen at the same time,
and you can listen again later after canceling a previous
subscription.

## Methods that process a stream {#process-stream-methods}

The following methods on
[Stream&lt;T&gt;]({{site.dart_api}}/dart-async/Stream-class.html)
process the stream and return a result:

{% prettify dart %}
Future<T> get first;
Future<T> get last;
Future<T> get single;
Future<int> get length
Future<bool> get isEmpty
Future<T> firstWhere(bool test(T event), {T orElse()})
Future<T> lastWhere(bool test(T event), {T orElse()})
Future<T> singleWhere(bool test(T event), {T orElse()})
Future<T> reduce(T combine(T previous, T element))
Future fold(initialValue, combine(previous, T element))
Future<String> join([String separator = ""])
Future<bool> contains(Object needle)
Future forEach(void action(T element))
Future<bool> every(bool test(T element))
Future<bool> any(bool test(T element))
Future<List<T>> toList()
Future<Set<T>> toSet()
Future<T> elementAt(int index)
Future pipe(StreamConsumer<T> consumer)
Future drain([var futureValue])
{% endprettify %}

All of these functions, except `drain()` and `pipe()`,
correspond to a similar function on Iterable.
Each one can be written easily by using an async function
with an **await for** loop (or just using one of the other methods).
For example, some implementations could be:

{% prettify dart %}
Future<bool> contains(Object element) async {
  await for (var event in this) {
    if (event == element) return true;
  }
  return false;
}

Future forEach(void action(T element)) async {
  await for (var event in this) {
    action(event);
  }
}

Future<List<T>> toList() async {
  var result = <T>[];
  await this.forEach(result.add);
  return result;
}

Future<String> join([String separator = ""]) async {
  return (await this.toList()).join(separator);
}
{% endprettify %}

(The actual implementations are slightly more complex,
but mainly for historical reasons.)

## Methods that modify a stream {#modify-stream-methods}

The following methods on Stream return a new stream based
on the original stream.
Each one waits until someone listens on the new stream before
listening on the original.

{% prettify dart %}
Stream<T> where(bool test(T event))
Stream map(convert(T event))
Stream expand(Iterable expand(T element);
Stream<T> take(int count)
Stream<T> skip(int count)
Stream<T> takeWhile(bool test(T element))
Stream<T> skipWhile(bool test(T element))
{% endprettify %}

These first seven all correspond to similar methods on Iterable
which transform an iterable into another iterable.
All of these can be written easily using an "async" function
with an **await for** loop.

{% prettify dart %}
Stream<T> distinct([bool equals(T previous, T next)])
Stream asyncExpand(Stream expand(T element))
Stream asyncMap(Future convert(T event))
{% endprettify %}

The `distinct()` function doesn't exist on Iterable, but it could have.
The `asyncExpand()` and `asyncMap()` functions are similar to
`expand()` and `map()`,
but allow their function argument to be an asynchronous function.

{% prettify dart %}
Stream timeout(Duration timeLimit,
               {void onTimeout(EventSink sink)})
Stream<T> handleError(Function onError, {bool test(error)})
Stream transform(StreamTransformer<T, dynamic> streamTransformer)
{% endprettify %}

The final three functions are more special.
They involve error handling which an **await for** loop
can't do&mdash;the first error reaching the loops will end
the loop and its subscription on the stream.
There is no recovering from that.
One can use `handleError()` to remove errors from a stream
before using it in an **await for** loop.

### The transform() function {#transform-function}

The `transform()` function is not just for error handling;
it is a more generalized "map" for streams.
A normal map requires one value for each incoming event.
However, especially for IO streams,
it might take several incoming events to produce an output event.
A StreamTransformer can work with that.
For example, decoders (like the UTF8.decoder) are transformers.
A transformer has only one function, `bind()`, which can be
easily implemented by an **async** function.

{% prettify dart %}
Stream mapNoError(Stream stream, convert(element)) async* {
  var streamNoErrors = stream.handleError((error) {
    log(error);
  });
  await for (var event in streamNoErrors) {
    yield convert(event);
  }
}
{% endprettify %}

### Reading and decoding a file {#reading-decoding-file}

The following code reads a file and runs two transforms over the stream.
It first converts the data from UTF8 and then runs it through
a LineSplitter.
All lines are printed, except any that begin with a hashtag, `#`.

{% prettify dart %}
import 'dart:io';
import 'dart:async';
import 'dart:convert';

main(args) async {
  var file = new File(args[0]);
  var lines = file
      .openRead()
      .transform(UTF8.decoder)
      .transform(const LineSplitter());
  await for (var line in lines) {
    if (!line.startsWith('#')) {
      print(line);
    }
  }
}
{% endprettify %}

## The listen() method {#listen-method}

The final method on Stream is `listen()`. This is a "low-level"
method&mdash;all other stream functions are defined in terms of `listen()`.
To create a new Stream type, you can just extend the Stream
class and implement the `listen()` method&mdash;all other methods
on Stream call listen in order to work.

The listen method allows you to start listening on a stream.
Until you do so,
the stream is an inert object describing what events you want to see.
When you listen,
a StreamSubscription object is returned which represents the
active stream producing events.
This is similar to how an Iterable is just a collection of objects,
but the iterator is the one doing the actual iteration.

The stream subscription allows you to pause the subscription,
resume it after a pause,
and cancel it completely.
You can set callbacks to be called for each data event or
error event, and when the stream is closed.

## Other resources {#other-resources}

Read the following documentation for more details on using streams
and asynchronous programming in Dart.

* [Single-Subscription vs Broadcast Streams](/articles/libraries/broadcast-streams),
  an article about the two different types of streams
* [Creating Streams in Dart](/articles/libraries/creating-streams),
  an article about creating your own streams
* [Futures and Error Handling](/articles/libraries/futures-and-error-handling),
  an article that explains how to handle errors using the Future API
* [Asynchrony support](/guides/language/language-tour#asynchrony),
  a section in the [language tour](/guides/language/language-tour)
* [Stream API reference]({{site.dart_api}}/dart-async/Stream-class.html)

