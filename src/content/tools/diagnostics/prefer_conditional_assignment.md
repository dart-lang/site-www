---
title: prefer_conditional_assignment
description: >-
  Details about the prefer_conditional_assignment
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_conditional_assignment"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The 'if' statement could be replaced by a null-aware assignment._

## Description

The analyzer produces this diagnostic when an assignment to a variable is
conditional based on whether the variable has the value `null` and the
`??=` operator could be used instead.

## Example

The following code produces this diagnostic because the parameter `s` is
being compared to `null` in order to determine whether to assign a
different value:

```dart
int f(String? s) {
  [!if (s == null) {!]
    [!s = '';!]
  [!}!]
  return s.length;
}
```

## Common fixes

Use the `??=` operator instead of an explicit `if` statement:

```dart
int f(String? s) {
  s ??= '';
  return s.length;
}
```
