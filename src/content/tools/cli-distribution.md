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
