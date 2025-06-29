---
title: unnecessary_underscores
description: >-
  Details about the unnecessary_underscores
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_underscores"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of multiple underscores._

## Description

The analyzer produces this diagnostic when an unused variable is named
with multiple underscores (for example `__`). A single `_` wildcard variable
can be used instead.

## Example

The following code produces this diagnostic because the `__` parameter is unused:

```dart
void function(int [!__!]) { }
```

## Common fixes

Replace the name with a single underscore:

```dart
void function(int _) { }
```
