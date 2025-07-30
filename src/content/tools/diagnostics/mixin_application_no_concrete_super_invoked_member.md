---
title: mixin_application_no_concrete_super_invoked_member
description: >-
  Details about the mixin_application_no_concrete_super_invoked_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The class doesn't have a concrete implementation of the super-invoked member
'{0}'._

_The class doesn't have a concrete implementation of the super-invoked setter
'{0}'._

## Description

The analyzer produces this diagnostic when a [mixin application][] contains
an invocation of a member from its superclass, and there's no concrete
member of that name in the mixin application's superclass.

## Example

The following code produces this diagnostic because the mixin `M` contains
the invocation `super.m()`, and the class `A`, which is the superclass of
the [mixin application][] `A+M`, doesn't define a concrete implementation
of `m`:

```dart
abstract class A {
  void m();
}

mixin M on A {
  void bar() {
    super.m();
  }
}

abstract class B extends A with [!M!] {}
```

## Common fixes

If you intended to apply the mixin `M` to a different class, one that has a
concrete implementation of `m`, then change the superclass of `B` to that
class:

```dart
abstract class A {
  void m();
}

mixin M on A {
  void bar() {
    super.m();
  }
}

class C implements A {
  void m() {}
}

abstract class B extends C with M {}
```

If you need to make `B` a subclass of `A`, then add a concrete
implementation of `m` in `A`:

```dart
abstract class A {
  void m() {}
}

mixin M on A {
  void bar() {
    super.m();
  }
}

abstract class B extends A with M {}
```

[mixin application]: /resources/glossary#mixin-application
