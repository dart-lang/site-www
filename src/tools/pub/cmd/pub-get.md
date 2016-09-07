---
layout: default
permalink: /tools/pub/cmd/pub-get
title: "pub get"
description: "Use pub get to retrieve the dependencies used by your Dart application."
toc: false
---

_Get_ is one of the commands of the _pub_ tool.
[Learn more about pub](/tools/pub).

{% prettify sh %}
$ pub get [--offline] [--no-packages-dirs | --packages-dirs]
{% endprettify %}

This command gets all the dependencies listed in the
[`pubspec.yaml`](/tools/pub/pubspec) file in the current working
directory, as well as their
[transitive dependencies](/tools/pub/glossary#transitive-dependency).
For example:

{% prettify sh %}
$ pub get
Got dependencies!
{% endprettify %}

If the [system cache](/tools/pub/glossary#system-cache)
doesn't already contain the dependencies, `pub get`
updates the cache,
downloading dependencies if necessary.
To map packages back to the system cache,
this command creates a `.packages` file and—unless you specify
the `--no-packages-dir` flag—one or more
`packages` directories.

{% comment %}
PENDING: here just to make it easy to find discussions of `packages`...
{% include coming-release.html %}
{% endcomment %}

<aside class="alert alert-warning" markdown="1">
  **The `.packages` file is replacing `packages` directories.**

  As of Dart 1.12,
  `packages` directories are being phased out and
  replaced by the `.packages` file.
  If both are present, the `.packages` file is preferred by
  tools that support it.
  For more information, see
  [Resolving package: URIs](https://github.com/lrhn/dep-pkgspec/blob/master/DEP-pkgspec.md#resolving-package-uris).

  As of Dart 1.19, you can suppress creation of the `packages` directories
  by specifying `--no-packages-dirs`.
  To request generation of `packages` directories
  (in addition to the `.packages` file),
  use the `--packages-dirs` flag.
</aside>

Once the dependencies are acquired, they may be referenced in Dart code.
For example, if a package depends on `test`:

{% prettify dart %}
import 'package:test/test.dart';
{% endprettify %}

When `pub get` gets new dependencies, it writes a
[lockfile](/tools/pub/glossary#lockfile) to ensure that future
gets will use the same versions of those dependencies.
Application packages should check in the lockfile to source control;
this ensures the application will use the exact same versions
of all dependencies for all developers and when deployed to production.
Library packages should not check in the lockfile, though, since they're
expected to work with a range of dependency versions.

If a lockfile already exists, `pub get` uses the versions of dependencies
locked in it if possible. If a dependency isn't locked, pub gets the
latest version of that dependency that satisfies all the [version
constraints](/tools/pub/glossary#version-constraint).
This is the primary difference between `pub get` and
[`pub upgrade`](/tools/pub/cmd/pub-upgrade), which always tries to
get the latest versions of all dependencies.

<aside class="alert alert-info" markdown="1">
**Note:** Do not check the generated `.package` file,
`packages` directories, or `.pub` directory (when present)
into your repo;
add them to your repo's `.gitignore` file.
[What Not to Commit](/guides/libraries/private-files) has a complete list
of files that should not be checked into the repo.
</aside>

## Getting a new dependency

If a dependency is added to the pubspec and then `pub get` is run,
it gets the new dependency and any of its transitive dependencies and
updates the mapping in the `.packages` file and
the links in the `packages` directory.
However, pub won't change the versions of any already-acquired
dependencies unless that's necessary to get the new dependency.

## Removing a dependency

If a dependency is removed from the pubspec and then `pub get` is run,
it removes the dependency from the `.packages` file and
`packages` directory, thus making it unavailable for importing.
Any transitive dependencies of the removed dependency are also removed,
as long as no remaining immediate dependencies also depend on them.
Removing a dependency never changes the versions of any
already-acquired dependencies.

## The system package cache

Dependencies downloaded over the internet, such as those from Git and
[pub.dartlang.org](https://pub.dartlang.org), are stored in a
[system-wide cache](/tools/pub/glossary#system-cache).
This means that if multiple packages use the same version of the
same dependency, it only needs to be
downloaded and stored locally once. It also means that it's safe to delete
the `.packages` file and `packages` directories, without
worrying about re-downloading packages.

By default, the system package cache is located in the `.pub-cache`
subdirectory of your home directory (on Mac and Linux),
or in `AppData\Roaming\Pub\Cache` (on Windows).
However, it may be configured by setting the
[`PUB_CACHE`](/tools/pub/installing)
environment variable before running pub.

## Getting while offline

If you don't have network access, you can still run `pub get`.
Since pub downloads packages to a central cache shared by all packages
on your system, it can often find previous-downloaded packages there
without needing to hit the network.

However, by default, pub always tries to go online when you get if you
have any hosted dependencies so that it can see if newer versions of them are
available. If you don't want it to do that, pass the `--offline` flag when
running pub. In this mode, it only looks in your local package cache and
tries to find a set of versions that work with your package from what's already
available.

Keep in mind that pub generates a lockfile after it does this. If the
only version of some dependency in your cache happens to be old, this locks
your app to that version. The next time you are online, you will likely want to
run [`pub upgrade`](/tools/pub/cmd/pub-upgrade) to upgrade to a later version.

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

<aside class="alert alert-info" markdown="1">
*Problems?*
See [Troubleshooting Pub](/tools/pub/troubleshoot).
</aside>
