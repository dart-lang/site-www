---
title: Packaging and distributing Dart CLI tools
description: A guide for creating, building, and distributing command-line applications in Dart.
---

:::version-note
Dart 3.10 introduced support for `dart install`
and stable build hooks (`hook/build.dart`).
Dart 3.9 introduced the `dart build cli` command
for compiling CLI apps.
:::

A Dart CLI tool is a standalone command-line application
distributed via the Pub package manager.
Creating your own CLI tools allows you to share developer utilities,
build scripts, or fully-featured desktop console applications
with the broader Dart ecosystem.

## Writing entrypoints

When a user installs a tool via [`dart install`][],
Pub looks for the entrypoints defined in your package's `pubspec.yaml` file.

Create a Dart script in the `bin/` directory of your package.
For example, `bin/my_tool.dart`:

```dart
void main(List<String> arguments) {
  print('Hello from my tool!');
}
```

Then, map this script to a command name in your `pubspec.yaml`
using the `executables` section:

```yaml
name: my_package
version: 1.0.0
# ... other metadata

executables:
  my_tool: my_tool
```

The key (`my_tool`) is the name of the executable command
that Pub places on the user's PATH,
and the value (`my_tool`) corresponds to the `bin/my_tool.dart` script.

## Compiling via dart build cli

Starting in Dart 3.9, you can explicitly compile CLI applications
using the `dart build cli` command.

Under the hood, `dart install` automatically invokes `dart build cli`
to create **AOT-compiled, self-contained native executables** for your tool.

AOT (Ahead-of-Time) compilation means your tool starts up instantly
without booting a Dart VM or JIT-compiling code dynamically,
leading to much faster and more consistent execution times for your users.

## Accessing the Dart SDK and spawning subprocesses

When building tools that invoke other developer commands (such as `dart format`, `dart test`, or code generators),
be mindful of the execution environment difference between JIT snapshots and AOT binaries.

### The AOT Platform.resolvedExecutable gotcha

Under legacy `dart pub global activate` (which ran inside the Dart JIT VM),
`Platform.resolvedExecutable` pointed directly to the `<dart-sdk>/bin/dart` binary.
Many legacy packages located SDK libraries by navigating relative to this path:

```dart
// ❌ UNSAFE under AOT compilation ('dart install')
final sdkDir = path.dirname(path.dirname(Platform.resolvedExecutable));
```

Under `dart install` (and `dart compile exe`),
`Platform.resolvedExecutable` points to **your compiled application binary**
(for example, in `~/.dart/install/app-bundles/<package>/.../bundle/bin/<executable>`),
**not** the Dart SDK runtime.

If your tool attempts to:
1. Locate SDK libraries relative to `Platform.resolvedExecutable`, the lookup fails
   because the tool's application bundle does not contain SDK compiler artifacts.
2. Spawn a subprocess using `Platform.executable` or `Platform.resolvedExecutable`,
   it recursively executes your tool binary in an infinite loop instead of running `dart`.

### Recommended solution: package:cli_util

To safely discover the host Dart SDK and locate the `dart` binary under both JIT and AOT compilation,
use [`package:cli_util`](https://pub.dev/packages/cli_util) (version `^0.6.0` or later):

```yaml
dependencies:
  cli_util: ^0.6.0
```

`package:cli_util` implements a resilient 4-tier probe
(validating active runtime path, `DART_SDK` environment variable, system `PATH` resolution including Flutter's bundled SDK, and `FLUTTER_ROOT` fallback):

```dart
import 'dart:io';
import 'package:cli_util/cli_util.dart';

void runTool() {
  // 1. Get the path to the Dart SDK root directory (or null if not found)
  final String? sdk = sdkPath;

  // 2. Get the path to the host `dart` executable for subprocess spawning
  final String? dart = dartExecutable;

  if (dart != null) {
    // Safely spawn a child Dart process
    Process.runSync(dart, ['format', '.']);
  }
}
```

## Adding build hooks

If your CLI tool depends on native C/C++ libraries
or needs to bundle specific data assets,
you can utilize [code assets and build hooks](/tools/hooks).

By writing a `hook/build.dart` script,
you can instruct the Dart SDK to compile or download native dependencies
when the user installs your package.
`dart install` fully supports these hooks,
ensuring the compiled output (dynamic libraries and assets)
is placed alongside the AOT-compiled executable in the application bundle.

## Distribution

Once your package is published to pub.dev (or pushed to a Git repository),
users can install it globally using the [`dart install`][] command:

```console
$ dart install my_package
```

This command resolves dependencies,
runs any build hooks,
AOT-compiles the executable,
and places the resulting binary in the `$DART_DATA_HOME/install/bin` directory.

Depending on the platform, the default location is:

| Platform | Default path |
|---|---|
| **macOS** | `$HOME/Library/Application Support/Dart/install/bin` |
| **Linux** | `$HOME/.local/share/dart/install/bin` (or `$XDG_DATA_HOME/dart/install/bin`) |
| **Windows** | `%LOCALAPPDATA%\Dart\install\bin` |

### Migrating users from pub global

If you maintain an existing Dart CLI package,
update your documentation (such as your `README.md`)
to recommend `dart install` instead of the legacy `dart pub global activate` command.
`dart install` produces faster,
self-contained applications that are uncoupled from the host Dart SDK version.

[`dart install`]: /tools/dart-install
