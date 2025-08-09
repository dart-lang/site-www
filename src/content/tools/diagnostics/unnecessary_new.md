---
title: unnecessary_new
description: >-
  Details about the unnecessary_new
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_new"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary 'new' keyword._

## Description

The analyzer produces this diagnostic when the keyword `new` is used to
invoke a constructor.

## Example

The following code produces this diagnostic because the keyword `new` is
used to invoke the unnamed constructor from `Object`:

```dart
var o = [!new!] Object();
```

## Common fixes

Remove the keyword `new`:

```dart
var o = Object();
```
