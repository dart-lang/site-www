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
   to identify which package dependencies are out of date.
   Note the affected packages,
   so that later you can test the behavior of code that uses them.
1. Follow the recommendations of `pub outdated` for updating the packages.
   Some updates might require only running `pub upgrade`.
   Others might require updating `pubspec.yaml` before running `pub upgrade`.
1. **Run `pub outdated`** to confirm that you've updated all the dependencies.
1. **Test** your package to confirm that it still works as expected.


## Example

Here's an example of running `pub outdated` on
[PENDING: link to source code]:

```terminal
$ pub outdated
Package              Current   Upgradable  Resolvable  Latest    
dependencies: all up-to-date

dev_dependencies    
build_web_compilers  1.2.3     1.2.3       2.10.0      2.10.0    

transitive dependencies
_fe_analyzer_shared  -         -           2.0.0       2.0.0     
analyzer             0.35.4    0.35.4      0.39.5      0.39.5    
...

9  dependencies are constrained to versions that are older than a resolvable version.
To update these dependencies, edit pubspec.yaml.
```

<span style="color:red">[PENDING: Use a different example.
Link to it so it's reproduceable.
Update the text to match.]</span>

The preceding output shows that all regular dependencies are up to date,
but one [dev dependency][] (`build_web_compilers`) is out of date.
Several [transitive dependencies][] are also out of date.
For details on what each column shows, see the
[output columns](#output-columns) section of this page.

To fix the dev dependency,
the easiest solution is to change
the pubspec's `build_web_compilers` entry to use
the version in the **Resolvable** column: `2.10.0`.
Here's the diff for `pubspec.yaml`:

{% comment %}
  [TODO: Improve the formatting of the following diff]
{% endcomment %}

```diff
-  build_web_compilers: ^1.0.0
+  build_web_compilers: ^2.10.0
```

{{site.alert.tip}}
  To see what changed in the new version of a package
  that's published on [pub.dev,]({{site.pub}})
  look at the changelog in the package page.
  For an example, see the
  [build_web_compilers changelog.][]
{{site.alert.end}}

After editing `pubspec.yaml`, run `pub upgrade` to
update the `pubspec.lock` file.
You can then run `pub outdated` to confirm that
you've made all necessary changes.

```terminal
$ pub upgrade
...
$ pub outdated
Package     Current  Upgradable  Resolvable  Latest  
dependencies: all up-to-date

dev_dependencies: all up-to-date

transitive dependencies
googleapis  0.53.0   0.53.0      0.53.0      0.54.0  
$
```

<span style="color:red">[PENDING: file bug about "up-to-date" (shouldn't be hyphenated unless it comes before a noun)]

{{site.alert.important}}
  Test your code to verify that it still works as expected
  after updating the packages.
{{site.alert.end}}

If any transitive dependencies are out of date,
ask the package maintainers to update their code.
To find the cause of an out-of-date dependency,
you can run [`pub deps`][] and
search the output for the name of the out-of-date package.
Then make sure an issue exists for the out-of-date dependency.
You can often find the issue tracker for a package
by looking at the package page on pub.dev.


## Output columns

As a reminder, here's what the output of `pub outdated` looks like:


```terminal
$ pub outdated
Package              Current   Upgradable  Resolvable  Latest    
dependencies: all up-to-date

dev_dependencies    
build_web_compilers  1.2.3     1.2.3       2.10.0      2.10.0    

transitive dependencies
_fe_analyzer_shared  -         -           2.0.0       2.0.0     
analyzer             0.35.4    0.35.4      0.39.5      0.39.5    
...

9  dependencies are constrained to versions that are older than a resolvable version.
To update these dependencies, edit pubspec.yaml.
```

As a rule, update the **dependencies** and **dev_dependencies** sections
of your `pubspec.yaml` file
to depend on the **resolvable** versions of out-of-date packages.

Here are the meanings of the version numbers in the output:

Current
: The version used in your package, as recorded in `pubspec.lock`.
  If the package isn't in `pubspec.lock`,
  the value is `-`.

Upgradable
: The latest version allowed by your `pubspec.yaml` file.
  This is the version that `pub upgrade` resolves to.
  The value is `-` if the value in the **Current** column is `-`.

  <span style="color:red">
    [PENDING: Is the description of `-` correct?
    Is there a more helpful way to state it?]
  </span>

Resolvable
: The latest version that can be resolved.
  This version corresponds to what you get if
  you set all version constraints in `pubspec.yaml` to `any`
  and then run `pub upgrade`.
  A value of `-` means that the package will no longer be needed.

  <span style="color:red">
    [PENDING: Correct?]
  </span>

{{site.alert.important}}
  We don't recommend using `any` as the constraint,
  for performance reasons.
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

[best practices]: /tools/pub/dependencies#best-practices
[build_web_compilers changelog.]: {{site.pub-pkg}}/build_web_compilers#changelog
[constraints]: /tools/pub/dependencies#version-constraints
[dev dependency]: /tools/pub/dependencies#dev-dependencies
[`dependency_overrides`]: /tools/pub/dependencies#dependency-overrides
[package dependencies]: /tools/pub/dependencies
[`pub deps`]: /tools/pub/cmd/pub-deps
[`pub get`]: /tools/pub/cmd/pub-get
[`pub upgrade`]: /tools/pub/cmd/pub-upgrade
[transitive dependencies]: /tools/pub/glossary#transitive-dependency
