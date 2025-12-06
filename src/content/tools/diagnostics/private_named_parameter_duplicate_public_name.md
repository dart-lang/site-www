---
title: private_named_parameter_duplicate_public_name
description: >-
  Details about the private_named_parameter_duplicate_public_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The corresponding public name '{0}' is already the name of another parameter._

## Description

The analyzer produces this diagnostic when a private named parameter
(leading `_`) has a corresponding public name that conflicts with an
existing parameter name in the same parameter list.

## Example

The following code produces this diagnostic because the private named
parameter `_x`'s public name is `x`, which conflicts with the existing
parameter named `x`:

```dart
class C {
  int? _x;
  C({int? x, this.[!_x!]});
  int? get x => _x;
}
```

## Common fixes

Rename one of the two parameters.
