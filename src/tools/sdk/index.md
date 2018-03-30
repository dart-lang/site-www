---
title: Dart SDK
description: Dart libraries and command-line tools.
permalink: /tools/sdk
js:
- url: /tools/sdk/archive/assets/install.js
  defer: true
---

The Dart SDK has the libraries and command-line tools that you need to develop
Dart apps. To learn about other tools you can use for Dart development, see
[Dart Tools](/tools).

The [DartPad][]{: target="_blank"} is a great way to learn how to write a simple
app in the Dart language, once you are ready to develop real apps, you need the
Dart SDK.

This site's documentation and examples use the
[{{site.data.pkg-vers.SDK.vers}}][site SDK version]{:.no-automatic-external}
release of the **Dart SDK**.

## Install the SDK

A package manager can help you easily install and update the Dart SDK.

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">Mac</li>
</ul>
<div id="tab-sdk-install-windows" class="tabs__content current" markdown="1">
{% include_relative _windows.md %}
</div>
<div id="tab-sdk-install-linux" class="tabs__content" markdown="1">
{% include_relative _linux.md %}
</div>
<div id="tab-sdk-install-mac" class="tabs__content" markdown="1">
{% include_relative _mac.md %}
</div>

Alternatives:

- Not using a package manager for your OS? No problem!
  [Download](/install/archive)
  zip files of the Dart SDK and docs.
- Looking for an older version?
  Check out our [zip file archive](/install/archive) for
  previous versions of the Dart SDK.

## What's in the SDK

The SDK directory includes a `lib` directory for the
[Dart libraries](/guides/libraries/library-tour)
and a `bin` directory that has these command-line tools:

<div class="row"><div class="col-md-6" markdown="1">

[dart](/dart-vm)
: The standalone VM

[dart2js]({{site.webdev}}/tools/dart2js)
: The Dart-to-JavaScript compiler (used only for web development)

[dartanalyzer](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer)
: The static analyzer

[dartdevc]({{site.webdev}}/tools/dartdevc)
: The Dart development compiler
(used only for web development)

</div> <div class="col-md-6" markdown="1">

[dartdoc](https://github.com/dart-lang/dartdoc#dartdoc)
: The API documentation generator

[dartfmt](https://github.com/dart-lang/dart_style#readme)
: The Dart code formatter

[pub](/tools/pub)
: The Dart package manager

</div></div>

For more information about the SDK, see its
[README file](https://github.com/dart-lang/sdk/blob/master/README.dart-sdk).

## About SDK release channels and version strings

The Dart SDK has two release channels:

* **stable** channel: **stable releases**,
  updated no more frequently than every 6 weeks;
  currently `[calculating]`{:.editor-build-rev-stable}.
* **dev** channel: **pre-releases**, usually updated 1/week;
  currently `[calculating]`{:.editor-build-rev-dev}.

<aside class="alert alert-warning" markdown="1">
  **Warning:**
  To give you early access to new features and fixes,
  dev channel releases are not as heavily tested as the stable release.
</aside>

Most **alpha** releases of Flutter contain a **dev** channel release of Dart.

**Stable** channel releases of the Dart SDK have version strings like `1.24.2` and `2.0.0`.
They consist of dot-separated integers, with no hyphens or letters.

**Dev** channel releases of the Dart SDK (pre-releases)
have additional characters, starting with a hyphen (`-`).
Dart 2 pre-releases have version numbers starting with
`2.0.0-dev`—for example, `2.0.0-dev.42.0`.

For more information, see [Dart 2 Updates](/dart-2).

[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[semantic versioning]: http://semver.org/

## Filing bugs and feature requests

To see existing issues or create a new one,
go to [dartbug.com](http://dartbug.com).
Here are some handy searches:

* [dart (VM) issues](https://github.com/dart-lang/sdk/labels/Area-VM)
* [dartanalyzer issues](https://github.com/dart-lang/sdk/labels/Area-Analyzer)
* [dartdoc issues](https://github.com/dart-lang/dartdoc/issues)
* [pub issues](https://github.com/dart-lang/sdk/labels/Area-Pub)
* [issues for the SDK as a whole](https://github.com/dart-lang/sdk/issues)

[DartPad]: {{site.custom.dartpad.direct-link}}
[site SDK version]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}