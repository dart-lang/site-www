---
title: Get the Dart SDK
description: Get the libraries and command-line tools that you need to develop Dart web, command-line, and server apps.
js:
- url: /assets/js/get-dart/install.js
  defer: true
---

This page describes how to download the Dart SDK.
The Dart SDK has the libraries and command-line tools that you need to develop
Dart command-line, server, and non-Flutter web apps.
For details, see the [Dart SDK overview](/tools/sdk).

## Installing the Dart SDK {#install}

As the following instructions show,
you can use a package manager
to easily install and update a stable channel Dart SDK.
Alternatively, you can
[build the SDK from source][],
grab a [Dart Docker image][], or
install from [any release channel](#release-channels) by
[downloading the SDK as a zip file][].
{% comment %}
NOTE to editors: Keep the zip file link as the last thing in the paragraph,
so it's easy to find (but not more tempting than package managers).
{% endcomment %}

*Note*: The Flutter SDK includes the full Dart SDK,
and has Dart's [`dart`](/tools/dart-tool) command-line interface
in its `bin` folder.

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

## System requirements

The Dart SDK is supported on Windows, Linux, and macOS.

### Windows

* **Supported versions:** Windows 10 and 11.
* **Supported architectures:** x64, IA32, ARM64.<br>
  Support for ARM64 is in preview, and is available only in the dev and beta channels.

### Linux

* **Supported versions:** [Debian stable][] and [Ubuntu LTS][] under standard support.
* **Supported architectures:** x64, IA32, ARM64, ARM, RISC-V (RV64GC).<br>
  Support for RISC-V is in preview, and is available only in the dev and beta channels.

### macOS

* **Supported versions:** Latest three major versions.
Dart supports the following macOS versions as of November 2022:
  - macOS 11 (Big Sur)
  - macOS 12 (Monterey)
  - macOS 13 (Ventura)
* **Supported architectures:** x64, ARM64.

## About release channels and version strings {#release-channels}

The Dart SDK has three release channels:

* **Stable** channel: **stable releases**, updated roughly every three months;
  currently `[calculating]`{:.build-rev-stable}.
  
  Stable releases are suitable for production use.
  
* **Beta** channel: **preview releases**, usually updated every month;
  currently `[calculating]`{:.build-rev-beta}.
  
  Beta channel builds are preview builds for the stable channel. We recommend
  testing, but not releasing, your apps against beta to preview new features or
  test compatibility with future releases.
  
* **Dev** channel: **prereleases**, usually updated twice a week;
  currently `[calculating]`{:.build-rev-dev}.
  
  Dev channel releases are the most current with latest changes, may be broken,
  are unsupported, and may contain unvetted breaking changes.

**Stable** channel releases of the Dart SDK have `x.y.z` version strings like
`1.24.3` and `2.1.0`. They consist of dot-separated integers, with no hyphens or
letters, where `x` is the major version, `y` is the minor version, and `z` is
the patch version.

**Beta** and **dev** channel releases of the Dart SDK (non-stable releases) have
`x.y.z-a.b.<beta|dev>` versions like `2.8.0-20.11.beta`. The part before the
hyphen follows the stable version scheme, `a` and `b` after the hyphen are the
prerelease and prerelease patch versions, and `beta` or `dev` is the channel.

You can get stable channel releases using
the [instructions above](#install), or you can
get stable, beta, or dev channel releases
using [a package manager][] or [Dart Docker image][], or
by [downloading the SDK as a zip file][].

[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[build the SDK from source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart libraries]: /guides/libraries/library-tour
[Dart Docker image]: https://hub.docker.com/_/dart
[downloading the SDK as a zip file]: /get-dart/archive
[Debian stable]: https://www.debian.org/releases
[Ubuntu LTS]: https://wiki.ubuntu.com/Releases
[flutter]: https://flutter.dev/docs/get-started/install
[site SDK version]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}/index.html
[a package manager]: https://github.com/dart-lang/sdk/wiki/Installing-beta-and-dev-releases-with-brew,-choco,-and-apt-get
