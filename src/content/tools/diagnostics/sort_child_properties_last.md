---
title: sort_child_properties_last
description: >-
  Details about the sort_child_properties_last
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/sort_child_properties_last"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The '{0}' argument should be last in widget constructor invocations._

## Description

The analyzer produces this diagnostic when the `child` or `children`
argument isn't the last argument in an invocation of a widget class'
constructor. An exception is made if all of the arguments after the
`child` or `children` argument are function expressions.

## Example

The following code produces this diagnostic because the `child` argument
isn't the last argument in the invocation of the `Center` constructor:

```dart
import 'package:flutter/material.dart';

Widget createWidget() {
  return Center(
    [!child: Text('...')!],
    widthFactor: 0.5,
  );
}
```

## Common fixes

Move the `child` or `children` argument to be last:

```dart
import 'package:flutter/material.dart';

Widget createWidget() {
  return Center(
    widthFactor: 0.5,
    child: Text('...'),
  );
}
```
