---
title: "Google Summer of Code 2022 Results"
description: "The Google Summer of Code (GSoC) program focuses on engaging new developers worldwide with open source software development. Google…"
publishDate: 2022-11-03
author: "jonasfj"
image: images/1tzmsHv4_tAl7Nil6XZaANw.png
category: other
tags:
  - dartlang
  - flutter
  - open-source
  - google-summer-of-code
---


The [Google Summer of Code](https://summerofcode.withgoogle.com/) (GSoC) program focuses on engaging new developers worldwide with open source software development. Google sponsors students to work with a mentoring open source organization on a 12-week programming project during the summer. Over the past 17 years, more than 18,000 contributors have participated in Google Summer of Code.

<DashImage src="images/1tzmsHv4_tAl7Nil6XZaANw.png" />


In 2022, Dart have participated as mentoring organization in Google Summer of Code for a third consecutive year. Following our [call for proposals in March](https://medium.com/dartlang/contributors-for-google-summer-of-code-2022-17e777f043f0), we received 50 project proposals from prospective participants around the world. Today, we spotlight some of the projects we mentored this summer. The contributors describe their projects in this post.

## JNI Interop for Dart

*By Mahesh Hegde*

Android platform uses Java as its official language. To access its rich ecosystem would add great value to Dart, so I developed a Java Native Interface (JNI) interop for Dart as my GSoC project.

[*`package:jnigen`*](https://pub.dev/packages/jnigen) generates bindings to enable using Java classes and methods from Dart. `jnigen` generates C bindings that wrap Java libraries, and Dart bindings that call those C bindings. The support library [`package:jni`](https://pub.dev/packages/jni) provides the common functions to initialize and access JNI*.*

In considering the complexity of both Java and JNI, JNI interop for Dart remains experimental. The interop can wrap basic features of the Java language, such as constructors, static and instance methods and field getters. Exceptions in Java get “rethrown” in Dart along with original stack traces. The interop cannot subclass a Java class from Dart or pass callbacks. After GSoC, we plan to improve the binding generation pipeline and implement more Java language features.

The technical complexity of the project proved challenging. We knew there hadn’t been any Java interop attempt for a natively-compiled, high-level language using JNI. We often had to find workarounds when something didn’t work as expected, like dynamic library loading and JNI exceptions. I ended up writing several tools to aid the project. These included one to get Java sources from maven and another to build shared libraries. I learned a lot about time management, prioritization, testing, and writing neat, readable and understandable code.

## Flutter Community admin dashboard

*By Abdelrahman Amer*

For GSoC’22, I designed and built an [admin dashboard for Flutter Community repositories on GitHub](https://github.com/fluttercommunity/admin_dashboard). The dashboard assists Flutter Community admins through aggregating the latest activities on repositories, maintainers, levels of access, and more. It contains a trigger to build and deploy to [pub.dev](https://pub.dev/). I implemented the project using Flutter for the frontend and Firebase for the backend.

During the project, I developed interesting reusable components, including:

1. A Firebase abstraction layer

1. A MVC widget and associated data structure classes to display any tabular information sortable by any field

1. A MVC widget and data structure classes to display graphical 2D data

The admin dashboard lacks some features, but the core functionalities have been implemented. I look forward to continuing work on more features after the GSoC period.

The GSoC experience taught me valuable development skills, especially in Flutter. I am very grateful for the opportunity, the great work environment, the experience I gained, and the mentoring I received from [Majid](https://github.com/mhadaily).

## Detecting incorrect version constraints

*By Arseny Uskov*

A package maintainer must assign an appropriate version to each Dart package release. They must decide whether they have introduced breaking changes to the users depending on their package. Dependent packages also assume what an appropriate version range would be for each of *their* dependencies.

Bugs can arise from incorrect assumptions in these areas. My project sought to identify and investigate a subset of these bugs.

<DashImage src="images/187NMdHXboVklByFDhR9d2Q.png" alt="An incorrect dependency constraint caused by improper versioning of `package:foo`" caption="An incorrect dependency constraint caused by improper versioning of `package:foo`" />


The project provides tools that summarize a portion of the public API of a given version of a given package. This summary identifies any other packages dependent on the given package that might have an incorrect version constraint. Our use case covered where a package used a symbol defined in one of its dependencies, but the same symbol did not include the lowest allowed version of that dependency.

The public API summary model allows for a range of other interesting static analysis applications. We did not have time to explore them during GSoC. To learn more, refer to the [API Analysis blog post](https://arseny.uk/posts/gsoc2022/) about the project, challenges we faced, results gathered from running analysis on the pub.dev ecosystem, bugs we found in real packages, and a starting point for hacking on the project yourself.

*Huge thanks to everyone who applied for Google Summer of Code 2022 with Dart, to the contributors who completed projects this year, and to the mentors who helped make this an awesome summer of code. If you’re interested in hearing more about Dart in Google Summer of Code, check out [our 2021 post](https://medium.com/dartlang/google-summer-of-code-2021-results-e514cce50fc).*