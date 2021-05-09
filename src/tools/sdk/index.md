---
title: Dart SDK overview
description: Dart libraries and command-line tools.
js:
- url: /tools/sdk/archive/assets/install.js
  defer: true
---

The Dart SDK has the libraries and command-line tools that you need to develop
Dart web, command-line, and server apps. To get the Dart SDK, see [Get Dart](/get-dart).
If you're developing Flutter apps,
then you don't need to separately download the Dart SDK; just [install Flutter.][flutter]

To learn about other tools you can use for Dart development, see
the [Dart tools](/tools) page.

{{site.alert.version-note}}
  As of Flutter 1.21, the Flutter SDK includes the full Dart SDK.
  This site's documentation and examples use
  {% if site.data.pkg-vers.SDK.channel == 'dev' %} the **dev channel** {% endif -%}
  version [{{site.data.pkg-vers.SDK.vers}}][site SDK version]{:.no-automatic-external}
  of the **Dart SDK**.
</aside>
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
  compiling, and running Dart code.
  
[`dartaotruntime`](/tools/dartaotruntime)
: A Dart runtime for AOT-compiled snapshots.

[`dartdoc`](/tools/dartdoc)
: The API documentation generator.

{{ site.alert.note }}
  The 2.10 Dart SDK also contains `dart2js`, `dart2native`, `dartanalyzer`,
  `dartdevc`, `dartfmt`, and `pub` commands.
  However, as of 2.10 the `dart` tool provides a unified interface
  to their functionality.
  We recommend that you transition to using
  [the `dart` tool](/tools/dart-tool).
{{ site.alert.end }}

For more information about the SDK, see its
[README file.](https://github.com/dart-lang/sdk/blob/master/README.dart-sdk)


## Filing bugs and feature requests

To see existing issues or create a new one,
go to [the SDK issue tracker](https://github.com/dart-lang/sdk/issues).

[Dart 2]: /dart-2
[build the SDK from source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart libraries]: /guides/libraries/library-tour
[flutter]: https://flutter.dev/docs/get-started/install
[site SDK version]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}/index.html
