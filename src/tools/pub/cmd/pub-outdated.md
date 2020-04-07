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
<span style="color:red">[PENDING: Should we motivate why you want to do this?
Null safety might be the biggest near-term motivation,
but are there other major reasons
that make it worth the effort to update and test your code?]</span>

[package dependencies]: /tools/pub/dependencies

Here's an overview of how you can use `pub outdated`
to help you update package dependencies:

1. In the top directory of your app or package,
   **run `pub upgrade`**
   to create or update the `pubspec.lock` file.
2. **Run `pub outdated`** and inspect its output.
3. If the output reports out-of-date dependencies,
   **update the version dependencies** in `pubspec.yaml` and
   run `pub upgrade`.
4. **Run `pub outdated`** to confirm that you've updated the dependencies.
5. **Test** your app or package to confirm that it still works as expected.


## Example

You run `pub outdated` in the top directory of your package or app,
in the same directory as your package or app's
[`pubspec.yaml`](/tools/pub/pubspec) file.
Here's an example of running `pub outdated`:

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

<span style="color:red">[PENDING: Is there a better example we should use?]</span>

The preceding output shows that all regular dependencies are up to date,
but one [dev dependency][] (`build_web_compilers`) is out of date.
Several [transitive dependencies][] are also out of date.

[dev dependency]: /tools/pub/dependencies#dev-dependencies
[transitive dependencies]: /tools/pub/glossary#transitive-dependency


To fix the dev dependency version,
the easiest solution is to change the `build_web_compilers` entry
in `pubspec.yaml` from `^1.0.0` to `^2.10.0`.
For help on specifying versions, see the
[version constraints documentation][constraints].

[constraints]: /tools/pub/dependencies#version-constraints

<span style="color:red">[PENDING: Improve the formatting of the following diff]</span>

```diff
-  build_web_compilers: ^1.0.0
+  build_web_compilers: ^2.10.0
```

{{site.alert.tip}}
  To see what changed in the new version, you can look at the package's changelog,
  which you can find in the package page on
  [pub.dev.]({{site.pub}})
  For an example, see the
  [build_web_compilers changelog.]({{site.pub-pkg}}/build_web_compilers#-changelog-tab-)
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
the best way to update those for package maintainers
to update their code.
You can find out the cause of the out-of-date dependency
by running [`pub deps`][]
and searching the output for the name of the out-of-date package.
Then make sure an issue exists for the out-of-date dependency;
you can find the issue tracker for a package
by looking at its pub page.
<span style="color:red">
  [PENDING: What exactly do we want to recommend?
  Searching for `googleapis` in the `pub deps` output tells me that
  `sdk_builds 0.2.0-dev` depends on `googleapis 0.53.0.`
  But although https://pub.dev/packages/sdk_builds exists,
  I think it's just referring to the Dart SDK.
  So we can't say everything's a package, can we?]
</span>

[`pub deps`]: /tools/pub/cmd/pub-deps)
[`pub get`]: /tools/pub/cmd/pub-get)
[`pub upgrade`]: /tools/pub/cmd/pub-upgrade)


## Using the output

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
<span style="color:red">
  [PENDING: correct? explain why?]
</span>

Here are the meanings of the version numbers in the output:

Current
: The version used in your package, as recorded in `pubspec.lock`.
  If the package isn't in `pubspec.lock`,
  the value is `-`.
  <span style="color:red">
    [PENDING: I'm curious about why the package isn't in pubspec.lock...
    but maybe it's OK not to talk about that.]
  </span>

Upgradable
: The latest version allowed by your `pubspec.yaml` file.
  This the version that `pub upgrade` resolves to.
  <span style="color:red">
    [PENDING: When is this `-`? If Current is `-`?]
  </span>

Resolvable
: The latest version that can be resolved.
  This version corresponds to what you get if
  you set all version constraints in `pubspec.yaml` to `any`
  and then run `pub upgrade`.
  <span style="color:red">
    [PENDING: why might this be `-`? It seems like it happens
    when the package won't be used any more once you update the
    pubspec.]
  </span>

{{site.alert.warning}}
  We don't recommend using `any` as a version constraint,
  for performance reasons.
{{site.alert.end}}

Latest
: The latest version of the package available,
  excluding prereleases unless you use the option `--prereleases`.
  <span style="color:red">
    [PENDING: This will never be `-`, right?]
  </span>

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
: Use this option to change whether the output has multiple colors.
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
: Use `--no-dev-dependencies` to ignore dev dependencies.

`--[no-]dependency-overrides`
: Use `--no-dependency-overrides` to ignore package dependencies
  that are specified using `dependency_overrides`.

<aside class="alert alert-info" markdown="1">
**Problems?**
See [Troubleshooting Pub](/tools/pub/troubleshoot).
</aside>
