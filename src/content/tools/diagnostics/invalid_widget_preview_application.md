---
title: invalid_widget_preview_application
description: >-
  Details about the invalid_widget_preview_application
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The '@Preview(...)' annotation can only be applied to public, statically
accessible constructors and functions._

## Description

The analyzer produces this diagnostic when a `@Preview(...)` annotation
is applied to an invalid widget preview target. Widget previews can only
be applied to public, statically accessible, explicitly defined
constructors and functions.

## Examples

The following code produces this diagnostic because `_myPrivatePreview`
is private:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

// Invalid application to private top-level function.
@[!Preview!]()
// ignore: unused_element
Widget _myPrivatePreview() => Text('Foo');
```

The following code produces this diagnostic because `myExternalPreview`
is `external`:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';


// Invalid application to an external function.
@[!Preview!]()
external Widget myExternalPreview();
```

The following code produces this diagnostic because `PublicWidget._()` is
private:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

class PublicWidget extends StatelessWidget {
  // Invalid application to a private constructor.
  @[!Preview!]()
  PublicWidget._();

  @override
  Widget build(BuildContext) => Text('Foo');
}
```

The following code produces this diagnostic because `instancePreview` is
an instance method:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

class PublicWidget extends StatelessWidget {
  // Invalid application to a instance member.
  @[!Preview!]()
  Widget instancePreview() => PublicWidget();

  @override
  Widget build(BuildContext context) => Text('Foo');
}
```

The following code produces this diagnostic because `_PrivateWidget` is
private:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

// ignore: unused_element
class _PrivateWidget extends StatelessWidget {
  // Invalid application to a constructor of a private class.
  @[!Preview!]()
  _PrivateWidget();

  @override
  Widget build(BuildContext context) => Text('Foo');
}
```

The following code produces this diagnostic because `_PrivateWidget` is
private:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

// ignore: unused_element
class _PrivateWidget extends StatelessWidget {
  // Invalid application to a static method of a private class.
  @[!Preview!]()
  Widget privateStatic() => _PrivateWidget();

  @override
  Widget build(BuildContext context) => Text('Foo');
}
```

The following code produces this diagnostic because `AbstractWidget` is
an `abstract` class:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

abstract class AbstractWidget extends StatelessWidget {
  // Invalid application to a constructor of an abstract class.
  @[!Preview!]()
  AbstractWidget();

  @override
  Widget build(BuildContext context) => Text('Foo');
}
```

## Common fixes

Create a dedicated public, statically accessible, and explicitly defined
constructor, top-level function, or class member for use as a preview:
