---
title: for_in_of_invalid_element_type
description: >-
  Details about the for_in_of_invalid_element_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type '{0}' used in the 'for' loop must implement '{1}' with a type argument
that can be assigned to '{2}'._

## Description

The analyzer produces this diagnostic when the `Iterable` or `Stream` in a
for-in loop has an element type that can't be assigned to the loop
variable.

## Example

The following code produces this diagnostic because `<String>[]` has an
element type of `String`, and `String` can't be assigned to the type of `e`
(`int`):

```dart
void f() {
  for (int e in [!<String>[]!]) {
    print(e);
  }
}
```

## Common fixes

If the type of the loop variable is correct, then update the type of the
iterable:

```dart
void f() {
  for (int e in <int>[]) {
    print(e);
  }
}
```

If the type of the iterable is correct, then update the type of the loop
variable:

```dart
void f() {
  for (String e in <String>[]) {
    print(e);
  }
}
```
