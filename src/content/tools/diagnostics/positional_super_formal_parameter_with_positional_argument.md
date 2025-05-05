---
title: positional_super_formal_parameter_with_positional_argument
description: >-
  Details about the positional_super_formal_parameter_with_positional_argument
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Positional super parameters can't be used when the super constructor invocation
has a positional argument._

## Description

The analyzer produces this diagnostic when some, but not all, of the
positional parameters provided to the constructor of the superclass are
using a super parameter.

Positional super parameters are associated with positional parameters in
the super constructor by their index. That is, the first super parameter
is associated with the first positional parameter in the super
constructor, the second with the second, and so on. The same is true for
positional arguments. Having both positional super parameters and
positional arguments means that there are two values associated with the
same parameter in the superclass's constructor, and hence isn't allowed.

## Example

The following code produces this diagnostic because the constructor
`B.new` is using a super parameter to pass one of the required positional
parameters to the super constructor in `A`, but is explicitly passing the
other in the super constructor invocation:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(int x, super.[!y!]) : super(x);
}
```

## Common fixes

If all the positional parameters can be super parameters, then convert the
normal positional parameters to be super parameters:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(super.x, super.y);
}
```

If some positional parameters can't be super parameters, then convert the
super parameters to be normal parameters:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(int x, int y) : super(x, y);
}
```
