---
title: undefined_super_member
description: >-
  Details about the undefined_super_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_(Previously known as `undefined_super_method`)_

_The getter '{0}' isn't defined in a superclass of '{1}'._

_The method '{0}' isn't defined in a superclass of '{1}'._

_The operator '{0}' isn't defined in a superclass of '{1}'._

_The setter '{0}' isn't defined in a superclass of '{1}'._

## Description

The analyzer produces this diagnostic when an inherited member (method,
getter, setter, or operator) is referenced using `super`, but there's no
member with that name in the superclass chain.

## Examples

The following code produces this diagnostic because `Object` doesn't define
a method named `n`:

```dart
class C {
  void m() {
    super.[!n!]();
  }
}
```

The following code produces this diagnostic because `Object` doesn't define
a getter named `g`:

```dart
class C {
  void m() {
    super.[!g!];
  }
}
```

## Common fixes

If the inherited member you intend to invoke has a different name, then
make the name of the invoked member match the inherited member.

If the member you intend to invoke is defined in the same class, then
remove the `super.`.

If the member isn't defined, then either add the member to one of the
superclasses or remove the invocation.
