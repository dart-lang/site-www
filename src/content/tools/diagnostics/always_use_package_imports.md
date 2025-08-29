---
title: always_use_package_imports
description: >-
  Details about the always_use_package_imports
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/always_use_package_imports"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'package:' imports for files in the 'lib' directory._

## Description

The analyzer produces this diagnostic when an `import` in a library inside
the `lib` directory uses a relative path to import another library inside
the `lib` directory of the same package.

## Example

Given that a file named `a.dart` and the code below are both inside the
`lib` directory of the same package, the following code produces this
diagnostic because a relative URI is used to import `a.dart`:

```dart
import [!'a.dart'!];
```

## Common fixes

Use a package import:

```dart
import 'package:p/a.dart';
```
