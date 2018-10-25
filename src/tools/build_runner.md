---
title: Build_runner
description: A tool for building, testing, and running Dart code.
---

The [build_runner][] package provides general-purpose commands for generating files,
optionally serving or testing the output files.

<aside class="alert alert-info" markdown="1">
  **If you're a web developer:**
  Use the [`webdev` tool][webdev] instead of directly using
  build_runner to build, serve, and test web apps.
</aside>

The build_runner commands work with _builders_—packages
that use the [Dart build system][build]
to specify how to generate output files from input files.
For example, the [json_serializable][] and [built_value_generator][]
packages define builders.
**[PENDING: are those good examples to point to?]**


## Setting up build_runner

To use build_runner, add these dev dependencies to your app's pubspec:

**[TODO: update the code-excerpt directive]**

<?code-excerpt "quickstart/pubspec.yaml (build dependencies)" title?>
```
  dev_dependencies:
    # ···
    build_runner: ^1.0.0
    build_test: ^0.10.3+3
```

The **build_test** package is optional; add it if you'll be testing your code.

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
  you should usually use [`webdev serve`.][webdev]

test
: Runs [tests.][tests]

watch
: Launches a build server that watches for edits to input files.
  Responds to changes by performing incremental rebuilds.


## More information

For details of using build_runner, see the following pages:

- [Getting started with build_runner][]
- Documentation and example code for the packages you use
  that depend on build or build_runner.

If you're working on web-specific code, see the [webdev documentation.][webdev]

[build]: https://github.com/dart-lang/build
[build_runner]: {{site.pub-pkg}}/build_runner
[built_value_generator]: {{site.pub-pkg}}/built_value_generator
[Getting started with build_runner]: https://github.com/dart-lang/build/blob/master/docs/getting_started.md
[json_serializable]: {{site.pub-pkg}}/json-serializable
[tests]: /guides/testing
[webdev]: {{site.webdev}}/tools/webdev
