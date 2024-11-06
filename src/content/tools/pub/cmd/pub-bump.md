---
title: dart pub bump
description: Use dart pub bump to increase the version number of the current package.
---

_Bump_ is one of the commands of the [pub tool](/tools/pub/cmd).

```plaintext
$ dart pub bump <subcommand> [arguments]
```

This command increments the verion number of the current package.
It allows the subcommands `breaking`, `major`, `minor`,
and `patch` to increment only a specific part of the version number. 
For example:

```console
$ dart pub bump minor
  Updating version from 1.0.0 to 1.1.0
  
  Diff:
  - version: 1.0.0
  + version: 1.1.0
  
  Remember to update `CHANGELOG.md` before publishing.
```

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `-n, --dry-run`

Reports what would change for the version number, and shows the version diff,
without changing anything.
