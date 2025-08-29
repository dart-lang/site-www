---
title: empty_constructor_bodies
description: >-
  Details about the empty_constructor_bodies
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/empty_constructor_bodies"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Empty constructor bodies should be written using a ';' rather than '{}'._

## Description

The analyzer produces this diagnostic when a constructor has an empty
block body.

## Example

The following code produces this diagnostic because the constructor for
`C` has a block body that is empty:

```dart
class C {
  C() [!{}!]
}
```

## Common fixes

Replace the block with a semicolon:

```dart
class C {
  C();
}
```
