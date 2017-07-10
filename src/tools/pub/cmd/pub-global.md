---
layout: default
permalink: /tools/pub/cmd/pub-global
title: "pub global"
description: "Use pub global to run Dart scripts hosted on pub.dartlang.org from the command line."

header:
  css: ["../transformers/transformers.css"]
---

_Global_ is one of the commands of the _pub_ tool.
[Learn more about pub](/tools/pub).

Pub's `global` option allows you to run Dart scripts from the
command line when you are not currently inside a package.
You first [activate a package](#activating-a-package), then you can
[run scripts](#running-a-script) from that package's `bin` directory.
[Deactivating a package](#deactivating-a-package) removes it from
your list of globally available packages.

To run a Dart script from within a package, or from a
package that your package depends on, see [pub run](/tools/pub/cmd/pub-run).

## Activating a package

{% prettify sh %}
$ pub global activate [--noexecutables] [--executable=<name>] [--overwrite] <package> [constraint]
{% endprettify %}

Use `activate` to enable running a package's executables from any
directory on your machine.
You can activate a package from [pub.dartlang.org](https://pub.dartlang.org/),
a Git repository, or your local machine.
Once you have activated a package, see [Running a script](#running-a-script)
to run scripts from the package's `bin` directory.

When you activate a package you can specify an optional version constraint.
See the [constraint](#options) flag for usage examples.

### Activating a package on pub.dartlang.org

{% prettify sh %}
$ pub global activate <pub.dartlang package>
{% endprettify %}

Specify a package on pub.dartlang.org to activate it. For example:

{% prettify sh %}
$ pub global activate markdown
{% endprettify %}

### Activating a package with Git

{% prettify sh %}
$ pub global activate --source git <Git URL>
$ pub global activate -sgit <Git URL>
{% endprettify %}

Use `--source git` (or `-sgit`, for short) to activate
a package in a Git repository. The following examples,
which activate the `async_await` package on
[GitHub](https://github.com/), are equivalent:

{% prettify sh %}
pub global activate --source git https://github.com/dart-lang/async_await.git
pub global activate -sgit https://github.com/dart-lang/async_await.git
{% endprettify %}

### Activating a package on your local machine

{% prettify sh %}
$ pub global activate --source path <path>
{% endprettify %}

Use `activate --source path <path>` to activate a package on your local machine.
The following example activates the `stopwatch` package from the
`~/dart` directory:

{% prettify sh %}
pub global activate --source path ~/dart/stopwatch
{% endprettify %}

### Updating an activated package

Once a package has been activated, you can upgrade it by activating the
package again.

## Running a script

You can run a script from an activated package explicitly using
`pub global run`. If the script has been added to the
`executables` tag in its pubspec file, and the bin directory in
the cache has been added to your path, you can run the script
directly from the command line.

### Running a script using `pub global run`

{% prettify sh %}
$ pub global run <package>:<executable> [args...]
{% endprettify %}

Once you have [activated a package](#activating-a-package), use
`run` to run a script from the package's `bin` directory.
You can also specify arguments. The following command
runs the `bin/bar.dart` script from the `foo` package,
and passes in two arguments.

{% prettify sh %}
$ pub global run foo:bar arg1 arg2
{% endprettify %}


### Running a script from your PATH

In order to run a script directly from your path, it must be specified
under the `executables` tag in its pubspec file.

For example, activate Stagehand, the Dart project generator:

{% prettify sh %}
$ pub global activate stagehand
{% endprettify %}

This command installs the package to the system cache on your machine.
Because the `stagehand` executable is listed under the `executables` tag
in the pubspec file, pub creates a corresponding shell script in the `bin`
directory of the system cache.

If you haven't already done so, add the bin directory for the
[system cache](/tools/pub/glossary#system-cache)
(maintained by the [`pub cache`](/tools/pub/cmd/pub-cache) command),
to your path. On Mac and Linux, add `~/.pub-cache/bin` to your path.
On Windows, add `C:\Users\<user name>\AppData\Roaming\Pub\Cache\bin`
to your path. (This path is valid for Windows 10, but may vary depending
on the Windows version.)

You can now directly invoke the command. For example:

{% prettify sh %}
$ mkdir angular-project
$ cd angular-project
$ [[highlight]]stagehand web-angular[[/highlight]]
{% endprettify %}

### Configuring a package

If you are not a package developer, you can skip these instructions.

A package may choose to expose some of its scripts as executables
that can be run directly from the command line.  The script must
be listed in the [`executables`](/tools/pub/pubspec.html#executables)
entry of the pubspec file.  For example, the following pubspec file
identifies `bin/helloworld.dart` as an executable for the helloworld package:

{% prettify yaml %}
name: helloworld

executables:
  helloworld:
{% endprettify %}

Failing to list a script under the `executables` tag limits how it can
be used&mdash;it can be executed using `pub global run`, but not
directly from the command line.

## Deactivating a package

{% prettify sh %}
$ pub global deactivate <package>
{% endprettify %}

Use `deactivate` to remove a package from the list of available
global packages. For example:

{% prettify sh %}
$ pub global deactivate markdown
{% endprettify %}

You can no longer invoke the package's scripts using `pub global run`,
or at the command line.

## Listing active packages

{% prettify sh %}
$ pub global list
{% endprettify %}

Use `list` to list all currently active packages.

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

`constraint`
: Optional for `pub global activate`. The constraint allows you to pull
  in a specific version of the package. For example,
  the following command pulls the 0.6.0 version of the `markdown` package:

<div class="step-details" markdown="1">
{% prettify sh %}
$ pub global activate markdown 0.6.0
{% endprettify %}
</div>

  If you specify a range, pub picks the best version that meets that constraint.
  For example:

<div class="step-details" markdown="1">
{% prettify sh %}
$ pub global activate foo <3.0.0
{% endprettify %}
</div>

`--executable=<name>` or `-x<name>`
: Optional for `pub global activate`.
  Adds the specified executable to your PATH.
  You can pass more than one of these flags.
  For example, the following command adds `bar` and `baz` (but not
  any other executables that `foo` might define) to your PATH.

<div class="step-details" markdown="1">
{% prettify sh %}
$ pub global activate foo -x bar -x baz
{% endprettify %}
</div>

`--no-executables`
: Optional for `pub global activate`.
  Globally activates the package but doesn't put any
  executables in `bin`. You have to use `pub global run` to
  run any executables.

`--overwrite`
: Optional for `pub global activate`.
  Normally, if executables from two global packages have a name collision,
  the preexisting executable wins. If you specify this flag,
  the new executable overwrites the previously activated executable.

<aside class="alert alert-info" markdown="1">
*Problems?*
See [Troubleshooting Pub](/tools/pub/troubleshoot).
</aside>
