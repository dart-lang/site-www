---
title: dart pub upgrade
description: Use dart pub upgrade to get the latest versions of all dependencies used by your Dart app.
---

_Upgrade_ is one of the commands of the [pub tool](/tools/pub/cmd).

```nocode
$ dart pub upgrade [options] [dependencies]
```

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
dependencies. For [application packages][], check in the lockfile to
source control; this ensures the application has the exact same
versions of all dependencies for all developers and when deployed to
production. For regular packages, don't check in the lockfile,
because packages are expected to work with a range of dependency versions.

If a lockfile already exists, `dart pub upgrade` ignores it and generates a new
one from scratch, using the latest versions of all dependencies.

See the [`dart pub get` documentation](/tools/pub/cmd/pub-get) for more information
on package resolution and the system package cache.

[application packages]: /tools/pub/glossary#application-package

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
it gets the new dependency and any of its transitive dependencies.
This shares the same behavior as `dart pub get`.


## Removing a dependency

If a dependency is removed from the pubspec before `dart pub upgrade` is run,
the dependency is no longer available for importing.
Any transitive dependencies of the removed dependency are also removed,
as long as no remaining immediate dependencies also depend on them.
This is the same behavior as `dart pub get`.

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
[`dart pub get` options](/tools/pub/cmd/pub-get#options), and more.
For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% include tools/pub-option-no-offline.md %}

### `--dry-run` or `-n`

Reports the dependencies that would be changed,
but doesn't make the changes. This is useful if you
want to analyze updates before making them.

### `--[no-]precompile`

By default, pub precompiles executables
in immediate dependencies (`--precompile`).
To prevent precompilation, use `--no-precompile`.

### `--null-safety`

Gets the packages that
[`dart pub outdated --mode=null-safety`][`dart pub outdated`]
lists as _resolvable_,
ignoring any upper-bound constraint in the `pubspec.yaml` file.
Also updates `pubspec.yaml` with the new constraints.
This command is similar to `--major-versions`.

{{site.alert.tip}}
  Commit the `pubspec.yaml` file before running this command,
  so that you can undo the changes if necessary.
{{site.alert.end}}

### `--major-versions`

Gets the packages that [`dart pub outdated`][] lists as _resolvable_,
ignoring any upper-bound constraint in the `pubspec.yaml` file.
Also updates `pubspec.yaml` with the new constraints.

[`dart pub outdated`]: /tools/pub/cmd/pub-outdated

{{site.alert.tip}}
  Commit the `pubspec.yaml` file before running this command,
  so that you can undo the changes if necessary.
{{site.alert.end}}

To check which dependencies will be upgraded,
you can use `dart pub upgrade --major-versions --dry-run`.


{{site.alert.info}}
  *Problems?*
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
{{site.alert.end}}
