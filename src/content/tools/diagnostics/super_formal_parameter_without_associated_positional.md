---
title: super_formal_parameter_without_associated_positional
description: >-
  Details about the super_formal_parameter_without_associated_positional
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_No associated positional super constructor parameter._

## Description

The analyzer produces this diagnostic when there's a positional super
parameter in a constructor and the implicitly or explicitly invoked super
constructor doesn't have a positional parameter at the corresponding
index.

Positional super parameters are associated with positional parameters in
the super constructor by their index. That is, the first super parameter
is associated with the first positional parameter in the super
constructor, the second with the second, and so on.

## Examples

The following code produces this diagnostic because the constructor in `B`
has a positional super parameter, but there's no positional parameter in
the super constructor in `A`:

```dart
class A {
  A({int? x});
}

class B extends A {
  B(super.[!x!]);
}
```

The following code produces this diagnostic because the constructor in `B`
has two positional super parameters, but there's only one positional
parameter in the super constructor in `A`, which means that there's no
corresponding parameter for `y`:

```dart
class A {
  A(int x);
}

class B extends A {
  B(super.x, super.[!y!]);
}
```

## Common fixes

If the super constructor should have a positional parameter corresponding
to the super parameter, then update the super constructor appropriately:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(super.x, super.y);
}
```

If the super constructor is correct, or can't be changed, then convert the
super parameter into a normal parameter:

```dart
class A {
  A(int x);
}

class B extends A {
  B(super.x, int y);
}
```
