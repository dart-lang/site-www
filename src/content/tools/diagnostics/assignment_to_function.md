---
title: assignment_to_function
description: >-
  Details about the assignment_to_function
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Functions can't be assigned a value._

## Description

The analyzer produces this diagnostic when the name of a function appears
on the left-hand side of an assignment expression.

## Example

The following code produces this diagnostic because the assignment to the
function `f` is invalid:

```dart
void f() {}

void g() {
  [!f!] = () {};
}
```

## Common fixes

If the right-hand side should be assigned to something else, such as a
local variable, then change the left-hand side:

```dart
void f() {}

void g() {
  var x = () {};
  print(x);
}
```

If the intent is to change the implementation of the function, then define
a function-valued variable instead of a function:

```dart
void Function() f = () {};

void g() {
  f = () {};
}
```
