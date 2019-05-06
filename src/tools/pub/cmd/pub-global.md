---
title: pub global
description: Use pub global to run Dart scripts hosted on the Pub site from the command line.
---

_Global_ is one of the commands of the [pub tool](/tools/pub/cmd).

Pub's `global` option allows you to run Dart scripts from the
command line when you are not currently inside a package.
After [activating a package](#activating-a-package), you can
[run scripts](#running-a-script) from that package's `bin` directory.
[Deactivating a package](#deactivating-a-package) removes it from
your list of globally available packages.

For example, say you want to run
[Stagehand]({{site.pub}}/packages/stagehand)
the Dart project generator, from the command line.

```terminal
$ pub global activate stagehand
$ stagehand
```

If this doesn't work, you may need to
[set up your path](#running-a-script-from-your-path).

To run a Dart script from within a package, or from a
package that your package depends on, see [pub run](/tools/pub/cmd/pub-run).

## Activating a package

```nocode
pub global activate [--noexecutables] [--executable=<name>] [--overwrite] <package> [constraint]
```

You can activate packages that live on the
[Pub site]({{site.pub}}), a Git repository,
or your local machine.
Once you have activated a package, see [Running a
script](#running-a-script) to run scripts from the package's
`bin` directory.

When you activate a package you can specify an optional version
constraint.  See the [constraint](#options) flag for usage examples.

### Activating a package on the Pub site

```terminal
$ pub global activate <pub.dartlang package>
```

Specify a package on the Pub site to activate it. For example:

```terminal
$ pub global activate markdown
```

### Activating a package with Git

```terminal
$ pub global activate --source git <Git URL>
$ pub global activate -sgit <Git URL>
```

Use `--source git` (or `-sgit`, for short) to activate
a package in a Git repository. The following examples,
which activate the `async_await` package on
[GitHub](https://github.com/), are equivalent:

```terminal
$ pub global activate --source git https://github.com/dart-lang/async_await.git
$ pub global activate -sgit https://github.com/dart-lang/async_await.git
```

### Activating a package on your local machine

```terminal
$ pub global activate --source path <path>
```

Use `activate --source path <path>` to activate a package on your local machine.
The following example activates the `stopwatch` package from the
`~/dart` directory:

```terminal
$ pub global activate --source path ~/dart/stopwatch
```

### Updating an activated package

Once a package has been activated, you can upgrade it by activating the
package again.

## Running a script

You can directly run a script from an activated package from the
command line. If you are unable to run the script directly,
you can also use `pub global run`.

### Running a script from your PATH

To run a script directly from the command line, add the `bin` file
for the [system cache](/tools/pub/glossary#system-cache) to your path.

For example, say you've activated the Stagehand script,
but you still can't run the command:

```terminal
$ pub global activate stagehand
$ stagehand
-bash: stagehand: command not found
```

Verify that the `bin` directory for the system cache is in your path.
The following path, on macOS, includes the system cache.

{% prettify none %}
$ echo $PATH
[!/Users/<user>/.pub-cache/bin!]:/Users/<user>/homebrew/bin:/usr/local/bin:/usr/bin:/bin
{% endprettify %}

If this directory is missing from your path,
locate the file for your platform and add it.

|-------------------+---------------------------|
|      Platform     |      Cache location       |
|-------------------|---------------------------|
| macOS or Linux | `$HOME/.pub-cache/bin`        |
| Windows<sup><strong>*</strong></sup> | `%APPDATA%\Pub\Cache\bin` |
{:.table .table-striped}

<sup><strong>*</strong></sup> The exact location of the system cache
may vary for different versions of Windows.

You can now directly invoke the command:

{% prettify none %}
$ mkdir angular_project
$ cd angular_project
$ [!stagehand web-angular!]
{% endprettify %}

If the script still fails to run from the command line, the
package may not be [configured](#configuring-package-executables) for
this feature. You can still run the script using `pub global run`.

### Running a script using `pub global run`

```nocode
$ pub global run <package>:<executable> [args...]
```

Even if a script is not configured to be run from the command line,
you can still use `pub global run`.
The following command runs the `bin/bar.dart` script from the
`foo` package, passing in two arguments.

```terminal
$ pub global run foo:bar arg1 arg2
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

{% prettify yaml %}
name: helloworld

executables:
  helloworld:
{% endprettify %}

Failing to list a script under the `executables` tag reduces the script's
usability: unlisted scripts can be executed using `pub global run`, but not
directly from the command line.

## Deactivating a package

```terminal
$ pub global deactivate <package>
```

Use `deactivate` to remove a package from the list of available
global packages. For example:

```terminal
$ pub global deactivate markdown
```

You can no longer invoke the package's scripts using `pub global run`,
or at the command line.

## Listing active packages

```terminal
$ pub global list
```

Use `list` to list all currently active packages.

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

`<constraint>`
: Optional for `pub global activate`. The constraint allows you to pull
  in a specific version of the package. For example,
  the following command pulls the 0.6.0 version of the `markdown`
  package:

  ```terminal
  $ pub global activate markdown 0.6.0
  ```

  If you specify a range, pub picks the best version that meets that
  constraint. For example:

  ```terminal
  $ pub global activate foo <3.0.0
  ```

`--executable=<name>` or `-x<name>`
: Optional for `pub global activate`.
  Adds the specified executable to your PATH.
  You can pass more than one of these flags.
  For example, the following command adds `bar` and `baz` (but not
  any other executables that `foo` might define) to your PATH.

  ```terminal
  $ pub global activate foo -x bar -x baz
  ```

`--no-executables`
: Optional for `pub global activate`.
  Globally activates the package but doesn't put any
  executables in `bin`. You have to use `pub global run` to
  run any executables.

`--overwrite`
: Optional for `pub global activate`.
  Normally, if executables from two global packages have a name
  collision, the preexisting executable wins. If you specify this flag,
  the new executable overwrites the previously activated executable.

<aside class="alert alert-info" markdown="1">
  *Problems?* See [Troubleshooting pub](/tools/pub/troubleshoot).
</aside>
