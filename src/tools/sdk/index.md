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
then you don't need the Dart SDK; just [install Flutter.][flutter]

To learn about other tools you can use for Dart development, see
the [Dart tools](/tools) page.

{{site.alert.version-note}}
  As of Flutter 1.21, the Flutter SDK includes the Dart SDK.
  This site's documentation and examples use
  {% if site.data.pkg-vers.SDK.channel == 'dev' %} the **dev channel** {% endif -%}
  version [{{site.data.pkg-vers.SDK.vers}}][site SDK version]{:.no-automatic-external}
  of the **Dart SDK**.
</aside>

## What's in the Dart SDK

The Dart SDK includes a `lib` directory for the [Dart libraries][] and a `bin`
directory that has these command-line tools:

<div class="row">
  <div class="col-lg-6" markdown="1">  
    
  [dart](/tools/dart-vm)
  : The standalone VM

  [dart2native](/tools/dart2native)
  : A tool that AOT compiles Dart code to native x64 machine code,
  producing either a standalone executable or a snapshot

  [dartaotruntime](/tools/dartaotruntime)
  : A Dart runtime for AOT-compiled snapshots

  [dart2js](/tools/dart2js)
  : The Dart-to-JavaScript compiler (used only for web development)

  [dartanalyzer](/tools/dartanalyzer)
  : The static analyzer
  </div><div class="col-lg-6" markdown="1">
  [dartdevc](/tools/dartdevc)
  : The Dart development compiler
  (used only for web development)

  [dartdoc](/tools/dartdoc)
  : The API documentation generator

  [dartfmt](/tools/dartfmt)
  : The Dart code formatter

  [pub](/tools/pub)
  : The Dart package manager
  </div>
</div>

For more information about the SDK, see its
[README file.](https://github.com/dart-lang/sdk/blob/master/README.dart-sdk)

## Filing bugs and feature requests

To see existing issues or create a new one,
go to [dartbug.com](https://dartbug.com).
Here are some handy searches:

* [dart (VM) issues](https://github.com/dart-lang/sdk/labels/Area-VM)
* [dartanalyzer issues](https://github.com/dart-lang/sdk/labels/Area-Analyzer)
* [dartdoc issues](https://github.com/dart-lang/dartdoc/issues)
* [pub issues](https://github.com/dart-lang/sdk/labels/Area-Pub)
* [issues for the SDK as a whole](https://github.com/dart-lang/sdk/issues)

[Dart 2]: /dart-2
[build the SDK from source]: https://github.com/dart-lang/sdk/wiki/Building
[Dart libraries]: /guides/libraries/library-tour
[flutter]: https://flutter.dev/docs/get-started/install
[site SDK version]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}/index.html
