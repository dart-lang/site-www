---
title: prefer_relative_imports
description: >-
  Details about the prefer_relative_imports
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_relative_imports"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use relative imports for files in the 'lib' directory._

## Description

The analyzer produces this diagnostic when an `import` in a library inside
the `lib` directory uses a `package:` URI to refer to another library in
the same package.

## Example

The following code produces this diagnostic because it uses a `package:`
URI when a relative URI could have been used:

```dart
import 'package:my_package/bar.dart';
```

## Common fixes

Use a relative URI to import the library:

```dart
import 'bar.dart';
```
