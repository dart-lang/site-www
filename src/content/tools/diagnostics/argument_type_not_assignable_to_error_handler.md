---
title: argument_type_not_assignable_to_error_handler
description: >-
  Details about the argument_type_not_assignable_to_error_handler
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The argument type '{0}' can't be assigned to the parameter type '{1} Function(Object)' or '{1} Function(Object, StackTrace)'._

## Description

The analyzer produces this diagnostic when an invocation of
`Future.catchError` has an argument that is a function whose parameters
aren't compatible with the arguments that will be passed to the function
when it's invoked. The static type of the first argument to `catchError`
is just `Function`, even though the function that is passed in is expected
to have either a single parameter of type `Object` or two parameters of
type `Object` and `StackTrace`.

## Examples

The following code produces this diagnostic because the closure being
passed to `catchError` doesn't take any parameters, but the function is
required to take at least one parameter:

```dart
void f(Future<int> f) {
  f.catchError([!() => 0!]);
}
```

The following code produces this diagnostic because the closure being
passed to `catchError` takes three parameters, but it can't have more than
two required parameters:

```dart
void f(Future<int> f) {
  f.catchError([!(one, two, three) => 0!]);
}
```

The following code produces this diagnostic because even though the closure
being passed to `catchError` takes one parameter, the closure doesn't have
a type that is compatible with `Object`:

```dart
void f(Future<int> f) {
  f.catchError([!(String error) => 0!]);
}
```

## Common fixes

Change the function being passed to `catchError` so that it has either one
or two required parameters, and the parameters have the required types:

```dart
void f(Future<int> f) {
  f.catchError((Object error) => 0);
}
```
