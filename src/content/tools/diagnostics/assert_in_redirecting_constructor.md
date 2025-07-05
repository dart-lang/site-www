---
title: assert_in_redirecting_constructor
description: >-
  Details about the assert_in_redirecting_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_A redirecting constructor can't have an 'assert' initializer._

## Description

The analyzer produces this diagnostic when a redirecting constructor (a
constructor that redirects to another constructor in the same class) has an
assert in the initializer list.

## Example

The following code produces this diagnostic because the unnamed constructor
is a redirecting constructor and also has an assert in the initializer
list:

```dart
class C {
  C(int x) : [!assert(x > 0)!], this.name();
  C.name() {}
}
```

## Common fixes

If the assert isn't needed, then remove it:

```dart
class C {
  C(int x) : this.name();
  C.name() {}
}
```

If the assert is needed, then convert the constructor into a factory
constructor:

```dart
class C {
  factory C(int x) {
    assert(x > 0);
    return C.name();
  }
  C.name() {}
}
```
