---
title: use_colored_box
description: >-
  Details about the use_colored_box
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_colored_box"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use a 'ColoredBox' rather than a 'Container' with only a 'Color'._

## Description

The analyzer produces this diagnostic when a `Container` is created that
only sets the color.

## Example

The following code produces this diagnostic because the only attribute of
the container that is set is the `color`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return [!Container!](
    color: Colors.red,
    child: const Text('hello'),
  );
}
```

## Common fixes

Replace the `Container` with a `ColoredBox`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return ColoredBox(
    color: Colors.red,
    child: const Text('hello'),
  );
}
```
