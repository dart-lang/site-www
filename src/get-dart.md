---
title: Get the Dart SDK
description: Get the libraries and command-line tools that you need to develop Dart web, command-line, and server apps.
js:
- url: /tools/sdk/archive/assets/install.js
  defer: true
---

The Dart SDK has the libraries and command-line tools that you need to develop
Dart command-line, server, and non-Flutter web apps.
**To develop Flutter apps for any platform** —
including web and mobile apps —
then **instead of installing the Dart SDK,
[install Flutter.][flutter]**

{{site.alert.tip}}
  If you want to create _both_ Flutter and command-line or server apps,
  install both Flutter and the Dart SDK.
{{site.alert.end}}

To learn about the tools you can use for Dart development, see
the [Dart tools](/tools) page.
To learn about what's in the Dart SDK, see [Dart SDK overview](/tools/sdk).


## Install the Dart SDK {#install}

As the following instructions show,
you can use a package manager
to easily install and update the Dart SDK.
Alternatively, you can
[build the SDK from source][] or
[download the SDK as a zip file](/tools/sdk/archive).
{% comment %}
NOTE to editors: Keep the zip file link as the last thing in the paragraph,
so it's easy to find (but not more tempting than package managers).
{% endcomment %}

{{site.alert.warn}}
  {% include_relative tools/sdk/archive/_sdk-terms.md %}
{{site.alert.end}}

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
* **dev** channel: **prereleases**, usually updated 1/week;
  currently `[calculating]`{:.editor-build-rev-dev}.

{{site.alert.warning}}
  To give you early access to new features and fixes,
  dev channel releases are not as heavily tested as the stable release.
{{site.alert.end}}

**Stable** channel releases of the Dart SDK have version strings like `1.24.3` and `2.1.0`.
They consist of dot-separated integers, with no hyphens or letters.

**Dev** channel releases of the Dart SDK (prereleases)
have additional characters, starting with a hyphen (`-`).
For example, Dart 2 prereleases have version numbers starting with
`2.0.0-dev` such as `2.0.0-dev.69.5`.

You can get stable and dev channel releases using
the [instructions above](#install), or you can
[download the SDK as a zip file](/tools/sdk/archive).

[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[Dart 2]: /dart-2
[build the SDK from source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart libraries]: /guides/libraries/library-tour
[flutter]: https://flutter.dev/docs/get-started/install
[site SDK version]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}/index.html
