---
title: dart pub downgrade
description: Use dart pub downgrade to get the lowest versions of all dependencies used by your Dart application.
---

_Downgrade_ is one of the commands of the [pub tool](/tools/pub/cmd).

```nocode
$ dart pub downgrade [--[no-]offline] [-n|--dry-run] [dependencies...] 
```

Without any additional arguments, `dart pub downgrade` gets the lowest versions of
all the dependencies listed in the [`pubspec.yaml`](/tools/pub/pubspec) file
in the current working directory, as well as their [transitive
dependencies](/tools/pub/glossary#transitive-dependency).
For example:

```terminal
$ dart pub downgrade
Resolving dependencies... (1.2s)
+ barback 0.13.0
+ collection 0.9.1
+ path 1.2.0
+ source_maps 0.9.0
+ source_span 1.0.0
+ stack_trace 0.9.1
Changed 6 dependencies!
```

The `dart pub downgrade` command creates a lockfile. If one already exists,
pub ignores that file and generates a new one from scratch, using the lowest
versions of all dependencies.

See the [`dart pub get` documentation](/tools/pub/cmd/pub-get) for more information
on package resolution and the system package cache.


## Downgrading specific dependencies

It's possible to tell `dart pub downgrade` to downgrade specific dependencies to the
lowest version while leaving the rest of the dependencies alone as much as
possible. For example:

```terminal
$ dart pub downgrade test
Resolving dependencies...
  barback 0.15.2+2
  bot 0.27.0+2
  browser 0.10.0+2
  chrome 0.6.5
  collection 1.1.0
  path 1.3.0
  pool 1.0.1
  source_span 1.0.2
< stack_trace 0.9.2 (was 1.1.1)
  stagexl 0.10.2
< test 0.10.0 (was 0.11.4)
These packages are no longer being depended on:
- matcher 0.11.3
Changed 3 dependencies!
```

If you are downgrading a specific dependency, pub tries to find the
highest versions of any transitive dependencies that fit the new dependency
constraints. Any transitive dependencies are usually also downgraded
as a result.


## Getting a new dependency

If a dependency is added to the pubspec before `dart pub downgrade` is run,
it gets the new dependency and any of its transitive dependencies.
This shares the same behavior as `dart pub get`.


## Removing a dependency

If a dependency is removed from the pubspec before `dart pub downgrade` is run,
the dependency is no longer available for importing.
Any transitive dependencies of the removed dependency are also removed,
as long as no remaining immediate dependencies also depend on them.
This is the same behavior as `dart pub get`.


## Downgrading while offline

If you don't have network access, you can still run `dart pub downgrade`.
Because pub downloads packages to a central cache shared by all packages
on your system, it can often find previously downloaded packages
without needing to use the network.

However, by default, `dart pub downgrade` tries to go online if you
have any hosted dependencies.
If you don't want pub to do that, pass it the `--offline` flag.
In offline mode, pub looks only in your local package cache,
trying to find a set of versions that work with your package from what's already
available.



## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% include tools/pub-option-no-offline.md %}

### `--dry-run` or `-n`

Reports what dependencies would change but doesn't change any.


{{site.alert.info}}
  *Problems?*
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
{{site.alert.end}}
