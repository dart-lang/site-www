---
title: illegal_async_generator_return_type
description: >-
  Details about the illegal_async_generator_return_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Functions marked 'async*' must have a return type that is a supertype of
'Stream<T>' for some type 'T'._

## Description

The analyzer produces this diagnostic when the body of a function has the
`async*` modifier even though the return type of the function isn't either
`Stream` or a supertype of `Stream`.

## Example

The following code produces this diagnostic because the body of the
function `f` has the 'async*' modifier even though the return type `int`
isn't a supertype of `Stream`:

```dart
[!int!] f() async* {}
```

## Common fixes

If the function should be asynchronous, then change the return type to be
either `Stream` or a supertype of `Stream`:

```dart
Stream<int> f() async* {}
```

If the function should be synchronous, then remove the `async*` modifier:

```dart
int f() => 0;
```
