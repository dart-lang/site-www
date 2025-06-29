---
title: final_not_initialized
description: >-
  Details about the final_not_initialized
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The final variable '{0}' must be initialized._

## Description

The analyzer produces this diagnostic when a final field or variable isn't
initialized.

## Example

The following code produces this diagnostic because `x` doesn't have an
initializer:

```dart
final [!x!];
```

## Common fixes

For variables and static fields, you can add an initializer:

```dart
final x = 0;
```

For instance fields, you can add an initializer as shown in the previous
example, or you can initialize the field in every constructor. You can
initialize the field by using an initializing formal parameter:

```dart
class C {
  final int x;
  C(this.x);
}
```

You can also initialize the field by using an initializer in the
constructor:

```dart
class C {
  final int x;
  C(int y) : x = y * 2;
}
```
