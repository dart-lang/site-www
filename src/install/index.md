---
title: Install Dart
description: The bundles that support the Dart language.
permalink: /install
js:
- url: /install/archive/assets/install.js
  defer: true
show_breadcrumbs: false
---

_Current stable version of Dart:
<span class="editor-build-rev-stable">[calculating]</span>_

<aside class="alert alert-warning"><div class="alert-with-image">
  <img src="{% asset_path flutter-logo.png %}" alt="[Flutter]">
  <div markdown="1">
  **Important:**
  If you’re a _Flutter_ developer, you get Dart when you
  [install Flutter](https://flutter.io/setup/)
  or [upgrade Flutter.](https://flutter.io/upgrading/)
  </div>
</div></aside>

To use Dart for web or server-side development, install the **Dart SDK** to get
everything you need to write and run Dart code:
VM, libraries, analyzer, package manager, doc generator,
formatter, debugger, and more.

If you're doing web development, you might also want **Dartium**.
Instructions for installing Dartium are also provided in the following pages,
or see the [zip file archive](/install/archive).

{% include dartium-2.0.html %}

{% comment %}
update-for-dart-2
{% endcomment %}


## Automated installation and updates

A package manager can help you easily install and update the Dart SDK.

* [Installing Dart on Windows](/install/windows) with Chocolatey or a
  Windows installer
* [Installing Dart on Mac](/install/mac) with homebrew
* [Installing Dart on Linux](/install/linux) with our Debian package


## Manual install

Not using a package manager for your OS? No problem!

[Download](/install/archive)
zip files of the Dart SDK, Dartium, and docs.


## Looking for an older version?

Check out our [zip file archive](/install/archive) for
previous versions of the Dart SDK.


## About SDK release channels and version strings

The Dart SDK has two release channels:

* **stable** channel: **stable releases**
  (updated no more frequently than every 6 weeks)
* **dev** channel: **pre-releases**
  (usually updated 1/week)

Most **alpha** releases of Flutter contain a **dev** channel release of Dart.

**Stable** channel releases of the Dart SDK have version strings like `1.24.2` and `2.0.0`.
They consist of dot-separated integers, with no hyphens or letters.

**Dev** channel releases of the Dart SDK (pre-releases)
have additional characters, starting with a hyphen (`-`).
After the stable release of Dart 1.24.0 on June 12,
dev channel SDKs had version strings beginning with
`1.25.0-dev`—for example, `1.25.0-dev.16.4`.

Although we don't plan to release a 1.25 Dart SDK on the stable channel,
the `1.25.0-dev` releases made it possible to use the latest SDK without
worrying about [SDK constraints][] and [semantic versioning.][semantic versioning]
Now that breaking changes are expected,
we’ve switched to version strings beginning with `2.0.0-dev`.

For more information, see
[Dart 2 Updates](/dart-2)
and the [installation instructions](#) for your platform.
{% comment %}
[PENDING: add link to the news post?]
{% endcomment %}

[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[semantic versioning]: http://semver.org/
