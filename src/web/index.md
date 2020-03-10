---
title: Web platform
short-title: Web
description: Resources for developing Dart web apps.
toc: false
---

Dart supports the web as one of its core [platforms](/platforms).
Dart-to-JavaScript compilers are available both for development
(with a quick edit-refresh cycle)
and for production
(with a focus on code size and speed).

In addition to compilers,
the Dart web platform provides [core libraries][],
access to the [DOM (Document Object Model)][DOM],
and [interoperability for calling JavaScript][interop] from Dart.

You have the option of using Dart web with a higher-level web app framework.
Several web apps at Google
(including the [Google Ads front end formerly known as AdWords][AdWords])
are built using [AngularDart.][]
Many apps that support both web and mobile are built
using [Flutter][] and [Flutter web][] support.
AngularDart,
Flutter web support,
and other web app frameworks for Dart are powered by the Dart web platform.

<p class="text-center">
  <a href="/tutorials/web/get-started" class="btn btn-primary btn-lg">Get started</a>
</p>

<p class="text-center">
  <br>
  <img src="{% asset flutter-gallery.jpg @path %}"
    alt="screenshot of Flutter Gallery">
  <br>
  <em>Flutter Gallery, running in a web browser</em>
</p>

[AdWords]: {{site.news}}/2016/03/the-new-adwords-ui-uses-dart-we-asked.html
[AngularDart.]: {{site.angulardart}}
[core libraries]: /guides/libraries#web-platform-libraries
[DOM]: /tutorials/web/low-level-html/connect-dart-html
[Flutter]: {{site.flutter}}
[Flutter web]: {{site.flutter}}/web
[interop]: /web/js-interop
