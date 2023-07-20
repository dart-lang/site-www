---
title: Package layout conventions
description: Learn more about the directory structure used by Dart's package management tool, pub.
---

When you build a [pub package](/guides/packages),
we encourage you to follow the conventions that this page describes.
They describe how you organize the files and directories within your
package, and how to name things.

{{site.alert.flutter-note}}
  Flutter apps can use custom directories for their assets.
  For details, see
  [Adding assets and images]({{site.flutter-docs}}/development/ui/assets-and-images)
  on the [Flutter website.]({{site.flutter-docs}})
{{site.alert.end}}

Here's what a complete package (named `enchilada`)
that uses every corner of these guidelines
might look like:

```nocode
enchilada/
  .dart_tool/ *
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
```    

\* The `.dart_tool/` directory exists after you've run `dart pub get`.
   Don't check it into source control.
   To learn more, see 
   [Project specific caching for tools](#project-specific-caching-for-tools).

\** The `pubspec.lock` file exists after you've run `dart pub get`.
    Leave it out of source control unless your package is an
    [application package](/tools/pub/glossary#application-package).

\*** The `doc/api` directory exists locally after you've run
     [`dart doc`](/tools/dart-doc).
     Don't check the `api` directory into source control.


## The pubspec

```nocode
enchilada/
  pubspec.yaml
  pubspec.lock
```

Every package has a [_pubspec_](/tools/pub/pubspec), a file named
`pubspec.yaml`, in the root directory of the package. That's what *makes* it a
package.

Running [`dart pub get`](/tools/pub/cmd/pub-get),
[`dart pub upgrade`](/tools/pub/cmd/pub-upgrade), or
[`dart pub downgrade`](/tools/pub/cmd/pub-downgrade) on the package
creates a **lockfile**, named `pubspec.lock`. 
If your package is an 
[application package](/tools/pub/glossary#application-package), 
check the lockfile into source control. Otherwise, don't.

For more information, see the [pubspec page](/tools/pub/pubspec).

## LICENSE

```nocode
enchilada/
  LICENSE
```

If you're publishing your package, include a license file named `LICENSE`.
We recommend using an [OSI-approved license](https://opensource.org/licenses)
such as [BSD-3-Clause,](https://opensource.org/licenses/BSD-3-Clause)
so that others can reuse your work.

## README.md

```nocode
enchilada/
  README.md
```

One file that's very common in open source is a _README_ file that
describes the project. This is especially important in pub. When you upload
to the [pub.dev site,]({{site.pub}}) your `README.md` file
is shown—rendered as [Markdown][]—on the page for your package. 
This is the perfect place to introduce people to your code.

For guidance on how to write a great README, see
[Writing package pages](/guides/libraries/writing-package-pages).

## CHANGELOG.md

```nocode
enchilada/
  CHANGELOG.md
```

Include a `CHANGELOG.md` file that has a section for
each release of your package,
with notes to help users of your package upgrade.
Users of your package often review the changelog
to discover bug fixes and new features,
or to determine how much effort it will take to upgrade
to the latest version of your package.

To support tools that parse `CHANGELOG.md`,
use the following format:

* Each version has its own section with a heading.
* The version headings are either all level 1 or all level 2.
* The version heading text contains a package version number,
  optionally prefixed with "v".

When you upload your package to the [pub.dev site,]({{site.pub}})
your package's `CHANGELOG.md` file (if any)
appears in the **Changelog** tab, rendered as [Markdown.][Markdown]

Here's an example of a `CHANGELOG.md` file.
As the example shows, you can add subsections.

```markdown
# 1.0.1

* Fixed missing exclamation mark in `sayHi()` method.

# 1.0.0

* **Breaking change:** Removed deprecated `sayHello()` method.
* Initial stable release.

## Upgrading from 0.1.x

Change all calls to `sayHello()` to instead be to `sayHi()`.

# 0.1.1

* Deprecated the `sayHello()` method; use `sayHi()` instead.

# 0.1.0

* Initial development release.
```


## Public directories

Two directories in your package are public to other packages: `lib` and
`bin`. You place [public libraries](#public-libraries) in `lib` and
[public tools](#public-tools) in `bin`.

### Public libraries {#public-libraries}

The following directory structure shows the `lib` portion of enchilada:

```nocode
enchilada/
  lib/
    enchilada.dart
    tortilla.dart
```

Many [packages](/tools/pub/glossary#package)
define Dart libraries that other packages can import and use.
These public Dart library files go inside a directory called `lib`.

Most packages define a single library that users can import. In that case,
its name should usually be the same as the name of the package, like
`enchilada.dart` in the example here. But you can also define other
libraries with whatever names make sense for your package.

When you do, users can import these libraries using the name of the
package and the library file, like so:

```dart
import 'package:enchilada/enchilada.dart';
import 'package:enchilada/tortilla.dart';
```

If you want to organize your public libraries, you can also create
subdirectories inside `lib`. If you do that, users will specify that path
when they import it. Say you have the following file hierarchy:

```nocode
enchilada/
  lib/
    some/
      path/
        olives.dart
```

Users import `olives.dart` as follows:

```dart
import 'package:enchilada/some/path/olives.dart';
```

Note that only *libraries* should be in `lib`.
*Entrypoints*—Dart scripts with a `main()` function—cannot
go in `lib`. If you place a Dart script inside `lib`,
you will discover that any `package:` imports it contains don't
resolve. Instead, your entrypoints should go in the appropriate
[entrypoint directory](/tools/pub/glossary#entrypoint-directory).

{{site.alert.info}}
  **Tip for web apps:**
  For the best performance when developing web apps,
  put [implementation files](#implementation-files) under `/lib/src`,
  instead of elsewhere under `/lib`.
  Also, avoid imports of <code>package:<em>package_name</em>/src/...</code>.
{{site.alert.end}}

For more information on packages, see
[Creating packages](/guides/libraries/create-packages).

### Public tools {#public-tools}

Dart scripts placed inside of the `bin` directory are public. If you're
inside the directory of a package, you can use
[`dart run`](/tools/dart-run) to run scripts from the `bin`
directories of any other package the package depends on. From _any_
directory, you can [run scripts][]
from packages that you have activated using
[`dart pub global activate`][activate].

[run scripts]: /tools/pub/cmd/pub-global#running-a-script
[activate]: /tools/pub/cmd/pub-global#activating-a-package

If you intend for your package to be depended on,
and you want your scripts to be private to your package, place them
in the top-level `tool` directory.
If you don't intend for your package to be depended on, you can leave your
scripts in `bin`.


## Public assets

```nocode
enchilada/
  lib/
    guacamole.css
```

While most packages exist to let you reuse Dart code, you can also
reuse other kinds of content. For example, a package for
[Bootstrap](https://getbootstrap.com/) might include a number of CSS files
for consumers of the package to use.

These go in the top-level `lib` directory. You can put any kind of file
in there and organize it with subdirectories however you like.


## Implementation files

```nocode
enchilada/
  lib/
    src/
      beans.dart
      queso.dart
```

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

How you import libraries from within your own package
depends on the locations of the libraries:

 * When [reaching inside or outside `lib/`][]
   (lint: [_avoid_relative_lib_imports_][]),
   use `package:`.
 * Otherwise, [prefer relative imports][].
 
 [reaching inside or outside `lib/`]: /effective-dart/usage#dont-allow-an-import-path-to-reach-into-or-out-of-lib
 [_avoid_relative_lib_imports_]: /tools/linter-rules/avoid_relative_lib_imports
 [prefer relative imports]: /effective-dart/usage#prefer-relative-import-paths

For example:

```dart
// When importing from lib/beans.dart
import 'src/beans.dart';

// When importing from test/beans_test.dart
import 'package:enchilada/src/beans.dart';
```

The name you use here (in this case `enchilada`) is the name you specify for
your package in its [pubspec](/tools/pub/pubspec).

## Web files

```nocode
enchilada/
  web/
    index.html
    main.dart
    style.css
```

For web packages, place entrypoint code—Dart scripts that include
`main()` and supporting files, such as CSS or HTML—under `web`.
You can organize the `web` directory into subdirectories if you like.

Put [library code](#public-libraries) under `lib`.
If the library isn't imported directly by code under `web`, or by
another package, put it under `lib/src`.
Put [web-based examples](#examples) under `example`. See
[Public assets](#public-assets) for tips on where to put assets,
such as images.

## Command-line apps

```nocode
enchilada/
  bin/
    enchilada
```

Some packages define programs that can be run directly from the command
line. These can be shell scripts or any other scripting language,
including Dart.

If your package defines code like this, put it in a directory named `bin`.
You can run that script from anywhere on the command line, if you set it up
using
[`dart pub global`](/tools/pub/cmd/pub-global#running-a-script-from-your-path).

## Tests and benchmarks

```nocode
enchilada/
  test/
    enchilada_test.dart
    tortilla_test.dart
```

Every package should have tests. With pub, the convention is
that these go in a `test` directory (or some directory inside it if you like)
and have `_test` at the end of their file names.

Typically, these use the [test]({{site.pub-pkg}}/test)
package.

```nocode
enchilada/
  benchmark/
    make_lunch.dart
```

Packages that have performance critical code may also include *benchmarks*.
These test the API not for correctness but for speed (or memory use, or maybe
other empirical metrics).

## Documentation

```nocode
enchilada/
  doc/
    api/
    getting_started.md
```

If you have code and tests, the next piece you might want
is good documentation. That goes inside a directory named `doc`.

When you run the [`dart doc`](/tools/dart-doc)
tool, it places the API documentation, by default, under `doc/api`.
Since the API documentation is generated from the source code,
you should not place it under source control.

Other than the generated `api`, we don't
have any guidelines about format or organization of the documentation
that you author.  Use whatever markup format that you prefer.

## Examples

```nocode
enchilada/
  example/
    main.dart
```

Code, tests, docs, what else
could your users want? Standalone example programs that use your package, of
course! Those go inside the `example` directory. If the examples are complex
and use multiple files, consider making a directory for each example. Otherwise,
you can place each one right inside `example`.

In your examples, use `package:` to import files from your own package.
That ensures that the example code in your package looks exactly
like code outside of your package would look.

If you might publish your package,
consider creating an example file with one of the following names:

* <code>example/example[.md]</code>
* <code>example[/lib]/main.dart</code>
* <code>example[/lib]/<em>package_name</em>.dart</code>
* <code>example[/lib]/<em>package_name</em>_example.dart</code>
* <code>example[/lib]/example.dart</code>
* <code>example/README[.md]</code>

When you publish a package that contains one or more of the above files,
the pub.dev site creates an **Example** tab to display the first file it finds
(searching in the order shown in the list above).
For example, if your package has many files under its `example` directory,
including a file named `README.md`,
then your package's Example tab displays the contents of `example/README.md`
(parsed as [Markdown.)][Markdown]

{% comment %}
To see how the example file is chosen,
search the dart-lang repos for exampleFileCandidates:
https://github.com/search?q=org%3Adart-lang+exampleFileCandidates&type=Code
{% endcomment %}

## Internal tools and scripts

```nocode
enchilada/
  tool/
    generate_docs.dart
```

Mature packages often have little helper scripts and programs that people
run while developing the package itself. Think things like test runners,
documentation generators, or other bits of automation.

Unlike the scripts in `bin`, these are *not* for external users of the package.
If you have any of these, place them in a directory called `tool`.

## Project-specific caching for tools

{{site.alert.info}}
  Do not check the `.dart_tool/` directory into source control.
  Instead, keep `.dart_tool/` in `.gitignore`.
{{site.alert.end}}

The `.dart_tool/` directory is created when you run `dart pub get`
and might be deleted at any time. Various tools use this directory
for caching files specific to your project and/or local machine.
The `.dart_tool/` directory should never be checked into
source control, or copied between machines.

It is also generally safe to delete the `.dart_tool/` directory,
though some tools might need recompute the cached information. 

**Example:** The [`dart pub get`](/tools/pub/cmd/pub-get) tool
will download and extract dependencies to a global `$PUB_CACHE` directory,
and then write a `.dart_tool/package_config.json` file mapping _package names_
to directories in the global `$PUB_CACHE` directory.
The `.dart_tool/package_config.json` file is used by other tools,
such as the analyzer and compilers when they need to resolve statements
such as `import 'package:foo/foo.dart'`.

When developing a tool that needs project-specific caching, 
you might consider using the `.dart_tool/` directory 
because most users already ignore it with `.gitignore`.
When caching files for your tool in a user's `.dart_tool/` directory,
you should use a unique subdirectory. To avoid collisions,
subdirectories of the form `.dart_tool/<tool_package_name>/`
are reserved for the package named `<tool_package_name>`.
If your tool isn't distributed through the [pub.dev site,]({{site.pub}})
you might consider publishing a placeholder package in order to 
reserve the unique name.

**Example:** [`package:build`](https://pub.dev/packages/build) provides a
framework for writing code generation steps.
When running these build steps, files are cached in `.dart_tool/build/`.
This helps speed-up future re-runs of the build steps.

{{site.alert.warning}}
  When developing a tool that wants to cache files in `.dart_tool/`,
  ensure the following:
  
  * You are using a subdirectory named after a package you own
    (`.dart_tool/<my_tool_package_name>/`)
  * Your files don't belong under source control, 
    as `.dart_tool/` is generally listed in `.gitignore`
{{site.alert.end}}


[Markdown]: {{site.pub-pkg}}/markdown
