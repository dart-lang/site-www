---
title: referenced_before_declaration
description: >-
  Details about the referenced_before_declaration
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Local variable '{0}' can't be referenced before it is declared._

## Description

The analyzer produces this diagnostic when a variable is referenced before
it's declared. In Dart, variables are visible everywhere in the block in
which they are declared, but can only be referenced after they are
declared.

The analyzer also produces a context message that indicates where the
declaration is located.

## Example

The following code produces this diagnostic because `i` is used before it
is declared:

```dart
void f() {
  print([!i!]);
  int i = 5;
}
```

## Common fixes

If you intended to reference the local variable, move the declaration
before the first reference:

```dart
void f() {
  int i = 5;
  print(i);
}
```

If you intended to reference a name from an outer scope, such as a
parameter, instance field or top-level variable, then rename the local
declaration so that it doesn't hide the outer variable.

```dart
void f(int i) {
  print(i);
  int x = 5;
  print(x);
}
```
