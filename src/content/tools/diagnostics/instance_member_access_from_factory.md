---
title: instance_member_access_from_factory
description: >-
  Details about the instance_member_access_from_factory
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Instance members can't be accessed from a factory constructor._

## Description

The analyzer produces this diagnostic when a factory constructor contains
an unqualified reference to an instance member. In a generative
constructor, the instance of the class is created and initialized before
the body of the constructor is executed, so the instance can be bound to
`this` and accessed just like it would be in an instance method. But, in a
factory constructor, the instance isn't created before executing the body,
so `this` can't be used to reference it.

## Example

The following code produces this diagnostic because `x` isn't in scope in
the factory constructor:

```dart
class C {
  int x;
  factory C() {
    return C._([!x!]);
  }
  C._(this.x);
}
```

## Common fixes

Rewrite the code so that it doesn't reference the instance member:

```dart
class C {
  int x;
  factory C() {
    return C._(0);
  }
  C._(this.x);
}
```
