---
title: prefer_constructors_over_static_methods
description: >-
  Details about the prefer_constructors_over_static_methods
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_constructors_over_static_methods"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Static method should be a constructor._

## Description

The analyzer produces this diagnostic when a static method returns a newly
created instance of the class and could, therefore, be a constructor.

## Example

The following code produces this diagnostic because the static method
`all` could be a constructor:

```dart
class C {
  final int a, b, c;
  C(this.a, this.b, this.c);
  static C [!all!](int i) => C(i, i, i);
}
```

## Common fixes

Convert the static method to a named constructor:

```dart
class C {
  final int a, b, c;
  C(this.a, this.b, this.c);
  C.all(int i) : a = i, b = i, c = i;
}
```
