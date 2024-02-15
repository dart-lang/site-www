---
title: Get the Dart SDK
description: Get the libraries and command-line tools that you need to develop Dart web, command-line, and server apps.
channel-list: [Stable, Beta, Dev]
js: [{url: '/assets/js/get-dart/install.js', defer: true}]
---

This page describes how to download the Dart SDK.
The Dart SDK includes the libraries and command-line tools that you need to develop Dart command-line, server, and non-Flutter web apps.

To learn more about the Dart SDK, consult the [Dart SDK overview](/tools/sdk).

## System requirements

Dart supports the following hardware architectures and platform versions
to develop and run Dart code.

{% assign yes = '<span class="material-symbols" style="color: #158477;">verified</span>' %}
{% assign no = '<span class="material-symbols" style="color: #D43324">dangerous</span>' %}
{% assign beta = '<span class="material-symbols" style="color: #13C2AD">gpp_maybe</span>' %}
{% assign na = '<span class="material-symbols" style="color: #DADCE0">do_not_disturb_on</span>' %}
{% assign macversions = 'Latest three versions of macOS:<br>' %}
{% for version in macos limit:3 %}
{%- if version.eol == false -%}
{% capture maclinkversion -%}
[{{version.codename}}]({{version.link}}) ({{version.cycle}})
{%- endcapture -%}
{% assign macversions = macversions | append: maclinkversion %}
{%- unless forloop.last -%}{% assign macversions = macversions | append: ', ' %}{% endunless -%}
{%- endif %}
{% endfor %}

| Platform |   x86   |   x64   |  ARM32  |   ARM64   | RISC-V   | OS Versions                       |
|----------|---------|---------|---------|-----------|----------|-----------------------------------|
| Windows  | {{yes}} | {{yes}} | {{no}}  | {{beta}}  | {{no}}   | [10] (32-bit, 64-bit), [11][]     |
| Linux    | {{yes}} | {{yes}} | {{yes}} | {{yes}}   | {{beta}} | [Debian stable][], [Ubuntu LTS][] |
| macOS    | {{no}}  | {{yes}} | {{na}}  | {{yes}}   | {{na}}   | {{macversions}}                   |

{:.table .table-striped}

{{yes}} Supported in all channels.  
{{no}} Unsupported in all channels.  
{{beta}} Supported in Dev, Beta channels only.  
{{na}} No version exists.

## Choose an install option

To install and update the Dart SDK from the stable channel,
choose one of the following options:

1. [Use a package manager](#install) (Recommended).
1. Use a [Dart Docker image][dart-docker]
1. Download from the [SDK Archive](/get-dart/archive)
1. [Build the SDK from source][build-source]

{% comment %}
NOTE to editors: Keep the zip file link as the last thing in the paragraph,
so it's easy to find (but not more tempting than package managers).
{% endcomment %}

:::warning Notice
{% include './archive/_sdk-terms.md' %}
:::

If you've installed or plan to [install the Flutter SDK][install-flutter],
it includes the full Dart SDK. The Flutter SDK includes the
[`dart`](/tools/dart-tool) CLI tool in Flutter's `bin` folder.

## Install the Dart SDK using a package manager {:#install}

Install the Dart SDK using the package manager for your platform.

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">macOS</li>
</ul>
<div id="tab-sdk-install-windows" class="tabs__content current" markdown="1">
{% include './_windows.md' %}
</div>
<div id="tab-sdk-install-linux" class="tabs__content" markdown="1">
{% include './_linux.md' %}
</div>
<div id="tab-sdk-install-mac" class="tabs__content" markdown="1">
{% include './_mac.md' %}
</div>

## Use release channels and version strings {:#release-channels}

{% for channel in channel-list %}
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
{%- if chnl != 'stable' %}
download the [SDK as a zip file][dl-sdk].
{%- else %}
follow the [instructions on this page](#install)
{% endif %}

{% endfor -%}

[build-source]: https://github.com/dart-lang/sdk/wiki/Building
[dart-docker]: https://hub.docker.com/_/dart
[dl-sdk]: /get-dart/archive
[install-flutter]: {{site.flutter-docs}}/get-started/install
[10]: https://www.microsoft.com/en-us/software-download/windows10%20
[11]: https://www.microsoft.com/en-us/software-download/windows11
[Debian stable]: https://www.debian.org/releases
[Ubuntu LTS]: https://wiki.ubuntu.com/Releases
