---
layout: default
permalink: /tools/pub/pubspec
title: "Pubspec Format"
---

Every [pub](/tools/pub) package needs some metadata so it can specify its
[dependencies](/tools/pub/glossary#dependency). Pub packages that are shared with
others also need to provide some other information so users can discover them.
All of this metadata goes in the package's _pubspec:_
a file named `pubspec.yaml` that's written in the
[YAML](http://www.yaml.org/) language.


## Supported fields

A pubspec can have the following fields:

`name`
: Required for every package.
  [_Learn more._](#name)

`version`
: Required for packages that are hosted on pub.dartlang.org.
  [_Learn more._](#version)

`description`
: Required for packages that are hosted on pub.dartlang.org.
  [_Learn more._](#description)

`author` or `authors`
: Optional.
  [_Learn more._](#authorauthors)

`homepage`
: Optional.
  [_Learn more._](#homepage)

`documentation`
: Optional. Can be used to automatically create documentation.
  [_Learn more._](#documentation)

`dependencies`
: Can be omitted if your package has no dependencies.
  [_Learn more._](#dependencies)

`dev_dependencies`
: Can be omitted if your package has no dev dependencies.
  [_Learn more._](#dependencies)

`dependency_overrides`
: Can be omitted if you do not need to override any dependencies.
  [_Learn more._](#dependencies)

`environment`
: Optional. Can be used to require a specific version of the Dart SDK.
  [_Learn more._](#sdk-constraints)

`executables`
: Optional. Used to put a package's executables on your PATH.
  [_Learn more._](#executables)

`publish_to`
: Optional. Specify where to publish a package. The default is
  `https://pub.dartlang.org`. Specify `none` to prevent a package from
  being published.

`transformers`
: Optional. Used to configure dart2js or other transformers.
  For more information, see
  [Pub Assets and Transformers](/tools/pub/assets-and-transformers) and
  [Configuring the Built-in dart2js Compiler]({{site.webdev}}/tools/pub/dart2js-transformer).

Pub ignores all other fields.

<aside class="alert alert-info" markdown="1">
**Flutter note:** Pubspecs for [Flutter apps]({{site.flutter}}) can have
[a few additional fields]({{site.flutter}}/assets-and-images)
for managing assets.
</aside>


## Example

A simple but complete pubspec looks something like the following:

{% prettify yaml %}
name: newtify
version: 1.2.3
description: >
  Have you been turned into a newt?  Would you like to be?
  This package can help: it has all of the
  newt-transmogrification functionality you have been looking
  for.
author: Natalie Weizenbaum <nweiz@google.com>
homepage: http://newtify.dartlang.org
documentation: http://docs.newtify.com
dependencies:
  efts: ^2.0.4
  transmogrify: ^0.4.0
dev_dependencies:
  test: '>=0.6.0 <0.12.0'
dependency_overrides:
  transmogrify:
    path: ../transmogrify_patch/
{% endprettify %}


## Details

This section has more information about most of the pubspec fields.

{% comment %}
TODO: Consider adding subsections for the remaining fields
(publish_to, transformers) so we don't have to say "most of".
{% endcomment %}


### Name

Every package needs a name.  It's how other packages refer to yours,
and how it appears to the world, should you publish it.

The name should be all lowercase, with underscores to separate words,
`just_like_this`. Use only basic Latin letters and Arabic digits:
`[a-z0-9_]`. Also, make sure the name is a valid Dart identifier—that it
doesn't start with digits and isn't a
[reserved word](/guides/language/language-tour#keywords).

Try to pick a name that is clear, terse, and not already in use.
A quick search of packages on
[pub.dartlang.org](https://pub.dartlang.org/packages)
to make sure that nothing else is using your name is recommended.

### Version

Every package has a version. A version number is required to host your package
on pub.dartlang.org, but can be omitted for local-only packages. If you omit
it, your package is implicitly versioned `0.0.0`.

Versioning is necessary for reusing code while letting it evolve quickly. A
version number is three numbers separated by dots, like `0.2.43`. It can also
optionally have a build (`+hotfix.oopsie`) or pre-release (`-alpha.12`) suffix.

Each time you publish your package, you publish it at a specific version.
Once that's been done, consider it hermetically sealed: you can't touch it
anymore. To make more changes, you'll need a new version.

When you select a version, follow [semantic versioning][].

[semantic versioning]: http://semver.org/spec/v2.0.0.html

### Description

This is optional for your own personal packages, but if you intend to
publish your package you must provide a description. This should
be relatively short&mdash;a few sentences, maybe a whole paragraph&mdash;and
tells a casual reader what they might want to know about your package.

Think of the description as the sales pitch for your package. Users see it
when they [browse for packages](https://pub.dartlang.org/packages).
It should be simple plain text: no markdown or HTML.
That's what your README is for.

### Author/Authors

You're encouraged to use these fields to describe the author(s) of your package
and provide contact information. `author` should be used if your package has a
single author, while `authors` should be used with a YAML list if more than one
person wrote the package. Each author can either be a single name
(`Natalie Weizenbaum`) or a name and an email address
(`Natalie Weizenbaum <nweiz@google.com>`). For example:

{% prettify yaml %}
authors:
- Natalie Weizenbaum <nweiz@google.com>
- Bob Nystrom <rnystrom@google.com>
{% endprettify %}

If anyone uploads your package to pub.dartlang.org, your email address is
public.

### Homepage

This should be a URL pointing to the website for your package.
For [hosted packages](/tools/pub/dependencies#hosted-packages),
this URL is linked from the package's page.
While this is technically optional *please do* provide one. It
helps users understand where your package is coming from. If nothing else, you
can always use the URL where you host the source code, such as
[GitHub](https://github.com).

### Documentation

Some packages may have a site that hosts documentation separate from the main
homepage. If your package has that, you can also add a `documentation:` field
with that URL. If provided, a link to it is shown on your package's page.

If you specify the `documentation:` field with a blank value,
documentation is created automatically for you, and is linked to from
[pub.dartlang.com](https://pub.dartlang.org/).

### Dependencies

[Dependencies](/tools/pub/glossary#dependency) are the pubspec's *raison d'être*.
In this section you list each package that your package needs in order to work.

Dependencies fall into one of two types. _Regular dependencies_ are listed
under `dependencies:`&mdash;these are packages that anyone using your package
will also need. Dependencies that are only needed in the development phase of
the package itself are listed under `dev_dependencies`.

During the development process, you might need to temporarily override
a dependency.  You can do so using `dependency_overrides`.

For more information, see [Pub Dependencies](/tools/pub/dependencies).

### Executables

A package may expose one or more of its scripts as executables that
can be run directly from the command line. To make a script publicly
available, list it under the `executables` field.
Entries are listed as key/value pairs:

{% prettify none %}
<name-of-executable>: <Dart-script-from-bin>
{% endprettify %}

For example, the following pubspec entry lists two scripts:

{% prettify yaml %}
executables:
  polymer-new-element: new_element
  useful-script:
{% endprettify %}

Once the package is activated using `pub global activate`,
typing `polymer-new-element` executes `bin/new_element.dart`.
Typing `useful-script` executes `bin/useful-script.dart`.
If you don't specify the value, it is inferred from the key.

For more information, see
[pub global](/tools/pub/cmd/pub-global#running-a-script-from-your-path).

### SDK constraints

A package can indicate which versions of its dependencies it supports, but there
is another implicit dependency all packages have: the Dart SDK itself.
Since the Dart platform evolves over time, a package may only work with certain
versions of it.

A package can specify that using an *SDK constraint*. This goes inside a
separate top-level `environment` field in the pubspec and uses the same
[version constraint](/tools/pub/dependencies#version-constraints) syntax as
dependencies.

For example, the following constraint says that this package
works with any 1.x Dart SDK that's version 1.23.0 or higher:

{% prettify yaml %}
environment:
  sdk: ">=1.23.0 <2.0.0"
{% endprettify %}

Pub tries to find the latest version of a package whose SDK constraint works
with the version of the Dart SDK that you have installed.

<aside class="alert alert-warning" markdown="1">
**Don't use caret syntax** (`^`) for the SDK constraint,
and **do include an upper bound** (`<2.0.0`, usually).
Packages that break these rules might stop working in the future
and, for that reason, might not be allowed on pub.dartlang.org.
For more information, see [Dart 2 Updates.](/dart-2)
</aside>


#### Flutter SDK constraints

As of Dart 1.19.0,
pub supports Flutter SDK constraints under the `environment:` field, like so:

{% prettify yaml %}
environment:
  sdk: ">=1.19.0 <2.0.0"
  flutter: "^0.1.2"
{% endprettify %}

A Flutter SDK constraint is only satisfied if pub is running in the
context of the `flutter` executable, and the Flutter SDK's
`version` file matches the given version constraint. Otherwise,
the package will not be selected.

To publish a package with a Flutter SDK constraint,
you must specify a Dart SDK constraint with a minimum version of
at least 1.19.0, to ensure that older versions of pub won't
accidentally install packages that need Flutter.

[pubsite]: https://pub.dartlang.org
[semantic versioning]: http://semver.org/spec/v2.0.0-rc.1.html
