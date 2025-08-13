---
title: no_logic_in_create_state
description: >-
  Details about the no_logic_in_create_state
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_logic_in_create_state"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't put any logic in 'createState'._

## Description

The analyzer produces this diagnostic when an implementation of
`createState` in a subclass of `StatefulWidget` contains any logic other
than the return of the result of invoking a zero argument constructor.

## Examples

The following code produces this diagnostic because the constructor
invocation has arguments:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  MyState createState() => [!MyState(0)!];
}

class MyState extends State {
  int x;

  MyState(this.x);
}
```

## Common fixes

Rewrite the code so that `createState` doesn't contain any logic:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  MyState createState() => MyState();
}

class MyState extends State {
  int x = 0;

  MyState();
}
```
