---
title: use_function_type_syntax_for_parameters
description: >-
  Details about the use_function_type_syntax_for_parameters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_function_type_syntax_for_parameters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use the generic function type syntax to declare the parameter '{0}'._

## Description

The analyzer produces this diagnostic when the older style function-valued
parameter syntax is used.

## Example

The following code produces this diagnostic because the function-valued
parameter `f` is declared using an older style syntax:

```dart
void g([!bool f(String s)!]) {}
```

## Common fixes

Use the generic function type syntax to declare the parameter:

```dart
void g(bool Function(String) f) {}
```
