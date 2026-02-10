---
title: "Announcing Dart 2.10"
description: "A new, unified dart tool for all core tasks. Also, an update on null safety timelines and migration principles."
publishDate: 2020-10-01
author: "mit-mit"
image: images/19wrenixSu1viOYLF1nWhAw.jpeg
category: announcements
tags:
  - announcements
  - null-safety
  - dart
  - flutter
---


*By: [Michael Thomsen](https://medium.com/@mit.mit) & [Kevin Moore](https://twitter.com/kevmoo)*

Today we’re announcing a new release of Dart, version 2.10 (*two-dot-ten*). This release features a new, unified Dart developer tool: a single tool for all your developer needs like creating projects, analyzing and formatting code, running tests, and compiling apps. We also have an update on the null safety roadmap and timelines, and a discussion of the principles for migrating existing code to null safety.

<DashImage src="images/19wrenixSu1viOYLF1nWhAw.jpeg" />


## A new, unified Dart developer tool

Dart forms the foundation of the Flutter SDK: it not only provides the language and runtimes that power Flutter apps, but also supports many core developer tasks like formatting, analyzing, and testing code. However, while Flutter has a single, general-purpose developer tool (the `flutter` command), Dart has historically had many smaller developer tools (for example, `dartfmt` and `dartanalyzer`). Dart 2.10 has a new, unified `dart` developer tool that’s very similar to the `flutter` tool. This new tool supports all common tasks, such as creating new projects and packages; analyzing and formatting code; and running, compiling, and testing projects. To use the tool, simply run the `dart` command:

<DashImage src="images/1y-udLgjneGgP-y8UATZrlw.png" alt="Learn about the 2.10 dart tool by running dart help." caption="Learn about the 2.10 dart tool by running dart help." />


Flutter includes this new Dart tool in the Flutter SDK. Starting with today’s [Flutter 1.22 SDK](https://medium.com/flutter/announcing-flutter-1-22-stable-44f146009e5f), the `&lt;flutter-sdk&gt;/bin` directory (which you likely have in `PATH`) contains both `flutter` and `dart` commands. If you do both Flutter and general-purpose Dart development, you get both developer experiences from a single Flutter SDK, without needing to install anything else.
> **Note:** If you want to download and install a second Dart SDK (perhaps because you require a different version), make sure the SDK of the `dart` tool you wish to default to is at the beginning of your `PATH` environment variable.

Over the coming stable releases, we plan to add more to this `dart` tool and gradually deprecate the smaller tools (`dartdoc`, `dartfmt`, `dartanalyzer`, etc.). Next year we expect to ship Dart SDKs that contain only the single `dart` tool. We recommend that you switch over to the new tool when running Dart commands now, whether manually in the terminal or in continuous integration (*CI*) scripts, and [give us feedback](https://github.com/dart-lang/sdk/issues/new?labels=area-dart-cli) if anything is missing or not working as intended.

## Looking forward to null safety

We’ve experienced a strong interest in null safety since we launched our [first technical preview](https://medium.com/dartlang/announcing-sound-null-safety-defd2216a6f3) a few months back. We’re all looking forward to null safety as a tool for avoiding hard-to-spot null errors, and as an added bonus the performance improvements that we expect to see with sound null safety. If you’re keen to learn more, we recommend our new [Understanding null safety](https://dart.dev/null-safety/understanding-null-safety) page. If you prefer a short video, check out [the null safety video](https://www.youtube.com/watch?v=ZxSyZHq8gUg&feature=youtu.be&list=PLjxrf2q8roU1rBlI9vz01K2324nzIhYgp&t=322) from the [Flutter Day event](https://events.withgoogle.com/flutter-day/#content) a few months ago.

When might null safety be ready to use? Here is the current timeline:

1. **Flutter experimentation with *technical preview 2***: We’ve successfully migrated most parts of Flutter. Soon — likely within the next month — we expect to have the complete Flutter framework migrated, and thus be ready to enable experimental use with Flutter. You’ll be able to try null safety in a Flutter sample, and to do trial migration of your Flutter apps and packages. You’ll need to pass an [experiment flag](https://dart.dev/tools/experiment-flags), shouldn’t use it in production, and shouldn’t publish any migrated packages.

1. **Early package migration with *beta***: Later this year, we’ll complete performance tuning and have sufficient test coverage to give us confidence that the feature works as intended, and that backwards compatibility is solid. At that time we’ll publish a beta version of the feature, and you won’t need to pass the experiment flag. We hope to see package owners begin migration of their packages to null safety, with that one last round of validation that the feature is ready for a stable release.

1. **Production use with *stable***: Depending on the feedback from the beta launch, we’ll fix any remaining issues and then publish to stable. It’s hard to state a concrete timeline for this, but we’re thinking early next year. Once the feature is stable, we hope to see lots of adoption of null safety, with null-safe apps published to stores, and many null-safe packages published to pub.dev in stable versions.

## Principles for migrating to null safety

We’d like to share our guiding principles for null safety migration.

### Adopt when you’re ready

Null safety is a fundamental change to the Dart typing system. It changes the basics of variable declarations because [we decided](https://medium.com/dartlang/announcing-sound-null-safety-defd2216a6f3) to make variables non-nullable by default:

```
**Without null safety**                 W**ith null safety**

String s; // A String or null.      String s; // A String, not null.
```


Such a fundamental change would be extremely disruptive if we insisted on forced adoption. We want to let *you* decide when the time is right, so null safety is an opt-in feature: you’ll be able to use the latest Dart and Flutter releases without being forced to enable null safety before you’re ready to do so. You can even depend on packages that have already enabled null safety from an app or package that hasn’t yet.

### Adopt incrementally, in order

We strongly recommend migrating code in order, with the leaves of the dependency graph being migrated first. For example, if C depends on B which depends on A, migrate A to null safety first, then B, then C. This order applies whether A, B, and C are libraries, packages, or apps.

Why is the order important? Although you can make some progress migrating code before your dependencies migrate, you risk having to do a second migration pass if your dependencies change their APIs during their migration. We will provide tools to help you find out which of your dependencies have migrated. If you’re a package author, then to avoid the risk of breaking your APIs, wait until all of your dependencies have migrated before you publish a null-safe version.

### Use automated tools to reduce migration cost

When your dependencies are ready and you choose to do the migration, you can use our migration tool. The tool works by analyzing all of your existing code, looking for which declarations can be non-nullable (left unchanged), and which must be nullable (need a `?` nullability marker on the declaration).

The migration tool is interactive, so you can review the nullability properties that the tool has inferred. If you disagree with any of the tool’s conclusions, you can add nullability hints to change the inference. For example, if you want to make an API non-nullable even though some refactoring will be needed, you can tell the tool and rerun the migration analysis. Adding a few migration hints can have a huge impact on migration quality.

<DashImage src="images/0wqrweNI-0SK9DB0z.png" />


### Get full benefit with full use

Once *all* of your code — and the packages it depends on — is migrated, your code can be executed with *sound* null safety. Before that, your code will continue to run and compile as it does today, but fully sound null safety enables full runtime verification and compiler optimization. Running tests with sound null safety helps you avoid issues with runtime null assertions, and compiling your applications with sound null safety ensures that you get current and future optimizations, such as smaller compiled output and faster execution.

## Next steps

The new `dart` developer tool is available today in the Dart 2.10 SDK and in the Flutter 1.22 SDK. If you already have a Flutter SDK, you can get a Dart SDK with a `dart` command simply by running `flutter upgrade`; this will give you the Flutter 1.22 SDK, which has Dart 2.10 embedded. We recommend that you switch over to the new `dart` tool immediately, and that you [give us feedback](https://github.com/dart-lang/sdk/issues/new?labels=area-dart-cli) if anything is missing or not working as intended.

We’ll have more news about null safety soon — very likely within the next month, when we expect our friends in the Flutter team to have a null-safety-enabled Flutter framework ready for experimentation. Keep an eye on the [Flutter blog](https://medium.com/flutter) for an update. In the meantime you can experiment with null-safe Dart code using [DartPad with Null Safety](https://nullsafety.dartpad.dev/3d9c1769de7912c654bc5d132aff60ac), and learn more about the feature design by reading our [null safety documentation](https://dart.dev/null-safety).