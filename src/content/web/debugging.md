---
title: Debugging Dart web apps
shortTitle: Debugging web apps
breadcrumb: Debugging
description: Learn how to debug your Dart web app.
---

You can use a [Dart IDE][IDE], [Dart DevTools][], and browser tools
such as [Chrome DevTools][] to debug your Dart web apps.

* To debug your app's logic,
  use your IDE, Dart DevTools, or browser tools.
  Dart DevTools has better support than browser tools
  for inspecting and automatically reloading Dart code.
* To debug your app's appearance (HTML/CSS) and performance,
  use your IDE or browser tools such as Chrome DevTools.


## Overview

To serve your app, use `webdev serve`
(either at the command line or through your IDE)
to start up the Dart development compiler.
To enable Dart DevTools, add the `--debug` or `--debug-extension` option
(at the command line or through your IDE):

```console
$ webdev serve --debug
```

When running your app using the `--debug` flag of `webdev`,
you can open Dart DevTools by pressing
<kbd>Alt</kbd>+<kbd>D</kbd>
(or <kbd>Option</kbd>+<kbd>D</kbd> on macOS).

To open Chrome DevTools, press <kbd>Control</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd>
(or <kbd>Command</kbd>+<kbd>Option</kbd>+<kbd>I</kbd> on macOS).
If you want to debug your app using Chrome DevTools,
you can use [source maps][] to display your Dart source files
instead of the JavaScript or WebAssembly that the compiler produces.
For more information on using Chrome DevTools,
see the [Chrome DevTools documentation][Chrome DevTools].

To use Dart DevTools or Chrome DevTools
to debug a Dart web app, you need the following software:

* [Google Chrome][Google Chrome].
* The latest [Dart SDK][].
* Either the [`webdev`][cl-tools] command-line tool
  (Dart DevTools comes bundled with the Dart SDK)
  or a [Dart IDE or editor][IDE] that supports web development.
* A [Dart web app][] to debug.

## Getting started with Dart DevTools {:#using-dart-devtools}

![Dart DevTools debugger showing source code and breakpoints](/assets/img/dart-devtools-screenshot.png)

This section leads you through the basics of
using Dart DevTools to debug a web app.
If you already have an app that's ready to debug,
you can skip creating the test app (step 1),
but you'll need to adjust the instructions to match your app.

1. _Optional:_ Clone the [webdev repository][webdev repo],
   so you can use its example app to play with Dart DevTools.

1. _Optional:_ Install the [Dart Debug Extension][]
   so that you can run your app and open Dart DevTools
   in an already-running instance of Chrome.

1. In your app's top directory, run `dart pub get` to get its dependencies.

   ```console
   $ cd example
   $ dart pub get
   ```

1. Compile and serve the app in debug mode,
   using either your IDE or `webdev` at the command line.

   :::note
   The first compilation takes the longest,
   because the entire app must be compiled.
   After that, refreshes are much faster.
   :::

   If you're using `webdev` at the command line,
   the command to use depends on whether you want to
   run the app and debugger in an already-running instance of Chrome.

   * If you have [Dart Debug Extension][] installed and want to use
     an existing instance of Chrome to debug:

     ```console
     $ webdev serve --debug-extension
     ```

   * Otherwise, use the following command,
     which launches a new instance of Chrome
     and runs the app:

     ```console
     $ webdev serve --debug
     ```

1. If your app isn't already running, open it in a Chrome browser window.

   For example, if you use `webdev serve --debug-extension` with no arguments,
   open `http://127.0.0.1:8080`.

1. Open Dart DevTools to debug the app that's running in the current window.

   * If Dart Debug Extension is installed and
     you used the `--debug-extension` flag to `webdev`,
     click the Dart logo
     <img src="/assets/img/logo/dart-64.png" alt="Dart logo" class="align-baseline text-icon">
     at the top right of the browser window.

   * If you used the `--debug` flag to `webdev`,
     press <kbd>Alt</kbd>+<kbd>D</kbd>
     (or <kbd>Option</kbd>+<kbd>D</kbd> on macOS).

   The Dart DevTools window opens
   and displays the source code for your app's main file.

1. Set a breakpoint inside a timer or event handler
   by clicking to the left of one of its lines of code.

   For example, click the line number for the first line inside
   an event handler or timer callback.

1. Trigger the event that causes the function call.
   Execution stops at the breakpoint.

1. In the **Variables** pane, inspect the values of variables.

1. Resume script execution, and trigger the event again or press **Pause**.
   Execution pauses again.

1. Try stepping through code line-by-line using the
   **Step In**, **Step Over**, and **Step Out** buttons.

   :::note
   Dart DevTools doesn't step into SDK code.
   For example, if you press **Step In** at a call to `print()`,
   you go to the next line, not into the SDK code that implements `print()`.
   :::

1. Change your source code and reload the Chrome window that's running the app.
   The app quickly rebuilds and reloads while preserving your breakpoints.

1. Click the **Logging** button to see stdout, stderr, and system logs.


## Getting command-line tool packages

If you're using the command line instead of an IDE or Dart-enabled editor,
install the [`webdev` tool][webdev] globally.
Dart DevTools comes bundled with the Dart SDK.

```console
$ dart install webdev
```

Once installed on your `PATH`, you can run `webdev` at the command line:

```console
$ webdev --help
A tool to develop Dart web projects.
...
```

For details on managing global CLI tools and configuring `PATH`, see the
[`dart install` documentation][dart install].

Whenever you update the Dart SDK,
update `webdev` by running the install command again:

```console
$ dart install webdev
```

## Running web tests and collecting coverage

To run unit tests for your web app in a browser, pass the `-p` (`--platform`)
flag to [`dart test`][dart test]:

```console
$ dart test -p chrome
```

You can also target other browsers such as Firefox (`-p firefox`) or Safari
(`-p safari`).

To pause test execution after loading so you can open browser DevTools and set
breakpoints before your tests run, pass `--pause-after-load`:

```console
$ dart test -p chrome --pause-after-load
```

To collect code coverage for web tests in Chrome, pass `-p chrome` to
`test_with_coverage` from [`package:coverage`][coverage-pkg]:

```console
$ dart run coverage:test_with_coverage -p chrome
```

## Debugging production code {:#debugging}

This section provides tips for debugging production-compiled Dart web apps in
Chrome, Edge, Firefox, and Safari.
All four browsers support source maps for both JavaScript (`.js.map`) and
WebAssembly (`.wasm.map`) production builds.

:::tip
Whenever possible, instead of debugging production code,
debug your app using a development server such as [`webdev`][webdev].
:::

When compiling to WebAssembly with [`dart compile wasm`][dart compile wasm],
the compiler emits a `<name>.wasm.map` source map file alongside `<name>.wasm`
by default.
At optimization level `-O2` and higher, the compiler strips the WebAssembly
`name` custom section to reduce binary size.
Pass `--no-strip-wasm` to preserve human-readable Dart function names in
browser DevTools stack traces and flamecharts:

```console
$ dart compile wasm -O2 --no-strip-wasm web/main.dart -o build/main.wasm
```

Ensure that your web server serves the generated `.js.map` or `.wasm.map` file
alongside the compiled output so the browser can resolve Dart source files.

Whichever browser you use, enable pausing on at least uncaught exceptions.
For frameworks such as `dart:async` that wrap user code in `try`-`catch` blocks,
enable pausing on all exceptions to surface caught errors.

### Chrome {:#dart2js-debugging-chrome}

To debug in Chrome:

1. Open the Developer Tools window, as described in the
   [Chrome DevTools documentation][Chrome DevTools].
1. Confirm that source maps are enabled (on by default), as described in
   [Map preprocessed code to source code][source maps].
1. Enable pausing on all exceptions or only on uncaught exceptions,
   as described in [Pause your code with breakpoints][chrome-breakpoints].
1. Reload your app.

### Edge {:#dart2js-debugging-ie}

To debug in Edge:

1. Update to the latest version of Edge.
1. Open [**Developer Tools**][edge-devtools] (<kbd>F12</kbd>).
1. Reload your app. The **Debugger** tab shows source-mapped files.
1. Toggle exception behavior with
   <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd>;
   the default is **Break on unhandled exceptions**.

### Firefox {:#dart2js-debugging-firefox}

To debug in Firefox:

1. Open the **Web Developer Tools** window, as described in the
   [Firefox developer tools documentation][firefox-devtools].
1. Enable **Pause on exceptions**, as shown in the following figure:

   ![Enable Pause on exceptions in Firefox debugger](/assets/img/ff-debug.png)

1. Reload your app. The **Debugger** tab shows source-mapped files.

### Safari {:#dart2js-debugging-safari}

To debug in Safari:

1. Turn on the **Develop** menu,
   as described in [Enabling Web Inspector][safari-web-inspector].
1. Enable breakpoints on all exceptions or only on uncaught exceptions.
   See [Add a JavaScript breakpoint][safari-breakpoints] in
   [Safari Developer Help][safari-dev-help].
1. Reload your app.

## Resources

To learn more, see the following:

* Documentation for [your IDE][IDE]
* [Dart DevTools documentation][Dart DevTools]
* [webdev tool documentation][webdev]
* [webdev package documentation][webdev-pkg]

[Chrome DevTools]: https://developer.chrome.com/docs/devtools/
[chrome-breakpoints]: https://developer.chrome.com/docs/devtools/javascript/breakpoints/
[cl-tools]: #getting-command-line-tool-packages
[coverage-pkg]: {{site.pub-pkg}}/coverage
[dart compile wasm]: /tools/dart-compile#wasm
[Dart Debug Extension]: https://chromewebstore.google.com/detail/dart-debug-extension/eljbmlghnomdjgdjmbdekegdkbabckhm
[Dart DevTools]: /tools/dart-devtools
[dart install]: /tools/dart-install
[Dart SDK]: /get-dart
[dart test]: /tools/dart-test
[Dart web app]: /web
[edge-devtools]: https://learn.microsoft.com/en-us/microsoft-edge/devtools/landing/
[firefox-devtools]: https://firefox-source-docs.mozilla.org/devtools-user/index.html
[Google Chrome]: https://www.google.com/chrome
[IDE]: /tools#editors
[safari-breakpoints]: https://support.apple.com/guide/safari-developer/add-a-javascript-breakpoint-dev5e4caf347/mac
[safari-dev-help]: https://support.apple.com/guide/safari-developer/welcome/mac
[safari-web-inspector]: https://webkit.org/web-inspector/enabling-web-inspector/
[source maps]: https://developer.chrome.com/docs/devtools/javascript/source-maps/
[webdev]: /tools/webdev
[webdev repo]: {{site.repo.dart.org}}/webdev
[webdev-pkg]: {{site.pub-pkg}}/webdev
