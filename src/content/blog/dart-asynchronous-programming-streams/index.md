---
title: "Dart asynchronous programming: Streams"
description: "This article covers one of the fundamentals of reactive programming: streams, which are objects of type Stream."
publishDate: 2020-02-11
author: "kwalrath"
image: images/1Q2-Ac9rjIDSuXzbrQqGkVA.png
category: other
tags:
  - programming
  - programming-languages
  - dartlang
  - asynchronous-programming
  - flutter
---


***Note**: You might want to check out a [version of this article where the code is updated to be null safe](https://medium.com/dartlang/dart-asynchronous-programming-streams-dab952023ed7). (The video has not changed.)*

<DashImage src="images/17v26fZu7zzY0QSBQAwj42Q.gif" alt="A simple Flutter app that displays data from a stream" caption="A simple Flutter app that displays data from a stream" />


This article covers one of the fundamentals of reactive programming: streams, which are objects of type [`Stream`](https://api.dart.dev/stable/dart-async/Stream-class.html).

If you’ve read the [previous article on futures](https://medium.com/dartlang/dart-asynchronous-programming-futures-96937f831137), you might remember that **each future represents a single value** (either an error or data) that it delivers **asynchronously**. Streams work similarly, but instead of a single thing, **a stream can deliver zero or more values and errors** over **time.**
> This article is the third one based on the *Flutter in Focus* video series *Asynchronous Programming in Dart*. The first article, [Isolates and event loops](https://medium.com/dartlang/dart-asynchronous-programming-isolates-and-event-loops-bffc3e296a6a), covered the foundations of Dart’s support for background work. The second one, [Futures](https://medium.com/dartlang/dart-asynchronous-programming-futures-96937f831137), discussed the `Future` class.
> If you prefer to learn by watching or listening, everything in this article is covered in the following video.

<YoutubeEmbed id="nQBpOIHE4eE" title="Dart Streams - Flutter in Focus" fullwidth="true"/>


If you think about the way a single value relates to an [iterator](https://dart.dev/codelabs/iterables) of the same type, that’s how a future relates to a stream.

<DashImage src="images/1q9cqGB5uXOX3tNw07SoJnQ.png" />


Just like with futures, the key is deciding in advance, “Here’s what to do when a piece of data is ready, and when there’s an error, and when the stream completes.”

*Also* just like with futures, the Dart event loop is still running the show.

<DashImage src="images/0UVy8BLEUm4CifwDE.png" alt="Streams work with the Dart event loop." caption="Streams work with the Dart event loop." />


If you’re using the `File` class’s [`openRead()`](https://api.dart.dev/stable/dart-io/File/openRead.html) method to read data from a file, for example, that method returns a stream.

Chunks of data are read from disk and arrive at the event loop. A Dart library looks at them and says, “Ah, I’ve got somebody waiting for this,” adds the data to the stream, and it pops out in your app’s code.

When another piece of data arrives, in it goes, and out it comes. Timer-based streams, streaming data from a network socket — they work with the event loop, too, using clock and network events.

## Listening to streams

Let’s talk about how to work with data provided by a stream. Say you have a class that gives you a stream that kicks out a new integer once per second: 1, 2, 3, 4, 5…

You can use the [`listen()`](https://api.dart.dev/stable/dart-async/Stream/listen.html) method to subscribe to the stream. The only required parameter is a function.

```dart
final myStream = NumberCreator().stream;

final subscription = myStream.listen(
  (data) => print('Data: $data'),
);
```

Every time a new value is emitted by the stream, the function gets called and prints the value:

```
Data: 1
Data: 2
Data: 3
Data: 4
...
```


That’s how `listen()` works.
> **Important:** By default, streams are set up for single subscription. They hold onto their values until someone subscribes, and they only allow a single listener for their entire lifespan. If you try to listen to a stream twice, you’ll get an exception.
> Fortunately Dart also offers broadcast streams. You can use the [`asBroadcastStream()`](https://api.dart.dev/stable/dart-async/Stream/asBroadcastStream.html) method to make a broadcast stream from a single subscription one. Broadcast streams work the same as single subscription streams, but they can have multiple listeners, and if nobody’s listening when a piece of data is ready, that data is tossed out.

```dart
final myStream = NumberCreator().stream.asBroadcastStream();

final subscription = myStream.listen(
  (data) => print('Data: $data'),
);

final subscription2 = myStream.listen(
  (data) => print('Data again: $data'),
);
```

Let’s go back to that first `listen()` call, because there are a couple more things to talk about.

As we mentioned earlier, streams can produce errors just like futures can. By adding an `onError` function to the `listen()` call, you can catch and process any error.

There’s also a `cancelOnError` property that’s true by default, but can be set to false to keep the subscription going even after an error.

And you can add an `onDone` function to execute some code when the stream is finished sending data, such as when a file has been completely read.

With all four of those parameters combined — `onError`, `onDone`, `cancelOnError`, and the required parameter (`onData`) — you can be ready in advance for whatever happens.

```dart
final subscription = myStream.listen(
  (data) {
    print('Data: $data');
  },
  onError: (err) {
    print('Error!');
  },
  cancelOnError: false,
  onDone: () {
    print('Done!');
  },
);
```
> **Tip:** The little subscription object that `listen()` returns has some useful methods of its own. It’s a [*`StreamSubscription`*](https://api.dart.dev/stable/dart-async/StreamSubscription-class.html), and you can use it to pause, resume, and even cancel the flow of data.

```dart
final subscription = myStream.listen(...);

subscription.pause();
subscription.resume();
subscription.cancel();
```

## Using and manipulating streams

Now that you know how to use `listen()` to subscribe to a stream and receive data events, we can talk about what makes streams really cool: manipulating them. Once you’ve got data in a stream, a lot of operations become fluent and elegant.

Going back to that number stream from earlier, we can use a method called [`map()`](https://api.dart.dev/stable/dart-async/Stream/map.html) to take each value from the stream and convert it on the fly into something else. Give `map()` a function to do the conversion, and it returns a new stream, typed to match the return value of the function. Instead of a stream of ints, you now have a stream of strings. You can throw a `listen()` call on the end, give it the `print()` function, and now you’re printing strings directly off the stream, asynchronously, as they arrive.

```dart
NumberCreator().stream
    .map((i) => 'String $i')
    .listen(print);
/*
OUTPUT: 
String 1
String 2
String 3
String 4
*/
```

There are a ton of methods that you can chain up like this. If you only want to print the even numbers, for example, you can use [`where()`](https://api.dart.dev/stable/dart-async/Stream/where.html) to filter the stream. Give it a test function that returns a boolean for each element, and it returns a new stream that only includes values that pass the test.

```dart
NumberCreator().stream
    .where((i) => i % 2 == 0)
    .map((i) => 'String $i')
    .listen(print);
/*
OUTPUT:
String 2
String 4
String 6
String 8
*/
```

The [`distinct()`](https://api.dart.dev/stable/dart-async/Stream/distinct.html) method is another good one. If you have an app that uses a Redux store, that store emits new app state objects in an `onChange` stream. You can use `map()` to convert that stream of state objects to a stream of view models for one part of the app. Then you can use the `distinct()` method to get a stream that filters out consecutive identical values (in case the store kicks out a change that doesn’t affect the subset of data in the view model). Then you can listen and update the UI whenever you get a new view model.

```dart
myReduxStore.onChange
    .map((s) => MyViewModel(s))
    .distinct()
    .listen( /* update UI */ );
```

There are a bunch of additional methods built into Dart that you can use to shape and modify your streams. Plus, when you’re ready for even more advanced stuff, there’s the [async package](https://pub.dev/packages/async) maintained by the Dart team and available on [pub.dev](https://pub.dev). It has classes that can merge two streams together, cache results, and perform other types of stream-based wizardry.

<DashImage src="images/1WTHZRJjgF4qQvSDvY0Z9ow.png" alt="Try the async package for more stream-based wizardry." caption="Try the async package for more stream-based wizardry." />


For even more stream magic, take a look at the [stream_transform package](https://pub.dev/packages/stream_transform).

## Creating streams

One advanced topic deserves a mention here, and that’s how to create streams of your own. Just like with futures, most of the time you’re going to be working with streams created for you by network libraries, file libraries, state management, and so on. But you can make your own as well, using a [`StreamController`](https://api.dart.dev/stable/dart-async/StreamController-class.html).

Let’s go back to that `NumberCreator` we’ve been using so far. Here’s the actual code for it:

```dart
class NumberCreator {
  NumberCreator() {
    Timer.periodic(Duration(seconds: 1), (t) {
      _controller.sink.add(_count);
      _count++;
    });
  }

  var _count = 1;
  final _controller = StreamController<int>();
  Stream<int> get stream => _controller.stream;
}

```

As you can see, it keeps a running count, and it uses a timer to increment that count each second. The interesting bit, though, is the stream controller.

A `StreamController` creates a brand new stream from scratch, and gives you access to both ends of it. There’s the stream end itself, where data arrives. (We’ve been using that one throughout this article.)

```
Stream<int> get stream => _controller.stream;
```


Then there’s the sink end, which is where new data gets added to the stream:

```
_controller.sink.add(_count);
```


`NumberCreator` here uses both of them. When the timer goes off, it adds the latest count to the controller’s sink, and then it exposes the controller’s stream with a public property so other objects can subscribe to it.

## Building Flutter widgets using streams

Now that we’ve covered creating, manipulating, and listening to streams, let’s talk about how to put them to work building widgets in Flutter.

If you saw the previous video on futures, you might remember [`FutureBuilder`](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html). You give it a future and a builder method, and it builds widgets based on the state of the future.

For streams, there’s a similar widget called [`StreamBuilder`](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html). Give it a stream and a builder method, and it will rebuild its children whenever a new value is emitted by the stream.

```dart
StreamBuilder<String>(
  stream: NumberCreator().stream.map((i) => 'String $i'),
  builder: (context, snapshot) {
    /* Build widgets! */
  }
)
```

The snapshot parameter is an [`AsyncSnapshot`](https://api.flutter.dev/flutter/widgets/AsyncSnapshot-class.html), just like with `FutureBuilder`. You can check its `connectionState` property to see if the stream hasn’t yet sent any data or if it’s completely finished. You can use the `hasError` property to see if the latest value is an error. And, of course, you can handle data values.

```dart
StreamBuilder<String>(
  stream: NumberCreator().stream.map((i) => 'String $i'),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text('No data yet.');
    } else if (snapshot.connectionState == ConnectionState.done) {
      return Text('Done!');
    }
  }
)
```

The main thing is just to make sure your builder knows how to handle all the possible states of the stream. Once you’ve got that, it can react to whatever the stream does.

## Summary

This article talked about what streams represent, how you get values from a stream, ways to manipulate those values, and how `StreamBuilder` helps you use stream values in a Flutter app.

You can learn more about streams from the Dart and Flutter documentation:

* On [dart.dev](https://dart.dev), see the [streams tutorial](https://dart.dev/tutorials/language/streams), the [command-line app tutorial](https://dart.dev/tutorials/server/cmdline), and the [stream section](https://dart.dev/guides/libraries/library-tour#stream) of the library tour.

* On [flutter.dev](https://flutter.dev), see [Work with WebSockets](https://flutter.dev/docs/cookbook/networking/web-sockets), which features an example that uses `StreamBuilder`.

Or go on to the next video in the *Asynchronous Programming in Dart* series. It talks about `async` and `await`, which are two keywords that Dart offers to help you keep your asynchronous code tight and easy to read.

<YoutubeEmbed id="SmTCmDMi4BY" title="Async/Await - Flutter in Focus" fullwidth="true"/>


*Big thanks to Andrew Brogdon, who created the video that this article is based on.*

<DashImage src="images/1Q2-Ac9rjIDSuXzbrQqGkVA.png" />
