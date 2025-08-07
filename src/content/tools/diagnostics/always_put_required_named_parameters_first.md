---
title: always_put_required_named_parameters_first
description: >-
  Details about the always_put_required_named_parameters_first
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/always_put_required_named_parameters_first"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Required named parameters should be before optional named parameters._

## Description

The analyzer produces this diagnostic when required named parameters occur
after optional named parameters.

## Example

The following code produces this diagnostic because the required parameter
`x` is after the optional parameter `y`:

```dart
void f({int? y, required int [!x!]}) {}
```

## Common fixes

Reorder the parameters so that all required named parameters are before
any optional named parameters:

```dart
void f({required int x, int? y}) {}
```
