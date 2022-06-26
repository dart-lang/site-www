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

[Low-level web tutorials](/tutorials/web/low-level-html)
: An overview of DOM, CSS, and HTML concepts, with information on
  how to include a Dart script in an HTML page and
  how to add and remove elements from a web page.
  These tutorials feature interactive examples in
  [DartPad.]({{site.dartpad}})

[The dart:html section](/guides/libraries/library-tour) of the library tour
: An example-driven tour of using the dart:html library.
  Topics include manipulating the DOM programmatically,
  making HTTP requests, and using WebSockets.

[dart:html API reference][dart:html]
: Complete reference documentation for the dart:html library.


## Web packages

Many [packages](/guides/packages) support web development with Dart.
In particular, the [Flutter framework][flutter] has [web support][flutter-web],
in addition to mobile, desktop, and embedded device support.

Here are a few packages that are web-specific:

|--------------------+---------------------------------+--------------------------|
| Library            | Package                         | Notes                    |
|--------------------|---------------------------------|--------------------------|
| JavaScript interop | [js][]                          | Support for calling JavaScript libraries from Dart code. More info: [JavaScript interoperability][] |
| Material Design    | [mdc_web][]                     | Bindings for Material Components for the web. |
| Mustache templates | [mustache_template][]           | Support for the Mustache templating language. |
| React              | [react][]                       | Bindings for the ReactJS library. |
{:.table .table-striped}


[angular]: {{site.pub-pkg}}/angular
[flutter]: {{site.flutter}}
[flutter-web]: {{site.flutter}}/web
[js]: {{site.pub-pkg}}/js
[JavaScript interoperability]: /web/js-interop
[mdc_web]: {{site.pub-pkg}}/mdc_web
[mustache_template]: {{site.pub-pkg}}/mustache_template
[react]: {{site.pub-pkg}}/react

To find more libraries that support writing web apps, search pub.dev for
[web packages][].


[web packages]: {{site.pub}}/web
