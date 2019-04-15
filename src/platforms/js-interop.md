---
title: "JS/TS interop"
short-title: Platforms
description: "The Dart Web platform supports JS/TS integration via package:js"
toc: false
---

On the [Dart Web platform](/platforms/overview/), Dart supports calling
JavaScript (JS) and TypeScript (TS) via the [`js`
package,]({{site.pub-pkg}}/js), also known as _package:js,_.

For help using the `js` package, see the following:

[js_facade_gen](https://github.com/dart-lang/js_facade_gen)
: A tool that generates Dart code from JavaScript libraries that have
  [TypeScript type definitions.](http://definitelytyped.org/)

[dart_js_interop](https://github.com/matanlurey/dart_js_interop)
: Examples of using the `js` package,
  with comparisons to old code that uses the dart:js library.

[Packages that depend on `js`]({{pub-pkg}}?q=dependency%3Ajs)
: Published packages that have `js` in their pubspec.
