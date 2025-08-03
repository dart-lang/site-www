---
title: no_leading_underscores_for_library_prefixes
description: >-
  Details about the no_leading_underscores_for_library_prefixes
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_leading_underscores_for_library_prefixes"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The library prefix '{0}' starts with an underscore._

## Description

The analyzer produces this diagnostic when the name of a prefix declared
on an import starts with an underscore.

Library prefixes are inherently not visible outside the declaring library,
so a leading underscore indicating private adds no value.

## Example

The following code produces this diagnostic because the prefix `_core`
starts with an underscore:

```dart
import 'dart:core' as [!_core!];
```

## Common fixes

Remove the underscore:

```dart
import 'dart:core' as core;
```
