---
title: dart pub global
description: Use dart pub global to run Dart scripts hosted on the pub.dev site from the command line.
---

_Global_ is one of the commands of the [pub tool](/tools/pub/cmd).

Pub's `global` option allows you to run Dart scripts from the
command line when you are not currently inside a package.
After [activating a package](#activating-a-package), you can
[run scripts](#running-a-script) from that package's `bin` directory.
[Deactivating a package](#deactivating-a-package) removes it from
your list of globally available packages.

For example, say you want to use [webdev][] to serve
your Dart web application from the command line.

```terminal
$ dart pub global activate webdev
$ webdev serve
```

If this doesn't work, you might need to
[set up your path](#running-a-script-from-your-path).

To run a Dart script from within a package, or from a
package that your package depends on, see [dart run](/tools/dart-run).

## Activating a package

```nocode
dart pub global activate [--noexecutables] [--executable=<name>] [--overwrite] <package> [version-constraint]
```

Activate a package when you want to be able to run
one or more of its executable files from the command line.
You can activate packages that live on the
[pub.dev site]({{site.pub}}), a Git repository,
or your local machine.
Once you've activated a package, see [Running a
script](#running-a-script) to run scripts from the package's
`bin` directory.

When you activate a package you can specify an optional version
constraint.  See the [constraint](#options) flag for usage examples.

### Activating a package on the pub.dev site

```terminal
$ dart pub global activate <pub.dev package>
```

Specify a package on the pub.dev site to activate it. For example:

```terminal
$ dart pub global activate markdown
```

### Activating a package with Git

```terminal
$ dart pub global activate --source git <Git URL>
$ dart pub global activate -sgit <Git URL>
```

Use `--source git` (or `-sgit`, for short) to activate
a package in a Git repository. The following examples,
which activate the `async_await` package on
[GitHub](https://github.com/), are equivalent:

```terminal
$ dart pub global activate --source git https://github.com/dart-lang/async_await.git
$ dart pub global activate -sgit https://github.com/dart-lang/async_await.git
```

Pub expects to find the package in the root of the Git repository.
To specify a different location, 
use the `--git-path` option with
a path relative to the repository root:

```terminal
$ dart pub global activate -sgit https://github.com/dart-lang/http.git --git-path pkgs/http/
```

### Activating a package on your local machine

```terminal
$ dart pub global activate --source path <path>
```

Use `activate --source path <path>` to activate a package on your local machine.
The following example activates the `stopwatch` package from the
`~/dart` directory:

```terminal
$ dart pub global activate --source path ~/dart/stopwatch
```

### Updating an activated package

Once a package has been activated, you can upgrade it by activating the
package again.

## Running a script

You can directly run a script from an activated package from the
command line. If you are unable to run the script directly,
you can also use `dart pub global run`.

### Running a script from your PATH

To run a script directly from the command line, add the [system cache][] `bin`
directory to your `PATH` environment variable.

For example, say you've activated the webdev package,
but you still can't run the command:

```terminal
$ dart pub global activate webdev
$ webdev serve
-bash: webdev: command not found
```

Verify that the `bin` directory for the system cache is in your path.
The following `PATH` variable, on macOS, includes the system cache:

```terminal
$ echo $PATH
/Users/<user>/homebrew/bin:/usr/local/bin:/usr/bin:/bin:[!/Users/<user>/.pub-cache/bin!]
```

If this directory is missing from your `PATH`,
locate the file for your platform and add it.

|-------------------+---------------------------|
|      Platform     |      Cache location       |
|-------------------|---------------------------|
| macOS or Linux | `$HOME/.pub-cache/bin`        |
| Windows<sup><strong>*</strong></sup> | `%LOCALAPPDATA%\Pub\Cache\bin` |
{:.table .table-striped}

<sup><strong>*</strong></sup> The exact location of the system cache
may vary for different versions of Windows.

You can now directly invoke the command:

{% prettify nocode tag=pre+code %}
$ cd web_project
$ [!webdev serve!]
{% endprettify %}

If the script still fails to run from the command line, the
package may not be [configured](#configuring-package-executables) for
this feature. You can still run the script using `dart pub global run`.

### Running a script using `dart pub global run`

```nocode
$ dart pub global run <package>:<executable> [args...]
```

Even if a script is not configured to be run from the command line,
you can still use `dart pub global run`.
The following command runs the `bin/bar.dart` script from the
`foo` package, passing in two arguments.

```terminal
$ dart pub global run foo:bar arg1 arg2
```

### Configuring package executables

If you are not a package developer, you can skip this section.

A package can expose some of its scripts as executables
that can be run directly from the command line. The script or scripts
must be listed in the
[`executables`](/tools/pub/pubspec#executables)
entry of the pubspec file.  For example, the following pubspec file
identifies `bin/helloworld.dart` as an executable for the helloworld
package:

```yaml
name: helloworld

executables:
  helloworld:
```

Failing to list a script under the `executables` tag reduces the script's
usability: unlisted scripts can be executed using `dart pub global run`, but not
directly from the command line.

## Deactivating a package

```terminal
$ dart pub global deactivate <package>
```

Use `deactivate` to remove a package from the list of available
global packages. For example:

```terminal
$ dart pub global deactivate markdown
```

You can no longer invoke the package's scripts using `dart pub global run`,
or at the command line.

## Listing active packages

```terminal
$ dart pub global list
```

Use `list` to list all currently active packages.

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `[version-constraint]`

Use `dart pub global activate <package> [version-constraint]` 
to specify a specific version of the package. 
For example, the following command pulls
the 0.6.0 version of the `markdown` package:

```terminal
$ dart pub global activate markdown 0.6.0
```

If you specify a range, pub picks the best version that meets that
constraint. For example:

```terminal
$ dart pub global activate foo <3.0.0
```

### `--no-executables`

Use `dart pub global activate <package> --no-executables`
to globally activate the specified package,
but not put any executables in `bin`.
You have to use `dart pub global run` to run any executables.

### `--executable=<name>` or `-x <name>`

Use with `dart pub global activate`
to add the specified executable to your PATH.
You can pass more than one of these flags.

For example, the following command adds `bar` and `baz`,
(but not any other executables that `foo` might define) 
to your PATH.

```terminal
$ dart pub global activate foo -x bar -x baz
```

### `--overwrite`

Use `dart pub global activate <package> --overwrite`
to overwrite any previously activated global executables
with the same name. If you don't specify this flag,
the preexisting executable will not be replaced.


{{site.alert.info}}
  *Problems?*
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
{{site.alert.end}}

[system cache]: /tools/pub/glossary#system-cache
[webdev]: /tools/webdev
