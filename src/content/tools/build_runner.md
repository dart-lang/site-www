---
title: build_runner
description: A tool for building, testing, and running Dart code.
---

The [build_runner][] package provides general-purpose commands for
generating files, including testing the generated files
or serving both source and generated files.
This page explains how to use `build_runner`.
To learn how to use build_runner with a specific package,
see the documentation for that package.

:::note
If you're a web developer, use the [`webdev` tool][webdev] to
build and serve web apps.
:::

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

<?code-excerpt "build_runner_usage/pubspec.yaml" from="dev_dependencies" to="build_test" replace="/args.*/# ···/g"?>
```yaml
dev_dependencies:
  # ···
  build_runner: ^2.4.15
  build_test: ^2.2.3
```

Depending on **build_test** is optional; do it if you'll be testing your code.

As usual after `pubspec.yaml` changes, run `dart pub get` or `dart pub upgrade`:

```console
$ dart pub get
```

## Using built-in commands

The following is an example of using the build_runner **build** command:

```console
$ # From a directory that contains a pubspec.yaml file:
$ dart run build_runner build
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

[build]: {{site.repo.dart.org}}/build
[Build FAQ]: {{site.repo.dart.org}}/build/blob/master/docs/faq.md
[build_runner]: {{site.pub-pkg}}/build_runner
[built_value_generator]: {{site.pub-pkg}}/built_value_generator
[dev dependency]: /tools/pub/dependencies#dev-dependencies
[Getting started with build_runner]: {{site.repo.dart.org}}/build/blob/master/docs/getting_started.md
[json_serializable]: {{site.pub-pkg}}/json_serializable
[on build]: {{site.pub-pkg}}?q=dependency%3Abuild
[on build_runner.]: {{site.pub-pkg}}?q=dependency%3Abuild_runner
[sass_builder]: {{site.pub-pkg}}/sass_builder
[tests]: /tools/testing
[webdev]: /tools/webdev
[webdev serve]: /tools/webdev#serve
