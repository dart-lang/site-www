---
title: dart fix
description: Help for bringing your code up-to-date.
toc: false
---

The `dart fix` command (added in Dart 2.12)
finds and fixes two types of issues:

* Analysis issues that have associated automated fixes
  (sometimes called _quick-fixes_ or _code actions_)
* Issues that have associated package API migration information

{% include tools/dart-tool-note.md %}

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

The `dart fix` command replaces [`dartfix`][].

[`dartfix`]: {{site.pub-pkg}}/dartfix
