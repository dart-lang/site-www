---
title: final_not_initialized_constructor
description: >-
  Details about the final_not_initialized_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_All final variables must be initialized, but '{0}' and '{1}' aren't._

_All final variables must be initialized, but '{0}' isn't._

_All final variables must be initialized, but '{0}', '{1}', and {2} others aren't._

## Description

The analyzer produces this diagnostic when a class defines one or more
final instance fields without initializers and has at least one constructor
that doesn't initialize those fields. All final instance fields must be
initialized when the instance is created, either by the field's initializer
or by the constructor.

## Example

The following code produces this diagnostic:

```dart
class C {
  final String value;

  [!C!]();
}
```

## Common fixes

If the value should be passed in to the constructor directly, then use an
initializing formal parameter to initialize the field `value`:

```dart
class C {
  final String value;

  C(this.value);
}
```

If the value should be computed indirectly from a value provided by the
caller, then add a parameter and include an initializer:

```dart
class C {
  final String value;

  C(Object o) : value = o.toString();
}
```

If the value of the field doesn't depend on values that can be passed to
the constructor, then add an initializer for the field as part of the field
declaration:

```dart
class C {
  final String value = '';

  C();
}
```

If the value of the field doesn't depend on values that can be passed to
the constructor but different constructors need to initialize it to
different values, then add an initializer for the field in the initializer
list:

```dart
class C {
  final String value;

  C() : value = '';

  C.named() : value = 'c';
}
```

However, if the value is the same for all instances, then consider using a
static field instead of an instance field:

```dart
class C {
  static const String value = '';

  C();
}
```
