---
title: use_raw_strings
description: >-
  Details about the use_raw_strings
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_raw_strings"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use a raw string to avoid using escapes._

## Description

The analyzer produces this diagnostic when a string literal containing
escapes, and no interpolations, could be marked as being raw in order to
avoid the need for the escapes.

## Example

The following code produces this diagnostic because the string contains
escaped characters that wouldn't need to be escaped if the string is
made a raw string:

```dart
var s = [!'A string with only \\ and \$'!];
```

## Common fixes

Mark the string as being raw and remove the unnecessary backslashes:

```dart
var s = r'A string with only \ and $';
```
