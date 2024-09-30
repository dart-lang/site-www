---
title: Web libraries and packages
short-title: Web libraries
description: Libraries and packages that can help you write Dart web apps.
---

Dart provides several packages and libraries to support
web app development, the recommended option being [`package:web`][web].
The [Dart SDK][] also contains other libraries that provide low-level web APIs.

## Web solutions

[Migrate to `package:web`][migrate]
: Learn how to migrate to `package:web`
  from Dart's previous web library solutions, like [`dart:html`][html].

[`package:web` API reference][web]
: Dart's recommended web interop solution `package:web` exposes browser
  APIs with lightweight bindings built around static JS interop. 

[JavaScript interoperability documentation][js]
: Learn how to interact with existing JavaScript or TypeScript libraries
  using Dart's JS interop support.

[`dart:js_interop` API reference][js_interop]
: Dart's web library `dart:js_interop` provides all the necessary members to
  facilitate sound interop between JavaScript and Dart types. 

[Flutter web support][flutter-web]
: The [Flutter framework][flutter] supports web development with Dart,
  in addition to mobile, desktop, and embedded device support.

[Build a web app with Dart](/web/get-started)
: A quick overview of how to build, run, and debug a web app with Dart.

To find other libraries that support the web platform,
search pub.dev for [web packages][].

[web]: {{site.pub-pkg}}/web
[Dart SDK]: {{site.dart-api}}/{{site.sdkInfo.channel}}
[migrate]: /interop/js-interop/package-web
[js_interop]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_interop/dart-js_interop-library.html
[flutter-web]: {{site.flutter-docs}}/platform-integration/web
[flutter]: {{site.flutter}}
[web packages]: {{site.pub}}/web
[html]: /libraries/dart-html
[js]: /interop/js-interop