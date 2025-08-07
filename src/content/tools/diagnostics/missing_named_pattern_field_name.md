---
title: missing_named_pattern_field_name
description: >-
  Details about the missing_named_pattern_field_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The getter name is not specified explicitly, and the pattern is not a
variable._

## Description

The analyzer produces this diagnostic when, within an object pattern, the
specification of a property and the pattern used to match the property's
value doesn't have either:

- a getter name before the colon
- a variable pattern from which the getter name can be inferred

## Example

The following code produces this diagnostic because there is no getter
name before the colon and no variable pattern after the colon in the
object pattern (`C(:0)`):

```dart
abstract class C {
  int get f;
}

void f(C c) {
  switch (c) {
    case C([!:0!]):
      break;
  }
}
```

## Common fixes

If you need to use the actual value of the property within the pattern's
scope, then add a variable pattern where the name of the variable is the
same as the name of the property being matched:

```dart
abstract class C {
  int get f;
}

void f(C c) {
  switch (c) {
    case C(:var f) when f == 0:
      print(f);
  }
}
```

If you don't need to use the actual value of the property within the
pattern's scope, then add the name of the property being matched before
the colon:

```dart
abstract class C {
  int get f;
}

void f(C c) {
  switch (c) {
    case C(f: 0):
      break;
  }
}
```
