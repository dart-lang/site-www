---
title: invocation_of_extension_without_call
description: >-
  Details about the invocation_of_extension_without_call
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The extension '{0}' doesn't define a 'call' method so the override can't be used in an invocation._

## Description

The analyzer produces this diagnostic when an extension override is used to
invoke a function but the extension doesn't declare a `call` method.

## Example

The following code produces this diagnostic because the extension `E`
doesn't define a `call` method:

```dart
extension E on String {}

void f() {
  [!E('')!]();
}
```

## Common fixes

If the extension is intended to define a `call` method, then declare it:

```dart
extension E on String {
  int call() => 0;
}

void f() {
  E('')();
}
```

If the extended type defines a `call` method, then remove the extension
override.

If the `call` method isn't defined, then rewrite the code so that it
doesn't invoke the `call` method.
