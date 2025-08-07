---
title: prefer_iterable_wheretype
description: >-
  Details about the prefer_iterable_wheretype
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_iterable_whereType"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'whereType' to select elements of a given type._

## Description

The analyzer produces this diagnostic when the method `Iterable.where` is
being used to filter elements based on their type.

## Example

The following code produces this diagnostic because the method `where` is
being used to access only the strings within the iterable:

```dart
Iterable<Object> f(Iterable<Object> p) => p.[!where!]((e) => e is String);
```

## Common fixes

Rewrite the code to use `whereType`:

```dart
Iterable<String> f(Iterable<Object> p) => p.whereType<String>();
```

This might also allow you to tighten the types in your code or remove
other type checks.
