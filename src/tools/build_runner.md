---
title: build_runner
description: A tool for building, testing, and running Dart code.
---

The [build_runner][] package provides general-purpose commands for generating files,
and for optionally testing the generated files
or serving both source and generated files.
Read this page for an overview of using build_runner, with links to
where you can find more information.
For details of using build_runner with a specific package,
see the documentation for that package.

<aside class="alert alert-info" markdown="1">
  **If you're a web developer:**
  You can use the [`webdev` tool][webdev] instead of directly using
  build_runner to build and serve web apps.
</aside>

The build_runner commands work with _builders_—packages
that use the [Dart build system][build]
to generate output files from input files.
For example, the [json_serializable][] and [built_value_generator][]
packages define builders that generate Dart code.

Although the Dart build system is a good alternative to
reflection (which has performance issues) and
macros (which Dart's compilers don't support),
it can do more than just read and write Dart code.
For example, the [sass_builder][] package implements a builder that
generates `.css` files from `.scss` and `.sass` files.


## Setting up build_runner

To use build_runner, add a [dev dependency][] on **build_runner**
to your app's pubspec:

```
  dev_dependencies:
    # ···
    build_runner: ^1.0.0
    build_test: ^0.10.3
```

Depending on **build_test** is optional; do it if you'll be testing your code.

As usual after `pubspec.yaml` changes, run `pub get` or `pub upgrade`:

```terminal
$ pub get
```

## Using built-in commands

How you use the build_runner commands depends on whether you're using
the Dart SDK or the Flutter SDK.
Here are examples of using the build_runner **build** command:

```terminal
$ # From a directory that contains a pubspec.yaml file:
$ pub run build_runner build  # Dart SDK
$ flutter packages pub run build_runner build  # Flutter SDK
```

The build_runner package includes the following commands:

build
: Performs a one-time build.

serve
: Runs a development server.
  Instead of directly using this command,
  you can use [`webdev serve`,][webdev serve]
  which has convenient default behavior.

test
: Runs [tests.][tests]

watch
: Launches a build server that watches for edits to input files.
  Responds to changes by performing incremental rebuilds.


## More information

If you're working on web-specific code,
see the [webdev page.][webdev]

For details on using build_runner, see the following:

- Documentation for packages that require you to use build_runner.
  These packages generally have a dependency
  [on build][] or [on build_runner.][]
- Build_runner documentation:
  - [Getting started with build_runner][]
  - [Build FAQ][]

[build]: https://github.com/dart-lang/build
[Build FAQ]: https://github.com/dart-lang/build/blob/master/docs/faq.md
[build_runner]: {{site.pub-pkg}}/build_runner
[built_value_generator]: {{site.pub-pkg}}/built_value_generator
[dev dependency]: /tools/pub/dependencies#dev-dependencies
[Getting started with build_runner]: https://github.com/dart-lang/build/blob/master/docs/getting_started.md
[json_serializable]: {{site.pub-pkg}}/json_serializable
[on build]: {{site.pub-pkg}}?q=dependency%3Abuild
[on build_runner.]: {{site.pub-pkg}}?q=dependency%3Abuild_runner
[sass_builder]: {{site.pub-pkg}}/sass_builder
[tests]: /guides/testing
[webdev]: /tools/webdev
[webdev serve]: /tools/webdev#serve
