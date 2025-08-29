---
title: field_initializer_not_assignable
description: >-
  Details about the field_initializer_not_assignable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The initializer type '{0}' can't be assigned to the field type '{1}' in a const constructor._
_The initializer type '{0}' can't be assigned to the field type '{1}'._

## Description

The analyzer produces this diagnostic when the initializer list of a
constructor initializes a field to a value that isn't assignable to the
field.

## Example

The following code produces this diagnostic because `0` has the type `int`,
and an `int` can't be assigned to a field of type `String`:

```dart
class C {
  String s;

  C() : s = [!0!];
}
```

## Common fixes

If the type of the field is correct, then change the value assigned to it
so that the value has a valid type:

```dart
class C {
  String s;

  C() : s = '0';
}
```

If the type of the value is correct, then change the type of the field to
allow the assignment:

```dart
class C {
  int s;

  C() : s = 0;
}
```
