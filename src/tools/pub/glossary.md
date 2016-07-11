---
layout: default
title: "Glossary of Pub Terms"
description: "A glossary of terms relating to Dart's package management tool, pub."
permalink: /tools/pub/glossary
---

The following terms are used in the documentation for the [pub](/tools/pub)
tool.

## Application package {#application-package}

A package that is not intended to be used as a library. Application packages may
have [dependencies](#dependency) on other packages, but are never depended on
themselves. They are usually meant to be run directly, either on the command
line or in a browser. The opposite of an application package is a [library
package](#library-package).

Application packages should check their [lockfiles](#lockfile) into source
control, so that everyone working on the application and every location the
application is deployed has a consistent set of dependencies. Because their
dependencies are constrained by the lockfile, application packages usually
specify `any` for their dependencies' [version
constraints](#version-constraint).

## Asset {#asset}

A resource&mdash;Dart, HTML, JavaScript, CSS, image, or anything
else&mdash;intended to be part of a deployed package. The package can be a web
app, a package used by a web app, or any other package that benefits from a
build step. Tools such as [`pub serve`]({{site.webdev}}/tools/pub/pub-serve)
and [`pub build`]({{site.webdev}}/tools/pub/pub-build) take _source_ assets
(such as an HTML file, a CSS file, and several Dart files)
and produce _generated_ assets
(such as the same HTML and CSS files, plus a single JavaScript file).

Assets fall into four groups, with some overlap:

* Source asset: An actual, authored file on disk that `pub build` and
  `pub serve` can find and use.
* Generated asset: An asset (possibly the output of a
  [transformer](#transformer)) that's either served by `pub serve` or saved
  to disk by `pub build`.
* Input asset: An asset that is the input to a transformer. An input asset
  might be a source asset, or it might be the output of a transformer in a
  previous phase.
* Output asset: An asset that is created by a transformer. An output asset
  might be a generated asset, or it might be the input to a transformer in a
  later phase.

For more information, see
[Pub Assets and Transformers](assets-and-transformers.html).

## Dependency {#dependency}

Another package that your package relies on. If your package wants to import
code from some other package, that package must be a dependency. Dependencies
are specified in your package's [pubspec](pubspec.html) and described in
[Pub Dependencies](dependencies).

To see the dependencies used by a package, use [`pub deps`](cmd/pub-deps.html).

## Entrypoint {#entrypoint}

_Entrypoint_ is used to mean two things. In the general context of Dart, it is
a Dart library that is directly invoked by a Dart implementation. When you
reference a Dart library in a `<script>` tag or pass it as a command line
argument to the standalone Dart VM, that library is the entrypoint. In other
words, it's usually the `.dart` file that contains `main()`.

In the context of pub, an _entrypoint package_ or _root package_ is the root
of a dependency graph. It will usually be an application. When you run your app,
it's the entrypoint package. Every other package it depends on will not be an
entrypoint in that context.

A package can be an entrypoint in some contexts and not in others. Lets say your
app uses a library package A. When you run your app, A is not the entrypoint
package. However, if you go over to A and execute its tests, in that
context, it *is* the entrypoint since your app isn't involved.

## Entrypoint directory {#entrypoint-directory}

A directory inside your package that is allowed to contain
[Dart entrypoints](#entrypoint).

Pub has a whitelist of these directories: `benchmark`, `bin`, `example`,
`test`, `tool`, and `web`. Any subdirectories of those (except `bin`) may also
contain entrypoints.

## Immediate dependency {#immediate-dependency}

A [dependency](#dependency) that your package directly uses itself. The
dependencies you list in your pubspec are your package's immediate dependencies.
All other dependencies are [transitive dependencies](#transitive-dependency).

## Library package {#library-package}

A package that other packages will depend on. Library packages may have
[dependencies](#dependency) on other packages *and* may be dependencies
themselves. They may also include scripts that will be run directly. The
opposite of a library package is an [application package](#application-package).

Library packages should not check their [lockfile](#lockfile) into source
control, since they should support a range of dependency versions. Their
[immediate dependencies](#immediate-dependency)' [version
constraints](#version-constraint) should be as wide as possible while still
ensuring that the dependencies will be compatible with the versions that were
tested against.

Since [semantic versioning](http://semver.org/spec/v2.0.0-rc.1.html) requires
that libraries increment their major version numbers for any backwards
incompatible changes, library packages will usually require their dependencies'
versions to be greater than or equal to the versions that were tested and less
than the next major version. So if your library depended on the (fictional)
`transmogrify` package and you tested it at version 1.2.1, your version
constraint would be [`^1.2.1`](dependencies#caret-syntax).

## Lockfile {#lockfile}

A file named `pubspec.lock` that specifies the concrete versions and other
identifying information for every immediate and transitive dependency a package
relies on.

Unlike the pubspec, which only lists immediate dependencies and allows version
ranges, the lock file comprehensively pins down the entire dependency graph to
specific versions of packages. A lockfile ensures that you can recreate the
exact configuration of packages used by an application.

The lockfile is generated automatically for you by pub when you run
[`pub get`](cmd/pub-get.html), [`pub upgrade`](cmd/pub-upgrade.html),
or [`pub downgrade`](cmd/pub-downgrade.html)..
If your package is an application package, you will typically check this into
source control. For library packages, you usually won't.

## SDK constraint {#sdk-constraint}

The declared versions of the Dart SDK itself that a package declares that it
supports. An SDK constraint is specified using normal
[version constraint](#version-constraint) syntax, but in a special _environment_
section [in the pubspec](pubspec.html#sdk-constraints).

## Source {#source}

A kind of place that pub can get packages from. A source isn't a specific place
like pub.dartlang.org or some specific Git URL. Each source describes a general
procedure for accessing a package in some way. For example, _git_ is one source.
The git source knows how to download packages given a Git URL. Several
different [supported sources](dependencies#dependency-sources) are available.

## System cache {#system-cache}

When pub gets a remote package,
it downloads it into a single _system cache_ directory maintained by pub.
On Mac and Linux, this directory defaults to `~/.pub-cache`.
On Windows, it goes in `AppData\Roaming\Pub\Cache`.
You can specify a different location using the
[PUB_CACHE](/tools/pub/installing.html) environment variable.

Once packages are in the system cache,
pub creates symbolic links to the real packages in the system cache.
As of 1.12, pub also creates a `.packages` file that maps each package
used by your application to the corresponding package in the cache.

{% include coming-release.html %}

You only have to download a given version of a package once
and can then reuse it in as many packages as you would like.
You can delete and regenerate your `packages` directories
or `.packages` file without having to access the network.

## Transformer {#transformer}

For more information, see
[Pub Assets and Transformers](assets-and-transformers.html).

A transformer is a Dart object that converts input [assets](#asset) (such as
Dart files or Polymer-formatted HTML) into output assets (such as JavaScript
and HTML). The [`pub build`]({{site.webdev}}/tools/pub/pub-build)
command puts the generated assets into files.
The [`pub serve`]({{site.webdev}}/tools/pub/pub-serve) command,
on the other hand, doesn't produce files;
its generated assets are served directly by the dev server.

## Transitive dependency {#transitive-dependency}

A dependency that your package indirectly uses because one of its dependencies
requires it. If your package depends on A, which in turn depends on B which
depends on C, then A is an [immediate dependency](#immediate-dependency) and B
and C are transitive ones.

## Uploader {#uploader}

An uploader of a package is someone who has administrative permissions
for that package. They can not only upload new versions of a package,
but also [add and remove other uploaders](cmd/pub-uploader.html) for that
package. The uploader of a package is often, but not necessarily, the
same as the [author](pubspec.html#authorauthors) of a package.

Anyone uploading a new package automatically becomes an uploader for
that package. Otherwise, to become an uploader, you need to contact an
existing uploader and ask them to add you as another uploader.

## Version constraint {#version-constraint}

A constraint placed on each [dependency](#dependency) of a package that
specifies which versions of that dependency the package is expected to work
with. This can be a single version (`0.3.0`) or a range of versions (`^1.2.1`).
While `any` is also allowed, for performance reasons we don't recommend it.

For more information, see
[Version constraints](dependencies#version-constraints).

[Library packages](#library-package) should always specify version constraints
for all of their dependencies, but [application packages](#application-package)
should usually allow any version of their dependencies, since they use the
[lockfile](#lockfile) to manage their dependency versions.

For more information, see
[Pub Versioning Philosophy](versioning.html).
