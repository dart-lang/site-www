---
title: valid_regexps
description: >-
  Details about the valid_regexps
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/valid_regexps"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Invalid regular expression syntax._

## Description

The analyzer produces this diagnostic when the string passed to the
default constructor of the class `RegExp` doesn't contain a valid regular
expression.

A regular expression created with invalid syntax will throw a
`FormatException` at runtime.

## Example

The following code produces this diagnostic because the regular expression
isn't valid:

```dart
var r = RegExp([!r'('!]);
```

## Common fixes

Fix the regular expression:

```dart
var r = RegExp(r'\(');
```
