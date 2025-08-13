---
title: unnecessary_null_checks
description: >-
  Details about the unnecessary_null_checks
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_null_checks"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of a null check ('!')._

## Description

The analyzer produces this diagnostic when a null check operator (`!`) is
used in a context where a nullable value is acceptable.

## Example

The following code produces this diagnostic because a null check is being
used even though `null` is a valid value to return:

```dart
int? f(int? i) {
  return i[!!!];
}
```

## Common fixes

Remove the null check operator:

```dart
int? f(int? i) {
  return i;
}
```
