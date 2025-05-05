---
title: close_sinks
description: >-
  Details about the close_sinks
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/close_sinks"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unclosed instance of 'Sink'._

## Description

The analyzer produces this diagnostic when an instance of `Sink` is
created but the method `close` isn't invoked.

## Example

The following code produces this diagnostic because the `sink` isn't
closed:

```dart
import 'dart:io';

void g(File f) {
  var [!sink = f.openWrite()!];
  sink.write('x');
}
```

## Common fixes

Close the sink:

```dart
import 'dart:io';

void g(File f) {
  var sink = f.openWrite();
  sink.write('x');
  sink.close();
}
```
