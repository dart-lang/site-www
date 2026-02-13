---
title: "Getting ready for Dart 2, and making your packages look great on the Pub site!"
description: "We have a new release of Pub, the package repository for Dart! This time around we focused on preparing for the Dart 2 stable release."
publishDate: 2018-07-20
author: "mit-mit"
image: images/0Fq4FHYc9N5aHmYBK.png
category: other
tags:
  - github
  - dartlang
---


<DashImage src="images/1zpVgP0W04QFmqqaJO9fzhg.png" />


## Migrating your packages to Dart 2

We expect the Dart 2 release to graduate to stable in the immediate future! Thus, it’s critical that you [migrate your code](https://www.dartlang.org/dart-2#migration) — especially any packages you have published — to be Dart 2 compatible. There are three main aspects to this:

* Make sure your code passes Dart 2 analysis ([details](https://www.dartlang.org/dart-2#general-process)). We recommend you also pay attention to hints — for example, to prepare for deprecations.

* Run tests to make sure your code passes Dart 2 runtime checks ([details](https://www.dartlang.org/guides/language/sound-problems#runtime-errors)).

* Update the upper bound of the SDK constraint of your packages to `&lt;3.0.0` ([details](https://www.dartlang.org/dart-2#upper-constraints-on-the-sdk-version)).

We strongly encourage all package authors to do this work, and we will be pushing hard ourselves on the packages we own over the next few days.

## Improved analysis UI on the Pub site

To help with this migration we have updated the analysis tab of the Pub site to make the results of code analysis easier to read. First, at the top of the analysis page we added progress bars allowing you to quickly see the status of the package:

<DashImage src="images/0LatYAFujtrM2yebc.png" alt="Package scores shown on the Pub site" caption="Package scores shown on the Pub site" />


Below the progress bars are detailed analysis results, grouped by severity: errors (red icon), warnings (yellow icon), and suggested issues (blue icon), as shown in the following screenshot:

<DashImage src="images/0Fq4FHYc9N5aHmYBK.png" alt="Analysis issues shown on the Pub site" caption="Analysis issues shown on the Pub site" />


## Updated analysis scores

We also made some tweaks to the analysis score. We now lower the score of a package if any of the following are true:

* The package doesn’t pass Dart 2 analysis.

* The upper SDK constraint isn’t at least `&lt;3.0.0`.

* API reference generation ([dartdoc](https://www.dartlang.org/guides/language/effective-dart/documentation)) fails.

For our next Pub site release we expect to work on some further refinement of the scores, and to add some documentation for how the scores are calculated.

## Searching the API surface of a package

Searching is — not too surprisingly — the most popular feature of the Pub site. We have made a number of improvements in this area over the past few quarters, focused on adding platform filters and better ranking. The new release extends search with support for searching the API surface of a package. In addition to the current search indexing of the package’s description and `README.md` content, search now covers all the public API members of the package, plus the API documentation for those members! This is great when you want to locate something that isn’t mentioned in the descriptions and `README.md` files.

For example, let’s say you’re looking for a package that can format strings using the [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217) currency format. A search in description and README.md files gives you [a single result](https://pub.dartlang.org/packages?q=4217&api=0), but a search that includes API documentation gives you [several results](https://pub.dartlang.org/packages?q=4217):

```
10 results for 4217

intl

Contains code to deal with internationalized/localized messages, date and number formatting and parsing, bi-directional text, and other internationalization issues.

v 0.15.2 • Updated: Oct 19, 2017 FLUTTER WEB OTHER

API results:

intl/NumberFormat-class.html

flutter_billing

A flutter plugin to communicate with billing on iOS and Android.

v 0.1.2 • Updated: Feb 10, 2018 FLUTTER

API results:

flutter_billing/BillingProduct-class.html
```


## In summary…

The Dart 2 stable channel release is happening very soon, and we’ve made a bunch of Pub site improvements related to Dart 2, ranking, and searching.

If you’ve published packages, *now* is the time to update them for Dart 2:

1. Make sure your packages pass Dart 2 analysis.

1. Update the upper bound of the SDK constraint to `<3.0.0` in your `pubspec.yaml`.

1. Republish your updated packages.

Then go to your package’s analysis page on [pub.dartlang.org](https://pub.dartlang.org/), and see what else you can do to improve your ranking!