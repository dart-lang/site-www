---
title: Security
---

The Dart team takes the security of Dart and the applications
created with it seriously. This page describes how to report any
vulnerabilities you may find, and lists best practices to minimize
the risk of introducing a vulnerability.

## Reporting vulnerabilities

In the rare event that you find a vulnerability in Dart itself,
email us at
[product-security@google.com](mailto:product-security@google.com).
For more information about how Google handles security issues, see
[Google’s security philosophy.](https://www.google.com/about/appsecurity/)

## Best practices

* **Keep current with the latest Dart SDK releases.**
  We regularly update Dart, and these updates may fix security
  defects discovered in previous versions. Check the Dart
  [change log](https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md)
  for security-related updates.

* **Keep your application’s dependencies up to date.**
  Make sure you [upgrade your package
  dependencies](/guides/packages#upgrading-a-dependency)
  to keep the dependencies up to date. Avoid pinning to specific versions
  for your dependencies and, if you do, make sure you check
  periodically to see if your dependencies have had security updates,
  and update the pin accordingly.
