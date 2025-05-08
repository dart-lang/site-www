---
title: async_for_in_wrong_context
description: >-
  Details about the async_for_in_wrong_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The async for-in loop can only be used in an async function._

## Description

The analyzer produces this diagnostic when an async for-in loop is found in
a function or method whose body isn't marked as being either `async` or
`async*`.

## Example

The following code produces this diagnostic because the body of `f` isn't
marked as being either `async` or `async*`, but `f` contains an async
for-in loop:

```dart
void f(list) {
  [!await!] for (var e in list) {
    print(e);
  }
}
```

## Common fixes

If the function should return a `Future`, then mark the body with `async`:

```dart
Future<void> f(list) async {
  await for (var e in list) {
    print(e);
  }
}
```

If the function should return a `Stream` of values, then mark the body with
`async*`:

```dart
Stream<void> f(list) async* {
  await for (var e in list) {
    print(e);
  }
}
```

If the function should be synchronous, then remove the `await` before the
loop:

```dart
void f(list) {
  for (var e in list) {
    print(e);
  }
}
```
