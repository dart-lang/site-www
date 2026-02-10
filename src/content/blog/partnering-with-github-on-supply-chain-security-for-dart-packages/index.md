---
title: "Partnering with GitHub on supply chain security for Dart packages"
description: "Starting today, GitHub supports Dart in its Advisory Database, dependency graph, and Dependabot. This means GitHub now offers comprehensive…"
publishDate: 2022-10-06
author: mit-mit
image: images/1MdOSko9W_PJA0KwuQ_mu6w.png
category: other
tags:
  - dart
  - dartlang
  - gi̇thub
  - security
layout: blog
---


Starting today, GitHub supports Dart in its [Advisory Database](https://github.com/advisories), [dependency graph](https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/about-the-dependency-graph), and [Dependabot](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts). This means GitHub now offers comprehensive support for supply chain security for Dart and Flutter apps.

To learn about these new capabilities, check out the [GitHub blog post](https://github.blog/2022-10-06-githubs-supply-chain-security-features-now-support-dart). To learn what this means to you as a Dart developer, keep reading.
> “With Dart now in our supply chain security ecosystem, GitHub extends its support for a fast-growing segment of the open source community,” *Courtney Claessens, Senior Product Manager for GitHub, said.* “And by moving security left, we help not only developers, but the millions of users who rely on apps developed in Dart.”

## Learning about package security issues

Imagine you’re building a fantastic new Flutter app. You’re using lots of really good packages in your `pubspec` (such as something [like this](https://github.com/gskinnerTeam/flutter-wonderous-app/blob/master/pubspec.yaml)) and shipping your app to multiple stores. What would happen if one of them had an important update to fix a security vulnerability? How would you find out about that? You can’t, short of manually checking the`CHANGELOG` for each of the tens of packages on a regular basis. This is a real challenge.

This is where Dependabot comes in. If you manage your source code in GitHub repository, the dependency graph and Dependabot monitor your pubspec dependencies and lets you know if you’re missing an update. The Dependabot submits a pull request to update `pubspec.yaml` to the latest version of the package on your behalf. This all comes about through new Dart-specific improvements in GitHub.

<DashImage src="images/1MdOSko9W_PJA0KwuQ_mu6w.png" alt="Dependabot sending a PR to bump (update) a package dependency to a more recent version." caption="Dependabot sending a PR to bump (update) a package dependency to a more recent version." />


<DashImage src="images/1AVm9C0qX5t-FhYp8lJzU4Q.png" alt="Dependency Graph showing the set of dependencies for a Dart package." caption="Dependency Graph showing the set of dependencies for a Dart package." />


## An advisory database for Dart packages

This scenario relies on a high quality, open database of security advisories that lists known vulnerabilities in Dart packages. For this feature, we partnered with GitHub to add Dart support to their popular [GitHub Advisory Database](https://github.com/advisories). This database already contains thousands of advisories for other ecosystems like npm, NuGet, and Maven.

Starting today, you can now select the **Pub** ecosystem when creating advisories for published Dart packages.

<DashImage src="images/1oPBNmrTaMOB_etyNOp9JJA.png" alt="Creating a new security advisory for a Dart package published on pub.dev" caption="Creating a new security advisory for a Dart package published on pub.dev" />


If you publish packages on [pub.dev](https://pub.dev/), we recommend two new best practices.

1. Use GitHub’s [security advisory](https://docs.github.com/en/code-security/repository-security-advisories/creating-a-repository-security-advisory) feature to create new advisories in your GitHub repo. GitHub ingests these advisories into the central GitHub Advisory database.

1. Configure your [security policy](https://docs.github.com/en/code-security/getting-started/adding-a-security-policy-to-your-repository) including detailing how users can report vulnerabilities.

## Secure your Dart repositories today

The new security features are available today. If your source code resides in a public repository, Dependabot has started monitoring for security issues. If your source lives in a private GitHub repo, you need a bit more [configuration](https://github.blog/2022-10-06-githubs-supply-chain-security-features-now-support-dart) to enable this feature.