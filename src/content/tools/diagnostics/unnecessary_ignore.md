---
title: unnecessary_ignore
description: >-
  Details about the unnecessary_ignore
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_ignore"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The diagnostic '{0}' isn't produced at this location so it doesn't need to be ignored._
_The diagnostic '{0}' isn't produced in this file so it doesn't need to be ignored._

## Description

The analyzer produces this diagnostic when an ignore is specified to
ignore a diagnostic that isn't produced.

## Example

The following code produces this diagnostic because the
`unused_local_variable` diagnostic isn't reported at the ignored location:

```dart
// ignore: [!unused_local_variable!]
void f() {}
```

## Common fixes

Remove the ignore comment:

```dart
void f() {}
```
