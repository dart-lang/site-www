---
title: unnecessary_raw_strings
description: >-
  Details about the unnecessary_raw_strings
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_raw_strings"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of a raw string._

## Description

The analyzer produces this diagnostic when a string literal is marked as
being raw (is prefixed with an `r`), but making the string raw doesn't
change the value of the string.

## Example

The following code produces this diagnostic because the string literal
will have the same value without the `r` as it does with the `r`:

```dart
var s = [!r'abc'!];
```

## Common fixes

Remove the `r` in front of the string literal:

```dart
var s = 'abc';
```
