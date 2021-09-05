---
title: dart pub cache
description: Use dart pub cache to manage your system cache.
---

_Cache_ is one of the commands of the [pub tool](/tools/pub/cmd).

```nocode
$ dart pub cache add <package> [--version <constraint>] [--all]
$ dart pub cache repair
$ dart pub cache clean
```

The `dart pub cache` command works with the
[system cache](/tools/pub/glossary#system-cache).

## Adding a package to the system cache

You can manually add a package to your system cache:

```terminal
$ dart pub cache add <package>
```

## Reinstalling all packages in the system cache

You can perform a clean reinstallation of all packages in your system cache:

```terminal
$ dart pub cache repair
```

This command can be useful when packages in your system cache
are somehow changed or broken.

For example, some editors make it easy to find implementation files
for packages in the system cache,
and you might accidentally edit one of those files.

## Clearing the global system cache

You can empty the entire system cache
to reclaim extra disk space or remove problematic packages:

```terminal
$ dart pub cache clean
```

{{site.alert.version-note}}
  The `clean` subcommand was introduced in Dart 2.14.
  To clear your system cache with an older SDK,
  you can manually delete the [`PUB_CACHE`][] folder.
{{site.alert.end}}

[`PUB_CACHE`]: /tools/pub/environment-variables

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `--all`

Use `dart pub cache add --all` 
to install all matching versions of a library.

### `--version `_`<constraint>`_

Use with `dart pub cache add`
to install the version best matching the specified constraint. 
For example:

```terminal
$ dart pub cache add http --version "0.12.2"
```

If `--version` is omitted, pub installs the best of all known versions.

{{site.alert.info}}
  *Problems?*
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
{{site.alert.end}}