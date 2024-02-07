---
title: Get the Dart SDK
description: >-
  Get the libraries and command-line tools that you need to develop 
  Dart web, command-line, and server apps.
channel-list: [Stable, Beta, Dev]
js:
- url: /assets/js/get-dart/install.js
---

This page describes how to download the Dart SDK.
The Dart SDK includes the libraries and command-line tools that you need to develop Dart command-line, server, and non-Flutter web apps.

To learn more about the Dart SDK, see the [Dart SDK overview](/tools/sdk).

## Choose an install option

To install and update the Dart SDK from the stable channel,
choose one of the following options:

1. [Use a package manager](#install) (Recommended).
1. [Build the SDK from source][build-source]
1. Use a [Dart Docker image][dart-docker]

{% comment %}
NOTE to editors: Keep the zip file link as the last thing in the paragraph,
so it's easy to find (but not more tempting than package managers).
{% endcomment %}

*Note*: The Flutter SDK includes the full Dart SDK,
and has Dart's [`dart`](/tools/dart-tool) command-line interface
in its `bin` folder.

:::warning Notice
{% include './archive/_sdk-terms.md' %}
:::

## Install the Dart SDK {#install}

The Flutter SDK includes the full Dart SDK including the
[`dart`](/tools/dart-tool) CLI tool in Flutter's `bin` folder.

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">macOS</li>
</ul>
<div id="tab-sdk-install-windows" class="tabs__content current">

{% include './_windows.md' %}

</div>
<div id="tab-sdk-install-linux" class="tabs__content">

{% include './_linux.md' %}

</div>
<div id="tab-sdk-install-mac" class="tabs__content">

{% include './_mac.md' %}

</div>

## About release channels and version strings {#release-channels}

{% for channel in page.channel-list %}
{% assign chnl = channel | downcase -%}

{% assign current="`[calculating]`{:.build-rev-" | append: chnl | append: "}" %}
{% case chnl %}
{% when 'stable' %}
{% assign verstring = "`x.y.z`" %}
{% assign examples = "`1.24.3` and `2.1.0`" %}
{% when 'beta' %}
{% assign verstring = "`x.y.z-a.b.beta`" %}
{% assign examples = "`2.8.0-20.11.beta` and `3.3.0-205.1.beta`" %}
{% assign verdesc = "pre-release" %}
{% when 'dev' %}
{% assign verstring = "`x.y.z-a.b.dev`" %}
{% assign examples = "`2.8.0-20.11.dev` and `3.2.12-15.33.dev`" %}
{% assign verdesc = "development" %}
{% endcase %}

### {{channel}} channel

Dart publishes a new release to the *{{chnl}}* channel about every three months.
The current {{chnl}} version is {{current}}.

Use **stable channel releases** for **production** environments.

**{{channel}}** channel release version strings follow a {{verstring}} format:

* `x` : major version
* `y` : minor version
* `z` : patch version
{%- if chnl != 'stable' %}
* `a` : {{verdesc}} version
* `b` : {{verdesc}} patch version
{% endif %}

Examples of {{chnl}} channel version strings include {{examples}}.

To install a {{chnl}} channel release,
{% if chnl != 'stable' %}
download the [SDK as a zip file][dl-sdk].
{% else %}
follow the [instructions on this page](#install)
{% endif %}

{% endfor -%}

[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[build-source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart libraries]: /libraries
[dart-docker]: https://hub.docker.com/_/dart
[dl-sdk]: /get-dart/archive
[flutter]: https://flutter.dev/docs/get-started/install
[site SDK version]: {{site.dart-api}}/{{site.sdkInfo.channel}}/{{site.sdkInfo.version}}/index.html
[a package manager]: https://github.com/dart-lang/sdk/wiki/Installing-beta-and-dev-releases-with-brew,-choco,-and-apt-get
