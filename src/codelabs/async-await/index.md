---
title: "Asynchronous programming: futures, async, await"
description: Learn about and practice writing asynchronous code in DartPad!
---
This codelab teaches you how to write asynchronous code using
futures and the `async` and `await` keywords. Using the embedded DartPad
editors, you can test your knowledge by running example code and completing
exercises.

To get the most out of this codelab, you should have the following:
* Knowledge of [basic Dart syntax](/samples).
* Some experience writing asynchronous code in another language.

This codelab covers the following material:

* How and when to use the `async` and `await` keywords.
* How using `async` and `await` affects execution order.
* How to handle errors from an asynchronous call using `try-catch` expressions
in `async` functions.

Estimated time to complete this codelab: 40-60 minutes.

{{ site.alert.note }}
  This page uses embedded DartPads to display examples and exercises.
  {% include dartpads-embedded-troubleshooting.md %}
{{ site.alert.end }}

## Why asynchronous code matters

Asynchronous operations let your program complete work while waiting for
another operation to finish. Here are some common asynchronous operations:

* Fetching data over a network.
* Writing to a database.
* Reading data from a file.

To perform asynchronous operations in Dart, you can use the `Future` class
and the `async` and `await` keywords.

### Example: Incorrectly using an asynchronous function
The following example shows the wrong way to use an asynchronous function
(`getUserOrder()`). Later you'll fix the example using `async` and `await`.
Before running this example, try to spot the issue -- what do you think the
output will be?

[//]: https://gist.github.com/5c8c7716b6b4284842f15fe079f61e47
<iframe
  src="{{site.dartpad-embed}}?id=5c8c7716b6b4284842f15fe079f61e47"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="420"
  width="100%" >
</iframe>

Here's why the example fails to print the value that `getUserOrder()` eventually
produces:

* `getUserOrder()` is an asynchronous function that, after a delay,
provides a string that describes the user's order: a "Large Latte".
* To get the user's order, `createOrderMessage()` should call `getUserOrder()`
and wait for it to finish. Because `createOrderMessage()` does *not* wait
for `getUserOrder()` to finish, `createOrderMessage()` fails to get the string
value that `getUserOrder()` eventually provides.
* Instead, `createOrderMessage()` gets a representation of pending work to be
done: an uncompleted future. You'll learn more about futures in the next section.
* Because `createOrderMessage()` fails to get the value describing the user's
order, the example fails to print "Large Latte" to the console, and instead
prints "Your order is: Instance of '_Future<String>'".

In the next sections you'll learn the about futures, `async`, and `await`
so that you'll be able to write the code necessary to make `getUserOrder()`
print the desired value ("Large Latte") to the console.

 {{ site.alert.secondary }}
 **Key terms:**
* **synchronous operation**: A synchronous operation blocks other operations
from executing until it completes.
* **synchronous function**: A synchronous function only performs synchronous
operations.
* **asynchronous operation**: Once initiated, an asynchronous operation allows
other operations to execute before it completes.
* **asynchronous function**: An asynchronous function performs at least one
asynchronous operation and can also perform _synchronous_ operations.
 {{ site.alert.end }}


## What is a future?
A future (lower case "f") is an instance of the [Future][future class]
(capitalized "F") class. A future represents the result of an asynchronous
operation, and can have two states: uncompleted or completed.

{{ site.alert.note }}
  _Uncompleted_ is a Dart term referring to the state of a future
  before it has produced a value.
{{ site.alert.end }}

### Uncompleted

When you call an asynchronous function, it returns an uncompleted future.
That future is waiting for the function's asynchronous operation to finish or to
throw an error.

### Completed
If the asynchronous operation succeeds, the future completes with a
value. Otherwise it completes with an error.

#### Completing with a value

A future of type `Future<T>` completes with a value of type `T`.
For example, a future with type `Future<String>` produces a string value.
If a future doesn't produce a usable value, then the future's type is
`Future<void>`.

#### Completing with an error

If the asynchronous operation performed by the function fails for any reason, the
future completes with an error.

### Example: Introducing futures

In the following example, `getUserOrder()` returns a future that completes after
printing to the console. Because it doesn't return a usable value,
`getUserOrder()` has the type `Future<void>`. Before you run the example,
try to predict which will print first: "Large Latte" or "Fetching user order...".

[//]: https://gist.github.com/57e6085344cbd1719ed42b32f8ad1bce
<iframe
  src="{{site.dartpad-embed}}?id=57e6085344cbd1719ed42b32f8ad1bce"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="300"
  width="100%" >
</iframe>

In the preceding example, even though `getUserOrder()` executes before
the `print()` call on line 8, the console shows the output from line 8
("Fetching user order...") before the output from `getUserOrder()` ("Large Latte").
This is because `getUserOrder()` delays before it prints "Large Latte".

### Example: Completing with an error
Run the following example to see how a future completes with an error.
A bit later you'll learn how to handle the error.

[//]: https://gist.github.com/d843061bbd9388b837c57613dc6d5125
<iframe
  src="{{site.dartpad-embed}}?id=d843061bbd9388b837c57613dc6d5125"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="275"
  width="100%" >
</iframe>

In this example, `getUserOrder()` completes with an error indicating that the
user ID is invalid.

You've learned about futures and how they complete, but how do you use the
results of asynchronous functions? In the next section you'll learn how to get
results with the `async` and `await` keywords.

{{ site.alert.secondary }}
  **Quick review:**
  * A [Future\<T\>][future class] instance produces a value of type `T`.
  * If a future doesn't produce a usable value, then the future's type is
  `Future<void>`.
  * A future can be in one of two states: uncompleted or completed.
  * When you call a function that returns a future, the function queues up
  work to be done and returns an uncompleted future.
  * When a future's operation finishes, the future completes with a value or
  with an error.

**Key terms:**
* **Future**: the Dart [Future][future class] class.

* **future**: an instance of the Dart Future class.
{{ site.alert.end }}

## Working with futures: async and await

The `async` and `await` keywords provide a declarative way to define
asynchronous functions and use their results. Remember these two basic guidelines
when using `async` and `await`:
* __To define an async function, add `async` before the function body:__
* __The `await` keyword works only in `async` functions.__

Here's an example  that converts `main()` from a synchronous to asynchronous
function.

First, add the `async` keyword before the function body:
{% prettify dart %}
    main() [!async!] {
{% endprettify %}

{{ site.alert.info }}
  You might have noticed that some functions (like `main()`, above)
  don't have return types.
  That's because Dart can [infer the return type][infer] for you.
  Omitting return types is fine when you're prototyping,
  but when you write production code,
  we recommend that you specify the return type.
{{ site.alert.end }}

[infer]: https://dart.dev/guides/language/sound-dart#type-inference

If the function has a declared return type, then update the type to be
`Future<T>`, where `T` is the type of the value that the function returns.
If the function doesn't explicitly return a value, then the return type is
`Future<void>`:

{% prettify dart %}
    [!Future<void>!] main() async {
{% endprettify %}

Now that you have an `async` function, you can use the `await` keyword to wait
for a future to complete:
{% prettify dart %}
    print(await createOrderMessage());
{% endprettify %}


As the following two examples show, the `async` and `await` keywords result in
asynchronous code that looks a lot like synchronous code.
The only differences are highlighted in the asynchronous example, which — if
your window is wide enough — is to the right of the synchronous example.

<div class="container">
  <div class="row">
    <div class="col-sm">
    <h4> Example: synchronous functions</h4>

{% prettify dart %}
// Synchronous
String createOrderMessage() {
  var order = getUserOrder();
  return 'Your order is: $order';
}

Future<String> getUserOrder() {
  // Imagine that this function is
  // more complex and slow.
  return
    Future.delayed(
      Duration(seconds: 4), () => 'Large Latte');
}

// Synchronous
main() {
  print('Fetching user order...');
  print(createOrderMessage());
}

// 'Fetching user order...'
// 'Your order is: Instance of _Future<String>'
{% endprettify %}
    </div>
    <div class="col-sm">
    <h4> Example: asynchronous functions</h4>

{% prettify dart %}
// Asynchronous
[!Future<String>!] createOrderMessage() [!async!] {
  var order = [!await!] getUserOrder();
  return 'Your order is: $order';
}

Future<String> getUserOrder() {
  // Imagine that this function is
  // more complex and slow.
  return
   Future.delayed(
     Duration(seconds: 4), () => 'Large Latte');
}

// Asynchronous
main() [!async!] {
  print('Fetching user order...');
  print([!await!] createOrderMessage());
}

// 'Fetching user order...'
// 'Your order is: Large Latte'
{% endprettify %}
    </div>
  </div>
</div>

The asynchronous example is different in three ways:
  * The return type for `createOrderMessage()` changes from `String` to
  `Future<String>`.
  * The **`async`** keyword appears before the function bodies for
  `createOrderMessage()` and `main()`.
  * The **`await`** keyword appears before calling the asynchronous functions
  `getUserOrder()` and `createOrderMessage()`.

{{ site.alert.secondary }}
  **Key terms:**
* **async**: You can use the `async` keyword before a function's body to mark it as
asynchronous.
* **async function**:  An `async` function is a function labeled with the `async`
keyword.
* **await**: You can use the `await` keyword to get the completed result of an
asynchronous expression. The `await` keyword only works within an `async` function.
{{ site.alert.end }}

### Execution flow with async and await

An `async` function runs synchronously until the first
`await` keyword. This means that within an `async` function body, all
synchronous code before the first `await` keyword executes immediately.

{{ site.alert.note }}
Before Dart 2.0, an `async` function returned immediately,
without executing any code within the `async` function body.
{{ site.alert.end }}

### Example: Execution within async functions
Run the following example to see how execution proceeds within an `async`
function body. What do you think the output will be?

[//]: https://gist.github.com/d7abfdea1ae5596e96c7c0203d975dba
<iframe
  src="{{site.dartpad-embed}}?id=d7abfdea1ae5596e96c7c0203d975dba"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 40px"
  frameborder="no"
  height="600"
  width="100%">
</iframe>

After running the code in the preceding example, try reversing line 4 and line 5:

{% prettify dart %}
  var order = await getUserOrder();
  print('Awaiting user order...');
{% endprettify %}

Notice that timing of the output shifts, now that `print('Awaiting user order')`
appears after the first `await` keyword in `createOrderMessage()`.

### Exercise: Practice using async and await

The following exercise is a failing unit test that contains partially completed
code snippets. Your task is to complete the exercise by writing code to make the
tests pass.
You don't need to implement `main()`.

To simulate asynchronous operations, call the following functions, which are
provided for you:

|------------------+--------------------------------+-------------|
| Function         | Type signature                 | Description |
|------------------|--------------------------------|-------------|
| getRole()        | `Future<String> getRole()`     | Gets a short description of the user's role. |
| getLoginAmount() | `Future<int> getLoginAmount()` | Gets the number of times a user has logged in. |
{:.table .table-striped}


#### Part 1: `reportUserRole()`

Add code to the `reportUserRole()` function so that it does the following:
<!-- Some bulleted items are intentionally lacking punctuation to avoid
confusing the users about characters in string values -->
* Returns a future that completes with the following
string: `"User role: <user role>"`
  * Note: You must use the actual value returned by `getRole()`; copying and
  pasting the example return value won't make the test pass.
  * Example return value: `"User role: tester"`
* Gets the user role by calling the provided function `getRole()`.

####  Part 2: `reportLogins()`
Implement an `async` function `reportLogins()` so that it does the following:
* Returns the string `"Total number of logins: <# of logins>"`.
  * Note: You must use the actual value returned by `getLoginAmount()`; copying
  and pasting the example return value won't make the test pass.
  * Example return value from `reportLogins()`: `"Total number of logins: 57"`
* Gets the number of logins by calling the provided function `getLoginAmount()`.

<!-- [//]: https://gist.github.com/f751b692502c4ee43d932f745860b056 -->
<iframe
  src="{{site.dartpad-embed}}?id=f751b692502c4ee43d932f745860b056&theme=dark"
  frameborder="no"
  height="550"
  width="100%">
</iframe>

  {{ site.alert.info }}
    If your code passes the tests, you can ignore [info-level messages.](/guides/language/analysis-options#customizing-analysis-rules)
  {{ site.alert.end }}

## Handling errors
To handle errors in an `async` function, use try-catch:

```dart
  try {
    var order = await getUserOrder();
    print('Awaiting user order...');
  } catch (err) {
    print('Caught error: $err');
  }
```
Within an `async` function, you can write [try-catch clauses](/guides/language/language-tour#catch)
the same way you would in synchronous code.

### Example: async and await with try-catch
Run the following example to see how to handle an error from an
asynchronous function. What do you think the output will be?
<!-- [//]: https://gist.github.com/25ade03f0632878a9169209e3cd7bef2 -->
<iframe
  src="{{site.dartpad-embed}}?id=25ade03f0632878a9169209e3cd7bef2"
  style="border: 1px solid lightgrey;"
  frameborder="no"
  height="525"
  width="100%" >
</iframe>

### Exercise: Practice handling errors

The following exercise provides practice handling errors with asynchronous code,
using the approach described in the previous section. To simulate asynchronous
operations, your code will call the following function, which is provided for you:

|------------------+-----------------------------------+-------------|
| Function         | Type signature                    | Description |
|------------------|-----------------------------------|-------------|
| getNewUsername() | `Future<String> getNewUsername()` | Returns the new username that you can use to replace an old one.|
{:.table .table-striped}

Use `async` and `await` to implement an asynchronous `changeUsername()` function
that does the following:
* Calls the provided asynchronous function `getNewUsername()` and returns its result.
  * Example return value from `changeUsername()`: `"jane_smith_92"`
* Catches any error that occurs and returns the string value of the error.
  * You can use the [toString()]({{site.dart_api}}/stable/dart-core/ArgumentError/toString.html) method to stringify both [Exceptions]({{site.dart_api}}/stable/dart-core/Exception-class.html) and [Errors.]({{site.dart_api}}/stable/dart-core/Error-class.html)

<!-- [//]: https://gist.github.com/858f71f0ad0e70051999bcafa41806a3 -->

<iframe
src="{{site.dartpad-embed}}?id=858f71f0ad0e70051999bcafa41806a3&theme=dark"
frameborder="no"
height="525"
width="100%" >
</iframe>

<!-- TODO: Consider summary section before final exercise -->
<!-- TODO: Consider adding new content to final section (not repeating same stuff) -->
## Exercise: Putting it all together

It's time to practice what you've learned in one final exercise.
To simulate asynchronous operations, this exercise provides the asynchronous
functions `getUsername()` and `logoutUser()`:

|------------------+-----------------------------------+-------------|
| Function         | Type signature                    | Description |
|------------------|-----------------------------------|-------------|
| getUsername()    | `Future<String> getUsername()`    |      Returns the name associated with the current user.|
| logoutUser()    | `Future<String> logoutUser()`    |      Performs logout of current user and returns the username that was logged out.|
{:.table .table-striped}

Write the following:

####  Part 1: `addHello()`
* Write a function `addHello()` that takes a single String argument.
* `addHello()` returns its String argument preceded by 'Hello '.<br>
  Example: `addHello('Jon')` returns `'Hello Jon'`.

####  Part 2: `greetUser()`
* Write a function `greetUser()` that takes no arguments.
* To get the username, `greetUser()` calls the provided asynchronous
  function `getUsername()`.
* `greetUser()` creates a greeting for the user by calling `addHello()`,
  passing it the username, and returning the result.<br>
  Example: If `getUsername()` returns `'Jenny'`, then
  `greetUser()` returns `'Hello Jenny'`.

####  Part 3: `sayGoodbye()`
* Write a function `sayGoodbye()` that does the following:
  * Takes no arguments.
  * Catches any errors.
  * Calls the provided asynchronous function `logoutUser()`.
* If `logoutUser()` fails, `sayGoodbye()` returns any string you like.
* If `logoutUser()` succeeds, `sayGoodbye()` returns the string
  `'<result> Thanks, see you next time'`, where `<result>` is
  the String value returned by calling `logoutUser()`.

{% comment %}https://gist.github.com/f601d25bc2833c957186e3c6bf71effc{% endcomment -%}
<iframe
  src="{{site.dartpad-embed}}?id=f601d25bc2833c957186e3c6bf71effc&theme=dark"
  frameborder="no"
  height="550"
  width="100%">
</iframe>


## What's next?

Congratulations, you've finished the codelab! If you'd like to learn more, here
are some suggestions for where to go next:

* Play with [DartPad.]({{site.dartpad}})
* Try another [codelab](/codelabs).
* Learn more about futures and asynchrony:
  * [Streams tutorial](/tutorials/language/streams):
    Learn how to work with a sequence of asynchronous events.
  * [Dart videos from Google:][Dart videos]
    Watch one or more of the videos about asynchronous coding.
    Or, if you prefer, read the articles that are based on these videos.
    (Start with [isolates and event loops.][article])
* [Get the Dart SDK.](/get-dart)

[Dart videos]: https://www.youtube.com/playlist?list=PLjxrf2q8roU0Net_g1NT5_vOO3s_FR02J
[article]: https://medium.com/dartlang/dart-asynchronous-programming-isolates-and-event-loops-bffc3e296a6a
[future class]: {{site.dart_api}}/stable/dart-async/Future-class.html
[style guide]: /guides/language/effective-dart/style
[documentation guide]: /guides/language/effective-dart/documentation
[usage guide]: /guides/language/effective-dart/usage
[design guide]: /guides/language/effective-dart/design
