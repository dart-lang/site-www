---
title: Package dependencies
description: Add other packages to your app. Specify package locations, version constraints, and more.
---

Dependencies are one of the core concepts of the [pub package manager][].
A _dependency_ is another package that your package needs to work.
Dependencies are specified in your [pubspec](/tools/pub/pubspec).
You list only _immediate dependencies_: the
software that your package uses directly. Pub handles
[transitive dependencies](/tools/pub/glossary#transitive-dependency) for you.

This page has detailed information on how to specify dependencies.
At the end is a list of
[best practices for package dependencies](#best-practices).

## Overview

For each dependency, you specify the _name_ of the package you depend on
and the _range of versions_ of that package that you allow.
You can also specify the [_source_][].
The source tells pub how to locate the package.

[_source_]: /tools/pub/glossary#source

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

* [SDK](#sdk)
* [Hosted packages](#hosted-packages)
* [Git packages](#git-packages)
* [Path packages](#path-packages)

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

{% prettify yaml tag=pre+code %}
environment:
  sdk: '>=[!2.15.0!] < 3.0.0'

dependencies:
  transmogrify:
    [!hosted: https://some-package-server.com!]
    version: ^1.4.0
{% endprettify %}

The version constraint is optional but recommended. If no version constraint is
given, `any` is assumed.

{{site.alert.version-note}}
If your package has a [language version][] before 2.15,
you must use a more verbose `hosted` format:

{% prettify yaml tag=pre+code %}
environment:
  sdk: '>=[!2.14.0!] < 3.0.0'

dependencies:
  transmogrify:
    [!hosted:!]
      [!name: transmogrify!]
      [!url: https://some-package-server.com!]
    version: ^1.4.0
{% endprettify %}
{{site.alert.end}}

[language version]: /guides/language/evolution#language-versioning

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

Even if the package repo is private, if you can
[connect to the repo using SSH,][GitHub SSH]
then you can depend on the package by using the repo's SSH URL:

```yaml
dependencies:
  kittens:
    git: git@github.com:munificent/kittens.git
```

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

### SDK

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
or _caret syntax_. Both syntaxes specify a range of compatible versions.

The traditional syntax provides an explicit range like `'>=1.2.3 <2.0.0'`.
The caret syntax provides an explicit starting version`^1.2.3`

```yaml
environment:
  # This package must use a 2.x version of the Dart SDK starting with 2.14.
  sdk: '>=2.14.0 < 3.0.0'

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

{{site.alert.warning}}
  If you include the greater than (**>**) character in the version constraint,
  **quote the entire constraint string**.
  This prevents YAML from interpreting the character as YAML syntax.
  For example: never use `>=1.2.3 <2.0.0`. Use `'>=1.2.3 <2.0.0'` or `^1.2.3`.
{{site.alert.end}}

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
| <1.0          | Next minor      | `^0.1.2 `    | `'>=0.1.2 <0.2.0' ` |
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
  test: '>=0.5.0 <0.12.0'
```

Pub gets every package that your package depends on, and everything *those*
packages depend on, transitively. It also gets your package's dev dependencies,
but it _ignores_ the dev dependencies of any dependent packages. Pub only gets
*your* package's dev dependencies. So when your package depends on
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

{{site.alert.warning}}
  Using a dependency override involves some risk. For example,
  using an override to specify a version outside the range that the
  package claims to support, or using an override to specify
  a local copy of a package that has unexpected behaviors,
  may break your application.
{{site.alert.end}}

Only the dependency overrides in a **package's own pubspec**
are considered during package resolution. 
Dependency overrides inside any depended-on packages are ignored.

As a result, if you publish a package to pub.dev,
keep in mind that your package's dependency overrides
are ignored by all users of your package.

## Best practices

It's important to actively manage your dependencies and
ensure that your packages use the freshest versions possible.
If any dependency is stale,
then you might have not only a stale version of that package,
but also stale versions of other packages in your dependency graph that
depend on that package.
These stale versions can have a negative impact on
the stability, performance, and quality of apps.

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

### Test whenever you update package dependencies

If you run [`dart pub upgrade`][] without updating your pubspec,
the API should stay the same
and your code should run as before—but test to make sure.
If you modify the pubspec and update to a new major version,
then you might encounter breaking changes,
so you need to test even more thoroughly.

### Verify the integrity of downloaded packages

When retrieving new dependencies, use the [`--enforce-lockfile`][]
option to ensure the extracted package content matches
the contents of the original archive.
Without modifying the [lockfile][],
this flag only resolves new dependencies if:

* `pubspec.yaml` is satisfied
* `pubspec.lock` is not missing
* The packages' [content hashes][] match

[`--enforce-lockfile`]: /tools/pub/cmd/pub-get#--enforce-lockfile
[lockfile]: /tools/pub/glossary#lockfile
[content hashes]: /tools/pub/glossary#content-hashes
---

<aside id="fn:semver" class="footnote" markdown="1">

[1] Pub follows version `2.0.0-rc.1` of the
[semantic versioning specification][]
because that version allows packages to use build identifiers (`+12345`)
to differentiate versions. <a href="#fnref:semver">↩</a>

</aside>

[GitHub SSH]: https://help.github.com/articles/connecting-to-github-with-ssh/
[pub package manager]: /guides/packages
[`dart pub get`]: /tools/pub/cmd/pub-get
[`dart pub outdated`]: /tools/pub/cmd/pub-outdated
[`dart pub upgrade`]: /tools/pub/cmd/pub-upgrade
[pubsite]: {{site.pub}}
[semantic versioning specification]: https://semver.org/spec/v2.0.0-rc.1.html
