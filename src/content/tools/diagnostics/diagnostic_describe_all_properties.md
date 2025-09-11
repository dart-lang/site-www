---
title: diagnostic_describe_all_properties
description: >-
  Details about the diagnostic_describe_all_properties
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/diagnostic_describe_all_properties"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The public property isn't described by either 'debugFillProperties' or 'debugDescribeChildren'._

## Description

The analyzer produces this diagnostic when a class that implements
`Diagnosticable` has a public property that isn't added as a property in
either a `debugFillProperties` or `debugDescribeChildren` method.

## Example

The following code produces this diagnostic because the property `p2`
isn't added in the `debugFillProperties` method:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class C extends Widget {
  bool get p1 => true;

  bool get [!p2!] => false;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('p1', p1));
  }
}
```

## Common fixes

If there isn't on override of either the `debugFillProperties` or
`debugDescribeChildren` method, then add one.

Add a description of the property in the `debugFillProperties` or
`debugDescribeChildren` method:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class C extends Widget {
  bool get p1 => true;

  bool get p2 => false;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('p1', p1));
    properties.add(DiagnosticsProperty<bool>('p2', p2));
  }
}
```
