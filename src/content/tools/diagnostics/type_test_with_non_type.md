---
title: type_test_with_non_type
description: >-
  Details about the type_test_with_non_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The name '{0}' isn't a type and can't be used in an 'is' expression._

## Description

The analyzer produces this diagnostic when the right-hand side of an `is`
or `is!` test isn't a type.

## Example

The following code produces this diagnostic because the right-hand side is
a parameter, not a type:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a is [!b!]) {
    return;
  }
}
```

## Common fixes

If you intended to use a type test, then replace the right-hand side with a
type:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a is B) {
    return;
  }
}
```

If you intended to use a different kind of test, then change the test:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a == b) {
    return;
  }
}
```
