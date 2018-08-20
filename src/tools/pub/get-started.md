---
layout: default
title: "Getting Started with Pub"
description: "Learn more about Dart's tool for managing packages and assets, the pub tool."
permalink: /tools/pub/get-started
---

You can use [pub](/tools/pub) to manage Dart packages.

At the very minimum,
a Dart package is simply a directory containing a _pubspec_ file.

The pubspec contains some metadata about the package. Additionally,
a package can contain dependencies (listed in the pubspec),
Dart libraries, command-line apps, web apps, resources,
tests, images, or examples.
If your app uses one or more packages, then your app itself must be
a package.

<aside class="alert alert-info" markdown="1">
**Note:**
IDEs such as WebStorm offer support for using pub,
including creating, installing, updating, and publishing packages.
To access the pub commands in WebStorm, double-click the
`pubspec.yaml` file. The **Pub actions** are provided above the
contents of the pubspec file.
</aside>

A package can live anywhere. For example, some packages are on GitHub.
The Dart team publishes packages at
[pub.dartlang.org](https://pub.dartlang.org),
and we hope you will, too.

To use a library that is in a Dart package, you need to do the
following:

* Create a pubspec (a file that lists package dependencies and includes
  other metadata, such as a name for your package).
* Use pub to get your package's dependencies.
* Import the library.

## Creating a pubspec
To use a package, your application must define a pubspec.
The simplest possible pubspec lists only the package name:

{% prettify yaml %}
name: my_app
{% endprettify %}

A pubspec is where you list dependencies and their download locations.
The pubspec is a file named <code class="literal">pubspec.yaml</code>,
and it must be in the top directory of your application.

Here is an example of a pubspec that specifies the locations of
two packages. First, it points to the js package that is hosted on
pub.dartlang.org, and then it points to the intl package in the Dart
SDK:

{% prettify yaml %}
name: my_app
dependencies:
  js: ^0.3.0
  intl: ^0.12.4
{% endprettify %}

For details, see the [pubspec documentation](/tools/pub/pubspec)
and the documentation for the packages you are interested in using.

## Installing packages
Once you have a pubspec, you can run <code class="literal">pub
get</code> from the top directory of your application:

{% prettify dart %}
cd <path-to-my_app>
pub get
{% endprettify %}

This process is called _getting the dependencies_.

The `pub get` command determines which packages your app depends on,
and puts them in a central [system cache](/tools/pub/glossary#system-cache).
For git dependencies, pub clones the git repository.
For hosted dependencies, pub downloads the package from
pub.dartlang.org. Transitive dependencies are included, too.
For example, if the js package depends on the test package, `pub`
grabs both the js package and the test package.

Pub creates a
`.packages` file (under your app’s top directory)
that maps each package name
that your app depends on to the corresponding package in the system cache.

{% comment %}
PENDING: Here only to make it easy to find the packages discussion:
packages-dir.html
{% endcomment %}

## Importing libraries from packages
To import libraries found in packages, use the
<code class="literal">package:</code> prefix:

{% prettify dart %}
import 'package:js/js.dart' as js;
import 'package:intl/intl.dart';
{% endprettify %}

The Dart runtime takes everything after `package:`
and looks it up within the `.packages` file for
your app.

You can also use this style to import libraries from within your own package.

Consider the following pubspec file, which declares a dependency on
the (fictional) `transmogrify` package:

{% prettify yaml %}
name: my_app
dependencies:
  transmogrify:
{% endprettify %}

Let's say that your package is laid out as follows:

{% prettify none %}
transmogrify/
  lib/
    transmogrify.dart
    parser.dart
  test/
    parser/
      parser_test.dart
{% endprettify %}

The `parser_test` file *could* import `parser.dart` like this:

{% prettify dart %}
import '../../lib/parser.dart';
{% endprettify %}

But that's a fragile relative path. If `parser_test.dart` is ever moved
up or down a directory, that path will break and you'll have to fix the code.
Instead, you can do as follows:

{% prettify dart %}
import 'package:transmogrify/parser.dart';
{% endprettify %}

This way, the import can always get to `parser.dart` regardless of where the
importing file is.

## Upgrading a dependency

The first time you get a new dependency for your package,
pub downloads the latest version of it that's compatible with
your other dependencies.
It then locks your package to *always* use that version by
creating a **lockfile**.
This is a file named `pubspec.lock` that pub creates and stores next to your
pubspec. It lists the specific versions of each dependency (immediate and
transitive) that your package uses.

If this is an application package,
you should check this file into source control.
That way, everyone working on your app ensures they are using the same versions
of all of the packages.
This also makes sure that you use the same versions of
code when you deploy your app to production.

When you are ready to upgrade your dependencies to the latest versions, do:

{% prettify sh %}
$ pub upgrade
{% endprettify %}

This tells pub to regenerate the lockfile using the newest
available versions of your package's dependencies.
If you only want to upgrade a specific dependency,
you can specify that too:

{% prettify sh %}
$ pub upgrade transmogrify
{% endprettify %}

This upgrades `transmogrify` to the latest version but leaves everything else
the same.

## More information

* [Pub Dependencies](/tools/pub/dependencies)
* [Pubspec Format](/tools/pub/pubspec)
* [Pub Package Layout Conventions](/tools/pub/package-layout)
* [Pub Commands](/tools/pub/cmd)

