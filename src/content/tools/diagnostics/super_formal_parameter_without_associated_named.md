---
title: super_formal_parameter_without_associated_named
description: >-
  Details about the super_formal_parameter_without_associated_named
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_No associated named super constructor parameter._

## Description

The analyzer produces this diagnostic when there's a named super parameter
in a constructor and the implicitly or explicitly invoked super
constructor doesn't have a named parameter with the same name.

Named super parameters are associated by name with named parameters in the
super constructor.

## Example

The following code produces this diagnostic because the constructor in `A`
doesn't have a parameter named `y`:

```dart
class A {
  A({int? x});
}

class B extends A {
  B({super.[!y!]});
}
```

## Common fixes

If the super parameter should be associated with an existing parameter
from the super constructor, then change the name to match the name of the
corresponding parameter:

```dart
class A {
  A({int? x});
}

class B extends A {
  B({super.x});
}
```

If the super parameter should be associated with a parameter that hasn't
yet been added to the super constructor, then add it:

```dart
class A {
  A({int? x, int? y});
}

class B extends A {
  B({super.y});
}
```

If the super parameter doesn't correspond to a named parameter from the
super constructor, then change it to be a normal parameter:

```dart
class A {
  A({int? x});
}

class B extends A {
  B({int? y});
}
```
