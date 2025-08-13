---
title: avoid_unnecessary_containers
description: >-
  Details about the avoid_unnecessary_containers
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_unnecessary_containers"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary instance of 'Container'._

## Description

The analyzer produces this diagnostic when a widget tree contains an
instance of `Container` and the only argument to the constructor is
`child:`.

## Example

The following code produces this diagnostic because the invocation of the
`Container` constructor only has a `child:` argument:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return [!Container!](
    child: Row(
      children: [
        Text('a'),
        Text('b'),
      ],
    )
  );
}
```

## Common fixes

If you intended to provide other arguments to the constructor, then add
them:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return Container(
    color: Colors.red.shade100,
    child: Row(
      children: [
        Text('a'),
        Text('b'),
      ],
    )
  );
}
```

If no other arguments are needed, then unwrap the child widget:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return Row(
    children: [
      Text('a'),
      Text('b'),
    ],
  );
}
```
