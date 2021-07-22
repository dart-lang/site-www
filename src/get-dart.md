---
title: Get the Dart SDK
description: Get the libraries and command-line tools that you need to develop Dart web, command-line, and server apps.
js:
- url: /tools/sdk/archive/assets/install.js
  defer: true
---

This page describes how to download the Dart SDK.
The Dart SDK has the libraries and command-line tools that you need to develop
Dart command-line, server, and non-Flutter web apps.
For details, see the [Dart SDK overview](/tools/sdk).

**As of Flutter 1.21, the [Flutter SDK][flutter] includes the full Dart SDK.**
So if you have Flutter installed,
you might not need to explicitly download the Dart SDK.
Consider downloading the Dart SDK if
any of the following are true:

* You don't use Flutter.
* You use a pre-1.21 version of Flutter.
* You want to reduce disk space requirements or download time,
  and your use case doesn't require Flutter.
  For example, you might have a continuous integration (CI)
  setup that requires Dart but not Flutter.

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

{{site.alert.warn}}
  {% include_relative tools/sdk/archive/_sdk-terms.md %}
{{site.alert.end}}

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">macOS</li>
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

## System requirements

The Dart SDK is supported on Windows, Linux, and macOS.

### Windows

* **Supported versions:** Windows 10.
* **Supported architectures:** x64, ia32.

### Linux

* **Supported versions:** [Debian stable][] and [Ubuntu LTS][] under standard support.
* **Supported architectures:** x64, ia32, arm, arm64.

{{site.alert.note}}
  The arm support requires glibc 2.23 or newer due to a
  [dynamic linker bug](https://sourceware.org/bugzilla/show_bug.cgi?id=14341).
{{site.alert.end}}

### macOS

* **Supported versions:** Latest three major versions.
  As of April 2021, the following versions are supported:
  - macOS 10.14 (Mojave)
  - macOS 10.15 (Catalina)
  - macOS 11 (Big Sur)
* **Supported architectures:** x64, arm64.
  Support for arm64 is in preview, and is available only in the dev and beta channels.

## About release channels and version strings {#release-channels}

The Dart SDK has three release channels:

* **Stable** channel: **stable releases**, updated roughly every three months;
  currently `[calculating]`{:.editor-build-rev-stable}.
  
  Stable releases are suitable for production use.
  
* **Beta** channel: **preview releases**, usually updated every month;
  currently `[calculating]`{:.editor-build-rev-beta}.
  
  Beta channel builds are preview builds for the stable channel. We recommend
  testing, but not releasing, your apps against beta to preview new features or
  test compatibility with future releases.
  
* **Dev** channel: **prereleases**, usually updated twice a week;
  currently `[calculating]`{:.editor-build-rev-dev}.
  
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
[Dart 2]: /dart-2
[build the SDK from source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart libraries]: /guides/libraries/library-tour
[Dart Docker image]: https://hub.docker.com/_/dart
[downloading the SDK as a zip file]: /tools/sdk/archive
[Debian stable]: https://www.debian.org/releases
[Ubuntu LTS]: https://wiki.ubuntu.com/Releases
[flutter]: https://flutter.dev/docs/get-started/install
[site SDK version]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}/index.html
[a package manager]: https://github.com/dart-lang/sdk/wiki/Installing-beta-and-dev-releases-with-brew,-choco,-and-apt-get
