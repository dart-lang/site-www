---
title: duplicate_pattern_field
description: >-
  Details about the duplicate_pattern_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The field '{0}' is already matched in this pattern._

## Description

The analyzer produces this diagnostic when a record pattern matches the
same field more than once, or when an object pattern matches the same
getter more than once.

## Examples

The following code produces this diagnostic because the record field `a`
is matched twice in the same record pattern:

```dart
void f(({int a, int b}) r) {
  switch (r) {
    case (a: 1, [!a!]: 2):
      return;
  }
}
```

The following code produces this diagnostic because the getter `f` is
matched twice in the same object pattern:

```dart
void f(Object o) {
  switch (o) {
    case C(f: 1, [!f!]: 2):
      return;
  }
}
class C {
  int? f;
}
```

## Common fixes

If the pattern should match for more than one value of the duplicated
field, then use a logical-or pattern:

```dart
void f(({int a, int b}) r) {
  switch (r) {
    case (a: 1, b: _) || (a: 2, b: _):
      break;
  }
}
```

If the pattern should match against multiple fields, then change the name
of one of the fields:

```dart
void f(({int a, int b}) r) {
  switch (r) {
    case (a: 1, b: 2):
      return;
  }
}
```
