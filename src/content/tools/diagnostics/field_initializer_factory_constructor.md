---
title: field_initializer_factory_constructor
description: >-
  Details about the field_initializer_factory_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Initializing formal parameters can't be used in factory constructors._

## Description

The analyzer produces this diagnostic when a factory constructor has an
initializing formal parameter. Factory constructors can't assign values to
fields because no instance is created; hence, there is no field to assign.

## Example

The following code produces this diagnostic because the factory constructor
uses an initializing formal parameter:

```dart
class C {
  int? f;

  factory C([!this.f!]) => throw 0;
}
```

## Common fixes

Replace the initializing formal parameter with a normal parameter:

```dart
class C {
  int? f;

  factory C(int f) => throw 0;
}
```
