---
title: dart pub upgrade
description: Use dart pub upgrade to get the latest versions of all dependencies used by your Dart app.
---

_Upgrade_ is one of the commands of the [pub tool](/tools/pub/cmd).

{% prettify nocode tag=pre+code %}
$ dart pub upgrade [args] [dependencies]
{% endprettify %}

Like [`dart pub get`](/tools/pub/cmd/pub-get),
`dart pub upgrade` gets dependencies.
The difference is that `dart pub upgrade` ignores any existing
[lockfile](/tools/pub/glossary#lockfile),
so that pub can get the latest versions of all dependencies.
A related command is [`dart pub outdated`](/tools/pub/cmd/pub-outdated),
which you can run to find out-of-date dependencies.

Without any additional arguments, `dart pub upgrade` gets the latest
versions of all the dependencies listed in the
[`pubspec.yaml`](/tools/pub/pubspec) file in the current working
directory, as well as their [transitive
dependencies](/tools/pub/glossary#transitive-dependency).
For example:

```terminal
$ dart pub upgrade
Dependencies upgraded!
```

When `dart pub upgrade` upgrades dependency versions, it writes a lockfile to ensure that
[`dart pub get`](/tools/pub/cmd/pub-get) will use the same versions of those
dependencies. For application packages, check in the lockfile to
source control; this ensures the application has the exact same
versions of all dependencies for all developers and when deployed to
production. For library packages, don't check in the lockfile,
because libraries are expected to work with a range of dependency versions.

If a lockfile already exists, `dart pub upgrade` ignores it and generates a new
one from scratch, using the latest versions of all dependencies.

See the [`dart pub get` documentation](/tools/pub/cmd/pub-get) for more information
on package resolution and the system package cache.

## Upgrading specific dependencies

You can tell `dart pub upgrade` to upgrade specific dependencies to the
latest version while leaving the rest of the dependencies alone as much as
possible. For example:

```terminal
  $ dart pub upgrade test args
  Dependencies upgraded!
```

Upgrading a dependency upgrades its transitive dependencies to their latest
versions as well. Usually, no other dependencies are updated; they stay at the
versions that are locked in the lockfile. However, if the requested upgrades
cause incompatibilities with these locked versions, they are selectively
unlocked until a compatible set of versions is found.


## Getting a new dependency

If a dependency is added to the pubspec before `dart pub upgrade` is run,
it gets the new dependency and any of its transitive dependencies,
placing them in the `.packages` file. This
is the same behavior as `dart pub get`.


## Removing a dependency

If a dependency is removed from the pubspec before `dart pub upgrade` is
run, it removes the dependency from the `.packages` file,
thus making the dependency unavailable for
importing. Any transitive dependencies of the removed dependency are
also removed, as long as no remaining immediate dependencies also
depend on them. This is the same behavior as `dart pub get`.


## Upgrading while offline

If you don't have network access, you can still run `dart pub upgrade`.
Because pub downloads packages to a central cache shared by all packages
on your system, it can often find previously downloaded packages
without needing to use the network.

However, by default, `dart pub upgrade` tries to go online if you
have any hosted dependencies,
so that pub can detect newer versions of dependencies.
If you don't want pub to do that, pass it the `--offline` flag.
In offline mode, pub looks only in your local package cache,
trying to find a set of versions that work with your package from what's already
available.

Keep in mind that pub generates a lockfile. If the
only version of some dependency in your cache happens to be old,
offline `dart pub upgrade` locks your app to that old version.
The next time you are online, you will likely want to
run `dart pub upgrade` again to upgrade to a later version.


## Options

The `dart pub upgrade` command supports the
[`dart pub get` options](/tools/pub/cmd/pub-get#options).

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `--dry-run` or `-n`

With this, pub reports the dependencies that would
but does not make the changes. This is useful if you
want to analyze the updates before making them.

### `--precompile`

This option makes pub compile executables in its dependencies
before running the get process.

### `--major-versions`

When pub upgrades with this option, it will do so
ignoring any upper-bound constraint in the
`pubspec.yaml` file. It will also update `pubspec.yaml`
with the newly defined constraints.
The packages it gets are those
listed as "Resolvable" with `dart pub outdated`.

It is recommended to commit your `pubspec.yaml` file
before running this, as this cannot be undone otherwise.
You can use `dart pub upgrade --major-versions --dry-run`
to quickly check which dependencies would be upgraded. 

### `--null-safety`

This is similar to `--major-versions`, except that pub will
force dependencies to use null-safety versions. The packages
it gets are those listed in `dart pub outdated --mode=null-safety`.
This option will also guide you to do a partial null-safety migration.

<aside class="alert alert-info" markdown="1">
*Problems?*
See [Troubleshooting Pub](/tools/pub/troubleshoot).
</aside>
