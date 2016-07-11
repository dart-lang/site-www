---
layout: default
permalink: /tools/pub/cmd/pub-run
title: "pub run"
description: "Use pub run to run a Dart script in your package."
toc: false
---

_Run_ is one of the commands of the _pub_ tool.
[Learn more about pub](/tools/pub/).

{% prettify sh %}
$ pub run [--mode=<mode>] [--checked] <executable> [args...]
{% endprettify %}

Use this command to run a Dart script in your package,
or in one of its dependencies, from the command line.
If your app uses transformers, pub loads and runs the appropriate
transformers, then runs the app, passing in any specified parameters.

To run an executable when you are not currently inside a package,
see the [pub global](pub-global.html) command.

## Running a script in your package's bin directory

This is the simplest use case.

From the root of a package that contains `foo.dart`
in the `bin` directory, run the app using the following command:

{% prettify sh %}
$ pub run foo arg1 arg2
{% endprettify %}

This command looks in your package's `bin` directory for the
specified script and invokes it, passing in any arguments.

## Running a script in another directory in your package

To run a script inside a directory other than the top-level
bin directory (but within the package), prepend the path
to the name of the script.
For example, to run `foo.dart` in the `example/sub` directory:

{% prettify sh %}
$ pub run example/sub/foo arg1 arg2
{% endprettify %}

## Running a script in a dependency

To run a script from the `bin` directory of a package that you depend on
in the pubspec, specify the package name.
For example, to run `bar.dart` in the foo package:

{% prettify sh %}
$ pub run foo:bar arg
{% endprettify %}

You can only run scripts out of another package's `bin` directory.
All other directories are private.

## Options {#options}

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd/#global-options).

<dl>
  <dt><code>--mode=&lt;mode&gt;</code></dt>
  <dd>
  Optional. Specifies a transformation mode.
  Transformers may use <code>--mode</code> to change how they behave.
  Any word can be used,
  but the following have special meaning:<br>

  <dl>
    <dt><code>debug</code></dt>
    <dd>
    If <code>mode</code> is not specified,
    it defaults to <code>debug</code> for entrypoints.
    </dd>

    <dt><code>release</code></dt>
    <dd>
    If <code>mode</code> is not specified,
    it defaults to <code>release</code> for dependencies.
    </dd>
  </dl>
  </dd>

  <dt><code>--checked</code></dt>
  <dd>
  Optional. Specify to run in checked mode.
  It defaults to non-checked mode.
  </dd>

</dl>

<aside class="alert alert-info" markdown="1">
*Problems?*
See [Troubleshooting Pub](../troubleshoot.html).
</aside>
