---
title: use_super_parameters
description: >-
  Details about the use_super_parameters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_super_parameters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Parameter '{0}' could be a super parameter._
_Parameters '{0}' could be super parameters._

## Description

The analyzer produces this diagnostic when a parameter to a constructor is
passed to a super constructor without being referenced or modified and a
`super` parameter isn't used.

## Example

The following code produces this diagnostic because the parameters of the
constructor for `B` are only used as arguments to the super constructor:

```dart
class A {
  A({int? x, int? y});
}
class B extends A {
  [!B!]({int? x, int? y}) : super(x: x, y: y);
}
```

## Common fixes

Use a `super` parameter to pass the arguments:

```dart
class A {
  A({int? x, int? y});
}
class B extends A {
  B({super.x, super.y});
}
```
