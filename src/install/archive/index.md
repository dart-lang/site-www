---
layout: default
title: "Index of Downloads"
description: "Download specific stable and dev channel versions of the Dart SDK, Dartium, and the Dart API documentation."
permalink: /install/archive/

js:
- url: out/web/download_archive.dart.js
  defer: true
- url: assets/install.js
  defer: true
---

{% include breadcrumbs.html %}

Use this index to install specific versions of the
[Dart SDK](/tools/sdk),
[Dartium]({{site.webdev}}/tools/dartium),
and the [Dart API documentation]({{site.dart_api}}).

Want to install Dart with your OS's package manager?
Go to the [main Dart installation page](/install).

## Stable channel

Stable channel builds are tested and approved for production use.

{% include_relative _archives_table.html channel="stable" %}

## Dev channel

Dev channel builds may contain bugs and can provide early access
to new features. We do not recommended dev channel builds for
production use.

{% include_relative _archives_table.html channel="dev" %}

## Direct download URLs

You can find the zip files at predictable URLs using the
following pattern:

{% prettify none %}
https://storage.googleapis.com/dart-archive/channels/<[[highlight]]stable/dev[[/highlight]]>/release/<[[highlight]]release[[/highlight]]>/sdk/dartsdk-<[[highlight]]platform[[/highlight]]>-<[[highlight]]architecture[[/highlight]]>-release.zip
{% endprettify %}

Examples:

{% prettify none %}
https://storage.googleapis.com/dart-archive/channels/stable/release/1.11.1/sdk/dartsdk-windows-ia32-release.zip
https://storage.googleapis.com/dart-archive/channels/stable/release/1.12.0/sdk/dartsdk-macos-x64-release.zip
https://storage.googleapis.com/dart-archive/channels/dev/release/1.13.0-dev.0.0/sdk/dartsdk-linux-ia32-release.zip
{% endprettify %}
