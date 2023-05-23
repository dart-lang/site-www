---
title: webdev
description: Command-line tools for Dart web development.
---

This page explains how to use `webdev` to compile your app and
`build_runner` to test your app.

## Setup

Follow these instructions to get started using `webdev`.

Before you can use `webdev`, Add dependencies to the [build_runner][] 
and [build_web_compilers][] packages to your app. The `build_runner`
package adds scripting capabilities to `webdev`.

```terminal
$ dart pub add build_runner build_web_compilers --dev
```

### Installing and updating webdev

Use `dart pub` to install `webdev` for [all users][].

```terminal
$ dart pub global activate webdev
```

Use the same command to update `webdev`. 
Update `webdev` when you update your Dart SDK or when `webdev` commands fail in a way you can't explain.

[all users]: /tools/pub/cmd/pub-global


### Depending on build_* packages

To use `webdev`, you must be in the root directory of a package that
depends on the **build_runner** and **build_web_compilers** packages.
If you're testing the app, it must also depend on **build_test**.

To depend on these packages, add the following [dev_dependencies][] to
your app's `pubspec.yaml` file:

```yaml
  dev_dependencies:
    # ···
    build_runner: ^2.4.1
    build_test: ^2.1.7
    build_web_compilers: ^4.0.3
```

As usual after `pubspec.yaml` changes, run `dart pub get` or 
`dart pub upgrade`:

```terminal
$ dart pub get
```

## Using commands from Dart packages to compile and test

This tool can compile in two ways: one that makes debugging easier
(`serve`) and one that makes for small, fast code (`build`).

The development compiler supports incremental updates and produces
[Asynchronous Module Definition (AMD) modules.](https://github.com/amdjs/amdjs-api/blob/master/AMD.md#amd).
With [`webdev serve`](#serve), you can edit your Dart files, refresh in
Chrome, and see your edits in short order. This speed comes from
compiling updated modules, not all the packages that your app requires.

The first compilation takes the longest as it compiles the entire app.
While [`serve`](#serve) command runs, successive builds should compile
faster.

The production compiler generates a single, minified JavaScript file.

This section describes how to use the following commands:

[webdev serve](#serve)
: Runs a development server that continuously builds a JavaScript app.

[webdev build](#build)
: Builds a deployable version of a JavaScript app.

[build_runner test](#test)
: Runs tests.

You can customize your build using build configuration files. 
To learn more about build configuration files, see the 
[build_web_compilers][] package.

### webdev serve {#serve}

To serve a development version of your web app, run the following
command.

```terminal
$ webdev serve [--debug | --release] [ [<directory>[:<port>]] ... ]
```

This command launches a development server that serves your app and
watches for source code changes. By default, this command serves the
 app at [localhost:8080](localhost:8080):

```terminal
$ webdev serve
```

The first `webdev serve` compiles slow. After the first compile, it caches
assets on disk. This makes later builds compile faster.

{{site.alert.note}}
  The development compiler supports **only Chrome.**
  To view your app in another browser,
  use the production compiler.
  For a list of supported browsers, [see the FAQ][supported browsers].
{{site.alert.end}}

To enable [Dart DevTools][], add the `--debug` flag:

```terminal
$ webdev serve --debug  # enables Dart DevTools
```

To use production compiler instead of development compiler, add the `--release` flag:

```terminal
$ webdev serve --release  # uses production compiler
```

You can specify different directory-port configurations. 

For example, the following command changes the test port from the
default (8081) to 8083:

```terminal
$ webdev serve web test:8083 # App: 8080; tests: 8083
```

### webdev build {#build}

Use the following command to build your app:

```terminal
$ webdev build [--no-release] --output [<dirname>:]<dirname>
```

By default, the `build` command uses the production JavaScript compiler to create a production version of your app. Add `--no-release` to compile with the development JavaScript compiler. Use the `--output` option to control where Dart compiles top-level project folders and writes its output.

The following command shows how to compile the project's top-level
`web` folder into the `build` directory. This command uses the
production JavaScript compiler by default.

```terminal
$ webdev build --output web:build
```


### build_runner test {#test}

Use the `build_runner test` command to run your app's component tests:

```
$ dart run build_runner test [build_runner options] -- -p <platform> [test options]
```

{{site.alert.tip}}
  If the command fails to load the test file,
  make sure that your app's `pubspec` has a `dev_dependency` on `build_test`.
{{site.alert.end}}

For example, here's how to run all Chrome platform tests:

```terminal
$ dart run build_runner test -- -p chrome
```

To see all available build_runner options, use the `--help` or `-h` option:

```terminal
$ dart run build_runner test -h
```

Dart passes arguments after the empty `--` argument directly to the
[test package][] runner. To see all command-line options for the
test package runner, use this command:

```terminal
$ dart test -h
```


## More information

For a complete list of `webdev` options, run `webdev --help` or see the
[webdev package][webdev].

Also see the following pages:

* [build_runner:][build_runner]
  Introduces build_runner and its built-in commands,
  and points to more information.
* [build_web_compilers:][build_web_compilers]
  Has information on configuring builds,
  with an example of using `dart2js_args` to specify
  [compiler options](/tools/dart-compile#js).

[build_runner]: /tools/build_runner
[build_runner test]: #test
[build_web_compilers]: {{site.pub-pkg}}/build_web_compilers
[Dart DevTools]: /tools/dart-devtools
[dev_dependencies]: /tools/pub/dependencies#dev-dependencies
[PATH]: /tools/pub/cmd/pub-global#running-a-script-from-your-path
[supported browsers]: /resources/faq#q-what-browsers-do-you-support-as-javascript-compilation-targets
[test package]: {{site.pub-pkg}}/test
[webdev]: {{site.pub-pkg}}/webdev
