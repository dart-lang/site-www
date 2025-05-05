---
title: mixin_application_concrete_super_invoked_member_type
description: >-
  Details about the mixin_application_concrete_super_invoked_member_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The super-invoked member '{0}' has the type '{1}', and the concrete member in
the class has the type '{2}'._

## Description

The analyzer produces this diagnostic when a mixin that invokes a method
using `super` is used in a class where the concrete implementation of that
method has a different signature than the signature defined for that method
by the mixin's `on` type. The reason this is an error is because the
invocation in the mixin might invoke the method in a way that's
incompatible with the method that will actually be executed.

## Example

The following code produces this diagnostic because the class `C` uses the
mixin `M`, the mixin `M` invokes `foo` using `super`, and the abstract
version of `foo` declared in `I` (the mixin's `on` type) doesn't have the
same signature as the concrete version of `foo` declared in `A`:

```dart
class I {
  void foo([int? p]) {}
}

class A {
  void foo(int p) {}
}

abstract class B extends A implements I {
  @override
  void foo([int? p]);
}

mixin M on I {
  void bar() {
    super.foo(42);
  }
}

abstract class C extends B with [!M!] {}
```

## Common fixes

If the class doesn't need to use the mixin, then remove it from the `with`
clause:

```dart
class I {
  void foo([int? p]) {}
}

class A {
  void foo(int? p) {}
}

abstract class B extends A implements I {
  @override
  void foo([int? p]);
}

mixin M on I {
  void bar() {
    super.foo(42);
  }
}

abstract class C extends B {}
```

If the class needs to use the mixin, then ensure that there's a concrete
implementation of the method that conforms to the signature expected by the
mixin:

```dart
class I {
  void foo([int? p]) {}
}

class A {
  void foo(int? p) {}
}

abstract class B extends A implements I {
  @override
  void foo([int? p]) {
    super.foo(p);
  }
}

mixin M on I {
  void bar() {
    super.foo(42);
  }
}

abstract class C extends B with M {}
```
