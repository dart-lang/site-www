---
title: non_sync_factory
description: >-
  Details about the non_sync_factory
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Factory bodies can't use 'async', 'async*', or 'sync*'._

## Description

The analyzer produces this diagnostic when the body of a factory
constructor is marked with `async`, `async*`, or `sync*`. All constructors,
including factory constructors, are required to return an instance of the
class in which they're declared, not a `Future`, `Stream`, or `Iterator`.

## Example

The following code produces this diagnostic because the body of the factory
constructor is marked with `async`:

```dart
class C {
  factory C() [!async!] {
    return C._();
  }
  C._();
}
```

## Common fixes

If the member must be declared as a factory constructor, then remove the
keyword appearing before the body:

```dart
class C {
  factory C() {
    return C._();
  }
  C._();
}
```

If the member must return something other than an instance of the enclosing
class, then make the member a static method:

```dart
class C {
  static Future<C> m() async {
    return C._();
  }
  C._();
}
```
