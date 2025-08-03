---
title: prefer_null_aware_operators
description: >-
  Details about the prefer_null_aware_operators
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_null_aware_operators"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use the null-aware operator '?.' rather than an explicit 'null' comparison._

## Description

The analyzer produces this diagnostic when a comparison with `null` is
used to guard a member reference, and `null` is used as a result when the
guarded target is `null`.

## Example

The following code produces this diagnostic because the invocation of
`length` is guarded by a `null` comparison even though the default value
is `null`:

```dart
int? f(List<int>? p) {
  return [!p == null ? null : p.length!];
}
```

## Common fixes

Use a null-aware access operator instead:

```dart
int? f(List<int>? p) {
  return p?.length;
}
```
