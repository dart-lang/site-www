---
title: Security
---

The Dart team takes the security of Dart and the applications
created with it seriously.
This page describes how to report any vulnerabilities that you find,
and lists best practices to minimize the risk of introducing a vulnerability.

## Reporting vulnerabilities

To report a security issue, use [https://g.co/vulnz][].
Coordination and disclosure happen in the [dart-lang GitHub repos][repos]
(including [GitHub security advisories][]).
The Google Security Team will respond within 5 working days of
your report on g.co/vulnz.

For more information about how Google handles security issues, see
[Google’s security philosophy][].

## Best practices

* **Keep current with the latest Dart SDK releases.**
  We regularly update Dart, and these updates may fix security
  defects discovered in previous versions.
  Check the [Dart changelog][]
  for security-related updates.

* **Keep your application’s dependencies up to date.**
  Make sure you [upgrade your package dependencies][]
  to keep the dependencies up to date.
  Avoid pinning to specific versions
  for your dependencies and, if you do, make sure you check
  periodically to see if your dependencies have had security updates,
  and update the version pin accordingly.

[Dart changelog]: https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md
[GitHub security advisories]: https://docs.github.com/en/code-security/security-advisories
[Google’s security philosophy]: https://www.google.com/about/appsecurity/
[https://g.co/vulnz]: https://g.co/vulnz
[repos]: https://github.com/dart-lang/
[upgrade your package dependencies]: /guides/packages#upgrading-a-dependency
