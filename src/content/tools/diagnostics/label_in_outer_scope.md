---
title: label_in_outer_scope
description: >-
  Details about the label_in_outer_scope
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Can't reference label '{0}' declared in an outer method._

## Description

The analyzer produces this diagnostic when a `break` or `continue`
statement references a label that is declared in a method or function
containing the function in which the `break` or `continue` statement
appears. The `break` and `continue` statements can't be used to transfer
control outside the function that contains them.

## Example

The following code produces this diagnostic because the label `loop` is
declared outside the local function `g`:

```dart
void f() {
  loop:
  while (true) {
    void g() {
      break [!loop!];
    }

    g();
  }
}
```

## Common fixes

Try rewriting the code so that it isn't necessary to transfer control
outside the local function, possibly by inlining the local function:

```dart
void f() {
  loop:
  while (true) {
    break loop;
  }
}
```

If that isn't possible, then try rewriting the local function so that a
value returned by the function can be used to determine whether control is
transferred:

```dart
void f() {
  loop:
  while (true) {
    bool g() {
      return true;
    }

    if (g()) {
      break loop;
    }
  }
}
```
