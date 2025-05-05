---
title: constant_identifier_names
description: >-
  Details about the constant_identifier_names
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/constant_identifier_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The constant name '{0}' isn't a lowerCamelCase identifier._

## Description

The analyzer produces this diagnostic when the name of a constant doesn't
follow the lowerCamelCase naming convention.

## Example

The following code produces this diagnostic because the name of the
top-level variable isn't a lowerCamelCase identifier:

```dart
const [!EMPTY_STRING!] = '';
```

## Common fixes

Rewrite the name to follow the lowerCamelCase naming convention:

```dart
const emptyString = '';
```
