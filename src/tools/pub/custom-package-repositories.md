---
title: Custom package repositories
description: "How Dart's package management tool, pub, works with custom package repositories."
---

The `dart pub` tool has support for third-party package repositories.
A package repository is a server that hosts Dart packages
for consumption by the `dart pub` tool.
The default package repository used, [pub.dev]({{site.pub}}), 
is operated by the Dart team to 
facilitate publication of Dart packages for public use.
A package repository is identified by a
_hosted-url_, such as `https://dart-packages.example.com/`.

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

## Authenticating with a custom package repository {#token-authentication}

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
  # package foo is fetched from https://dart-packages.example.com
  foo:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
```

This enables you to keep private packages on a private package repository
while staying up-to-date with latest public dependencies. However, conflicts can
easily arise if package `retry` requires `meta` from pub.dev, and `foo` requires
`meta` from `https://dart-packages.example.com`. Thus, if mirroring packages into a private
package repository is it frequently necessary to also mirror all dependencies
and either update the `dependencies` section in section in each package, or
override the default package repository.

{{site.alert.note}}
  To ensure that public packages are usable to everyone, the official package
  repository [pub.dev]({{site.pub}}) does not allow publication of packages
  with git-dependencies or hosted-dependencies with custom package repositories.

  However, such packages can be published to a custom package repository!
{{site.alert.end}}


## Publishing to a custom package repository

To publish a package to a custom package repository
instead of [pub.dev]({{site.pub}}),
you specify the 
[`publish_to`](/tools/pub/pubspec#publish_to) property in `pubspec.yaml`.
If authentication is enabled,
publishing uses the same [token authentication](#token-authentication)
as retrieving packages.

{{site.alert.note}}
  To prevent accidental publication to [pub.dev]({{site.pub}})
  when working on private package 
  it is a good idea to specify this early in the development.
{{site.alert.end}}

To prepare a package for publishing to `https://dart-packages.example.com`,
your `pubspec.yaml` should look minimally like the following:

```yaml
name: mypkg
version: 1.0.0
# Ensures the package is published to https://dart-packages.example.com
publish_to: https://dart-packages.example.com
```

To then publish a new version of the package,
use `dart pub publish`:

```terminal
$ dart pub publish
Publishing mypkg 1.0.0 to https://dart-packages.example.com
|-- CHANGELOG.md
|-- LICENSE
|-- README.md
|-- lib
|   '-- mypkg.dart
'-- pubspec.yaml
...
```

{{site.alert.note}}
  Even if you aren't using a private repository, 
  you can specify `publish_to: none` 
  which stops any accidental publication.
{{site.alert.end}}


### Overriding the default package repository

By default, `dart pub` retrieves dependencies from and publishes packages
to the [pub.dev site]({{site.pub}})
unless the hosted-dependency syntax
is used to specify a custom package repository.
However, it’s possible to override the default package repository using the
[`PUB_HOSTED_URL`](/tools/pub/environment-variables) environment variable.

This approach is particularly useful when mirroring all packages
in a private package repository or a subset of pub.dev
when working in a restricted network environment.


## Setting up a custom package repository

You can write a custom package repository by implementing
the REST API outlined in the
[Hosted Pub Repository Specification Version 2][repository-spec-v2.md].

### Dart package repositories as a service

Custom Dart package repositories are also offered as a service
with support for token authentication by multiple vendors,
alleviating you from the overhead of hosting and maintaining
your own custom package repository:

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
