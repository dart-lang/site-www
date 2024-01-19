---
title: Web libraries and packages
short-title: Web libraries
description: Libraries and packages that can help you write Dart web apps.
---

The [Dart SDK][] contains [dart:html][] and other libraries
that provide low-level web APIs.
You can supplement or replace these APIs using web packages.

[Dart SDK]: /tools/sdk
[dart:html]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/dart-html-library.html


## SDK libraries

The Dart SDK contains dart:html and other libraries
that provide low-level web APIs.

[Build a web app with Dart](/web/get-started)
: A quick overview of how to build, run, and debug a web app with Dart.

[The dart:html documentation](/libraries/dart-html)
: An example-driven tour of using the dart:html library.
  Topics include manipulating the DOM programmatically,
  making HTTP requests, and using WebSockets.

[dart:html API reference][dart:html]
: Complete reference documentation for the dart:html library.


## Web packages

Many [packages](/guides/packages) support web development with Dart.
In particular, the [Flutter framework][flutter] has [web support][flutter-web],
in addition to mobile, desktop, and embedded device support.

To find more libraries that support writing web apps, 
search pub.dev for [web packages][].

Your Dart code can also interact with existing
JavaScript or TypeScript libraries
using Dart's [JavaScript interoperability][] support.

[flutter]: {{site.flutter}}
[flutter-web]: {{site.flutter}}/web
[js]: {{site.pub-pkg}}/js
[JavaScript interoperability]: /interop/js-interop
[web packages]: {{site.pub}}/web
