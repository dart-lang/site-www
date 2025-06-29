---
title: yield_in_non_generator
description: >-
  Details about the yield_in_non_generator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Yield statements must be in a generator function (one marked with either
'async*' or 'sync*')._

_Yield-each statements must be in a generator function (one marked with either
'async*' or 'sync*')._

## Description

The analyzer produces this diagnostic when a `yield` or `yield*` statement
appears in a function whose body isn't marked with one of the `async*` or
`sync*` modifiers.

## Examples

The following code produces this diagnostic because `yield` is being used
in a function whose body doesn't have a modifier:

```dart
Iterable<int> get digits {
  yield* [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
}
```

The following code produces this diagnostic because `yield*` is being used
in a function whose body has the `async` modifier rather than the `async*`
modifier:

```dart
Stream<int> get digits async {
  yield* [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
}
```

## Common fixes

Add a modifier, or change the existing modifier to be either `async*` or
`sync*`:

```dart
Iterable<int> get digits sync* {
  yield* [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
}
```
