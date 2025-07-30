---
title: multiple_redirecting_constructor_invocations
description: >-
  Details about the multiple_redirecting_constructor_invocations
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Constructors can have only one 'this' redirection, at most._

## Description

The analyzer produces this diagnostic when a constructor redirects to more
than one other constructor in the same class (using `this`).

## Example

The following code produces this diagnostic because the unnamed
constructor in `C` is redirecting to both `this.a` and `this.b`:

```dart
class C {
  C() : this.a(), [!this.b()!];
  C.a();
  C.b();
}
```

## Common fixes

Remove all but one of the redirections:

```dart
class C {
  C() : this.a();
  C.a();
  C.b();
}
```
