---
title: JavaScript interoperability
short-title: JS interop
description: "Use package:js to integrate JavaScript code into your Dart web app."
toc: false
---

The [Dart web platform](/platforms/) supports calling
JavaScript using the `js` package,
also known as _package:js_.

For help using the `js` package, see the following:

* Documentation for the `js` package:
  * [pub.dev site page][js]
  * [API reference][js-api]
* Packages that use the `js` package:
  * [firebase_web][] is a good example of providing a Dart-like API
    to a JavaScript library.
  * [sass][] is an example of a more unusual use case: providing a
    way for JavaScript code to call Dart code.

[js]: {{site.pub-pkg}}/js
[js-api]: {{site.pub-api}}/js
[firebase_web]: {{site.pub-pkg}}/firebase_web
[sass]: {{site.pub-pkg}}/sass

