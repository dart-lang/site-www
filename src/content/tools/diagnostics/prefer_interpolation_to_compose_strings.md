---
title: prefer_interpolation_to_compose_strings
description: >-
  Details about the prefer_interpolation_to_compose_strings
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_interpolation_to_compose_strings"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use interpolation to compose strings and values._

## Description

The analyzer produces this diagnostic when string literals and computed
strings are being concatenated using the `+` operator, but string
interpolation would achieve the same result.

## Example

The following code produces this diagnostic because the String `s` is
concatenated with other strings using the `+` operator:

```dart
String f(String s) {
  return [!'(' + s!] + ')';
}
```

## Common fixes

Use string interpolation:

```dart
String f(List<String> l) {
  return '(${l[0]}, ${l[1]})';
}
```
