---
title: Get the Dart SDK
description: Get the libraries and command-line tools that you need to develop Dart web, command-line, and server apps.
js:
- url: /tools/sdk/archive/assets/install.js
  defer: true
---

The Dart SDK has the libraries and command-line tools that you need to develop
Dart web, command-line, and server apps.
If you're developing only mobile apps,
then you don't need the Dart SDK; just [install Flutter.][flutter]

To learn about other tools you can use for Dart development, see
the [Dart tools](/tools) page.
To learn about what's in the SDK, see [Dart SDK overview](/tools/sdk).

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

The Dart SDK has three release channels:

* **stable** channel: **stable releases**, updated roughly every three months;
  currently `[calculating]`{:.editor-build-rev-stable}.
  
  Stable releases are suitable for production use.
  
* **beta** channel: **preview releases**, usually updated every month;
  currently `[calculating]`{:.editor-build-rev-beta}.
  
  Beta channel builds are preview builds for the stable channel. We recommend
  testing, but not releasing, your apps against beta to preview new features, or
  test compatibility with future releases.
  
* **dev** channel: **pre-releases**, usually updated twice a week;
  currently `[calculating]`{:.editor-build-rev-dev}.
  
  Dev channel releases are the most current with latest changes, may be broken,
  are unsupported, and may contain unvetted breaking changes.

**Stable** channel releases of the Dart SDK have `x.y.z` version strings like
`1.24.3` and `2.1.0`. They consist of dot-separated integers, with no hyphens or
letters, where `x` is the major version, `y` is the minor version, and `z` is
the patch version.

**Beta** and **Dev** channel releases of the Dart SDK (non-stable releases) have
`x.y.z-a.b.<beta|dev>` versions like `2.8.0-20.11.beta`. The part before the
hyphen follows the stable version scheme, `a` and `b` after the hyphen is the
pre-release and pre-release patch versions, and `beta` or `dev` is the channel.

You can get stable, beta, and dev channel releases using
the [instructions above](#install), or you can
[download the SDK as a zip file](/tools/sdk/archive).

[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[Dart 2]: /dart-2
[build the SDK from source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart libraries]: /guides/libraries/library-tour
[flutter]: https://flutter.dev/docs/get-started/install
[site SDK version]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}/index.html
