---
title: invalid_annotation
description: >-
  Details about the invalid_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Annotation must be either a const variable reference or const constructor invocation._

## Description

The analyzer produces this diagnostic when an annotation is found that is
using something that is neither a variable marked as `const` or the
invocation of a `const` constructor.

Getters can't be used as annotations.

## Examples

The following code produces this diagnostic because the variable `v` isn't
a `const` variable:

```dart
var v = 0;

[!@v!]
void f() {
}
```

The following code produces this diagnostic because `f` isn't a variable:

```dart
[!@f!]
void f() {
}
```

The following code produces this diagnostic because `f` isn't a
constructor:

```dart
[!@f()!]
void f() {
}
```

The following code produces this diagnostic because `g` is a getter:

```dart
[!@g!]
int get g => 0;
```

## Common fixes

If the annotation is referencing a variable that isn't a `const`
constructor, add the keyword `const` to the variable's declaration:

```dart
const v = 0;

@v
void f() {
}
```

If the annotation isn't referencing a variable, then remove it:

```dart
int v = 0;

void f() {
}
```
