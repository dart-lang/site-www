---
title: "Asynchronous programming: futures, async, await"
description: Learn about and practice writing asynchronous code in DartPad!
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

This tutorial explains how to write asynchronous code using
futures and the `async` and `await` keywords.
It uses embedded copies of the DartPad IDE.
To test your knowledge,
complete the exercises in these embedded DartPads then run example code.

:::secondary What you'll learn

* How and when to use the `async` and `await` keywords.
* How using `async` and `await` affects execution order.
* How to handle errors from an asynchronous call
  using `try-catch` expressions in `async` functions.

:::

## Tutorial parameters

### Requirements

To get the most out of this tutorial, you need the following:

* Knowledge of [basic Dart syntax](/language).
* Some experience writing asynchronous code in another language.

### Duration

Estimated time to complete this tutorial: 40-60 minutes.

### Format

This page uses embedded DartPads to display examples and exercises.
{% render 'dartpads-embedded-troubleshooting.md' %}

The exercises in this tutorial include partial code snippets.
To test your knowledge, complete the code in the DartPad and
click **Run**.
**Don't edit the test code in or after the `main` function.**

If you need help, expand the **Hint** or **Solution** dropdown
after each exercise.

### Glossary

**synchronous operation**
: A synchronous operation blocks other operations
  from executing until it completes.

**synchronous function**
: A synchronous function only performs synchronous operations.

**asynchronous operation**
: Once initiated, an asynchronous operation allows
  other operations to execute before it completes.

**asynchronous function**
: An asynchronous function performs at least one
  asynchronous operation and can also perform _synchronous_ operations.

**Future**
: The Dart [Future][] class.

**future**
: One instance of the Dart `Future` class.

**async**
: You can use the `async` keyword before a function's body to mark it as
  asynchronous.

**async function**
: An `async` function is a function labeled with the `async` keyword.

**await**
: You can use the `await` keyword to get the completed result of an
  asynchronous expression. The `await` keyword only works within an `async` function.

## Why does asynchronous code matter?

Asynchronous operations let your program complete work
while waiting for another operation to finish.
Some common asynchronous operations include:

* Fetching data over a network
* Writing to a database
* Reading data from a file

Such asynchronous computations provide their result as a `Future`
or, if the result has multiple parts, as a `Stream`.
These computations introduce asynchrony into a program.
To accommodate that initial asynchrony,
other plain Dart functions also need to become asynchronous.

To interact with these asynchronous results,
you can use the `async` and `await` keywords.
Most asynchronous functions are just async Dart functions
that depend, possibly deep down,
on an inherently asynchronous computation.

### Example: Incorrect use of an asynchronous function {:.no_toc}

The following example shows the wrong way
to use an asynchronous function (`fetchUserOrder()`).
Later you'll fix the example using `async` and `await`.
Before running this example, try to spot the issue --
what do you think the output will be?

<?code-excerpt "async_await/bin/get_order_sync_bad.dart" remove="Fetching"?>
```dartpad theme="dark"
// This example shows how *not* to write asynchronous Dart code.

String createOrderMessage() {
  var order = fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is more complex and slow.
    Future.delayed(
      const Duration(seconds: 2),
      () => 'Large Latte',
    );

void main() {
  print(createOrderMessage());
}
```

Here's why the example fails to print the value
that `fetchUserOrder()` should produce:

1. The asynchronous function `fetchUserOrder()`
   provides a string that describes the user's order: a "Large Latte".
1. To get the user's order,
   `createOrderMessage()` calls `fetchUserOrder()`
   and needs to wait for it to finish.
   As `createOrderMessage()` _doesn't_ wait
   for `fetchUserOrder()` to finish, `createOrderMessage()` fails to
   get the string value that `fetchUserOrder()` would provide.
1. `createOrderMessage()` gets a representation of pending work to be
   done: an _uncompleted future_.
1. As `createOrderMessage()` fails to get the value describing the user's
   order, the example fails to print "Large Latte" to the console.
   It instead prints `Your order is: Instance of '_Future\<String\>'`.

In the next sections,
you'll learn about futures and use `async` and `await` to work with futures.
This helps you write the necessary code so `fetchUserOrder()`
prints the desired value to the console.

## What is a future?

A future (lower case "f") is a single instance
of the [Future][] (capitalized "F") class.

A future represents the result of an asynchronous operation.
It can have two states: uncompleted or completed.

### Uncompleted future state

Dart refers to a future as _Uncompleted_ when the state of a future
has yet to produce a value.

When you call an asynchronous function, it returns an uncompleted future.
That future is waiting for the function's asynchronous operation
to finish or to throw an error.

### Completed future state

If the asynchronous operation succeeds,
the future completes with a value.
Otherwise, it completes with an error.

#### Complete with a value

A future of type `Future<T>` completes with a value of type `T`.
For example, a future with type `Future<String>` produces a string value.
If a future doesn't produce a usable value,
then the future's type is `Future<void>`.

#### Complete with an error

If the asynchronous operation performed by the function fails for any reason,
the future completes with an error.

### Example: How futures work {:.no_toc}

In the following example, `fetchUserOrder()` returns a future
that completes after printing to the console.
Because it doesn't return a usable value,
`fetchUserOrder()` has the type `Future<void>`.

Before you run the example,
try to predict which will print first:
"Large Latte" or "Fetching user order...".

<?code-excerpt "async_await/bin/futures_intro.dart (no-error)"?>
```dartpad theme="dark"
Future<void> fetchUserOrder() {
  // Imagine that this function is fetching user info from another service or database.
  return Future.delayed(const Duration(seconds: 2), () => print('Large Latte'));
}

void main() {
  fetchUserOrder();
  print('Fetching user order...');
}
```

In the preceding example,
`fetchUserOrder()` executes before the `print()` call on line 8,
the console shows the output from line 8 (`Fetching user order...`)
before the output from `fetchUserOrder()` (`Large Latte`).
The `fetchUserOrder()` method delays before it prints `Large Latte`.

### Example: Complete with an error {:.no_toc}

Run the following example to see how a future completes with an error.
A bit later you'll learn how to handle the error.

<?code-excerpt "async_await/bin/futures_intro.dart (error)" replace="/Error//g"?>
```dartpad theme="dark"
Future<void> fetchUserOrder() {
  // Imagine that this function is fetching user info but encounters a bug.
  return Future.delayed(
    const Duration(seconds: 2),
    () => throw Exception('Logout failed: user ID is invalid'),
  );
}

void main() {
  fetchUserOrder();
  print('Fetching user order...');
}
```

In this example, `fetchUserOrder()` completes
with an error indicating that the user ID is invalid.

You've learned about futures and how they complete,
but how do you use the results of asynchronous functions?
In the next section,
you'll learn how to get results with the `async` and `await` keywords.

:::secondary Quick review

* A [Future\<T\>][Future] instance produces a value of type `T`.
* If a future doesn't produce a usable value,
  then the future's type is `Future<void>`.
* A future can be in one of two states: uncompleted or completed.
* When you call a function that returns a future,
  the function queues up work to be done and returns an uncompleted future.
* When a future's operation finishes,
  the future completes with a value or with an error.

:::

## How do you use futures?

### Use `async` and `await` keywords

To define asynchronous functions and use their results,
use the `async` and `await` keywords.

To use `async` and `await`:

* _To define an async function, prepend `async` to the function body._
* _The `await` keyword works only within `async` functions._

To convert `main()` from a synchronous to asynchronous function,
complete the following steps.

1. Add the `async` keyword before the function body:

   <?code-excerpt "async_await/bin/get_order_sync_bad.dart (main-sig)" replace="/main\(\)/$& async/g; /async/[!$&!]/g; /$/ ··· }/g"?>
   ```dart
   void main() [!async!] { ··· }
   ```

1. If the function has a declared return type,
   then update the type to be `Future<T>`,
   where `T` is the type of the value that the function returns.
   If the function doesn't explicitly return a value,
   then the return type is `Future<void>`.

   <?code-excerpt "async_await/bin/get_order.dart (main-sig)" replace="/Future<\w+\W/[!$&!]/g;  /$/ ··· }/g"?>
   ```dart
   [!Future<void>!] main() async { ··· }
   ```

1. As the code now has an `async` function,
   add the `await` keyword to wait for a future to complete.

   <?code-excerpt "async_await/bin/get_order.dart (print-order)" replace="/await/[!$&!]/g"?>
   ```dart
   print([!await!] createOrderMessage());
   ```

As shown in following two examples,
the `async` and `await` keywords result in asynchronous code that
resembles synchronous code.

#### Example: Use synchronous functions

<?code-excerpt "async_await/bin/get_order_sync_bad.dart (no-warning)" replace="/(\s+\/\/ )(Imagine.*? is )(.*)/$1$2$1$3/g"?>
```dart
String createOrderMessage() {
  var order = fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is
    // more complex and slow.
    Future.delayed(
      const Duration(seconds: 2),
      () => 'Large Latte',
    );

void main() {
  print('Fetching user order...');
  print(createOrderMessage());
}
```

```plaintext
Fetching user order...
Your order is: Instance of '_Future<String>'
```

#### Example: Use asynchronous functions

<?code-excerpt "async_await/bin/get_order.dart" replace="/(\s+\/\/ )(Imagine.*? is )(.*)/$1$2$1$3/g; /async|await/[!$&!]/g; /(Future<\w+\W)( [^f])/[!$1!]$2/g; /4/2/g"?>
```dart
[!Future<String>!] createOrderMessage() [!async!] {
  var order = [!await!] fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is
    // more complex and slow.
    Future.delayed(
      const Duration(seconds: 2),
      () => 'Large Latte',
    );

[!Future<void>!] main() [!async!] {
  print('Fetching user order...');
  print([!await!] createOrderMessage());
}
```

```plaintext
Fetching user order...
Your order is: Large Latte
```

The asynchronous example differs in three ways:

1. The return type for `createOrderMessage()` changes from `String`
   to `Future<String>`.
1. The **`async`** keyword appears before the function bodies for
   `createOrderMessage()` and `main()`.
1. The **`await`** keyword appears before calling the asynchronous functions
   `fetchUserOrder()` and `createOrderMessage()`.

### How do execution flow work with async and await?

An `async` function runs _synchronously_ until the first `await` keyword.
This means that within an `async` function body,
all synchronous code before the first `await` keyword executes immediately.

#### Example: Execution within async functions

Run the following example to see how execution proceeds
within an `async` function body.
What do you think the output will be?

<?code-excerpt "async_await/bin/async_example.dart" remove="/\/\/ print/"?>
```dartpad theme="dark"
Future<void> printOrderMessage() async {
  print('Awaiting user order...');
  var order = await fetchUserOrder();
  print('Your order is: $order');
}

Future<String> fetchUserOrder() {
  // Imagine that this function is more complex and slow.
  return Future.delayed(const Duration(seconds: 4), () => 'Large Latte');
}

void main() async {
  countSeconds(4);
  await printOrderMessage();
}

// You can ignore this function - it's here to visualize delay time in this example.
void countSeconds(int s) {
  for (var i = 1; i <= s; i++) {
    Future.delayed(Duration(seconds: i), () => print(i));
  }
}
```

After running the code in the preceding example, try reversing lines 2 and 3:

<?code-excerpt "async_await/bin/async_example.dart (swap-stmts)" replace="/\/\/ (print)/$1/g"?>
```dart
var order = await fetchUserOrder();
print('Awaiting user order...');
```

Notice that timing of the output shifts, now that `print('Awaiting user order')`
appears after the first `await` keyword in `printOrderMessage()`.

#### Exercise: Practice using async and await

The following exercise is a failing unit test
that contains partially completed code snippets.
Your task is to complete the exercise by writing code to make the tests pass.
You don't need to implement `main()`.

To simulate asynchronous operations, call the following functions,
which are provided for you:

<div class="table-wrapper">

| Function           | Type signature                   | Description                                    |
|--------------------|----------------------------------|------------------------------------------------|
| fetchRole()        | `Future<String> fetchRole()`     | Gets a short description of the user's role.   |
| fetchLoginAmount() | `Future<int> fetchLoginAmount()` | Gets the number of times a user has logged in. |

{:.table .table-striped}
</div>

##### Part 1: `reportUserRole()`

Add code to the `reportUserRole()` function so that it does the following:

* Returns a future that completes with the following
  string: `"User role: <user role>"`
  * Use the actual value that `fetchRole()` returns.
    Copying and pasting the example return value won't make the test pass.
  * Example return value: `"User role: tester"`
* Gets the user role by calling the provided function `fetchRole()`.

##### Part 2: `reportLogins()`

Implement an `async` function `reportLogins()` so that it does the following:

* Returns the string `"Total number of logins: <# of logins>"`.
  * Note: You must use the actual value returned by `fetchLoginAmount()`;
    copying and pasting the example return value won't make the test pass.
  * Example return value from `reportLogins()`: `"Total number of logins: 57"`
* Gets the number of logins by calling the provided function `fetchLoginAmount()`.

```dartpad theme="dark" theme="dark"
// Part 1
// Call the provided async function fetchRole()
// to return the user role.
Future<String> reportUserRole() async {
  // TODO: Implement the reportUserRole function here.
}

// Part 2
// TODO: Implement the reportLogins function here.
// Call the provided async function fetchLoginAmount()
// to return the number of times that the user has logged in.
reportLogins() {}

// The following functions those provided to you to simulate
// asynchronous operations that could take a while.

Future<String> fetchRole() => Future.delayed(_halfSecond, () => _role);
Future<int> fetchLoginAmount() => Future.delayed(_halfSecond, () => _logins);

// The following code is used to test and provide feedback on your solution.
// There is no need to read or modify it.

void main() async {
  print('Testing...');
  List<String> messages = [];
  const passed = 'PASSED';
  const testFailedMessage = 'Test failed for the function:';
  const typoMessage = 'Test failed! Check for typos in your return value';
  try {
    messages
      ..add(_makeReadable(
          testLabel: 'Part 1',
          testResult: await _asyncEquals(
            expected: 'User role: administrator',
            actual: await reportUserRole(),
            typoKeyword: _role,
          ),
          readableErrors: {
            typoMessage: typoMessage,
            'null':
                'Test failed! Did you forget to implement or return from reportUserRole?',
            'User role: Instance of \'Future<String>\'':
                '$testFailedMessage reportUserRole. Did you use the await keyword?',
            'User role: Instance of \'_Future<String>\'':
                '$testFailedMessage reportUserRole. Did you use the await keyword?',
            'User role:':
                '$testFailedMessage reportUserRole. Did you return a user role?',
            'User role: ':
                '$testFailedMessage reportUserRole. Did you return a user role?',
            'User role: tester':
                '$testFailedMessage reportUserRole. Did you invoke fetchRole to fetch the user\'s role?',
          }))
      ..add(_makeReadable(
          testLabel: 'Part 2',
          testResult: await _asyncEquals(
            expected: 'Total number of logins: 42',
            actual: await reportLogins(),
            typoKeyword: _logins.toString(),
          ),
          readableErrors: {
            typoMessage: typoMessage,
            'null':
                'Test failed! Did you forget to implement or return from reportLogins?',
            'Total number of logins: Instance of \'Future<int>\'':
                '$testFailedMessage reportLogins. Did you use the await keyword?',
            'Total number of logins: Instance of \'_Future<int>\'':
                '$testFailedMessage reportLogins. Did you use the await keyword?',
            'Total number of logins: ':
                '$testFailedMessage reportLogins. Did you return the number of logins?',
            'Total number of logins:':
                '$testFailedMessage reportLogins. Did you return the number of logins?',
            'Total number of logins: 57':
                '$testFailedMessage reportLogins. Did you invoke fetchLoginAmount to fetch the number of user logins?',
          }))
      ..removeWhere((m) => m.contains(passed))
      ..toList();

    if (messages.isEmpty) {
      print('Success. All tests passed!');
    } else {
      messages.forEach(print);
    }
  } on UnimplementedError {
    print(
        'Test failed! Did you forget to implement or return from reportUserRole?');
  } catch (e) {
    print('Tried to run solution, but received an exception: $e');
  }
}

const _role = 'administrator';
const _logins = 42;
const _halfSecond = Duration(milliseconds: 500);

// Test helpers.
String _makeReadable({
  required String testResult,
  required Map<String, String> readableErrors,
  required String testLabel,
}) {
  if (readableErrors.containsKey(testResult)) {
    var readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
  }
}

// Assertions used in tests.
Future<String> _asyncEquals({
  required String expected,
  required dynamic actual,
  required String typoKeyword,
}) async {
  var strActual = actual is String ? actual : actual.toString();
  try {
    if (expected == actual) {
      return 'PASSED';
    } else if (strActual.contains(typoKeyword)) {
      return 'Test failed! Check for typos in your return value';
    } else {
      return strActual;
    }
  } catch (e) {
    return e.toString();
  }
}
```

<details>
<summary title="Expand for a hint on the async-await exercise.">Hint</summary>

* Did you remember to add the `async` keyword to the `reportUserRole` function?

* Did you remember to use the `await` keyword before invoking `fetchRole()`?

* Remember: `reportUserRole` needs to return a `Future`.

</details>

<details>
<summary title="Expand for the solution of the async-await exercise.">Solution</summary>

```dart
Future<String> reportUserRole() async {
  final username = await fetchRole();
  return 'User role: $username';
}

Future<String> reportLogins() async {
  final logins = await fetchLoginAmount();
  return 'Total number of logins: $logins';
}
```

</details>

## How do you handle errors?

To handle errors in an `async` function, use `try` and `catch` blocks.

<?code-excerpt "async_await/bin/try_catch.dart (try-catch)" remove="print(order)"?>
```dart
try {
  print('Awaiting user order...');
  var order = await fetchUserOrder();
} catch (err) {
  print('Caught error: $err');
}
```

Within an `async` function, you can write
[try-catch clauses](/language/error-handling#catch)
as you would in synchronous code.

### Example: Use `try`-`catch` with `async` and `await` {:.no_toc}

To see how to handle an error from an asynchronous function,
run the following example.
What do you think the output will be?

<?code-excerpt "async_await/bin/try_catch.dart"?>
```dartpad theme="dark"
Future<void> printOrderMessage() async {
  try {
    print('Awaiting user order...');
    var order = await fetchUserOrder();
    print(order);
  } catch (err) {
    print('Caught error: $err');
  }
}

Future<String> fetchUserOrder() {
  // Imagine that this function is more complex.
  var str = Future.delayed(
      const Duration(seconds: 4),
      () => throw 'Cannot locate user order');
  return str;
}

void main() async {
  await printOrderMessage();
}
```

### Exercise: Practice error handling {:.no_toc}

The following exercise provides practice handling errors with asynchronous code,
using the approach described in the previous section. To simulate asynchronous
operations, your code will call the following function, which is provided for you:

<div class="table-wrapper">

| Function           | Type signature                      | Description                                                      |
|--------------------|-------------------------------------|------------------------------------------------------------------|
| fetchNewUsername() | `Future<String> fetchNewUsername()` | Returns the new username that you can use to replace an old one. |

{:.table .table-striped}
</div>

Use `async` and `await` to implement an asynchronous `changeUsername()` function
that does the following:

* Calls the provided asynchronous function `fetchNewUsername()`
  and returns its result.
  * Example return value from `changeUsername()`: `"jane_smith_92"`
* Catches any error that occurs and returns the string value of the error.
  * You can use the
    [toString()]({{site.dart-api}}/{{site.sdkInfo.channel}}/dart-core/ArgumentError/toString.html)
    method to stringify both
    [Exceptions]({{site.dart-api}}/{{site.sdkInfo.channel}}/dart-core/Exception-class.html)
    and
    [Errors.]({{site.dart-api}}/{{site.sdkInfo.channel}}/dart-core/Error-class.html)

```dartpad theme="dark" theme="dark"
// TODO: Implement changeUsername here.
changeUsername() {}

// The following function is provided to you to simulate
// an asynchronous operation that could take a while and
// potentially throw an exception.

Future<String> fetchNewUsername() =>
    Future.delayed(const Duration(milliseconds: 500), () => throw UserError());

class UserError implements Exception {
  @override
  String toString() => 'New username is invalid';
}

// The following code is used to test and provide feedback on your solution.
// There is no need to read or modify it.

void main() async {
  final List<String> messages = [];
  const typoMessage = 'Test failed! Check for typos in your return value';

  print('Testing...');
  try {
    messages
      ..add(_makeReadable(
          testLabel: '',
          testResult: await _asyncDidCatchException(changeUsername),
          readableErrors: {
            typoMessage: typoMessage,
            _noCatch:
                'Did you remember to call fetchNewUsername within a try/catch block?',
          }))
      ..add(_makeReadable(
          testLabel: '',
          testResult: await _asyncErrorEquals(changeUsername),
          readableErrors: {
            typoMessage: typoMessage,
            _noCatch:
                'Did you remember to call fetchNewUsername within a try/catch block?',
          }))
      ..removeWhere((m) => m.contains(_passed))
      ..toList();

    if (messages.isEmpty) {
      print('Success. All tests passed!');
    } else {
      messages.forEach(print);
    }
  } catch (e) {
    print('Tried to run solution, but received an exception: $e');
  }
}

// Test helpers.
String _makeReadable({
  required String testResult,
  required Map<String, String> readableErrors,
  required String testLabel,
}) {
  if (readableErrors.containsKey(testResult)) {
    final readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
  }
}

Future<String> _asyncErrorEquals(Function fn) async {
  final result = await fn();
  if (result == UserError().toString()) {
    return _passed;
  } else {
    return 'Test failed! Did you stringify and return the caught error?';
  }
}

Future<String> _asyncDidCatchException(Function fn) async {
  var caught = true;
  try {
    await fn();
  } on UserError catch (_) {
    caught = false;
  }

  if (caught == false) {
    return _noCatch;
  } else {
    return _passed;
  }
}

const _passed = 'PASSED';
const _noCatch = 'NO_CATCH';
```

<details>
<summary title="Expand for a hint on the error-handling exercise.">Hint</summary>

Implement `changeUsername` to return the string from `fetchNewUsername` or,
if that fails, the string value of any error that occurs.

Remember: You can use a [try-catch statement](/language/error-handling#catch)
to catch and handle errors.

</details>

<details>
<summary title="Expand for the solution of the error-handling exercise.">Solution</summary>

```dart
Future<String> changeUsername() async {
  try {
    return await fetchNewUsername();
  } catch (err) {
    return err.toString();
  }
}
```

</details>

## How do you put it all together?

Practice what you've learned with one final exercise.

To simulate asynchronous operations, this exercise provides the asynchronous
functions `fetchUsername()` and `logoutUser()`:

| Function        | Type signature                   | Description                                                                   |
|-----------------|----------------------------------|-------------------------------------------------------------------------------|
| fetchUsername() | `Future<String> fetchUsername()` | Returns the name associated with the current user.                            |
| logoutUser()    | `Future<String> logoutUser()`    | Performs logout of current user and returns the username that was logged out. |

{:.table .table-striped}

Write the following into the DartPad embedded at the end of this section.

1. Complete the `addHello()` function on line 2.
   This function should:

   * Take a single `String` argument.
   * Return `'Hello '` then its `String` argument.

   Example: `addHello('Jon')` returns `'Hello Jon'`.

1. Complete the `greetUser()` function on line 7.
   This function should:

   * Take no arguments.
   * Get the username using the provided asynchronous
     function `fetchUsername()`.
   * Pass the username to a call to the `addHello()` function
     and return a greeting for the user.

   Example: If `fetchUsername()` returns `'Jenny'`, then
   `greetUser()` returns `'Hello Jenny'`.

1. Complete the `sayGoodbye()` function on line 12.
   This function should:

   * Take no arguments.
   * Catch any errors.
   * Call the provided asynchronous function `logoutUser()`.

     * If `logoutUser()` fails, `sayGoodbye()` returns any string you like.
     * If `logoutUser()` succeeds, `sayGoodbye()` returns the string
       `'<result> Thanks, see you next time'`, where `<result>` is
       the string value returned by calling `logoutUser()`.

```dartpad theme="dark"
// Part 1
addHello(String user) {}

// Part 2
// Call the provided async function fetchUsername()
// to return the username.
greetUser() {}

// Part 3
// Call the provided async function logoutUser()
// to log out the user.
sayGoodbye() {}

// The following functions are provided to you to use in your solutions.

Future<String> fetchUsername() => Future.delayed(_halfSecond, () => 'Jean');

Future<String> logoutUser() => Future.delayed(_halfSecond, _failOnce);

// The following code is used to test and provide feedback on your solution.
// There is no need to read or modify it.

void main() async {
  const didNotImplement =
      'Test failed! Did you forget to implement or return from';

  final List<String> messages = [];

  print('Testing...');
  try {
    messages
      ..add(_makeReadable(
          testLabel: 'Part 1',
          testResult: await _asyncEquals(
              expected: 'Hello Jerry',
              actual: addHello('Jerry'),
              typoKeyword: 'Jerry'),
          readableErrors: {
            _typoMessage: _typoMessage,
            'null': '$didNotImplement addHello?',
            'Hello Instance of \'Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
            'Hello Instance of \'_Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
          }))
      ..add(_makeReadable(
          testLabel: 'Part 2',
          testResult: await _asyncEquals(
              expected: 'Hello Jean',
              actual: await greetUser(),
              typoKeyword: 'Jean'),
          readableErrors: {
            _typoMessage: _typoMessage,
            'null': '$didNotImplement greetUser?',
            'HelloJean':
                'Looks like you forgot the space between \'Hello\' and \'Jean\'',
            'Hello Instance of \'Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
            'Hello Instance of \'_Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
            '{Closure: (String) => dynamic from Function \'addHello\': static.(await fetchUsername())}':
                'Did you place the \'\$\' character correctly?',
            '{Closure \'addHello\'(await fetchUsername())}':
                'Did you place the \'\$\' character correctly?',
          }))
      ..add(_makeReadable(
          testLabel: 'Part 3',
          testResult: await _asyncDidCatchException(sayGoodbye),
          readableErrors: {
            _typoMessage:
                '$_typoMessage. Did you add the text \'Thanks, see you next time\'?',
            'null': '$didNotImplement sayGoodbye?',
            _noCatch:
                'Did you remember to call logoutUser within a try/catch block?',
            'Instance of \'Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
            'Instance of \'_Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
          }))
      ..add(_makeReadable(
          testLabel: 'Part 3',
          testResult: await _asyncEquals(
              expected: 'Success! Thanks, see you next time',
              actual: await sayGoodbye(),
              typoKeyword: 'Success'),
          readableErrors: {
            _typoMessage:
                '$_typoMessage. Did you add the text \'Thanks, see you next time\'?',
            'null': '$didNotImplement sayGoodbye?',
            _noCatch:
                'Did you remember to call logoutUser within a try/catch block?',
            'Instance of \'Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
            'Instance of \'_Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
            'Instance of \'_Exception\'':
                'CAUGHT Did you remember to return a string?',
          }))
      ..removeWhere((m) => m.contains(_passed))
      ..toList();

    if (messages.isEmpty) {
      print('Success. All tests passed!');
    } else {
      messages.forEach(print);
    }
  } catch (e) {
    print('Tried to run solution, but received an exception: $e');
  }
}

// Test helpers.
String _makeReadable({
  required String testResult,
  required Map<String, String> readableErrors,
  required String testLabel,
}) {
  String? readable;
  if (readableErrors.containsKey(testResult)) {
    readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else if ((testResult != _passed) && (testResult.length < 18)) {
    readable = _typoMessage;
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
  }
}

Future<String> _asyncEquals({
  required String expected,
  required dynamic actual,
  required String typoKeyword,
}) async {
  final strActual = actual is String ? actual : actual.toString();
  try {
    if (expected == actual) {
      return _passed;
    } else if (strActual.contains(typoKeyword)) {
      return _typoMessage;
    } else {
      return strActual;
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> _asyncDidCatchException(Function fn) async {
  var caught = true;
  try {
    await fn();
  } on Exception catch (_) {
    caught = false;
  }

  if (caught == true) {
    return _passed;
  } else {
    return _noCatch;
  }
}

const _typoMessage = 'Test failed! Check for typos in your return value';
const _passed = 'PASSED';
const _noCatch = 'NO_CATCH';
const _halfSecond = Duration(milliseconds: 500);

String _failOnce() {
  if (_logoutSucceeds) {
    return 'Success!';
  } else {
    _logoutSucceeds = true;
    throw Exception('Logout failed');
  }
}

bool _logoutSucceeds = false;
```

<details>
<summary title="Expand for a hint on the 'Putting it all together' exercise.">Hint</summary>

The `greetUser` and `sayGoodbye` functions should be asynchronous,
while `addHello` should be a normal, synchronous function.

Remember: You can use a [try-catch statement](/language/error-handling#catch)
to catch and handle errors.

</details>

<details>
<summary title="Expand for the solution of the 'Putting it all together' exercise.">Solution</summary>

```dart
String addHello(String user) => 'Hello $user';

Future<String> greetUser() async {
  final username = await fetchUsername();
  return addHello(username);
}

Future<String> sayGoodbye() async {
  try {
    final result = await logoutUser();
    return '$result Thanks, see you next time';
  } catch (e) {
    return 'Failed to logout user: $e';
  }
}
```

</details>

## Which lints work for futures?

In real-world scenarios, enable the following two lints to help with
futures.

* [discarded_futures][]
* [unawaited_futures][]

By default, these lints aren't enabled.

[discarded_futures]: /tools/linter-rules/discarded_futures
[unawaited_futures]: /tools/linter-rules/unawaited_futures

## What's next?

Congratulations, you've finished the tutorial!
To learn more, consult some of the following guides:

* Play with [DartPad]({{site.dartpad}}).
* Try another [tutorial](/tutorials).
* Learn more about futures and asynchronous code in Dart:
  * [Streams tutorial](/libraries/async/using-streams):
    Learn how to work with a sequence of asynchronous events.
  * [Concurrency in Dart](/language/concurrency):
    Understand and learn how to implement concurrency in Dart.
  * [Asynchrony support](/language/async):
    Dive in to Dart's language and library support for asynchronous coding.
  * [Dart videos from Google][Dart videos]:
    Watch one or more of the videos about asynchronous coding.
* Get the [Dart SDK](/get-dart)!

[Dart videos]: {{yt.playlist}}PLjxrf2q8roU0Net_g1NT5_vOO3s_FR02J
[Future]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-async/Future-class.html
[style guide]: /effective-dart/style
[documentation guide]: /effective-dart/documentation
[usage guide]: /effective-dart/usage
[design guide]: /effective-dart/design
