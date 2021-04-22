---
title: dart pub remove
description: Use dart pub remove to remove a dependency.
toc: false
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

<dl>
    <dt><code>--[no-]offline</code></dt>
    <dd>Uses cached packages instead of the network.</dd>
    <dt><code>-n, --dry-run</code></dt>
    <dd>Reports which dependencies would change, but doesn't change any.</dd>
    <dt><code>--[no-]precompile</code></dt>
    <dd>Precompiles executables in immediate dependencies (true by default).</dd>
</dl>
