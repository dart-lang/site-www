---
title: prefix_shadowed_by_local_declaration
description: >-
  Details about the prefix_shadowed_by_local_declaration
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The prefix '{0}' can't be used here because it's shadowed by a local
declaration._

## Description

The analyzer produces this diagnostic when an import prefix is used in a
context where it isn't visible because it was shadowed by a local
declaration.

## Example

The following code produces this diagnostic because the prefix `a` is
being used to access the class `Future`, but isn't visible because it's
shadowed by the parameter `a`:

```dart
import 'dart:async' as a;

a.Future? f(int a) {
  [!a!].Future? x;
  return x;
}
```

## Common fixes

Rename either the prefix:

```dart
import 'dart:async' as p;

p.Future? f(int a) {
  p.Future? x;
  return x;
}
```

Or rename the local variable:

```dart
import 'dart:async' as a;

a.Future? f(int p) {
  a.Future? x;
  return x;
}
```
