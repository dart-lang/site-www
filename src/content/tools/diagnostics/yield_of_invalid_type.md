---
title: yield_of_invalid_type
description: >-
  Details about the yield_of_invalid_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A yielded value of type '{0}' must be assignable to '{1}'._

_The type '{0}' implied by the 'yield*' expression must be assignable to '{1}'._

## Description

The analyzer produces this diagnostic when the type of object produced by
a `yield` or `yield*` expression doesn't match the type of objects that
are to be returned from the `Iterable` or `Stream` types that are returned
from a generator (a function or method marked with either `sync*` or
`async*`).

## Example

The following code produces this diagnostic because the getter `zero` is
declared to return an `Iterable` that returns integers, but the `yield` is
returning a string from the iterable:

```dart
Iterable<int> get zero sync* {
  yield [!'0'!];
}
```

## Common fixes

If the return type of the function is correct, then fix the expression
following the keyword `yield` to return the correct type:

```dart
Iterable<int> get zero sync* {
  yield 0;
}
```

If the expression following the `yield` is correct, then change the return
type of the function to allow it:

```dart
Iterable<String> get zero sync* {
  yield '0';
}
```
