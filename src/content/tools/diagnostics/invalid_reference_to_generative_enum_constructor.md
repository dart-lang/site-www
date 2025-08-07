---
title: invalid_reference_to_generative_enum_constructor
description: >-
  Details about the invalid_reference_to_generative_enum_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Generative enum constructors can only be used as targets of redirection._

## Description

The analyzer produces this diagnostic when a generative constructor
defined on an enum is used anywhere other than to create one of the enum
constants or as the target of a redirection from another constructor in
the same enum.

## Example

The following code produces this diagnostic because the constructor for
`E` is being used to create an instance in the function `f`:

```dart
enum E {
  a(0);

  const E(int x);
}

E f() => const [!E!](2);
```

## Common fixes

If there's an enum value with the same value, or if you add such a
constant, then reference the constant directly:

```dart
enum E {
  a(0), b(2);

  const E(int x);
}

E f() => E.b;
```

If you need to use a constructor invocation, then use a factory
constructor:

```dart
enum E {
  a(0);

  const E(int x);

  factory E.c(int x) => a;
}

E f() => E.c(2);
```
