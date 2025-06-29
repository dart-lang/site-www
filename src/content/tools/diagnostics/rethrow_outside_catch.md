---
title: rethrow_outside_catch
description: >-
  Details about the rethrow_outside_catch
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_A rethrow must be inside of a catch clause._

## Description

The analyzer produces this diagnostic when a `rethrow` statement is outside
a `catch` clause. The `rethrow` statement is used to throw a caught
exception again, but there's no caught exception outside of a `catch`
clause.

## Example

The following code produces this diagnostic because the`rethrow` statement
is outside of a `catch` clause:

```dart
void f() {
  [!rethrow!];
}
```

## Common fixes

If you're trying to rethrow an exception, then wrap the `rethrow` statement
in a `catch` clause:

```dart
void f() {
  try {
    // ...
  } catch (exception) {
    rethrow;
  }
}
```

If you're trying to throw a new exception, then replace the `rethrow`
statement with a `throw` expression:

```dart
void f() {
  throw UnsupportedError('Not yet implemented');
}
```
