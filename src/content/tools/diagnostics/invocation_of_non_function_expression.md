---
title: invocation_of_non_function_expression
description: >-
  Details about the invocation_of_non_function_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The expression doesn't evaluate to a function, so it can't be invoked._

## Description

The analyzer produces this diagnostic when a function invocation is found,
but the name being referenced isn't the name of a function, or when the
expression computing the function doesn't compute a function.

## Examples

The following code produces this diagnostic because `x` isn't a function:

```dart
int x = 0;

int f() => x;

var y = [!x!]();
```

The following code produces this diagnostic because `f()` doesn't return a
function:

```dart
int x = 0;

int f() => x;

var y = [!f()!]();
```

## Common fixes

If you need to invoke a function, then replace the code before the argument
list with the name of a function or with an expression that computes a
function:

```dart
int x = 0;

int f() => x;

var y = f();
```
