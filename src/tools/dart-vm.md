---
layout: default
title: "dart (Dart VM)"
description: "The reference page for 'dart' at the command line."
short-title: "dart"
---

You can use the _dart_ tool (`bin/dart`) to run Dart command-line apps such as
server-side scripts, programs, and servers.

## Basic usage

Here’s an example of running a Dart file on the command line:

```terminal
$ dart --enable-asserts test.dart
```

<aside class="alert alert-info" markdown="1">
**Note:** You can't use `dart` to run mobile apps or web apps
(apps that include `dart:html`, or that depend on libraries
that use the browser environment).
</aside>

## Options

Common command-line options for dart include:

`--enable-asserts`
: Enables `assert` statements. When asserts are enabled, an
  [assert statement](/guides/language/language-tour#assert)
  checks a boolean condition, raising an exception if the condition is false.

`--packages=<path>`
: Specifies the path to the package resolution configuration file.
  For more information, see
  [Package Resolution Configuration File](https://github.com/lrhn/dep-pkgspec/blob/master/DEP-pkgspec.md).
  _This option cannot be used with `--package-root`._

`-p <path>` or `-package-root=<path>`
: Specifies where to find imported libraries.
  _This option cannot be used with `--packages`._

`--old_gen_heap_size=<num>`
: Sets the upper limit of
  [old space](https://dart-lang.github.io/observatory/glossary#old-generation) to `<num>` MB.

`--version`
: Displays VM version information.

`-h` or `--help`
: Displays help. (Add `-v` for information about all options.)

### Observatory options

Observatory is a tool for profiling and debugging your apps.
You can use the following flags to enable Observatory and to
instruct the VM to delay the start up, or the exit, of an isolate:

`--enable-vm-service`
: Enables Observatory on localhost port 8181.

`--enable-vm-service=<port>`
: Enables Observatory on localhost for the specific port.

`--enable-vm-service=<port>/<IP address>`
: Enables Observatory on an external network using the specified
  IP address and port. For example:
  `--enable-vm-service=9999/0.0.0.0`

`--pause-isolates-on-exit`
: Causes the VM to pause each isolate that would otherwise exit.
  If your standalone app executes quickly,
  it might exit before you can open Observatory. To avoid this situation,
  specify this flag on startup.  You must explicitly release all isolates
  in the [Observatory debugger](https://dart-lang.github.io/observatory/debugger.html).

`--pause-isolates-on-start`
: Causes the VM to pause before starting any isolate.
  You must explicitly start each isolate in the
  [Observatory debugger](https://dart-lang.github.io/observatory/debugger.html).

`--observe`
: A shortcut that combines `--enable-vm-service` and
  `--pause-isolates-on-exit`.

`--profile`
: On Windows, Observatory's
  [CPU Profiler](https://dart-lang.github.io/observatory/cpu-profile.html) screen
  is disabled by default. Use this option to enable it.

The following is an example Observatory run:

```terminal
$ dart --observe <script>.dart
```

For more information, see [Observatory.](https://dart-lang.github.io/observatory/)

### Snapshot option

You can also generate snapshots:

`--snapshot=<filename>`
: Generates a snapshot in the specified file. For information
  on generating and running snapshots, see
  [Snapshots](https://github.com/dart-lang/sdk/wiki/Snapshots) on GitHub.
