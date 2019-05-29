---
title: The pubspec file
---

Every [pub package](/guides/packages) needs some metadata so it can specify its
[dependencies](/tools/pub/glossary#dependency). Pub packages that are shared with
others also need to provide some other information so users can discover them.
All of this metadata goes in the package's _pubspec:_
a file named `pubspec.yaml` that's written in the
[YAML](http://www.yaml.org/) language.

{% comment %}
PENDING: acknowledge the existence of pubspec.lock files.
{% endcomment %}


## Supported fields

A pubspec can have the following fields:

`name`
: Required for every package.
  [_Learn more._](#name)

`version`
: Required for packages that are hosted on the Pub site.
  [_Learn more._](#version)

`description`
: Required for packages that are hosted on the [Pub site.]({{site.pub}})
  [_Learn more._](#description)

`author` or `authors`
: Optional.
  [_Learn more._](#authorauthors)

`homepage`
: Optional. URL pointing to the package's homepage (or source code repository).
  [_Learn more._](#homepage)

`repository`
: Optional. URL pointing to the package's source code repository.
  [_Learn more._](#repository)

`issue_tracker`
: Optional. URL pointing to an issue tracker for the package.
  [_Learn more._](#issue-tracker)

`documentation`
: Optional. URL pointing to documentation for the package.
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
: Required as of Dart 2.
  [_Learn more._](#sdk-constraints)

`executables`
: Optional. Used to put a package's executables on your PATH.
  [_Learn more._](#executables)

`publish_to`
: Optional. Specify where to publish a package.
  [_Learn more._](#publish_to)

Pub ignores all other fields,

<aside class="alert alert-info" markdown="1">
**Flutter note:** Pubspecs for [Flutter apps]({{site.flutter}}) can have
[a few additional fields]({{site.flutter}}/assets-and-images)
for managing assets.
</aside>

If you add a custom field, give it a unique name
that won't clash with future pubspec fields.
For example, instead of adding `bugs`,
you might add a field named `my_pkg_bugs`.


## Example

A simple but complete pubspec looks something like the following:

{% prettify yaml %}
name: newtify
version: 1.2.3
description: >-
  Have you been turned into a newt?  Would you like to be?
  This package can help. It has all of the
  newt-transmogrification functionality you have been looking
  for.
author: Natalie Weizenbaum <nweiz@google.com>
homepage: https://example-pet-store.com/newtify
documentation: https://example-pet-store.com/newtify/docs
environment:
  sdk: '>=2.0.0 <3.0.0'
dependencies:
  efts: ^2.0.4
  transmogrify: ^0.4.0
dev_dependencies:
  test: '>=0.6.0 <0.12.0'
{% endprettify %}


## Details

This section has more information about most of the pubspec fields.

{% comment %}
TODO: Consider adding subsection for publish_to and anything else
that's missing so we don't have to say "most of".
https://github.com/dart-lang/site-www/issues/702
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
A quick search of packages on the
[Pub site]({{site.pub}}/packages)
to make sure that nothing else is using your name is recommended.

### Version

Every package has a version. A version number is required to host your package
on the Pub site, but can be omitted for local-only packages. If you omit
it, your package is implicitly versioned `0.0.0`.

Versioning is necessary for reusing code while letting it evolve quickly. A
version number is three numbers separated by dots, like `0.2.43`. It can also
optionally have a build (`+hotfix.oopsie`) or pre-release (`-alpha.12`) suffix.

Each time you publish your package, you publish it at a specific version.
Once that's been done, consider it hermetically sealed: you can't touch it
anymore. To make more changes, you'll need a new version.

When you select a version, follow [semantic versioning.][semantic versioning]

[semantic versioning]: http://semver.org/spec/v2.0.0.html

### Description

This is optional for your own personal packages, but if you intend to
publish your package you must provide a description, which should be in English.
The description should be relatively short&mdash;60 to 180 characters&mdash;and
tell a casual reader what they might want to know about your package.

Think of the description as the sales pitch for your package. Users see it
when they [browse for packages.]({{site.pub}}/packages)
The description is plain text: no markdown or HTML.

### Author/authors

You're encouraged to use these fields to describe the author(s) of your package
and provide contact information. Use `author` if your package has a
single author, or use `authors` with a YAML list if more than one
person wrote the package. Each author can be either a single name
(`Natalie Weizenbaum`) or a name and an email address
(`Natalie Weizenbaum <nweiz@google.com>`). For example:

{% prettify yaml %}
authors:
- Natalie Weizenbaum <nweiz@google.com>
- Bob Nystrom <rnystrom@google.com>
{% endprettify %}

If anyone uploads your package to the Pub site, your email address is
public.

### Homepage

This should be a URL pointing to the website for your package.
For [hosted packages](/tools/pub/dependencies#hosted-packages),
this URL is linked from the package's page.
While providing a `homepage` is optional, *please provide* it or `repository`
(or both). It helps users understand where your package is coming from.

### Repository

The optional `repository` field should contain the URL for your package's source
code repository — for example, `https://github.com/<user>/<repository>`.
If you publish your package to the Pub site, then your package's page
displays the repository URL.
While providing a `repository` is optional, *please provide* it or `homepage`
(or both). It helps users understand where your package is coming from.

### Issue tracker

The optional `issue_tracker` field should contain a URL for the package's
issue tracker, where existing bugs can be viewed and new bugs can be filed.
The Pub site attempts to display a link to each package's issue
tracker, using the value of this field. If `issue_tracker` is missing but
`repository` is present and points to GitHub, then the Pub site uses the
default issue tracker (`https://github.com/<user>/<repository>/issues`).

### Documentation

Some packages have a site that hosts documentation, separate from the main
homepage and from the Pub-generated API reference.
If your package has additional documentation, add a `documentation:` field
with that URL; pub shows a link to this documentation on your package's page.

### Dependencies

[Dependencies](/tools/pub/glossary#dependency) are the pubspec's *raison d'être*.
In this section you list each package that your package needs in order to work.

Dependencies fall into one of two types. _Regular dependencies_ are listed
under `dependencies:`&mdash;these are packages that anyone using your package
will also need. Dependencies that are only needed in the development phase of
the package itself are listed under `dev_dependencies`.

During the development process, you might need to temporarily override
a dependency.  You can do so using `dependency_overrides`.

For more information, see [Package dependencies](/tools/pub/dependencies).

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


### Publish_to

The default uses the [Pub site.]({{site.pub}}) Specify `none` to prevent
a package from being published. This setting can be used to specify a
[custom pub package server](https://github.com/dart-lang/pub-dartlang-dart/)
to publish.

{% prettify yaml %}
publish_to: none
{% endprettify %}


### SDK constraints

A package can indicate which versions of its dependencies it supports, but
packages have another implicit dependency: the Dart platform itself.
The Dart platform evolves over time, and a package might only work with certain
versions of the platform.

A package can specify those versions using an *SDK constraint*. This
constraint goes inside a separate top-level `environment` field in the pubspec
and uses the same
[version constraint](/tools/pub/dependencies#version-constraints) syntax as
dependencies.

For example, the following constraint says that this package
works with any **Dart 2** SDK that's version 2.0.0 or higher:

{% prettify yaml %}
environment:
  sdk: '>=2.0.0 <3.0.0'
{% endprettify %}

Pub tries to find the latest version of a package whose SDK constraint works
with the version of the Dart SDK that you have installed.

<aside class="alert alert-warning" markdown="1">
  **Don't use caret syntax** (`^`) for the SDK constraint,
  and **do include an upper bound** (`<3.0.0`, usually).
  For more information, see the [Dart 2 page](/dart-2).
</aside>


#### Flutter SDK constraints

As of Dart 1.19.0,
pub supports Flutter SDK constraints under the `environment:` field:

{% prettify yaml %}
environment:
  sdk: '>=1.19.0 <3.0.0'
  flutter: ^0.1.2
{% endprettify %}

A Flutter SDK constraint is satisfied only if pub is running in the
context of the `flutter` executable, and the Flutter SDK's
`version` file matches the given version constraint. Otherwise,
the package will not be selected.

To publish a package with a Flutter SDK constraint,
you must specify a Dart SDK constraint with a minimum version of
at least 1.19.0, to ensure that older versions of pub won't
accidentally install packages that need Flutter.

[pubsite]: {{site.pub}}
[semantic versioning]: http://semver.org/spec/v2.0.0-rc.1.html
