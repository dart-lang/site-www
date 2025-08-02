---
title: dot_shorthand_undefined_member
description: >-
  Details about the dot_shorthand_undefined_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The static getter '{0}' isn't defined for the context type '{1}'._

_The static method or constructor '{0}' isn't defined for the context type
'{1}'._

## Description

The analyzer produces this diagnostic when a dot shorthand is used to
reference a member, but that member doesn't exist.

## Example

The following code produces this diagnostic because the enum `E` doesn't
define a static member named `c`:

```dart
void f() {
  E e = .[!c!];
  print(e);
}

enum E {a, b}
```

## Common fixes

If the name is correct, then define a member with that name in the context
type, which in this case is the enum `E`:

```dart
void f() {
  E e = .c;
  print(e);
}

enum E {a, b, c}
```

If the name is not correct, then replace the name with the name of an
existing member from the context type, which in this case is the enum `E`:

```dart
void f() {
  E e = .b;
  print(e);
}

enum E {a, b}
```
