---
title: unnecessary_parenthesis
description: >-
  Details about the unnecessary_parenthesis
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_parenthesis"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of parentheses._

## Description

The analyzer produces this diagnostic when parentheses are used where they
do not affect the semantics of the code.

## Example

The following code produces this diagnostic because the parentheses around
the binary expression are not necessary:

```dart
int f(int a, int b) => [!(a + b)!];
```

## Common fixes

Remove the unnecessary parentheses:

```dart
int f(int a, int b) => a + b;
```
