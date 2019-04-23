---
title: "dartdevc: the Dart dev compiler"
short-title: dartdevc
description: Fast, modular compilation of Dart code to JavaScript.
---

The Dart development compiler _(dartdevc_, also known as _DDC)_
lets you run and debug your Dart web app in any modern web browser.

<aside class="alert alert-info" markdown="1">
  **Note:**
  The dartdevc compiler is for _development_ only.
  Continue to use [dart2js](/tools/dart2js)
  to compile for [deployment]({{site.angulardart}}/guide/deployment).
</aside>

Unlike dart2js,
dartdevc supports incremental compilation and emits modular JavaScript.
With a tool like [webdev serve][serve] that uses dartdevc,
you can edit your Dart files,
refresh in Chrome,
and see your edits almost immediately.
This speed is possible because dartdevc compiles only updated modules,
not all the packages that your app depends on.

The first compilation with dartdevc takes the longest,
because the entire app must be compiled.
After that, as long as the [serve][] command keeps running,
refresh times with dartdevc are much faster than with dart2js.

## More information

* [dartdevc: FAQ](/tools/dartdevc/faq)
* [webdev][], which uses dartdevc by default when serving and testing web apps

[serve]: /tools/webdev#serve
[webdev]: /tools/webdev
