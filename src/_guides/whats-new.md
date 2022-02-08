---
title: What’s new
description: A list of what’s new on dart.dev and related sites.
---

This page describes what's new on the Dart website and blog.
To see what's new in Flutter, visit the
[Flutter what's new page.][flutter-whats-new]

For a list of Dart language changes in each Dart SDK, see the 
[language evolution page][evolution].
To stay on top of announcements, including breaking changes,
join the [Dart announcements Google group][dart-announce]
and follow the [Dart blog][].

[flutter-whats-new]: {{site.flutter_docs}}/whats-new
[dart-announce]: https://groups.google.com/a/dartlang.org/d/forum/announce
[Dart blog]: https://medium.com/dartlang

## February 3, 2022: 2.16 release

This section lists notable changes made from December 8, 2021,
through February 3, 2022.
For details about the 2.16 release, 
see [Dart 2.16: Improved tooling and platform handling][].

[Dart 2.16: Improved tooling and platform handling]: https://medium.com/dartlang/dart-2-16-improved-tooling-and-platform-handling-dd87abd6bad1

### Docs updated or added to dart.dev
{: .no_toc}

We [updated the website infrastructure][] to a Docker-based setup
to enable [easier contributions][] and more closely align with
the setup for [docs.flutter.dev]({{site.flutter_docs}}).

In addition to other bug fixes and incremental improvements,
we made the following changes to this site:

* Switched to documenting the new [`dart doc`][] tool 
  which replaces `dartdoc`.
* Documented the new [`platform` entry][] to specify supported platforms
  within a package's `pubspec.yaml`.
* Updated the [diagnostic messages][] and [linter rules][] pages.
* Documented how to [ignore all linter rules][] in a file.
* Removed mentions of the old standalone tools from the [Dart SDK overview][].
* Update remaining mentions of the old standalone tools
  to their [`dart`] tool equivalents.
* Added clarifications to the
  [PREFER using interpolation to compose strings and values][]
  Effective Dart guideline.

[updated the website infrastructure]: https://github.com/dart-lang/site-www/pull/3765
[easier contributions]: {{site.repo.this}}#getting-started
[`dart doc`]: /tools/dart-doc
[`platform` entry]: /tools/pub/pubspec#platforms
[ignore all linter rules]: /guides/language/analysis-options#suppressing-rules-for-a-file
[diagnostic messages]: /tools/diagnostic-messages
[linter rules]: /tools/linter-rules
[Dart SDK overview]: /tools/sdk
[PREFER using interpolation to compose strings and values]: /guides/language/effective-dart/usage#prefer-using-interpolation-to-compose-strings-and-values
[`dart`]: /tools/dart-tool


## December 8, 2021: 2.15 release

This section lists notable changes made from September 9, 2021,
through December 8, 2021.
For details about the 2.15 release, see [Announcing Dart 2.15][].

[Announcing Dart 2.15]: https://medium.com/dartlang/dart-2-15-7e7a598e508a

### Docs updated or added to dart.dev
{: .no_toc}

In addition to bug fixes and incremental improvements,
we made the following changes to this site:

* Added [Concurrency in Dart][], which discusses features such as
  isolates that enable parallel execution of Dart code.
* Documented pub features added or improved in 2.15:
  * Added a page for a new pub subcommand, [dart pub token][],
    and a page about [custom package repositories][]
  * Added information about [package retraction][]
  * Added the [false_secrets][] field to the pubspec page
  * Updated the syntax for [hosted dependencies][]
* Removed all entries for Dart 1 [books][]
* Expanded on [DartPad troubleshooting tips][]
* Updated the [diagnostic messages][] page
* Updated the [linter rules][] page;
  removed references to deprecated rule sets such as
  `effective_dart`
* Updated the instructions for installing and using
  [Dart DevTools][]
* Added information about what the [Dart runtime][] provides,
  and clarified [compilation formats][]

[books]: /resources/books
[compilation formats]: /tools/dart-compile
[Concurrency in Dart]: /guides/language/concurrency
[custom package repositories]: /tools/pub/custom-package-repositories
[Dart DevTools]: /tools/dart-devtools
[dart pub token]: /tools/pub/cmd/pub-token
[Dart runtime]: /overview#runtime
[DartPad troubleshooting tips]: /tools/dartpad/troubleshoot
[diagnostic messages]: /tools/diagnostic-messages
[false_secrets]: /tools/pub/pubspec#false_secrets
[hosted dependencies]: /tools/pub/dependencies#hosted-packages
[linter rules]: /tools/linter-rules
[package retraction]: /tools/pub/publishing#retract


## September 8, 2021: 2.14 release

This section lists notable changes made from May 20, 2021,
through September 8, 2021.
For details about the 2.14 release, see [Announcing Dart 2.14][].

[Announcing Dart 2.14]: https://medium.com/dartlang/announcing-dart-2-14-b48b9bb2fb67

### Docs updated or added to dart.dev
{: .no_toc}

In addition to bug fixes and incremental improvements,
we made the following changes to this site:

* Fleshed out the page on [fixing type promotion failures][no-promo].
* Documented how to use the [`.pubignore` file][],
  a feature that was introduced in Dart 2.14.
* Added coverage of the [unsigned shift operator][] (`>>>`),
  which was introduced in Dart 2.14.
* Built out the [linter rule page][];
  updated Effective Dart to link to it.
* Added pages for the
  [`dart create`][] and [`dart test`][] commands.
* Finished converting examples from using old command-line tools
  (for example, `dartfmt`) to using the [unified `dart` tool][dart-tool]
  (for example, `dart format`).
* Updated site code to use the [recommended linter rules][],
  instead of pedantic.
* Updated the lists of [core libraries][] and [commonly used packages][].
* Added a redirect from [dart.dev/jobs][] to flutter.dev/jobs,
  to make it easier to find open positions on
  the Dart and Flutter teams.
* Finished migrating all analyzed or tested code to null safety,
  updating text to match.
  Found more site code that hadn't been analyzed; fixed that.

[unsigned shift operator]: /guides/language/language-tour#bitwise-and-shift-operators
[`.pubignore` file]: /tools/pub/publishing#what-files-are-published
[linter rule page]: /tools/linter-rules
[dart-tool]: /tools/dart-tool
[recommended linter rules]: /guides/language/analysis-options#lints
[core libraries]: /guides/libraries
[commonly used packages]: /guides/libraries/useful-libraries
[dart.dev/jobs]: /jobs
[no-promo]: /tools/non-promotion-reasons
[`dart create`]: /tools/dart-create
[`dart test`]: /tools/dart-test

### Articles added to the Dart blog
{: .no_toc}

We published the following articles on the Dart blog:

* [Experimenting with Dart and Wasm][blog-7-27-21]
* [How Dart’s null safety helped me augment my projects][blog-6-23-21]
* [Implementing structs by value in Dart FFI][blog-6/8-21]

[blog-7-27-21]: https://medium.com/dartlang/experimenting-with-dart-and-wasm-ef7f1c065577
[blog-6-23-21]: https://medium.com/dartlang/how-darts-null-safety-helped-me-augment-my-projects-af58f8129cf
[blog-6/8-21]: https://medium.com/dartlang/implementing-structs-by-value-in-dart-ffi-1cb1829d11a9


## May 19, 2021: 2.13 release

This section lists notable changes made from March 4, 2021,
through May 19, 2021.
For details about the 2.13 release, see [Announcing Dart 2.13][].

[Announcing Dart 2.13]: https://medium.com/dartlang/announcing-dart-2-13-c6d547b57067

### Docs updated or added to dart.dev
{: .no_toc}

In addition to bug fixes and incremental improvements,
we made the following changes to this site:

* Updated the [typedef section][] of the language tour to reflect
  non-function type aliases,
  which were introduced in Dart 2.13.
* Published or updated documentation related to the command line and servers:
  * [Using Google Cloud][] describes Google Cloud products that
    Dart servers can use,
    often with the help of pre-packaged Docker images.
  * The [HTTP server tutorial][],
    which featured the discontinued `http_server` package,
    has been temporarily replaced by
    an "under construction" page that
    links to helpful documentation and samples.
  * The [command-line tutorial][] has been completely updated.
* Published some other new pages:
  * [Null safety codelab][] teaches you about Dart’s null-safe type system,
    which was introduced in Dart 2.12.
  * [Numbers in Dart][] has
    details about differences between native and web number implementations.
  * [Using Google APIs][] points to resources to
    help you use Firebase and Google client APIs from a Dart app.
  * [Writing package pages][] gives tips for
    writing a package README that works well on pub.dev.
  * [Fixing type promotion failures][]
    has information to help you understand
    why type promotion failures occur, and gives tips on how to fix them.
  * The new [`dart run` page][]
    describes how to run a Dart program from the command line.
* Continued work on migrating code to null safety, in particular the
  [streams tutorial][].
* Made miscellaneous other updates:
  * Removed references to Stagehand, in favor of [`dart create`][].
  * Changed analytics options for dart.dev example code from
    using `pedantic` to using the recommended rules in [`lints`][].
  * Added Docker as a way to [get Dart][].
  * Updated the [language evolution page][evolution] to reflect Dart 2.13.

[command-line tutorial]: /tutorials/server/cmdline
[`dart run` page]: /tools/dart-run
[`dart create`]: /tools/dart-create
[Fixing type promotion failures]: /tools/non-promotion-reasons
[get Dart]: /get-dart
[HTTP server tutorial]: /tutorials/server/httpserver
[`lints`]: {{site.pub-pkg}}/lints
[Null safety codelab]: /codelabs/null-safety
[Numbers in Dart]: /guides/language/numbers
[streams tutorial]: /tutorials/language/streams
[typedef section]: /guides/language/language-tour#typedefs
[Using Google APIs]: /guides/google-apis
[Using Google Cloud]: /server/google-cloud
[Writing package pages]: /guides/libraries/writing-package-pages


### Articles added to the Dart blog
{: .no_toc}

We published the following articles on the Dart blog:

* [AngularDart, Flutter, and the web: Spring update][blog-5-12-21]
* [Announcing Dart support for GitHub Actions][blog-3-24-21]
* [Dart in Google Summer of Code 2021][blog-3-13-21]

[blog-5-12-21]: https://medium.com/dartlang/angulardart-flutter-and-the-web-spring-update-f7f5b8b10001
[blog-3-24-21]: https://medium.com/dartlang/announcing-dart-support-for-github-actions-3d892642104
[blog-3-13-21]: https://medium.com/dartlang/dart-in-google-summer-of-code-2021-e89eaf1d177a


## March 3, 2021: 2.12 release

This section lists notable changes made from October 2, 2020,
through March 3, 2021.
For details about the 2.12 release, see [Announcing Dart 2.12][].


### Docs updated or added to dart.dev
{: .no_toc}

In addition to bug fixes and incremental improvements, we made the following changes to this site:

* Updated and fleshed out null safety docs. Notably:
  * Provided a [migration guide][].
  * Added a [FAQ][ns-faq].
  * Created [Unsound null safety][].
  * Simplified the [null safety homepage][].
* Refreshed [Effective Dart][], updating code to be null safe and
  changing rules to reflect new guidance.
* Refreshed the [language tour][], updating code to be null safe and
  adding information about new features such as
  [`late` variables][].
* Updated the [language evolution page][evolution]
  to add information about language versioning
  and to reflect Dart 2.12.
* Updated the [library tour][], [samples][], and [codelabs][]
  to reflect sound null safety.
* Updated pages across the site to use [the `dart` tool][]
  instead of deprecated commands.
  Started adding pages for various `dart` commands, including
  [`dart analyze`][], [`dart compile`][], [`dart fix`][],
  and [`dart format`][].
* Created a page documenting the quality and support of [Dart team packages][].
* Replaced the Platforms page with a new [Overview page][].
* Created this page ("What’s new").

We also switched from Travis CI to GitHub Actions, and we made multiple CSS changes to improve site legibility.

[Announcing Dart 2.12]: https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87
[migration guide]: /null-safety/migration-guide
[ns-faq]: /null-safety/faq
[Unsound null safety]: /null-safety/unsound-null-safety
[null safety homepage]: /null-safety
[Overview page]: /overview
[Effective Dart]: /guides/language/effective-dart
[language tour]: /guides/language/language-tour
[`late` variables]: /guides/language/language-tour#late-variables
[library tour]: /guides/libraries/library-tour
[samples]: /samples
[codelabs]: /codelabs
[the `dart` tool]: /tools/dart-tool
[`dart analyze`]: /tools/dart-analyze
[`dart compile`]: /tools/dart-compile
[`dart fix`]: /tools/dart-fix
[`dart format`]: /tools/dart-format
[Dart team packages]: /dart-team-packages


### Articles added to the Dart blog
{: .no_toc}

We published the following articles on the Dart blog:

* [Preparing the Dart and Flutter ecosystem for null safety][blog-2-16-21]
  announced null safety API stability and
  invited developers to publish stable, null-safe versions of their packages.
* [Dart and the performance benefits of sound types][blog-1-19-21]
  demonstrated how soundness and null safety enable Dart compilers to
  generate faster, smaller code.
* [Why nullable types?][blog-12-7-20]
  expanded on a discussion on the /r/dart_lang subreddit,
  answering the question “Why not get rid of null completely?”
* [Announcing Dart null safety beta][blog-11-19-20]
  invited developers to start planning their migration to null safety.

[blog-2-16-21]: https://medium.com/dartlang/preparing-the-dart-and-flutter-ecosystem-for-null-safety-e550ce72c010
[blog-1-19-21]: https://medium.com/dartlang/dart-and-the-performance-benefits-of-sound-types-6ceedd5b6cdc
[blog-12-7-20]: https://medium.com/dartlang/why-nullable-types-7dd93c28c87a
[blog-11-19-20]: https://medium.com/dartlang/announcing-dart-null-safety-beta-87610fee6730

## October 1, 2020: 2.10 release

This section lists notable changes made from
July 1 through October 1, 2020.
For details about the 2.10 release, see [Announcing Dart 2.10.][210-ann]

[210-ann]: https://medium.com/dartlang/announcing-dart-2-10-350823952bd5

<div class="no_toc_section" markdown="1">

### Docs updated or added to dart.dev
{: .no_toc}

In addition to bug fixes and small improvements,
we made the following changes to this site:

* Added a [`dart` tool page][dart-tool]
  to document the new command-line interface to the Dart SDK.
  The new `dart` tool is analogous to the `flutter` tool in the Flutter SDK.
  Previously, the `dart` command only ran command-line apps.
  We updated the previous `dart` page accordingly
  and plan to update references to other tools over time.
* Updated the [package changelog documentation][changelog-docs]
  to recommend a standard format for `CHANGELOG.md` files.
  This new format lets tools
  (such as the relaunched pub.dev)
  parse changelogs.
* Changed an [Effective Dart][] guideline to favor
  using `Object` instead of `dynamic`.
  For details, see the revised guideline
  [AVOID using `dynamic` unless you want to disable static checking.][dynamic]
* Updated the [diagnostic messages page][diagnostics] to
  include more messages produced by the Dart analyzer.
* Updated the [evolution page][evolution]
  to include 2.9 and 2.10.
* Reorganized the [language specification page][spec]
  to make it easier to find the PDF version of
  the latest, in-progress specification.
* Added or updated docs related to [sound null safety][],
  a feature that's coming to the Dart language:
  * Clarified how to use [experiment flags with IDEs][experiments].
  * Updated the null safety page, adding information about
    [how to enable null safety][ns-enable].
  * Added a deep dive into null safety,
    [Understanding null safety][],
    written by Dart engineer Bob Nystrom.

[dart-tool]: /tools/dart-tool
[diagnostics]: /tools/diagnostic-messages
[dynamic]: /guides/language/effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking
[Effective Dart]: /guides/language/effective-dart
[evolution]: /guides/language/evolution
[experiments]: /tools/experiment-flags#using-experiment-flags-with-ides
[ns-enable]: /null-safety#enable-null-safety
[Understanding null safety]: /null-safety/understanding-null-safety
[sound null safety]: /null-safety
[diagnostics]: /tools/diagnostic-messages
[changelog-docs]: /tools/pub/package-layout#changelogmd
[spec]: /guides/language/spec

### Articles added to the Dart blog
{: .no_toc}

We published the following articles on the [Dart blog:][Dart blog]

* [Exploring collections in Dart][] helps you use collections
  (lists, maps, sets, and more), with special attention to
  2.3 language features like collection if, collection for, and spreads.
* [Google Summer of Code 2020 results][] describes the results of
  five projects that the Dart team mentored.
* [Introducing a brand new pub.dev][] announces the relaunch of
  the [pub.dev site,][pub.dev] with new package scoring metrics, improved search,
  and a redesigned UI.

We also improved the blog navigation,
adding **announcement** and **archive** tabs, plus a link to dart.dev.

{{site.alert.tip}}
  All articles in the Dart blog are free to read.
{{site.alert.end}}

</div>

[Dart blog]: https://medium.com/dartlang
[Exploring collections in Dart]: https://medium.com/dartlang/exploring-collections-in-dart-f66b6a02d0b1
[Google Summer of Code 2020 results]: https://medium.com/dartlang/google-summer-of-code-2020-results-a38cd072c9fe
[Introducing a brand new pub.dev]: https://medium.com/dartlang/pub-dev-redesign-747406dcb486
[pub.dev]: {{site.pub}}
