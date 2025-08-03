---
title: expected_one_list_pattern_type_arguments
description: >-
  Details about the expected_one_list_pattern_type_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_List patterns require one type argument or none, but {0} found._

## Description

The analyzer produces this diagnostic when a list pattern has more than
one type argument. List patterns can have either zero type arguments or
one type argument, but can't have more than one.

## Example

The following code produces this diagnostic because the list pattern
(`[0]`) has two type arguments:

```dart
void f(Object x) {
  if (x case [!<int, int>!][0]) {}
}
```

## Common fixes

Remove all but one of the type arguments:

```dart
void f(Object x) {
  if (x case <int>[0]) {}
}
```
