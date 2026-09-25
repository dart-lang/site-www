---
title: Data-driven fixes
description: >-
  Enable dart fix to migrate code for breaking changes in pub packages.
prevpage:
  url: /tools/pub/publishing
  title: Publishing packages
nextpage:
  url: /tools/pub/writing-package-pages
  title: Writing package pages
---

As a [package](/tools/pub/packages) maintainer,
modifying or deprecating public APIs can break existing code for your users.
To help your users upgrade smoothly,
you can provide _data-driven fixes_.

Data-driven fixes are declarative migration rules
stored directly within your package.
When users update to a newer version of your package,
both [`dart fix`][] and IDE quick-fixes read this metadata
to automatically migrate code to your updated APIs.

## Enable data-driven fixes in your package

To provide automated migrations for your package,
follow these steps.

### 1. Add a fix data file

Add a file named `fix_data.yaml` to your package's `lib/` directory:

<FileTree>

- my_package/
  - lib/
    - fix_data.yaml
    - my_package.dart
  - pubspec.yaml

</FileTree>

If you have many fixes,
you can split them across multiple files in a `lib/fix_data/` directory.

### 2. Define API transforms

In `fix_data.yaml`, specify the format version (`version: 1`)
and a list of `transforms`.
Each transform describes the API element that changed
and the changes to apply.

For example, if you rename `oldMethod()` to `newMethod()` in class `MyClass`:

```yaml title="lib/fix_data.yaml"
version: 1
transforms:
  - title: 'Rename oldMethod to newMethod'
    date: 2026-09-18
    element:
      uris: ['my_package.dart']
      method: 'oldMethod'
      inClass: 'MyClass'
    changes:
      - kind: 'rename'
        newName: 'newMethod'
```

* **`date`:** A `YYYY-MM-DD` date indicating
  when the change was introduced.
* **`uris`:** The library URI relative to `lib/`
  where the API is exported (such as `'my_package.dart'`).

:::tip Best practice: Add fixes upon deprecation
Add transforms to `fix_data.yaml` when you first deprecate an API,
before removing it in a later breaking release.
This allows users to migrate while their code still compiles.
:::

## Test your fixes {:#test-your-fixes}

To ensure your migration rules work as expected,
set up paired test files and golden master files.

### 1. Set up a `test_fixes` directory

Create a `test_fixes/` directory in your package root:

<FileTree>

- my_package/
  - lib/
    - fix_data.yaml
  - test_fixes/
    - my_api.dart
    - my_api.dart.expect
  - pubspec.yaml

</FileTree>

* `my_api.dart`: Code written against the old API.
* `my_api.dart.expect`: The expected code after applying `dart fix`.

For example, pair your test files as follows:

```dart title="test_fixes/my_api.dart"
import 'package:my_package/my_package.dart';

void main() {
  MyClass().oldMethod();
}
```

```dart title="test_fixes/my_api.dart.expect"
import 'package:my_package/my_package.dart';

void main() {
  MyClass().newMethod();
}
```

### 2. Run the tests

From your package root, run `dart fix` with `--compare-to-golden`:

```console
$ dart fix test_fixes --compare-to-golden
```

If the output matches your `.expect` file, the command exits with code `0`.
If there is a difference, it displays a diff and exits with a non-zero code,
making it ideal for CI test suites.

## Learn more

To learn more about all supported change kinds
(such as parameter modifications and replaced declarations),
conditions, and code templates,
see the [Data-driven Fixes specification][spec].

[`dart fix`]: /tools/dart-fix
[spec]: https://github.com/flutter/flutter/blob/master/docs/contributing/Data-driven-Fixes.md
