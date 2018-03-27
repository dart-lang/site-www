---
layout: default
title: "Obsolete Pub Features"
description: "As of Dart 2, pub no longer supports pub build/serve or transformers."
permalink: /tools/pub/obsolete
---

As of Dart 2, pub no longer supports `pub build`, `pub serve`, or transformers.
They're replaced by the **build system**, which includes the **build_runner** tool.

For information about building and serving apps in Dart 2, see the following:

* Web development:
  * [Setup for Angular development (v5)]({{site.webdev_dev}}/angular/guide/setup)
  * [Deployment (v5)]({{site.webdev_dev}}/angular/guide/deployment)
  * [Web-specific build_runner documentation]({{site.webdev_dev}}/tools/build_runner)
* General:
  * [Build system](https://github.com/dart-lang/build)
  * [Build system documents,](https://github.com/dart-lang/build/tree/master/docs) including
    [getting started with build_runner](https://github.com/dart-lang/build/blob/master/docs/getting_started.md#getting-started-with-build_runner)

If you use Dart 1.x for web development, see the following:

* [Setup for Angular development (v4)]({{site.webdev}}/angular/guide/setup)
* [Deployment (v4)]({{site.webdev}}/angular/guide/deployment)
* Pub command reference:
  * [pub build]({{site.webdev}}/tools/pub/pub-build)
  * [pub serve]({{site.webdev}}/tools/pub/pub-serve)


If you maintain a transformer, see the following:

* [Assets and Transformers]({{site.dartlang_v1}}/tools/pub/assets-and-transformers)
  in the [archived Dart site]({{site.dartlang_v1}})
* [Writing a Pub Transformer]({{site.dartlang_v1}}/tools/pub/transformers)
  in the [archived Dart site]({{site.dartlang_v1}})

For help in switching from Dart 1.x to Dart 2, see the Dart 2 migration guides:

* [Language and core library migration guide](/dart-2)
* [Web app migration guide]({{site.webdev_dev}}/dart-2)
