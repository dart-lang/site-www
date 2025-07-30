---
title: extension_type_implements_disallowed_type
description: >-
  Details about the extension_type_implements_disallowed_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Extension types can't implement '{0}'._

## Description

The analyzer produces this diagnostic when an extension type implements a
type that it isn't allowed to implement.

## Example

The following code produces this diagnostic because extension types can't
implement the type `dynamic`:

```dart
extension type A(int i) implements [!dynamic!] {}
```

## Common fixes

Remove the disallowed type from the implements clause:

```dart
extension type A(int i) {}
```
