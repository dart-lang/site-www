---
title: "A brand new DartPad.dev with Flutter support"
description: "Today, we’re announcing a major upgrade of DartPad.dev with a fresh new look-and-feel and support for the popular Flutter UI toolkit."
publishDate: 2019-12-04
author: "johnpryan"
image: images/1X7Sild_wdEFGRYaSk2C3Og.gif
category: announcements
tags:
  - dart
  - dartpad
  - announcements
  - flutter
---


Today we’re announcing a major upgrade of [DartPad.dev](https://dartpad.dev) with a fresh new look-and-feel and support for the popular [Flutter](https://flutter.dev/) UI toolkit. DartPad is our online editor that runs Dart programs directly in your browser, and now it runs Flutter apps too.

<DashImage src="images/1X7Sild_wdEFGRYaSk2C3Og.gif" />


## Make something today

To create a new Flutter project, click the **New Pad** button and choose **Flutter**.

<DashImage src="images/1Sd404nMeJmYEgbPpE7HN7g.gif" />


This adds some starter code to the editor and runs it. Any time that DartPad sees that you’re using `package:flutter`, a panel comes up to display the UI. Or use the **Samples** menu to find a Flutter sample.

<DashImage src="images/1CONdjdCgZJH6oN7B4tjA5w.png" />


## Features

All of Flutter’s core libraries, like [cupertino](https://api.flutter.dev/flutter/cupertino/cupertino-library.html) and [material](https://api.flutter.dev/flutter/material/material-library.html), are available to use, and DartPad can display their documentation. Select a symbol to see the documentation in the bottom panel.

<DashImage src="images/1pjBKPqejQhVga2yXYWWigw.gif" />


DartPad formats code using the Dart formatter ([dartfmt](https://github.com/dart-lang/dart_style)), offers assists, provides fixes, suggests auto-completions, and shows errors and warnings.

<DashImage src="images/1f-DNPnkA6gB5wkT_TVVpSQ.gif" />


When you’re ready to share your snippet, you can [create a GitHub gist](https://help.github.com/en/github/writing-on-github/creating-gists) and put the gist ID in a URL like this: `https://dartpad.dev/&lt;GistID&gt;`. You can share this link in a bug report, in a StackOverflow question, or on your social media platform of choice. Check out the [sharing guide](https://github.com/dart-lang/dart-pad/wiki/Sharing-Guide) for more details.

You can also embed DartPad into a page, [like in this codelab](https://flutter.dev/docs/codelabs/layout-basics). Embedded DartPads are especially good for articles, codelabs, and tutorials. (Check out [this guide](https://dart.dev/resources/dartpad-tutorials.pdf) if you’re interested in using DartPad in codelabs and tutorials.) To learn more about adding DartPad to a page, check out the [embedding guide](https://github.com/dart-lang/dart-pad/wiki/Embedding-Guide).

## Thanks!

DartPad is part of the Dart [open-source project](https://github.com/dart-lang). If you’ve filed [issues](https://github.com/dart-lang/dart-pad/issues) or submitted changes to DartPad, thank you for making it better. If you’d like to contribute, get started at [github.com/dart-lang/dart-pad](https://github.com/dart-lang/dart-pad). To learn more about running Flutter on the web, visit [flutter.dev/web](https://flutter.dev/web).

We can’t wait to see what you build!