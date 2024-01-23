---
title: Security advisories
description: Use security advisories to inform and be informed about security vulnerabilities.
---

Security advisories are a means to report information about security
vulnerabilities. Pub uses the [Github Advisory
Database][https://github.com/advisories] for publishing security advisories for
Dart and Flutter packages. 

To create an advisory in your Github repo use Github's security advisory
reporting mechanism as explained
[here][https://docs.github.com/en/code-security/security-advisories/working-with-repository-security-advisories/creating-a-repository-security-advisory].
First you create a draft security advisory, which will then be reviewed by
Github and ingested into the central database.


## Security advisories in the pub client
The pub client surfaces security advisories at dependency resolution. For
instance when running `dart pub get` you will get the following output:

```terminal
$ dart pub get
Resolving dependencies...
http 0.13.0 (affected by advisory: [^0], 1.2.0 available)
Got dependencies!
Dependencies are affected by security advisories:
  [^0]: https://github.com/advisories/GHSA-4rgh-jx4f-qfcq
```

In such a case we recommend you follow the link and review the advisory. After
reviewing, if you asses that this vulnerability is affecting your package, you
should strongly consider upgrading to another version of your dependency.


### Ignoring security advisories
If a security advisory is not relevant for your package, you can suppress the
warning by adding the advisory to the list of `ignored_advisories` in the
`pubspec.yaml` of your package. For example:

```
name: myapp
dependencies:
  foo: ^1.0.0
ignored_advisories:
 - GHSA-4rgh-jx4f-qfcq
```

The list of `ignored_advisories` only affects the root package. I.e, ignored
advisories in your dependencies will have no effect on your resolution.
