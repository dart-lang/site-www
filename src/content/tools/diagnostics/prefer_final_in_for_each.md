---
title: prefer_final_in_for_each
description: >-
  Details about the prefer_final_in_for_each
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_final_in_for_each"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The pattern should be final._
_The variable '{0}' should be final._

## Description

The analyzer produces this diagnostic when the loop variable in a for-each
statement isn't marked as being `final`.

## Example

The following code produces this diagnostic because the loop variable `e`
isn't marked as being `final`:

```dart
void f(List<int> l) {
  for (var [!e!] in l) {
    print(e);
  }
}
```

## Common fixes

Add the modifier `final` to the loop variable, removing the `var` if there
is one:

```dart
void f(List<int> l) {
  for (final e in l) {
    print(e);
  }
}
```
