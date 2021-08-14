---
title: dart pub remove
description: Use dart pub remove to remove a dependency.
---

_Remove_ is one of the commands of the [pub tool](/tools/pub/cmd).

```
$ dart pub remove <package> [options]
```

This command removes the specified package from the pubspec as a dependency.

For example, the following command is equivalent to
editing `pubspec.yaml` (removing `http` from `dependencies` or `dev_dependencies`)
and then calling `dart pub get`:

```
$ dart pub remove http
```

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `--[no-]offline`

Uses cached packages instead of the network.

### `-n, --dry-run`

Reports which dependencies would change, 
but doesn't change any.

### `--[no-]precompile`

Precompiles executables in immediate dependencies (`true` by default).

{{site.alert.info}}
  *Problems?*
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
{{site.alert.end}}
