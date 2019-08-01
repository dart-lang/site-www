---
title: "Asynchronous Dart codelab: futures, async, and await"
description: A series of explanations and exercises for writing asynchronous code in Dart
date: 2019-06-12
tags: [ future, async, await, asynchronous, try, catch, error ]
---
<!-- TODO: ensure 80chars -->

In this codelab, you practice using Dart to write asynchronous code using
futures and the `async` and `await` keywords. This codelab also includes
embedded editors that you can use to test your knowledge by running 
examples code and completing exercises.

To get the most out of this codelab, you should have the following:
* Knowledge of basic Dart syntax.
* Some experience writing asynchronous code in another language.

This codelab covers the following material:

* How and when to use `async` and `await` keywords.
* How using `async` and `await` affects execution order. 
* How to handle errors from an asynchronous call using `try-catch` expressions
in `async` functions.

Estimated time to complete this codelab: 40-60 minutes.

## Why asynchronous code matters

Asynchronous operations let your program complete work while waiting for 
another operation to finish. Here are some common asynchronous operations: 

* Fetching data over a network.
* Writing to a database.
* Reading data from a file.

To perform asynchronous operations in Dart, you can use the `Future` class
and the `async` and `await` keywords. 

### Example: Incorrectly using an asynchronous function
The following example fails to use the results of the asynchronous function
`getUserOrder()`. Later you'll fix the example using `async` and `await`. 
Before running this example, try to spot the issue -- can you guess what the
output will be? 

[//]: https://gist.github.com/5c8c7716b6b4284842f15fe079f61e47
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=5c8c7716b6b4284842f15fe079f61e47"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="420"
  width="100%" >
</iframe>

Here's why the preceding example fails to print the result of `getUserOrder()`:

* `getUserOrder()` is an asynchronous function that, after a delay, 
eventually provides a string that describes the user's order: a "Large Latte".
* To get the user's order, `createOrderMessage()` should call `getUserOrder()`
and wait for it to finish after a delay. Because `createOrderMessage()` does *not* wait 
for `getUserOrder()` to finish, `createOrderMessage()` fails to get the string value
that `getUserOrder()` eventually provides. 
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

  * **synchronous operation**: A synchronous operation blocks other operations from executing until it completes. 

  * **synchronous function**: A synchronous function only performs synchronous operations.

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
That future is waiting for the function's asynchronous operation to finish or to throw an error. 

### Completed
If the asynchronous operation succeeds, the future completes with a 
value. Otherwise it completes with an error.

#### Completing with a value

A future of type `Future<T>` completes with a value of type `T`.
For example, `Future<String>` is the type signature for a
future that produces a string value. If a future doesn't produce a usable value
– for example, if you only need to log that a task is complete – then the future's type is `Future<void>`.

#### Completing with an error

If the asynchronous operation performed by the function fails for any reason, the 
future completes with an error.

### Example: Introducing futures

In the following example, `getUserOrder()` returns a future that completes after printing 
to the console. Because it doesn't return a usable value, `getUserOrder()` has
the type `Future<void>`. Before you run the example, try to predict which will
print first: "Large Latte" or "Fetching user order..." ?

[//]: https://gist.github.com/57e6085344cbd1719ed42b32f8ad1bce
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=57e6085344cbd1719ed42b32f8ad1bce"
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
How do you think you might handle the error?

[//]: https://gist.github.com/d843061bbd9388b837c57613dc6d5125
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=d843061bbd9388b837c57613dc6d5125"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="275"
  width="100%" >
</iframe>

In this example, `getUserOrder()` completes with an error indicating that the user ID is invalid.

You've learned about futures and how they complete, but how do you use the results
of asynchronous functions? In the next section you will learn how to do this with
the `async` and `await` keywords. 

{{ site.alert.secondary }}
  **Quick review:**

  * A [Future<T>](https://api.dartlang.org/stable/dart-async/Future-class.html) instance
  produces a value of type `<T>`. For example, `Future<String>`
  is the type for a future that produces a string value. If a
  future doesn't produce a usable value, then the future's type is
  `Future<void>`.
  * A future can be in one of two states: uncompleted or completed. 
  * When you call a function that returns a future, the function queues up 
  work to be done and returns an uncompleted future.
  * Later, when the operation finishes, the future completes with a value or with an error.

**Key terms:**
* **Future**: Future (with a capitalized "F") refers to the Dart [Future](https://api.dartlang.org/stable/dart-async/Future-class.html) class.

* **future**: future (with a lower case "f") refers to an instance of the Dart Future class.
{{ site.alert.end }}

## Working with futures: async and await

The `async` and `await` keywords provide a declarative way to define 
asynchronous functions and use their results. Remember these two basic guidelines
when using `async` and `await`: 
* __The `await` keyword works only in `async` functions.__
* __To define an `async` function, add `async` before the function body.__

Here's an example  that converts `main()` from a synchronous to asynchronous function.

First, add the `async` keyword before the function body.
{% prettify dart %}
    main() [!async!] {
{% endprettify %}

If needed, update the function's type signature to return a future.
{% prettify dart %}
    [!Future<void>!] main() async {
{% endprettify %}

Remember, you can only use the `await` keyword within an `async` function. 
The following examples provide a comparison of synchronous and asynchronous functions.
If your window is wide enough, you'll see the two examples side-by-side.

<div class="container">
  <div class="row">
    <div class="col-sm">
    <h4> Example: synchronous functions</h4>

{% prettify dart %}
// Synchronous
String createOrderMessage () {
  var order = getUserOrder();
  return 'Your order is: $order';
}

Future<String> getUserOrder() {
  // Imagine that this function is
  // more complex and slow
  return 
    Future.delayed(
      Duration(seconds: 4), () => 'Large Latte'); 
}

// Synchronous
main() {
  print('Fetching user order...');
  print(createOrderMessage());
}

// "Your order is: Instance of '_Future<String>'"
{% endprettify %}
    </div>
    <div class="col-sm">
    <h4> Example: asynchronous functions</h4>

{% prettify dart %}
// Asynchronous
[!Future<String>!] createOrderMessage () [!async!] {
  var order = [!await!] getUserOrder();
  return 'Your order is: $order';
}

Future<String> getUserOrder() {
  // Imagine that this function is
  // more complex and slow
  return
   Future.delayed(
     Duration(seconds: 4), () => 'Large Latte');
}

// Asynchronous
main() [!async!] {
  print('Fetching user order...');
  print([!await!] createOrderMessage());
}

// "Your order is: Large Latte"
{% endprettify %}
    </div>
  </div>
</div>

The asynchronous example is different in three ways:
  * The return type for `createOrderMessage()` changes from `String` to `Future<String>`.
  * The **`async`** keyword appears before the function bodies for `createOrderMessage()` and the `main()` function.
  * The **`await`** keyword appears before calling the asynchronous functions `getUserOrder()` and `createOrderMessage()`.

{{ site.alert.secondary }}
  **Key terms:**
* **async**: You can use the `async` keyword before a function's body to mark it as
asynchronous.
* **async function**:  An `async` function is a function labeled with the `async` keyword. 
* **await**: You can use the `await` keyword to get the completed result of an
asynchronous expression. You can only use the `await` keyword within an `async` function. 
{{ site.alert.end }}

## Execution flow with async and await

As of Dart 2, functions marked as `async` run synchronously until the first
`await` keyword. This means that within an `async` function body, all
synchronous code before the first `await` keyword executes immediately. 

### Example: Execution within async functions
Run the following example to see how execution proceeds within an `async` 
function body. What do you think the output will be?

[//]: https://gist.github.com/d7abfdea1ae5596e96c7c0203d975dba
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=d7abfdea1ae5596e96c7c0203d975dba"
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

Notice that the timing of the output shifts, now that the `print('Awaiting user order')`
statement appears after the first `await` keyword in `createOrderMessage()`.
### Exercise: Practice using async and await

The following exercise is a failing unit test that contains partially completed
code snippets. Your task is to complete the exercise by writing code to make the 
tests pass. To simulate asynchronous operations, __the exercise provides the 
async functions `getRole()` and `getLoginAmount()`. You don't need
to implement these functions -- they are provided but not shown in the exercise.
You don't need to implement `main()`.__

<div class="container">
  <div class="row">
   <div class="col-sm">
<!-- TODO: Your code will call the following methods, which are provided for you... -->
<!-- (Provide function signatures, break them out from the instructions) -->
        <h4 markdown="1">Part 1: `reportUserRole()`</h4>
        <span markdown="1">Add logic to the `reportUserRole()`function:</span>  
        <ul>
          <li><span markdown="1">`reportUserRole()` returns a Future that completes
            with the String `"User role: <user role>"`. 
          </span></li>
          <!-- TODO: indent all "Example return values" -->
          <li><span markdown="1"> Example return value from `reportUserRole()`: 
          <!-- TODO: separate list item for note about actual value needed -->
            `'User role: tester'` (Note: you must use the actual value returned 
            by `getRole()`; copying and pasting the example return value won't make your test pass). 
          </span></li>
          <li><span markdown="1">Obtain the user role by calling the provided
           `async` function `getRole()`</span></li> 
          <li><span markdown="1">  `getRole()` returns a `String` describing the
            user's role.</span></li>
        </ul>
      <h4 markdown="1"> Part 2: `reportLogins()`</h4>
      <!-- TODO: example return value, and note, like above -->
        <span markdown="1">Implement an `async` function `reportLogins()`:</span>
        <ul>
          <li><span markdown="1">  `reportLogins()` returns the string 
            `'Total number of logins: <# of logins>'`. </span></li>
          <li><span markdown="1">  Example return value from `reportLogins(): 
            'Total number of logins: 57'` (Note: you must use the actual value 
            returned by `getLoginAmount()`; copying and pasting this text will
            not pass the test). </span></li>
          <li><span markdown="1">  Obtain the number of logins by calling the 
            provided `async` function `getLoginAmount()`</span></li>
          <li><span markdown="1"> `getLoginAmount()` returns an `int` 
            representing the number of times that the user has logged in. </span></li>
        </ul>
    </div>
    <div class="col-sm">

  <!-- [//]: https://gist.github.com/f751b692502c4ee43d932f745860b056 -->
  <iframe 
    src="https://dartpad.dartlang.org/experimental/embed-new-inline.html?id=f751b692502c4ee43d932f745860b056&theme=dark"
    frameborder="no"
    height="650"
    width="100%">
  </iframe>


  </div>
  </div>
</div>

<!-- If your tests pass you can ignore the info level messages  -->
  {{ site.alert.info }}
    [Info-level messages](/guides/language/analysis-options#customizing-analysis-rules)
    from DartPad provide you with additional information, but they don't
    prevent you from passing the exercise.
  {{ site.alert.end }}
## Handling errors

Handle errors in an `async` function by using try-catch: 

```dart
  try {
    var order = await getUserOrder();
    print('Awaiting user order...');
  } catch (err) {
    print('Caught error: $err');
  }
```
Within an `async` function, you can write [try-catch clauses](/guides/language/language-tour#catch)
the same way for asynchronous and synchronous code. 
<!-- To handle the error, use the await keyword within a try block -->
<!-- Exception vs. Error -->

### Example: async and await with try-catch
Run the following example to see how to handle an exception from an 
asynchronous function. Can you guess what the output will be before running it?
<!-- [//]: https://gist.github.com/25ade03f0632878a9169209e3cd7bef2 -->
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=25ade03f0632878a9169209e3cd7bef2"
  style="border: 1px solid lightgrey;"
  frameborder="no"
  height="475"
  width="100%" >
</iframe>

### Exercise: Practice handling errors
<span markdown="1">
<!-- TODO: same fix as above w/ section about provided functions -->
<!-- Indent the example values -->
<!-- Pull "provided functions" out of instructions section -->
    __This exercise provides the async function `getNewUsername()`. 
    You don’t need to implement this provided function.__
    Use `async` and `await` to do the following:
</span>
<div class="container">
  <div class="row">
   <div class="col-sm">
    <ul>
      <li><span markdown="1">Implement an asynchronous `changeUsername()` function that calls the provided asynchronous function `getNewUsername()` and returns its result.</span></li>
      <li><span markdown="1">Because `getNewUsername()` can throw an Exception, the `changeUsername()` function must __catch and return any errors__ thrown by `getNewUsername()` and it must __stringify the error before returning it__.</span></li>
      <li><span markdown="1">If `getNewUsername()` succeeds it returns a String, otherwise it throws an Exception.</span></li>
      <li><span markdown="1">You can use the [toString()]({{site.dart_api}}/stable/dart-core/ArgumentError/toString.html) method to stringify both [Exceptions]({{site.dart_api}}/stable/dart-core/Exception-class.html) and [Errors.]({{site.dart_api}}/stable/dart-core/Error-class.html)</span></li>
    </ul>
   </div>
   <div class="col-sm">
    <!-- [//]: https://gist.github.com/858f71f0ad0e70051999bcafa41806a3 -->
    <iframe 
      src="https://dartpad.dartlang.org/experimental/embed-new-inline.html?id=858f71f0ad0e70051999bcafa41806a3&theme=dark"
      frameborder="no"
      height="525"
      width="100%" >
    </iframe>
   </div>
  </div> 
</div>

### Exercise: Putting it all together

It's time to practice what you've learned in one final exercise. 
To simulate asynchronous operations, __this exercise provides the async functions
`getUsername()` and `logoutUser()`. You don’t need to implement these provided functions.
You don't need to implement `main()`.__

Write the following:

<div class="container">
  <div class="row">
   <div class="col-sm">

   <h4 markdown="1"> Part 1: `addHello()` </h4>
    <ul>
      <li><span markdown="1"> Write a function `addHello()` that takes a single String argument</span></li> 
      <!-- try to avoid should -->
      <li><span markdown="1"> `addHello()` should return its String argument surrounded by the text ‘Hello \<string\>'</span></li>
    </ul>

   <h4 markdown="1"> Part 2: `greetUser()` </h4>
    <ul>
      <li><span markdown="1"> Write a function `greetUser()` that takes no arguments. </span></li>
      <li><span markdown="1"> To obtain the username, `greetUser()` should call the provided asynchronous function `getUsername()`, which waits for 1 second before returning a string. </span></li>
      <li><span markdown="1"> `greetUser()` should create a greeting for the user by calling `addHello()`, passing it the username, and returning the result. For example, if the username is ‘Jenny' `greetUser()` should create and return the greeting "Hello Jenny" </span></li>
    </ul>

   <h4 markdown="1"> Part 3: `sayGoodbye()` </h4>
   <!-- Write a function sayGoodbye that does the following: takes no arguments, catch any errors,  -->
<!-- pull out descriptions of  -->
<!-- consider describe how to handle logoutUser if it fails -->
    <ul>
      <li><span markdown="1"> Write a function `sayGoodbye()` that takes no arguments.</span></li>
      <li><span markdown="1"> `sayGoodbye()` should catch any errors.</span></li>
      <li><span markdown="1"> `sayGoodbye()` should call the provided asynchronous function `logoutUser()`, which takes no arguments.</span></li>
      <!-- italicize <result> -->
      <li><span markdown="1"> If `logoutUser()` succeeds, `sayGoodbye()` should return the string "\<result\> Thanks, see you next time" where \<result\> is the String value returned by calling `logoutUser()`.</span></li>
    </ul>
   </div>

   <div class="col-sm">
    <!-- [//]: https://gist.github.com/f601d25bc2833c957186e3c6bf71effc -->
    <iframe 
      src="https://dartpad.dev/experimental/embed-new-inline.html?id=f601d25bc2833c957186e3c6bf71effc&theme=dark"
      frameborder="no"
      height="650"
      width="100%">
    </iframe>
   </div>
  </div> 
</div>

{{ site.alert.info }}
  Dart can [infer the return type](https://dart.dev/guides/language/sound-dart#type-inference) for you.
{{ site.alert.end }}

## What's next?

* [Asynchronous programming: futures & async-await](/tutorials/language/futures) tutorial
* [Dart's type system](/guides/language/sound-dart) (Includes more examples of type signatures with futures).
* [Preferring signatures in function type annotations](/guides/language/effective-dart/design#prefer-signatures-in-function-type-annotations)
from [Effective Dart](/guides/language/effective-dart)
* Try [other Dart codelabs](/codelabs).
* Play with [DartPad.]({{site.dartpad}})


[future class]: {{site.dart_api}}/stable/dart-async/Future-class.html
[style guide]: /guides/language/effective-dart/style
[documentation guide]: /guides/language/effective-dart/documentation
[usage guide]: /guides/language/effective-dart/usage
[design guide]: /guides/language/effective-dart/design