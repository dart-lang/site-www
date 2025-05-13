---
title: undefined_named_parameter
description: >-
  Details about the undefined_named_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The named parameter '{0}' isn't defined._

## Description

The analyzer produces this diagnostic when a method or function invocation
has a named argument, but the method or function being invoked doesn't
define a parameter with the same name.

## Example

The following code produces this diagnostic because `m` doesn't declare a
named parameter named `a`:

```dart
class C {
  m({int? b}) {}
}

void f(C c) {
  c.m([!a!]: 1);
}
```

## Common fixes

If the argument name is mistyped, then replace it with the correct name.
The example above can be fixed by changing `a` to `b`:

```dart
class C {
  m({int? b}) {}
}

void f(C c) {
  c.m(b: 1);
}
```

If a subclass adds a parameter with the name in question, then cast the
receiver to the subclass:

```dart
class C {
  m({int? b}) {}
}

class D extends C {
  m({int? a, int? b}) {}
}

void f(C c) {
  (c as D).m(a: 1);
}
```

If the parameter should be added to the function, then add it:

```dart
class C {
  m({int? a, int? b}) {}
}

void f(C c) {
  c.m(a: 1);
}
```
