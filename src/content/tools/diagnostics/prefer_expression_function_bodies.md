---
title: prefer_expression_function_bodies
description: >-
  Details about the prefer_expression_function_bodies
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_expression_function_bodies"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of a block function body._

## Description

The analyzer produces this diagnostic when the body of a function consists
of a single return statement with an expression.

## Example

The following code produces this diagnostic because the body of `f` has a
single return statement:

```dart
int f() [!{!]
  [!return 0;!]
[!}!]
```

## Common fixes

If the body is complete, then replace the body with an expression body:

```dart
int f() => 0;
```

If the body isn't complete, then add the missing statements.
