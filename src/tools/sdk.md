---
title: Dart SDK overview
description: Dart libraries and command-line tools.
---

The Dart SDK has the libraries and command-line tools that you need to develop
Dart web, command-line, and server apps. To get the Dart SDK, see [Get Dart](/get-dart).
If you're developing Flutter apps,
then you don't need to separately download the Dart SDK; just [install Flutter.][flutter]

To learn about other tools you can use for Dart development, see
the [Dart tools](/tools) page.

{{site.alert.version-note}}
  This site's documentation and examples use
  {% if site.data.pkg-vers.SDK.channel == 'dev' %} the **dev channel** {% endif -%}
  version [{{site.data.pkg-vers.SDK.vers}}][site SDK version]{:.no-automatic-external}
  of the **Dart SDK**.
{{site.alert.end}}

{% comment %}
  IMPORTANT: After each release, EDIT src/_data/pkg-vers.json
  to update the SDK version number.
  More info: https://github.com/dart-lang/site-www/wiki/Updating-to-new-SDK-releases
{% endcomment %}

## What's in the Dart SDK

The Dart SDK includes a `lib` directory for the [Dart libraries][] and a `bin`
directory that has these command-line tools:

[`dart`](/tools/dart-tool)
: The command-line interface for creating, formatting, analyzing, testing,
  documenting, compiling, and running Dart code.
  
[`dartaotruntime`](/tools/dartaotruntime)
: A Dart runtime for AOT-compiled snapshots.

For more information about the SDK, see its
[README file.](https://github.com/dart-lang/sdk/blob/main/README.dart-sdk)

## Filing bugs and feature requests

To see existing issues or create a new one,
go to [the SDK issue tracker](https://github.com/dart-lang/sdk/issues).

[build the SDK from source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart libraries]: /guides/libraries/library-tour
[flutter]: https://flutter.dev/docs/get-started/install
[site SDK version]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}/index.html
