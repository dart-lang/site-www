---
title: initializer_for_static_field
description: >-
  Details about the initializer_for_static_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_'{0}' is a static field in the enclosing class. Fields initialized in a
constructor can't be static._

## Description

The analyzer produces this diagnostic when a static field is initialized
in a constructor using either an initializing formal parameter or an
assignment in the initializer list.

## Example

The following code produces this diagnostic because the static field `a`
is being initialized by the initializing formal parameter `this.a`:

```dart
class C {
  static int? a;
  C([!this.a!]);
}
```

## Common fixes

If the field should be an instance field, then remove the keyword `static`:

```dart
class C {
  int? a;
  C(this.a);
}
```

If you intended to initialize an instance field and typed the wrong name,
then correct the name of the field being initialized:

```dart
class C {
  static int? a;
  int? b;
  C(this.b);
}
```

If you really want to initialize the static field, then move the
initialization into the constructor body:

```dart
class C {
  static int? a;
  C(int? c) {
    a = c;
  }
}
```
