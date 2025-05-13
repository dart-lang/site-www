---
title: dead_code
description: >-
  Details about the dead_code
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Dead code._

_Dead code: The assigned-to wildcard variable is marked late and can never be
referenced so this initializer will never be evaluated._

## Description

The analyzer produces this diagnostic when code is found that won't be
executed because execution will never reach the code.

## Example

The following code produces this diagnostic because the invocation of
`print` occurs after the function has returned:

```dart
void f() {
  return;
  [!print('here');!]
}
```

## Common fixes

If the code isn't needed, then remove it:

```dart
void f() {
  return;
}
```

If the code needs to be executed, then either move the code to a place
where it will be executed:

```dart
void f() {
  print('here');
  return;
}
```

Or, rewrite the code before it, so that it can be reached:

```dart
void f({bool skipPrinting = true}) {
  if (skipPrinting) {
    return;
  }
  print('here');
}
```
