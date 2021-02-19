---
title: The dart fix command
description: Help for bringing your code up-to-date.
toc: false
---

The `dart fix` command finds and fixes two types of issues:

* Analysis issues that have associated automated fixes
  (sometimes called _quick fixes_)
* Issues that have associated package API migration information

{{site.alert.info}}
  For more information about this and other `dart` commands,
  see the [Dart command-line tool page](/tools/dart-tool).
{{site.alert.end}}

To preview proposed changes, use the `--dry-run` flag:

```terminal
$ dart fix --dry-run
```

To apply the proposed changes, use the `--apply` flag:

```terminal
$ dart fix --apply
```

For information about how automated package API changes work,
see [dart.dev/go/dart-fix](/go/dart-fix).

