## Asynchronous Dart Code: Future, async, and await


## Introduction


Welcome to the asynchronous Dart codelab! In this codelab you'll practice using
Dart to run asynchronous code via the `async` and `await` keywords.

In addition to explanations, this codelab includes embedded editors that show 
you working code examples and coding exercises. You can use these editors to 
test your knowledge by completing the exercises.

Before you begin this codelab, you should:

* Have some experience writing asynchronous code -- for example, writing code 
that sends a request to a server and then handles a response

When you finish this codelab, you'll know the following: 

* How to use the `async` keyword
* How to use the `await` keyword
* When to use `async` and `await` in your code
* How your code will be executed when you use the `async/await` keywords
* How to handle errors from an asynchronous call using `try/catch` expressions 
in async functions.
* Where to find more information for related to the `async/await` material 
covered in this codelab.


## Why Async Matters

Asynchronous operations let your program complete other work while waiting for 
an operation to finish. Some common processes that require asynchronous 
operations include: 

* Fetching data over a network
* Writing to a database
* Reading data from a file

In order to write code that implements these features, you will need to learn 
the Dart syntax for Futures, async, and await. In Dart you cannot use 
synchronous code to handle asynchronous operations. 

Consider the following example that fails to print the desired user order to the
console: 

Note: this example shows how *not* to handle asynchronous code in dart. 
{:.fails-sa}

```
String createOrderMessage () {
  var order = getUserOrder(); 
  return 'Your order is: $order';
}

Future<String> getUserOrder() {
  // Imagine that this function is more complex and slow
  return Future.delayed(Duration(seconds: 4), () => 'Large Latte'); 
}

main() {
  print(createOrderMessage()); 
}
```

`// Your order is: Instance of '_Future<String>'`

In the above code:

* `getUserOrder` is an asynchronous function that waits four seconds before 
returning a string describing the user's order: a large latte. (For a further
 explanation you can  
 [find out more about Future.delayed](https://api.dartlang.org/stable/2.3.0/dart-async/Future/Future.delayed.html))
* `createOrderMessage` calls `getUserOrder` as if it were a synchronous function
 -- it invokes `getUserOrder` and immediately prints the result. 
* Since `getUserOrder` waits four seconds before returning the user's order, 
`createOrderMessage` never actually prints the user's order. Instead you can see
 `Instance of '_Future<String>'`  printed to the console as the value returned 
 by `createOrderMessage().`

What is a future, and how do we write code to handle the asynchronous function
 `getUserOrder`?


## Async in Dart: What is a Future?



In Dart, the result of an asynchronous operation is represented by a
[Future](https://api.dartlang.org/stable/2.2.0/dart-async/Future-class.html)
object. A future object can be in one of two states: uncompleted or completed.

### **Lifecycle of a Future Object**

### **Uncompleted**

When you invoke a function that returns a future, that function immediately 
returns a future object in an uncompleted state. While in its uncompleted state,
 a future object is simply waiting for asynchronous operations to finish or to 
 throw an error. 

### **Completed **

There are two ways that a future object can complete:

#### **Completed - Success**

If the asynchronous operations succeed, the future completes and returns a 
result of type T. For example,  
[Future](https://api.dartlang.org/stable/2.3.0/dart-async/Future-class.html)
`<String>` is the type signature for a future object that produces a string
result. If a future produces a result that isn't a usable value, then the
future's type is `Future<void>`. 

#### **Completed - Error**

Instead of succeeding, if the asynchronous operations being performed by the 
function throw an error, the future completes and returns an error. 

To see this lifecycle at work consider what happens after you invoke the 
`getUserOrder` function:

```
String createOrderMessage () {
  var order = getUserOrder(); 
  return 'Your order is: $order';
}

Future<String> getUserOrder() {
  // Imagine that this function is more complex and slow
  return Future.delayed(Duration(seconds: 4), () => 'Large Latte'); 
}

main() {
  print(createOrderMessage()); 
}
```

`// Your order is: Instance of '_Future<String>'`

* after 1 second has passed: the future is uncomplete - we cannot access the
desired result yet

`     Your order is: Instance of '_Future<String>'`

* after 4 seconds have passed: the future completes, returning the desired
result 

`'Large Latte'`


But how do you access this result that completes 4 seconds later? In addition
to providing future objects, Dart also provides a clean and easy way to handle
their results -- the `async` and `await` keywords. 

Quick Review:

* In Dart, the result of an asynchronous operation is represented by a
[Future](https://api.dartlang.org/stable/2.2.0/dart-async/Future-class.html)`<T>`
object that produces a result of type `T`. For example,
[Future](https://api.dartlang.org/stable/2.3.0/dart-async/Future-class.html)`<String>`
is the type signature for a future object that produces a string result. If a 
future produces a result that isn't a usable value, then the future's type is
`Future<void>`. 
* A future can be in one of two states: uncompleted, or completed. 
* A completed future can either (1) complete with a result or (2) complete with
an error
* When a function that returns a future is invoked, two things happen:

1. The function queues up work to be done and returns an uncompleted future.
2. Later, when the operation is finished, the future completes with a value or
with an error.


## Working with Futures in Dart: async and await



In the previous section you learned that, in Dart, future objects represent the
results of asynchronous operations -- if a function does asynchronous work, it
returns a future object. But how do we access the results of future objects when
using asynchronous functions?

The `async` and `await` keywords provide a declarative way to (1) define
asynchronous functions and (2) access their results *after they have completed.*


To define an `async` function:

1. Add the `async` keyword after the function's parameters but before the
   function's body.

    createOrderMessage () async {

2. Update the function's type signature to return a future. In the following example, we define an `async` function that completes with a string.   

    Future<String> createOrderMessage () async {

 *Note: You can * [use
 Future<void>](https://dart.dev/guides/language/effective-dart/design#do-use-futurevoid-as-the-return-type-of-asynchronous-members-that-do-not-produce-values) *
 as the return type for asynchronous functions that don't return usable values.
 *


Once you have defined an async function, that function will return a future
object. Using the await keyword, you can "wait" for the completed future to
return either its value or its error.

    String order = await getUserOrder();

Remember, you can only use the `await` keyword within an `async` function body.
The following example demonstrates how to convert `createOrderMessage` from
synchronous to asynchronous:

```
// BEFORE: handle a function that returns a string

String createOrderMessage () {
  var order = getUserOrder();
  return 'Your order is: $order';
}

main() {
  print(createOrderMessage()); 
}
```

```
// After: handle an async function that returns a Future<String>

Future<String> createOrderMessage () async {
  var order = await getUserOrder();
  return 'Your order is: $order';
}

main() async {
  print(await createOrderMessage());
}
```

*  *Note: * [All functions return a
   value](https://dart.dev/guides/language/language-tour#return-values) * even
   if you don't explicitly use the * *`return`* * keyword. *
*  *Note: Dart can *  [infer the Future<String> type](https://dart.dev/guides/language/sound-dart#type-inference) * for you.
* 

This code has only three changes from the preceding implementation:

1. Mark the return type for `createOrderMessage` with `Future<String>`
2. Add **`async`** before the method body (the `createOrderMessage` and the `main` method)
3. Add **`await`** before the calling the asynchronous function (before we invoke `getUserOrder` and `createOrderMessage`)


## Execution Flow with async and await



As of Dart 2.0, functions marked as `async` run synchronously until the first
`await` keyword. This means that within an `async` function's body, all
synchronous code is immediately executed. This is demonstrated in the following
example:

```
void createOrderMessage () async {
  print('Awaiting user order...');
  var order = await getUserOrder();
  print('Your order is: $order');
}

Future<String> getUserOrder() {
  return Future.delayed(Duration(seconds: 4), () => 'Large Latte'); 
}

main() async {
  await createOrderMessage();
}

// Output: 
// Awaiting user order...
// (4 second pause)
// Your order is: Large Latte
```

Notice that the timing of the output shifts if we move the print statement
"Awaiting user order" to the line after the first await keyword in
`createOrderMessage`:

```
void createOrderMessage () async {
  var order = await getUserOrder();
  print('Awaiting user order...');
  print('Your order is: $order');
}

Future<String> getUserOrder() {
  return Future.delayed(Duration(seconds: 4), () => 'Large Latte'); 
}

main() async {
  await createOrderMessage();
}

// Output: 
// (4 seconds pause)
// Awaiting user order...
// Your order is: Large Latte
```


## Practice Using async and await



The exercise below is created with partially completed code snippets as a
failing unit test, and you will be writing code and make it pass. Verify your
code by clicking the Run button.

Add the following:

* Part 1: Add logic to the `reportUserRole` function so that it returns a Future
  that produces the String result ‘User role: <user role>!'. The <user role> can
  be obtained by calling the provided async function `getRole` which returns a
  `String` describing the user role. Example return value from
  `reportUserRole()`: `'User role: tester'`
* Part 2: Write an `async` function `reportLogins` that returns the string:
  ‘Total number of logins: <login amount>'. The <login amount> can be obtained
  by calling the provided asynchronous function `getLoginAmount`, which returns
  an `int` representing the number of times that the user has logged in. Example
  return value from `reportLogins(): 'Total number of logins: 57'`


## Handling errors



`Async` functions can handle errors using try-catch:

```
void createOrderMessage () async {
  try {
    var order = await getUserOrder();
    print('Awaiting user order...');
  } catch (err) {
    print('Caught error: $err');
  }
}

Future<String> getUserOrder() {
  // Imagine that this function is more complex and throws an exception
  var str = Future.delayed(Duration(seconds: 4), () => throw 'Cannot locate user order');
  return str;
}

main() async {
  await createOrderMessage();
}

// Caught error: Cannot locate user order
```

The try-catch code behaves in the same way with asynchronous code as it does
with synchronous code: if the code within the `try` block throws an exception,
the code inside the `catch` clause executes.


## Practice Handling Errors with async and awaitImplement code to accomplish the following:



* Make `changeUsername` call the provided asynchronous function
  `getNewUsername`, and return its result
* `changeUsername` must catch and return any errors thrown by getNewUsername,
  prefixing the returned error with the following string: `Error:`
* Example return value from `changeUsername` when `getNewUsername` throws an
  error: `Error: Username must contain only alphanumeric values`


## Putting It All Together



Now it's time to sum up what you've learned in one final exercise. In the
following snippet, write the following:

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

<aside class="special">

**Note**: All Dart code runs in the context of an
[isolate](https://api.dartlang.org/stable/2.2.0/dart-isolate/dart-isolate-library.html)
that owns all of the memory that the Dart code uses. While Dart code is
executing, no other code in the same isolate can run.

If you want multiple parts of Dart code to run concurrently, you can run them in
separate isolates. (Web apps use *workers* instead of isolates.) Multiple
isolates run at the same time, usually each on its own CPU core. Isolates don't
share memory, and the only way they can interact is by sending messages to each
other. </aside>

Find Out More

*  [Futures](https://www.dartlang.org/tutorials/language/futures)
*  [The Event Loop in Dart](https://webdev.dartlang.org/articles/performance/event-loop)
*  [Isolates](https://api.dartlang.org/stable/2.2.0/dart-isolate/dart-isolate-library.html)
* Read about [Dart's type system](https://dart.dev/guides/language/sound-dart)
  for more examples of type signatures with futures. You should [prefer
  signatures in function type
  annotations](https://dart.dev/guides/language/effective-dart/design#prefer-signatures-in-function-type-annotations)
  wherever possible!
