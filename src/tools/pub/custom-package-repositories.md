---
title: Custom package repositories
description: "How Dart's package management tool, pub, works with custom package repositories."
---

The `dart pub` tool supports third-party package repositories.
A package repository is a server that hosts Dart packages
for consumption by the `dart pub` tool.
The default package repository used, [pub.dev]({{site.pub}}), 
is operated by the Dart team to 
facilitate publication of Dart packages for public use.
A package repository is identified by a
_hosted-url_, such as `https://dart-packages.example.com/`.

Sometimes a custom package repository might be useful
for hosting private packages,
including in some of the following scenarios:

1. Sharing internal proprietary packages within an organization.
2. Tight control of dependencies in enterprise environments.
3. Secure environments without public internet access.

It's also common to use [git-dependencies](/tools/pub/dependencies#git-packages) 
for hosting private packages, however, 
the `dart pub` tool doesn't support resolving versions against a git repository; 
it just fetches a specific revision of the git repository.
Therefore, when many people are collaborating
it's often preferable to use a private package repository.

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

This ensures that `dart pub` doesn't actually 
store the secret token in its configuration, 
instead it merely stores the fact that it
should read the secret from the environment variable `$MY_SECRET_TOKEN`. 
This reduces the risk that secrets are accidentally leaked
if the execution environment is shared between CI jobs.

{{site.alert.note}}
  When the `dart pub` tool doesn't have a token for a given repository URL,
  it attempts to make requests without authentication.
{{site.alert.end}}


## Retrieving dependencies from a custom package repository

To fetch a package from custom package repository,
you must specify the _hosted-url_ for the package in `pubspec.yaml`, 
using the syntax for [hosted packages](/tools/pub/dependencies#hosted-packages).
For example:

```yaml
dependencies:
  example_package:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
```

In the previous example, `package:example_package` 
is fetched from `https://dart-packages.example.com`. 
If authentication is required by this package repository, 
see [Authenticating with a custom package repository](#token-authentication)
for more information on how to authenticate your requests.

You can also use the `dart pub add` command
with the `--hosted` flag to add a dependency from a custom package repository:

```terminal
$ dart pub add example_package --hosted https://dart-packages.example.com
```

### Using multiple package repositories

You can also fetch different dependencies
from different package repositories, 
as the _hosted-url_ can be specified for each dependency:

```yaml
dependencies:
  # package retry is fetched from pub.dev (the default package repository)
  retry: ^3.0.0
  # package example_package is fetched from https://dart-packages.example.com
  example_package:
    hosted: https://dart-packages.example.com
    version: ^1.4.0
```

This enables you to keep private packages on a private package repository
while using the most up-to-date public packages as dependencies. 

However, conflicts can easily arise if your dependencies require
a package with the same name from different repositories.
For example, if package `retry` requires `meta` from pub.dev, 
and `example_package` requires `meta` from `https://dart-packages.example.com`.
Therefore, if mirroring any packages into a private package repository 
it's often necessary to mirror all dependencies
and either update the `dependencies` section of each package, 
or [override the default package repository](#default-override).

{{site.alert.note}}
  To ensure that public packages are usable to everyone, 
  the official package repository, [pub.dev]({{site.pub}}),
  doesn't allow publication of packages
  with git-dependencies or hosted-dependencies from custom package repositories.

  However, such packages can be published to a custom package repository.
{{site.alert.end}}


## Publishing to a custom package repository

To publish a package to a custom package repository
instead of [pub.dev]({{site.pub}}),
specify the 
[`publish_to`](/tools/pub/pubspec#publish_to) property in `pubspec.yaml`.
If authentication is enabled,
publishing uses the same [token authentication](#token-authentication)
as retrieving packages.

{{site.alert.note}}
  To prevent accidental publication to [pub.dev]({{site.pub}})
  when working on a private package, 
  it's a good idea to specify this early in the development.
{{site.alert.end}}

To prepare a package for publishing to `https://dart-packages.example.com`,
your `pubspec.yaml` should look minimally like the following:

```yaml
name: example_package
version: 1.0.0
# Ensures the package is published to https://dart-packages.example.com
publish_to: https://dart-packages.example.com
```

To then publish a new version of the package,
use `dart pub publish`:

```terminal
$ dart pub publish
Publishing example_package 1.0.0 to https://dart-packages.example.com
|-- CHANGELOG.md
|-- LICENSE
|-- README.md
|-- lib
|   '-- example_package.dart
'-- pubspec.yaml
...
```

{{site.alert.note}}
  Even if you aren't using a private repository, 
  you can specify `publish_to: none` 
  which stops any accidental publication.
{{site.alert.end}}


### Overriding the default package repository {#default-override}

By default, `dart pub` retrieves dependencies from and publishes packages
to the [pub.dev site]({{site.pub}})
unless the hosted-dependency syntax
is used to specify a custom package repository.
However, you can override the default package repository using the
[`PUB_HOSTED_URL`](/tools/pub/environment-variables) environment variable.

This approach is particularly useful when mirroring all packages
in a private package repository or a subset of pub.dev
when working in a restricted network environment.


## Setting up a custom package repository

You can write a custom package repository by implementing
the REST API outlined in the
[Hosted Pub Repository Specification Version 2][repository-spec-v2.md].

### Dart package repositories as a service

Custom package repositories are also offered as a service
with support for token authentication by multiple vendors,
alleviating you from the overhead of hosting and maintaining
your own custom package repository:

<ul class="col2">
<li>
  <img src="/assets/img/tools/cloudsmith.svg" width="48" alt="Cloudsmith logo">
  <a href="https://help.cloudsmith.io/docs/dart-repository"><b>Cloudsmith</b></a>
</li>
<li>
  <img src="/assets/img/tools/jetbrains-space.svg" width="48" alt="JetBrains Space logo">
  <a href="https://www.jetbrains.com/help/space/dart-package-repository.html"><b>JetBrains Space</b></a>
</li>
<li>
  <img src="/assets/img/tools/jfrog.svg" width="48" alt="JFrog logo">
  <a href="https://www.jfrog.com/confluence/display/JFROG/Pub+Repositories"><b>JFrog Artifactory</b></a>
</li>
<li>
  <img src="/assets/img/tools/onepub.svg" width="48" alt="OnePub logo">
  <a href="https://onepub.dev"><b>OnePub Dart Repository</b></a>
</li>
</ul>


[repository-spec-v2.md]: https://github.com/dart-lang/pub/blob/master/doc/repository-spec-v2.md
