---
title: camel_case_extensions
description: >-
  Details about the camel_case_extensions
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/camel_case_extensions"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The extension name '{0}' isn't an UpperCamelCase identifier._

## Description

The analyzer produces this diagnostic when the name of an extension
doesn't use the 'UpperCamelCase' naming convention.

## Example

The following code produces this diagnostic because the name of the
extension doesn't start with an uppercase letter:

```dart
extension [!stringExtension!] on String {}
```

## Common fixes

If the extension needs to have a name (needs to be visible outside this
library), then rename the extension so that it has a valid name:

```dart
extension StringExtension on String {}
```

If the extension doesn't need to have a name, then remove the name of the
extension:

```dart
extension on String {}
```
