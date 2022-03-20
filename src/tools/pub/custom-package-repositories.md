---
title: Custom package repositories
description: "How Dart's package management tool, pub, works with custom package repositories."
---

The `pub` tool has support for third-party package repositories. A package
repository is an HTTP server from which the `pub` client can fetch packages.
The official package repository is [pub.dev]({{site.pub}}), this repository
is by the `pub` tool by default. A package repository is identified by a
_hosted-url_ (e.g. `https://pub.example.com/my-account/`). 

Third-party package servers can be useful for hosting private packages. It is
also common to use [git-dependencies](/tools/pub/dependencies#git-packages) for hosting
private packages, however, the `pub` does not support resolving versions against
a git-repository it just fetches a specific revision of the git-repository.
Hence, when many people are collaborating it is sometimes preferable to use a
private package repository.

{{site.alert.note}}
  If you host a private repository, also check out the free article on Medium,
  [Hosting a private Dart package repository](https://medium.com/dartlang/hosting-a-private-dart-package-repository-774c3c51dff9).
{{site.alert.end}}

## Authenticating with a custom package repository

Custom package servers are often private and require authentication. The `pub`
tool authenticates against package repositories by attaching a secret token to
the requests. When the `pub` tool does not have a token for a given
_hosted-url_ it will attempt to make requests without authentication.

To specify a secret token for the `pub` tool to use with a given _hosted-url_,
use the `dart pub token add <hosted-url>` command.


## Getting dependencies from a custom package repository

To fetch a package from custom package repository we must specify the
_hosted-url_ for the package in `pubspec.yaml`, using the syntax for
[hosted packages](/tools/pub/dependencies#hosted-packages).

```yaml
dependencies:
  foo:
    hosted: https://pub.example.com
    version: ^1.4.0
```

In the example above `package:foo` will be fetched from
`https://pub.example.com`. If authentication is required by this package
repository, it can be specified using
`dart pub token add https://pub.example.com`, which will prompt for the secret
token.


### Using multiple package repositories

It is possible to fetch different dependencies from different package
repositories, as the _hosted-url_ is specified for each dependency. As
illustrated below.

```yaml
dependencies:
  # package retry is fetched from pub.dev (the default package repository)
  retry: ^3.0.0
  # package foo is fetched from https://pub.example.com
  foo:
    hosted: https://pub.example.com
    version: ^1.4.0
```

This enables you to keep private packages on a private package repository
while staying up-to-date with latest public dependencies. However, conflicts can
easily arise if package `retry` requires `meta` from pub.dev, and `foo` requires
`meta` from `https://pub.example.com`. Thus, if mirroing packages into a private
package repository is it frequently necessary to also mirror all dependencies
and either update the `dependencies` section in section in each package, or
override the default package repository.

{{site.alert.note}}
  To ensure that public packages are usable to everyone, the official package
  repository [pub.dev]({{site.pub}}) does not allow publication of packages
  with git-dependencies or hosted-dependencies with custom package repositories.

  However, such packages can be published to a custom package repository!
{{site.alert.end}}


### Overriding the default package repository

The package repository to be used can be specified on a per-dependency basis,
or the default package repository can be overriden with the
[`PUB_HOSTED_URL`](/tools/pub/environment-variables) environment variable.

This can be useful if you are mirroring all packages in a private package
repository, or working in a restricted network environment using a mirror of
[pub.dev]({{site.pub}}).


## Publishing to a custom package repository

The `pub` tool also supports publishing packages to a private package
repository, using the [`publish_to`](/tools/pub/pubspec#publish_to) property in
`pubspec.yaml`. If working on a private package it is a good idea to specify
this early in the development, so as to prevent accidental publication to
[pub.dev]({{site.pub}}). 

To publish a package to `https://pub.example.com` you would write a
`pubspec.yaml` as follows, and run `dart pub publish`.

```yaml
name: mypkg
version: 1.0.0
# Ensures the package is published to https://pub.example.com
publish_to: https://pub.example.com
```

{{site.alert.note}}
  Even if you don't have a private repository, you can specify
  `publish_to: none` which stops accidental publication.
{{site.alert.end}}


## Getting a custom package repository

The REST API for writing a custom package repository is outlined in the
[Hosted Pub Repository Specification Version 2][repository-spec-v2.md].


### Dart package repositories as a service

Dart package repositories are also offered as a service
by the following vendors:

<ul class="col2">
<li>
  <img src="/assets/img/tools/cloudsmith.svg" width="48" alt="Cloudsmith logo">
  <a href="https://help.cloudsmith.io/docs/dart-repository"><b>Cloudsmith</b></a>
</li>
<li>
  <img src="/assets/img/tools/jfrog.svg" width="48" alt="JFrog logo">
  <a href="https://jfrog.com/blog/how-to-use-pub-repositories-in-artifactory/"><b>JFrog Artifactory</b></a>
</li>
</ul>


[repository-spec-v2.md]: https://github.com/dart-lang/pub/blob/master/doc/repository-spec-v2.md
