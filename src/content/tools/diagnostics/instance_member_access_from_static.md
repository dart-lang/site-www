---
title: instance_member_access_from_static
description: >-
  Details about the instance_member_access_from_static
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Instance members can't be accessed from a static method._

## Description

The analyzer produces this diagnostic when a static method contains an
unqualified reference to an instance member.

## Example

The following code produces this diagnostic because the instance field `x`
is being referenced in a static method:

```dart
class C {
  int x = 0;

  static int m() {
    return [!x!];
  }
}
```

## Common fixes

If the method must reference the instance member, then it can't be static,
so remove the keyword:

```dart
class C {
  int x = 0;

  int m() {
    return x;
  }
}
```

If the method can't be made an instance method, then add a parameter so
that an instance of the class can be passed in:

```dart
class C {
  int x = 0;

  static int m(C c) {
    return c.x;
  }
}
```
