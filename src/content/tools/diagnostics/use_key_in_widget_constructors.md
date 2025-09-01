---
title: use_key_in_widget_constructors
description: >-
  Details about the use_key_in_widget_constructors
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_key_in_widget_constructors"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Constructors for public widgets should have a named 'key' parameter._

## Description

The analyzer produces this diagnostic when a constructor in a subclass of
`Widget` that isn't private to its library doesn't have a parameter named
`key`.

## Example

The following code produces this diagnostic because the constructor for
the class `MyWidget` doesn't have a parameter named `key`:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  [!MyWidget!]({required int height});
}
```

The following code produces this diagnostic because the default
constructor for the class `MyWidget` doesn't have a parameter named `key`:

```dart
import 'package:flutter/material.dart';

class [!MyWidget!] extends StatelessWidget {}
```

## Common fixes

Add a parameter named `key` to the constructor, explicitly declaring the
constructor if necessary:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  MyWidget({super.key, required int height});
}
```
