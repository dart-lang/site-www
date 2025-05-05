---
title: multiple_super_initializers
description: >-
  Details about the multiple_super_initializers
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_A constructor can have at most one 'super' initializer._

## Description

The analyzer produces this diagnostic when the initializer list of a
constructor contains more than one invocation of a constructor from the
superclass. The initializer list is required to have exactly one such call,
which can either be explicit or implicit.

## Example

The following code produces this diagnostic because the initializer list
for `B`'s constructor invokes both the constructor `one` and the
constructor `two` from the superclass `A`:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
}

class B extends A {
  B() : super.one(0), [!super.two('')!];
}
```

## Common fixes

If one of the super constructors will initialize the instance fully, then
remove the other:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
}

class B extends A {
  B() : super.one(0);
}
```

If the initialization achieved by one of the super constructors can be
performed in the body of the constructor, then remove its super invocation
and perform the initialization in the body:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
}

class B extends A {
  B() : super.one(0) {
    s = '';
  }
}
```

If the initialization can only be performed in a constructor in the
superclass, then either add a new constructor or modify one of the existing
constructors so there's a constructor that allows all the required
initialization to occur in a single call:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
  A.three(this.x, this.s);
}

class B extends A {
  B() : super.three(0, '');
}
```
