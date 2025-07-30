---
title: unused_field
description: >-
  Details about the unused_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The value of the field '{0}' isn't used._

## Description

The analyzer produces this diagnostic when a private field is declared but
never read, even if it's written in one or more places.

## Example

The following code produces this diagnostic because the field
`_originalValue` isn't read anywhere in the library:

```dart
class C {
  final String [!_originalValue!];
  final String _currentValue;

  C(this._originalValue) : _currentValue = _originalValue;

  String get value => _currentValue;
}
```

It might appear that the field `_originalValue` is being read in the
initializer (`_currentValue = _originalValue`), but that is actually a
reference to the parameter of the same name, not a reference to the field.

## Common fixes

If the field isn't needed, then remove it.

If the field was intended to be used, then add the missing code.
