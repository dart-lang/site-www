---
title: dart fix
description: Command-line tool for applying analysis fixes and migrating API usages.
---

The `dart fix` command
finds and fixes two types of issues:

* Analysis issues identified by [`dart analyze`][]
  that have associated automated fixes
  (sometimes called _quick-fixes_ or _code actions_).

* Outdated API usages when updating to
  newer releases of the Dart and Flutter SDKs.

:::tip
To learn about `dart fix` in a video format,
check out this [deep dive][] on **Decoding Flutter**:

<iframe
  {{yt.std-size}}
  src="{{yt.embed}}/OBIuSrg_Quo"
  title="Learn how to use 'dart fix'"
  {{yt.set}}>
</iframe>
:::

[deep dive]: {{yt.watch}}/OBIuSrg_Quo

<a id="usage"></a>
## Apply fixes

To preview proposed changes, use the `--dry-run` flag:

```console
$ dart fix --dry-run
```

To apply the proposed changes, use the `--apply` flag:

```console
$ dart fix --apply
```

<a id="customization"></a>
## Customize behavior {:#customize}

The `dart fix` command only applies fixes
when there is a "problem" identified by a diagnostic.
Some diagnostics, such as compilation errors, are implicitly enabled,
while others, such as lints, must be explicitly enabled
in the [analysis options file](/tools/analysis),
as individual preferences for these vary.

You can sometimes increase the number of fixes that can be applied
by enabling additional lints.
Note that not all diagnostics have associated fixes.

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

To enable `dart fix` to upgrade existing code to use this feature,
and to ensure that the analyzer warns you when you later forget to use it,
configure your `analysis_options.yaml` file as follows:

```yaml
linter:
  rules:
    - use_super_parameters
```

We also need to make sure the code enables the required [language version][].
Super initializers were introduced in Dart 2.17,
so update `pubspec.yaml` to have at least that
in the lower SDK constraint:

```yaml
environment:
  sdk: ">=2.17.0 <4.0.0"
```

You should then see the following when viewing the proposed changes:

```console
$ dart fix --dry-run
Computing fixes in myapp (dry run)... 9.0s

1 proposed fixes in 1 files.

lib/myapp.dart
  use_super_parameters • 1 fix
```

To learn more about customizing analysis results and behavior,
see [Customizing static analysis](/tools/analysis).

[`dart analyze`]: /tools/dart-analyze
[language version]: /guides/language/evolution#language-versioning

## VS Code support

When you open a project in VS Code,
the Dart plugin scans the project for issues that `dart fix` can repair.
If it finds issues for repair, VS Code displays a prompt to remind you.

<img src="/assets/img/tools/vscode/dart_fix_notification.png" width="550" height="175" alt="VS Code notification about 'dart fix'">

After running `dart pub get` or `dart pub upgrade`,
VS Code might also display this prompt if package changes
add issues that `dart fix` can repair.

Save all of your files before running `dart fix`.
This ensures that Dart uses the latest versions of your files.
