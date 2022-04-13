---
title: dart fix
description: Command-line tool for applying analysis fixes and migrating API usages.
toc: false
---

The `dart fix` command
finds and fixes two types of issues:

* Analysis issues identified by [`dart analyze`][]
  that have associated automated fixes
  (sometimes called _quick-fixes_ or _code actions_)

  To learn more about customizing the analysis issues identified,
  see [Customizing static analysis](/guides/language/analysis-options).

* Outdated API usages when updating to
  newer releases of the Dart and Flutter SDKs.

{% include tools/dart-tool-note.md %}

To preview proposed changes, use the `--dry-run` flag:

```terminal
$ dart fix --dry-run
```

To apply the proposed changes, use the `--apply` flag:

```terminal
$ dart fix --apply
```

[`dart analyze`]: /tools/dart-analyze
