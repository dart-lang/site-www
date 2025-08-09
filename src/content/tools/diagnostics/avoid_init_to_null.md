---
title: avoid_init_to_null
description: >-
  Details about the avoid_init_to_null
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_init_to_null"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Redundant initialization to 'null'._

## Description

The analyzer produces this diagnostic when a nullable variable is
explicitly initialized to `null`. The variable can be a local variable,
field, or top-level variable.

A variable or field that isn't explicitly initialized automatically gets
initialized to `null`. There's no concept of "uninitialized memory" in
Dart.

## Example

The following code produces this diagnostic because the variable `f` is
explicitly initialized to `null`:

```dart
class C {
  int? [!f = null!];

  void m() {
    if (f != null) {
      print(f);
    }
  }
}
```

## Common fixes

Remove the unnecessary initialization:

```dart
class C {
  int? f;

  void m() {
    if (f != null) {
      print(f);
    }
  }
}
```
