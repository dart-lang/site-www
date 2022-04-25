---
title: "dart2js: Dart-to-JavaScript compiler"
short-title: dart2js
description: The dart2js compiler compiles Dart code to deployable JavaScript.
---

{{site.alert.version-note}}
  The `dart2js` command-line tool is deprecated as of Dart 2.17
  and will be removed in a future release.
  
  Use [`dart compile js`](/tools/dart-compile#js) 
  or the [`webdev`][] tool
  to compile Dart code to deployable JavaScript.
{{site.alert.end}}

Use the _dart2js_ compiler to compile Dart code to deployable JavaScript.
Another Dart-to-JavaScript compiler, [dartdevc][], is for development use only.
The [`webdev build`][] command uses dart2js by default.
The [`webdev serve`][] command uses dartdevc by default, but you can switch
to dart2js using the `--release` flag.

The dart2js compiler provides hints and warnings
for improving your Dart code.
Also see [`dart analyze`](/tools/dart-analyze),
which performs further analysis.

This page tells you how to use the dart2js compiler.
It also give tips on debugging the JavaScript that dart2js generates.

## Basic usage

Here’s an example of compiling a Dart file to JavaScript:

```terminal
$ dart compile js -O2 -o test.js test.dart
```

This command produces a file that contains
the JavaScript equivalent of your Dart code. 
It also produces a source map, 
which can help you debug the
JavaScript version of the app more easily.

{{site.alert.note}}
  The <code>-O<em>n</em></code> argument specifies the optimization level.
  We recommend starting at `-O1` (the default) 
  and then increasing to `-O2` or higher when you're ready to deploy.
  The `-O3` and `-O4` optimization levels are suitable only for
  **well tested code** 
  ([see the <code>-O<em>n</em></code> descriptions, below](#basic-options)).
{{site.alert.end}}


## Build config usage

You can also configure dart2js options in a build config file
when using the [`webdev`][] tool or [build_runner][].
For more information,
see the [build_web_compilers package.][build_web_compilers]

## Options

* [Basic options](#basic-options)
* [Path and environment options](#path-and-environment-options)
* [Display options](#display-options)
* [Analysis options](#analysis-options)

#### Basic options

Common options for the dart2js compiler include:

`-o <file>` or `--output=<file>`
: Generates the output into `<file>`. 
  If not specified, the output goes in a file named `out.js`.

`--enable-asserts`
: Enables assertion checking.

`-O{0|1|2|3|4}`
: Controls optimizations that can help reduce code size and
  improve performance of the generated code.
  For more details on these optimizations, 
  run `dart compile js -hv`.

  * `-O0`: Disables many optimizations.
  * `-O1`: Enables default optimizations.
  * `-O2`: Enables `-O1` optimizations, plus additional ones
    (such as minification) that respect the language semantics and
    are safe for all programs.
    {{site.alert.note}}
      With `-O2`, string representations of types are no longer the same as
      those in the Dart VM and when compiled with [dartdevc][].
    {{site.alert.end}}
  * `-O3`: Enables `-O2` optimizations, plus omits implicit type checks.
    {{site.alert.warning}}
      Omitting type checks can cause your app to crash due to type errors.
      Before using `-O3`, **test using `-O2`** to ensure that your app
      **never** throws a subtype of `Error` (such as `TypeError`).
    {{site.alert.end}}
  * `-O4`: Enables more aggressive optimizations than `-O3`,
    but with the same assumptions.
    {{site.alert.warning}}
      The `-O4` optimizations are susceptible to variations in input data.
      Before relying on `-O4`, **test for edge cases in user input**.
    {{site.alert.end}}

`--no-source-maps`
: Do not generate a source map file.

`-h` or `--help`
: Displays help. To get information about all options, use `-hv`.


#### Path and environment options

Some other handy options include:

`--packages=<path>`
: Specifies the path to the package resolution configuration file.
  For more information, see
  [Dart Package Configuration File.][]

`-D<flag>=<value>`
: Defines an environment variable.

`--version`
: Displays version information for dart2js.


#### Display options

The following options help you control the output of dart2js:

`--suppress-warnings`
: Doesn't display warnings.

`--suppress-hints`
: Doesn't display hints.

`--terse`
: Emits diagnostics, 
  without suggesting how to get rid of the diagnosed problems.

`-v` or `--verbose`
: Displays lots of information.


#### Analysis options

The following options control the analysis that dart2js performs on Dart code:

`--fatal-warnings`
: Treat warnings as compilation errors.

`--enable-diagnostic-colors`
: Adds colors to diagnostic messages.

`--show-package-warnings`
: Shows warnings and hints generated from packages.

`--csp`
: Disables dynamic generation of code in the generated output.
  This is necessary to satisfy CSP restrictions
  (see [W3C Content Security Policy.](https://www.w3.org/TR/CSP/))

`--dump-info`
: Generates a file (with the suffix `.info.json`)
  that contains information about the generated code.
  You can inspect the generated file with the
  [Dump Info Visualizer.](https://github.com/dart-lang/dump-info-visualizer)


## Helping dart2js generate better code {#helping-dart2js-generate-efficient-code}

Follow these practices to help dart2js do better type inference, 
so it can generate smaller and faster JavaScript code:

* Don't use `Function.apply()`.
* Don't override `noSuchMethod()`.
* Avoid setting variables to `null`.
* Be consistent with the types of arguments
  you pass into each function or method.

{{site.alert.tip}}
  Don’t worry about the size of your app’s included libraries. 
  The dart2js compiler performs tree shaking to omit
  unused classes, functions, methods, and so on.
  Just import the libraries you need, 
  and let dart2js get rid of what you don’t need.
{{site.alert.end}}


## Debugging {#debugging}

This section gives tips for debugging dart2js-produced code
in Chrome, Firefox, and Safari. 
Debugging the JavaScript produced by dart2js is easiest in
browsers such as Chrome that support source maps.

{{site.alert.tip}}
  Whenever possible, instead of debugging dart2js-produced code,
  [debug dartdevc-produced code][debugging web apps].
{{site.alert.end}}

Whichever browser you use, you should enable pausing on at least
uncaught exceptions, and perhaps on all exceptions. 
For frameworks such as `dart:async` that wrap user code in try-catch, 
we recommend pausing on all exceptions.

[debugging web apps]: /web/debugging


### Chrome {#dart2js-debugging-chrome}

To debug in Chrome:

1. Open the Developer Tools window, as described in the
   [Chrome DevTools documentation.](https://developer.chrome.com/docs/devtools/)
2. Turn on source maps, as described in the video
   [SourceMaps in Chrome.](https://bit.ly/YugIUY)
3. Enable debugging, either on all exceptions or only on uncaught exceptions,
   as described in
   [How to set breakpoints.](https://developer.chrome.com/docs/devtools/javascript/breakpoints/)
4. Reload your app.

### Edge {#dart2js-debugging-ie}

To debug in Edge:

1. Update to the latest version of Edge. 
2. Load **Developer Tools** (**F12**). For more information, see
   [Using the F12 developer tools.](https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide-chromium/landing/)
3. Reload the app. The **debugger** tab shows source-mapped files.
4. Exception behavior can be controlled through **Ctrl+Shift+E**;
   the default is **Break on unhandled exceptions**.

### Firefox {#dart2js-debugging-firefox}

To debug in Firefox:

1. Open the **Web Developer Tools** window, as described in the
   [Firefox developer tools documentation](https://firefox-source-docs.mozilla.org/devtools-user/index.html).
2. Enable **Pause on exceptions**, as shown in the following figure:
   
   <img width="640px" src="/assets/img/ff-debug.png" alt="Enable Pause on exceptions in Firefox debugger">
   
3. Reload the app. The **Debugger** tab shows source-mapped files.

### Safari {#dart2js-debugging-safari}

To debug in Safari:

1. Turn on the **Develop** menu, 
   as described in the [Safari Web Inspector Tutorial.](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/Web_Inspector_Tutorial/EnableWebInspector/EnableWebInspector.html)
2. Enable breaks, either on all exceptions or only on uncaught exceptions.
   See [Add a JavaScript breakpoint](https://support.apple.com/en-ca/guide/safari-developer/add-a-javascript-breakpoint-dev5e4caf347/mac) under [Safari Developer Help.](https://support.apple.com/en-ca/guide/safari-developer/welcome/mac)
3. Reload your app.

[build_runner]: /tools/build_runner
[build_web_compilers]: {{site.pub-pkg}}/build_web_compilers
[config]: /tools/build_runner#config
[dartdevc]: /tools/dartdevc
[`webdev`]: /tools/webdev
[`webdev build`]: /tools/webdev#build
[`webdev serve`]: /tools/webdev#serve

[Dart Package Configuration File.]: https://github.com/dart-lang/language/blob/master/accepted/2.8/language-versioning/package-config-file-v2.mdx
