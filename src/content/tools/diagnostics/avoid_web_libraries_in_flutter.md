---
title: avoid_web_libraries_in_flutter
description: >-
  Details about the avoid_web_libraries_in_flutter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_web_libraries_in_flutter"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't use web-only libraries outside Flutter web plugins._

## Description

The analyzer produces this diagnostic when a library in a package that
isn't a web plugin contains an import of a web-only library:
- `dart:html`
- `dart:js`
- `dart:js_util`
- `dart:js_interop`
- `dart:js_interop_unsafe`
- `package:js`
- `package:web`

## Example

When found in a package that isn't a web plugin, the following code
produces this diagnostic because it imports `dart:html`:

```dart
import [!'dart:html'!];

import 'package:flutter/material.dart';

class C {}
```

## Common fixes

If the package isn't intended to be a web plugin, then remove the import:

```dart
import 'package:flutter/material.dart';

class C {}
```

If the package is intended to be a web plugin, then add the following
lines to the `pubspec.yaml` file of the package:

```yaml
flutter:
  plugin:
    platforms:
      web:
        pluginClass: HelloPlugin
        fileName: hello_web.dart
```

See [Developing packages & plugins](https://flutter.dev/to/develop-packages)
for more information.
