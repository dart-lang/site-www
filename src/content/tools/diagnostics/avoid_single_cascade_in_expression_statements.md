---
title: avoid_single_cascade_in_expression_statements
description: >-
  Details about the avoid_single_cascade_in_expression_statements
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_single_cascade_in_expression_statements"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary cascade expression._

## Description

The analyzer produces this diagnostic when a single cascade operator is
used and the value of the expression isn't being used for anything (such
as being assigned to a variable or being passed as an argument).

## Example

The following code produces this diagnostic because the value of the
cascade expression `s..length` isn't being used:

```dart
void f(String s) {
  [!s..length!];
}
```

## Common fixes

Replace the cascade operator with a simple access operator:

```dart
void f(String s) {
  s.length;
}
```
