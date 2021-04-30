---
title: dart pub get
description: Use dart pub get to retrieve the dependencies used by your Dart application.
---

_Get_ is one of the commands of the [pub tool](/tools/pub/cmd).

{% prettify nocode tag=pre+code %}
$ dart pub get [args]
{% endprettify %}

This command gets all the dependencies listed in the
[`pubspec.yaml`](/tools/pub/pubspec) file in the current working
directory, as well as their
[transitive dependencies](/tools/pub/glossary#transitive-dependency).
For example:

```terminal
$ dart pub get
Resolving dependencies...
Got dependencies!
```

If the [system cache](/tools/pub/glossary#system-cache)
doesn't already contain the dependencies, `dart pub get`
updates the cache,
downloading dependencies if necessary.
To map packages back to the system cache,
this command creates a `.packages` file.

Once the dependencies are acquired, they may be referenced in Dart code.
For example, if a package depends on `test`:

{% prettify dart tag=pre+code %}
import 'package:test/test.dart';
{% endprettify %}

When `dart pub get` gets new dependencies, it writes a
[lockfile](/tools/pub/glossary#lockfile) to ensure that future
gets will use the same versions of those dependencies.
Application packages should check in the lockfile to source control;
this ensures the application will use the exact same versions
of all dependencies for all developers and when deployed to production.
Library packages should not check in the lockfile, though, since they're
expected to work with a range of dependency versions.

If a lockfile already exists, `dart pub get` uses the versions of dependencies
locked in it if possible. If a dependency isn't locked, pub gets the
latest version of that dependency that satisfies all the [version
constraints](/tools/pub/glossary#version-constraint).
This is the primary difference between `dart pub get` and
[`dart pub upgrade`](/tools/pub/cmd/pub-upgrade), which always tries to
get the latest versions of all dependencies.

## Package resolution

By default, pub creates a `.packages` file
that maps from package names to location URIs.
Before the `.packages` file, pub used to create `packages` directories.

<aside class="alert alert-info" markdown="1">
**Note:** Don't check the generated `.packages` file,
`packages` directories (if present), or
`.dart_tool` directory into your repo;
add them to your repo's `.gitignore` file.
For more information, see
[What Not to Commit](/guides/libraries/private-files).
{% comment %}
PENDING: here just to make it easy to find discussions of `packages`...
{% include packages-dir.html %}
{% endcomment %}
</aside>

For more information, see the
[package specification file proposal.](https://github.com/lrhn/dep-pkgspec/blob/master/DEP-pkgspec.md#proposal)


## Getting a new dependency

If a dependency is added to the pubspec and then `dart pub get` is run,
it gets the new dependency and any of its transitive dependencies and
updates the mapping in the `.packages` file.
However, pub won't change the versions of any already-acquired
dependencies unless that's necessary to get the new dependency.


## Removing a dependency

If a dependency is removed from the pubspec and then `dart pub get` is run,
it removes the dependency from the `.packages` file,
making the dependency unavailable for importing.
Any transitive dependencies of the removed dependency are also removed,
as long as no remaining immediate dependencies also depend on them.
Removing a dependency never changes the versions of any
already-acquired dependencies.


## The system package cache

Dependencies downloaded over the internet, such as those from Git and the
[pub.dev site]({{site.pub}}), are stored in a
[system-wide cache](/tools/pub/glossary#system-cache).
This means that if multiple packages use the same version of the
same dependency, it only needs to be
downloaded and stored locally once.

By default, the system package cache is located in the `.pub-cache`
subdirectory of your home directory (on macOS and Linux),
or in `%LOCALAPPDATA%\Pub\Cache` (on Windows;
the location might vary depending on the Windows version).
You can configure the location of the cache by setting the
[`PUB_CACHE`](/tools/pub/environment-variables)
environment variable before running pub.


## Getting while offline

If you don't have network access, you can still run `dart pub get`.
Because pub downloads packages to a central cache shared by all packages
on your system, it can often find previously downloaded packages
without needing to use the network.

However, by default, `dart pub get` tries to go online if you
have any hosted dependencies,
so that pub can detect newer versions of dependencies.
If you don't want pub to do that, pass it the `--offline` flag.
In offline mode, pub looks only in your local package cache,
trying to find a set of versions that work with your package from what's already
available.

Keep in mind that pub generates a lockfile. If the
only version of some dependency in your cache happens to be old,
offline `dart pub get` locks your app to that old version.
The next time you are online, you will likely want to
run [`dart pub upgrade`](/tools/pub/cmd/pub-upgrade) to upgrade to a later version.


## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `--dry-run` or `-n`

Reports the dependencies that would be changed,
but doesn't make the changes. This is useful if you
want to analyze updates before making them.

### `--offline`

Uses cached packages rather than downloading
from the network.
For details, see [Getting while offline](#getting-while-offline).

### `--precompile`

Creates snapshots of the
project's executables in direct dependencies.

<aside class="alert alert-info" markdown="1">
*Problems?*
See [Troubleshooting Pub](/tools/pub/troubleshoot).
</aside>
