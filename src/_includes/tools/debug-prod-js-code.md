## Debugging production code {#debugging}

This section gives tips for debugging production-compiled code
in Chrome, Firefox, and Safari. You can only debug JavaScript code in
browsers that support source maps such as Chrome.

{{site.alert.tip}}
  Whenever possible, instead of debugging production code,
  debug code using a development server such as provided by [`webdev`][].
{{site.alert.end}}

[`webdev`]: /tools/webdev

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
2. Load **Developer Tools** (**[F12](https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide-chromium/landing/)**).
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