---
title: Dart SDK archive
short-title: Archive
description: Download specific stable, beta, dev, and main channel versions of the Dart SDK and the Dart API documentation.
js:
- url: /assets/js/get-dart/download_archive.dart.js
  defer: true
- url: /assets/js/get-dart/install.js
  defer: true
---

Use this archive to download
[specific versions](/get-dart#release-channels) of the
[Dart SDK](/tools/sdk) and the [Dart API documentation]({{site.dart-api}}).

Want to install Dart with your OS's package manager?
[Get Dart.](/get-dart)

:::warning Notice
{% include './_sdk-terms.md' %}
:::

## Stable channel

Stable channel builds are tested and approved for production use.

{% include './_archives_table.html', channel:'stable' %}

## Beta channel

Beta channel builds are preview builds for the stable channel.
We recommend testing, but not releasing, your apps against beta
to preview new features or test compatibility with future releases.
Beta channel builds are not suitable for production use.

{% include './_archives_table.html', channel:'beta' %}

## Dev channel

Dev channel builds can provide early access
to new features but might contain bugs.
Dev channel builds are not suitable for production use.

{% include './_archives_table.html', channel:'dev' %}

## Main channel

Main channel builds are the latest, raw builds from
the `main` branch of the Dart SDK repository.
These are the freshest builds available,
and they're likely to contain bugs.
Main channel builds are suitable only for
experimental development use, not for production use.

:::note
Main channel builds are unsigned.
:::

To download a main channel build, use a
[main channel URL](#main-channel-url-scheme).

## Download URLs

You can download zip files for any channel.

### Stable, beta, and dev channel URL scheme

Stable, beta, and dev channel releases
are available at URLs like the following:

```plaintext
https://storage.googleapis.com/dart-archive/channels/<[!stable|beta|dev!]>/release/<[!version!]>/sdk/dartsdk-<[!platform!]>-<[!architecture!]>-release.zip
```

Examples:

```plaintext
https://storage.googleapis.com/dart-archive/channels/stable/release/3.6.2/sdk/dartsdk-windows-x64-release.zip
https://storage.googleapis.com/dart-archive/channels/stable/release/3.0.7/sdk/dartsdk-macos-arm64-release.zip
https://storage.googleapis.com/dart-archive/channels/beta/release/2.8.0-20.11.beta/sdk/dartsdk-linux-x64-release.zip
https://storage.googleapis.com/dart-archive/channels/dev/release/2.9.0-1.0.dev/sdk/dartsdk-linux-x64-release.zip
```

### Main channel URL scheme

The latest main channel build
is available at URLs like the following:

```plaintext
https://storage.googleapis.com/dart-archive/channels/main/raw/latest/sdk/dartsdk-<[!platform!]>-<[!architecture!]>-release.zip
```

Example:

```plaintext
https://storage.googleapis.com/dart-archive/channels/main/raw/latest/sdk/dartsdk-windows-x64-release.zip
```

:::note
Main channel builds are unsigned.
:::
