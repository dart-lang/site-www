---
title: redirect_generative_to_missing_constructor
description: >-
  Details about the redirect_generative_to_missing_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The constructor '{0}' couldn't be found in '{1}'._

## Description

The analyzer produces this diagnostic when a generative constructor
redirects to a constructor that isn't defined.

## Example

The following code produces this diagnostic because the constructor `C.a`
redirects to the constructor `C.b`, but `C.b` isn't defined:

```dart
class C {
  C.a() : [!this.b()!];
}
```

## Common fixes

If the missing constructor must be called, then define it:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```

If the missing constructor doesn't need to be called, then remove the
redirect:

```dart
class C {
  C.a();
}
```
