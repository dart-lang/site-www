---
title: "AngularDart, Flutter, and the web: Spring update"
description: "Adjusting our investment for Dart’s open source web frameworks"
publishDate: 2021-05-12
author: "timsneath"
image: images/1TnLjhbuMnphc4ZlsuSdtog.png
category: other
tags:
  - angulardart
  - dart
---


Two months ago, we delivered our [first stable release of web support](https://medium.com/flutter/flutter-web-support-hits-the-stable-milestone-d6b84e83b425) for Flutter. This was a major milestone for client development as a whole, combining Flutter’s established UI framework, Dart’s industrial-strength JavaScript toolchain, and the underlying power of the web platform to deliver consistency across mobile devices and browsers.

Since that release, we’ve been excited to see developers start to use Flutter on the web. Even at this early stage, more than 10% of `flutter build` commands target the web, demonstrating that web apps are already being deployed using Flutter. Inside Google, a number of teams are starting to rely on Flutter’s web support. And we use it heavily ourselves for Flutter development, both for [DartPad](https://dartpad.dev/e0a2e942e85fde2cd39b2741ff0c49e5?null_safety=true) and for [DevTools](https://flutter.dev/docs/development/tools/devtools/overview), our suite of performance and debugging tools.

When we first started adding web support to Flutter a couple of years ago, we were hopeful that it would lead to good results, but it still felt like a moonshot. While much work remains, we’re confident that Flutter’s web support has the potential to fill an important niche with a high-quality solution. So, we’re adjusting our investments for Dart’s open source web tooling to focus on Flutter.

In changing our focus, we’re also scaling back our external work on AngularDart, a separate web framework that evolved out of the original Angular project. Six months ago, [we announced a roadmap for AngularDart](https://groups.google.com/a/dartlang.org/g/announce/c/Kz84KNBcf3U) that included publishing a long-term stable update ([AngularDart 6](https://pub.dev/packages/angular/changelog)) and supporting null safety, but prioritized AngularDart engineering work on major internal customers, including [Google Ads](https://ads.google.com/) and [Google Play Console](https://play.google.com/console). Although the AngularDart framework itself is relatively easy to open source, Google’s build and release systems are [uniquely specialized](https://sre.google/sre-book/release-engineering/#continuous-build-and-deployment-Yms8u8), resulting in significant divergence that makes it nontrivial to synchronize internal and external releases.

Focusing on the majority of AngularDart users helps us make the most of our talented engineering resources, and we hope everyone benefits as a result. For projects like Ads and Play Console, we can more directly address their needs without worrying about external implications; for external users, we can put all our energy into giving you a high-quality Flutter product that works across web, desktop, mobile, and embedded scenarios.
> # We can put all our energy into giving you a high-quality Flutter product that works across web, desktop, mobile, and embedded scenarios.

Over the past few months, we’ve been talking with the largest external users of AngularDart to help them with their own roadmaps. For some, Flutter’s web support is a perfect choice; others are happy with the stability and maturity of AngularDart as it stands; yet others are using this opportunity to transition to [Angular](https://angular.io/), Google’s popular TypeScript-based web framework.

Angular itself continues to grow quickly. In the last year, [weekly downloads have grown by over 60%](https://www.npmjs.com/package/@angular/core) and nearly [two million public GitHub repositories depend on it](https://github.com/angular/angular/network/dependents?package_id=UGFja2FnZS00NTE2NDYyMzQ%3D). Its syntax will be familiar to those who are using AngularDart today, and it’s a logical choice for developers looking for a modern web framework.

For developers who want to use Dart, we think Flutter’s web support will be an exciting choice. As an early example, [PropOps](https://propops.com/en/) — a tech startup in the real estate space—has had great success building a line-of-business app with Flutter, as the screenshots below demonstrate:

<DashImage src="images/1TnLjhbuMnphc4ZlsuSdtog.png" alt="PropOps: a cloud-based property management tool, built with Flutter’s web support." caption="PropOps: a cloud-based property management tool, built with Flutter’s web support." />


In the next few weeks, we’ll deliver a stable external release of AngularDart with null safety; at that point, it will shift into maintenance mode. If a committed consortium or community group wants to take over leadership of the project and continue to evolve it, we’re interested in hearing from them.

We’re moving full steam ahead on Flutter’s web support as well as on Angular itself: stay tuned for more on that at next week’s [Google I/O event](https://events.google.com/io/)!