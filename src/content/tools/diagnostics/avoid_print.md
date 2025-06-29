---
title: avoid_print
description: >-
  Details about the avoid_print
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_print"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't invoke 'print' in production code._

## Description

The analyzer produces this diagnostic when the function `print` is invoked
in production code.

## Example

The following code produces this diagnostic because the function `print`
can't be invoked in production:

```dart
void f(int x) {
  [!print!]('x = $x');
}
```

## Common fixes

If you're writing code that uses Flutter, then use the function
[`debugPrint`][debugPrint], guarded by a test
using [`kDebugMode`][kDebugMode]:

```dart
import 'package:flutter/foundation.dart';

void f(int x) {
  if (kDebugMode) {
    debugPrint('x = $x');
  }
}
```

If you're writing code that doesn't use Flutter, then use a logging
service, such as [`package:logging`][package-logging], to write the
information.

[debugPrint]: https://api.flutter.dev/flutter/foundation/debugPrint.html
[kDebugMode]: https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html
[package-logging]: https://pub.dev/packages/logging
