---
title: extension_override_argument_not_assignable
description: >-
  Details about the extension_override_argument_not_assignable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The type of the argument to the extension override '{0}' isn't assignable to
the extended type '{1}'._

## Description

The analyzer produces this diagnostic when the argument to an extension
override isn't assignable to the type being extended by the extension.

## Example

The following code produces this diagnostic because `3` isn't a `String`:

```dart
extension E on String {
  void method() {}
}

void f() {
  E([!3!]).method();
}
```

## Common fixes

If you're using the correct extension, then update the argument to have the
correct type:

```dart
extension E on String {
  void method() {}
}

void f() {
  E(3.toString()).method();
}
```

If there's a different extension that's valid for the type of the argument,
then either replace the name of the extension or unwrap the argument so
that the correct extension is found.
