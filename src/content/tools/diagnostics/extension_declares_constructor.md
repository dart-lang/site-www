---
title: extension_declares_constructor
description: >-
  Details about the extension_declares_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Extensions can't declare constructors._

## Description

The analyzer produces this diagnostic when a constructor declaration is
found in an extension. It isn't valid to define a constructor because
extensions aren't classes, and it isn't possible to create an instance of
an extension.

## Example

The following code produces this diagnostic because there is a constructor
declaration in `E`:

```dart
extension E on String {
  [!E!]() : super();
}
```

## Common fixes

Remove the constructor or replace it with a static method.
