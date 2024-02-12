---
title: JS interop tutorials
description: Tutorials for common JavaScript interop use cases in Dart.
---

## Tutorials

### [How to test and mock JavaScript interop in Dart][]

Exporting Dart objects with [`@JSExport`] creates a mock of the object at the JS
level, which essentially allows you to test your Dart JS interop code.

This tutorial will walk through both cases: simply exporting Dart objects to JS,
and then using that same functionality to test JS interop code.

{% comment %}
TODO: add a section on how to bundle a JS and Dart app for interop
TODO: maybe add a section on conversions
{% endcomment %}

[How to test and mock JavaScript interop in Dart]: /interop/js-interop/test-and-mock
[`@JSExport`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-js_interop/JSExport-class.html