---
title: enum_mixin_with_instance_variable
description: >-
  Details about the enum_mixin_with_instance_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Mixins applied to enums can't have instance variables._

## Description

The analyzer produces this diagnostic when a mixin that's applied to an
enum declares one or more instance variables. This isn't allowed because
the enum values are constant, and there isn't any way for the constructor
in the enum to initialize any of the mixin's fields.

## Example

The following code produces this diagnostic because the mixin `M` defines
the instance field `x`:

```dart
mixin M {
  int x = 0;
}

enum E with [!M!] {
  a
}
```

## Common fixes

If you need to apply the mixin, then change all instance fields into
getter and setter pairs and implement them in the enum if necessary:

```dart
mixin M {
  int get x => 0;
}

enum E with M {
  a
}
```

If you don't need to apply the mixin, then remove it:

```dart
enum E {
  a
}
```
