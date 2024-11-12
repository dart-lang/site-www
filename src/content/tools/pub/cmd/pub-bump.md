---
title: dart pub bump
description: Use dart pub bump to increase the version number of the current package.
---

_Bump_ is one of the commands of the [pub tool](/tools/pub/cmd).

```plaintext
$ dart pub bump <subcommand> [options]
```

This command increments the version number of the current package.
Use one of the subcommands `breaking`, `major`, `minor`,
or `patch` according to the type of increment desired. 

Refer to [semver](https://semver.org/spec/v2.0.0-rc.1.html) for guidance on versioning your package.
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

Reports what would change for the version number under each subcommand,
and shows the version diff, without changing anything.
