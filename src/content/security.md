---
title: Security
description: >-
  An overview of the Dart team's philosophy and processes for security.
---

The Dart team takes the security of Dart and the applications
created with it seriously.
This page describes how to report any vulnerabilities that you find,
and lists best practices to minimize the risk of introducing a vulnerability.

## Security philosophy

Dart's security strategy is based on five key pillars:

- **Identify**: Track & prioritize key security risks by identifying core assets, 
  key threats and vulnerabilities. 
- **Detect**: Detect and identify vulnerabilities using techniques and tools like
  vulnerability scanning,
  static application security testing and fuzzing.
- **Protect**: Eliminate risks by mitigating known vulnerabilities and protect 
  critical assets against source threats.
- **Respond**: Define processes to report, triage and respond to vulnerabilities 
  or attacks.
- **Recover**: Build capabilities to contain and recover from an incident with 
  minimal impact.

## Reporting vulnerabilities

To report a security issue, use [https://g.co/vulnz][].
Coordination and disclosure happen in the [dart-lang GitHub repos][repos]
(including [GitHub security advisories][]).
Please include a detailed description of the issue,
the steps you took to create the issue, affected versions, and any 
mitigations for the issue.
The Google Security Team will respond within 5 working days of
your report on g.co/vulnz.

For more information about how Google handles security issues, see
[Google's security philosophy][].

##  Flagging existing issues as security-related

If you believe that an existing issue is security-related, 
we ask that you report it via [https://g.co/vulnz][] and include 
the issue id in your report.

## Supported versions

We commit to publishing security updates for the version of Dart currently for 
the most recent [stable][] Dart release.

[stable]: https://dart.dev/get-dart#release-channels

## Expectations

We treat security issues equivalent to a P0 priority level 
and release a beta or patch fix
for any major security issues found
in the most recent stable release of the Dart SDK.
Any vulnerability reported for Dart websites like dart.dev does not 
require a release and will be fixed in the website itself.

Dart does not have a bug bounty program.

## Receiving security updates

Depending on the issue and the fix release, an announcement will be made to
[dart-announce](https://groups.google.com/a/dartlang.org/g/announce) 
mailing list.

## Best practices

* **Keep current with the latest Dart SDK releases.**
  We regularly update Dart, and these updates may fix security
  defects discovered in previous versions.
  Check the [Dart changelog][]
  for security-related updates.

* **Keep your application's dependencies up to date.**
  Make sure you [upgrade your package dependencies][]
  to keep the dependencies up to date.
  Avoid pinning to specific versions
  for your dependencies and, if you do, make sure you check
  periodically to see if your dependencies have had security updates,
  and update the version pin accordingly.

[Dart changelog]: https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md
[GitHub security advisories]: https://docs.github.com/en/code-security/security-advisories
[Google's security philosophy]: https://www.google.com/about/appsecurity/
[https://g.co/vulnz]: https://g.co/vulnz
[repos]: https://github.com/dart-lang/
[upgrade your package dependencies]: /guides/packages#upgrading-a-dependency
