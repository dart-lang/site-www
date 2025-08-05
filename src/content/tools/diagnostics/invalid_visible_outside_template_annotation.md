---
title: invalid_visible_outside_template_annotation
description: >-
  Details about the invalid_visible_outside_template_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The annotation 'visibleOutsideTemplate' can only be applied to a member of a class, enum, or mixin that is annotated with 'visibleForTemplate'._

## Description

The analyzer produces this diagnostic when the `@visibleOutsideTemplate`
annotation is used incorrectly. This annotation is only meant to annotate
members of a class, enum, or mixin that has the `@visibleForTemplate`
annotation, to opt those members out of the visibility restrictions that
`@visibleForTemplate` imposes.

## Examples

The following code produces this diagnostic because there is no
`@visibleForTemplate` annotation at the class level:

```dart
import 'package:angular_meta/angular_meta.dart';

class C {
  @[!visibleOutsideTemplate!]
  int m() {
    return 1;
  }
}
```

The following code produces this diagnostic because the annotation is on
a class declaration, not a member of a class, enum, or mixin:

```dart
import 'package:angular_meta/angular_meta.dart';

@[!visibleOutsideTemplate!]
class C {}
```

## Common fixes

If the class is only visible so that templates can reference it, then add
the `@visibleForTemplate` annotation to the class:

```dart
import 'package:angular_meta/angular_meta.dart';

@visibleForTemplate
class C {
  @visibleOutsideTemplate
  int m() {
    return 1;
  }
}
```

If the `@visibleOutsideTemplate` annotation is on anything other than a
member of a class, enum, or mixin with the `@visibleForTemplate`
annotation, remove the annotation:

```dart
class C {}
```
