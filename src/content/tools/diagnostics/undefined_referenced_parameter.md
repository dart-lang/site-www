---
title: undefined_referenced_parameter
description: >-
  Details about the undefined_referenced_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The parameter '{0}' isn't defined by '{1}'._

## Description

The analyzer produces this diagnostic when an annotation of the form
[`UseResult.unless(parameterDefined: parameterName)`][meta-UseResult]
specifies a parameter name that isn't defined by the annotated function.

## Example

The following code produces this diagnostic because the function `f`
doesn't have a parameter named `b`:

```dart
import 'package:meta/meta.dart';

@UseResult.unless(parameterDefined: [!'b'!])
int f([int? a]) => a ?? 0;
```

## Common fixes

Change the argument named `parameterDefined` to match the name of one of
the parameters to the function:

```dart
import 'package:meta/meta.dart';

@UseResult.unless(parameterDefined: 'a')
int f([int? a]) => a ?? 0;
```

[meta-UseResult]: https://pub.dev/documentation/meta/latest/meta/UseResult-class.html
