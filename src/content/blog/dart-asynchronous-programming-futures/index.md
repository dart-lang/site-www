---
title: "Dart asynchronous programming: Futures"
description: "One of the most basic APIs that Dart has for asynchronous programming is futures — objects of type Future. For the most part, Dart’s…"
publishDate: 2019-09-18
author: "kwalrath"
image: images/1UD63BMoIBmzoA6jo3LjCCg.png
category: other
tags:
  - programming
  - programming-languages
  - dartlang
  - asynchronous-programming
  - flutter
---


<DashImage src="images/1G4044qvxp8yBjmGVHVLEyw.png" alt="Many asynchronous Dart APIs return futures." caption="Many asynchronous Dart APIs return futures." />


One of the most basic APIs that Dart has for asynchronous programming is *futures —* objects of type [`Future`](https://api.dartlang.org/stable/dart-async/Future-class.html). For the most part, Dart’s futures are very similar to the *future* or *promise* APIs found in other languages.

This article discusses the concepts behind Dart futures and tells you how to use the `Future` API. It also discusses the Flutter `FutureBuilder` widget, which helps you update a Flutter UI asynchronously, based on the state of a future.

Thanks to Dart language features like [async-await](https://dart.dev/codelabs/async-await), you might never need to use the `Future` API directly. But you’re almost certain to encounter futures in your Dart code. And you might want to *create* futures or *read* code that uses the `Future` API.
> This article is the second one based on the *Flutter in Focus* video series *Asynchronous Programming in Dart*. The first article, [Isolates and event loops](https://medium.com/dartlang/dart-asynchronous-programming-isolates-and-event-loops-bffc3e296a6a), covered the foundations of Dart’s support for background work.
> If you prefer to learn by watching or listening, everything in this article is covered in the following video*.*

<YoutubeEmbed id="OTS-ap9_aXc" title="Dart Futures - Flutter in Focus" fullwidth="true"/>


You can think of futures as little gift boxes for data. Somebody hands you one of these gift boxes, which starts off closed. A little while later the box pops open, and inside there’s either a value or an error.

So a future can be in one of 3 states:

1. **Uncompleted:** The gift box is closed*.*

1. **Completed with a value:** The box is open, and your gift (data) is ready.

1. **Completed with an error:** The box is open, but something went wrong.

Most of the code you’re about to see revolves around dealing with these three states. You receive a future, and you need to decide what to do until the box opens, what to do when it opens with a value, and what to do if there’s an error. You’ll see that 1–2–3 pattern a lot.

<DashImage src="images/1UD63BMoIBmzoA6jo3LjCCg.png" alt="The 3 states of a future" caption="The 3 states of a future" />


You might remember the event loop (pictured below) from our [article about the Dart event loop](https://medium.com/dartlang/dart-asynchronous-programming-isolates-and-event-loops-bffc3e296a6a). A good thing to know about futures is that they’re really just an API built to make using the event loop easier.

<DashImage src="images/0xlxALlxjazVifRep.png" alt="The Dart event loop processes one event at a time." caption="The Dart event loop processes one event at a time." />


The Dart code you write is executed by a single thread. The whole time your app is running, that one little thread just keeps going around and around, picking up events from the event queue and processing them.

Say you have some code for a download button (implemented below as a `RaisedButton`). The user taps, and your button starts downloading a picture.

```dart
RaisedButton(
  onPressed: () {
    final myFuture = http.get('https://my.image.url');
    myFuture.then((resp) {
      setImage(resp);
    });
  },
  child: Text('Click me!'),
)
```

First the tap event occurs. The event loop gets the event, and it calls your tap handler (which you set using the `onPressed` parameter to the `RaisedButton` constructor). Your handler uses the http library to make a request (`http.get()`), and it gets a future in return (`myFuture`).

So now you’ve got your little box, `myFuture`. It starts off closed. To register a callback for when it opens, you use `then()`.

Once you have your gift box, you wait. Maybe some other events come in, the user does some stuff, and your little box just sits there while the event loop keeps going around.

Eventually, data for the image is downloaded, and the http library says, “Great! I’ve got this future right here.” It puts the data in the box and pops it open, which triggers your callback.

Now that little piece of code you handed to `then()` executes, and it displays the image.

Throughout that process, your code never had to touch the event loop directly. It didn’t matter what else was going on, or what other events came in. All you needed to do was get the future from the http library, and then say what to do when the future completed.

In real code, you’d also take care of errors. We’ll show you how to do that a little later.

Let’s take a closer look at the `Future` API, some of which you just saw in use.

OK, first question: how do you get an instance of a `Future`? Most of the time, you don’t create futures directly. That’s because many of the common asynchronous programming tasks already have libraries that generate futures for you.

For example, network communication returns a future:

```
final myFuture = http.get('http://example.com');
```


Getting access to shared preferences also returns a future:

```
final myFuture = SharedPreferences.getInstance();
```


But you can also use `Future` constructors to create futures.

## Future constructors

The simplest constructor is [`Future()`](https://api.dartlang.org/stable/dart-async/Future/Future.html), which takes a function and returns a future that matches the function’s return type. Later the function runs asynchronously, and the future completes with the function’s return value. Here’s an example of using `Future()`:

```dart
void main() {
  final myFuture = Future(() {
    return 12;
  });
}
```

Let’s add a couple of print statements to make the asynchronous part clear:

```dart
void main() {
  final myFuture = Future(() {
    print('Creating the future.'); // Prints second.
    return 12;
  });
  print('Done with main().'); // Prints first.
}
```

If you run that code in DartPad ([dartpad.dev](https://dartpad.dev)), the entire main function finishes before the function given to the `Future()` constructor. That’s because the `Future()` constructor just returns an uncompleted future at first. It says, “Here’s this box. You hold onto that for now, and later I’ll go run your function and put some data in there for you.” Here’s the output of the preceding code:

```
Done with main().
Creating the future.
```


Another constructor, [`Future.value()`](https://api.dartlang.org/stable/dart-async/Future/Future.value.html), is handy when you already know the value for the future. This constructor is useful when you’re building services that use caching. Sometimes you already have the value you need, so you can pop it right in there:

```
final myFuture = Future.value(12);
```


The `Future.value()` constructor has a counterpart for completing with an error. It’s called [`Future.error()`](https://api.dartlang.org/stable/dart-async/Future/Future.error.html), and it works essentially the same way, but takes an error object and an optional stacktrace:

```
final myFuture = Future.error(ArgumentError.notNull('input'));
```


The handiest future constructor is probably [`Future.delayed()`](https://api.dartlang.org/stable/dart-async/Future/Future.delayed.html). It works just like `Future()`, except that it waits for a specified length of time before running the function and completing the future.

One way to use `Future.delayed()` is when you’re creating mock network services for testing. If you need to make sure your loading spinner displays correctly, a delayed future is your friend.

```dart
final myFuture = Future.delayed(
  const Duration(seconds: 5),
  () => 12,
);
```

## Using futures

Now that you know where futures come from, let’s talk about how to use them. As we mentioned earlier, using a future is mostly about accounting for the three states it can be in: uncompleted, completed with a value, or completed with an error.

The following code uses `Future.delayed()` to create a future that completes after 3 seconds with a value of 100.

```dart
void main() {
  Future.delayed(
    const Duration(seconds: 3),
    () => 100,
  );
  print('Waiting for a value...');
}
```

When this code executes, `main()` runs from top to bottom, creating the future and printing “Waiting for a value…” That whole time, the future is uncompleted. It doesn’t complete for another 3 seconds.

To *use* the completed value, you can use [`then()`](https://api.dartlang.org/stable/dart-async/Future/then.html). That’s an instance method on each future that you can use to register a callback for when the future completes with a value. You give it a function that takes a single parameter matching the type of the future. Once the future completes with a value, your function is called with that value.

```dart
void main() {
  Future.delayed(
    const Duration(seconds: 3),
    () => 100,
  ).then((value) {
    print('The value is $value.'); // Prints later, after 3 seconds.
  });
  print('Waiting for a value...'); // Prints first.
}
```

Here’s the output of the preceding code:

```
Waiting for a value... *(3 seconds pass until callback executes)*
The value is 100.
```


In addition to executing your code, `then()` returns a future of its own, matching the return value of whatever function you give it. So if you need to make a couple of asynchronous calls, you can chain them together even if they have different return types.

```dart
_fetchNameForId(12)
    .then((name) => _fetchCountForName(name))
    .then((count) => print('The count is $count.'));
```

Back to our first example, what happens if that initial future doesn’t complete with a value — what if it completes with an error? The `then()` method expects a value. You need a way to register another callback in case of an error.

The answer is to use [`catchError()`](https://api.dartlang.org/stable/dart-async/Future/catchError.html). It works just like `then()`, except that it takes an error instead of a value, and it executes if the future completes with an error. Just like `then()`, the `catchError()` method returns a future of its own, so you can build a whole chain of `then()` and `catchError()`methods that wait on one another.
> **Note:** You don’t need to call `then()` or `catchError()` if you use the async-await language feature. Instead, you await the completed value, and you use try-catch-finally to handle errors. For details, see the Dart language tour’s [asynchrony support section](https://dart.dev/guides/language/language-tour#asynchrony-support).

Here’s an example of using `catchError()` to handle the case where a future completes with an error:

```dart
void main() {
  Future.delayed(
    Duration(seconds: 3),
    () => throw 'Error!', // Complete with an error.
  ).then((value) {
    print(value);
  }).catchError((err) {
    print('Caught $err'); // Handle the error.
  });
  print('Waiting for a value...');
}
```

You can even give `catchError()` a test function to check the error before invoking the callback. You can have multiple `catchError()` functions this way, each one checking for a different kind of error. Here’s an example of specifying a test function, using the optional `test` parameter to `catchError()`:

```dart
void main() {
  Future.delayed(
    Duration(seconds: 3),
    () => throw 'Error!',
  ).then((value) {
    print(value);
  }).catchError((err) {
    print('Caught $err');
  }, test: (err) { // Optional test parameter.
    return err is String;
  });
  print('Waiting for a value...');
}
```

Now that you’ve gotten this far, hopefully you can see how the three states of a future are often reflected by the structure of the code. There are three blocks in the preceding example:

1. The first block creates an uncompleted future.

1. Then there’s a function to call if the future completes with a value.

1. Then there’s another function to call if the future completes with an error.

There’s one more method you might want to use: [`whenComplete()`](https://api.dartlang.org/stable/dart-async/Future/whenComplete.html). You can use it to execute a function when the future is completed, no matter whether it’s with a value or an error.

It’s kind of like the *finally* block in a try-catch-finally. There’s code executed if everything goes right, code for an error, and code that runs no matter what.

## Using futures in Flutter

So that’s how you create futures, and a bit about how you can use their values. Now let’s talk putting them to work in Flutter.

Say you have a network service that’s going to return some JSON data, and you want to display that data. You could create a [`StatefulWidget`](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) that creates the future, checks for completion or error, calls `setState()`, and generally handles all the wiring manually.

Or you can use [`FutureBuilder`](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html). It’s a widget that comes with the Flutter SDK. You give it a future and a builder function, and it automatically rebuilds its children when the future completes.

The `FutureBuilder` widget works by calling its builder function, which takes a context and a snapshot of the current state of the future.

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use a FutureBuilder.
    return FutureBuilder<String>(
      future: _fetchNetworkData(),
      builder: (context, snapshot) {},
    );
  }
}
```

You can check the snapshot to see whether the future completed with an error:

```dart
    return FutureBuilder<String>(
      future: _fetchNetworkData(5),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Future completed with an error.
          return Text(
            'There was an error',
          );
        }
        throw UnimplementedError("Case not handled yet");
      },
    );
```

Otherwise you can check the `hasData` property to see if it completed with a value:

```dart
    return FutureBuilder<String>(
      future: _fetchNetworkData(5),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Future completed with an error.
          return Text(
            'There was an error',
          );
        } else if (snapshot.hasData) {
          // Future completed with a value.
          return Text(
            json.decode(snapshot.data)['field'],
          );
        }
        throw UnimplementedError("Case not handled yet");
      },
    );
```

If neither `hasError` nor `hasData` is true, then you know you’re still waiting, and you can output something for that as well.

```dart
    return FutureBuilder<String>(
      future: _fetchNetworkData(5),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Future completed with an error.
          return Text(
            'There was an error',
          );
        } else if (snapshot.hasData) {
          // Future completed with a value.
          return Text(
            json.decode(snapshot.data)['field'],
          );
        } else {
          // Uncompleted.
          return Text(
            'No value yet!',
          );
        }
      },
    );
```

Even in Flutter code, you can see how those three states keep popping up: uncompleted, completed with value, and completed with error.

## Summary

This article talked about what futures represent and how you can use the `Future` and `FutureBuilder` APIs to create futures and use their completed values.

If you’d like to learn more about using futures—with the option of using runnable examples and interactive exercises to test your understanding—check out the asynchronous codelab on [futures, async, and await](https://dart.dev/codelabs/async-await).

Or go on to the next video in the *Asynchronous Programming in Dart* series. It talks about *streams*, which are a lot like futures in that they can provide either values or errors. But where futures just give you one result and stop, streams just keep right on going.

<YoutubeEmbed id="nQBpOIHE4eE" title="Dart Streams - Flutter in Focus" fullwidth="true"/>


*Big thanks to Andrew Brogdon, who created the video that this article is based on.*