---
title: Package dependencies
description: Add other packages to your app. Specify package locations, version constraints, and more.
---

Dependencies are one of the core concepts of the [pub package manager][].
A _dependency_ is another package that your package needs in order to work.
Dependencies are specified in your [pubspec](/tools/pub/pubspec).
You list only _immediate dependencies_ — the
software that your package uses directly. Pub handles
[transitive dependencies](/tools/pub/glossary#transitive-dependency) for you.

This page has detailed information on how to specify dependencies.
At the end is a list of
[best practices for package dependencies](#best-practices).

## Overview

For each dependency, you specify the *name* of the package you depend on
and the *range of versions* of that package that you allow.
You can also specify the
[*source*](/tools/pub/glossary#source),
which tells pub how to locate the package,
and any additional *description* that the source needs to find the package.

Here is an example of specifying a dependency:

{% prettify yaml tag=pre+code %}
dependencies:
  transmogrify: ^1.0.0
{% endprettify %}

This YAML code creates a dependency on the `transmogrify` package
using the default source ([pub.dev]({{site.pub}})) and
allowing any version from `1.0.0` to `2.0.0` (but not including `2.0.0`).
See the [version constraints](#version-constraints)
section of this page for syntax details.

If you want to specify a source, the syntax looks a bit different:

{% prettify yaml tag=pre+code %}
dependencies:
  transmogrify:
    hosted:
      name: transmogrify
      url: http://some-package-server.com
    version: ^1.0.0
{% endprettify %}

This YAML code creates a dependency on the `transmogrify` package
using the `hosted` source.
Everything under the source key (here, just a map with a `url:` key)
is the description that gets passed to the source.
Each source has its own description format,
which is described in the [dependency sources](#dependency-sources) section
of this page.
The version constraint is optional but recommended.

Use this long form when you don't use the default source or when you have a
complex description that you need to specify.
But in most cases, you'll just use the simple
<code><em>packagename</em>: <em>version</em></code> form.

## Dependency sources

Pub can use the following sources to locate packages:

* [SDK](#sdk)
* [Hosted packages](#hosted-packages)
* [Git packages](#git-packages)
* [Path packages](#path-packages)

### SDK

The SDK source is used for any SDKs that are shipped along with packages,
which may themselves be dependencies.
Currently, Flutter is the only SDK that is supported.

The syntax looks like this:

{% prettify yaml tag=pre+code %}
dependencies:
  flutter_driver:
    sdk: flutter
    version: ^0.0.1
{% endprettify %}

The identifier after `sdk:` indicates which SDK the package comes from.
If it's `flutter`, the dependency is satisfiable as long as:

* Pub is running in the context of the `flutter` executable
* The Flutter SDK contains a package with the given name
* That package's version matches the version constraint

If it's an unknown identifier, the dependency is always considered unsatisfied.

A package with an `sdk` dependency
must have a Dart SDK constraint with a minimum version of at least 1.19.0.
This constraint ensures that older versions of pub won't
install packages that have `sdk` dependencies.

### Hosted packages

A *hosted* package is one that can be downloaded from the pub.dev site
(or another HTTP server that speaks the same API). Here's an example
of declaring a dependency on a hosted package:

{% prettify yaml tag=pre+code %}
dependencies:
  transmogrify: ^1.4.0
{% endprettify %}

This example specifies that your package depends on a hosted package named
`transmogrify` and will work with any version from 1.4.0 to 2.0.0
(but not 2.0.0 itself).

If you want to use your own package server, you can use a description that
specifies its URL:

{% prettify yaml tag=pre+code %}
dependencies:
  transmogrify:
    hosted:
      name: transmogrify
      url: http://your-package-server.com
    version: ^1.4.0
{% endprettify %}

### Git packages

Sometimes you live on the bleeding edge and need to use packages that
haven't been formally released yet. Maybe your package itself is still in
development and is using other packages that are being developed at the
same time. To make that easier, you can depend directly on a package
stored in a [Git][] repository.

[git]: https://git-scm.com/

{% prettify yaml tag=pre+code %}
dependencies:
  kittens:
    git: git://github.com/munificent/kittens.git
{% endprettify %}

The `git` here says this package is found using Git, and the URL after that is
the Git URL that can be used to clone the package.

Even if the package repo is private, if you can
[connect to the repo using SSH,][GitHub SSH]
then you can depend on the package by using the repo's SSH URL:

{% prettify yaml tag=pre+code %}
dependencies:
  kittens:
    git: git@github.com:munificent/kittens.git
{% endprettify %}

If you want to depend on a specific commit, branch, or tag,
add a `ref` argument:

{% prettify yaml tag=pre+code %}
dependencies:
  kittens:
    git:
      url: git://github.com/munificent/kittens.git
      ref: some-branch
{% endprettify %}

The ref can be anything that Git allows to [identify a commit.][commit]

[commit]: https://www.kernel.org/pub/software/scm/git/docs/user-manual.html#naming-commits

Pub assumes that the package is in the root of the Git repository.
To specify a different location in the repo, use the `path` argument:

{% prettify yaml tag=pre+code %}
dependencies:
  kittens:
    git:
      url: git://github.com/munificent/cats.git
      path: path/to/kittens
{% endprettify %}

The path is relative to the Git repo's root.

### Path packages

Sometimes you find yourself working on multiple related packages at the same
time. Maybe you are creating a framework while building an app that uses it.
In those cases, during development you really want to depend on the _live_
version of that package on your local file system. That way changes in one
package are instantly picked up by the one that depends on it.

To handle that, pub supports *path dependencies*.

{% prettify yaml tag=pre+code %}
dependencies:
  transmogrify:
    path: /Users/me/transmogrify
{% endprettify %}

This says the root directory for `transmogrify` is `/Users/me/transmogrify`.
For this dependency, pub generates a symlink directly to the `lib` directory
of the referenced package directory. Any changes you make to the dependent
package are seen immediately. You don't need to run pub every time you
change the dependent package.

Relative paths are allowed and are considered relative to the directory
containing your pubspec.

Path dependencies are useful for local development, but do not work when
sharing code with the outside world&mdash;not everyone can get to
your file system. Because of this, you cannot upload a package to the
[pub.dev site][pubsite] if it has any path dependencies in its pubspec.

Instead, the typical workflow is:

1. Edit your pubspec locally to use a path dependency.
2. Work on the main package and the package it depends on.
3. Once they're both working, publish the dependent package.
4. Change your pubspec to point to the now hosted version of its dependent.
5. Publish your main package too, if you want.

## Version constraints

Specifying version constraints lets people
using your package know which versions of its dependencies they can rely on to
be compatible with your library. Your goal is to allow a range of versions as
wide as possible to give your users flexibility. But it should be narrow enough
to exclude versions that you know don't work or haven't been tested.

The Dart community uses semantic versioning<sup id="fnref:semver"><a
href="#fn:semver">1</a></sup>, which helps you know which versions should work.
If you know that your package works fine with `1.2.3` of some dependency, then
semantic versioning tells you that it should work with any subsequent
stable release before `2.0.0`.
For details on pub's version system,
see the [package versioning page](/tools/pub/versioning#semantic-versions).

You can express version constraints using either
_caret syntax_ (`^1.2.3`) or
_traditional syntax_ (`'>=1.2.3 <2.0.0'`).

### Caret syntax

_Caret syntax_ is a compact way of expressing the most common
sort of version constraint.
`^version` means _the range of all versions guaranteed to be backwards
compatible with the specified version_.

For example, `^1.2.3` is equivalent to `'>=1.2.3 <2.0.0'`, and
`^0.1.2` is equivalent to `'>=0.1.2 <0.2.0'`.
The following is an example of caret syntax:

{% prettify yaml tag=pre+code %}
dependencies:
  path: ^1.3.0
  collection: ^1.1.0
  string_scanner: ^0.1.2
{% endprettify %}

Because caret syntax was introduced in Dart 1.8.3,
it requires an [SDK constraint][]
(using [traditional syntax](#traditional-syntax))
to ensure that older versions of pub don't try to process it.
For example:

{% prettify yaml tag=pre+code %}
environment:
  sdk: '>=1.8.3 <3.0.0'
{% endprettify %}

### Traditional syntax

A version constraint that uses _traditional syntax_
is a series of the following:

`any`
: The string `any` allows any version. This is equivalent to an empty
  version constraint, but is more explicit. **Although `any` is allowed,
  we don't recommend it.**

`1.2.3`
: A concrete version number pins the dependency to only allow that
    <em>exact</em> version. Avoid using this when you can because it can cause
    version lock for your users and make it hard for them to use your package
    along with other packages that also depend on it.

`>=1.2.3`
: Allows the given version or any greater one. You'll typically use this.

`>1.2.3`
: Allows any version greater than the specified one but <em>not</em> that
  version itself.

`<=1.2.3`
: Allows any version lower than or equal to the specified one. You
  <em>won't</em> typically use this.

`<1.2.3`
: Allows any version lower than the specified one but <em>not</em> that
  version itself. This is what you'll usually use because it lets you specify
  the upper version that you know does <em>not</em> work with your package
  (because it's the first version to introduce some breaking change).

You can specify version parts as you want, and their ranges are intersected
together. For example, `'>=1.2.3 <2.0.0'` allows any version from `1.2.3` to
`2.0.0` excluding `2.0.0` itself. An easier way to express this range is
by using [caret syntax](#caret-syntax), or `^1.2.3`.

<aside class="alert alert-warning" markdown="1">
If the **`>`** character is in the version constraint,
be sure to **quote the constraint string**,
so the character isn't interpreted as YAML syntax.
For example, never use `>=1.2.3 <2.0.0`;
instead, use `'>=1.2.3 <2.0.0'` or `^1.2.3`.
</aside>

## Dev dependencies

Pub supports two flavors of dependencies: regular dependencies and *dev
dependencies.* Dev dependencies differ from regular dependencies in that *dev
dependencies of packages you depend on are ignored*. Here's an example:

Say the `transmogrify` package uses the `test` package in its tests and only
in its tests. If someone just wants to use `transmogrify`&mdash;import its
libraries&mdash;it doesn't actually need `test`. In this case, it specifies
`test` as a dev dependency. Its pubspec will have something like:

{% prettify yaml tag=pre+code %}
dev_dependencies:
  test: '>=0.5.0 <0.12.0'
{% endprettify %}

Pub gets every package that your package depends on, and everything *those*
packages depend on, transitively. It also gets your package's dev dependencies,
but it *ignores* the dev dependencies of any dependent packages. Pub only gets
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
published library package. Transmogrify is used by other packages in your
dependency graph, but you don't want to clone each package locally
and change each pubspec to test your local copy of transmogrify.

In this situation, you can override the dependency using
`dependency_overrides` to specify the directory holding the local
copy of the package.

The pubspec would look something like the following:

{% prettify yaml tag=pre+code %}
name: my_app
dependencies:
  transmogrify: ^1.2.0
dependency_overrides:
  transmogrify:
    path: ../transmogrify_patch/
{% endprettify %}

When you run [`pub get`][] or [`pub upgrade`][],
the pubspec's lockfile is updated to reflect the
new path to your dependency and, wherever transmogrify is used, pub
uses the local version instead.

You can also use `dependency_overrides` to specify a particular
version of a package:

{% prettify yaml tag=pre+code %}
name: my_app
dependencies:
  transmogrify: ^1.2.0
dependency_overrides:
  transmogrify: '3.2.1'
{% endprettify %}

{{site.alert.warning}}
  Using a dependency override involves some risk. For example,
  using an override to specify a version outside the range that the
  package claims to support, or using an override to specify
  a local copy of a package that has unexpected behaviors,
  may break your application.
{{site.alert.end}}

## Best practices

It’s important to actively manage your dependencies and
ensure that your packages use the freshest versions possible.
If any dependency is stale,
then you might have not only a stale version of that package,
but also stale versions of other packages in your dependency graph that
depend on that package.
These stale versions can have a negative impact on
the stability, performance, and quality of apps.

We recommend the following best practices for package dependencies:

Use [caret syntax](#caret-syntax)
: Specifying dependencies with version ranges is such as `^1.6.3`
  is a good practice because it allows the pub tool to
  select newer versions of the package when they become available.
  Also, it places an upper limit on the allowed version,
  based on an assumption that packages use [semantic versions][],
  where any version of path versioned `1.x` is compatible,
  but where a new version `2.x` would be a major upgrade
  that isn't semantically compatible with `1.x` versions. 

Depend on the latest stable package versions
: Use [`pub upgrade`][] to update to the latest package versions
  that your pubspec allows.
  To identify dependencies in your app or package that
  aren't on the latest stable versions,
  use [`pub outdated`][].

Test whenever you update package dependencies
: If you run [`pub upgrade`][] without updating your pubspec,
  the API should stay the same
  and your code should run as before — but test to make sure.
  If you modify the pubspec and update to a new major version,
  then you might encounter breaking changes,
  so you need to test even more thoroughly.

---

<aside id="fn:semver" class="footnote" markdown="1">

[1] Pub follows version `2.0.0-rc.1` of the
[semantic versioning specification][]
because that version allows packages to use build identifiers (`+12345`)
to differentiate versions. <a href="#fnref:semver">↩</a>

</aside>

[GitHub SSH]: https://help.github.com/articles/connecting-to-github-with-ssh/
[pub package manager]: /guides/packages
[`pub get`]: /tools/pub/cmd/pub-get
[`pub outdated`]: /tools/pub/cmd/pub-outdated
[`pub upgrade`]: /tools/pub/cmd/pub-upgrade
[PubGrub]: https://medium.com/@nex3/pubgrub-2fb6470504f
[pubsite]: {{site.pub}}
[SDK constraint]: /tools/pub/pubspec#sdk-constraints
[semantic versioning specification]: https://semver.org/spec/v2.0.0-rc.1.html
[semantic versions]: /tools/pub/versioning#semantic-versions
[What not to commit]: /guides/libraries/private-files
