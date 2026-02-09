---
title: "Introducing a brand new pub.dev"
description: "Redesigned for high-quality, multiplatform packages"
publishDate: 2020-07-15
author: "mit-mit"
image: images/0efALL34OP6a4tcxh.png
category: other
tags:
  - dart
  - flutter
  - package-management
  - google
  - development
---


Today we’re launching a brand new [pub.dev](https://pub.dev) site. It features new scoring metrics to give you a better understanding of potentially useful packages, and to provide package publishers with more actionable feedback on how to improve package quality. To help you find packages that support all the platforms you’re interested in, we’ve added support for identifying and searching for multiplatform packages. And overall we’ve redesigned the UI, aiming for a delightful and elegant experience that’s consistent with our [dart.dev](https://dart.dev) and [dartpad.dev](https://dartpad.dev) sites.

<DashImage src="images/0efALL34OP6a4tcxh.png" alt="The new pub.dev site" caption="The new pub.dev site" />


## Finding the best packages for your needs

With* *nearly 7,000 new packages published over the past year, you have no shortage of options when looking for packages to extend the functionality of your apps. But with so many packages to choose from, naturally you want the most liked, highest quality, and most popular packages to bubble to the surface. To support better package search results, we’ve redesigned the scoring system in pub.dev around three dimensions:

<DashImage src="images/0OmvIh_FRHtJDrSIk.png" alt="*The three scoring dimensions for a pub package*" caption="*The three scoring dimensions for a pub package*" />


1. **Likes**: A measure of how many developers have liked a package. This provides a raw measure of the overall sentiment toward a package.

1. **Pub points**: A new measure of quality. This includes several dimensions of quality such as code style, platform support, and maintainability. More about this below.

1. **Popularity**: A measure of how many developers use a package. This reflects the number of apps that depend on the package over the past sixty days. The normalized scale ranges from 100% (the most used package) to 0% (the least used package), but we’re investigating whether we can provide absolute usage counts in a future version.

We hope that these new dimensions help both package consumers who are looking for packages to depend on, and package publishers working on shipping a high quality packages.

## Measuring quality with pub points

With likes and popularity providing community-sourced, subjective measures, the goal of pub points is to provide a close approximation of measurable, objective quality. This isn’t easy; developers perceive quality in a variety of ways, but we still believe that most developers look for core traits that we can measure. The previous pub.dev scoring model was based on subtracting points for issues. The new scoring model reverses this approach, instead awarding points based on traits in five categories:

<DashImage src="images/0RWVQoe0INHUfS_Ax.png" alt="*Pub points overview with categories and checks, as well as points awarded*" caption="*Pub points overview with categories and checks, as well as points awarded*" />


1. *Follow Dart file conventions*: Follow best practices around pubspec, readme, and changelog files

1. *Provide documentation*: Provide API documentation and an illustrative example

1. *Support multiple platforms*: Support as many Dart and Flutter platforms as possible

1. *Pass static analysis*: Provide code that is free from errors, warnings, and lints

1. *Support up-to-date dependencies*: Have dependency constraints that support the latest Dart & Flutter SDKs, and the latest package dependencies

We expect to add more checks and categories for pub points over time, raising the ceiling for how many points a package can have. For example, we plan to add a score for supporting [null safety](https://medium.com/dartlang/announcing-sound-null-safety-defd2216a6f3) when that feature launches. And we’re investigating how to measure maintainability (issue and pull request responsiveness), testability (automated test coverage), and community friendliness (number of contributors, maintainers, etc.). If you have an idea for a great measure, we’d love to [hear from you](https://github.com/dart-lang/pub-dev/issues)!

## Supporting multiplatform apps

Both Dart and Flutter excel at creating apps that target multiple platforms. On pub.dev we’ve provide clear platform tags for mobile (iOS and Android) and web platforms, as well as search filters for these platforms:

<DashImage src="images/0aTIl5H_AbGmOJBKO.png" alt="Platform filters in search" caption="Platform filters in search" />


To make sure that your package is tagged with the correct platform support, follow the guidance on the pub.dev [scoring help page](https://pub.dev/help/scoring).

We’ll be adding similar support for desktop platforms (macOS, Windows, and Linux) when that advances to a more final state. For now you can find filters for those platforms inside the **Advanced** search options:

<DashImage src="images/0LpResE7zZv_5x3xB.png" alt="*Desktop platforms in advanced filters*" caption="*Desktop platforms in advanced filters*" />


## An elegant and delightful design

The Dart pub.dev team collaborated with Google Developer Studio, our internal creative team, with Jeremy Sie as the main designer. Alongside functional updates, the team took a considered look at the visual design, sharing their thoughts on the project. With an eye to providing a coherent, accessible, and user-focused experience, we made a range of refinements rooted in Google’s [Material Design system](https://material.io/design/). Our aim was to create a lightweight and streamlined interface, allowing for clear and concise workflows for both package publishers and consumers.

The updated design features [Material components](https://material.io/components) such as cards and chips that clearly display package details and allow greater transparency into how individual packages function. We updated the typographic system and improved the [type scale](https://material.io/design/typography/the-type-system.html#type-scale) across the site, bringing greater clarity to search results and improving the way package information is displayed. Components such as package scores have been redesigned to be clearer and structured in a way that makes the scoring process more transparent and easier to understand.

<DashImage src="images/06UWz21c0wZuisozR.png" alt="*Search showing all three pub.dev scores*" caption="*Search showing all three pub.dev scores*" />


We also made changes to the homepage. We knew the ability to quickly search for packages was a core part of the site, but we wanted to improve the experience by surfacing the most useful tools and libraries. We added sections such as **Flutter favorites** and **Most popular packages** up front, helping you to quickly explore some of the best packages available. We took a close look at the color palette and art direction, incorporating illustrations and making components such as code examples visually consistent with [dart.dev](https://dart.dev/) and [dartpad.dev](https://dartpad.dev/).

## Try pub.dev today

We invite you to try the new [pub.dev](http://pub.dev) browse and search experience today, and to use the new scoring dimensions and pub points report.

If you’re a package developer, we encourage you to view the pub points for your packages, looking for opportunities to improve your packages. For further details on how the scoring system works, see the [pub.dev scoring help](https://pub.dev/help/scoring).

As always, we love feedback. Please leave comments below, or file issues in the [pub.dev issue tracker](https://github.com/dart-lang/pub-dev/issues).

*By: Michael Thomsen (Product Manager, Dart) & 
Jeremy Sie (Visual Designer, Google Developer Studio)*