---
title: The pubspec file
description: Reference guide for the fields in pubspec.yaml.
---

Every [pub package](/guides/packages) needs some metadata so it can specify its
[dependencies](/tools/pub/glossary#dependency). Pub packages that are shared with
others also need to provide some other information so users can discover them.
All of this metadata goes in the package's _pubspec:_
a file named `pubspec.yaml` that's written in the
[YAML](https://yaml.org/) language.

{% comment %}
PENDING: acknowledge the existence of pubspec.lock files.
{% endcomment %}


## Supported fields

A pubspec can have the following fields:

`name`
: Required for every package.
  [_Learn more._](#name)

`version`
: Required for packages that are hosted on the pub.dev site.
  [_Learn more._](#version)

`description`
: Required for packages that are hosted on the pub.dev site.
  [_Learn more._](#description)

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

`platforms`
: Optional. Used to explicitly declare supported platforms
  on the pub.dev site.
  [_Learn more._](#platforms)

`publish_to`
: Optional. Specify where to publish a package.
  [_Learn more._](#publish_to)

`funding`
: Optional. List of URLs where users can sponsor development of the package.
  [_Learn more._](#funding)

`false_secrets`
: Optional. Specify files to ignore when conducting a pre-publishing search
  for potential leaks of secrets.
  [_Learn more._](#false_secrets)

Pub ignores all other fields,

{{site.alert.flutter-note}}
  Pubspecs for [Flutter apps]({{site.flutter}}) can have
  [additional fields]({{site.flutter-docs}}/development/tools/pubspec)
  for configuring the environment and managing assets.
{{site.alert.end}}

If you add a custom field, give it a unique name
that won't clash with future pubspec fields.
For example, instead of adding `bugs`,
you might add a field named `my_pkg_bugs`.


## Example

A simple but complete pubspec looks something like the following:

```yaml
name: newtify
description: >-
  Have you been turned into a newt?  Would you like to be?
  This package can help. It has all of the
  newt-transmogrification functionality you have been looking
  for.
version: 1.2.3
homepage: https://example-pet-store.com/newtify
documentation: https://example-pet-store.com/newtify/docs

environment:
  sdk: '>=2.10.0 <3.0.0'
  
dependencies:
  efts: ^2.0.4
  transmogrify: ^0.4.0
  
dev_dependencies:
  test: '>=1.15.0 <2.0.0'
```


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
[pub.dev site]({{site.pub-pkg}})
to make sure that nothing else is using your name is recommended.

### Version

Every package has a version. A version number is required to host your package
on the pub.dev site, but can be omitted for local-only packages. If you omit
it, your package is implicitly versioned `0.0.0`.

Versioning is necessary for reusing code while letting it evolve quickly. A
version number is three numbers separated by dots, like `0.2.43`. It can also
optionally have a build ( `+1`, `+2`, `+hotfix.oopsie`) or prerelease
(`-dev.4`, `-alpha.12`, `-beta.7`, `-rc.5`) suffix.

Each time you publish your package, you publish it at a specific version.
Once that's been done, consider it hermetically sealed: you can't touch it
anymore. To make more changes, you'll need a new version.

When you select a version, follow [semantic versioning.][semantic versioning]

[semantic versioning]: https://semver.org/spec/v2.0.0-rc.1.html

### Description

This is optional for your own personal packages, but if you intend to
publish your package you must provide a description, which should be in English.
The description should be relatively short—60 to 180 characters—and
tell a casual reader what they might want to know about your package.

Think of the description as the sales pitch for your package. Users see it
when they [browse for packages.]({{site.pub-pkg}})
The description is plain text: no markdown or HTML.

### Author/authors

_Deprecated._ Use a [verified publisher][] instead.

[verified publisher]: /tools/pub/verified-publishers

You might see an `author` or `authors` section in old pubspecs.
These optional fields were a way to describe
the author(s) of your package and to provide contact information.
Each author could be either a single name
(`Natalie Weizenbaum`) or a name and an email address
(`Natalie Weizenbaum <nweiz@google.com>`).
However, these values weren't verified.

The pub.dev site no longer displays package authors, and
(as of Dart 2.7) the `pub publish` command
displays a warning if your pubspec has an `author` or `authors` section.


### Homepage

This should be a URL pointing to the website for your package.
For [hosted packages](/tools/pub/dependencies#hosted-packages),
this URL is linked from the package's page.
While providing a `homepage` is optional, *please provide* it or `repository`
(or both). It helps users understand where your package is coming from.

### Repository

The optional `repository` field should contain the URL for your package's source
code repository—for example, `https://github.com/<user>/<repository>`.
If you publish your package to the pub.dev site, then your package's page
displays the repository URL.
While providing a `repository` is optional, *please provide* it or `homepage`
(or both). It helps users understand where your package is coming from.

### Issue tracker

The optional `issue_tracker` field should contain a URL for the package's
issue tracker, where existing bugs can be viewed and new bugs can be filed.
The pub.dev site attempts to display a link to each package's issue
tracker, using the value of this field. If `issue_tracker` is missing but
`repository` is present and points to GitHub, then the pub.dev site uses the
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
under `dependencies:`—these are packages that anyone using your package
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

{% prettify none tag=pre+code %}
<name-of-executable>: <Dart-script-from-bin>
{% endprettify %}

For example, the following pubspec entry lists two scripts:

{% prettify yaml tag=pre+code %}
executables:
  slidy: main
  fvm:
{% endprettify %}

Once the package is activated using `pub global activate`,
typing `slidy` executes `bin/main.dart`.
Typing `fvm` executes `bin/fvm.dart`.
If you don't specify the value, it is inferred from the key.

For more information, see
[pub global](/tools/pub/cmd/pub-global#running-a-script-from-your-path).


### Platforms

When you [publish a package][], pub.dev automatically 
detects the platforms that the package supports.
If this platform-support list is incorrect,
use `platforms` to explicitly declare
which platforms your package supports.

For example, the following `platforms` entry causes pub.dev
to list the package as supporting
Android, iOS, Linux, macOS, Web, and Windows:

```yaml
# This package supports all platforms listed below.
platforms:
  android:
  ios:
  linux:
  macos:
  web:
  windows:
```

Here is an example of declaring that the package supports
only Linux and macOS (and not, for example, Windows):

```yaml
# This package supports only Linux and macOS.
platforms:
  linux:
  macos:
```

{{site.alert.flutter-note}}
  Flutter plugins use [plugin declarations][]
  instead of this field.
{{site.alert.end}}

{{site.alert.version-note}}
  Support for the `platforms` entry was added in Dart 2.16.
{{site.alert.end}}

[publish a package]: /tools/pub/publishing
[plugin declarations]: {{site.flutter-docs}}/development/packages-and-plugins/developing-packages#plugin-platforms


### Publish_to

The default uses the [pub.dev site.]({{site.pub}}) Specify `none` to prevent
a package from being published. This setting can be used to specify a
[custom pub package server](/tools/pub/custom-package-repositories)
to publish.

{% prettify yaml tag=pre+code %}
publish_to: none
{% endprettify %}


### Funding

Package authors can use the `funding` property to specify a list of URLs that
provide information on how users can help fund the development of the package.
For example:

```yaml
funding:
 - https://www.buymeacoffee.com/example_user
 - https://www.patreon.com/some-account
```

If published to [pub.dev]({{site.pub}}) the links are displayed on the
package page. This aims to help users fund the development
of their dependencies.


### False_secrets

When you try to [publish a package][],
pub conducts a search for potential leaks of
secret credentials, API keys, or cryptographic keys.
If pub detects a potential leak in a file that would be published,
then pub warns you and refuses to publish the package.

Leak detection isn't perfect.
To avoid false positives,
you can tell pub not to search for leaks in certain files,
by creating an allowlist
using [`gitignore` patterns][] under
`false_secrets` in the pubspec.

[`gitignore` patterns]: https://git-scm.com/docs/gitignore#_pattern_format

For example, the following entry causes pub not to look for leaks in
the file `lib/src/hardcoded_api_key.dart`
and in all `.pem` files in the `test/localhost_certificates/` directory:

[publish a package]: /tools/pub/publishing

{% prettify yaml tag=pre+code %}
false_secrets:
 - /lib/src/hardcoded_api_key.dart
 - /test/localhost_certificates/*.pem
{% endprettify %}

Starting a `gitignore` pattern with slash (`/`) ensures that
the pattern is considered relative to the package's root directory.

{{site.alert.warn}}
  **Don't rely on leak detection.**
  It uses a limited set of patterns
  to detect common mistakes.
  You're responsible for managing your credentials,
  preventing accidental leaks, and
  revoking credentials that are accidentally leaked.
{{site.alert.end}}

{{site.alert.version-note}}
  Support for the `false_secrets` field was added in Dart 2.15.
{{site.alert.end}}

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

{{site.alert.version-note}}
  For a package to use a feature introduced after 2.0,
  its pubspec must have a lower constraint that's at least
  the version when the feature was introduced.
  For details, see the [language evolution page][].
{{site.alert.end}}

[language evolution page]: /guides/language/evolution

For example, the following constraint says that this package
works with any Dart SDK that's version 2.10.0 or higher:

```yaml
environment:
  sdk: '>=2.10.0 <3.0.0'
```

Pub tries to find the latest version of a package whose SDK constraint works
with the version of the Dart SDK that you have installed.

As of Dart 2.12, omitting the SDK constraint is an error.
When the pubspec has no SDK constraint,
`pub get` fails with a message like the following:

```
pubspec.yaml has no lower-bound SDK constraint.
You should edit pubspec.yaml to contain an SDK constraint:

environment:
  sdk: '>=2.10.0 <3.0.0'
```

{{site.alert.warning}}
  Caret syntax (`^`) is a compact way to represent version ranges, 
  but **don't use it for the SDK constraint.** 
  Instead, **include an upper bound for the SDK** (`<3.0.0`, usually). 
  For more information, 
  see the [Caret syntax](/tools/pub/dependencies#caret-syntax) documentation.
{{site.alert.end}}


#### Flutter SDK constraints

As of Dart 1.19.0,
pub supports Flutter SDK constraints under the `environment:` field:

```yaml
environment:
  sdk: '>=1.19.0 <3.0.0'
  flutter: ^0.1.2
```

A Flutter SDK constraint is satisfied only if pub is running in the
context of the `flutter` executable, and the Flutter SDK's
`version` file matches the given version constraint. Otherwise,
the package will not be selected.

To publish a package with a Flutter SDK constraint,
you must specify a Dart SDK constraint with a minimum version of
at least 1.19.0, to ensure that older versions of pub won't
accidentally install packages that need Flutter.

[pubsite]: {{site.pub}}
[semantic versioning]: https://semver.org/spec/v2.0.0-rc.1.html
