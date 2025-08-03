---
title: field_initialized_in_parameter_and_initializer
description: >-
  Details about the field_initialized_in_parameter_and_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Fields can't be initialized in both the parameter list and the initializers._

## Description

The analyzer produces this diagnostic when a field is initialized in both
the parameter list and in the initializer list of a constructor.

## Example

The following code produces this diagnostic because the field `f` is
initialized both by an initializing formal parameter and in the
initializer list:

```dart
class C {
  int f;

  C(this.f) : [!f!] = 0;
}
```

## Common fixes

If the field should be initialized by the parameter, then remove the
initialization in the initializer list:

```dart
class C {
  int f;

  C(this.f);
}
```

If the field should be initialized in the initializer list and the
parameter isn't needed, then remove the parameter:

```dart
class C {
  int f;

  C() : f = 0;
}
```

If the field should be initialized in the initializer list and the
parameter is needed, then make it a normal parameter:

```dart
class C {
  int f;

  C(int g) : f = g * 2;
}
```
