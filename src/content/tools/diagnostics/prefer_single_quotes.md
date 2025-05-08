---
title: prefer_single_quotes
description: >-
  Details about the prefer_single_quotes
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_single_quotes"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of double quotes._

## Description

The analyzer produces this diagnostic when a string literal uses double
quotes (`"`) when it could use single quotes (`'`) without needing extra
escapes and without hurting readability.

## Example

The following code produces this diagnostic because the string literal
uses double quotes but doesn't need to:

```dart
void f(String name) {
  print([!"Hello $name"!]);
}
```

## Common fixes

Use single quotes in place of double quotes:

```dart
void f(String name) {
  print('Hello $name');
}
```
