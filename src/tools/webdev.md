---
title: webdev
description: Command-line tools for Dart web development.
---
<!--?code-excerpt path-base="examples/ng/doc"?-->

This page explains how to use `webdev` and
a tool it depends on — `build_runner` —
to build, serve, and test your web apps.
The [webdev][] package provides `webdev`,
which wraps around the more general-purpose
[`build_runner` tool.][build_runner]

Usually you can use `webdev` instead of directly using `build_runner`.
The only time most web app developers run `build_runner` is for tests.

<aside class="alert alert-info" markdown="1">
  **Dart 2 note:**
  The `webdev` tool replaces the Dart 1.x `pub build` and `pub serve` commands.
</aside>

## Setup

The easiest way to get `webdev` is to globally install it,
so that it can be [in your PATH.][PATH]
Before you can use `webdev`,
your web app must depend on the
build_runner and build_web_compilers packages.


### Installing and updating webdev

[Globally install][] `webdev` using pub:

```terminal
$ pub global activate webdev
```

Use the same command to update `webdev`.
We recommend updating `webdev` whenever you update your Dart SDK
or when `webdev` commands unexpectedly fail.

[Globally install]: /tools/pub/cmd/pub-global


### Depending on build_* packages

To use `webdev` or (in a web app context) `build_runner`,
you must be in the root directory of a package that depends on 
the **build_runner** and **build_web_compilers** packages.
If you're testing the app,
it must also depend on **build_test**.

To depend on these packages,
add the following [dev dependencies][]
to your app's `pubspec.yaml` file:

<!--?code-excerpt "quickstart/pubspec.yaml (build dependencies)"?-->
```
  dev_dependencies:
    # ···
    build_runner: ^1.0.0
    build_test: ^0.10.2
    build_web_compilers: ^0.4.0
```

As usual after `pubspec.yaml` changes, run `pub get` or `pub upgrade`:

```terminal
$ pub get
```
## Using webdev and build_runner commands

This section describes how to use the following commands:

[webdev serve](#serve)
: Runs a development server that continuously builds a web app.

[webdev build](#build)
: Builds a deployable version of a web app.

[build_runner test](#test)
: Runs tests.

You can customize your build using build config files. For details, see
the [build_web_compilers README.][build_web_compilers]


### webdev serve {#serve}

To launch a development server, which serves your app and watches for source
code changes, use the following command:

```
webdev serve [--release] [ [<directory>[:<port>]] ... ]
```

By default, `webdev serve` compiles your app using [dartdevc][] and 
serves the app at [localhost:8080](localhost:8080):

```terminal
$ webdev serve  # uses dartdevc
```

The first dartdevc build is the slowest. After that, assets are cached on disk,
and incremental builds are much faster.

<aside class="alert alert-info" markdown="1">
  **Note:** The development compiler (dartdevc) supports **only Chrome.**
  To view your app in another browser,
  use the production compiler (dart2js).
  For a list of supported browsers, [see the FAQ][supported browsers].
</aside>

To use [dart2js][] instead of dartdevc, add the `--release` flag:

```terminal
$ webdev serve --release  # uses dart2js
```

You can specify different directory-port configurations. For example, the
following command changes the test port from the default (8081) to 8083:

```terminal
$ webdev serve web test:8083 # App: 8080; tests: 8083
```


### webdev build {#build}

Use the following command to build your app:

```
webdev build [--no-release] --output [<dirname>:]<dirname>
```

By default, the `build` command uses the [dart2js][] web compiler to create a
production version of your app. Add `--no-release` to compile with [dartdevc][].
Using the `--output` option, you can control which top-level project folders are
compiled and where output is written.

For example, the following command uses dart2js to compile the project's
top-level `web` folder into the `build` directory:

```terminal
$ webdev build --output web:build
```


### build_runner test {#test}

Use the `build_runner test` command to run your app's [component tests][]:

```
$ pub run build_runner test [build_runner options] -- -p <platform> [test options]
```

<aside class="alert alert-info" markdown="1">
  **Tip:**
  If the command fails to load the test file,
  make sure that your app's pubspec has a dev dependency on
  **build_test**.
</aside>

For example, here's how to run all Chrome platform tests:

```terminal
$ pub run build_runner test -- -p chrome
```

To see all available build_runner options, use the `--help` or `-h` option:

```terminal
$ pub run build_runner test -h
```

Arguments after the empty `--` argument
are passed directly to the [test package][] runner.
To see all command-line options for the test package runner,
use this command:

```terminal
$ pub run test -h
```


## More information

For a complete list of `webdev` options, run `webdev --help` or see the
[webdev package README.][webdev]

Also see the following pages:

* [build_runner:][build_runner]
  Introduces build_runner and its built-in commands,
  and points to more information.
* [build_web_compilers:][build_web_compilers]
  Has information on configuring builds,
  with an example of using `dart2js_args` to specify
  [dart2js options.][]

[build_runner]: /tools/build_runner
[build_runner test]: #test
[build_web_compilers]: {{site.pub-pkg}}/build_web_compilers
[component tests]: {{site.angulardart}}/guide/testing/component
[dart2js]: /tools/dart2js
[dart2js options.]: /tools/dart2js#options
[dartdevc]: /tools/dartdevc
[dev dependencies]: /tools/pub/dependencies#dev-dependencies
[PATH]: /tools/pub/cmd/pub-global#running-a-script-from-your-path
[supported browsers]: /faq#q-what-browsers-do-you-support-as-javascript-compilation-targets
[test package]: {{site.pub-pkg}}/test
[webdev]: {{site.pub-pkg}}/webdev
