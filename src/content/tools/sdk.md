---
title: Dart SDK overview
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
This site's documentation and examples use
{% if site.sdkInfo.channel == 'dev' %} the **dev channel** {% endif -%}
version [{{site.sdkInfo.version}}][site SDK version] of the **Dart SDK**.
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

{% include 'tools/utf-8.md' %}

To learn more about the SDK, check out its [README file][readme].

## Filing bugs and feature requests

To see existing issues or create a new one,
go to [the SDK issue tracker][sdk-issues].

[Dart libraries]: /libraries
[flutter]: {{site.flutter-docs}}/get-started/install
[site SDK version]: {{site.dart-api}}/{{site.sdkInfo.channel}}/{{site.sdkInfo.version}}/index.html
[readme]: ({{site.repo.dart.sdk}}/blob/main/README.dart-sdk)
[sdk-issues]: ({{site.repo.dart.sdk}}/issues)
