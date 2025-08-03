---
title: unnecessary_brace_in_string_interps
description: >-
  Details about the unnecessary_brace_in_string_interps
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_brace_in_string_interps"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary braces in a string interpolation._

## Description

The analyzer produces this diagnostic when a string interpolation with
braces is used to interpolate a simple identifier and isn't followed by
alphanumeric text.

## Example

The following code produces this diagnostic because the interpolation
element `${s}` uses braces when they are not necessary:

```dart
String f(String s) {
  return '"[!${s}!]"';
}
```

## Common fixes

Remove the unnecessary braces:

```dart
String f(String s) {
  return '"$s"';
}
```
