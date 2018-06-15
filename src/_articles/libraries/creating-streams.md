---
title: "Creating Streams in Dart"
description: "A stream is a sequence of results; learn how to create your own."
written: 2013-04-08
category: libraries
obsolete: true
---

<style>
.comment {color:red;}
</style>

_Written by Lasse Nielsen <br>
April 2013_

The dart:async library contains two types
that are important for many Dart APIs:
[Stream]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html) and
[Future]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html).
Where a Future represents the result of a single computation,
a stream is a _sequence_ of results.
You listen on a stream to get notified of the results
(both data and errors)
and of the stream shutting down.
You can also pause the stream or stop listening to it.

But this article is not about _using_ streams.
It's about creating your own streams.
You can create streams by transforming existing streams,
by using a StreamController,
or if necessary by extending Stream itself.
This article shows the code for each approach
and gives tips to help you implement your stream correctly.

<aside class="alert alert-info" markdown="1">
**Note:**
This article was updated in October 2013
to remove sections that used the obsolete EventTransformStream
and StreamEventTransformer classes.
For details on how stream transformers have changed, see the
[breaking change notice](https://groups.google.com/a/dartlang.org/d/msg/misc/7sAIhWXfIKQ/PzYJy1QqtWUJ).
</aside>

For help on using streams, see
[Asynchronous Programming: Streams](/tutorials/language/streams).

## Transforming an existing stream

If you already have a stream
and just want to transform the events in some way,
you can use Stream's transforming methods
such as `map()`, `where()`, `expand()`, and `take()`.
If you need more control over the transformation,
you can use Stream's `transform()` method.

For example, say someone else has implemented a function called
timedCounter() that returns a stream of steadily incrementing integers.
To get and use the stream returned by the function,
you use code like this
(from [stream_controller.dart](code/stream_controller.dart)):

{% prettify dart %}
Stream<int> counterStream = timedCounter(const Duration(seconds: 1), 15);
counterStream.listen(print);      // Print an integer every second, 15 times.
{% endprettify %}

To transform the stream,
you can invoke a transforming method such as `map()`
on the stream:

{% prettify dart %}
Stream<int> counterStream2 =
    timedCounter(const Duration(seconds: 1), 15)
    .map((int x) => x * 2);       // Double the integer in each event.
counterStream2.listen(print);
{% endprettify %}

Instead of `map()`, you could use any transforming method, such as:

{% prettify dart %}
.where((int x) => x.isEven);      // Retain only even integer events.
.expand((var x) => [x, x]);       // Duplicate each event.
.take(5);                         // Stop after the first five events.
{% endprettify %}

Often, a transforming method is all you need.
However, if you need more control over the transformation,
you can specify a
[StreamTransformer]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/StreamTransformer-class.html)
with Stream's `transform()` method.

{% comment %}
For example, the following code
(from [transformer.dart](code/transformer.dart))
combines data from multiple events
into a single event, using transform() with a
[StreamEventTransformer]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/StreamEventTransformer-class.html) subclass:

{% prettify dart %}
/// Combines strings, breaking them at 80 characters.
class BlockBreaker extends StreamEventTransformer<String, String> {
  String carry = '';
  void handleData(String data, EventSink<String> output) {
    data = carry + data;
    data = data.replaceAll('\n', ' '); // Remove newlines.
    while (data.length >= 80) {
      output.add(data.substring(0, 80));
      data = data.substring(80);
    }
    carry = data;
  }
  void handleError(Error error, EventSink<String> output) {
    output.addError(error);
  }
  void handleDone(EventSink<String> output) {
    if (carry.length > 0) {
      output.add(carry);
    }
    output.close();
  }
}

main() {
  // ...
  Stream lines = text.stream.transform(new BlockBreaker());
  // ...
}
{% endprettify %}

<aside class="alert alert-info" markdown="1">
**Note:**
The handleError() method
in the preceding example could be omitted,
since it's just duplicating the default behavior
inherited from StreamEventTransformer.
</aside>
{% endcomment %}

## Using a StreamController

When you need to implement a stream, consider using
[StreamController]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/StreamController-class.html).
Creating a StreamController gives you a new stream
and allows you to add events to the stream.
The stream has all the logic necessary to handle listeners and pausing.
You can then return the stream and keep the controller to yourself.

The following example
(from [stream_controller_bad.dart](code/stream_controller_bad.dart))
shows a basic, though flawed, usage of StreamController
to implement the timedCounter() function from the previous examples.
This code creates a stream to return,
and then feeds data into it.

{% prettify dart %}
// NOTE: This implementation is FLAWED!
// It starts before it has subscribers, and it doesn't implement pause.
Stream<int> timedCounter(Duration interval, [int maxCount]) {
  StreamController<int> controller = new StreamController<int>();
  int counter = 0;
  void tick(Timer timer) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (maxCount != null && counter >= maxCount) {
      timer.cancel();
      controller.close();    // Ask stream to shut down and tell listeners.
    }
  }
  new Timer.periodic(interval, tick); // BAD: Starts before it has subscribers.
  return controller.stream;
}
{% endprettify %}

As before, you can use the stream returned by timedCounter() like this:

{% prettify dart %}
main() {
  Stream<int> counterStream = timedCounter(const Duration(seconds: 1), 15);
  counterStream.listen(print);      // Print an integer every second, 15 times.
}
{% endprettify %}

This implementation of timedCounter() has
a couple of problems:

* It starts producing events before it has subscribers.
* It keeps producing events even if the subscriber requests a pause.

As the next sections show,
you can fix both of these problems by specifying
callbacks such as `onListen` and `onPause`
when creating the StreamController.


### Waiting for a subscription

As a rule, streams should wait for subscribers before starting their work.
When a stream has no subscriber,
its StreamController buffers events,
which can lead to a memory leak
if the stream never gets a subscriber.

Try changing main() to the following:

{% prettify dart %}
main() {
  var counterStream = timedCounter(const Duration(seconds: 1), 15);

  // After 5 seconds, add a listener.
  new Timer(const Duration(seconds: 5), () => counterStream.listen(print));
}
{% endprettify %}

When this code runs,
nothing is printed for the first 5 seconds,
although the stream is doing work.
Then the listener is added,
and the first 10 or so events are printed all at once,
since they were buffered by the StreamController.

To be notified of subscriptions, specify an
`onListen` argument when you create the StreamController.
The onListen callback is called
when the stream gets its first subscriber.
If you specify an `onCancel` callback,
it's called when the controller loses its last subscriber.
In the preceding example,
`new Timer.periodic()`
should move to an onListen handler,
as shown in the next section.


### Honoring the pause state

Avoid producing events when the listener has requested a pause.
StreamController buffers events during the pause,
but if the stream doesn't respect the pause,
the size of the buffer can grow indefinitely.
Also, if the listener stops listening soon after pausing,
then the work spent creating the buffer is wasted.

To see what happens without pause support,
try changing the main() method above to this:

{% prettify dart %}
main() {
  Stream<int> counterStream = timedCounter(const Duration(seconds: 1), 15);
  StreamSubscription<int> subscription;
  subscription = counterStream.listen((int counter) {
    print(counter);  // Print an integer every second.
    if (counter == 5) {
      // After 5 ticks, pause for five seconds, then resume.
      subscription.pause();
      new Timer(const Duration(seconds: 5), subscription.resume);
    }
  });
}
{% endprettify %}

When the five seconds of pause are up,
the events fired during that time are all received at once.
That happens because the stream's source doesn't honor pauses
and keeps adding events to the stream.
So the stream has to buffer the events,
and it then empties its buffer when the stream becomes unpaused.

The following version of timedCounter()
(from [stream_controller.dart](code/stream_controller.dart))
implements pause by using the
`onListen`, `onPause`, `onResume`, and `onCancel` callbacks
on the StreamController.
{% comment %}
PENDING: check whether onCancel is really needed.
{% endcomment %}

{% prettify dart %}
import 'dart:async';

Stream<int> timedCounter(Duration interval, [int maxCount]) {
  StreamController<int> controller;
  Timer timer;
  int counter = 0;

  void tick(_) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (maxCount != null && counter >= maxCount) {
      timer.cancel();
      controller.close();    // Ask stream to shut down and tell listeners.
    }
  }

  void startTimer() {
    timer = new Timer.periodic(interval, tick);
  }

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  controller = new StreamController<int>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller.stream;
}
{% endprettify %}

Run this code with the main() method above.
You'll see that it stops counting while paused,
and it resumes nicely afterwards.

You must use all of the listeners—`onListen`,
`onCancel`, `onPause`, and `onResume`—to be
notified of changes in pause state.
The reason is that if the
subscription and pause states both change at the same time,
only the onListen or onCancel callback is called.

{% comment %}
## Extending EventTransformStream

If you need to implement a stream
but are really just transforming events from another stream,
you can extend
[EventTransformStream]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/EventTransformStream-class.html).
Here's an example
from [event_transform_stream.dart](code/event_transform_stream.dart):

{% prettify dart %}
class MyMultiplyingStream extends EventTransformStream<int, int> {
  // Create a new stream that repeats all events of [source] [times] times.
  MyMultiplyingStream(Stream<int> source, int times)
      : super(source, new MultiplyingEventTransformer(times));

  // And the reason you needed to extend Stream.
  num someMethodOnMyStream() => 42;
}

class MultiplyingEventTransformer extends StreamEventTransformer<int, int> {
  final int times;
  MultiplyingEventTransformer(this.times);

  void handleData(int data, EventSink<int> sink) {
    for (int i = 0; i < times; i++) sink.add(data);
  }
}

main() {
  Stream<int> stream =
      new MyMultiplyingStream(timedCounter(const Duration(seconds: 1), 15), 2);
  stream.listen(print);  // Prints 1, 1, 2, 2, ..., 15, 15.
}
{% endprettify %}
{% endcomment %}

## Extending Stream

Usually one of the preceding solutions is sufficient, and preferable,
to creating a new class that is itself a Stream.
However, in some cases
you might want to extend the Stream class itself
with extra functionality.
Or you might just want to be able to create a stream
using a constructor call like
`new MyFancyStream(something)`.

If creating a Stream class is really necessary,
don't try to implement Stream from scratch.
The subscription, event firing, and callback logic is complex,
and it's much easier to piggyback on the existing implementation.

Instead, extend the abstract Stream class,
adding the extra functionality you want.
Forward your class's listen() method to an existing stream—for
example, the stream of a StreamController.
All the other methods inherited from Stream work by calling listen(),
so they work as if called on the underlying stream.

The following code
(from [line_stream.dart](code/line_stream.dart))
has a LineStream class
that extends Stream\<String\>:

{% prettify dart %}
import 'dart:async';

class LineStream extends Stream<String> {
  Stream<String> _source;
  StreamSubscription<String> _subscription;
  StreamController<String> _controller;
  int _lineCount = 0;
  String _remainder = '';

  LineStream(Stream<String> source) : _source = source {
    _controller = new StreamController<String>(
      onListen: _onListen,
      onPause: _onPause,
      onResume: _onResume,
      onCancel: _onCancel);
  }

  int get lineCount => _lineCount;

  StreamSubscription<String> listen(void onData(String line),
                                    { void onError(Error error),
                                      void onDone(),
                                      bool cancelOnError }) {
    return _controller.stream.listen(onData,
                                     onError: onError,
                                     onDone: onDone,
                                     cancelOnError: cancelOnError);
  }

  void _onListen() {
    _subscription = _source.listen(_onData,
                                   onError: _controller.addError,
                                   onDone: _onDone);
  }

  void _onCancel() {
    _subscription.cancel();
    _subscription = null;
  }

  void _onPause() {
    _subscription.pause();
  }

  void _onResume() {
    _subscription.resume();
  }

  void _onData(String input) {
    List<String> splits = input.split('\n');
    splits[0] = _remainder + splits[0];
    _remainder = splits.removeLast();
    _lineCount += splits.length;
    splits.forEach(_controller.add);
  }

  void _onDone() {
    if (!_remainder.isEmpty) _controller.add(_remainder);
    _controller.close();
  }
}
{% endprettify %}

Notice that while our stream here extends Stream,
it doesn't implement listener handling and pausing itself.
Instead it just forwards the listen() method
to the full stream implementation from a StreamController.
All the other methods on the Stream class
are implemented in terms of listen(),
so they effectively work on the controller's stream.


## Final hints

Whichever way you implement your stream,
keep these tips in mind:

* Be careful when using a synchronous controller—for example,
  one created using `new StreamController(sync: true)`.
  When you send an event on an unpaused synchronous controller
  (for example, using the add(), addError(), or close() methods
  defined by [EventSink]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/EventSink-class.html)),
  the event is sent immediately to all listeners on the stream.
  Make sure your stream's public methods
  are ready for event listeners to call them immediately.

* If you use StreamController,
  your listener for `onListen` must not always depend
  on having the value of the StreamSubscription object.
  For example, in the following code,
  an onListen event fires
  (and `handler` is called)
  before the `subscription` variable (a
  [StreamSubscription]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/StreamSubscription-class.html))
  has a valid value.

  {% prettify dart %}
subscription = stream.listen(handler);
  {% endprettify %}

* The `onListen`, `onPause`, `onResume`, and `onCancel`
  callbacks defined by StreamController are
  called by the stream when the stream's state changes,
  but never during the firing of an event
  or during the call of another state change handler.

{% comment %}
The tests for this article are at /src/tests/site/articles/creating-streams.
{% endcomment %}
