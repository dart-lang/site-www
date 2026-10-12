---
title: Debugging Dart web apps
shortTitle: Debugging web apps
breadcrumb: Debugging
description: Learn how to debug your Dart web app.
---

You can debug Dart web apps using your [Dart IDE][IDE], [Dart DevTools][],
and browser tools such as [Chrome DevTools][].

* **App logic and state:** Use your IDE's built-in debugger or Dart DevTools
  to set breakpoints in `.dart` files, inspect variables, and evaluate Dart
  expressions.
* **DOM, CSS, and network activity:** Use browser developer tools such as
  [Chrome DevTools][].

## Debug in an IDE

The fastest way to debug a Dart web app during development is from a
[Dart-enabled IDE][IDE] (such as VS Code or IntelliJ IDEA): open your project,
set breakpoints in the editor margin, and start a debug session.
The editor compiles your app with `dartdevc`, launches Chrome, and attaches the
debugger automatically.

To inspect source-mapped Dart files directly in Chrome DevTools at any time,
press <kbd>Control</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd>
(<kbd>Command</kbd>+<kbd>Option</kbd>+<kbd>I</kbd> on macOS).
Chrome uses [source maps][] to display your original `.dart` source files
instead of compiled JavaScript or WebAssembly.

## Debug from the command line with Dart DevTools {:#using-dart-devtools}

To debug from the command line using the latest [Dart SDK][] and
[Google Chrome][Google Chrome], install the [`webdev`][webdev] CLI tool globally
with [`dart install`][dart install]:

```console
$ dart install webdev
```

:::note
Whenever you update the Dart SDK, re-run `dart install webdev` so `webdev`
matches your active SDK version.
:::

![Dart DevTools debugger showing source code and breakpoints](/assets/img/dart-devtools-screenshot.png)

1. In your [Dart web app][] root directory, fetch package dependencies:

   ```console
   $ dart pub get
   ```

1. Start the development server in debug mode (optionally pass `--auto restart`
   to hot-restart on file changes):

   * **Launch a new debug instance of Chrome:**

     ```console
     $ webdev serve --debug --auto restart
     ```

   * **Use an existing Chrome window** (requires the
     [Dart Debug Extension][]):

     ```console
     $ webdev serve --debug-extension --auto restart
     ```

1. Open `http://localhost:8080` in Chrome if it isn't already open.

1. Open **Dart DevTools**:

   * With `--debug`, press <kbd>Alt</kbd>+<kbd>D</kbd>
     (<kbd>Option</kbd>+<kbd>D</kbd> on macOS).
   * With `--debug-extension`, click the Dart icon
     <img src="/assets/img/logo/dart-64.png" alt="Dart logo" class="align-baseline text-icon">
     in the Chrome toolbar.

1. In the **Debugger** tab, click a line number in your `.dart` file to set a
   breakpoint, then trigger that code path in your app.
   When execution pauses, inspect variables in the **Variables** pane and step
   through code using **Step In**, **Step Over**, and **Step Out**.

   :::note
   Dart DevTools skips stepping into SDK implementation code by default
   (for example, stepping into `print()` advances to the next line in your app).
   :::

1. Open the **Logging** view to inspect `stdout`, `stderr`, and system events.

## Running web tests and collecting coverage

To run browser unit tests, pass `-p` (`--platform`) to
[`dart test`][dart test]:

```console
$ dart test -p chrome
```

You can also target Firefox (`-p firefox`) or Safari (`-p safari`).

To pause execution after loading so you can open browser DevTools and set
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

Chrome, Edge, Firefox, and Safari all support source maps for both JavaScript
(`.js.map`) and WebAssembly (`.wasm.map`) production builds.

:::tip
Whenever possible, debug development builds (`webdev serve --debug`) instead of
production code—optimizations inline functions and minify symbols.
:::

When compiling to WebAssembly with [`dart compile wasm`][dart compile wasm],
the compiler emits a `<name>.wasm.map` source map alongside `<name>.wasm` by
default.
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

1. Open [Chrome DevTools][].
1. Confirm that source maps are enabled (on by default), as described in
   [Map preprocessed code to source code][source maps].
1. Enable pausing on all exceptions or uncaught exceptions, as described in
   [Pause your code with breakpoints][chrome-breakpoints].
1. Reload your app.

### Edge {:#dart2js-debugging-ie}

1. Open [**Developer Tools**][edge-devtools] (<kbd>F12</kbd>).
1. Reload your app. The **Debugger** tab displays source-mapped `.dart` files.
1. Toggle exception pausing with <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd>
   (defaults to **Break on unhandled exceptions**).

### Firefox {:#dart2js-debugging-firefox}

1. Open the [**Firefox Web Developer Tools**][firefox-devtools].
1. Enable **Pause on exceptions**:

   ![Enable Pause on exceptions in Firefox debugger](/assets/img/ff-debug.png)

1. Reload your app to view source-mapped files in the **Debugger** tab.

### Safari {:#dart2js-debugging-safari}

1. Turn on the **Develop** menu, as described in
   [Enabling Web Inspector][safari-web-inspector].
1. Enable breakpoints on all exceptions or uncaught exceptions—see
   [Add a JavaScript breakpoint][safari-breakpoints] in
   [Safari Developer Help][safari-dev-help].
1. Reload your app.

## Resources

* [Dart IDEs and editors][IDE]
* [Dart DevTools documentation][Dart DevTools]
* [`webdev` tool documentation][webdev]
* [`webdev` package on pub.dev][webdev-pkg]

[Chrome DevTools]: https://developer.chrome.com/docs/devtools/
[chrome-breakpoints]: https://developer.chrome.com/docs/devtools/javascript/breakpoints/
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
[webdev-pkg]: {{site.pub-pkg}}/webdev
