---
layout: default
title: "Create Library Packages"
description: "Learn how to create library packages in Dart."
---

Libraries are a great way to create modular code that can
be easily shared. In the Dart ecosystem,
libraries are created and distributed as packages.
Dart has two kinds of packages:
[_application_ packages](/tools/pub/glossary#application-package),
which may include local libraries, and
[_library_ packages](/tools/pub/glossary#library-package).

This document explains how to create a library package
and points you to further resources.
For information on _using_ libraries, see
[Install Shared Packages](/tutorials/libraries/shared-pkgs) or the
language tour's
[Libraries and visibility](/guides/language/language-tour#libraries-and-visibility)
section.

## What makes a library package

The following diagram shows the layout of the simplest
library package:

{% img 'libraries/simple-lib2.png' %}

The minimal requirements for a library are:

<dl markdown="1">

<dt markdown="1">
pubspec file
</dt>
<dd markdown="1">
The `pubspec.yaml` file for a library is the same
as for an application package&mdash;there is no special
designation to indicate that the package is a library.
</dd>

<dt markdown="1">
lib directory
</dt>
<dd markdown="1">
As you might expect, the library code lives under the _lib_
directory and is public to other packages.
You can create any hierarchy under lib, as needed.
By convention, implementation code is placed under _lib/src_.
Code under lib/src is considered private;
other packages should never need to import `src/...`.
To make APIs under lib/src public, you can export lib/src files
from a file that's directly under lib.
</dd>

<aside class="alert alert-info" markdown="1">
**Note:**
When the `library` directive isn't specified, a unique
tag is generated for each library based on its path and filename.
Therefore, we suggest that you omit the `library` directive from
your code unless you plan to
[generate library-level documentation](#documenting-a-library).
</aside>

</dl>

## Organizing a library package

Library packages are easiest to maintain, extend, and test
when you create small, individual libraries, referred to as
_mini libraries_.
In most cases, each class should be in its own mini library, unless
you have a situation where two classes are tightly coupled.

<aside class="alert alert-info" markdown="1">
**Note:** You may have heard of the `part` directive, which allows
you to split a library into multiple Dart files. We recommend
that you avoid using `part` and create mini libraries instead.
</aside>

Create a "main" library file directly under lib,
lib/_&lt;package-name&gt;_.dart, that
exports all of the public APIs.
This allows the user to get all of a library's functionality
by importing a single file.

The lib directory might also include other importable, non-src, libraries.
For example, perhaps your main library works across platforms, but
you create separate libraries that rely on dart:io or dart:html.
Some packages have separate libraries that are meant to be imported
with a prefix, when the main library is not.

Let's look at the organization of a real-world library package: shelf. The
[shelf](https://github.com/dart-lang/shelf)
package provides an easy way to create web servers using Dart,
and is laid out in a structure that is commonly used for Dart
library packages:

{% img 'libraries/shelf.png' %}

Directly under lib, the main library file,
`shelf.dart`, exports several files from lib/src:

{% prettify dart %}
export 'src/cascade.dart';
export 'src/handler.dart';
export 'src/handlers/logger.dart';
export 'src/hijack_exception.dart';
export 'src/middleware.dart';
export 'src/pipeline.dart';
export 'src/request.dart';
export 'src/response.dart';
export 'src/server.dart';
export 'src/server_handler.dart';
{% endprettify %}

The shelf package also contains a mini library: shelf_io.
This adapter handles HttpRequest objects from dart:io.

<aside class="alert alert-info" markdown="1">
**Tip for web apps:**
For the best performance when developing with
[dartdevc,]({{site.webdev}}/tools/dartdevc)
put [implementation
files](/tools/pub/package-layout#implementation-files) under `/lib/src`,
instead of elsewhere under `/lib`.
Also, avoid imports of <code>package:<em>package_name</em>/src/...</code>.
</aside>

## Importing library files

When importing a library file, you can use the
the `package:` directive to specify the URI of that file.

{% prettify dart %}
import 'package:utilities/utilities.dart';
{% endprettify %}

You can import a library using a relative path when
both files are inside of lib,
or when both files are outside of lib.
However, you must use `package:` when importing a file that reaches
inside, or outside, of lib.
When in doubt, use the `package:` directive; it works in all cases.

The following graphic shows how
to import `lib/foo/a.dart` from both lib and web.

{% img 'libraries/import-lib-rules.png' %}

<aside class="alert alert-info" markdown="1">
**Note:**
Although the lib graphic shows `lib/bar/b.dart` using a relative import
(`import '../foo/a.dart'`),
it could instead use the `package:` directive
(`import 'package:my_package/foo/a.dart'`).
</aside>


## Providing additional files

A well designed library package is easy to test.
We recommend that you write tests using the
[test](https://github.com/dart-lang/test) package,
placing the test code in the `test` directory at the
top of the package.

If you create any command-line tools intended for public consumption,
place those in the `bin` directory, which is public.
Enable running a tool from the command line, using
[`pub global activate`](/tools/pub/cmd/pub-global#activating-a-package).
Listing the tool in the
[`executables` section](/tools/pub/pubspec#executables)
of the pubspec allows a user to run it directly without calling
[`pub global run`](/tools/pub/cmd/pub-global#running-a-script-using-pub-global-run).

It's helpful if you include an example of how to use your library.
This goes into the `example` directory at the top of the package.

Any tools or executables that you create during development that aren't for
public use go into the `tool` directory.

Other files that are required if you publish your library to
pub.dartlang.org, such as a README and a CHANGELOG, are
described in [Publishing a Package](/tools/pub/publishing).
Also see
[Pub Package Layout Conventions](/tools/pub/package-layout)
for further information on how to organize a package directory
structure.

## Documenting a library

You can generate API docs for your library using
the [dartdoc](https://github.com/dart-lang/dartdoc#dartdoc) tool.
Dartdoc parses the source looking for
[documentation comments](/guides/language/effective-dart/documentation#doc-comments),
which use the `///` syntax:

{% prettify dart %}
/// The event handler responsible for updating the badge in the UI.
void updateBadge() {
  ...
}
{% endprettify %}

For an example of generated docs, see the
[shelf documentation](https://pub.dartlang.org/documentation/shelf/latest/shelf/shelf-library.html).

<aside class="alert alert-info" markdown="1">
**Note:**
To include any library-level documentation in the generated docs,
you must specify the `library` directive.
See [issue 1082](https://github.com/dart-lang/dartdoc/issues/1082).
</aside>

## Distributing a library

When checking your library into source code control, be aware
that there are some files you should not commit.
For example, don't commit `.packages` or `pubspec.lock` files.
To learn more, see
[What Not to Commit](private-files).

You can share your open source libraries with other developers on
[pub.dartlang.org](https://pub.dartlang.org/) using
[pub publish](/tools/pub/cmd/pub-lish).
[Publishing a Package](/tools/pub/publishing)
describes all the files that you should include.

[pub.dartlang.org](https://pub.dartlang.org/) provides a handy 
service that generates new docs when it detects changes to published
packages. The latest generated docs can be accessed from the 
package's sidebar, while other version's docs are available from the
`Versions` tab. Before publishing your package, run the dartdoc tool
manually to make sure that your docs generate successfully and look
as expected. Once uploaded, you can check the `Versions` tab to see
if the docs were generated successfully, and if not you can access
the log to see why not by clicking `failed`on that version's listing.

To minimize the possibility of broken links as version numbers change,
specify "latest" rather than a specific version when linking to
documentation on [pub.dartlang.org](https://pub.dartlang.org/). 
For example:
[https://pub.dartlang.org/documentation/shelf/latest/](https://pub.dartlang.org/documentation/shelf/latest/).

## Resources

Use the following resources to learn more about library packages:

* [Libraries and visibility](/guides/language/language-tour#libraries-and-visibility)
  in the [language tour](/guides/language/language-tour) covers
  using library files.
* The [pub](/tools/pub) documentation is useful, particularly
  [Pub Package Layout Conventions](/tools/pub/package-layout).
* [What Not to Commit](private-files)
  covers what should not be checked into a source code repository.
* The newer library packages under the
  [dart-lang](https://github.com/dart-lang) organization tend
  to show best practices. Consider studying these examples:
  [dart_style](https://github.com/dart-lang/dart_style),
  [path](https://github.com/dart-lang/path),
  [shelf](https://github.com/dart-lang/shelf),
  [source_gen](https://github.com/dart-lang/source_gen), and
  [test](https://github.com/dart-lang/test).
