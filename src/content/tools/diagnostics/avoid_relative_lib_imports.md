---
title: avoid_relative_lib_imports
description: >-
  Details about the avoid_relative_lib_imports
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_relative_lib_imports"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Can't use a relative path to import a library in 'lib'._

## Description

The analyzer produces this diagnostic when the URI in an `import`
directive has `lib` in the path.

## Example

Assuming that there is a file named `a.dart` in the `lib` directory:

```dart
class A {}
```

The following code produces this diagnostic because the import contains a
path that includes `lib`:

```dart
import [!'../lib/a.dart'!];
```

## Common fixes

Rewrite the import to not include `lib` in the URI:

```dart
import 'a.dart';
```
