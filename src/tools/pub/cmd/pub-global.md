---
layout: default
permalink: /tools/pub/cmd/pub-global
title: "pub global"
description: "Use pub global to run Dart scripts hosted on pub.dartlang.org from the command line."
toc: false

header:
  css: ["../transformers/transformers.css"]
---

_Global_ is one of the commands of the _pub_ tool.
[Learn more about pub](/tools/pub/).

**Contents**

Pub's `global` option allows you to run Dart scripts from the
command line when you are not currently inside a package.
You first [activate a package](#activating-a-package), then you can
[run scripts](#running-a-script) from that package's bin directory.
[Deactivating a package](#deactivating-a-package) removes it from
your list of globally available packages.

To run a Dart script from within a package, or from a
package that your package depends on, see [pub run](pub-run.html).

## Activating a package {#activating-a-package}

{% prettify sh %}
$ pub global activate [--noexecutables] [--executable=<name>] [--overwrite] <package> [constraint]
{% endprettify %}

Use `activate` to enable you to run a package's executables
from anywhere on your machine.
You can activate a package on [pub.dartlang.org](https://pub.dartlang.org/),
in a Git repository, or on your local machine.
Once you have activated a package, see [Running a script](#running-a-script)
to run scripts from the package's `bin` directory.

When you activate a package you can specify an optional constraint. See the
[constraint](#options) flag for usage examples.

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

## Running a script {#running-a-script}

You can run a script from an activated package explicitly using
`pub global run`, or you can add it to your PATH so that you can run it
directly at the command line.

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

### Running a script from your PATH {#running-a-script-from-your-path}

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

When you globally activate a package using any of the `pub global activate`
options, pub creates a shell script for each
entry listed in the `executables` section of the pubspec,
and adds it to the `bin` directory in your
[pub cache]({{site.dartlang}}/tools/pub/glossary#system-cache).
For Linux and Mac, this file is located in `~/.pub-cache/bin`.
If you want to activate a subset of the list of executables,
use `--executable=<name>` (or `-x<name>`, for short).

**You must manually add the pub cache `bin` directory to your PATH.**

If the executable's name conflicts with a previously activated executable,
it generates a warning. To force pub to install the new executable,
use `--overwrite`. For example:

{% prettify sh %}
$ pub global activate <package> --executable=<name> [[highlight]]--overwrite[[/highlight]]
{% endprettify %}

You can now run `helloworld` at the command line.

For more information on the these flags, see [Options](#options).

## Deactivating a package {#deactivating-a-package}

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

## Listing active packages {#listing-active-packages}

{% prettify sh %}
$ pub global list
{% endprettify %}

Use `list` to list all currently active packages.

## Options {#options}

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd/#global-options).

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
See [Troubleshooting Pub](../troubleshoot.html).
</aside>
