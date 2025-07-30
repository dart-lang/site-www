---
title: invalid_widget_preview_private_argument
description: >-
  Details about the invalid_widget_preview_private_argument
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_'@Preview(...)' can only accept arguments that consist of literals and public
symbols._

## Description

The analyzer produces this diagnostic when the `Preview` constructor is
invoked with arguments that contain references to private symbols.

## Example

The following code produces this diagnostic because the constant variable
`_name` is private to the current library:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

const String _name = 'My Foo Preview';

@Preview([!name: _name!])
Widget myPreview() => Text('Foo');
```

## Common fixes

If appropriate, the private symbol should be made public:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

const String name = 'My Foo Preview';

@Preview(name: name)
Widget myPreview() => Text('Foo');
```

Otherwise, a different public constant symbol should be used:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'My Foo Preview')
Widget myPreview() => Text('Foo');
```
