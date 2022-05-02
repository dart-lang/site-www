---
title: "dartdevc: The Dart development compiler"
short-title: dartdevc
description: A development compiler for fast, modular compilation of Dart code to JavaScript.
---

The Dart development compiler (_dartdevc_, also known as _DDC_)
is a Dart-to-JavaScript compiler
that's targeted at web app development in modern browsers.

dartdevc is used by tools such as the [`webdev`][] tool
to allow you to run and debug your Dart web apps in Chrome.

{{site.alert.note}}
  dartdevc is used for _development_ only.
  Continue to use [dart2js](/tools/dart2js)
  through [`dart compile js`](/tools/dart-compile#js) 
  or the [`webdev`][] tool
  to compile for deployment.
{{site.alert.end}}

## Overview

dartdevc is a Dart-to-JavaScript compiler
that's targeted at web app development in modern browsers.

dartdevc supports incremental compilation and emits modular JavaScript.
With a tool like [`webdev serve`][serve] that uses dartdevc,
you can edit your Dart files,
refresh in Chrome,
and see your edits almost immediately.
This speed is possible because dartdevc compiles only updated modules,
not all the packages that your app depends on.

The first compilation with dartdevc takes the longest,
because the entire app must be compiled.
After that, as long as the [`serve`][serve] command keeps running,
refresh times with dartdevc are much faster than with dart2js.


### Using dartdevc

The [`webdev`][] and [build_runner][] tools use
**dartdevc** as the default web compiler when
[serving][serve] and [testing][test] web apps.


### When to use dartdevc

Use **dartdevc** whenever you're actively working on your code.
Here are some of the advantages of dartdevc over dart2js:

* Faster refreshing after code changes.
* Simpler, more readable, more idiomatic JavaScript output
  containing fewer runtime checks.
* Integration with Chrome dev tools for easier debugging.

Keep using **[dart2js][]** to build your deployed, production app.
With dart2js you get advanced optimizations such as
tree shaking to minimize downloaded code size.


### Compatible browsers

Chrome is the only supported browser.
You _might_ be able to use other modern browsers
(Chromium Edge, Firefox, and Safari).

If you find a bug in dartdevc's support for Chrome, Edge, Firefox, or Safari,
please [create an issue.][dartdevc issue]


## Common problems

### Code passes analysis but fails to compile

Because dartdevc analyzes more code.

The Dart analyzer looks at an individual package's source code,
not the code of any additional packages.
In contrast, dartdevc analyzes the whole, generated program;
it covers the original source code,
plus generated code and all used packages.

{% comment %}
TODO: Provide guidance as to how to debug such errors,
especially when they come from generated code or third-party libraries.
{% endcomment %}

### First compile takes a long time to run

Because it's compiling your entire app,
including the packages your app depends on.

The first time you [`build`][build] or [`serve`][serve] your app,
dartdevc compiles every module.
Afterward, as long as [`webdev`][] continues to run,
it tracks which Dart files change,
and dartdevc recompiles only the modules that are affected by those changes.


### Subsequent compilations are taking a long time to run

Are the implementation files for your package under `lib/src`?
If not, dartdevc is probably creating too many modules.
For more information, see
[How the modules are created.](#how-the-modules-are-created)


### Producing too many JavaScript files

This happens when dartdevc is creating too many modules.
Are the implementation files for your package under `lib/src`?
For more information, see
[How the modules are created.](#how-the-modules-are-created)


### Doesn't lazily load deferred libraries

[Lazily loading libraries][] is a production use case,
and dartdevc isn't intended for production code.
However, dartdevc validates that
when code uses a deferred library,
that code first calls `loadLibrary()`.

[Lazily loading libraries]: /guides/language/language-tour#lazily-loading-a-library


## Modules

### JavaScript module overview

When you use dartdevc, modules are an implementation detail.

The dartdevc creates several JavaScript modules,
each of which contains code generated from one or more Dart files.
When you edit your Dart files,
webdev recompiles only the affected modules, instead of your whole app.
The result is a much quicker edit-refresh cycle.

By contrast, when you use dart2js,
dart2js creates one JavaScript file for the entire app.

If you'd like to know more about JavaScript modules,
see Preethi Kasireddy's
[beginner's guide](https://www.freecodecamp.org/news/javascript-modules-a-beginner-s-guide-783f7d7a5fcc) or
Addy Osmani’s
[article on writing modular JavaScript.](https://addyosmani.com/writing-modular-js/)


### How the modules are created

When you use a webdev command with dartdevc,
a heuristic that's based on package structure
determines which modules the webdev command creates:

* One module for each Dart file that’s under `lib`, but not under `lib/src`. <br>
  These are the Dart files that are part of the package's public API,
  and can be imported by other packages.

* One module for each Dart file that’s not under `lib` and
  that contains a top-level `main()` function. <br>
  For example, `web/main.dart` gets its own module.

* One module for each Dart file that’s not imported by one of the above.

{% comment %}This currently isn't true: https://github.com/dart-lang/site-webdev/pull/1426#discussion_r176868668
* Shared modules. <br>
  The webdev tool produces a minimum set of shared modules,
  taking care not to introduce cycles.
  {% endcomment %}

Any Dart file that is imported ends up either
directly in the importing file’s module
or (if it’s imported more than once) in a shared module.

These rules ensure that no Dart file is compiled into more than one module.
Importing only from `lib` and not `lib/src`
minimizes the amount of code that your app loads.


### What kind of modules dartdevc produces

When run with [webdev][], dartdevc generates
[AMD modules.](https://github.com/amdjs/amdjs-api/blob/master/AMD.md#amd)
dartdevc can also generate
[ES6 (Harmony)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) and
[CommonJS (Node)](https://nodejs.org/docs/latest/api/modules.html#modules_modules)
modules, but these options aren't currently supported by the
[build_web_compilers][] package
used with the [build_runner][] and [webdev][] tools.


## Resources

For more information, see the following:

* [Debugging Dart web apps](/web/debugging) to learn more about using
  the [`webdev`][] tool and [Dart DevTools](/tools/dart-devtools)
  to debug your web application with dartdevc.
* [Web deployment](/web/deployment) to learn how to build your Dart web app
  for production deployment once done developing.


[build]: /tools/webdev#build
[build_runner]: /tools/build_runner
[build_web_compilers]: https://github.com/dart-lang/build/tree/master/build_web_compilers
[dart2js]: /tools/dart2js
[dartdevc issue]: https://github.com/dart-lang/sdk/issues/new?title=[dartdevc]%20
[serve]: /tools/webdev#serve
[test]: /tools/webdev#test
[`webdev`]: /tools/webdev
