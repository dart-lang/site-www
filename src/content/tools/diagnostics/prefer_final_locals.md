---
title: prefer_final_locals
description: >-
  Details about the prefer_final_locals
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_final_locals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Local variables should be final._

## Description

The analyzer produces this diagnostic when a local variable isn't marked
as being `final`.

## Example

The following code produces this diagnostic because the variable `s` isn't
marked as being `final`:

```dart
int f(int i) {
  [!var!] s = i + 1;
  return s;
}
```

## Common fixes

Add the modifier `final` to the variable, removing the `var` if there is
one:

```dart
int f(int i) {
  final s = i + 1;
  return s;
}
```
