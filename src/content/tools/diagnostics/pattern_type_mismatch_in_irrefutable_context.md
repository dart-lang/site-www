---
title: pattern_type_mismatch_in_irrefutable_context
description: >-
  Details about the pattern_type_mismatch_in_irrefutable_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The matched value of type '{0}' isn't assignable to the required type '{1}'._

## Description

The analyzer produces this diagnostic when the type of the value on the
right-hand side of a pattern assignment or pattern declaration doesn't
match the type required by the pattern being used to match it.

## Example

The following code produces this diagnostic because `x` might not be a
`String` and hence might not match the object pattern:

```dart
void f(Object x) {
  var [!String(length: a)!] = x;
  print(a);
}
```

## Common fixes

Change the code so that the type of the expression on the right-hand side
matches the type required by the pattern:

```dart
void f(String x) {
  var String(length: a) = x;
  print(a);
}
```
