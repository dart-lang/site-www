---
title: return_in_generator
description: >-
  Details about the return_in_generator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Can't return a value from a generator function that uses the 'async*' or
'sync*' modifier._

## Description

The analyzer produces this diagnostic when a generator function (one whose
body is marked with either `async*` or `sync*`) uses either a `return`
statement to return a value or implicitly returns a value because of using
`=>`. In any of these cases, they should use `yield` instead of `return`.

## Examples

The following code produces this diagnostic because the method `f` is a
generator and is using `return` to return a value:

```dart
Iterable<int> f() sync* {
  [!return!] 3;
}
```

The following code produces this diagnostic because the function `f` is a
generator and is implicitly returning a value:

```dart
Stream<int> f() async* [!=>!] 3;
```

## Common fixes

If the function is using `=>` for the body of the function, then convert it
to a block function body, and use `yield` to return a value:

```dart
Stream<int> f() async* {
  yield 3;
}
```

If the method is intended to be a generator, then use `yield` to return a
value:

```dart
Iterable<int> f() sync* {
  yield 3;
}
```

If the method isn't intended to be a generator, then remove the modifier
from the body (or use `async` if you're returning a future):

```dart
int f() {
  return 3;
}
```
