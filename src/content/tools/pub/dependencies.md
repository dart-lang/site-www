---
title: Package dependencies
breadcrumb: Dependencies
description: >-
  Add other packages to your app.
  Specify package locations, version constraints, and more.
---

Dependencies are one of the core concepts of the [pub package manager][].
A _dependency_ is another package that your package needs to work.
Dependencies are specified in your [pubspec](/tools/pub/pubspec).
You list only _immediate dependencies_: the
software that your package uses directly. Pub handles
[transitive dependencies](/resources/glossary#transitive-dependency) for you.

This page has detailed information on how to specify dependencies.
At the end is a list of
[best practices for package dependencies](#best-practices).

## Overview

For each dependency, you specify the _name_ of the package you depend on
and the _range of versions_ of that package that you allow.
You can also specify the [_source_][].
The source tells pub how to locate the package.

[_source_]: /resources/glossary#dependency-source

As an example, you specify a dependency in the following format:

```yaml
dependencies:
  transmogrify: ^1.0.0
```

This YAML code creates a dependency on the `transmogrify` package
using the default package repository ([pub.dev]({{site.pub}})) and
allowing any version from `1.0.0` to `2.0.0` (but not including `2.0.0`).
To learn about this syntax, check out
[version constraints](#version-constraints).

To specify a source other than pub.dev,
use `sdk`, `hosted`, `git`, or `path`.
For example, the following YAML code uses `path`
to tell pub to get `transmogrify` from a local directory:

```yaml
dependencies:
  transmogrify:
    path: /Users/me/transmogrify
```

The next section describes the format for each dependency source.

## Dependency sources

Pub can use the following sources to locate packages:

* [Hosted packages](#hosted-packages)
* [Git packages](#git-packages)
* [Path packages](#path-packages)
* [SDK](#sdk-packages)

Several [`dart` tool][] commands also support specifying dependency sources
directly on the command line using [package descriptors](#package-descriptors).

[`dart` tool]: /tools/dart-tool

### Hosted packages

A _hosted_ package is one that can be downloaded from the pub.dev site
(or another HTTP server that speaks the same API). Here's an example
of declaring a dependency on a hosted package:

```yaml
dependencies:
  transmogrify: ^1.4.0
```

This example specifies that your package depends on a hosted package named
`transmogrify` and works with any version from 1.4.0 to 2.0.0
(but not 2.0.0 itself).

If you want to use your [own package repository][],
you can use `hosted` to specify its URL.
The following YAML code creates a dependency on the `transmogrify` package
using the `hosted` source:

[own package repository]: /tools/pub/custom-package-repositories

```yaml
environment:
  sdk: '^[!2.19.0!]'

dependencies:
  transmogrify:
    [!hosted: https://some-package-server.com!]
    version: ^1.4.0
```

The version constraint is optional but recommended.
If no version constraint is given, `any` is assumed.

:::version-note
If your package has a [SDK constraints][SDK version] earlier than 2.19,
you must use the lower and upper bound format for SDK versions.
The SDK constraint validator in those versions doesn't support
the caret syntax.

```yaml
environment:
  sdk: [!'>=2.14.0 < 3.0.0'!]
```

If your package has a [SDK version][] earlier than 2.15,
you must use a more verbose `hosted` format.

```yaml
environment:
  sdk: [!'>=2.14.0 < 3.0.0'!]

dependencies:
  transmogrify:
    [!hosted:!]
      [!name: transmogrify!]
      [!url: https://some-package-server.com!]
    version: ^1.4.0
```
:::

[SDK version]: /resources/language/evolution#language-versioning

### Git packages

Sometimes you live on the bleeding edge and need to use packages that
haven't been formally released yet. Maybe your package itself is still in
development and is using other packages that are being developed at the
same time. To make that easier, you can depend directly on a package
stored in a [Git][] repository.

[git]: https://git-scm.com/

```yaml
dependencies:
  kittens:
    git: https://github.com/munificent/kittens.git
```

The `git` here says this package is found using Git, and the URL after that is
the Git URL that can be used to clone the package.

Even if the package repo is private, 
you can configure your `git` setup to access the repo using an
[HTTPS access key][GitHub HTTPS] or an [SSH key-pair][GitHub SSH].
Then you can depend on the package by using the repo's corresponding URL:

```yaml
dependencies:
  kittens:
    # SSH URL:
    git: git@github.com:munificent/kittens.git
```

The `dart pub` command calls `git clone` as a subprocess, so all you need to
provide is a `<url>` that works when `git clone <url>` is executed.

If you want to depend on a specific commit, branch, or tag,
add a `ref` key to the description:

```yaml
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/kittens.git
      ref: some-branch
```

The ref can be anything that Git allows to [identify a commit.][commit]

[commit]: https://www.kernel.org/pub/software/scm/git/docs/user-manual.html#naming-commits

If the package you depend on has tagged the
revision of each version of the package,
you can use `tag_pattern` instead of `ref`,
together with a version constraint.

Pub will then query Git for all matching tags, and
feed those version to the version solver.

```yaml highlightLines=5
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/kittens.git
      tag_pattern: v{% raw %}{{version}}{% endraw %} # Find version-tag prefixed by 'v'.
    version: ^2.0.1
```

:::version-note
Support for `tag_pattern` was introduced in Dart 3.9.

To use `tag_pattern`, the including pubspec (but not the dependency)
must have an SDK version constraint of `^3.9.0` or higher.
:::

Pub assumes that the package is in the root of the Git repository. To specify a
different location in the repo, specify a `path` relative to the repository
root:

```yaml
dependencies:
  kittens:
    git:
      url: git@github.com:munificent/cats.git
      path: path/to/kittens
```

The path is relative to the Git repo's root.

Git dependencies are not allowed as dependencies
for packages uploaded to [pub.dev][pubsite].

### Path packages

Sometimes you find yourself working on multiple related packages at the same
time. Maybe you are creating a framework while building an app that uses it.
In those cases, during development you really want to depend on the _live_
version of that package on your local file system. That way changes in one
package are instantly picked up by the one that depends on it.

To handle that, pub supports _path dependencies_.

```yaml
dependencies:
  transmogrify:
    path: /Users/me/transmogrify
```

This says the root directory for `transmogrify` is `/Users/me/transmogrify`.
For this dependency, pub generates a symlink directly to the `lib` directory
of the referenced package directory. Any changes you make to the dependent
package are seen immediately. You don't need to run pub every time you
change the dependent package.

Relative paths are allowed and are considered relative to the directory
containing your pubspec.

Path dependencies are useful for local development, but do not work when
sharing code with the outside world—not everyone can get to
your file system. Because of this, you cannot upload a package to the
[pub.dev site][pubsite] if it has any path dependencies in its pubspec.

Instead, the typical workflow is:

1. Edit your pubspec locally to use a path dependency.
2. Work on the main package and the package it depends on.
3. Once they're both working, publish the dependent package.
4. Change your pubspec to point to the now hosted version of its dependent.
5. Publish your main package too, if you want.

<a id="sdk" aria-hidden="true"></a>

### SDK packages

The SDK source is used for any SDKs that are shipped along with packages,
which may themselves be dependencies.
Currently, Flutter is the only SDK that is supported.

The syntax looks like this:

```yaml
dependencies:
  flutter_driver:
    sdk: flutter
```

The identifier after `sdk:` indicates which SDK the package comes from.
If it's `flutter`, the dependency is satisfiable as long as:

* Pub is running in the context of the `flutter` executable
* The Flutter SDK contains a package with the given name

If it's an unknown identifier, the dependency is always considered unsatisfied.

<a id="source-descriptors" aria-hidden="true"></a>

## Package descriptors

Several [`dart` tool][dart-tool] commands, such as
[`dart pub add`][pub-add] and [`dart pub unpack`][pub-unpack],
accept a _package descriptor_ after the package name
to specify the version or dependency source of a package.

The simplest form of a package descriptor is
a [version constraint](#version-constraints),
assuming the default source of the [pub.dev site][pubsite].
For example, the following command uses a descriptor of `^1.2.3`
to [add a dependency][pub-add] on `package:foo` with a constraint of `^1.2.3`.

```console
dart pub add foo:^1.2.3
```

To specify a custom [dependency source](#dependency-sources),
use the same structure as in `pubspec.yaml`,
but using [flow-style YAML][flow-style]:

```plaintext
{<source>: <descriptor>, [version: <constraint>]}
```

The following subsections show the package descriptor syntax
for each type of pub [dependency source](#dependency-sources).

[dart-tool]: /tools/dart-tool
[pub-add]: /tools/pub/cmd/pub-add
[pub-unpack]: /tools/pub/cmd/pub-unpack
[flow-style]: https://yaml.org/spec/1.2.2/#chapter-7-flow-style-productions

### Hosted dependency descriptor

To specify a [hosted package](#hosted-packages):

```plaintext
{hosted: my-pub.dev}
```

You can also specify a [version constraint](#version-constraints):

```plaintext
{hosted: my-pub.dev, version: ^1.2.3}
```

### Git dependency descriptor

To specify a [git package](#git-packages):

```plaintext
{git: https://github.com/foo/foo}
```

You can specify the repository URL, a branch or commit reference,
and the path to the package within the repository:

```plaintext
{git: {url: ../foo.git, ref: branch, path: subdir}}
```

### Path package descriptor

To specify a [path package](#path-packages):

```plaintext
{path: ../foo}
```

### SDK package descriptor

To specify an [SDK package](#sdk-packages):

```plaintext
{sdk: flutter}
```

## Version constraints

Let's say that your Package A depends upon Package B.
How can you communicate to other developers which version of Package B
remains compatible with a given version of Package A?

To let developers know version compatibility, specify version constraints.
You want to allow the widest range of versions possible
to give your package users flexibility.
The range should exclude versions that don't work or haven't been tested.

The Dart community uses semantic versioning<sup id="fnref:semver"><a
href="#fn:semver">1</a></sup>.

You can express version constraints using either _traditional syntax_
or _caret syntax_ starting with Dart 2.19.
Both syntaxes specify a range of compatible versions.

The traditional syntax provides an explicit range like `'>=1.2.3 <2.0.0'`.
The caret syntax provides an explicit starting version `^1.2.3`

```yaml
environment:
  # This package must use a 3.x version of the Dart SDK starting with 3.2.
  sdk: ^3.2.0

dependencies:
  transmogrify:
    hosted:
      name: transmogrify
      url: https://some-package-server.com
    # This package must use a 1.x version of transmogrify starting with 1.4.
    version: ^1.4.0
```

To learn more about pub's version system, see the [package versioning page][].

[package versioning page]: /tools/pub/versioning#semantic-versions

### Traditional syntax

A version constraint that uses the traditional syntax can use any
of the following values:

| **Value** |                **Allows**               | **Use?** |                                                                        **Notes**                                                                        |
|:---------:|:----------------------------------------|:--------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
|   `any`   | All versions                            |    No    | Serves as a explicit declaration of empty version constraint.                                                                                           |
|  `1.2.3`  | Only the given version                  |    No    | Limits adoption of your package due the additional limits it places on apps that use your package.                                                      |
| `>=1.2.3` | Given version or later                  |    Yes   |                                                                                                                                                         |
|  `>1.2.3` | Versions later than the given version   |    No    |                                                                                                                                                         |
| `<=1.2.3` | Given version or earlier                |    No    |                                                                                                                                                         |
|  `<1.2.3` | Versions earlier than the given version |    No    | Use this when you know an upper bound version that _doesn't_ work with your package. This version might be the first to introduce some breaking change. |

{:.table}

You can specify any combination of version values as their ranges intersect.
For example, if you set the version value as `'>=1.2.3 <2.0.0'`,
this combines the both limitations so the dependency can be any version
from `1.2.3` to `2.0.0` excluding `2.0.0` itself.

:::warning
If you include the greater than (**>**) character in the version constraint,
**quote the entire constraint string**.
This prevents YAML from interpreting the character as YAML syntax.
For example: never use `>=1.2.3 <2.0.0`. Use `'>=1.2.3 <2.0.0'` or `^1.2.3`.
:::

### Caret syntax

Caret syntax expresses the version constraint in a compact way.
`^version` means _the range of all versions guaranteed to be backwards
compatible with the given version_.
This range would include all versions up to the next one to introduce a
breaking change. As Dart uses semantic versioning, this would be the next
major version for any package version 1.0 or later
or the next minor version for any package version earlier than 1.0.

| Version value | Range covers to | Caret Syntax | Traditional Syntax  |
|:-------------:|:---------------:|:------------:|:-------------------:|
| >=1.0         | Next major      | `^1.3.0`     | `'>=1.3.0 <2.0.0'`  |
| <1.0          | Next minor      | `^0.1.2`     | `'>=0.1.2 <0.2.0'`  |

{:.table}

The following example shows caret syntax:

```yaml
dependencies:
  # Covers all versions from 1.3.0 to 1.y.z, not including 2.0.0
  path: ^1.3.0
  # Covers all versions from 1.1.0 to 1.y.z, not including 2.0.0
  collection: ^1.1.0
  # Covers all versions from 0.1.2 to 0.1.z, not including 0.2.0
  string_scanner: ^0.1.2
```

## Dev dependencies

Pub supports two flavors of dependencies: regular dependencies and _dev
dependencies._ Dev dependencies differ from regular dependencies in that _dev
dependencies of packages you depend on are ignored_. Here's an example:

Say the `transmogrify` package uses the `test` package in its tests and only
in its tests. If someone just wants to use `transmogrify`—import its
libraries—it doesn't actually need `test`. In this case, it specifies
`test` as a dev dependency. Its pubspec will have something like:

```yaml
dev_dependencies:
  test: ^1.25.0
```

Pub gets every package that your package depends on, and everything _those_
packages depend on, transitively. It also gets your package's dev dependencies,
but it _ignores_ the dev dependencies of any dependent packages. Pub only gets
_your_ package's dev dependencies. So when your package depends on
`transmogrify` it will get `transmogrify` but not `test`.

The rule for deciding between a regular or dev dependency is simple: If
the dependency is imported from something in your `lib` or `bin` directories,
it needs to be a regular dependency. If it's only imported from `test`,
`example`, etc. it can and should be a dev dependency.

Using dev dependencies makes dependency graphs smaller. That makes `pub` run
faster, and makes it easier to find a set of package versions that satisfies all
constraints.

## Dependency overrides

You can use `dependency_overrides` to temporarily override all references
to a dependency.

For example, perhaps you are updating a local copy of transmogrify, a
published package. Transmogrify is used by other packages in your
dependency graph, but you don't want to clone each package locally
and change each pubspec to test your local copy of transmogrify.

In this situation, you can override the dependency using
`dependency_overrides` to specify the directory holding the local
copy of the package.

The pubspec would look something like the following:

```yaml
name: my_app
dependencies:
  transmogrify: ^1.2.0
dependency_overrides:
  transmogrify:
    path: ../transmogrify_patch/
```

When you run [`dart pub get`][] or [`dart pub upgrade`][],
the pubspec's lockfile is updated to reflect the
new path to your dependency and, wherever transmogrify is used, pub
uses the local version instead.

You can also use `dependency_overrides` to specify a particular
version of a package:

```yaml
name: my_app
dependencies:
  transmogrify: ^1.2.0
dependency_overrides:
  transmogrify: '3.2.1'
```

:::warning
Using a dependency override involves some risk. For example,
using an override to specify a version outside the range that the
package claims to support, or using an override to specify
a local copy of a package that has unexpected behaviors,
may break your application.
:::

Only the dependency overrides in a **package's own pubspec**
are considered during package resolution. 
Dependency overrides inside any depended-on packages are ignored.

As a result, if you publish a package to pub.dev,
keep in mind that your package's dependency overrides
are ignored by all users of your package.

If you are using a [pub workspace][workspaces],
you can have `dependency_overrides` in each workspace package, but
a single package can only be overridden once in the workspace.

## `pubspec_overrides.yaml` {:#pubspec-overrides}

If you want to change certain aspects of
the resolution of your `pubspec.yaml` file, but
do not want to change the actual file, you can
place a file named `pubspec_overrides.yaml` next to the `pubspec.yaml`.

Attributes from that file will override those from `pubspec.yaml`.

The properties that can be overridden are:

* `dependency_overrides`
* `workspace`
* `resolution`

This can be useful to avoid accidentally
checking temporary overrides in to version control.
It can also make it easier to generate overrides from a script.

In a [pub workspace][workspaces], each workspace package
can have a `pubspec_overrides.yaml` file.

## Best practices

Be proactive in managing your dependencies.
Ensure that your packages depend on the freshest versions of packages
when possible.
If your package depends on a stale package,
that stale package may depend on other stale packages in its dependency tree.
Stale versions of packages can have a negative impact on
the stability, performance, and quality of your app.

We recommend the following best practices for package dependencies.

### Use caret syntax

Specify dependencies using the [caret syntax](#caret-syntax).
This allows the pub tool to select newer versions of the package
when they become available.
Further, it places an upper bound on the allowed version.

### Depend on the latest stable package versions

Use [`dart pub upgrade`][] to update to the latest package versions
that your pubspec allows.
To identify dependencies in your app or package that
aren't on the latest stable versions,
use [`dart pub outdated`][].

### Tighten version constraints for dev dependencies

A dev dependency defines a package that you need only when developing.
A finished app won't need these packages.
Examples of these packages include tests or code generation tooling.
Set the version constraints of packages in [`dev_dependencies`][dev-dep]
to have a lower bound of the latest version on which your package depends.

Tightening the version constraints of your dev dependencies might
resemble the following:

```yaml
dev_dependencies:
  build_runner: ^2.10.4
  lints: ^6.0.0
  test: ^1.26.3
```

This YAML sets the `dev_dependencies` to the latest patch versions.

[dev-dep]: /tools/pub/dependencies#dev-dependencies

### Test whenever you update package dependencies

If you run [`dart pub upgrade`][] without updating your pubspec,
the API should stay the same
and your code should run as before—but test to make sure.
If you modify the pubspec and update to a new major version,
then you might encounter breaking changes,
so you need to test even more thoroughly.

### Test with downgraded dependencies

When developing packages for publication, it is often preferable to
allow the widest dependency constraints possible.
A wide dependency constraint reduces the likelihood that
package consumers face a version resolution conflict.

For example, if you have a dependency on `foo: ^1.2.3` and
version `1.3.0` of `foo` is released, it might be reasonable to
keep the existing dependency constraint (`^1.2.3`).
But if your package starts using features that were added in `1.3.0`, then
you'll need to bump your constraint to `^1.3.0`.

However, it's easy to forget to bump a
dependency constraint when it becomes necessary.
Therefore, it's a best practice to test your package
against downgraded dependencies before publishing.

To test against downgraded dependencies, run [`dart pub downgrade`][] and
verify your package still analyzes without errors and passes all tests:

```console
dart pub downgrade
dart analyze
dart test
```

Testing with downgraded dependencies should
happen alongside normal tests with latest dependencies.
If dependency constraints need to be bumped, change them yourself or
use `dart pub upgrade --tighten` to update dependencies to the latest versions.

:::note
Testing with `dart pub downgrade` enables you to find incompatibilities that
you might not otherwise have discovered.
But it doesn't exclude the possibility of incompatibilities.

There are often so many different combinations of versions that
testing them all is infeasible.
There might also be older versions allowed by your dependency constraints that
can't be resolved due to mutually incompatible version constraints from
packages themselves or from your `dev_dependencies`.
:::

[`dart pub downgrade`]: /tools/pub/cmd/pub-downgrade

### Verify the integrity of downloaded packages

When retrieving new dependencies,
use the [`--enforce-lockfile`][enforce-lock] option to ensure
the extracted package contents match the contents of the original archive.
Without modifying the [lockfile][],
this flag only resolves new dependencies if:

* `pubspec.yaml` is satisfied
* `pubspec.lock` is not missing
* The packages' [content hashes][] match

[enforce-lock]: /tools/pub/cmd/pub-get#enforce-lockfile
[lockfile]: /resources/glossary#lockfile
[content hashes]: /resources/glossary#pub-content-hash

---

<aside id="fn:semver" class="footnote">

[1] Pub follows version `2.0.0-rc.1` of the
[semantic versioning specification][]
because that version allows packages to use build identifiers (`+12345`)
to differentiate versions. <a href="#fnref:semver">↩</a>

</aside>

[GitHub HTTPS]: https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git
[GitHub SSH]: https://help.github.com/articles/connecting-to-github-with-ssh/
[pub package manager]: /tools/pub/packages
[`dart pub get`]: /tools/pub/cmd/pub-get
[`dart pub outdated`]: /tools/pub/cmd/pub-outdated
[`dart pub upgrade`]: /tools/pub/cmd/pub-upgrade
[pubsite]: {{site.pub}}
[semantic versioning specification]: https://semver.org/spec/v2.0.0-rc.1.html
[workspaces]: /tools/pub/workspaces
