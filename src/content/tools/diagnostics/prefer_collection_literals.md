---
title: prefer_collection_literals
description: >-
  Details about the prefer_collection_literals
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_collection_literals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary constructor invocation._

## Description

The analyzer produces this diagnostic when a constructor is used to create
a list, map, or set, but a literal would produce the same result.

## Example

The following code produces this diagnostic because the constructor for
`Map` is being used to create a map that could also be created using a
literal:

```dart
var m = [!Map<String, String>()!];
```

## Common fixes

Use the literal representation:

```dart
var m = <String, String>{};
```
