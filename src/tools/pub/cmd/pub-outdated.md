---
title: pub outdated
description: Use pub outdated to help you update your package dependencies.
diff2html: true
---

_Outdated_ is one of the commands of the [pub tool](/tools/pub/cmd).

{% prettify nocode tag=pre+code %}
$ pub outdated [options]
{% endprettify %}

Use `pub outdated` to identify out-of-date [package dependencies][]
and get advice on how to update them.
[Best practices for dependency management][best practices]
include using the most recent stable package versions,
so you can get the latest bug fixes and improvements.

{{site.alert.version-note}}
  The `pub outdated` command was introduced in Dart 2.8.
{{site.alert.end}}

## Overview

Here's how you can use `pub outdated` to help you
update the dependencies of a package that you own
(whether it's an app or library package):

1. If your package doesn't have a `pubspec.lock` file
   checked into source control,
   **run `pub get`** in the top directory of the package —
   the directory that contains your package's
  [`pubspec.yaml`](/tools/pub/pubspec) file.
1. **Run `pub outdated`**
   to identify which package dependencies are out-of-date.
   Note the affected packages,
   so that later you can test the behavior of code that uses them.
1. Follow the recommendations of `pub outdated` for updating the packages.
   Some updates might require only running `pub upgrade`.
   Others might require updating `pubspec.yaml` before running `pub upgrade`.
1. **Run `pub outdated`** to confirm that you've updated all the dependencies.
1. **Test** your package to confirm that it still works as expected.

You might still have [transitive dependencies][] that are out-of-date.
If you want to determine the cause,
try running [`pub deps`][] and searching the output for
the name of the out-of-date package.


## Example

Here's an example of running `pub outdated` on
an example that depends on old versions of two packages:
`args` and `pedantic`.
As the following screenshot shows,
`pub outdated` colorizes the output by default
when you run it on the command line.

![screenshot of pub outdated output; visible as text later in "Output columns" section](images/pub-outdated.png)

The preceding output shows that one regular dependency (`args`)
and one [dev dependency][] (`pedantic`) are out-of-date.
For details on what each column shows, see the
[output columns](#output-columns) section of this page.

As a rule, you update the **dependencies** and **dev_dependencies** sections
of your `pubspec.yaml` file
so that each package uses the versions in the **Resolvable** column.
In this example, the resolvable version of `args` is **1.6.0**,
and the resolvable version of `pedantic` is **1.9.0**.

{{site.alert.tip}}
  To see what changed in the new version of a package
  that's published on [pub.dev,]({{site.pub}})
  look at the changelog in the package page.
  For example, you can look at the **Changelog** tabs on the pages for the
  [`args`][] and [`pedantic`][] packages.
{{site.alert.end}}

To fix the first dependency (`args`),
all that's needed is to run `pub upgrade`:

```terminal
$ pub upgrade
Resolving dependencies... 
> args 1.6.0 (was 1.5.0)
  pedantic 1.8.0 (1.9.0 available)
Changed 1 dependency!
```

To fix the second dependency (`pedantic`),
you can change the pubspec's `pedantic` entry to use [caret syntax][] (`^`)
and the number in the **Resolvable** column: **`^1.9.0`**.
Here's the diff for `pubspec.yaml`:

{% comment %}
  [TODO: Improve the formatting of the following diff]
{% endcomment %}

```diff
-  pedantic: 1.8.0
+  pedantic: ^1.9.0
```

{{site.alert.note}}
  Updating the `pedantic` package can cause code to start failing analysis,
  depending on your code and how you include the analysis options file.
  For details, see the section on
  [enabling default Google rules][using pedantic]
  in [Customizing static analysis][].
{{site.alert.end}}

After editing `pubspec.yaml`, run `pub upgrade` to
update the `pubspec.lock` file.
You can then run `pub outdated` to confirm that
you've made all necessary changes.

```terminal
$ pub upgrade
...
$ pub outdated
Found no outdated packages.
```

{{site.alert.important}}
  Test your code to verify that it still works as expected
  after updating the packages.
{{site.alert.end}}


## Output columns

The output of `pub outdated` has four columns of version information
for each out-of-date dependency:

```terminal
$ pub outdated
Dependencies  Current  Upgradable  Resolvable  Latest  
args          1.5.0    1.6.0       1.6.0       1.6.0   

dev_dependencies
pedantic      1.8.0    1.8.0       1.9.0       1.9.0   

transitive dependencies: all up-to-date

transitive dev_dependencies: all up-to-date

1 upgradable dependency is locked (in pubspec.lock) to an older version.
To update it, use `pub upgrade`.

1 dependency is constrained to a version that is older than a resolvable version.
To update it, edit pubspec.yaml.
```

Here are the meanings of each column:

Current
: The version used in your package, as recorded in `pubspec.lock`.
  If the package isn't in `pubspec.lock`,
  the value is `-`.

Upgradable
: The latest version allowed by your `pubspec.yaml` file.
  This is the version that `pub upgrade` resolves to.
  The value is `-` if the value in the **Current** column is `-`.

Resolvable
: The latest version that can be resolved,
  when combined with all other dependencies.
  This version corresponds to what you get if
  you set all version constraints in `pubspec.yaml` to `any`
  and then run `pub upgrade`.
  A value of `-` means that the package won't be needed.

{{site.alert.important}}
  We don't recommend actually using `any` as the constraint,
  because then running `pub upgrade` might surprise you by making
  incompatible version changes.
{{site.alert.end}}

Latest
: The latest version of the package available,
  excluding prereleases unless you use the option `--prereleases`.

For example, say your app depends on the `foo` and `bar` packages,
but the latest version of `bar` depends on an old major version of `foo`.
The result is that the latest _resolvable_ version of `foo`
is different from the _latest_ version of `foo`.


## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

`--json`
: Use this option to generate output in JSON format.

`--[no-]color`
: Use this option to change whether the output uses color for emphasis.
  The default depends on whether you're using this command at a terminal.
  At a terminal, `--color` is the default;
  otherwise, `--no-color` is the default.

`--[no-]up-to-date`
: Use `--up-to-date` to make the output include dependencies that
  are already at the latest version.
  The default is `--no-up-to-date`, which saves space.

`--[no-]prereleases`
: Use `--prereleases` to include prereleases when determining
  the latest package versions.
  By default, prerelease versions aren't considered.

`--[no-]dev-dependencies`
: Use `--no-dev-dependencies` to ignore [dev dependencies][dev dependency].

`--[no-]dependency-overrides`
: Use `--no-dependency-overrides` to ignore package dependencies
  that are specified using [`dependency_overrides`][].

<aside class="alert alert-info" markdown="1">
**Problems?**
See [Troubleshooting Pub](/tools/pub/troubleshoot).
</aside>

[`args`]: {{site.pub-pkg}}/args
[best practices]: /tools/pub/dependencies#best-practices
[caret syntax]: /tools/pub/dependencies#version-constraints
[constraints]: /tools/pub/dependencies#caret-syntax
[Customizing static analysis]: /guides/language/analysis-options
[dev dependency]: /tools/pub/dependencies#dev-dependencies
[`dependency_overrides`]: /tools/pub/dependencies#dependency-overrides
[package dependencies]: /tools/pub/dependencies
[`pedantic`]: {{site.pub-pkg}}/pedantic
[using pedantic]: /guides/language/analysis-options#default-google-rules-pedantic
[`pub deps`]: /tools/pub/cmd/pub-deps
[`pub get`]: /tools/pub/cmd/pub-get
[`pub upgrade`]: /tools/pub/cmd/pub-upgrade
[transitive dependencies]: /tools/pub/glossary#transitive-dependency
