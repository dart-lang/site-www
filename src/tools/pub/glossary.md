---
title: Glossary of package terms
description: A glossary of terms relating to Dart's package management tool, pub.
---

The following terms are used in the documentation for
[package management][] and
the [pub tool][].

[package management]: /guides/packages
[pub tool]: /tools/pub/cmd

## Application package

A package that contains a program or app, with a [main entrypoint][]. 
Meant to be run directly, either on the command line or in a browser.

Application packages may have [dependencies][] on other packages,
but are never depended on themselves.
Unlike regular [packages][], they are not intended to be shared.

Application packages should check their [lockfiles][] into source
control, so that everyone working on the application and every location the
application is deployed has a consistent set of dependencies. Because their
dependencies are constrained by the lockfile, application packages usually
specify `any` for their dependencies' [version constraints][].

[main entrypoint]: #entrypoint
[dependencies]: #dependency
[packages]: #package
[lockfiles]: #lockfile
[version constraints]: #version-constraint

## Content hashes

The pub.dev repository maintains a sha256 hash of each package version it hosts.
Pub clients can use this hash to validate the integrity of downloaded packages,
and protect against changes on the repository. 

When `dart pub get` downloads a package,
it computes the hash of the downloaded archive.
The hash of each hosted dependency is stored with the
[resolution][] in the [lockfile][].

The pub client uses this content hash
to verify that running `dart pub get` again using the same lockfile,
potentially on a different computer, uses exactly the same packages.

If the locked hash doesn't match what's currently in the pub cache,
pub redownloads the archive. If it still doesn't match, the lockfile
updates and a warning is printed. For example:

{% prettify nocode tag=pre+code %}
$ dart pub get
Resolving dependencies...
[!Cached version of foo-1.0.0 has wrong hash - redownloading.!]
 ~ foo 1.0.0 (was 1.0.0)
[!The existing content-hash from pubspec.lock doesn't match contents for:!]
 * foo-1.0.0 from "pub.dev"
This indicates one of:
 * The content has changed on the server since you created the pubspec.lock.
 * The pubspec.lock has been corrupted.
 
[!The content-hashes in pubspec.lock has been updated.!]

For more information see:
https://dart.dev/go/content-hashes

Changed 1 dependency!
{% endprettify %}

The updated content hash will show up in your version control diff,
and should make you suspicious.

To make a discrepancy become an error instead of a warning, use
[`dart pub get --enforce-lockfile`][]. It will cause the resolution to fail
if it cannot find package archives with the same hashes, without updating the lockfile.

{% prettify nocode tag=pre+code %}
$ dart pub get [!--enforce-lockfile!]
Resolving dependencies...
Cached version of foo-1.0.0 has wrong hash - redownloading.
~ foo 1.0.0 (was 1.0.0)
The existing content-hash from pubspec.lock doesn't match contents for:
 * foo-1.0.0 from "pub.dev"

This indicates one of:
 * The content has changed on the server since you created the pubspec.lock.
 * The pubspec.lock has been corrupted.

For more information see:
https://dart.dev/go/content-hashes
[!Would change 1 dependency.
Unable to satisfy `pubspec.yaml` using `pubspec.lock`.!]

To update `pubspec.lock` run `dart pub get` without
`--enforce-lockfile`.
{% endprettify %}

[resolution]: /tools/pub/cmd/pub-get
[lockfile]: #lockfile
[`dart pub get --enforce-lockfile`]: /tools/pub/cmd/pub-get#--enforce-lockfile

## Dependency

Another package that your package relies on. If your package wants to import
code from some other package, that package must be a dependency. Dependencies
are specified in your package's [pubspec][] and described in
[Package dependencies][].

To see the dependencies used by a package, use [`pub deps`][].

[pubspec]: /tools/pub/pubspec
[Package dependencies]: /tools/pub/dependencies
[`pub deps`]: /tools/pub/cmd/pub-deps

## Entrypoint

In the general context of Dart, an _entrypoint_ is
a Dart library that is directly invoked by a Dart implementation. When you
reference a Dart library in a `<script>` tag or pass it as a command-line
argument to the standalone Dart VM, that library is the entrypoint. In other
words, it's usually the `.dart` file that contains `main()`.

In the context of pub, an _entrypoint package_ or _root package_ is the root
of a dependency graph. It will usually be an application. When you run your app,
it's the entrypoint package. Every other package it depends on will not be an
entrypoint in that context.

A package can be an entrypoint in some contexts and not in others. Say your
app uses a package `A`. When you run your app, `A` is not the entrypoint
package. However, if you go over to `A` and execute its tests, in that
context, it *is* the entrypoint since your app isn't involved.

## Entrypoint directory

A directory inside your package that is allowed to contain
[Dart entrypoints](#entrypoint).

Pub has a list of these directories: `benchmark`, `bin`, `example`,
`test`, `tool`, and `web` (and `lib`, for [Flutter apps][]).
Any subdirectories of those (except `bin`) may also contain entrypoints.

[Flutter apps]: https://docs.flutter.dev/packages-and-plugins/developing-packages

## Immediate dependency

A [dependency](#dependency) that your package directly uses itself. The
dependencies you list in your pubspec are your package's immediate dependencies.
All other dependencies are [transitive dependencies](#transitive-dependency).

## Library

A library is a single compilation unit, made up of a single primary file and any
optional number of [parts][]. Libraries have their own private scope.

[parts]: /resources/glossary#part-file

## Lockfile

A file named `pubspec.lock` that specifies the concrete versions and other
identifying information for every immediate and transitive dependency a package
relies on.

Unlike the pubspec, which only lists immediate dependencies and allows version
ranges, the lockfile comprehensively pins down the entire dependency graph to
specific versions of packages. A lockfile ensures that you can recreate the
exact configuration of packages used by an application.

The lockfile is generated automatically for you by pub when you run
[`pub get`](/tools/pub/cmd/pub-get), [`pub upgrade`](/tools/pub/cmd/pub-upgrade),
or [`pub downgrade`](/tools/pub/cmd/pub-downgrade).
Pub includes a [content hash][] for each package
to check against during future resolutions.

If your package is an [application package][], you will typically check this into
source control. For regular packages, you usually won't.

[content hash]: #content-hashes

<a id="library-package"></a>

## Package

A collection of [libraries] under a directory,
with a [pubspec.yaml] in the root of that directory. 

Packages can have [dependencies](#dependency) on other packages
*and* can be dependencies themselves.
A package's `/lib` directory contains the
[public libraries][] that other packages can import and use.
They can also include scripts to be run directly.
A package that is not intended to be depended on by other packages is an
[application package][].
Shared packages are [published][] to pub.dev,
but you can also have non-published packages.

Don't check the [lockfile][] of a package into source
control, since libraries should support a range of dependency versions. The
[version constraints][] of a package's
[immediate dependencies][] should be as wide as possible while still
ensuring that the dependencies will be compatible with the versions that were
tested against.

Since [semantic versioning](https://semver.org/spec/v2.0.0-rc.1.html) requires
that libraries increment their major version numbers for any backwards
incompatible changes, packages will usually require their dependencies'
versions to be greater than or equal to the versions that were tested and less
than the next major version. So if your library depended on the (fictional)
`transmogrify` package and you tested it at version 1.2.1, your version
constraint would be [`^1.2.1`][].

[libraries]: #library
[pubspec.yaml]: /tools/pub/pubspec
[public libraries]: /tools/pub/package-layout#public-libraries
[application package]: #application-package
[published]: /tools/pub/publishing
[lockfile]: #lockfile
[version constraints]: #version-constraint
[immediate dependencies]: #immediate-dependency
[`^1.2.1`]: /tools/pub/dependencies#caret-syntax

## SDK constraint

The declared versions of the Dart SDK itself that a package declares that it
supports. An SDK constraint is specified using normal
[version constraint](#version-constraint) syntax, but in a special _environment_
section [in the pubspec](/tools/pub/pubspec#sdk-constraints).

## Source

A kind of place that pub can get packages from. A source isn't a specific place
like the pub.dev site or some specific Git URL. Each source describes a general
procedure for accessing a package in some way. For example, _git_ is one source.
The git source knows how to download packages given a Git URL. Several
different [supported sources](/tools/pub/dependencies#dependency-sources) are available.

## System cache

When pub gets a remote package,
it downloads it into a single _system cache_ directory maintained by
pub. On Mac and Linux, this directory defaults to `~/.pub-cache`.
On Windows, the directory defaults to `%LOCALAPPDATA%\Pub\Cache`,
though its exact location may vary depending on the Windows version.
You can specify a different location using the
[PUB_CACHE](/tools/pub/environment-variables) environment variable.

Once packages are in the system cache,
pub creates a `package_config.json` file that maps each package
used by your application to the corresponding package in the cache.

You only have to download a given version of a package once
and can then reuse it in as many packages as you would like.
If you specify the `--offline` flag to use cached packages,
you can delete and regenerate your `package_config.json`
files without having to access the network.


## Transitive dependency

A dependency that your package indirectly uses because one of its dependencies
requires it. If your package depends on A, which in turn depends on B which
depends on C, then A is an [immediate dependency](#immediate-dependency) and B
and C are transitive ones.


## Uploader

Someone who has administrative permissions for a package.
A package uploader can upload new versions of the package, 
and they can also 
[add and remove other uploaders](/tools/pub/publishing#uploaders)
for that package. 

If a package has a verified publisher,
then all members of the publisher can upload the package.


## Verified publisher

One or more users who own a set of packages.
Each verified publisher is identified by a verified domain name, such as
**dart.dev**.
For general information about verified publishers,
see the [verified publishers page][].
For details on creating a verified publisher
and transferring packages to it,
see the documentation for [publishing packages][].

[verified publishers page]: /tools/pub/verified-publishers
[publishing packages]: /tools/pub/publishing#verified-publisher

## Version constraint

A constraint placed on each [dependency](#dependency) of a package that
specifies which versions of that dependency the package is expected to work
with. This can be a single version (`0.3.0`) or a range of versions (`^1.2.1`).
While `any` is also allowed, for performance reasons we don't recommend it.

For more information, see
[Version constraints](/tools/pub/dependencies#version-constraints).

[Packages](#package) should always specify version constraints
for all of their dependencies. [Application packages](#application-package),
on the other hand, should usually allow any version of their dependencies,
since they use the [lockfile](#lockfile) to manage their dependency versions.

For more information, see
[Pub Versioning Philosophy](/tools/pub/versioning).
