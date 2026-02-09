---
title: "Dart asynchronous programming: Streams"
description: "This article covers one of the fundamentals of reactive programming: streams, which are objects of type Stream."
publishDate: 2022-04-14
author: "flutter_devrel"
image: images/04NRFcYLryiLlUIrT.png
category: other
tags:
  - programming
  - programming-languages
  - dartlang
  - asynchronous-programming
  - flutter
---


<DashImage src="images/0yUEX9fxMxoG63vi0.gif" alt="A simple Flutter app that displays data from a stream" caption="A simple Flutter app that displays data from a stream" />


This article covers one of the fundamentals of reactive programming: streams, which are objects of type [`Stream`](https://api.dart.dev/stable/dart-async/Stream-class.html).

If you’ve read our [previous articles on futures](https://medium.com/dartlang/dart-asynchronous-programming-futures-96937f831137), you might remember that **each future represents a single value **(either an error or data) delivered **asynchronously**. Streams work similarly, only instead of a single thing, **a** **stream** **can deliver zero or more values and errors **over **time**.
> This article was first published in [February 2020](https://medium.com/dartlang/dart-asynchronous-programming-streams-2569a993324d). This version updates the included code to null safety.
> This article is the third one based on the *Flutter in Focus* video series *Asynchronous Programming in Dart*. The first article, [Isolates and event loops](https://medium.com/dartlang/dart-asynchronous-programming-isolates-and-event-loops-bffc3e296a6a), covers the foundations of Dart’s support for background work. The second one, Futures, discusses the `Future` class.
> If you prefer to learn by watching or listening, everything in this article is covered in the following video.

<iframe src="https://www.youtube.com/watch?v=nQBpOIHE4eE" width="854" height="480" frameborder="0" allowfullscreen></iframe>

> **Note**: The code in this article has been updated to reflect best practices and changes to the Dart language (including null safety), which occurred after the video was released on June 28, 2019.

If you think about the way a single value relates to an [iterator](https://dart.dev/codelabs/iterables) of the same type, that’s how a future relates to a stream: a future represents a single request with a single response, where a stream represents a single request with multiple responses.

<DashImage src="images/0e0Lz6RaBIx2uK5R4.png" />


Just like with futures, the key is deciding in advance what to do 1) when a piece of data is ready, 2) when there’s an error, and 3) when the stream completes. As with futures, in this process the Dart event loop is still running the show.

<DashImage src="images/0tYShCv7ndeKeJFsv.png" alt="Streams work with the Dart event loop." caption="Streams work with the Dart event loop." />


### **Event loop pinch**

If you’re using the `File` class’s`[openRead](https://api.dart.dev/stable/dart-io/File/openRead.html)()` method to read data from a file, for example, this method returns a stream.

Chunks of data are read from disk and arrive at the event loop. The Dart library looks at them and says, “Ah, someone is waiting for this,” adds the data to the stream, and sends it to your app.

When another piece of data arrives — in it goes, and out it comes. Timer-based streams and streaming data from a network socket work with the event loop too, using clock and network events.

<DashImage src="images/04NRFcYLryiLlUIrT.png" alt="The event loop sorts the data." caption="The event loop sorts the data." />


### **Listening to streams**

The next thing to understand is how to work with data provided by a stream.

Say you have a class that gives you a stream that emits a new integer once every second (1, 2, 3, 4, 5…). You can use the `[listen](https://api.dart.dev/stable/dart-async/Stream/listen.html)()`method to subscribe to the stream. The only required parameter is a function.

```
final myStream = NumberCreator().stream;

final subscription = myStream.listen(
    (data) => print(‘Data: $data’),
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


That’s how `listen()`works.
> **Important:** By default, streams are set up for single subscription. They hold onto their values until someone subscribes, and they only allow a single listener for their entire lifespan. If you try to listen to a stream twice, you’ll get an exception.
> Fortunately Dart also offers broadcast streams. You can use the [`asBroadcastStream()`](https://api.dart.dev/stable/dart-async/Stream/asBroadcastStream.html) method to make a broadcast stream from a single subscription one. Broadcast streams work the same as single subscription streams, but they can have multiple listeners.
> **Another difference of broadcast streams: **if nobody’s listening when a piece of data is ready, that data is tossed out.

```
`final myStream = NumberCreator().stream;`

final subscription = myStream.listen(
  (data) => print(‘Data: $data’),
);

final subscription2 = myStream.listen(
  (data) => print(‘Data again: $data’),
);
```


Let’s go back to that first `listen()`call, because there are a couple more things to talk about.

As mentioned earlier, streams can produce errors just like futures can. By adding an [`onError`](https://api.dart.dev/stable/2.16.2/dart-async/StreamSubscription/onError.html) function to the `listen()` call, you can catch and process any errors.

There’s also a `cancelOnError`* *property that’s true by default, but can be set to false to keep the subscription going even after an error.

You can add the `[onDone](https://api.dart.dev/stable/2.16.2/dart-async/StreamSubscription/onDone.html) `function to execute some code when the stream is finished sending data, such as when a file has been completely read.

With all four of those parameters combined — `onError`, `onDone`, `cancelOnError`, and the required parameter ([`onData`](https://api.dart.dev/stable/2.16.2/dart-async/StreamSubscription/onData.html)) — you can be ready in advance for whatever happens.

```
`final myStream = NumberCreator().stream;`

final subscription = myStream.listen(
  (data){
    print(‘Data: $data’);
},
onError: (err) {
  print(‘Error!’);
},
cancelOnError: false,
onDone: () {
  print(‘Done!’):
 },
);
```

> **Tip:** The object that `listen()` returns has some useful methods of its own. It’s called a `StreamSubscription`, and you can use it to pause, resume, and even cancel the flow of data.

```
`final subscription = myStream.listen(…);`

subscription.pause();
subscription.resume();
subscription.cancel();
```


### **Using and manipulating streams**

Now that you know how to use `listen()` to subscribe to a stream and receive data events, let’s talk about what makes streams really cool: manipulating them.

Once you’ve got data in a stream, there are a lot of operations that suddenly become fluent and elegant.

Let’s go back to that number stream from earlier.

Using a method called `[map](https://api.dart.dev/stable/dart-async/Stream/map.html)()`*,* you can take each value from the stream and convert it on the fly into something else. Give `map()` a function to do the conversion, and it returns a new stream, typed to match the return value of the function.

Instead of a stream of integers, now there is a stream of strings. Throw a `listen()`call on the end, pass it the `[print](https://api.dart.dev/stable/2.16.2/dart-async/Zone/print.html)()`function, and now it prints strings directly off the stream — asynchronously, as they arrive.

```
`NumberCreator().stream
    .map((i) => ‘String $i’)
    .listen(print) ;`

String 1
String 2
String 3
String 4
*/
```


There are many methods you can chain up like this. If you only want to print the even numbers, for example, you can use `where()` to filter the stream. Give it a test function that returns a boolean for each element, and it returns a new stream that only includes values that pass the test.

```
`NumberCreator().stream
    .where((i) => i % 2 == 0)
    .map((i) => ‘String $i’)
    .listen(print) ;`

String 2
String 4
String 6
String 8
```


The `[distinct](https://api.dart.dev/stable/dart-async/Stream/distinct.html)()` method is another good one. With an app that uses a Redux store, that store emits new app state objects in an [`onChange`](https://api.dart.dev/stable/2.16.2/dart-html/Document/onChange.html) stream.

You can use `map()` to convert the stream of state objects to a stream of view models for one part of the app. Then you can use the `distinct()` method to get a stream that filters out consecutive identical values (in case the store kicks out a change that doesn’t affect the subset of data in the view model).

You can then listen and update the UI whenever you get a new view model.

```
`myReduxStore.onChange
    .map((s) => MyViewModel(s))
    .distinct()
    .listen( /* update UI */ )`
```


There are additional methods built into Dart that you can use to shape and modify your streams. Plus, when you’re ready for more advanced features, there’s the [async package](https://pub.dev/packages/async) maintained by the Dart team and available on [pub.dev](https://pub.dev/). It has classes that can merge two streams together, cache results, and perform other types of stream-based wizardry.

<DashImage src="images/1x-uuwOB-kV_dlw80Gx5kkA.png" alt="Try the async package for more stream-based wizardry." caption="Try the async package for more stream-based wizardry." />


For even more stream magic, take a look at the [stream_transform package](https://pub.dev/packages/stream_transform).

### **Creating streams**

Finally, one more advanced topic that deserves a mention here is how to create streams of your own.

Just like with futures, most of the time you’re going to be working with streams created for you by network libraries, file libraries, state management, and so on, but you can make your own using a [`StreamController`](https://api.dart.dev/stable/dart-async/StreamController-class.html).

Let’s go back to that `NumberCreator` example we’ve been using so far. Here’s the actual code for it:

```
`class NumberCreator {
  NumberCreator() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _controller.sink.add(_count);
     _count += 1;
   });
 }`

 final _controller = StreamController<int>();
 var _count = 0;
 Stream<int> get stream => _controller.stream;
}
```


As you can see, it keeps a running count and uses a timer to increment that count each second. The interesting bit, though, is the stream controller.

A [`StreamController`](https://api.dart.dev/stable/2.16.2/dart-async/StreamController-class.html) creates a brand new stream from scratch and gives you access to both ends of it. There’s the stream end itself, where data arrives. (We’ve been using that one throughout this article.)

`Stream&lt;int&gt; get stream =&gt; _controller.stream;`

And there’s the sink end, which is where new data gets added to the stream:

`_controller.sink.add(_count);`

`NumberCreator` uses both of them. When the timer goes off, it adds the latest count to the controller’s sink, and then it exposes the controller’s stream with a public property so other objects can subscribe to it.

### **Building Flutter widgets using streams**

Now that we’ve covered creating, manipulating, and listening to streams, let’s talk about how to put them to work building widgets in Flutter.

If you read the previous article on [Futures](https://medium.com/dartlang/dart-asynchronous-programming-futures-96937f831137), you may remember [`FutureBuilder`](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html). You give it a future and a builder method, and it builds widgets based on the state of the future.

For streams, there’s a similar widget called [`StreamBuilder`](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html). Give it a stream like the one from number creator and a builder method, and it rebuilds its children whenever a new value is emitted by the stream.

```
`StreamBuilder<String>(
  stream: NumberCreator().stream.map((i) => ‘String $i’),
  builder: (context, snapshot) {
    // Build some widgets
    throw UnimplementedError(“Case not handled yet”);
  },
);`
```


The snapshot parameter is an [`AsyncSnapshot`](https://api.flutter.dev/flutter/widgets/AsyncSnapshot-class.html), just like with `FutureBuilder`.

```
`StreamBuilder<String>(
  stream: NumberCreator().stream.map((i) => ‘String $i’),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Text(‘No data yet.’);
  }
  throw UnimplementedError(“Case not handled yet”);
},`

);
```


You can check its `connectionState `property to see if the stream hasn’t yet sent any data, or if it’s completely finished.

```
StreamBuilder<String>(
   stream: NumberCreator().stream.map((i) => 'String $i'),
   builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {      
        return const Text('No data yet.');
      } else if (snapshot.connectionState == ConnectionState.done){
        return const Text('Done!');
      }
      throw UnimplementedError("Case not handled yet");
    },
 );
```


You can use the `hasError` property to handle data values and see if the latest value is an error.

```
`StreamBuilder<String>(
  stream: NumberCreator().stream.map((i) => ‘String $i’),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Text(‘No data yet.’);
    } else if (snapshot.connectionState == ConnectionState.done) {
      return const Text(‘Done!’);
    } else if (snapshot.hasError) {
      return const Text(‘Error!’);
    } else {
      return Text(snapshot.data ?? ‘’);
    } 
  },
);`
```


The main thing is to make sure your builder knows how to handle all possible states of the stream. Once you’ve got that, it can react to whatever the stream does. (For more information, including a DartPad instance that you can play with, see the [`StreamBuilder`](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html) API page.)

## Summary

This article has covered what streams represent, how to get values from a stream, ways to manipulate those values, and how `StreamBuilder` helps you use stream values in a Flutter app.

You can learn more about streams from the Dart and Flutter documentation:

* On [dart.dev](https://dart.dev/), see the [streams tutorial](https://dart.dev/tutorials/language/streams), the [command-line app tutorial](https://dart.dev/tutorials/server/cmdline), and the [stream section](https://dart.dev/guides/libraries/library-tour#stream) of the library tour.

* On [flutter.dev](https://flutter.dev/), see [Work with WebSockets](https://flutter.dev/docs/cookbook/networking/web-sockets), which features an example that uses `StreamBuilder`.

**Stay tuned** for more articles coming in this series. Next up we’ll be talking about `async` and `await`. These are two keywords Dart offers to help you keep your asynchronous code concise and easy to read.

In the meantime you can **watch the next video series** on *Asynchronous Programming in Dart *our YouTube channel, or **head over to our websites** for more info on [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/).

<iframe src="https://www.youtube.com/watch?v=SmTCmDMi4BY" width="854" height="480" frameborder="0" allowfullscreen></iframe>


<DashImage src="images/0IGPMOenc2CSAeOFH.png" />
