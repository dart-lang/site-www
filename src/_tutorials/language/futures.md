---
title: "Asynchronous Programming: Futures"
description: "A first look at Futures and how to use them to make your asynchronous code better."

nextpage:
  url: /tutorials/language/streams
  title: "Asynchronous Programming: Streams"
---

<div class="panel" markdown="1">

#### <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>What's the point?

* Dart is single-threaded.
* Synchronous code can make your program freeze.
* Use Futures to perform asynchronous operations.
* Use `await` in an async function to pause execution until a Future completes.
* Or use Future's `then()` method.
* Use try-catch expressions in async functions to catch errors.
* Or use Future's `catchError()` method.
* You can chain Futures to run asynchronous functions in order.

</div>

Dart is a single-threaded programming language.
If any code blocks the thread of execution
(for example, by waiting for a time-consuming operation
or blocking on I/O) the program effectively freezes.
Asynchronous operations let your program run without getting blocked.
Dart uses Future objects to represent asynchronous operations.

## Introduction {#introduction}

Let's look at some code that could possibly cause a program to freeze:

{% prettify dart %}
// Synchronous code
printDailyNewsDigest() {
  String news = gatherNewsReports(); // Can take a while.
  print(news);
}

main() {
  printDailyNewsDigest();
  printWinningLotteryNumbers();
  printWeatherForecast();
  printBaseballScore();
}
{% endprettify %}

Our program gathers the news of the day, prints it,
and then prints a bunch of other items of interest to the user:

{% prettify none %}
<gathered news goes here>
Winning lotto numbers: [23, 63, 87, 26, 2]
Tomorrow's forecast: 70F, sunny.
Baseball score: Red Sox 10, Yankees 0
{% endprettify %}

Our code is problematic: since `gatherNewsReports()` blocks,
the remaining code runs only when `gatherNewsReports()`
returns with the contents of the file,
_however long that takes_.  And if reading the file takes a long time, the
user waits passively, wondering if she won the lottery, what tomorrow's weather
will be like, and who won today's game. Not good.

To help keep the application responsive, Dart library authors use an
asynchronous model when defining functions that do potentially expensive work.
Such functions return their value using a
<a href="{{site.dart_api}}/dart-async/Future-class.html" target="_blank">Future</a>.

## What is a Future? {#what-is-a-future}

A Future represents a means for getting a value sometime in the future. When a
function that returns a Future is invoked, two things happen:

1. The function queues up work to be done and returns an uncompleted Future
   object.
1. Later, when a value is available, the Future object completes with that
   value (or with an error; we'll discuss that later).

To get the value that the Future represents, you have two options:

* Use `async` and `await`
* Use the Future API

## Async and await {#async-await}

The `async` and `await` keywords are part of the Dart language's
[asynchrony support](/guides/language/language-tour#asynchrony).
They allow you to write asynchronous code that looks like synchronous
code and doesn't use the Future API.

The following app simulates reading the news by using async and await
to read the contents of a file on www.dartlang.org.
Click run ( {% img 'run.png' %} ) to start the app.

{% comment %}
https://gist.github.com/Sfshaza/c0e8f5c38489ddeccb5a

Future printDailyNewsDigest() async {
  String news = await gatherNewsReports();
  print(news);
}

Future gatherNewsReports() async {
  String path =
      'https://www.dartlang.org/f/dailyNewsDigest.txt';
  return (await HttpRequest.getString(path));
}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-dart-prefix}}?id=c0e8f5c38489ddeccb5a&horizontalRatio=99&verticalRatio=73"
    width="100%"
    height="500px"
    style="border: 1px solid #ccc;">
</iframe>

Notice that `printDailyNewsDigest` is the first function called,
but the news is the last thing to print, even though
the file contains only a single line. This is because the code that reads
and prints the file is running asynchronously.

In this example,
the `printDailyNewsDigest()` function calls `gatherNewsReports()`,
which is non-blocking.
Calling `gatherNewsReports()` queues up the work to be done but
doesn't stop the rest of the code from executing. The program prints the
lottery numbers, the forecast, and the baseball score; when
`gatherNewsReports()` finishes gathering news, the program prints.
If `gatherNewsReports()` takes a little while to complete its work,
no great harm is done: the user gets to read other things before the daily
news digest is printed.

The following diagram shows the flow of execution through the code.
Each number corresponds to a step below.

<img src="../images/async-await.png"
     alt="diagram showing flow of control through the main() and printDailyNewsDigest functions" />

1. The app begins executing.
1. The main function calls `printDailyNewsDigest()`,
   which (because it's marked `async`),
   immediately returns a Future, _before any code is executed_.
1. The remaining print functions execute. Because they're synchronous,
   each function executes fully before moving on to the next print
   function. For example,
   the winning lottery numbers are all printed before the weather forecast
   is printed.
1. The body of the `printDailyNewsDigest()` function starts executing.
1. After reaching the await expression (`await gatherNewsReports()`) and
   calling `gatherNewsReports()`, the program pauses,
   waiting for the Future returned by `gatherNewsReports()` to complete.
1. Once that Future completes, execution of `printDailyNewsDigest()`
   continues, printing the news.
1. When the `printDailyNewsDigest()` function body has completed executing,
   the Future that it originally returned completes, and the app exits.

<aside class="alert alert-info" markdown="1">
**Note:**
If an async function doesn't explicitly return a value,
it returns a Future wrapped around a null value.
</aside>

### Handling errors {#handling-errors-async}

If a Future-returning function completes with an error,
you probably want to capture that error.
Async functions can use try-catch to capture the error.

{% comment %}
https://gist.github.com/Sfshaza/847e8d9a356f025ad5d6

// Handling errors with async and await.
Future printDailyNewsDigest() async {
  try {
    String news = await gatherNewsReports();
    print(news);
  } catch (e) {
    // ... handle error ...
  }
}

Future gatherNewsReports() async {
  String path =
      'https://www.dartlang.org/f/dailyNewsDigest.txt';
    String content = await HttpRequest.getString(path);
    return content;
}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-dart-prefix}}?id=847e8d9a356f025ad5d6&horizontalRatio=99&verticalRatio=73"
    width="100%"
    height="500px"
    style="border: 1px solid #ccc;">
</iframe>

The try-catch code behaves in the same way with asynchronous code that
it does for synchronous code:
If the code within the `try` block throws an exception,
the code inside the `catch` clause executes.

### Sequential processing {#sequential-processing-async}

You can use multiple `await` expressions to ensure that each statement
completes before executing the next statement:

{% prettify dart %}
// Sequential processing using async and await.
main() async {
  await expensiveA();
  await expensiveB();
  doSomethingWith(await expensiveC());
}
{% endprettify %}

The `expensiveB()` function will not execute until `expensiveA()` has
finished, and so on.

---

## The Future API {#the-future-api}

Before async and await were added in Dart 1.9,
you had to use the Future API.
You might still see the Future API used in older code
and in code that needs more functionality than async-await offers.

To write asynchronous code using the Future API,
you use the `then()` method to register a callback.
This callback fires when the Future completes.

The following app simulates reading the news by using the Future API
to read the contents of a file on www.dartlang.org.
Click run ( {% img 'run.png' %} ) to start the app.

{% comment %}
https://gist.github.com/Sfshaza/ba1b258f810e34231a62

printDailyNewsDigest() {
  var future = gatherNewsReports();
  future.then((content) => print(content));
}

// Imagine that this function is more complex and slow. :)
gatherNewsReports() {
  String path =
      'https://www.dartlang.org/f/dailyNewsDigest.txt';
  return HttpRequest.getString(path);
}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-dart-prefix}}?id=ba1b258f810e34231a62&horizontalRatio=99&verticalRatio=73"
    width="100%"
    height="500px"
    style="border: 1px solid #ccc;">
</iframe>

Notice that `printDailyNewsDigest` is the first function called,
but the news is the last thing to print, even though
the file contains only a single line. This is because the code that reads
the file is running asynchronously.

This app executes as follows:

1. The app begins executing.
1. The main function calls the `printDailyNewsDigest()` function,
   which does not return immediately, but calls `gatherNewsReports()`.
1. `gatherNewsReports()` starts gathering news and returns a Future.
1. `printDailyNewsDigest()` uses `then()` to specify a response to
   the Future. Calling `then()` returns a new Future that will complete
   with the value returned by `then()`'s callback.
1. The remaining print functions execute. Because they're synchronous,
   each function executes fully before moving on to the next print
   function. For example,
   the winning lottery numbers are all printed before the weather forecast
   is printed.
1. When all of the news has arrived, the Future returned by
   `gatherNewsReports()` completes with a string containing
   the gathered news.
1. The code specified by `then()` in `printDailyNewsDigest()` runs,
   printing the news.
1. The app exits.

In the `printDailyNewsDigest()` function,
the code inside `then()` could be written in a couple different ways.

<ul markdown="1">
<li markdown="1">Using curly braces.
    This is useful if you want to perform more than one operation.
    **Try it!**
    Replace the `printDailyNewsDigest()` method with the following:


{% prettify dart %}
printDailyNewsDigest() {
  var future = gatherNewsReports();
  future.then((content) {
    print(content);
    // ... do something else ...
  });
}
{% endprettify %}

</li>
<li markdown="1">Passing the `print` function directly,
    since it takes a single argument&mdash;the completed value
    of the Future.
    Try this version of `printDailyNewsDigest()`:

{% prettify dart %}
printDailyNewsDigest() {
  var future = gatherNewsReports();
  future.then(print);
}
{% endprettify %}

</li>
</ul>

### Handling errors {#handling-errors-future-api}

With the Future API, you can capture an error using `catchError()`:

{% comment %}
https://gist.github.com/Sfshaza/a9d90ac89aded272d1ca

printDailyNewsDigest() {
  var future = gatherNewsReports();
  future.then((content) => print(content))
        .catchError((e) => handleError(e));
}

// Imagine that this function is more complex and slow. :)
gatherNewsReports() {
  String path =
      'https://www.dartlang.org/f/dailyNewsDigest.txt';
  return HttpRequest.getString(path);
}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-dart-prefix}}?id=a9d90ac89aded272d1ca&horizontalRatio=99&verticalRatio=73"
    width="100%"
    height="500px"
    style="border: 1px solid #ccc;">
</iframe>


If `dailyNewsDigest.txt` doesn't exist or isn't available for reading,
the code above executes as follows:

1. `gatherNewsReports()`'s Future completes with an error.
1. `then()`'s Future completes with an error.
1.  `catchError()`'s callback handles the error, `catchError()`'s Future
completes normally, and the error does not propagate.

<aside class="alert alert-info" markdown="1">
  Chaining catchError() to then() is a common pattern when using the Future API.
  <strong>
    Consider this pairing the Future API's equivalent of try-catch blocks.
  </strong>
</aside>

Like `then()`, `catchError()` returns a new Future that completes with
the return value of its callback.

For more details and examples, read
[Futures and Error Handling](/articles/libraries/futures-and-error-handling).

### Calling multiple functions that return Futures {#calling-multiple-funcs}

Consider three functions,  `expensiveA()`, `expensiveB()`, and `expensiveC()`,
that return Futures.  You can invoke them sequentially (one function starts
when a previous one completes), or you can kick off all of them at the same
time and do something once all the values return. The Future interface
is fluid enough to deal with both use cases.

#### Chaining function calls using then()

When Future-returning functions need to run in order, use chained
`then()` calls:

{% prettify dart %}
expensiveA().then((aValue) => expensiveB())
            .then((bValue) => expensiveC())
            .then((cValue) => doSomethingWith(cValue));
{% endprettify %}

Nested callbacks also work, but they're harder to read and not as Dart-y.

#### Waiting on multiple Futures to complete using Future.wait()

If the order of execution of the functions is not important,
you can use `Future.wait()`.

The functions get triggered in quick succession; when all of them
complete with a value, `Future.wait()` returns a new Future.
This Future completes with a list containing the values produced by
each function.

{% prettify dart %}
// Parallel processing using the Future API
Future.wait([expensiveA(), expensiveB(), expensiveC()])
      .then((List responses) => chooseBestResponse(responses))
      .catchError((e) => handleError(e));
{% endprettify %}

If any of the invoked functions completes with an error, the Future returned
by `Future.wait()` also completes with an error. Use `catchError()` to handle
the error.

## Other resources {#other-resources}

Read the following documentation for more details on using Futures
and asynchronous programming in Dart:

* [Futures and Error Handling](/articles/libraries/futures-and-error-handling),
  an article that starts where this tutorial ends
* [The Event Loop and Dart]({{site.webdev}}/articles/performance/event-loop),
  an article that describes how to schedule tasks using Futures
* [Asynchrony support](/guides/language/language-tour#asynchrony),
  a section in the [language tour](/guides/language/language-tour)
* [Future API reference]({{site.dart_api}}/dart-async/Future-class.html)

## What next? {#what-next}

* The next tutorial,
[Asynchronous Programming: Streams](streams),
shows you how to work with an event stream.
