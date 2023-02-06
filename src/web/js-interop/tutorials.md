---
title: JS interop tutorials
description: Tutorials for common JavaScript interop use cases in Dart.
---

## Tutorials

### [How to interop with DOM APIs][]

The browser exposes a number of DOM APIs accessible to Dart through the `dart:js_interop` library.
DOM APIs are the most common set of APIs Dart users will want to expose or interact with while using JS interop. This tutorial shows how to access these APIs and some of the common reasons you may want to use them. 

### [How to interop with JavaScript libraries and apps][]

Have you found a JS library or app that does exactly what you want to do in your Dart code, but it's way too complex to rewrite in Dart?

This tutorial will show you how to incorporate methods from an existing JS library.
It will also discuss build and serving options.

### [How to test and mock JavaScript interop in Dart][]

Exporting Dart objects with `@JSExport` creates a mock of the object at the JS level, which essentially allows you to test your Dart JS interop code.

This tutorial will walk through both cases: simply exporting Dart objects to JS,
and then using that same functionality to test JS interop code. 

[How to interop with DOM APIs]: /web/js-interop/dom
[How to interop with JavaScript libraries and apps]: /web/js-interop/js-app
[How to test and mock JavaScript interop in Dart]: /web/js-interop/test-and-mock