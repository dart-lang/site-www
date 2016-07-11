---
layout: default
permalink: /tools/pub/cmd/pub-upgrade
title: "pub upgrade"
description: "Use pub upgrade to get the latest versions of all dependencies used by your Dart application."
toc: false
---

_Upgrade_ is one of the commands of the _pub_ tool.
[Learn more about pub](/tools/pub/).

{% prettify sh %}
$ pub upgrade [dependencies...]
{% endprettify %}

Without any additional arguments, `pub upgrade` gets the latest versions of
all the dependencies listed in the [`pubspec.yaml`](/tools/pub/pubspec.html) file in the
current working directory, as well as their [transitive
dependencies]({{site.dartlang}}/tools/pub/glossary#transitive-dependency),
to the `packages` directory located next to the pubspec. For example:

{% prettify sh %}
$ pub upgrade
Dependencies upgraded!
{% endprettify %}

When `pub upgrade` upgrades dependency versions, it writes a
[lockfile]({{site.dartlang}}/tools/pub/glossary#lockfile)
to ensure that future [`pub get`s](pub-get.html)
will use the same versions of those dependencies.
Application packages should check in the lockfile to source control; this
ensures the application will use the exact same versions of all dependencies for
all developers and when deployed to production. Library packages should not
check in the lockfile, though, since they're expected to work with a range of
dependency versions.

If a lockfile already exists, `pub upgrade` ignores it and generates a new
one from scratch using the latest versions of all dependencies. This is the
primary difference between `pub upgrade` and `pub get`, which always tries to
get the dependency versions specified in the existing lockfile.

<aside class="alert alert-info" markdown="1">
**Note:** In earlier releases of Dart, _pub upgrade_ was called _pub update_.
</aside>

## Upgrading specific dependencies

It's possible to tell `pub upgrade` to upgrade specific dependencies to the
latest version while leaving the rest of the dependencies alone as much as
possible. For example:

    $ pub upgrade test args
    Dependencies upgraded!

Upgrading a dependency upgrades its transitive dependencies to their latest
versions as well. Usually, no other dependencies are updated; they stay at the
versions that are locked in the lockfile. However, if the requested upgrades
cause incompatibilities with these locked versions, they are selectively
unlocked until a compatible set of versions is found.

## Getting a new dependency

If a dependency is added to the pubspec before `pub upgrade` is run, it gets
the new dependency and any of its transitive dependencies and places them in
the `packages` directory. This is the same behavior as `pub get`.

## Removing a dependency

If a dependency is removed from the pubspec before `pub upgrade` is run, it
removes the dependency from the `packages` directory, thus making it
unavailable for importing. Any transitive dependencies of the removed dependency
are also removed, as long as no remaining immediate dependencies also depend
on them. This is the same behavior as `pub get`.

## Upgrading while offline

If you don't have network access, you can still run `pub upgrade`. Since pub
downloads packages to a central cache shared by all packages on your system, it
can often find previously-downloaded packages there without needing to hit the
network.

However, by default, pub always tries to go online when you upgrade if you
have any hosted dependencies so that it can see if newer versions of them are
available. If you don't want it to do that, pass the `--offline` flag when
running pub. In this mode, it only looks in your local package cache and
tries to find a set of versions that work with your package from what's already
available.

Keep in mind that pub *will* generate a lockfile after it does this. If the
only version of some dependency in your cache happens to be old, this locks
your app to that version. The next time you are online, you will likely want to
run `pub upgrade` again to upgrade to a later version.

## Options {#options}

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd/#global-options).

<aside class="alert alert-info" markdown="1">
*Problems?*
See [Troubleshooting Pub](../troubleshoot.html).
</aside>
