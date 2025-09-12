---
title: Get the Dart SDK
short-title: Get Dart
description: >-
  Get the libraries and command-line tools that you need to develop
  Dart web, command-line, and server apps.
channelList: [Stable, Beta, Dev]
js: [{url: '/assets/js/get-dart/install.js', defer: true}]
---

This page describes how to download the Dart SDK.
The Dart SDK includes the libraries and command-line tools that
you need to develop Dart command-line, server, and web apps.

The Dart team supports only the latest stable release of the SDK.
For full details on the SDK release lifecycle and supported versions,
check out the [SDK support policy](/tools/sdk#support-policy).

To learn more about the Dart SDK, consult the [Dart SDK overview](/tools/sdk).

:::tip
If you've installed or plan to [install the Flutter SDK][install-flutter], it
includes the full Dart SDK. You don't need to install Dart separately and can skip this guide.
:::

## System requirements

Dart supports the following hardware architectures and platform versions
to develop and run Dart code.

{% assign yes = '<span class="material-symbols system-support" style="color: #158477" aria-label="Supported" title="Supported">verified</span>' %}
{% assign no = '<span class="material-symbols system-support" style="color: #D43324" aria-label="Not supported" title="Not supported">dangerous</span>' %}
{% assign dep = '<span class="material-symbols system-support" style="color: #EF6C00" aria-label="Deprecated" title="Deprecated">error</span>' %}
{% assign rem = '<span class="material-symbols system-support" style="color: #E25012" aria-label="Final deprecation" title="Final deprecation">report</span>' %}
{% assign na = '<span class="material-symbols system-support" style="color: #DADCE0" aria-label="Does not exist" title="Does not exist">do_not_disturb_on</span>' %}

| Platform |   x64   | IA32 (x86) |  Arm32  |  Arm64  | RISC-V (RV64GC) | OS Versions                                                                                                                                                                                                                             |
|----------|:-------:|:----------:|:-------:|:-------:|:---------------:|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Windows  | {{yes}} |   {{no}}   | {{no}}  | {{yes}} |     {{na}}      | [10], [11][]                                                                                                                                                                                                                            |
| Linux    | {{yes}} |   {{no}}   | {{yes}} | {{yes}} |     {{yes}}     | [Debian stable][],<br>[Ubuntu LTS][] under standard support                                                                                                                                                                             |
| macOS    | {{yes}} |   {{no}}   | {{na}}  | {{yes}} |     {{na}}      | Latest three versions of macOS:<br>{% for version in macos limit:3 %}{%- if version.eol == false -%}[{{version.codename}}]({{version.link}}) ({{version.cycle}}){%- unless forloop.last -%}, {% endunless -%} {%- endif %} {% endfor %} |

{:.table .table-striped}

{{yes}} Supported on all channels.<br>
{{dep}} Support is deprecated and might be dropped in a future Dart release.<br>
{{rem}} Support is deprecated and will likely be removed in the next stable release.<br>
{{no}} Unsupported on all channels.<br>
{{na}} Unsupported by the operating system.<br>

## Choose an installation option

To install and update the Dart SDK from the stable channel,
choose one of the following options:

1. [Use a package manager](#install) (Recommended).

1. Use a [Dart Docker image][dart-docker].

1. [Install Flutter][install-flutter].  
   If you've installed or plan to [install the Flutter SDK][install-flutter],
   it includes the full Dart SDK. The Flutter SDK includes the
   [`dart`](/tools/dart-tool) CLI tool in Flutter's `bin` folder.

1. Download a ZIP archive from the [SDK Archive](/get-dart/archive).

1. [Build the SDK from source][build-source].

:::warning Notice
{% render 'install/sdk-terms.md' %}
:::

{% comment %}
NOTE to editors: Keep the zip file link as the last thing in the paragraph,
so it's easy to find (but not more tempting than package managers).
{% endcomment %}

## Install the Dart SDK {:#install}

To install the Dart SDK,
use the appropriate package manager for your development platform.

To upgrade the Dart SDK,
run the same command to install the Dart SDK from your package manager.

<Tabs key="dev-os" wrapped="true">
  <Tab name="Windows">

  {% render 'install/windows.md', site: site %}

  </Tab>
  <Tab name="Linux">

  {% render 'install/linux.md', site: site %}

  </Tab>
  <Tab name="macOS">

  {% render 'install/macos.md', site: site %}

  </Tab>
</Tabs>

## Release channel reference {:#release-channels}

{% for channel in page.channelList %}
{% assign chnl = channel | downcase -%}
{% assign current="`[calculating]`{:.build-rev-" | append: chnl | append: "}" %}
{% case chnl %}
{% when 'stable' %}
{% assign verstring = "`x.y.z`" %}
{% assign examples = "`1.24.3` and `2.1.0`" %}
{% assign schedule = "every three months" %}
{% assign version-use = "building and deploying production apps" %}
{% when 'beta' %}
{% assign verstring = "`x.y.z-a.b.beta`" %}
{% assign examples = "`2.8.0-20.11.beta` and `3.3.0-205.1.beta`" %}
{% assign verdesc = "pre-release" %}
{% assign schedule = "once a month" %}
{% assign version-use = "testing your app's compatibility with future stable versions" %}
{% when 'dev' %}
{% assign verstring = "`x.y.z-a.b.dev`" %}
{% assign examples = "`2.8.0-20.11.dev` and `3.2.12-15.33.dev`" %}
{% assign verdesc = "development" %}
{% assign schedule = "twice a week" %}
{% assign version-use = "testing recent fixes and experimental features" %}
{% endcase %}

### {{channel}} channel

Dart publishes a new release to the *{{chnl}}* channel about {{schedule}}.
The current {{chnl}} version is {{current}}.

Use **{{chnl}}** channel releases for {{version-use}}.

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
follow the [instructions on this page](#install).
{% endif %}

{% endfor -%}

[build-source]: {{site.repo.dart.sdk}}/wiki/Building
[dart-docker]: https://hub.docker.com/_/dart
[dl-sdk]: /get-dart/archive
[install-flutter]: {{site.flutter-docs}}/get-started/install
[10]: https://www.microsoft.com/en-us/software-download/windows10%20
[11]: https://www.microsoft.com/en-us/software-download/windows11
[Debian stable]: https://www.debian.org/releases
[Ubuntu LTS]: https://wiki.ubuntu.com/Releases
