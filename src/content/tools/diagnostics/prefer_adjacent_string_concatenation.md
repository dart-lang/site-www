---
title: prefer_adjacent_string_concatenation
description: >-
  Details about the prefer_adjacent_string_concatenation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_adjacent_string_concatenation"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_String literals shouldn't be concatenated by the '+' operator._

## Description

The analyzer produces this diagnostic when the `+` operator is used to
concatenate two string literals.

## Example

The following code produces this diagnostic because two string literals
are being concatenated by using the `+` operator:

```dart
var s = 'a' [!+!] 'b';
```

## Common fixes

Remove the operator:

```dart
var s = 'a' 'b';
```
