---
title: Dart SDK
description: Dart libraries and command-line tools.
permalink: /tools/sdk
---

The Dart SDK has the libraries and command-line tools
that you need to develop Dart applications.
To learn about other tools you can use for Dart development,
see [Dart Tools](/tools).

## Getting the SDK

Although
<a href="{{site.custom.dartpad.direct-link}}" target="_blank">DartPad</a>
is a great way to learn how to write a simple app in the Dart
language, once you are ready to start doing real-world development,
you need the Dart SDK.

[Install the Dart SDK](/install).

## What's in the SDK

The SDK directory includes a `lib` directory for the
[Dart libraries](/guides/libraries/library-tour)
and a `bin` directory that has these command-line tools:

<div class="row"> <div class="col-md-6" markdown="1">

[dart](/dart-vm)
: The standalone VM

[dart2js]({{site.webdev}}/tools/dart2js)
: The Dart-to-JavaScript compiler (used only for web development)

[dartanalyzer](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer)
: The static analyzer

[dartdevc]({{site.webdev}}/tools/dartdevc)
: The Dart development compiler
(used only for web development)

</div> <div class="col-md-6" markdown="1">

[dartdoc](https://github.com/dart-lang/dartdoc#dartdoc)
: The API documentation generator

[dartfmt](https://github.com/dart-lang/dart_style#readme)
: The Dart code formatter

[pub](/tools/pub)
: The Dart package manager

</div> </div>

For more information about the SDK, see its
[README file](https://github.com/dart-lang/sdk/blob/master/README.dart-sdk).

## Installing the SDK

{% include configure-path.html %}

If you are using an IDE, such as WebStorm, you
must also set the location to the SDK. In WebStorm,
you specify the path in
**Preferences** > **Languages & Frameworks** > **Dart**.

## Filing bugs and feature requests

To see existing issues or create a new one,
go to [dartbug.com](http://dartbug.com).
Here are some handy searches:

* [dart (VM) issues](https://github.com/dart-lang/sdk/labels/Area-VM)
* [dartanalyzer issues](https://github.com/dart-lang/sdk/labels/Area-Analyzer)
* [dartdoc issues](https://github.com/dart-lang/dartdoc/issues)
* [pub issues](https://github.com/dart-lang/sdk/labels/Area-Pub)
* [issues for the SDK as a whole](https://github.com/dart-lang/sdk/issues)
