---
title: unnecessary_constructor_name
description: >-
  Details about the unnecessary_constructor_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_constructor_name"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary '.new' constructor name._

## Description

The analyzer produces this diagnostic when a reference to an unnamed
constructor uses `.new`. The only place where `.new` is required is in a
constructor tear-off.

## Example

The following code produces this diagnostic because `.new` is being used
to refer to the unnamed constructor where it isn't required:

```dart
var o = Object.[!new!]();
```

## Common fixes

Remove the unnecessary `.new`:

```dart
var o = Object();
```
