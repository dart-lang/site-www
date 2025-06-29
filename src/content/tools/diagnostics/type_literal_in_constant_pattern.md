---
title: type_literal_in_constant_pattern
description: >-
  Details about the type_literal_in_constant_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/type_literal_in_constant_pattern"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'TypeName \_' instead of a type literal._

## Description

The analyzer produces this diagnostic when a type literal appears as a
pattern.

## Example

The following code produces this diagnostic because a type literal is used
as a constant pattern:

```dart
void f(Object? x) {
  if (x case [!num!]) {
    // ...
  }
}
```

## Common fixes

If the type literal is intended to match an object of the given type, then
use either a variable pattern:

```dart
void f(Object? x) {
  if (x case num _) {
    // ...
  }
}
```

Or an object pattern:

```dart
void f(Object? x) {
  if (x case num()) {
    // ...
  }
}
```

If the type literal is intended to match the type literal, then write it
as a constant pattern:

```dart
void f(Object? x) {
  if (x case const (num)) {
    // ...
  }
}
```
