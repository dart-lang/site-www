---
title: invalid_return_type_for_catch_error
description: >-
  Details about the invalid_return_type_for_catch_error
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A value of type '{0}' can't be returned by the 'onError' handler because it
must be assignable to '{1}'._

_The return type '{0}' isn't assignable to '{1}', as required by
'Future.catchError'._

## Description

The analyzer produces this diagnostic when an invocation of
`Future.catchError` has an argument whose return type isn't compatible with
the type returned by the instance of `Future`. At runtime, the method
`catchError` attempts to return the value from the callback as the result
of the future, which results in another exception being thrown.

## Examples

The following code produces this diagnostic because `future` is declared to
return an `int` while `callback` is declared to return a `String`, and
`String` isn't a subtype of `int`:

```dart
void f(Future<int> future, String Function(dynamic, StackTrace) callback) {
  future.catchError([!callback!]);
}
```

The following code produces this diagnostic because the closure being
passed to `catchError` returns an `int` while `future` is declared to
return a `String`:

```dart
void f(Future<String> future) {
  future.catchError((error, stackTrace) => [!3!]);
}
```

## Common fixes

If the instance of `Future` is declared correctly, then change the callback
to match:

```dart
void f(Future<int> future, int Function(dynamic, StackTrace) callback) {
  future.catchError(callback);
}
```

If the declaration of the instance of `Future` is wrong, then change it to
match the callback:

```dart
void f(Future<String> future, String Function(dynamic, StackTrace) callback) {
  future.catchError(callback);
}
```
