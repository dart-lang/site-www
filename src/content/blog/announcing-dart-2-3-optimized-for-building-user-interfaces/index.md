---
title: "Announcing Dart 2.3: Optimized for building user interfaces"
description: "Today we’re announcing the stable release of the Dart 2.3 SDK, with new language features that improve your coding experience when…"
publishDate: 2019-05-08
author: mit-mit
image: images/0iKWVPoE5aSiCI-mW.png
category: announcements
tags:
  - dart
  - flutter
  - programming-languages
  - ui
  - announcements
layout: blog
---


Today we’re announcing the stable release of the Dart 2.3 SDK, with new language features that improve your coding experience when developing user interfaces, new tooling support for developing Flutter UI, and two new websites: [dart.dev](https://dart.dev) & [pub.dev](https://pub.dev).

<DashImage src="images/0iKWVPoE5aSiCI-mW.png" />


## Dart’s momentum

One of the developer research reports we look forward to every year is the [StackOverflow Developer Survey](https://insights.stackoverflow.com/survey/2019), which provides a comprehensive dataset on developer trends and sentiment towards different technologies. This year’s edition demonstrated the growth in popularity and awareness of Dart, which entered the list of [Most Loved Languages](https://insights.stackoverflow.com/survey/2019#technology-_-most-loved-dreaded-and-wanted-languages) for the first time and ranked alongside other popular languages like JavaScript, C#, and Go and ahead of the likes of C++, F#, and R. At the same time, our good friends in the Flutter community were ranked third in the list of [Most Loved Frameworks](https://insights.stackoverflow.com/survey/2019#technology-_-most-loved-dreaded-and-wanted-other-frameworks-libraries-and-tools). Last month’s Codementor survey on *which programming languages to learn and not to learn* had similar positive news:.
> *“*Two examples of languages that really rose to the occasion for the title of Most Improved are Dart and Ruby*”.* Codementor, April 2019 [[source](https://www.codementor.io/blog/worst-languages-2019-6mvbfg3w9x)]

We’d like to extend a big *thank you* to all developers in the Dart community. It really means a lot to us to see you adopt Dart, offer your feedback, and continue the journey with us as we attempt to build the best client-optimized language for fast apps that run on any platform.

## New language features for building user interfaces

Speaking of client development, one of the longstanding joint projects between the Dart & Flutter teams is creating great support for capturing user interface code using Dart, without needing a markup language. We think that using a single language for both behavior and layout has large benefits. These include reducing context switching, not having to learn two languages, and allowing all of the abstraction features of a general-purpose programming language when building your UI.

We’ve made several improvements over the last few releases, such as simplifying code for [constructing widgets](https://medium.com/dartlang/announcing-dart-2-80ba01f43b6#da82), adding automatic [int-to-double conversion](https://medium.com/dartlang/announcing-dart-2-1-improved-performance-usability-9f55fca6f31a), and adding [set literals](https://medium.com/dartlang/announcing-dart-2-2-faster-native-code-support-for-set-literals-7e2ab19cc86d). In Dart 2.3 we take another big step forward, with three new features for expressing UI that is list-based, conditional, or repeated.

You can think of a UI as a tree of widget nodes. Some nodes contain lists of widgets — for example a list of scrollable elements. Often, these lists are built from other lists. For that, we have added a new [*spread operator*](https://dart.dev/guides/language/language-tour#spread-operator) feature for *unpacking* the elements from one list into another. In the following example, `buildMainElements()` returns a list of widgets, which is then unpacked into the surrounding list using the spread operator `…`:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Header(),
    ...buildMainElements(),
    Footer(),
  ]);
}
```

Another common UI task is to include a specific element based on a condition. For example, you may want to include a *Next* button on all pages but the last one. With Dart 2.3, you can do this using a [*collection if*](https://dart.dev/guides/language/language-tour#collection-operators):

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    if (page != pages.last)
      FlatButton(child: Text('Next')),
  ]);
}
```

Finally, UIs often build repeated elements from other repeated elements. You can express this using the new [*collection for*](https://dart.dev/guides/language/language-tour#collection-operators) feature:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    for (var section in sections)
      HeadingAction(section.heading),
  ]);
}
```

And because the three new features are language features, and not markup commands, they are fully composable, and can be used in any context where you work on collections. The features are included in the [Flutter 1.5](https://medium.com/flutter-io/announcing-flutter-1-5-d203c6072e5c) release, and are available in the [Dart 2.3](https://dart.dev/get-dart) release, which you can download today. We’ve also added new lints that you can [configure in static analysis](https://dart.dev/guides/language/analysis-options#enabling-linter-rules) to enforce using the new [spread](http://dart-lang.github.io/linter/lints/prefer_spread_collections.html), [collection if](http://dart-lang.github.io/linter/lints/prefer_if_elements_to_conditional_expressions.html), and [collection for](http://dart-lang.github.io/linter/lints/prefer_for_elements_to_map_fromIterable.html) features.

For details on all the work that was done to add these features, check out [this recent post](https://medium.com/dartlang/making-dart-a-better-language-for-ui-f1ccaf9f546c) from Bob Nystrom (aka [munificentbob](https://twitter.com/munificentbob)), an engineer on the Dart language team.

We’d also like to extend our gratitude to the developers who participated in the UX studies that were critical in shaping these new language features.

## IDE & editor features

In keeping with Dart 2.3’s UI theme, we’ve also added a new UI Guides feature to our IDE support. UI Guides are horizontal and vertical lines drawn within UI code, making it much easier to see the tree structure of Flutter UI build() methods. Here’s an example (from a Calculator app) where the UI Guides clearly illustrate that the UI is built from an Expanded Column containing several KeyRows, each of which contains NumberKeys.

<DashImage src="images/1CsGJu4iSvHzspALjfbQRfA.png" alt="IDE with UI Guides visualizing the tree structure of UI code" caption="IDE with UI Guides visualizing the tree structure of UI code" />


UI Guides are available in [version 35.2](https://plugins.jetbrains.com/plugin/9212-flutter) of the IntelliJ IDEA and Android Studio plugin. To enable the feature, choose the setting *Preferences &gt; Languages & Frameworks &gt; Flutter &gt; UI Guides*. We hope to offer similar support in VS Code in a later release.

Finally, we’ve observed that developers often use code completion in their IDE as a way of exploring APIs. Code completion has worked well for exploring the APIs in the libraries that you’ve already imported, but it hasn’t been available for APIs in libraries that aren’t yet imported. Our tools can now support the latter use case: you can invoke code completion on any prefix, and you’ll see completions for all APIs in the current package, the packages it directly depends on, and the SDK. If you choose a completion from a not-yet-imported library (marked *Auto import*, as the following animation shows), then the tool adds the import statement for you.

<DashImage src="images/0fqBkEGgVtWMT1QRy.gif" alt="Animation showing code completion & automatic import adding" caption="Animation showing code completion & automatic import adding" />


This new auto-import feature is available in VS Code with the [v2.26 plugin](https://dartcode.org/releases/v2-26/), in IntelliJ 2019.1, and the upcoming Android Studio 3.5 release.

## New Dart & Pub websites

Last, but certainly not least, we’ve been very busy the last few months building a new website for the Dart platform: [dart.dev](https://dart.dev)

<DashImage src="images/1ydTSALWV77UbB3WHKsy9cg.png" alt="Redesigned [https://dart.dev](https://dart.dev) homepage" caption="Redesigned [https://dart.dev](https://dart.dev) homepage" />


This new site features an entirely new landing page, focused on explaining the core benefits of the Dart platform. We’ve also updated the documentation pages to have better navigation and more visual appeal. Lastly, we’ve done a huge reorganization of all content to make discovery easier, and added new pages for core content that was missing before.

In a similar vein, we’ve visually updated the Pub package site, and we’ve moved it to a convenient new URL: [pub.dev](https://pub.dev).

We’d love to hear your feedback on both sites. If you find a problem or have a suggestion, please create an issue in the [dart.dev issue tracker](https://github.com/dart-lang/site-www/issues) or the [pub.dev issue tracker](https://github.com/dart-lang/pub-dartlang-dart/issues). Thanks for your support!