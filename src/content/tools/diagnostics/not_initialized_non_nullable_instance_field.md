---
title: not_initialized_non_nullable_instance_field
description: >-
  Details about the not_initialized_non_nullable_instance_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Non-nullable instance field '{0}' must be initialized._

## Description

The analyzer produces this diagnostic when a field is declared and has all
these characteristics:
- Has a type that's [potentially non-nullable][]
- Doesn't have an initializer
- Isn't marked as `late`

## Examples

The following code produces this diagnostic because `x` is implicitly
initialized to `null` when it isn't allowed to be `null`:

```dart
class C {
  int [!x!];
}
```

Similarly, the following code produces this diagnostic because `x` is
implicitly initialized to `null`, when it isn't allowed to be `null`, by
one of the constructors, even though it's initialized by other
constructors:

```dart
class C {
  int x;

  C(this.x);

  [!C!].n();
}
```

## Common fixes

If there's a reasonable default value for the field that's the same for all
instances, then add an initializer expression:

```dart
class C {
  int x = 0;
}
```

If the value of the field should be provided when an instance is created,
then add a constructor that sets the value of the field or update an
existing constructor:

```dart
class C {
  int x;

  C(this.x);
}
```

You can also mark the field as `late`, which removes the diagnostic, but if
the field isn't assigned a value before it's accessed, then it results in
an exception being thrown at runtime. This approach should only be used if
you're sure that the field will always be assigned before it's referenced.

```dart
class C {
  late int x;
}
```

[potentially non-nullable]: /resources/glossary#potentially-non-nullable
