---
title: Custom package repositories
description: "How Dart's package management tool, pub, works with custom package repositories."
---

The `dart pub` tool has support for third-party package repositories. A package
repository is an HTTP server from which the `pub` client can fetch packages.
The official package repository is [pub.dev]({{site.pub}}), this repository
is by the `dart pub` tool by default. A package repository is identified by a
_hosted-url_ (e.g. `https://dart-packages.example.com/my-account/`). 

Third-party package servers can be useful for hosting private packages. 
It is also common to use [git-dependencies](/tools/pub/dependencies#git-packages) 
for hosting private packages, however, 
the `dart pub` tool doesn't support resolving versions against
a git-repository; it just fetches a specific revision of the git repository.
Hence, when many people are collaborating it is sometimes preferable to use a
private package repository.

{{site.alert.note}}
  If you host a private repository, also check out the free article on Medium,
  [Hosting a private Dart package repository](https://medium.com/dartlang/hosting-a-private-dart-package-repository-774c3c51dff9).
{{site.alert.end}}

## Authenticating with a custom package repository

Most custom package repositories are
private package repositories that require authentication.
To authenticate against custom package repositories,
the `dart pub` tool attaches a secret token to the requests.

You can obtain the secret token from your custom package repository
and either specify it manually or through an environment variable.
To manually specify the secret token,
use the `dart pub token add` command
which prompts for the token:

```terminal
$ dart pub token add https://dart-packages.example.com
Enter secret token: [enter secret token]
Requests to "https://dart-packages.example.com" will now be authenticated using the secret token.
```

You can also tell `dart pub` to read the token from an environment variable,
including in a CI environment, with the `--env-var` flag:

```terminal
$ dart pub token add https://dart-packages.example.com --env-var MY_SECRET_TOKEN
Requests to "https://dart-packages.example.com" will now be authenticated using the secret token stored in the environment variable "MY_SECRET_TOKEN".
```

This ensures that `dart pub` doesn’t actually 
store the secret token in its configuration, 
instead it merely stores the fact that it
should read the secret from the environment variable `$MY_SECRET_TOKEN`. 
This reduces the risk that secrets are accidentally leaked
if the execution environment is shared between CI jobs.

{{site.alert.note}}
  When the `pub` tool does not have a token for a given
  repository URL it will attempt to make requests without authentication.
{{site.alert.end}}


## Getting dependencies from a custom package repository

To fetch a package from custom package repository,
you must specify the _hosted-url_ for the package in `pubspec.yaml`, 
using the syntax for [hosted packages](/tools/pub/dependencies#hosted-packages):

```yaml
dependencies:
  foo:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
```

In the example above `package:foo` 
will be fetched from `https://dart-packages.example.com`. 
If authentication is required by this package repository, 
see [Authenticating with a custom package repository][]
for more information on how to authenticate your requests.

You can also use the `dart pub add` command
with the `--hosted` flag to add a dependency from a custom package repository:

```terminal
$ dart pub add foo --hosted https://dart-packages.example.com
```

[Authenticating with a custom package repository]: #authenticating-with-a-custom-package-repository

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
`meta` from `https://pub.example.com`. Thus, if mirroring packages into a private
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

By default, dart pub get fetches dependencies from the pub.dev site
unless the hosted-dependency syntax 
is used to specify a custom package repository.
However, it’s possible to override the default package repository using the
[`PUB_HOSTED_URL`](/tools/pub/environment-variables) environment variable.

This approach is particularly useful when mirroring
all packages in a private package repository 
or a subset of pub.dev when working in a restricted network environment.


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
  <a href="https://www.jfrog.com/confluence/display/JFROG/Pub+Repositories"><b>JFrog Artifactory</b></a>
</li>
</ul>


[repository-spec-v2.md]: https://github.com/dart-lang/pub/blob/master/doc/repository-spec-v2.md
