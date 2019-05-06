---
title: Creating packages
description: Learn how to create library packages in Dart.
---

The Dart ecosystem uses [packages][]
to share software such as libraries and tools.
This page tells you how to create a package,
with a focus on the most common kind of package,
[_library_ packages](/tools/pub/glossary#library-package).

{% comment %}
TODO: Add coverage of packages that contain tools.
{% endcomment %}

[packages]: /guides/packages

## What makes a library package

The following diagram shows the layout of the simplest
library package:

{% asset libraries/simple-lib2.png alt="root directory contains pubspec.yaml and lib/file.dart" %}

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

{% asset libraries/shelf.png alt="shelf root directory contains example, lib, test, and tool subdirectories" %}

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
[dartdevc,](/tools/dartdevc)
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

{% asset libraries/import-lib-rules.png alt="lib/bar/b.dart uses a relative import; web/main.dart uses a package import" %}

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

Other files that are required if you publish your library to the
Pub site, such as a README and a CHANGELOG, are
described in [Publishing a package](/tools/pub/publishing).
For more information on how to organize a package directory,
see the [pub package layout conventions](/tools/pub/package-layout).

## Documenting a library

You can generate API docs for your library using
the [dartdoc][] tool.
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
[shelf documentation.]({{site.pub-api}}/shelf/latest)

<aside class="alert alert-info" markdown="1">
**Note:**
To include any library-level documentation in the generated docs,
you must specify the `library` directive.
See [issue 1082.](https://github.com/dart-lang/dartdoc/issues/1082)
</aside>

## Distributing an open source library {#distributing-a-library}

If your library is open source,
we recommend sharing it on the [Pub site.]({{site.pub}})
To publish or update the library,
use [pub publish](/tools/pub/cmd/pub-lish),
which uploads your package and creates or updates its page.
For example, see the page for the [shelf package.]({{site.pub}}/packages/shelf)
See [Publishing a package](/tools/pub/publishing)
for details on how to prepare your package for publishing.

The pub site not only hosts your package,
but also generates and hosts your package's API reference docs.
A link to the latest generated docs is in the package's **About** box;
for example, see the shelf package's
[API docs.]({{site.pub-api}}/shelf)
Links to previous versions' docs are in the
**Versions** tab of the package's page.

To ensure that your package's API docs look good on the pub site,
follow these steps:

* Before publishing your package, run the [dartdoc][] tool
  to make sure that your docs generate successfully and look as expected.
* After publishing your package, check the **Versions** tab
  to make sure that the docs generated successfully.
* If the docs didn't generate at all,
  click **failed** in the **Versions** tab to see the dartdoc output.

## Resources

Use the following resources to learn more about library packages:

* [Libraries and visibility](/guides/language/language-tour#libraries-and-visibility)
  in the [language tour](/guides/language/language-tour) covers
  using library files.
* The [package](/guides/packages) documentation is useful, particularly the
  [package layout conventions](/tools/pub/package-layout).
* [What not to commit](private-files)
  covers what should not be checked into a source code repository.
* The newer library packages under the
  [dart-lang](https://github.com/dart-lang) organization tend
  to show best practices. Consider studying these examples:
  [dart_style,](https://github.com/dart-lang/dart_style)
  [path,](https://github.com/dart-lang/path)
  [shelf,](https://github.com/dart-lang/shelf)
  [source_gen,](https://github.com/dart-lang/source_gen) and
  [test.](https://github.com/dart-lang/test)

[dartdoc]: https://github.com/dart-lang/dartdoc#dartdoc
