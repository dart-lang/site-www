---
title: sdk_version_extension_methods
description: >-
  Details about the sdk_version_extension_methods
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Extension methods weren't supported until version 2.6.0, but this code is
required to be able to run on earlier versions._

## Description

The analyzer produces this diagnostic when an extension declaration or an
extension override is found in code that has an SDK constraint whose lower
bound is less than 2.6.0. Using extensions wasn't supported in earlier
versions, so this code won't be able to run against earlier versions of the
SDK.

## Example

Here's an example of a pubspec that defines an SDK constraint with a lower
bound of less than 2.6.0:

```yaml
environment:
 sdk: '>=2.4.0 <2.7.0'
```

In the package that has that pubspec, code like the following produces
this diagnostic:

```dart
[!extension!] E on String {
  void sayHello() {
    print('Hello $this');
  }
}
```

## Common fixes

If you don't need to support older versions of the SDK, then you can
increase the SDK constraint to allow the syntax to be used:

```yaml
environment:
  sdk: '>=2.6.0 <2.7.0'
```

If you need to support older versions of the SDK, then rewrite the code to
not make use of extensions. The most common way to do this is to rewrite
the members of the extension as top-level functions (or methods) that take
the value that would have been bound to `this` as a parameter:

```dart
void sayHello(String s) {
  print('Hello $s');
}
```
