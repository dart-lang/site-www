---
title: Web deployment
description: Learn how to build your Dart web app for production deployment.
---

Deploying a Dart web app works like deploying any other web app.
This page describes how to compile your app, tips for making it smaller
and faster, and points you to resources for serving the app.

## Building your app {:#compiling-to-javascript}

Use the `webdev` tool to build your app. It compiles Dart to JavaScript
and generates all the assets you need for deployment.
When you build using the production mode of the compiler,
you get a JavaScript file that's reasonably small,
thanks to the compiler support for tree shaking.

With a little extra work, you can make your deployable app
[smaller, faster, and more reliable](#make-your-app-smaller-faster-and-more-reliable).

### Compile using webdev

[Use the `webdev build` command][build] to create a deployable version
of your app. This command converts your code to JavaScript and saves
the result as `build/web/main.dart.js`. You can use [any option
available to `dart compile js`](/tools/dart-compile#prod-compile-options)
with `webdev build`.

### Make your app smaller, faster, and more reliable

The following steps are optional. They can help make your app more
reliable and responsive.

* [Use deferred loading to reduce your app's initial size](#use-deferred-loading-to-reduce-your-apps-initial-size)
* [Follow best practices for web apps](#follow-best-practices-for-web-apps)
* [Manage source maps and unneeded build files](#manage-source-maps-and-unneeded-build-files)

#### Use deferred loading to reduce your app's initial size

You can use Dart's support for deferred loading to
reduce your app's initial download size.
For details, see the language tour's coverage of
[deferred loading](/language/libraries#lazily-loading-a-library).

#### Follow best practices for web apps

The usual advice for web apps applies to Dart web apps.
Here are a few resources:

* [Fast load times](https://web.dev/fast/)
* [Web Fundamentals](https://developers.google.com/web/fundamentals/)
  (especially [Optimizing Content Efficiency](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/))
* [Progressive Web Apps](https://web.dev/progressive-web-apps/)
* [Lighthouse](https://developers.google.com/web/tools/lighthouse/)

#### Manage source maps and unneeded build files

By default, Dart web compilers (`dart compile js` and `dart compile wasm`)
generate source map files (`.js.map` and `.wasm.map`)
alongside the compiled output.
While source maps are useful for debugging,
serving them on public web servers can expose sensitive information:

* **Unminified symbols and structure**:
  Source maps allow browser DevTools to reconstruct original class names,
  function names, and source logic.
* **Developer file paths**:
  Source maps often include absolute file system URIs
  (such as `file:///Users/...`) from the build machine.

:::warning
To keep your original source code and local build paths private,
don't deploy source map files to public web hosts.
:::

Depending on your deployment strategy,
you can handle source maps in one of two ways:

* **Disable source maps at build time**:
  If you don't need source maps for production debugging or error reporting,
  pass the `--no-source-maps` flag to the compiler:

  ```console
  $ dart compile js --no-source-maps -O2 -o build/main.js web/main.dart
  $ dart compile wasm --no-source-maps -o build/main.wasm web/main.dart
  ```

* **Exclude or strip map files from public hosting**:
  If you use source maps for private error monitoring services
  (such as Sentry or Bugsnag),
  keep the `.map` files during compilation
  and upload them directly to your monitoring service.
  Then, exclude or remove them from your public web server or CDN directory:

  ```console
  # From the root directory of your app:
  $ find build -type f \( -name "*.js.map" -o -name "*.wasm.map" \) -exec rm {} +
  ```

## Serving your app

You can serve your Dart Web app just like you'd serve any other web app.
This section points to tips for serving Dart Web apps,
as well as Dart-specific resources to help you use GitHub Pages or Firebase
to serve your app.

### GitHub Pages

If your app doesn't use routing or require server-side support,
you can serve the app using [GitHub Pages](https://pages.github.com/).
The [peanut][] package is
an easy way to automatically produce a gh-pages branch for any Dart web app.

The [startup_namer example](https://filiph.github.io/startup_namer/)
is hosted using GitHub Pages.
Its files are in the **gh-pages** branch of the
[filiph/startup_namer repo](https://github.com/filiph/startup_namer)
and were built using [peanut.][peanut]

### Firebase
{% comment %}
TODO: Give an example of how to deploy with Firebase, which originally was shown on https://dart.academy/build-a-real-time-chat-web-app-with-dart-angular-2-and-firebase-3/
{% endcomment %}

To learn more about deploying with Firebase, see the following resources:

* The [Firebase Hosting documentation](https://firebase.google.com/docs/hosting/)
  describes how to deploy web apps with Firebase.
* In the Firebase Hosting documentation,
  [Configure Hosting Behavior](https://firebase.google.com/docs/hosting/full-config)
  covers redirects, rewrites, and more.

[build]: /tools/webdev#build
[build_runner]: /tools/build_runner
[build_web_compilers]: {{site.pub-pkg}}/build_web_compilers
[config]: /tools/build_runner#config
[peanut]: {{site.pub-pkg}}/peanut
[webdev]: /tools/webdev
