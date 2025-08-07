---
title: dot_shorthand_missing_context
description: >-
  Details about the dot_shorthand_missing_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A dot shorthand can't be used where there is no context type._

## Description

The analyzer produces this diagnostic when a dot shorthand is used where
there is no context type.

## Example

The following code produces this diagnostic because there is no context
type for the expression `.a`:

```dart
void f() {
  var e = [!.a!];
  print(e);
}

enum E {a, b}
```

## Common fixes

If you want to use a dot shorthand, then add a context type, which in this
example means adding the explicit type `E` to the local variable:

```dart
void f() {
  E e = .a;
  print(e);
}

enum E {a, b}
```

If you don't want to add a context type, then specify the name of the
type containing the member being referenced, which in this case is `E`:

```dart
void f() {
  var e = E.a;
  print(e);
}

enum E {a, b}
```
