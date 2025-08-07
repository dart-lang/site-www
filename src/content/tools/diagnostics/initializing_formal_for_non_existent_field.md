---
title: initializing_formal_for_non_existent_field
description: >-
  Details about the initializing_formal_for_non_existent_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_'{0}' isn't a field in the enclosing class._

## Description

The analyzer produces this diagnostic when an initializing formal
parameter is found in a constructor in a class that doesn't declare the
field being initialized. Constructors can't initialize fields that aren't
declared and fields that are inherited from superclasses.

## Example

The following code produces this diagnostic because the field `x` isn't
defined:

```dart
class C {
  int? y;

  C([!this.x!]);
}
```

## Common fixes

If the field name was wrong, then change it to the name of an existing
field:

```dart
class C {
  int? y;

  C(this.y);
}
```

If the field name is correct but hasn't yet been defined, then declare the
field:

```dart
class C {
  int? x;
  int? y;

  C(this.x);
}
```

If the parameter is needed but shouldn't initialize a field, then convert
it to a normal parameter and use it:

```dart
class C {
  int y;

  C(int x) : y = x * 2;
}
```

If the parameter isn't needed, then remove it:

```dart
class C {
  int? y;

  C();
}
```
