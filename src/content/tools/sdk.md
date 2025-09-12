---
title: Dart SDK overview
shortTitle: SDK overview
breadcrumb: SDK
description: Dart libraries and command-line tools.
---

The Dart SDK has the libraries and command-line tools that you need to develop
Dart web, command-line, and server apps.
To install the Dart SDK, see [Get Dart](/get-dart).
If you're developing Flutter apps, [install the Flutter SDK][flutter].
The Flutter SDK includes the Dart SDK.

To learn about other tools you can use for Dart development,
check out the [Dart tools](/tools) page.

:::version-note
Unless stated otherwise,
this site's documentation and examples assume
version `{{site.sdkVersion}}` of the **Dart SDK**.
:::

{% comment %}
  IMPORTANT: After each release, EDIT src/_data/pkg-vers.json
  to update the SDK version number.
  More info: https://github.com/dart-lang/site-www/wiki/Updating-to-new-SDK-releases
{% endcomment %}

## What's in the Dart SDK

The Dart SDK includes two directories:

* `lib` contains the [Dart libraries][].
* `bin` contains the following command-line tools.

[`dart`](/tools/dart-tool)
: The command-line interface to create, format, analyze, test,
  document, compile, and run Dart code.
  
[`dartaotruntime`](/tools/dartaotruntime)
: A Dart runtime for AOT-compiled snapshots.

{% render 'tools/utf-8.md' %}

To learn more about the SDK, check out its [README file][readme].

## Support policy

The Dart team supports only the latest, stable version of the Dart SDK.
When a new major or minor version is released,
older versions are no longer supported.
For example, if `3.7.x` is the latest release,
it is supported until `3.8.0` or `4.0.0` is released,
whichever comes first.

The Dart team provides fixes to critical issues and security problems as needed
through patch releases but only for the currently supported version.
For example, if `3.7.0` is the latest stable release,
a fix to a vulnerability might be issued in a `3.7.1` patch release.

On average, the Dart team ships a new stable release every 3 months.
Patch releases to the currently supported version are shipped as needed.

This policy helps ensure Dart developers have access to
a stable and reliable platform that continues to
evolve with new features and improvements.

{% comment %}
TODO(parlough): Add a section discussing the breaking change policy
and link out to the breaking change index.
{% endcomment %}

## Filing bugs and feature requests

To see existing issues or create a new one,
go to [the SDK issue tracker][sdk-issues].

[Dart libraries]: /libraries
[flutter]: {{site.flutter-docs}}/get-started/install
[readme]: {{site.repo.dart.sdk}}/blob/main/README.dart-sdk
[sdk-issues]: {{site.repo.dart.sdk}}/issues
