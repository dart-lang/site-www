---
title: unqualified_reference_to_static_member_of_extended_type
description: >-
  Details about the unqualified_reference_to_static_member_of_extended_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Static members from the extended type or one of its superclasses must be
qualified by the name of the defining type._

## Description

The analyzer produces this diagnostic when an undefined name is found, and
the name is the same as a static member of the extended type or one of its
superclasses.

## Example

The following code produces this diagnostic because `m` is a static member
of the extended type `C`:

```dart
class C {
  static void m() {}
}

extension E on C {
  void f() {
    [!m!]();
  }
}
```

## Common fixes

If you're trying to reference a static member that's declared outside the
extension, then add the name of the class or extension before the reference
to the member:

```dart
class C {
  static void m() {}
}

extension E on C {
  void f() {
    C.m();
  }
}
```

If you're referencing a member that isn't declared yet, add a declaration:

```dart
class C {
  static void m() {}
}

extension E on C {
  void f() {
    m();
  }

  void m() {}
}
```
