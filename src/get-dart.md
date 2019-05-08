---
title: Get the Dart SDK
description: Get the Dart SDK
js:
- url: /tools/sdk/archive/assets/install.js
  defer: true
---

The Dart SDK has the libraries and command-line tools that you need to develop
Dart web, command-line, and server apps.
If you're developing only mobile apps,
then you don't need the Dart SDK; just [install Flutter.][flutter]

To learn about other tools you can use for Dart development, see
the [Dart tools]({{site.dartlang}}/tools) page.

To learn about what's in the SDK, see [Dart SDK overview](/tools/sdk).

<aside class="alert alert-info" markdown="1">
  **Note:** This site's documentation and examples use
  {% if site.data.pkg-vers.SDK.channel == 'dev' %} the **dev channel** {% endif -%}
  version [{{site.data.pkg-vers.SDK.vers}}][site SDK version]{:.no-automatic-external}
  of the **Dart SDK**.
</aside>

## Install the Dart SDK {#install}

As the following instructions show,
you can use a package manager
to easily install and update the Dart SDK.
Alternatively, you can
[build the SDK from source][] or
[download the SDK as a zip file]({{site.dartlang}}/tools/sdk/archive).
{% comment %}
NOTE to editors: Keep the zip file link as the last thing in the paragraph,
so it's easy to find (but not more tempting than package managers).
{% endcomment %}

<aside class="alert alert-warning" markdown="1">
  {% include_relative tools/sdk/archive/_sdk-terms.md %}
</aside>

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">Mac</li>
</ul>
<div id="tab-sdk-install-windows" class="tabs__content current" markdown="1">
{% include_relative tools/sdk/_windows.md %}
</div>
<div id="tab-sdk-install-linux" class="tabs__content" markdown="1">
{% include_relative tools/sdk/_linux.md %}
</div>
<div id="tab-sdk-install-mac" class="tabs__content" markdown="1">
{% include_relative tools/sdk/_mac.md %}
</div>

## About release channels and version strings

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


**Stable** channel releases of the Dart SDK have version strings like `1.24.3` and `2.1.0`.
They consist of dot-separated integers, with no hyphens or letters.

**Dev** channel releases of the Dart SDK (pre-releases)
have additional characters, starting with a hyphen (`-`).
For example, Dart 2 pre-releases have version numbers starting with
`2.0.0-dev` such as `2.0.0-dev.69.5`.

For more information, see the [Dart 2 page.][Dart 2]

[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[semantic versioning]: http://semver.org/
[Dart 2]: {{site.dartlang}}/dart-2
[build the SDK from source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart libraries]: {{site.dartlang}}/guides/libraries/library-tour
[flutter]: https://flutter.dev/docs/get-started/install
[site SDK version]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}/index.html
