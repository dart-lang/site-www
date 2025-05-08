---
title: built_in_identifier_in_declaration
description: >-
  Details about the built_in_identifier_in_declaration
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The built-in identifier '{0}' can't be used as a prefix name._

_The built-in identifier '{0}' can't be used as a type name._

_The built-in identifier '{0}' can't be used as a type parameter name._

_The built-in identifier '{0}' can't be used as a typedef name._

_The built-in identifier '{0}' can't be used as an extension name._

_The built-in identifier '{0}' can't be used as an extension type name._

## Description

The analyzer produces this diagnostic when the name used in the declaration
of a class, extension, mixin, typedef, type parameter, or import prefix is
a built-in identifier. Built-in identifiers can't be used to name any of
these kinds of declarations.

## Example

The following code produces this diagnostic because `mixin` is a built-in
identifier:

```dart
extension [!mixin!] on int {}
```

## Common fixes

Choose a different name for the declaration.
