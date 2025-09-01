---
title: invalid_modifier_on_constructor
description: >-
  Details about the invalid_modifier_on_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The modifier '{0}' can't be applied to the body of a constructor._

## Description

The analyzer produces this diagnostic when the body of a constructor is
prefixed by one of the following modifiers: `async`, `async*`, or `sync*`.
Constructor bodies must be synchronous.

## Example

The following code produces this diagnostic because the body of the
constructor for `C` is marked as being `async`:

```dart
class C {
  C() [!async!] {}
}
```

## Common fixes

If the constructor can be synchronous, then remove the modifier:

```dart
class C {
  C();
}
```

If the constructor can't be synchronous, then use a static method to create
the instance instead:

```dart
class C {
  C();
  static Future<C> c() async {
    return C();
  }
}
```
