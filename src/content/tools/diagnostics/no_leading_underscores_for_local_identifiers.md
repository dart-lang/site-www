---
title: no_leading_underscores_for_local_identifiers
description: >-
  Details about the no_leading_underscores_for_local_identifiers
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_leading_underscores_for_local_identifiers"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The local variable '{0}' starts with an underscore._

## Description

The analyzer produces this diagnostic when the name of a local variable
starts with an underscore.

Local variables are inherently not visible outside the declaring library,
so a leading underscore indicating private adds no value.

## Example

The following code produces this diagnostic because the parameter `_s`
starts with an underscore:

```dart
int f(String [!_s!]) => _s.length;
```

## Common fixes

Remove the underscore:

```dart
int f(String s) => s.length;
```
