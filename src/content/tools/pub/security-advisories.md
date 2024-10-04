---
title: Security advisories
description: >-
  Use security advisories to inform and be informed
  about security vulnerabilities in Dart packages.
---

Security advisories are a means to report information about security
vulnerabilities. Pub uses the [GitHub Advisory Database][]
for publishing security advisories for Dart and Flutter packages. 

To create an advisory in your GitHub repository, use
GitHub's security advisory reporting mechanism as
explained in GitHub's docs on [Creating a repository security advisory][].
First you create a draft security advisory, which will then be reviewed by
GitHub and ingested into the central advisory database.

[GitHub Advisory Database]: https://github.com/advisories
[Creating a repository security advisory]: https://docs.github.com/code-security/security-advisories/working-with-repository-security-advisories/creating-a-repository-security-advisory

## Security advisories in the pub client

The pub client surfaces security advisories at dependency resolution.
For instance, when running `dart pub get` you will get the following output:

```console
$ dart pub get
Resolving dependencies...
http 0.13.0 (affected by advisory: [^0], 1.2.0 available)
Got dependencies!
Dependencies are affected by security advisories:
  [^0]: https://github.com/advisories/GHSA-4rgh-jx4f-qfcq
```

If resolution identifies an advisory, the Dart team recommends you
visit the link and review the advisory.
If you assess that the vulnerability affects your package, you
should strongly consider upgrading to a non-affected version of the dependency.


### Ignoring security advisories

If a security advisory is not relevant for your application,
you can suppress the warning by adding the advisory identifier to
the [`ignored_advisories`][] list in the `pubspec.yaml` of your package.
For example, the following ignores the advisory
with the GHSA identifier `GHSA-4rgh-jx4f-qfcq`:

```yaml
name: myapp
dependencies:
  foo: ^1.0.0
ignored_advisories:
 - GHSA-4rgh-jx4f-qfcq
```

The `ignored_advisories` list only affects the root package. Ignored
advisories in your dependencies will have no effect on package resolution
for your own package.

[`ignored_advisories`]: /tools/pub/pubspec#ignored_advisories