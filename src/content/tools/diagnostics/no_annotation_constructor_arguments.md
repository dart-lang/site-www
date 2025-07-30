---
title: no_annotation_constructor_arguments
description: >-
  Details about the no_annotation_constructor_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Annotation creation must have arguments._

## Description

The analyzer produces this diagnostic when an annotation consists of a
single identifier, but that identifier is the name of a class rather than a
variable. To create an instance of the class, the identifier must be
followed by an argument list.

## Example

The following code produces this diagnostic because `C` is a class, and a
class can't be used as an annotation without invoking a `const` constructor
from the class:

```dart
class C {
  const C();
}

[!@C!]
var x;
```

## Common fixes

Add the missing argument list:

```dart
class C {
  const C();
}

@C()
var x;
```
