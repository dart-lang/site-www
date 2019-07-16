---
title: Asynchronous Dart code - futures, async, and await 
description: A series of explanations and exercises for writing asynchronous code in Dart
date: 2019-06-12
tags: [ future, async, await, asynchronous, try, catch, error ]
---

## Introduction

Welcome to the asynchronous Dart codelab! In this codelab, you practice using
Dart to run asynchronous code using the `async` and `await` keywords.

In addition to explaining how to write asynchronous Dart code,
this codelab includes embedded editors that show
you working code examples and coding exercises. You can use these editors to 
test your knowledge by completing the exercises.

Here's what you should know to get the most out of this codelab:

* Have programming experience in another language.
* Know basic Dart syntax.
* Have some experience writing asynchronous code in another language.

This codelab covers the following material:

* How to use the `async` keyword.
* How to use the `await` keyword.
* When to use `async` and `await` in your code.
* How your code executes when using the `async/await` keywords.
* How to handle errors from an asynchronous call using `try/catch` expressions
in `async` functions.
* Where to find more information for the `async/await` material 
covered in this codelab.

Estimated time to complete this codelab: 45-50 minutes.

## Key terms 
This section provides definitions for the key terms that appear 
throughout this codelab. The first section lists key terms that are generally
used in asynchronous programming. The second section defines keywords and 
terminology for writing asynchronous programs in Dart.

### Asynchronous programming terms

**synchronous operation**   
A synchronous operation blocks other operations from executing until it completes. 

**synchronous function**  
A synchronous function only performs synchronous operations.

**asynchronous operation**   
Once initiated, an asynchronous operation allows 
other operations to execute before it completes.

**asynchronous function**   
An asynchronous function performs asynchronous operations.


### Terms for asynchronous programming in Dart 
Don't worry if you are unfamiliar with these terms - this codelab will cover them in detail.

**Future**  
"Future" refers to the Dart [Future](https://api.dartlang.org/stable/dart-async/Future-class.html) class.

**future**   
"future" refers to an instance of the Dart Future class.

**async**  
Use the `async` keyword to define an asynchronous function. To use the
`async` keyword you must add it to a function definition just before the 
function's body. Once you define an `async` function, you invoke it by prefixing
it with the `await` keyword. 

**async function**  
A Dart `async` function is a function labeled with the `async` keyword.

**await**    
Before invoking an `async` function, you must use the `await` keyword. 
This syntax allows the caller to access the completed value of the future.

 

## Why asynchronous code matters

Asynchronous operations let your program complete work while waiting for 
another operation to finish. Some common processes that use asynchronous 
operations include: 

* Fetching data over a network.
* Writing to a database.
* Reading data from a file.

To implement these features, you will need to learn about the `Future` class
as well as the `async` and `await` keywords. In Dart you cannot use synchronous
code to handle asynchronous operations.

Consider the following example that fails to print the desired user order to the
console: 

## Example

[//]: https://gist.github.com/d7abfdea1ae5596e96c7c0203d975dba
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=5c8c7716b6b4284842f15fe079f61e47"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="420"
  width="100%" >
</iframe>

In the preceding example:

* `getUserOrder` is an asynchronous function that waits four seconds before
returning a string describing the user's order: a large latte. (For a further
explanation you can find out more about 
[Future.delayed]({{site.dart_api}}/Future.delayed.html)).
* `createOrderMessage` calls `getUserOrder` as if it were a synchronous 
function&mdash;it invokes `getUserOrder` and immediately prints the result. 
* Since `getUserOrder` waits four seconds before returning the user's order,
`createOrderMessage` never prints the user's order. Instead the console
prints the value returned by `createOrderMessage` which
turns out to be `Instance of '_Future<String>'`.

Next, you will learn about futures like the ones shown in the preceding example.
You will also learn how to write code to handle the asynchronous function `getUserOrder`.
 
 {{ site.alert.secondary }} 
  Quick review: 
  * Asynchronous operations let a program do work while waiting for an operation to finish.
  * Dart contains specific keywords and classes for writing asynchronous code.
 {{ site.alert.end }}


## Async in Dart: What is a future?

In Dart, a
[Future]({{site.dart_api}}/Future-class.html)
represents the result of an asynchronous operation. A future has
two states: uncompleted or completed.

{{ site.alert.note }}
  'Uncompleted' is a Dart term referring to the state of a future
  before it has produced a result.
{{ site.alert.end }}

### Uncompleted

When you invoke a function that returns a future, that function immediately 
returns a future in an uncompleted state. While in its uncompleted state,
a future is waiting for asynchronous operations to finish or to 
throw an error. 

### Completed

There are two ways that a future can complete:

#### 1. Success

If the asynchronous operations succeed, the future completes and returns a 
result of type T. For example,  
`Future<String>` is the type signature for a future that produces a string
result. If a future produces a result that isn't a usable value, then the
future's type is `Future<void>`. 

In the following example `getUserOrder` returns a future that completes by printing 
to the console.

## Example

[//]: https://gist.github.com/57e6085344cbd1719ed42b32f8ad1bce
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=57e6085344cbd1719ed42b32f8ad1bce"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="300"
  width="100%" >
</iframe>

In the preceding example, even though `getUserOrder` executes before the `print` method on line 8, the console
shows the `print` output from line 8 ("Fetching user order...") before the output from
`getUserOrder` ("Large Latte). This is because `getUserOrder` delays for 3 seconds before it
completes by printing `Large Latte` to the console.

#### 2. Error

If the asynchronous operations performed by the function throw an error or
exception, the future completes and throws the error or exception.

In the following example, `getUserOrder` returns a future that completes by 
throwing an Exception.

## Example

[//]: https://gist.github.com/d843061bbd9388b837c57613dc6d5125
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=d843061bbd9388b837c57613dc6d5125"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="275"
  width="100%" >
</iframe>

In this example, `getUserOrder` completes with an Exception indicating that the user ID is invalid.

You have learned about futures and how they complete, but how do you handle their
results? In the next section you will learn how to use the `async` and `await`
keywords to handle the results of asynchronous functions. 

{{ site.alert.secondary }}
  Quick Review:

  * In Dart, a
  [Future]({{site.dart_api}}/Future-class.html)
  produces a result of type `<T>`. For example,
  [Future]({{site.dart_api}}/Future-class.html)`<String>`
  is the type signature for a future that produces a string result. If a
  future produces a result that isn't a usable value, then the future's type is
  `Future<void>`.
  * A future can be in one of two states: uncompleted, or completed. 
  * A completed future can either (1) complete with a result or (2) complete with
  an error.
  * When you invoke a function that returns a future:

  1. The function queues up work to be done and returns an uncompleted future.
  2. Later, when the operation finishes, the future completes with a value or
  with an error.
{{ site.alert.end }}


## Working with futures in Dart: async and await

The `async` and `await` keywords provide a declarative way to define 
asynchronous functions and access their results *after they have completed.*

To define an `async` function:

1. Add the `async` keyword after the function's parameters but before the function's body:  
    {% prettify dart %}
        String createOrderMessage() [!async!] {
    {% endprettify %}

2. Update the function's type signature to return a future. The following  
example defines an `async` function that doesn't return a usable value:
    {% prettify dart %}
        [!Future<String>!] createOrderMessage() async {
    {% endprettify %}

{{ site.alert.info }}
 You can 
 [use Future\<void\>]({{url}}/guides/language/effective-dart/design#do-use-futurevoid-as-the-return-type-of-asynchronous-members-that-do-not-produce-values)
 as the return type for asynchronous functions that don't return usable values.
{{ site.alert.end }}

Now that you have declared an `async` function:
  1. Your function returns a future that completes with the type that you specify.
  1. You must use the `await` keyword before invoking the function  to "wait"
   for the future to complete either with a value or an error.

{% prettify dart %}
var order = [!await!] getUserOrder();
{% endprettify %}


The following examples provide a comparison of a synchronous function
and an asynchronous function.  

In this synchronous example the console immediately prints the messages 
"Your order is: Instance of '_Future<String>'". 

## Example

[//]: https://gist.github.com/8f4d136e7eb447f4acc7ccb523006e10
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=8f4d136e7eb447f4acc7ccb523006e10"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="450"
  width="100%">
</iframe>

The following example shows the same code as before, but implemented asynchronously.
Since you can only use the `await` keyword within an `async` function body, the 
`createOrderMessage()` function is now marked with the `async` keyword.

In this asynchronous example, the console  prints the result "Your order is: Large
Latte" after a four second delay. 

## Example

[//]: https://gist.github.com/b8d026d2b23102084534159fafc9d7c6
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=b8d026d2b23102084534159fafc9d7c6"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="450"
  width="100%">
</iframe>

This asynchronous example has three changes from the preceding synchronous example:

1. Update the return types for `createOrderMessage` and `getUserOrder` from 
`String` to `Future<String>`.
2. Add the **`async`** keyword before the method bodies for `createOrderMessage`
and the `main` method.
3. Use the **`await`** keyword before calling the asynchronous functions 
`getUserOrder` and `createOrderMessage`.


{{ site.alert.info }}
  Dart can [infer the Future\<T\> type](https://dart.dev/guides/language/sound-dart#type-inference) for you.
{{ site.alert.end }}

{{ site.alert.secondary }}
  Quick review: 
  * An `async` function returns a future.
  * You can only use the `async` and `await` keywords within an `async` function body.
  * To declare an `async` function, add the keyword after the function's parameters but before the function's body.
  * Use the `await` keyword before invoking an `async` function to "wait" for the future to complete either with a value or an error.
{{ site.alert.end }}

## Execution flow with async and await

As of Dart 2, functions marked as `async` run synchronously until the first
`await` keyword. This means that within an `async` function's body, all
synchronous code immediately executes so long as the synchronous code appears
before the first `await` keyword. The following example demonstrates how 
execution proceeds within an `async` function body:

## Example

[//]: https://gist.github.com/d7abfdea1ae5596e96c7c0203d975dba
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=d7abfdea1ae5596e96c7c0203d975dba"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 40px"
  frameborder="no"
  height="550"
  width="100%">
</iframe>

After running the code in the preceding example, try reversing line 4 and line 5:

{% prettify dart %}
  var order = await getUserOrder();
  print('Awaiting user order...');
{% endprettify %}

Notice that the timing of the output shifts now that the `print("Awaiting user order")`
statement appears after the first `await` keyword in `createOrderMessage`.

## Practice using async and await

The following exercise is a failing unit test that contains partially completed
code snippets. Your task is to complete the exercise by writing code to make the 
tests pass. To simulate asynchronous operations, __the exercise provides the 
async functions `getRole` and `getLoginAmount`. You don't need
to implement these provided functions. You don't need to implement `main()`.__
Verify your code by clicking the "Run" button.

### Part 1: `reportUserRole`
Add logic to the `reportUserRole` function:

1. `reportUserRole` returns a Future that produces the String result `'User role: <user role>'`.
1. Example return value from `reportUserRole`: `'User role: tester'` (Note: you must
use the actual value returned by `getRole`; copying and pasting this text will not pass the test).
1. Obtain the user role by calling the provided `async` function `getRole`
1. `getRole` returns a `String` describing the user's role.

### Part 2: `reportLogins`
Implement an `async` function `reportLogins`:

1. `reportLogins` returns the string `'Total number of logins: <# of logins>'`.
1. Example return value from `reportLogins: 'Total number of logins: 57'` (Note: you must
use the actual value returned by `getLoginAmount`; copying and pasting this text will not pass the test).
1. Obtain the number of logins by calling the provided `async` function `getLoginAmount`
1. `getLoginAmount` returns an `int` representing the number of times that the user has logged in.


## Exercise

[//]: https://gist.github.com/f751b692502c4ee43d932f745860b056
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=f751b692502c4ee43d932f745860b056&theme=dark"
  frameborder="no"
  height="525"
  width="100%">
</iframe>

{{ site.alert.info }}
  [Info-level messages](/guides/language/analysis-options#customizing-analysis-rules) from DartPad provide you with additional information, but they do not
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
You can write [try/catch clauses](/guides/language/language-tour#catch)
the same way with asynchronous as with
synchronous code: if the code within the `try` clause throws an exception,
the code inside the `catch` clause executes. The difference is that with
asynchronous functions you must use the async/await keywords following the 
syntax you used in the prior section:

## Example

[//]: https://gist.github.com/25ade03f0632878a9169209e3cd7bef2
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=25ade03f0632878a9169209e3cd7bef2"
  frameborder="no"
  height="475"
  width="100%" >
</iframe>

## Practice handling errors
__This exercise provides the async function `getNewUsername`. 
You don’t need to implement this provided function.__
Use `async` and `await` to do the following:

* Implement a `changeUsername` function that calls the provided asynchronous function
  `getNewUsername` and returns its result.
* The `changeUsername` function must catch any errors thrown by `getNewUsername`.

## Exercise

[//]: https://gist.github.com/858f71f0ad0e70051999bcafa41806a3
<iframe 
  src="https://dartpad.dartlang.org/experimental/embed-new-dart.html?id=858f71f0ad0e70051999bcafa41806a3&theme=dark"
  frameborder="no"
  height="525"
  width="100%" >
</iframe>

## Putting it all together

It's time to practice what you've learned in one final exercise. 
To simulate asynchronous operations, __this exercise provides the async functions
`getUsername` and `logoutUser`. You don’t need to implement these provided functions.
You don't need to implement `main()`.__

Write the following:

### Part 1: `addHello` 
* Write a function `addHello` that takes a single String
  argument
 * `addHello` should return its String argument surrounded by the text ‘Hello \<string\>'

### Part 2: `greetUser`
* Write a function `greetUser` that takes no arguments.
* To obtain the username, `greetUser` should call the provided `async` function
  `getUsername`, which waits for 1 second before returning a string.
* `greetUser` should create a greeting for the user by calling `addHello,`
  passing it the username, and returning the result. For example, if the
  username is ‘Jenny' `greetUser` should create and return the greeting "Hello
  Jenny!"

### Part 3: `sayGoodbye`
* Write a function `sayGoodbye` that takes no arguments.
* `sayGoodbye` should catch any errors.
* `sayGoodbye` should call the provided `async` function
  `logoutUser` which takes no arguments.
* If `logoutUser` succeeds, `sayGoodbye` should return the string "\<result\>
  Thanks! See you next time!" where \<result\> is the String value returned by
  calling `logoutUser`.

## Exercise

[//]: https://gist.github.com/f601d25bc2833c957186e3c6bf71effc
<iframe 
  src="https://dartpad.dev/experimental/embed-new-dart.html?id=f601d25bc2833c957186e3c6bf71effc&theme=dark"
  frameborder="no"
  height="525"
  width="100%">
</iframe>

## What next?

* [Asynchronous programming: futures & async-await](/tutorials/language/futures) tutorial
* [Dart's type system](/guides/language/sound-dart) (Includes more examples of type signatures with futures).
* [Preferring signatures in function type annotations](/guides/language/effective-dart/design#prefer-signatures-in-function-type-annotations)
from [Effective Dart](/guides/language/effective-dart)
* Try [other Dart codelabs](/codelabs).
* Play with [DartPad.]({{site.dartpad}})
