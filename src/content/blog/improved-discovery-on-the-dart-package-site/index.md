---
title: "Improved discovery on the Dart package site"
description: "Back in July we talked about our changes to the Dart package site (http://pub.dartlang.org), which included better support for analyzing…"
publishDate: 2018-09-24
author: mit-mit
image: images/1wh9C-VJUKEYz4l2zpUkg4A.png
category: other
tags:
  - dart
  - flutter
layout: blog
---


Back in July we talked about [our changes](https://medium.com/dartlang/getting-ready-for-dart-2-and-making-your-packages-look-great-on-the-pub-site-118464d7f59d) to the Dart package site ([http://pub.dartlang.org](http://pub.dartlang.org)), which included better support for analyzing packages for potential issues. Since then we’ve focused on further improvements to discovering content on the package site.

## Dart 2 incompatibility

The vast majority of recent & popular packages have been [migrated to support Dart 2](https://www.dartlang.org/dart-2#migration), so they are ready for [Flutter](https://flutter.io/) and [AngularDart](https://webdev.dartlang.org/angular) 5 apps. However some packages — mostly older ones not being maintained — still don’t support Dart 2. To make sure you can easily spot these, we now add Dart 2 incompatibility tags to the overview and package detail pages.

<DashImage src="images/1wh9C-VJUKEYz4l2zpUkg4A.png" alt="Packages incompatible with Dart 2 are clearly marked ‘Dart 2 incompatible’" caption="Packages incompatible with Dart 2 are clearly marked ‘Dart 2 incompatible’" />


Also, we anticipate that we will be archiving/discontinuing these incompatible packages in a future version of the package site, so if you are an author of a package marked ‘Dart 2 incompatible’, please consider migrating it soon!

## Support for core libraries

Dart comes with a rich set of core (standard) libraries. Developers have told us that it can be hard to remember if a particular utility function is in a core library or in a package. To help you find the API you need, searches on pub.dartlang.org now include not just published packages, but also core libraries. Search results from core libraries have **sdk** in the score circle, and the annotation **Dart core library**. If you click the entry, you go directly to the library API documentation.

<DashImage src="images/1Q9oEytibPnPy23qiSliyyQ.png" alt="Search hits in SDK core libraries are included among the results" caption="Search hits in SDK core libraries are included among the results" />


## Package update feed

Pub has provided an Atom feed for a while; to make this more discoverable we’ve added a direct link in the site footer.

<DashImage src="images/01rSptJGr3iaTKqvb.png" />


## Scoring changes

We’ve made a number of simplifications and adjustments to the scoring model for health and maintenance. For an overview of the current model, please see the [pana README](https://github.com/dart-lang/pana/blob/master/README.md) (pana is the tool that provides the scoring).

In the future, we plan to improve transparency by showing how much each reported issue reduced the overall score directly on the package analysis page.

## Feedback welcome

Found an issue? Have a cool idea or suggestion? Please tell us by [opening an issue](https://github.com/dart-lang/pub-dartlang-dart/issues/new?body=URL%3A+https%3A%2F%2Fpub.dartlang.org%2F%0A%0A%3CDescribe+your+issue+or+suggestion+here%3E&title=%3CSummarize+your+issues+here%3E&labels=Area%3A+site+feedback) in our tracker. Also note that even the package site itself is crafted as open-source in the [pub-dartlang-dart repo](https://github.com/dart-lang/pub-dartlang-dart), and contributions and ideas are most welcome!