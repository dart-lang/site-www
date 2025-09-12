---
title: tearoff_of_generative_constructor_of_abstract_class
description: >-
  Details about the tearoff_of_generative_constructor_of_abstract_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A generative constructor of an abstract class can't be torn off._

## Description

The analyzer produces this diagnostic when a generative constructor from an
abstract class is being torn off. This isn't allowed because it isn't valid
to create an instance of an abstract class, which means that there isn't
any valid use for the torn off constructor.

## Example

The following code produces this diagnostic because the constructor `C.new`
is being torn off and the class `C` is an abstract class:

```dart
abstract class C {
  C();
}

void f() {
  [!C.new!];
}
```

## Common fixes

Tear off the constructor of a concrete class.
