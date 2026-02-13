---
title: "Announcing verified publishers on pub.dev"
description: "Today we’re announcing a new ‘verified publishers’ feature on pub.dev,  the Dart package repository"
publishDate: 2019-10-10
author: "mit-mit"
image: images/0DfmB09PD2DK-pvTz.png
category: announcements
tags:
  - dart
  - flutter
  - package-management
  - announcements
---


Today we’re announcing a new feature on [pub.dev](https://pub.dev) (the Dart package repository): *verified publishers*. When you *use* a package that has a verified publisher, you can be sure that the publisher is who they claim to be. When you *publish* packages as a verified publisher, you get the bonus of easier package administration.

<DashImage src="images/0DfmB09PD2DK-pvTz.png" />


## Increasing trust for package consumers

App developers building apps with [Flutter](https://flutter.dev) tell us that having a rich selection of high-quality packages is critical to their productivity, allowing them to reuse common components and access popular SDKs and libraries. We’re seeing an immense amount of growth in the [pub.dev](https://pub.dev/) ecosystem, with thousands of packages published over the past year, and hundreds of thousands of developers using pub.dev every month to browse and search for new package content.

One of the most important selection criteria we hear from package users is *who published the package.* Verified publishers strengthen this signal by verifying the identity of the publisher, and by clearly listing the publisher identity in package search results and on package detail pages (note the blue badge next to dart.dev in the screenshots below).

<DashImage src="images/0LQMWHLFUi6F7nPO1.png" alt="*Package search result showing a package that was published by a verified publisher*" caption="*Package search result showing a package that was published by a verified publisher*" />


<DashImage src="images/0GJcMpmN8bNi6H5_g.png" alt="*Package detail page showing a package that was published by a verified publisher*" caption="*Package detail page showing a package that was published by a verified publisher*" />


When you click the publisher, you can see a few more details, including a contact email for the publisher, a link to the publisher homepage, and a short description of the publisher. The publisher description is provided by the publisher, offering a small branding opportunity.

You can also view a list of all packages published by the publisher. Below is an example from the new [dart.dev publisher](https://pub.dev/publishers/dart.dev/packages).

<DashImage src="images/0Q24NUEox8eA10hVB.png" alt="*Sample package list for a publisher*" caption="*Sample package list for a publisher*" />


### Publisher verification process

When we designed the verification process, we wanted a mechanism that was trustworthy, low cost, and available to anyone interested in being a verified publisher. We also preferred a process that was automated, so accounts could be created without delays.

After reviewing several alternatives, we decided to base the verification on DNS (domain name system) second-level domains. We chose DNS because we believe that most package publishers already have a domain and a homepage at that domain. During the [publisher creation process](https://dart.dev/tools/pub/publishing#create-verified-publisher), pub.dev verifies that the user creating the verified publisher has admin access to the associated domain, based on existing logic in the [Google Search Console](https://search.google.com/search-console/about).

### Improved package administration

Besides the clear benefits of verifying the publisher identity, the verified publishers feature also offers administrative benefits. Previously, if you published many packages, access management was a tedious, package-by-package job that took away time you could be spending on improving your packages. With verified publishers, you can configure a single team of admins for your publisher account, where all team members have the ability to publish updates to all packages owned by the publisher.

We’ve also added a few new self-administration options, including the ability to move an existing package to a publisher account (see below), or to mark a package as [discontinued](https://dart.dev/tools/pub/publishing#discontinue).

### Transfer existing packages

It’s easy to transfer existing packages to a verified publisher. Just [create a verified publisher](https://dart.dev/tools/pub/publishing#create-verified-publisher), and use the [transfer function](https://dart.dev/tools/pub/publishing#transferring-a-package-to-a-verified-publisher) on your existing packages. This simple process takes just a few minutes per package.

### Pub.dev roadmap

We’re discussing lots of future improvements to pub.dev. Here are some of the ideas:

* Search support for packages that support a particular platform (for example, Android or web; [#187](https://github.com/dart-lang/pub-dev/issues/187)), incl. better understanding of Dart web vs Flutter web packages

* Tags or categories for packages ([#367](https://github.com/dart-lang/pub-dev/issues/367))

* Voting on or liking high-quality packages ([#798](https://github.com/dart-lang/pub-dev/issues/798))

* Clear policy and process for reporting questionable content ([#1570](https://github.com/dart-lang/pub-dev/issues/1570))

If you’re interested in a particular idea, we encourage you to check the [pub.dev issue tracker](https://github.com/dart-lang/pub-dev/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc) to make sure the idea is already tracked, and to indicate your interest by adding a *thumbs up* reaction to the topmost comment of the issue.

### Next steps

If you’re a package publisher, we encourage you to get your packages transferred to a verified publisher account as soon as possible, to get the benefits listed above for both yourself and the users of your packages. We’ve already transferred many of the most popular [dart.dev packages](https://pub.dev/publishers/dart.dev/packages), and expect more to be transferred shortly.

That’s all for now. We look forward to seeing even more high-quality packages on [pub.dev](https://pub.dev/)!