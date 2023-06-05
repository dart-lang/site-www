---
title: How to use packages
short-title: Packages
description: Learn more about pub, Dart's tool for managing packages.
---

The Dart ecosystem uses _packages_ to manage shared software
such as libraries and tools.
To get Dart packages, you use the **pub package manager**.
You can find publicly available packages on the
[**pub.dev site**,]({{site.pub}})
or you can load packages from the local file system or elsewhere,
such as Git repositories.
Wherever your packages come from, pub manages version dependencies,
helping you get package versions that work with each other and
with your SDK version.

Most [Dart-savvy IDEs][] offer support for using pub that
includes creating, downloading, updating, and publishing packages.
Or you can use [`dart pub` on the command line](/tools/pub/cmd).

At a minimum,
a Dart package is a directory containing a [pubspec file](/tools/pub/pubspec).
The pubspec contains some metadata about the package. 
Additionally, a package can contain dependencies (listed in the pubspec),
Dart libraries, apps, resources, tests, images, and examples.

To use a package, do the following:

* Create a pubspec (a file named `pubspec.yaml` that
  lists package dependencies and includes
  other metadata, such as a version number).
* Use [`dart pub get`][get] to retrieve your package's dependencies.
* If your Dart code depends on a library in the package, import the library.

## Creating a pubspec

The pubspec is a file named `pubspec.yaml`
that's in the top directory of your application.
The simplest possible pubspec lists only the package name:

```yaml
name: my_app
```

Here is an example of a pubspec that declares dependencies on
two packages (`js` and `intl`) that are hosted on the pub.dev site:

```yaml
name: my_app

dependencies:
  js: ^0.6.0
  intl: ^0.17.0
```

To update the `pubspec.yaml` file, without manual editing, 
you can run `dart pub add` command.
The following example adds a dependency on `vector_math`.

```terminal
$ dart pub add vector_math
Resolving dependencies... 
+ vector_math 2.1.3
Downloading vector_math 2.1.3...
Changed 1 dependency!
```

For details on creating a pubspec,
see the [pubspec documentation](/tools/pub/pubspec)
and the documentation for the packages that you want to use.

## Getting packages

Once you have a pubspec, you can run [`dart pub get`][get] from the top 
directory of your application:

```terminal
$ cd <path-to-my_app>
$ dart pub get
```

This process is called _getting the dependencies_.

The `dart pub get` command
determines which packages your app depends on,
and puts them in a central [system cache](/tools/pub/glossary#system-cache).
If your app depends on a published package, pub downloads that package from the
[pub.dev site.]({{site.pub}})
For a [Git dependency](/tools/pub/dependencies#git-packages),
pub clones the Git repository.
Transitive dependencies are included, too.
For example, if the `js` package depends on the `test` package, `pub`
grabs both the `js` package and the `test` package.

Pub creates a
`package_config.json` file (under the `.dart_tool/` directory)
that maps each package name that your app depends on
to the corresponding package in the system cache.


## Importing libraries from packages

To import libraries found in packages, 
use the `package:` prefix:

```dart
import 'package:js/js.dart' as js;
import 'package:intl/intl.dart';
```

The Dart runtime takes everything after `package:`
and looks it up within the `package_config.json` file for
your app.

You can also use this style to import libraries from within your own package.
Let's say that the `transmogrify` package is laid out as follows:

```nocode
transmogrify/
  lib/
    transmogrify.dart
    parser.dart
  test/
    parser/
      parser_test.dart
```

The `parser_test.dart` file can import `parser.dart` like this:

```dart
import 'package:transmogrify/parser.dart';
```


## Upgrading a dependency

The first time you get a new dependency for your package,
pub downloads the latest version of it that's compatible with
your other dependencies.
It then locks your package to *always* use that version by
creating a **lockfile**.
This is a file named `pubspec.lock` that pub creates
and stores next to your pubspec. 
It lists the specific versions of each dependency (immediate and transitive) 
that your package uses.

If your package is an [application package](/tools/pub/glossary#application-package)
you should check this file into
[source control](/guides/libraries/private-files).
That way, everyone working on your app uses the same versions
of all of its dependencies.
Checking in the lockfile also ensures that your deployed app
uses the same versions of code.

When you're ready to upgrade your dependencies to the latest versions,
use the [`dart pub upgrade`][upgrade] command:

```terminal
$ dart pub upgrade
```

The `dart pub upgrade` command tells pub to regenerate the lockfile,
using the newest available versions of your package's dependencies.
If you want to upgrade only one dependency,
you can specify the package to upgrade:

```terminal
$ dart pub upgrade transmogrify
```

That command upgrades `transmogrify` to the latest version
but leaves everything else the same.

The `dart pub upgrade` command can't always upgrade every package
to its latest version,
due to conflicting version constraints in the pubspec.
To identify out-of-date packages that require editing the pubspec,
use [`dart pub outdated`][outdated].

## More information

The following pages have more information about packages and
the pub package manager.


### How to

* [Creating packages](/guides/libraries/create-packages)
* [Publishing packages](/tools/pub/publishing)

### Reference

* [Pub dependencies](/tools/pub/dependencies)
* [Pub environment variables](/tools/pub/environment-variables)
* [Pub glossary](/tools/pub/glossary)
* [Pub package layout conventions](/tools/pub/package-layout)
* [Pub versioning philosophy](/tools/pub/versioning)
* [Pubspec format](/tools/pub/pubspec)

### Pub subcommands

The `dart pub` tool provides the following subcommands:

{% include pub-subcommands.md %}

For an overview of all the `dart pub` subcommands,
see the [pub tool documentation](/tools/pub/cmd).

### Troubleshooting

[Troubleshooting pub](/tools/pub/troubleshoot) gives solutions to problems that
you might encounter when using pub.

[Dart-savvy IDEs]: /tools#ides-and-editors
[get]: /tools/pub/cmd/pub-get
[upgrade]: /tools/pub/cmd/pub-upgrade
[outdated]: /tools/pub/cmd/pub-outdated
