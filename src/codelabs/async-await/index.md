---
title: "Asynchronous Dart codelab: futures, async, and await"
description: A series of explanations and exercises for writing asynchronous code in Dart
date: 2019-06-12
tags: [ future, async, await, asynchronous, try, catch, error ]
---

Welcome to the asynchronous Dart codelab! In this codelab, you practice using
Dart to run asynchronous code using futures and the `async` and `await` keywords. 
In addition to explaining how to write asynchronous Dart code, this codelab 
includes embedded editors that show you working code examples and coding 
exercises. You can use these editors to test your knowledge by completing 
the exercises.

Here's what you should know to get the most out of this codelab:

* Know basic Dart syntax.
* Have some experience writing asynchronous code in another language.

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
and the `async` and `await` keywords. Consider the following example that
fails to print the desired user's order to the console: 

### Example: failing to use an asynchronous function

[//]: https://gist.github.com/d7abfdea1ae5596e96c7c0203d975dba
<!-- <iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=5c8c7716b6b4284842f15fe079f61e47"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="420"
  width="100%" >
</iframe> -->

In the preceding example:

* `getUserOrder()` is an asynchronous function that waits four seconds before
returning a string describing the user's order: a large latte. (For a further
explanation you can find out more about 
[Future.delayed]({{site.dart_api}}/Future.delayed.html)).
* `createOrderMessage()` calls `getUserOrder()` as if it were a synchronous 
function &mdash; it invokes `getUserOrder()` and immediately prints the result. 
* Since `getUserOrder()` waits four seconds before returning the user's order,
`createOrderMessage()` never prints the user's order. Instead the console
prints the value immediately returned by `createOrderMessage()` which
turns out to be `Instance of '_Future<String>'`.

In the preceding example, `createOrderMessage()` calls `getUserOrder()` as if it were a synchronous
function, and `createOrderMessage()` fails to print the desired output "Large Latte".
In the next sections you'll learn the about futures, `async`, and `await`
so that you will be able to write the code necessary to make `getUserOrder()` 
print the desired value (the user's order) to the console.

 {{ site.alert.secondary }} 
  **Key Terms** 

  * **synchronous operation**: A synchronous operation blocks other operations from executing until it completes. 

  * **synchronous function**: A synchronous function only performs synchronous operations.

  * **asynchronous operation**: Once initiated, an asynchronous operation allows 
    other operations to execute before it completes.

  * **asynchronous function**: An asynchronous function performs at least one 
  asynchronous operation and can also perform synchronous operations. 

 {{ site.alert.end }}


## Async in Dart: What is a future?

In Dart, a future represents the result of an asynchronous operation. A future has
two states: uncompleted or completed.

{{ site.alert.note }}
  'Uncompleted' is a Dart term referring to the state of a future
  before it has produced a result.
{{ site.alert.end }}

### Uncompleted

When you invoke an asynchronous function, that function immediately 
returns an uncompleted future. While uncomplete, a future is waiting for 
asynchronous operations to finish or to throw an error. 

### Completed

There are two ways that a future can complete:

#### Success

If the asynchronous operation succeeds, the future completes with a 
result. If the future has type `<T>` then the result is also of type `T`. 
For example,  `Future<String>` is the type signature for a
future that produces a string result. If a future doesn't produce a usable value
– for example, if you need log that a task is complete – then the future's type is `Future<void>`.


#### Error

If the asynchronous operations performed by the function throw an error or
exception, the future completes and throws the error or exception.

In the following example `getUserOrder()` returns a future that completes by printing 
to the console.
### Example: introducing futures

[//]: https://gist.github.com/57e6085344cbd1719ed42b32f8ad1bce
<!-- <iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=57e6085344cbd1719ed42b32f8ad1bce"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="300"
  width="100%" >
</iframe> -->

In the preceding example, even though `getUserOrder()` executes before the print
statement on line 8, the console shows the printed output from line 8 
("Fetching user order...") before the output from `getUserOrder()` ("Large Latte).
This is because `getUserOrder()` delays for 3 seconds before it completes by 
printing `Large Latte` to the console.


In the following example, `getUserOrder()` returns a future that completes with an exception.

### Example: futures and exceptions

[//]: https://gist.github.com/d843061bbd9388b837c57613dc6d5125
<!-- <iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=d843061bbd9388b837c57613dc6d5125"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="275"
  width="100%" >
</iframe> -->

In this example, `getUserOrder()` completes with an exception indicating that the user ID is invalid.

You have learned about futures and how they complete, but how do call and use 
asynchronous functions? In the next section you will learn how to do this with
the `async` and `await` keywords. 

{{ site.alert.secondary }}
  **Quick review**:

  * A [Future]({{site.dart_api}}/Future-class.html)
  produces a result of type `<T>`. For example,
  [Future]({{site.dart_api}}/Future-class.html)`<String>`
  is the type signature for a future that produces a string result. If a
  future doesn't produce a usable result, then the future's type is
  `Future<void>`.
  * A future can be in one of two states: uncompleted or completed. 
  * A future can complete with either a result or an error.
  * When you invoke a function that returns a future, the function queues up 
  work to be done and returns an uncompleted future.
  * Later, when the operation finishes, the future completes with a value or with an error.

**Key Terms**
* **Future**: Future (with a capitalised "F") refers to the Dart [Future](https://api.dartlang.org/stable/dart-async/Future-class.html) class.

* **future**: future (with a lower case "f") refers to an instance of the Dart Future class.
A future has two states: uncompleted and completed. 

{{ site.alert.end }}

## Working with futures: async and await

The `async` and `await` keywords provide a declarative way to define 
asynchronous functions and use their results. 

To define an `async` function:

* Add the `async` keyword after the function's parameters but before the function's body:  
    {% prettify dart %}
        String createOrderMessage() [!async!] {
    {% endprettify %}

* Update the function's type signature to return a future.
    {% prettify dart %}
        [!Future<void>!] createOrderMessage() async {
    {% endprettify %}

{{ site.alert.info }}
 You can 
 [use Future\<void\>]({{url}}/guides/language/effective-dart/design#do-use-futurevoid-as-the-return-type-of-asynchronous-members-that-do-not-produce-values)
 as the return type for asynchronous functions that don't return usable values.
{{ site.alert.end }}

Now that you've declared an async function:
  * Your function returns a future that completes with the type that you specify.
  * You must use the `await` keyword before invoking the function  to "wait"
   for the future to complete either with a value or an error.

{% prettify dart %}
var order = [!await!] getUserOrder();
{% endprettify %}

The following examples provide a comparison of synchronous and asynchronous functions.

### Example: synchronous functions

[//]: https://gist.github.com/8f4d136e7eb447f4acc7ccb523006e10
<!-- <iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=8f4d136e7eb447f4acc7ccb523006e10"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="450"
  width="100%">
</iframe> -->

In the preceding synchronous example the console immediately prints the messages 
"Your order is: Instance of '_Future<String>'". 

The following example shows the same code as before, but implemented asynchronously.
Since you can only use the `await` keyword within an `async` function body, the 
`createOrderMessage()` function is now marked with the `async` keyword.

### Example: asynchronous functions

[//]: https://gist.github.com/b8d026d2b23102084534159fafc9d7c6
<!-- <iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=b8d026d2b23102084534159fafc9d7c6"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="450"
  width="100%">
</iframe> -->

In the preceding asynchronous example, the console  prints the result "Your order is: Large
Latte" after a four second delay. This asynchronous example has three changes from the synchronous example:

* Update the return types for `createOrderMessage()` from 
`String` to `Future<String>`.
* Add the **`async`** keyword before the function bodies for `createOrderMessage()`
and the `main()` function.
* Use the **`await`** keyword before calling the asynchronous functions 
`getUserOrder()` and `createOrderMessage()`.


{{ site.alert.info }}
  Dart can [infer the return type](https://dart.dev/guides/language/sound-dart#type-inference) for you.
{{ site.alert.end }}

{{ site.alert.secondary }}
  **Key terms**:
* **async**:  Use the `async` keyword to define an asynchronous function. To use the
`async` keyword you must add it to a function definition just before the 
function's body. Once you define an `async` function, you invoke it by prefixing
it with the `await` keyword. 
* **async function**:  An `async` function is a function labeled with the `async` keyword. 
An `async` function returns a future. 
* **await**: Before invoking an `async` function, you can use the `await` keyword. 
This allows the caller to access the completed result of the future. You can 
only use the `await` keyword within an `async` function body.
{{ site.alert.end }}

## Execution flow with async and await

As of Dart 2, functions marked as `async` run synchronously until the first
`await` keyword. This means that within an `async` function's body, all
synchronous code immediately executes so long as the synchronous code appears
before the first `await` keyword. The following example demonstrates how 
execution proceeds within an `async` function body:

### Example: execution within async functions

[//]: https://gist.github.com/d7abfdea1ae5596e96c7c0203d975dba
<!-- <iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=d7abfdea1ae5596e96c7c0203d975dba"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 40px"
  frameborder="no"
  height="550"
  width="100%">
</iframe> -->

After running the code in the preceding example, try reversing line 4 and line 5:

{% prettify dart %}
  var order = await getUserOrder();
  print('Awaiting user order...');
{% endprettify %}

Notice that the timing of the output shifts now that the `print("Awaiting user order")`
statement appears after the first `await` keyword in `createOrderMessage()`.

## Exercise: Practice using async and await

The following exercise is a failing unit test that contains partially completed
code snippets. Your task is to complete the exercise by writing code to make the 
tests pass. To simulate asynchronous operations, __the exercise provides the 
async functions `getRole()` and `getLoginAmount()`. You don't need
to implement these functions -- they are provided but not shown in the exercise.
You don't need to implement `main()`.__

<div class="container">
  <div class="row">
   <div class="col-sm">
        <h3 markdown="1">Part 1: `reportUserRole()`</h3>
        <span markdown="1">Add logic to the `reportUserRole()`function:</span>  
        <ul>
          <li><span markdown="1">`reportUserRole()` returns a Future that produces
            the String result `"User role: <user role>"`. 
          </span></li>
          <li><span markdown="1"> Example return value from `reportUserRole()`: 
            `'User role: tester'` (Note: you must use the actual value returned 
            by `getRole()`; copying and pasting this text will not pass the test). 
          </span></li>
          <li><span markdown="1">Obtain the user role by calling the provided
           `async` function `getRole()`</span></li> 
          <li><span markdown="1">  `getRole()` returns a `String` describing the
            user's role.</span></li>
        </ul>
      <h3 markdown="1"> Part 2: `reportLogins()`</h3>
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

  <!-- <iframe 
    src="https://dartpad.dartlang.org/experimental/embed-new-inline.html?id=f751b692502c4ee43d932f745860b056&theme=dark"
    frameborder="no"
    height="525"
    width="100%">
  </iframe> -->


  </div>
  </div>
</div>

  {{ site.alert.info }}
    [Info-level messages](/guides/language/analysis-options#customizing-analysis-rules)
    from DartPad provide you with additional information, but they do not
    prevent you from passing the exercise.
  {{ site.alert.end }}
## Handling errors

Handle errors in an `async` function by using try / catch: 

```dart
  try {
    var order = await getUserOrder();
    print('Awaiting user order...');
  } catch (err) {
    print('Caught error: $err');
  }
```
You can write [try-catch clauses](/guides/language/language-tour#catch)
the same way with asynchronous as with
synchronous code: if the code within the `try` clause throws an exception,
the code inside the `catch` clause executes. The difference is that with
asynchronous functions you must use the async/await keywords following the 
syntax you used in the prior section:

### Example: async/await with try-catch

[//]: https://gist.github.com/25ade03f0632878a9169209e3cd7bef2
<!-- <iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=25ade03f0632878a9169209e3cd7bef2"
  style="border: 1px solid lightgrey;"
  frameborder="no"
  height="475"
  width="100%" >
</iframe> -->

## Exercise: Practice handling errors
<span markdown="1">
    __This exercise provides the async function `getNewUsername()`. 
    You don’t need to implement this provided function.__
    Use `async` and `await` to do the following:
</span>
<div class="container">
  <div class="row">
   <div class="col-sm">
    <ul>
      <li><span markdown="1">Implement an asynchronous `changeUsername()` function that calls the provided asynchronous function `getNewUsername()` and returns its result.</span></li>
      <li><span markdown="1">Since `getNewUsername()` can throw an Exception, the `changeUsername()` function must __catch and return any errors__ thrown by `getNewUsername()` and it must __stringify the error before returning it__.</span></li>
      <li><span markdown="1">If it succeeds, `getNewUsername()` returns a String, otherwise it throws an Exception.</span></li>
      <li><span markdown="1">You can use the [toString()]({{site.dart_api}}/stable/dart-core/ArgumentError/toString.html) method to stringify both [Exceptions]({{site.dart_api}}/stable/dart-core/Exception-class.html) and [Errors]({{site.dart_api}}/stable/dart-core/Error-class.html).</span></li>
    </ul>
   </div>
   <div class="col-sm">
    <!-- [//]: https://gist.github.com/858f71f0ad0e70051999bcafa41806a3 -->
    <!-- <iframe 
      src="https://dartpad.dartlang.org/experimental/embed-new-inline.html?id=858f71f0ad0e70051999bcafa41806a3&theme=dark"
      frameborder="no"
      height="525"
      width="100%" >
    </iframe> -->
   </div>
  </div> 
</div>

## Exercise: Putting it all together

It's time to practice what you've learned in one final exercise. 
To simulate asynchronous operations, __this exercise provides the async functions
`getUsername()` and `logoutUser()`. You don’t need to implement these provided functions.
You don't need to implement `main()`.__

Write the following:

<div class="container">
  <div class="row">
   <div class="col-sm">

   <h3 markdown="1"> Part 1: `addHello()` </h3>
    <ul>
      <li><span markdown="1"> Write a function `addHello()` that takes a single String argument</span></li> 
      <li><span markdown="1"> `addHello()` should return its String argument surrounded by the text ‘Hello \<string\>'</span></li>
    </ul>

   <h3 markdown="1"> Part 2: `greetUser()` </h3>
    <ul>
      <li><span markdown="1"> Write a function `greetUser()` that takes no arguments. </span></li>
      <li><span markdown="1"> To obtain the username, `greetUser()` should call the provided `async` function `getUsername()`, which waits for 1 second before returning a string. </span></li>
      <li><span markdown="1"> `greetUser()` should create a greeting for the user by calling `addHello()`, passing it the username, and returning the result. For example, if the username is ‘Jenny' `greetUser()` should create and return the greeting "Hello Jenny" </span></li>
    </ul>

   <h3 markdown="1"> Part 3: `sayGoodbye()` </h3>
    <ul>
      <li><span markdown="1"> Write a function `sayGoodbye()` that takes no arguments.</span></li>
      <li><span markdown="1"> `sayGoodbye()` should catch any errors.</span></li>
      <li><span markdown="1"> `sayGoodbye()` should call the provided `async` function `logoutUser()` which takes no arguments.</span></li>
      <li><span markdown="1"> If `logoutUser()` succeeds, `sayGoodbye()` should return the string "\<result\> Thanks, see you next time" where \<result\> is the String value returned by calling `logoutUser()`.</span></li>
    </ul>
   </div>

   <div class="col-sm">
    <!-- <iframe 
      src="https://dartpad.dev/experimental/embed-new-inline.html?id=f601d25bc2833c957186e3c6bf71effc&theme=dark"
      frameborder="no"
      height="525"
      width="100%">
    </iframe> -->
   </div>
  </div> 
</div>

## What's next?

* [Asynchronous programming: futures & async-await](/tutorials/language/futures) tutorial
* [Dart's type system](/guides/language/sound-dart) (Includes more examples of type signatures with futures).
* [Preferring signatures in function type annotations](/guides/language/effective-dart/design#prefer-signatures-in-function-type-annotations)
from [Effective Dart](/guides/language/effective-dart)
* Try [other Dart codelabs](/codelabs).
* Play with [DartPad.]({{site.dartpad}})
