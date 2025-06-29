---
title: illegal_sync_generator_return_type
description: >-
  Details about the illegal_sync_generator_return_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Functions marked 'sync*' must have a return type that is a supertype of
'Iterable<T>' for some type 'T'._

## Description

The analyzer produces this diagnostic when the body of a function has the
`sync*` modifier even though the return type of the function isn't either
`Iterable` or a supertype of `Iterable`.

## Example

The following code produces this diagnostic because the body of the
function `f` has the 'sync*' modifier even though the return type `int`
isn't a supertype of `Iterable`:

```dart
[!int!] f() sync* {}
```

## Common fixes

If the function should return an iterable, then change the return type to
be either `Iterable` or a supertype of `Iterable`:

```dart
Iterable<int> f() sync* {}
```

If the function should return a single value, then remove the `sync*`
modifier:

```dart
int f() => 0;
```
