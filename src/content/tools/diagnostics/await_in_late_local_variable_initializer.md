---
title: await_in_late_local_variable_initializer
description: >-
  Details about the await_in_late_local_variable_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The 'await' expression can't be used in a 'late' local variable's initializer._

## Description

The analyzer produces this diagnostic when a local variable that has the
`late` modifier uses an `await` expression in the initializer.

## Example

The following code produces this diagnostic because an `await` expression
is used in the initializer for `v`, a local variable that is marked `late`:

```dart
Future<int> f() async {
  late var v = [!await!] 42;
  return v;
}
```

## Common fixes

If the initializer can be rewritten to not use `await`, then rewrite it:

```dart
Future<int> f() async {
  late var v = 42;
  return v;
}
```

If the initializer can't be rewritten, then remove the `late` modifier:

```dart
Future<int> f() async {
  var v = await 42;
  return v;
}
```
