---
title: optional_parameter_in_operator
description: >-
  Details about the optional_parameter_in_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Optional parameters aren't allowed when defining an operator._

## Description

The analyzer produces this diagnostic when one or more of the parameters in
an operator declaration are optional.

## Example

The following code produces this diagnostic because the parameter `other`
is an optional parameter:

```dart
class C {
  C operator +([[!C? other!]]) => this;
}
```

## Common fixes

Make all of the parameters be required parameters:

```dart
class C {
  C operator +(C other) => this;
}
```
