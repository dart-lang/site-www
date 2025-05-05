---
title: undefined_extension_operator
description: >-
  Details about the undefined_extension_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The operator '{0}' isn't defined for the extension '{1}'._

## Description

The analyzer produces this diagnostic when an operator is invoked on a
specific extension when that extension doesn't implement the operator.

## Example

The following code produces this diagnostic because the extension `E`
doesn't define the operator `*`:

```dart
var x = E('') [!*!] 4;

extension E on String {}
```

## Common fixes

If the extension is expected to implement the operator, then add an
implementation of the operator to the extension:

```dart
var x = E('') * 4;

extension E on String {
  int operator *(int multiplier) => length * multiplier;
}
```

If the operator is defined by a different extension, then change the name
of the extension to the name of the one that defines the operator.

If the operator is defined on the argument of the extension override, then
remove the extension override:

```dart
var x = '' * 4;

extension E on String {}
```
