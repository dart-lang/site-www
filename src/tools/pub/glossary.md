---
title: Glossary of package terms
description: A glossary of terms relating to Dart's package management tool, pub.
---

The following terms are used in the documentation for
[packagement management][] and
the [pub tool][].

[packagement management]: /guides/packages
[pub tool]: /tools/pub/cmd

## Application package

A package that is not intended to be used as a library. Application packages may
have [dependencies][] on other packages, but are never depended on
themselves. They are usually meant to be run directly, either on the command
line or in a browser. The opposite of an application package is a
[library package][].

Application packages should check their [lockfiles][] into source
control, so that everyone working on the application and every location the
application is deployed has a consistent set of dependencies. Because their
dependencies are constrained by the lockfile, application packages usually
specify `any` for their dependencies' [version constraints][].

[dependencies]: #dependency
[library package]: #library-package
[lockfiles]: #lockfile
[version constraints]: #version-constraint

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
app uses a library package A. When you run your app, A is not the entrypoint
package. However, if you go over to A and execute its tests, in that
context, it *is* the entrypoint since your app isn't involved.

## Entrypoint directory

A directory inside your package that is allowed to contain
[Dart entrypoints](#entrypoint).

Pub has a whitelist of these directories: `benchmark`, `bin`, `example`,
`test`, `tool`, and `web`. Any subdirectories of those (except `bin`) may also
contain entrypoints.

## Immediate dependency

A [dependency](#dependency) that your package directly uses itself. The
dependencies you list in your pubspec are your package's immediate dependencies.
All other dependencies are [transitive dependencies](#transitive-dependency).

## Library package

A package that other packages can depend on. Library packages can have
[dependencies](#dependency) on other packages *and* can be dependencies
themselves. They can also include scripts to be run directly. The
opposite of a library package is an [application package][].

[application package]: #application-package
[lockfile]: #lockfile
[version constraints]: #version-constraint
[immediate dependencies]: #immediate-dependency

Don't check the [lockfile][] of a library package into source
control, since libraries should support a range of dependency versions. The
[version constraints][] of a library package's
[immediate dependencies][] should be as wide as possible while still
ensuring that the dependencies will be compatible with the versions that were
tested against.

Since [semantic versioning](https://semver.org/spec/v2.0.0-rc.1.html) requires
that libraries increment their major version numbers for any backwards
incompatible changes, library packages will usually require their dependencies'
versions to be greater than or equal to the versions that were tested and less
than the next major version. So if your library depended on the (fictional)
`transmogrify` package and you tested it at version 1.2.1, your version
constraint would be [`^1.2.1`][].

[`^1.2.1`]: /tools/pub/dependencies#caret-syntax

## Lockfile

A file named `pubspec.lock` that specifies the concrete versions and other
identifying information for every immediate and transitive dependency a package
relies on.

Unlike the pubspec, which only lists immediate dependencies and allows version
ranges, the lock file comprehensively pins down the entire dependency graph to
specific versions of packages. A lockfile ensures that you can recreate the
exact configuration of packages used by an application.

The lockfile is generated automatically for you by pub when you run
[`pub get`](/tools/pub/cmd/pub-get), [`pub upgrade`](/tools/pub/cmd/pub-upgrade),
or [`pub downgrade`](/tools/pub/cmd/pub-downgrade).
If your package is an application package, you will typically check this into
source control. For library packages, you usually won't.

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
On Windows, the file lives in `%APPDATA%\Pub\Cache\bin`,
though its exact location may vary depending on the Windows version.
You can specify a different location using the
[PUB_CACHE](/tools/pub/environment-variables) environment variable.

Once packages are in the system cache,
pub creates a `.packages` file that maps each package
used by your application to the corresponding package in the cache.

You only have to download a given version of a package once
and can then reuse it in as many packages as you would like.
You can delete and regenerate your `.packages` file without having to access the network.


## Transitive dependency

A dependency that your package indirectly uses because one of its dependencies
requires it. If your package depends on A, which in turn depends on B which
depends on C, then A is an [immediate dependency](#immediate-dependency) and B
and C are transitive ones.


## Uploader

Someone who has administrative permissions for a package.
A package uploader can upload new versions of the package,
and they can also [add and remove other uploaders](/tools/pub/cmd/pub-uploader)
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

[Library packages](#library-package) should always specify version constraints
for all of their dependencies, but [application packages](#application-package)
should usually allow any version of their dependencies, since they use the
[lockfile](#lockfile) to manage their dependency versions.

For more information, see
[Pub Versioning Philosophy](/tools/pub/versioning).
