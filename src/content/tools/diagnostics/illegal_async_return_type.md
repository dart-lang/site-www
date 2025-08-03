---
title: illegal_async_return_type
description: >-
  Details about the illegal_async_return_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Functions marked 'async' must have a return type which is a supertype of
'Future'._

## Description

The analyzer produces this diagnostic when the body of a function has the
`async` modifier even though the return type of the function isn't
assignable to `Future`.

## Example

The following code produces this diagnostic because the body of the
function `f` has the `async` modifier even though the return type isn't
assignable to `Future`:

```dart
[!int!] f() async {
  return 0;
}
```

## Common fixes

If the function should be asynchronous, then change the return type to be
assignable to `Future`:

```dart
Future<int> f() async {
  return 0;
}
```

If the function should be synchronous, then remove the `async` modifier:

```dart
int f() => 0;
```
