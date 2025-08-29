---
title: unnecessary_library_name
description: >-
  Details about the unnecessary_library_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_library_name"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Library names are not necessary._

## Description

The analyzer produces this diagnostic when a `library` directive specifies
a name.

## Example

The following code produces this diagnostic because the `library`
directive includes a name:

```dart
library [!some.name!];

class C {}
```

## Common fixes

Remove the name from the `library` directive:

```dart
library;

class C {}
```

If the library has any parts, then any `part of` declarations that use
the library name should be updated to use the URI of the library instead.
