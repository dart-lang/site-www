---
title: unnecessary_string_interpolations
description: >-
  Details about the unnecessary_string_interpolations
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_string_interpolations"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of string interpolation._

## Description

The analyzer produces this diagnostic when a string literal contains a
single interpolation of a `String`-valued variable and no other
characters.

## Example

The following code produces this diagnostic because the string literal
contains a single interpolation and doesn't contain any character outside
the interpolation:

```dart
String f(String s) => [!'$s'!];
```

## Common fixes

Replace the string literal with the content of the interpolation:

```dart
String f(String s) => s;
```
