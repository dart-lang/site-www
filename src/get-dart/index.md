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
Dart supports the following macOS versions as of November 2023:
  - macOS 12 (Monterey)
  - macOS 13 (Ventura)
  - macOS 14 (Sonoma)
* **Supported architectures:** x64, ARM64.

## About release channels and version strings {#release-channels}

The Dart SDK has three release channels:

### Stable channel
Dart deploys a release to the _stable_ channel about every three months.
The current stable version is  `[calculating]`{:.build-rev-stable}.

Use stable channel releases for production environments.

Versioning for releases in stable channel of the Dart SDK follows a `x.y.z` format.
The version strings resemble `1.24.3` and `2.1.0`.
This format consists of three dot-separated integers without hyphens or letters.
The versions include the major version (`x`), 
then the minor version (`y`), and then the patch version (`z`).

### Beta channel
Dart releases a build to the _preview_ channel about every month.
The current beta version is  `[calculating]`{:.build-rev-beta}.

These beta channel releases preview features intended for the stable channel.
Use releases in the beta channel to test new features or
test compatibility with future releases.
Don’t use beta releases for production environments. 

Versioning for releases in the **beta** channel of the Dart SDK
follows the `x.y.z-a.b.beta` format.
Version strings resemble `2.8.0-20.11.beta`.
The part before the hyphen follows the stable version format.
The part after the hyphen adds the pre-release version (`a`),
then the pre-release patch version (`b`), and then the channel (`beta`).

### Dev
Dart releases a build to the **dev** channel about twice a week.
The current dev version is  `[calculating]`{:.build-rev-dev}.

These dev channel builds include the most recent codebase with latest changes.
These builds may be broken, have no support,
and may contain unvetted breaking changes.

Versioning for releases in the **dev** channel of the Dart SDK
follows the `x.y.z-a.b.dev` format.
Version strings resemble `2.8.0-20.11.dev`.

## How to get different channel releases

You can get stable channel releases using
the [instructions above](#install), or you can
get stable, beta, or dev channel releases
using [a package manager][] or [Dart Docker image][], or
by [downloading the SDK as a zip file][].

[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[build the SDK from source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart libraries]: /libraries
[Dart Docker image]: https://hub.docker.com/_/dart
[downloading the SDK as a zip file]: /get-dart/archive
[Debian stable]: https://www.debian.org/releases
[Ubuntu LTS]: https://wiki.ubuntu.com/Releases
[flutter]: https://flutter.dev/docs/get-started/install
[site SDK version]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}/index.html
[a package manager]: https://github.com/dart-lang/sdk/wiki/Installing-beta-and-dev-releases-with-brew,-choco,-and-apt-get
