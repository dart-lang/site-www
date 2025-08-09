---
title: unreachable_switch_case
description: >-
  Details about the unreachable_switch_case
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_This case is covered by the previous cases._

## Description

The analyzer produces this diagnostic when a `case` clause in a `switch`
statement doesn't match anything because all of the matchable values are
matched by an earlier `case` clause.

## Example

The following code produces this diagnostic because the value `1` was
matched in the preceding case:

```dart
void f(int x) {
  switch (x) {
    case 1:
      print('one');
    [!case!] 1:
      print('two');
  }
}
```

## Common fixes

Change one or both of the conflicting cases to match different values:

```dart
void f(int x) {
  switch (x) {
    case 1:
      print('one');
    case 2:
      print('two');
  }
}
```
