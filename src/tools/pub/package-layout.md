---
title: Package layout conventions
description: Learn more about the directory structure used by Dart's package management tool, pub.
---

When you build a [pub package](/guides/packages),
we encourage you to follow the conventions that this page describes.
They describe how you organize the files and directories within your
package, and how to name things.

<aside class="alert alert-info"><div class="alert-with-image">
  <img src="{% asset shared/flutter/logo/default.svg @path %}" alt="[Flutter]">
  <div markdown="1">
  **Note:**
  Flutter apps can use custom directories for their assets.
  For details, see
  [Adding assets and images]({{site.flutter}}/assets-and-images/)
  on the [Flutter website.]({{site.flutter}})
  </div>
</div></aside>

Here's what a complete package (named `enchilada`)
that uses every corner of these guidelines
might look like:

{% prettify none %}
enchilada/
  .dart_tool/ *
  .packages *
  pubspec.yaml
  pubspec.lock **
  LICENSE
  README.md
  CHANGELOG.md
  benchmark/
    make_lunch.dart
  bin/
    enchilada
  doc/
    api/ ***
    getting_started.md
  example/
    main.dart
  lib/
    enchilada.dart
    tortilla.dart
    guacamole.css
    src/
      beans.dart
      queso.dart
  test/
    enchilada_test.dart
    tortilla_test.dart
  tool/
    generate_docs.dart
  web/
    index.html
    main.dart
    style.css
{% endprettify %}

\* The `.dart_tool` directory and `.packages` file exist after you've run
   `pub get`. Don't check them into source control.

\** The `pubspec.lock` file exists after you've run `pub get`.
    Leave it out of source control unless your package is an
    [application package](/tools/pub/glossary#application-package).

\*** The `doc/api` directory exists locally after you've run
      [dartdoc.](https://github.com/dart-lang/dartdoc#dartdoc)
      Don't check the `api` directory into source control.

{% include packages-dir.html %}


## The pubspec

{% prettify none %}
enchilada/
  pubspec.yaml
  pubspec.lock
{% endprettify %}

Every package has a [_pubspec_](/tools/pub/pubspec), a file named
`pubspec.yaml`, in the root directory of the package. That's what *makes* it a
package.

Running [`pub get`](/tools/pub/cmd/pub-get),
[`pub upgrade`](/tools/pub/cmd/pub-upgrade), or
[`pub downgrade`](/tools/pub/cmd/pub-downgrade) on the package creates a
**lockfile**, named `pubspec.lock`. If your package is an [application
package](/tools/pub/glossary#application-package), check the lockfile into source
control. Otherwise, don't.

For more information, see the [pubspec page](/tools/pub/pubspec).

## LICENSE

{% prettify none %}
enchilada/
  LICENSE
{% endprettify %}

If you're publishing your package, include a license file named `LICENSE`,
optionally with a file extension such as `.md`. 
We recommend using an [OSI-approved license](https://opensource.org/licenses)
such as [BSD-3-Clause,](https://opensource.org/licenses/BSD-3-Clause)
so that others can reuse your work.

## README

{% prettify none %}
enchilada/
  README.md
{% endprettify %}

One file that's very common in open source is a README file that
describes the project. This is especially important in pub. When you upload
to the [Pub site,]({{site.pub}}) your README is shown on
the page for your package. This is the perfect place to introduce people to
your code.

If your README ends in `.md`, it's parsed as
[Markdown.][markdown]

[markdown]: http://daringfireball.net/projects/markdown/

## CHANGELOG

{% prettify none %}
enchilada/
  CHANGELOG.md
{% endprettify %}

To show users the latest changes to your package, you can include a changelog
file where you can write a short note about the changes in your latest
release. When you upload your package to the
[Pub site,]({{site.pub}}) your package's changelog file (if any)
appears in the changelog tab.

If your CHANGELOG ends in `.md`, it's parsed as
[Markdown.][markdown]

## Public directories

Two directories in your package are public to other packages: `lib` and
`bin`. You place [public libraries](#public-libraries) in `lib` and
[public tools](#public-tools) in `bin`.

### Public libraries {#public-libraries}

The following directory structure shows the `lib` portion of enchilada:

{% prettify none %}
enchilada/
  lib/
    enchilada.dart
    tortilla.dart
{% endprettify %}

Many packages are [*library
packages*](/tools/pub/glossary#library-package): they
define Dart libraries that other packages can import and use.
These public Dart library files go inside a directory called `lib`.

Most packages define a single library that users can import. In that case,
its name should usually be the same as the name of the package, like
`enchilada.dart` in the example here. But you can also define other
libraries with whatever names make sense for your package.

When you do, users can import these libraries using the name of the
package and the library file, like so:

{% prettify dart %}
import 'package:enchilada/enchilada.dart';
import 'package:enchilada/tortilla.dart';
{% endprettify %}

If you want to organize your public libraries, you can also create
subdirectories inside `lib`. If you do that, users will specify that path
when they import it. Say you have the following file hierarchy:

{% prettify none %}
enchilada/
  lib/
    some/
      path/
        olives.dart
{% endprettify %}

Users import `olives.dart` as follows:

{% prettify dart %}
import 'package:enchilada/some/path/olives.dart';
{% endprettify %}

Note that only *libraries* should be in `lib`.
*Entrypoints*&mdash;Dart scripts with a `main()` function&mdash;cannot
go in `lib`. If you place a Dart script inside `lib`,
you will discover that any `package:` imports it contains don't
resolve. Instead, your entrypoints should go in the appropriate
[entrypoint directory](/tools/pub/glossary#entrypoint-directory).

<aside class="alert alert-info" markdown="1">
**Tip for web apps:**
For the best performance when developing with
[dartdevc,](/tools/dartdevc)
put [implementation files](#implementation-files) under `/lib/src`,
instead of elsewhere under `/lib`.
Also, avoid imports of <code>package:<em>package_name</em>/src/...</code>.
</aside>

For more information on library packages, see
[Creating packages](/guides/libraries/create-library-packages).

### Public tools {#public-tools}

Dart scripts placed inside of the `bin` directory are public. If you're
inside the directory of a package, you can use
[`pub run`](/tools/pub/cmd/pub-run) to run scripts from the `bin`
directories of any other package the package depends on. From _any_
directory, you can use [`pub global run`](/tools/pub/cmd/pub-global) to run
scripts from packages you have activated using `pub global activate`.

If you intend for your package to be depended on,
and you want your scripts to be private to your package, place them
in the top-level `tool` directory.
If you do not intend for your package to be depended on, you can leave your
scripts in `bin`.


## Public assets

{% prettify none %}
enchilada/
  lib/
    guacamole.css
{% endprettify %}

While most library packages exist to let you reuse Dart code, you can also
reuse other kinds of content. For example, a package for
[Bootstrap](http://getbootstrap.com/) might include a number of CSS files
for consumers of the package to use.

These go in the top-level `lib` directory. You can put any kind of file
in there and organize it with subdirectories however you like.

You can reference another package's assets using the
[resource package.](https://github.com/dart-lang/resource)

<aside class="alert alert-warning" markdown="1">
**Warning:**
Old code might refer to assets using `/packages/<package>/<path>` URLs.
</aside>


## Implementation files

{% prettify none %}
enchilada/
  lib/
    src/
      beans.dart
      queso.dart
{% endprettify %}

The libraries inside `lib` are publicly visible: other packages are free to
import them. But much of a package's code is internal implementation libraries
that should only be imported and used by the package itself. Those go inside a
subdirectory of `lib` called `src`. You can create subdirectories in there if
it helps you organize things.

You are free to import libraries that live in `lib/src` from within other Dart
code in the *same* package (like other libraries in `lib`, scripts in `bin`, and
tests) but you should never import from another package's `lib/src` directory.
Those files are not part of the package's public API, and they might change in
ways that could break your code.

When you use libraries from within your own package, even code in `src`, you
can (and should) still use `package:` to import them. For example:

{% prettify dart %}
import 'package:enchilada/src/beans.dart';
{% endprettify %}

The name you use here (in this case `enchilada`) is the name you specify for
your package in its [pubspec](/tools/pub/pubspec).

## Web files

{% prettify none %}
enchilada/
  web/
    index.html
    main.dart
    style.css
{% endprettify %}

For web packages, place entrypoint code&mdash;Dart scripts that include
`main()` and supporting files, such as CSS or HTML&mdash;under `web`.
You can organize the `web` directory into subdirectories if you like.

Put [library code](#public-libraries) under `lib`.
If the library isn't imported directly by code under `web`, or by
another package, put it under `lib/src`.
Put [web-based examples](#examples) under `example`. See
[Public assets](#public-assets) for tips on where to put assets,
such as images.

## Command-line apps

{% prettify none %}
enchilada/
  bin/
    enchilada
{% endprettify %}

Some packages define programs that can be run directly from the command
line.  These can be shell scripts or any other scripting language,
including Dart.  The `pub` application itself is one example: it's
a simple shell script that invokes `pub.dart`.

If your package defines code like this, put it in a directory named `bin`.
You can run that script from anywhere on the command line, if you set it up
using
[pub global](/tools/pub/cmd/pub-global#running-a-script-from-your-path).

## Tests and benchmarks

{% prettify none %}
enchilada/
  test/
    enchilada_test.dart
    tortilla_test.dart
{% endprettify %}

Every package should have tests. With pub, the convention is
that these go in a `test` directory (or some directory inside it if you like)
and have `_test` at the end of their file names.

Typically, these use the [test]({{site.pub}}/packages/test)
package.

{% prettify none %}
enchilada/
  benchmark/
    make_lunch.dart
{% endprettify %}

Packages that have performance critical code may also include *benchmarks*.
These test the API not for correctness but for speed (or memory use, or maybe
other empirical metrics).

## Documentation

{% prettify none %}
enchilada/
  doc/
    api/
    getting_started.md
{% endprettify %}

If you've got code and tests, the next piece you might want
is good documentation. That goes inside a directory named `doc`.

When you run the [dartdoc](https://github.com/dart-lang/dartdoc#dartdoc)
tool, it places the API documentation, by default, under `doc/api`.
Since the API documentation is generated from the source code,
you should not place it under source control.

Other than the generated `api`, we don't
have any guidelines about format or organization of the documentation
that you author.  Use whatever markup format that you prefer.

## Examples

{% prettify none %}
enchilada/
  example/
    main.dart
{% endprettify %}

Code, tests, docs, what else
could your users want? Standalone example programs that use your package, of
course! Those go inside the `example` directory. If the examples are complex
and use multiple files, consider making a directory for each example. Otherwise,
you can place each one right inside `example`.

In your examples, use `package:` to import files from your own package.
That ensures that the example code in your package looks exactly
like code outside of your package would look.

If you might publish your package,
consider creating an example file with one of the following names
(case insensitive):

* <code>example/readme[.md]</code>
* <code>example/example[.md]</code>
* <code>example[/lib]/main.dart</code>
* <code>example[/lib]/<em>package_name</em>.dart</code>
* <code>example[/lib]/<em>package_name</em>_example.dart</code>
* <code>example[/lib]/example.dart</code>

When you publish a package that contains one or more of the above files,
the Pub site creates an **Example** tab to display the first file it finds
(searching in the order shown in the list above).
For example, if your package has many files under its `example` directory,
including a file named `README.md`,
then your package's Example tab displays the contents of `example/README.md`
(parsed as [Markdown.)][markdown]

{% comment %}
To see how the example file is chosen,
search the dart-lang repos for exampleFileCandidates:
https://github.com/search?q=org%3Adart-lang+exampleFileCandidates&type=Code
{% endcomment %}

## Internal tools and scripts

{% prettify none %}
enchilada/
  tool/
    generate_docs.dart
{% endprettify %}

Mature packages often have little helper scripts and programs that people
run while developing the package itself. Think things like test runners,
documentation generators, or other bits of automation.

Unlike the scripts in `bin`, these are *not* for external users of the package.
If you have any of these, place them in a directory called `tool`.
