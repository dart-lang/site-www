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

## Customizing dart fix

The `dart fix` command applies its fixes
based on the analysis configuration of the code it runs on. 
To learn more about customizing the analysis,
see [Customizing static analysis](/guides/language/analysis-options).

### Example

Imagine you have code like this:

```dart
class Vector2d {
  final double x, y;
  Vector2d(this.x, this.y);
}

class Vector3d extends Vector2d {
  final double z;

  Vector3d(final double x, final double y, this.z) : super(x, y);
}
```

Dart 2.17 introduced a new language feature called super initializers, 
which allows you to write the constructor of `Vector3d`
with a more compact style:

```dart
class Vector3d extends Vector2d {
  final double z;

  Vector3d(super.x, super.y, this.z);
}
```

To enable the dart fix to upgrade existing code to use this feature,
and to ensure that the analyzer warns you when you later forget to use it,
configure your `analysis_options.yaml` file like this:

```yaml
linter:
  rules:
    - use_super_parameters
```

You should then see the following when viewing the proposed changes:

```terminal
$ dart fix --dry-run
Computing fixes in myapp (dry run)... 9.0s

1 proposed fixes in 1 files.

lib/myapp.dart
  use_super_parameters • 1 fix
```

[`dart analyze`]: /tools/dart-analyze
