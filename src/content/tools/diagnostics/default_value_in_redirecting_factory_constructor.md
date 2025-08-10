---
title: default_value_in_redirecting_factory_constructor
description: >-
  Details about the default_value_in_redirecting_factory_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Default values aren't allowed in factory constructors that redirect to another
constructor._

## Description

The analyzer produces this diagnostic when a factory constructor that
redirects to another constructor specifies a default value for an optional
parameter.

## Example

The following code produces this diagnostic because the factory constructor
in `A` has a default value for the optional parameter `x`:

```dart
class A {
  factory A([int [!x!] = 0]) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```

## Common fixes

Remove the default value from the factory constructor:

```dart
class A {
  factory A([int x]) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```

Note that this fix might change the value used when the optional parameter
is omitted. If that happens, and if that change is a problem, then consider
making the optional parameter a required parameter in the factory method:

```dart
class A {
 factory A(int x) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```
