---
title: non_constant_annotation_constructor
description: >-
  Details about the non_constant_annotation_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Annotation creation can only call a const constructor._

## Description

The analyzer produces this diagnostic when an annotation is the invocation
of an existing constructor even though the invoked constructor isn't a
const constructor.

## Example

The following code produces this diagnostic because the constructor for `C`
isn't a const constructor:

```dart
[!@C()!]
void f() {
}

class C {
  C();
}
```

## Common fixes

If it's valid for the class to have a const constructor, then create a
const constructor that can be used for the annotation:

```dart
@C()
void f() {
}

class C {
  const C();
}
```

If it isn't valid for the class to have a const constructor, then either
remove the annotation or use a different class for the annotation.
