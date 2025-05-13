---
title: prefer_void_to_null
description: >-
  Details about the prefer_void_to_null
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_void_to_null"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of the type 'Null'._

## Description

The analyzer produces this diagnostic when `Null` is used in a location
where `void` would be a valid choice.

## Example

The following code produces this diagnostic because the function `f` is
declared to return `null` (at some future time):

```dart
Future<[!Null!]> f() async {}
```

## Common fixes

Replace the use of `Null` with a use of `void`:

```dart
Future<void> f() async {}
```
