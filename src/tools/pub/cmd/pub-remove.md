---
title: dart pub remove
description: Use dart pub remove to remove dependecies from pubspec.yaml.
toc: false
---

_Remove_ is one of the commands of the [pub tool](/tools/pub/cmd).

```
$ dart pub remove <package> [options]
```

Example:

```
$ dart pub remove http
```

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

<dl>
    <dt><code>-h, --help</code></dt>
        <dd>Print this usage information.</dd>
    <dt><code>--[no-]offline</code></dt>
    <dd>Use cached packages instead of accessing the network.</dd>
    <dt><code>-n, --dry-run</code></dt>
    <dd>Report what dependencies would change but don't change any.</dd>
    <dt><code>--[no-]precompile</code></dt>
    <dd>Precompile executables in immediate dependencies.</dd>

</dl>
