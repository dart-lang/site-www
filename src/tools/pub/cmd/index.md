---
title: dart pub
description: The command-line interface for pub, a package management tool for Dart.
---

The [pub package manager](/guides/packages) has a command-line interface
that works with either the
[`flutter` tool][flutter-cli] or the [`dart` tool][dart-cli].
With either tool, add the `pub` command followed by
a subcommand such as `get`:

```terminal
$ dart pub get    # Gets dependencies for a non-Flutter package
$ flutter pub get # Gets dependencies for a Flutter package
```

This site uses `dart pub <subcommand>` for its examples,
but if your current directory holds a Flutter app
or other Flutter-specific code,
use `flutter pub <subcommand>` instead.
For more information, see
[Using packages]({{site.flutter-docs}}/development/packages-and-plugins/using-packages)
on the [Flutter website]({{site.flutter}}).

[flutter-cli]: {{site.flutter-docs}}/reference/flutter-cli
[dart-cli]: /tools/dart-tool

{{site.alert.version-note}}
  The `dart pub` command debuted in Dart 2.10.
  Although you might still find examples of
  using the standalone `pub` command instead of
  `dart pub` or `flutter pub`,
  the standalone `pub` command has been removed.
{{site.alert.end}}

If you encounter problems using the pub tool,
see [Troubleshooting Pub](/tools/pub/troubleshoot).


## List of subcommands

Detailed documentation exists for each of the following pub subcommands:

{% include pub-subcommands.md %}

## Overview of subcommands

Pub's subcommands fall into the following categories:

* [Managing package dependencies](#managing-apps)
* [Running command-line apps](#running-command-line-apps)
* [Deploying packages and apps](#deploying-packages-and-apps)


<a id="managing-apps"></a>
### Managing package dependencies

Pub provides a number of subcommands for managing the
[packages your code depends on](/tools/pub/dependencies).

In this group, the most commonly used subcommands are `get` and
`upgrade`, which retrieve or upgrade dependencies used by a package.
Every time you modify a pubspec file,
run `dart pub get` or `flutter pub get`
to make sure the dependencies are up to date. Some IDEs
perform this step automatically on the creation of a project,
or any modification of the pubspec.

[`cache`](/tools/pub/cmd/pub-cache)
: Manages pub's local package cache. Use this subcommand to add packages
  to your cache, or to perform a clean reinstall of all packages in
  your cache.

[`deps`](/tools/pub/cmd/pub-deps)
: Lists all dependencies used by the current package.

[`downgrade`](/tools/pub/cmd/pub-downgrade)
: Retrieves the lowest versions of all the packages that are
  listed as dependencies used by the current package. Used for testing
  the lower range of your package's dependencies.

[`get`](/tools/pub/cmd/pub-get)
: Retrieves the packages that are listed as the dependencies for
  the current package.
  If a `pubspec.lock` file already exists, fetches the version
  of each dependency (if possible) as listed in the lock file.
  Creates or updates the lock file, as needed.

[`outdated`](/tools/pub/cmd/pub-outdated)
: Looks at every package that the current package depends on,
  determines which package dependencies are out of date,
  and gives you advice on how to update them.
  Use this subcommand when you want to update package dependencies.

[`upgrade`](/tools/pub/cmd/pub-upgrade)
: Retrieves the latest version of each package listed
  as dependencies used by the current package. If a `pubspec.lock`
  file exists, ignores the versions listed in the lock file and fetches
  the newest versions that honor the constraints in the pubspec.
  Creates or updates the lock file, as needed.


### Running command-line apps

The [`global`](/tools/pub/cmd/pub-global) subcommand lets you 
make a package globally available, 
so you can run scripts from that package's `bin` directory.
To run globally available scripts, you must
[add the system cache `bin` directory to your path][add-path].

[add-path]: /tools/pub/cmd/pub-global#running-a-script-from-your-path

### Deploying packages and apps

With pub you can publish packages and command-line apps.

#### Packages

To share your Dart packages with the world, you can
use the [`publish`](/tools/pub/cmd/pub-lish) subcommand to upload the
package to the [pub.dev site]({{site.pub}}).
For information on allowing other users 
to modify and upload new versions of your package,
see [Uploaders](/tools/pub/publishing#uploaders).


#### Command-line apps

For any package that contains scripts (anything under the `bin/`
directory), consider adding the `executables` tag to the pubspec file.
When a script is listed under `executables`, users can run
[`dart pub global activate`](/tools/pub/cmd/pub-global#activating-a-package)
to make it directly available from the command line.


## Global options

Several command-line options work with all of the pub subcommands.
These include:

### `--help` or `-h`

Prints usage information.

### `--trace`

Prints debugging information when an error occurs.

### `--verbose` or `-v`

Equivalent to `--verbosity=all`.

### `--directory=<dir>` or `-C <dir>`

Runs the command in the specified directory.

### `--[no-]color`

Adds color to the output for emphasis (`--color`).
The default depends on whether you're using this command at a terminal.
At a terminal, `--color` is the default,
otherwise, `--no-color` is the default.
Use `--no-color` to disable color in all environments.

