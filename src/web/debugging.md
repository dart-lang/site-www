---
title: Debugging Dart web apps
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

```terminal
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
instead of the JavaScript that the compiler produces.
For more information on using Chrome DevTools,
see the [Chrome DevTools documentation.][Chrome DevTools]

[source maps]: https://developer.chrome.com/docs/devtools/javascript/source-maps/

To use the Dart DevTools or Chrome DevTools
to debug a Dart web app, you need the following software:

* [Google Chrome.][Google Chrome]
* [Dart SDK][], version 2.0.0 or higher.
* One of the following development environments:
  * Command-line: [Dart command-line tool packages][cl-tools]
    such as webdev (required for both Dart and Chrome DevTools) and
    devtools (required for Dart DevTools).
    <br>_or_
  * A [Dart IDE or editor][IDE] that supports web development.
* A [Dart web app][] to debug.

[cl-tools]: #getting-command-line-tool-packages

## Getting started with Dart DevTools {#using-dart-devtools}

<img src="/assets/img/dart-devtools-screenshot.png" alt="DevTools">

This section leads you through the basics of
using Dart DevTools to debug a web app.
If you already have an app that's ready to debug,
you can skip creating the test app (step 1),
but you'll need to adjust the instructions to match your app.

1. _Optional:_ Clone the [webdev repo,][] so you can use its example app
   to play with Dart DevTools.

1. _Optional:_ Install the [Dart Debug Extension][]
   so that you can run your app and open the Dart DevTools
   in an already-running instance of Chrome.

1. In your app's top directory, run `dart pub get` to get its dependencies.

   ```terminal
   $ cd example
   $ dart pub get
   ```

1. Compile and serve the app in debug mode,
   using either your IDE or `webdev` at the command line.

   {{site.alert.note}}
     The first compilation takes the longest,
     because the entire app must be compiled.
     After that, refreshes are much faster.
   {{site.alert.end}}

   If you're using webdev at the command line,
   the command to use depends on whether you want (or need) to
   run the app and debugger in an already-running instance of Chrome.

   * If you have [Dart Debug Extension][] installed and want to use
     an existing instance of Chrome to debug:

     ```terminal
     $ webdev serve --debug-extension
     ```

   * Otherwise, use the following command, 
     which launches a new instance of Chrome
     and runs the app:

     ```terminal
     $ webdev serve --debug
     ```

1. If your app isn't already running, open it in a Chrome browser window.
   <br>
   For example, if you use `webdev serve --debug-extension` with no arguments,
   open [http://127.0.0.1:8080](http://http://127.0.0.1:8080){: .no-automatic-external}.

1. Open Dart DevTools to debug the app that's running in the current window.

   * If Dart Debug Extension is installed and
     you used the `--debug-extension` flag to `webdev`,
     click the Dart logo
     <img src="/assets/shared/dart/icon/64.png" width="16" alt="Dart logo" class="align-baseline">
     at the top right of the browser window.
     
   * If you used the `--debug` flag to `webdev`,
     press <kbd>Alt</kbd>+<kbd>D</kbd>
     (or <kbd>Option</kbd>+<kbd>D</kbd> on macOS).
   
   The Dart DevTools window comes up
   and displays the source code for your app's main file.

1. Set a breakpoint inside a timer or event handler
   by clicking to the left of one of its lines of code.
   <br>
   For example, click the line number for the first line inside
   an event handler or timer callback.

1. Trigger the event that causes the function call.
   Execution stops at the breakpoint.

1. In the **Variables** pane, inspect the values of variables.

1. Resume script execution, and trigger the event again or press **Pause**.
   Execution pauses again.

1. Try stepping through code line-by-line using the
   **Step In**, **Step Over**, and **Step Out** buttons.

   {{site.alert.note}}
     Dart DevTools doesn't step into SDK code.
     For example, if you press **Step In** at a call to `print()`,
     you go to the next line, not into the SDK code that implements `print()`.
   {{site.alert.end}}

1. Change your source code and reload the Chrome window that's running the app.
   The app quickly rebuilds and reloads.
   Until [issue 1925][] is fixed,
   you lose your breakpoints when reloading the app.

1. Click the **Logging** button to see stdout, stderr, and system logs.


## Getting command-line tool packages

If you're using the command line instead of an IDE or Dart-enabled editor,
then you need the [webdev tool][webdev].
Dart DevTools is provided by the SDK.

```terminal
$ dart pub global activate webdev
```

If your PATH environment variable is set up correctly,
you can now use these tools at the command line:

```terminal
$ webdev --help
A tool to develop Dart web projects.
...
```

For information on setting PATH, see the
[`dart pub global` documentation.][dart pub global documentation]

Whenever you update the Dart SDK,
update the tools by activating them again:

```terminal
$ dart pub global activate webdev     # update webdev
```

{% include tools/debug-prod-js-code.md %}

## Resources

To learn more, see the following:

* Documentation for [your IDE][IDE]
* [Dart DevTools documentation][Dart DevTools]
* [webdev tool documentation][webdev]
* [webdev package documentation][webdev-pkg]

[Chrome DevTools]: https://developer.chrome.com/docs/devtools/
[Dart Debug Extension]: https://chrome.google.com/webstore/detail/dart-debug-extension/eljbmlghnomdjgdjmbdekegdkbabckhm
[Dart DevTools]: /tools/dart-devtools
[IDE]: /tools#ides-and-editors
[Dart SDK]: /get-dart
[Dart web app]: /web
[Google Chrome]: https://www.google.com/chrome
[issue 1925]: https://github.com/flutter/devtools/issues/1925
[JavaScript debugging reference]: https://developer.chrome.com/docs/devtools/javascript/reference/
[dart pub global documentation]: /tools/pub/cmd/pub-global
[webdev]: /tools/webdev
[webdev repo,]: https://github.com/dart-lang/webdev
[webdev-pkg]: {{site.pub-pkg}}/webdev
