---
title: Assert
description: Learn how to use the assert statement to manipulate control flow in Dart.
toc: false
---

You can control the flow of your Dart code using `assert`, and other control flow
statements:

-   [`for` loops][]
-   [`while` and `do while` loops][]
-   [`break` and `continue`][]
-   [`if`, `case`, and `else`][]
-   [`switch` and `case`][]

You can also affect control flow using [Exceptions][], like `try-catch` and `throw`.

## Assert

During development, use an assert 
statement— `assert(<condition>, <optionalMessage>);` —to
disrupt normal execution if a boolean condition is false. 

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

[Exceptions]: /language/error-handling
[`for` loops]: /language/loops#for-loops
[`while` and `do while` loops]: /language/loops#while-and-do-while
[`break` and `continue`]: /language/loops#break-and-continue
[`if`, `case`, and `else`]: /language/branches#if-else
[`switch` and `case`]: /language/branches#switch-case
[trailing comma]: /language/collections#trailing-comma
[`AssertionError`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/AssertionError-class.html
[Flutter debug mode]: {{site.flutter-docs}}/testing/debugging#debug-mode-assertions
[`webdev serve`]: /tools/webdev#serve
[`dart run`]: /tools/dart-run
[`dart compile js`]: /tools/dart-compile#js