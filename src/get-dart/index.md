---
title: Get the Dart SDK
description: Get the libraries and command-line tools that you need to develop Dart web, command-line, and server apps.
channel-list: [Stable, Beta, Dev]
js:
- url: /assets/js/get-dart/install.js
  defer: true
---

This page describes how to download the Dart SDK.
The Dart SDK includes the libraries and command-line tools to develop
Dart command-line, server, and non-Flutter web apps.

To learn more about the SDK, check out the [Dart SDK overview](/tools/sdk).

## Installing the Dart SDK {#install}

To install and update a stable channel Dart SDK,
use a package manager.

{% comment %}
NOTE to editors: Keep the zip file link as the last thing in the paragraph,
so it's easy to find (but not more tempting than package managers).
{% endcomment %}

{{site.alert.warn}}
  {% include_relative archive/_sdk-terms.md %}
{{site.alert.end}}

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">macOS</li>
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

Other options to install Dart include
[building the SDK from source][build-source],
using a [Dart Docker image][], or
installing from [any release channel](#release-channels) by
[downloading the SDK as a zip file][download].

{{site.alert.note}}
The [Flutter SDK][flutter] includes the full Dart SDK.
Flutter installs place Dart's [`dart`](/tools/dart-tool)
command-line interface in its `bin` directory.
{{site.alert.end}}

## System requirements

The Windows, Linux, and macOS support the Dart SDK.

### Supported architectures

| Platform | x86 | x64 | ARM | ARM64     | RISC-V    |
|----------|-----|-----|-----|-----------|-----------|
| Windows  | Yes | Yes | No  | Dev, Beta | No        |
| Linux    | Yes | Yes | Yes | Yes       | Dev, Beta |
| macOS    | No  | Yes | No  | Yes       | No        |
{:.table .table-striped}

### Supported operating systems

| Platform | OS Versions                              |
|----------|------------------------------------------|
| Windows  | 10, 11                                   |
| Linux    | [Debian stable][], [Ubuntu LTS][]        |
| macOS    | {% for version in site.data.macos %}{% if version.eol == true %}{% break %}{%- else -%}{{version.cycle}} ({{version.codename}}){% endif %},{% endfor %} |
{:.table .table-striped}

## Release channels and version strings {#release-channels}

All Dart versions follow [semantic versioning][semvar].

The Dart SDK has three release channels:
**stable** (production), **beta** (preview), and **dev** (latest).

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

Use stable channel releases for production environments.

**{{channel}}** channel release version strings follow a {{verstring}} format:

* `x` : major version
* `y` : minor version
* `z` : patch version
{% if chnl != 'stable' %}
* `a` : {{verdesc}} version
* `b` : {{verdesc}} patch version
{% endif %}

Examples of {{chnl}} channel version strings include {{example}}.

{% endfor -%}

## How to get different channel releases

To get stable channel releases, use the [previous instructions](#install).
To get stable, beta, or dev channel releases,
use a [package manager][], use a [Dart Docker image][], or
[download the SDK as a zip file][download].

[semvar]: /tools/pub/versioning#semantic-versions
[build-source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart Docker image]: https://hub.docker.com/_/dart
[download]: /get-dart/archive
[Debian stable]: https://www.debian.org/releases
[Ubuntu LTS]: https://wiki.ubuntu.com/Releases
[flutter]: https://flutter.dev/docs/get-started/install
[package manager]: https://github.com/dart-lang/sdk/wiki/Installing-beta-and-dev-releases-with-brew,-choco,-and-apt-get
[Dart libraries]: /libraries
[site SDK version]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}/index.html
