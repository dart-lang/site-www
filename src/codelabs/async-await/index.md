---
title: Asynchronous Dart code - futures, async, and await 
description: A series of explanations and exercises for writing asynchronous code in Dart
date: 2019-06-12
tags: [ future, async, await, asynchronous, try, catch, error ]
---

## Introduction
 
Welcome to the asynchronous Dart codelab! In this codelab you practice using
Dart to run asynchronous code via the `async` and `await` keywords.

In addition to explanations, this codelab includes embedded editors that show 
you working code examples and coding exercises. You can use these editors to 
test your knowledge by completing the exercises.

Before you begin this codelab, you should:

* Have programming experience in another language
* Know basic syntax in Dart 
* Have some experience writing asynchronous code in another language

When you finish this codelab, you'll know the following: 

* How to use the `async` keyword
* How to use the `await` keyword
* When to use `async` and `await` in your code
* How your code executes when using the `async/await` keywords
* How to handle errors from an asynchronous call using `try/catch` expressions 
in async functions.
* Where to find more information for the `async/await` material 
covered in this codelab.


## Why async matters

Asynchronous operations let your program complete other work while waiting for 
an operation to finish. Some common processes that require asynchronous 
operations include: 

* Fetching data over a network
* Writing to a database
* Reading data from a file

To implement these features, you will need to learn the Dart syntax for
futures, async, and await. In Dart you cannot use synchronous code to handle
asynchronous operations.

Consider the following example that fails to print the desired user order to the
console: 


<iframe style="margin-top: 25px; margin-bottom: 25px" frameborder="no" height="420" src="https://dartpad.dartlang.org/experimental/embed-new.html?id=5c8c7716b6b4284842f15fe079f61e47" width="100%"></iframe>


In the above code:

* `getUserOrder` is an asynchronous function that waits four seconds before
returning a string describing the user's order: a large latte. (For a further
explanation you can [find out more about
Future.delayed]({{site.dart_api}}/Future.delayed.html))
* `createOrderMessage` calls `getUserOrder` as if it were a synchronous function
 -- it invokes `getUserOrder` and immediately prints the result. 
* Since `getUserOrder` waits four seconds before returning the user's order,
`createOrderMessage` never actually prints the user's order. Instead the console
prints the value immediately returned by `createOrderMessage` which
turns out to be `Instance of '_Future<String>'`.

What is a future, and how do you write code to handle the asynchronous function
 `getUserOrder`?
 
 {{ site.alert.secondary }} 
 Quick review: 
 * Asynchronous operations let a program do work while waiting for an operation to finish.
 * In Dart, you can use Futures, `async` and `await` to write declarative asynchronous code.
 {{ site.alert.end }}


## Async in Dart: What is a future?

In Dart, a
[Future]({{site.dart_api}}/Future-class.html)
represents the result of an asynchronous operation. A future object has
two states: uncompleted or completed.

{{ site.alert.note }}
'Uncompleted' is a special term in Dart referring to the state of a future 
 before it has produced a result.
{{ site.alert.end }}

### Uncompleted

When you invoke a function that returns a future, that function immediately 
returns a future object in an uncompleted state. While in its uncompleted state,
a future object is simply waiting for asynchronous operations to finish or to 
throw an error. 

### Completed

There are two ways that a future object can complete:

#### 1. Success

If the asynchronous operations succeed, the future completes and returns a 
result of type T. For example,  
`Future<String>` is the type signature for a future object that produces a string
result. If a future produces a result that isn't a usable value, then the
future's type is `Future<void>`. 

#### 2. Error

If the asynchronous operations being performed by the 
function throw an error, the future completes and returns an error. 

To see this lifecycle at work consider what happens after invoking the 
`getUserOrder` function:


<iframe style="margin-top: 25px; margin-bottom: 25px" frameborder="no" height="450" src="https://dartpad.dartlang.org/experimental/embed-new.html?id=57e6085344cbd1719ed42b32f8ad1bce" width="100%"></iframe>


After 1 second has passed, notice that the future is in an uncompleted state - you can't access the
desired result yet:

`     Your order is: Instance of '_Future<String>'`

After 4 seconds have passed, the future completes and produces the desired
result:

`Your order is: 'Large Latte'`

How do you access this result that completes 4 seconds later? In the next section
you will learn about using  the `async` and `await` keywords to handle the results
of asynchronous functions. 

{{ site.alert.secondary }}
Quick Review:

* In Dart, a
[Future]({{site.dart_api}}/Future-class.html)
produces a result of type `<T>`. For example,
[Future]({{site.dart_api}}/Future-class.html)`<String>`
is the type signature for a future object that produces a string result. If a
future produces a result that isn't a usable value, then the future's type is
`Future<void>`.
* A future can be in one of two states: uncompleted, or completed. 
* A completed future can either (1) complete with a result or (2) complete with
an error.
* When you invoke a function that returns a future, two things happen:

1. The function queues up work to be done and returns an uncompleted future.
2. Later, when the operation is finished, the future completes with a value or
with an error.
{{ site.alert.end }}


## Working with futures in Dart: async and await

The `async` and `await` keywords provide a declarative way to: Define 
asynchronous functions and access their results *after they have completed.*

To define an `async` function:

1. Add the `async` keyword after the function's parameters but before the function's body:  

    ```
    createOrderMessage () async {
    ```

2. Update the function's type signature to return a future. The following  
example defines an `async` function that completes with a string.  

    ```
    Future<String> createOrderMessage() async {
    ```

{{ site.alert.info }}
 You can 
 [use Future\<void\>]({{url}}/guides/language/effective-dart/design#do-use-futurevoid-as-the-return-type-of-asynchronous-members-that-do-not-produce-values)
 as the return type for asynchronous functions that don't return usable values.
{{ site.alert.end }}

Now that you've declared an async function, it returns a future object. Use the
`await` keyword to "wait" for the completed future to return either its value or its error.

```dart
var order = await getUserOrder();
```

Remember: you can only use the `await` keyword within an `async` function body.
The following example demonstrates how to use the `await` keyword to access
the result of the async function `getUserOrder`. Notice that `createOrderMessage`
is an `async` function:

<iframe 
  style="margin-top: 25px; margin-bottom: 25px"
  frameborder="no"
  height="400"
  src="https://dartpad.dartlang.org/experimental/embed-new.html?id=b8d026d2b23102084534159fafc9d7c6"
  width="100%">
</iframe>

{{ site.alert.info }} 
[All functions return a
   value](https://dart.dev/guides/language/language-tour#return-values) even
   if you don't explicitly use the `return` keyword.
{{ site.alert.end }}
   
{{ site.alert.info }}
Dart can [infer the Future\<String\> type](https://dart.dev/guides/language/sound-dart#type-inference) for you.
{{ site.alert.end }}

This code has only three changes from the preceding implementation:

1. Mark the return type for `createOrderMessage` with `Future<String>`.
2. Add **`async`** before the method body (the `createOrderMessage` and the `main` method).
3. Add **`await`** before the calling the asynchronous function (before invoking `getUserOrder` and `createOrderMessage`).

{{ site.alert.secondary }}
Quick review: 
* An `async` function returns a future.
* You can only use the `async` and `await` keywords within an `async` function body.
* To declare an `async` function, add the keyword after the function's parameters but before the function's body.
* Use the `await` keyword before invoking an async function to "wait" for the completed future to return either its value or its error.
{{ site.alert.end }}

## Execution flow with async and await

As of Dart 2.0, functions marked as `async` run synchronously until the first
`await` keyword. This means that within an `async` function's body, all
synchronous code immediately executes. The following example demonstrates how 
execution proceeds within an `async` function body:

<iframe frameborder="no" height="325" src="https://dartpad.dartlang.org/experimental/embed-new.html?id=d7abfdea1ae5596e96c7c0203d975dba" width="100%"></iframe>

Notice that the timing of the output shifts if the print statement
"Awaiting user order" moves to the line after the first `await` keyword in
`createOrderMessage`:

<iframe frameborder="no" height="325" src="https://dartpad.dartlang.org/experimental/embed-new.html?id=e6ee207677e9f0e9220e73440e35eefc" width="100%"></iframe>


## Practice using async and await

The following example is a failing unit test that contains partially completed
code snippets. Your task is to complete the example so that the test passes.
Verify your code by clicking the "Run" button.

Add the following:

#### Part 1
Add logic to the `reportUserRole` function:

1. `reportUserRole` returns a Future that produces the String result `'User role: <user role>'`.
1. Obtain the user role by calling the provided `async` function `getRole`
1. `getRole` returns a `String` describing the user's role.
1. Example return value from `reportUserRole`: `'User role: tester'`

#### Part 2
Implement an `async` function `reportLogins`:

1. `reportLogins` returns the string `'Total number of logins: <# of logins>'`.
1. Obtain the number of logins by calling the provided `async` function `getLoginAmount`
1. `getLoginAmount` returns an `int` representing the number of times that the user has logged in.
1. Example return value from `reportLogins: 'Total number of logins: 57'`

<iframe frameborder="no" height="525" src="https://dartpad.dartlang.org/experimental/embed-new.html?id=f751b692502c4ee43d932f745860b056" width="100%"></iframe>

## Handling errors

Handle errors in an `async` function by using try / catch: 


```dart
  try {
    var order = await getUserOrder();
    print('Awaiting user order...');
  } catch (err) {
    print('Caught error: $err');
  }
}
```
You can write [try/catch clauses](/guides/language/language-tour#catch)
the same way with asynchronous as with
synchronous code: if the code within the `try` clause throws an exception,
the code inside the `catch` clause executes. The only difference is that with
asynchronous functions you must use the async/await keywords following the 
syntax you used in the prior section:

<iframe frameborder="no" height="525" src="https://dartpad.dartlang.org/experimental/embed-new.html?id=25ade03f0632878a9169209e3cd7bef2" width="100%"></iframe>

## Practice handling errors
Use `async` and `await` to accomplish the following:

* Implement a `changeUsername` function that calls the provided asynchronous function
  `getNewUsername` and returns its result.
* The `changeUsername` function must catch any errors thrown by `getNewUsername`

<iframe frameborder="no" height="525" src="https://dartpad.dartlang.org/experimental/embed-new.html?id=858f71f0ad0e70051999bcafa41806a3" width="100%"></iframe>

## Putting it all together

It's time to sum up what you've learned in one final exercise. Write the following:

* Part1: Write a function `addHello.` `addHello` should take a single string
  argument, and return that argument surrounded by the text ‘Hello <string>!'
* Part2: Write a function `greetUser` that takes no arguments
* To obtain the username, `greetUser` should call the provided async function
  `getUsername`, which waits for 1 second before returning a string
* `greetUser` should create a greeting for the user by calling `addHello,`
  passing it the username, and returning the result. For example, if the
  username is ‘Jenny' `greetUser` should create and return the greeting "Hello
  Jenny!"
* Part3: Write a function `sayGoodbye` that takes no arguments
* Within its function body, `sayGoodbye` should call the provided async function
  `logoutUser` which takes no arguments.
* `sayGoodbye` should catch any errors thrown by `logoutUser`
* If `logoutUser` succeeds, `sayGoodbye` should return the string "<result>
  Thanks! See you next time!" where <result> is the String value returned by
  calling `logoutUser`

<iframe frameborder="no" height="525" src="https://dartpad.dartlang.org/experimental/embed-new.html?id=f601d25bc2833c957186e3c6bf71effc" width="100%"></iframe>


{{ site.alert.info }}
Note: All Dart code runs in the context of an
[isolate]({{site.dart_api}}/dart-isolate-library.html)
that owns all of the memory that the Dart code uses. While Dart code is
executing, no other code in the same isolate can run.
{{ site.alert.end }}

If you want multiple parts of Dart code to run concurrently, you can run them in
separate isolates. (Web apps use *workers* instead of isolates.) Multiple
isolates run at the same time, usually each on its own CPU core. Isolates don't
share memory, and the only way they can interact is by sending messages to each
other. </aside>

### Find out more

* Try [other Dart codelabs](/codelabs).
* Play with [DartPad.]({{site.dartpad}})
* The [Futures](/tutorials/language/futures) tutorial
* Read about [Dart's type system](/guides/language/sound-dart) for more examples
of type signatures with futures. You should
[prefer signatures in function type annotations](/guides/language/effective-dart/design#prefer-signatures-in-function-type-annotations)
wherever possible!
