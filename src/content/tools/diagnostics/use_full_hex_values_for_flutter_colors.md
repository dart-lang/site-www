---
title: use_full_hex_values_for_flutter_colors
description: >-
  Details about the use_full_hex_values_for_flutter_colors
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_full_hex_values_for_flutter_colors"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Instances of 'Color' should be created using an 8-digit hexadecimal integer
(such as '0xFFFFFFFF')._

## Description

The analyzer produces this diagnostic when the argument to the constructor
of the `Color` class is a literal integer that isn't represented as an
8-digit hexadecimal integer.

## Example

The following code produces this diagnostic because the argument (`1`)
isn't represented as an 8-digit hexadecimal integer:

```dart
import 'package:flutter/material.dart';

Color c = Color([!1!]);
```

## Common fixes

Convert the representation to be an 8-digit hexadecimal integer:

```dart
import 'package:flutter/material.dart';

Color c = Color(0x00000001);
```
