---
title: Control flow statements
description: Learn how to control the flow of your Dart code.
---

You can control the flow of your Dart code using any of the following:

-   `if` and `else`
-   `for` loops
-   `while` and `do`-`while` loops
-   `break` and `continue`
-   `switch` and `case`
-   `assert`

You can also affect the control flow using `try-catch` and `throw`, as
explained in [Exceptions][].


## If and else

Dart supports `if` statements with optional `else` statements, as the
next sample shows. Also see [conditional expressions][].

<?code-excerpt "misc/lib/language_tour/control_flow.dart (if-else)"?>
```dart
if (isRaining()) {
  you.bringRainCoat();
} else if (isSnowing()) {
  you.wearJacket();
} else {
  car.putTopDown();
}
```

The statement conditions must be expressions
that evaluate to boolean values, nothing else.
See [Booleans][] for more information.


## For loops

You can iterate with the standard `for` loop. For example:

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (for)"?>
```dart
var message = StringBuffer('Dart is fun');
for (var i = 0; i < 5; i++) {
  message.write('!');
}
```

Closures inside of Dart’s `for` loops capture the _value_ of the index,
avoiding a common pitfall found in JavaScript. For example, consider:

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (for-and-closures)"?>
```dart
var callbacks = [];
for (var i = 0; i < 2; i++) {
  callbacks.add(() => print(i));
}

for (final c in callbacks) {
  c();
}
```

The output is `0` and then `1`, as expected. In contrast, the example
would print `2` and then `2` in JavaScript.

If the object that you are iterating over is an Iterable (such as List or Set)
and if you don't need to know the current iteration counter, 
you can use the `for-in` form of [iteration][]:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (collection)"?>
```dart
for (final candidate in candidates) {
  candidate.interview();
}
```

{{site.alert.tip}}
  To practice using `for-in`, follow the
  [Iterable collections codelab](/codelabs/iterables).
{{site.alert.end}}

Iterable classes also have a [forEach()][] method as another option:

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (forEach)"?>
```dart
var collection = [1, 2, 3];
collection.forEach(print); // 1 2 3
```


## While and do-while

A `while` loop evaluates the condition before the loop:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (while)"?>
```dart
while (!isDone()) {
  doSomething();
}
```

A `do`-`while` loop evaluates the condition *after* the loop:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (do-while)"?>
```dart
do {
  printLine();
} while (!atEndOfPage());
```


## Break and continue

Use `break` to stop looping:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (while-break)"?>
```dart
while (true) {
  if (shutDownRequested()) break;
  processIncomingRequests();
}
```

Use `continue` to skip to the next loop iteration:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (for-continue)"?>
```dart
for (int i = 0; i < candidates.length; i++) {
  var candidate = candidates[i];
  if (candidate.yearsExperience < 5) {
    continue;
  }
  candidate.interview();
}
```

You might write that example differently if you’re using an
[`Iterable`][] such as a list or set:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (where)"?>
```dart
candidates
    .where((c) => c.yearsExperience >= 5)
    .forEach((c) => c.interview());
```


## Switch and case

Switch statements in Dart compare integer, string, or compile-time
constants using `==`. The compared objects must all be instances of the
same class (and not of any of its subtypes), and the class must not
override `==`.
[Enumerated types][] work well in `switch` statements.

Each non-empty `case` clause ends with a `break` statement, as a rule.
Other valid ways to end a non-empty `case` clause are a `continue`,
`throw`, or `return` statement.

Use a `default` clause to execute code when no `case` clause matches:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (switch)"?>
```dart
var command = 'OPEN';
switch (command) {
  case 'CLOSED':
    executeClosed();
    break;
  case 'PENDING':
    executePending();
    break;
  case 'APPROVED':
    executeApproved();
    break;
  case 'DENIED':
    executeDenied();
    break;
  case 'OPEN':
    executeOpen();
    break;
  default:
    executeUnknown();
}
```

The following example omits the `break` statement in a `case` clause,
thus generating an error:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (switch-break-omitted)" plaster="none"?>
```dart
var command = 'OPEN';
switch (command) {
  case 'OPEN':
    executeOpen();
    // ERROR: Missing break

  case 'CLOSED':
    executeClosed();
    break;
}
```

However, Dart does support empty `case` clauses, allowing a form of
fall-through:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (switch-empty-case)"?>
```dart
var command = 'CLOSED';
switch (command) {
  case 'CLOSED': // Empty case falls through.
  case 'NOW_CLOSED':
    // Runs for both CLOSED and NOW_CLOSED.
    executeNowClosed();
    break;
}
```

If you really want fall-through, you can use a `continue` statement and
a label:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (switch-continue)"?>
```dart
var command = 'CLOSED';
switch (command) {
  case 'CLOSED':
    executeClosed();
    continue nowClosed;
  // Continues executing at the nowClosed label.

  nowClosed:
  case 'NOW_CLOSED':
    // Runs for both CLOSED and NOW_CLOSED.
    executeNowClosed();
    break;
}
```

A `case` clause can have local variables, which are visible only inside
the scope of that clause.


## Assert

During development, use an assert 
statement—<code>assert(<em>condition</em>, <em>optionalMessage</em>)</code>;—to
disrupt normal execution if a boolean condition is false. 
You can find examples of assert statements throughout this tour. 
Here are some more:

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (assert)"?>
```dart
// Make sure the variable has a non-null value.
assert(text != null);

// Make sure the value is less than 100.
assert(number < 100);

// Make sure this is an https URL.
assert(urlString.startsWith('https'));
```

To attach a message to an assertion,
add a string as the second argument to `assert`
(optionally with a [trailing comma][]):

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (assert-with-message)"?>
```dart
assert(urlString.startsWith('https'),
    'URL ($urlString) should start with "https".');
```

The first argument to `assert` can be any expression that
resolves to a boolean value. If the expression’s value
is true, the assertion succeeds and execution
continues. If it's false, the assertion fails and an exception (an
[`AssertionError`][]) is thrown.

When exactly do assertions work?
That depends on the tools and framework you're using:

* Flutter enables assertions in [debug mode.][Flutter debug mode]
* Development-only tools such as [`webdev serve`][]
  typically enable assertions by default.
* Some tools, such as [`dart run`][] and [`dart compile js`][]
  support assertions through a command-line flag: `--enable-asserts`.

In production code, assertions are ignored, and
the arguments to `assert` aren't evaluated.

[Exceptions]: /language/error-handling#exceptions
[conditional expressions]: /language/operators#conditional-expressions
[Booleans]: /language/built-in-types#booleans
[iteration]: /guides/libraries/library-tour#iteration
[forEach()]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable/forEach.html
[`Iterable`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html
[Enumerated types]: /language/enum
[trailing comma]: /language/collection-types#lists
[`AssertionError`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/AssertionError-class.html
[Flutter debug mode]: {{site.flutter-docs}}/testing/debugging#debug-mode-assertions
[webdev serve]: /tools/webdev#serve
[`dart run`]: /tools/dart-run
[dart compile js]: /tools/dart-compile#js
