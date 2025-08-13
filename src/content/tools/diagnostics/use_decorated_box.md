---
title: use_decorated_box
description: >-
  Details about the use_decorated_box
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_decorated_box"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'DecoratedBox' rather than a 'Container' with only a 'Decoration'._

## Description

The analyzer produces this diagnostic when a `Container` is created that
only sets the decoration.

## Example

The following code produces this diagnostic because the only attribute of
the container that is set is the `decoration`:

```dart
import 'package:flutter/material.dart';

Widget buildArea() {
  return [!Container!](
    decoration: const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: const Text('...'),
  );
}
```

## Common fixes

Replace the `Container` with a `DecoratedBox`:

```dart
import 'package:flutter/material.dart';

Widget buildArea() {
  return DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: const Text('...'),
  );
}
```
