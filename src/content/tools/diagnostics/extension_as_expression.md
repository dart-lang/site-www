---
title: extension_as_expression
description: >-
  Details about the extension_as_expression
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Extension '{0}' can't be used as an expression._

## Description

The analyzer produces this diagnostic when the name of an extension is used
in an expression other than in an extension override or to qualify an
access to a static member of the extension. Because classes define a type,
the name of a class can be used to refer to the instance of `Type`
representing the type of the class. Extensions, on the other hand, don't
define a type and can't be used as a type literal.

## Example

The following code produces this diagnostic because `E` is an extension:

```dart
extension E on int {
  static String m() => '';
}

var x = [!E!];
```

## Common fixes

Replace the name of the extension with a name that can be referenced, such
as a static member defined on the extension:

```dart
extension E on int {
  static String m() => '';
}

var x = E.m();
```
