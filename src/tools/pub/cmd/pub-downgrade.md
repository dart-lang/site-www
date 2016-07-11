---
layout: default
permalink: /tools/pub/cmd/pub-downgrade
title: "pub downgrade"
description: "Use pub downgrade to get the lowest versions of all dependencies used by your Dart application."
toc: false
---

_Downgrade_ is one of the commands of the _pub_ tool.
[Learn more about pub](/tools/pub/).

{% prettify sh %}
$ pub downgrade [dependencies...]
{% endprettify %}

Without any additional arguments, `pub downgrade` gets the lowest versions of
all the dependencies listed in the [`pubspec.yaml`](/tools/pub/pubspec.html)
file in the current working directory, as well as their [transitive
dependencies]({{site.dartlang}}/tools/pub/glossary#transitive-dependency), to the `packages`
directory located next to the pubspec. For example:

{% prettify sh %}
$ pub downgrade
Resolving dependencies... (1.2s)
+ barback 0.13.0
+ collection 0.9.1
+ path 1.2.0
+ source_maps 0.9.0
+ source_span 1.0.0
+ stack_trace 0.9.1
Changed 6 dependencies!
{% endprettify %}

The `pub downgrade` command creates a lockfile. If one already exists,
it ignores it and generates a new one from scratch using the lowest
versions of all dependencies.

## Downgrading specific dependencies

It's possible to tell `pub downgrade` to downgrade specific dependencies to the
lowest version while leaving the rest of the dependencies alone as much as
possible. For example:

{% prettify sh %}
$ pub downgrade test
Resolving dependencies...
  barback 0.15.2+2
  bot 0.27.0+2
  browser 0.10.0+2
  chrome 0.6.5
  collection 1.1.0
  path 1.3.0
  pool 1.0.1
  source_span 1.0.2
< stack_trace 0.9.2 (was 1.1.1)
  stagexl 0.10.2
< test 0.10.0 (was 0.11.4)
These packages are no longer being depended on:
- matcher 0.11.3
Changed 3 dependencies!
{% endprettify %}

If you are downgrading a specific dependency, pub tries to find the
highest versions of any transitive dependencies that fit the new dependency
constraints. Any transitive dependencies are usually also downgraded
as a result.

## Getting a new dependency

If a dependency is added to the pubspec before `pub downgrade` is run, it gets
the new dependency and any of its transitive dependencies and places them in
the `packages` directory. This is the same behavior as `pub get`.

## Removing a dependency

If a dependency is removed from the pubspec before `pub downgrade` is run, it
removes the dependency from the `packages` directory, thus making it
unavailable for importing. Any transitive dependencies of the removed dependency
are also removed, as long as no remaining immediate dependencies also depend
on them. This is the same behavior as `pub get`.

## Downgrading while offline

If you don't have network access, you can still run `pub downgrade`. Since pub
downloads packages to a central cache shared by all packages on your system, it
can often find previously-downloaded packages there without needing to hit the
network.

However, by default, pub always tries to go online when you downgrade if you
have any hosted dependencies so that it can see if newer versions of them are
available. If you don't want it to do that, pass the `--offline` flag when
running pub. In this mode, it only looks in your local package cache and
tries to find a set of versions that work with your package from what's already
available.

## Options {#options}

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd/#global-options).

<aside class="alert alert-info" markdown="1">
*Problems?*
See [Troubleshooting Pub](../troubleshoot.html).
</aside>
