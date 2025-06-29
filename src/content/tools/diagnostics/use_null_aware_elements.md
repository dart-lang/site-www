---
title: use_null_aware_elements
description: >-
  Details about the use_null_aware_elements
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_null_aware_elements"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use the null-aware marker '?' rather than a null check via an 'if'._

## Description

The analyzer produces this diagnostic when a null check is used instead
of a null-aware marker inside of a collection literal.

## Example

The following code produces this diagnostic because a null check is used
to decide whether `x` should be inserted into the list, while the
null-aware marker '?' would be less brittle and less verbose.

```dart
f(int? x) => [[!if!] (x != null) x];
```

## Common fixes

Replace the null-check with the null-aware marker '?':

```dart
f(int? x) => [?x];
```
