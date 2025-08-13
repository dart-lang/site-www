---
title: redirect_generative_to_non_generative_constructor
description: >-
  Details about the redirect_generative_to_non_generative_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Generative constructors can't redirect to a factory constructor._

## Description

The analyzer produces this diagnostic when a generative constructor
redirects to a factory constructor.

## Example

The following code produces this diagnostic because the generative
constructor `C.a` redirects to the factory constructor `C.b`:

```dart
class C {
  C.a() : [!this.b()!];
  factory C.b() => C.a();
}
```

## Common fixes

If the generative constructor doesn't need to redirect to another
constructor, then remove the redirect.

```dart
class C {
  C.a();
  factory C.b() => C.a();
}
```

If the generative constructor must redirect to another constructor, then
make the other constructor be a generative (non-factory) constructor:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```
