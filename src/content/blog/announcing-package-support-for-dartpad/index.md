---
title: "Announcing package support for DartPad"
description: "Create robust code snippets with popular packages in DartPad"
publishDate: 2021-11-15
author: zoeyfan
image: images/05iMRgkKlQGK6fJx3.png
category: announcements
tags:
  - flutter
  - dart
  - firebase
  - programming
  - announcements
layout: blog
---


Today we’re excited to announce that package support is now available in [DartPad](https://github.com/dart-lang/dart-pad)! DartPad is the open-sourced, web-based playground that runs Dart and Flutter apps directly in your web browser. It allows you to quickly run Dart code to test an idea or code up a technical concept without needing to install the Flutter SDK or any tools on your local system.

Since the launch of DartPad, one of the [most popular requests](https://github.com/dart-lang/dart-pad/issues/901) has been to add support for importing packages, such as [Google Fonts](https://pub.dev/packages/google_fonts) or [Firebase Authentication](https://pub.dev/packages/firebase_auth), directly in DartPad’s editor. In this first phase of rollout, you can import from a set of popular packages.

To help you get started, we’ve created several new examples that you can find using DartPad’s **Samples** menu.

## Google Fonts example

Start using a package by adding an import statement for it at the top of the code editor. For example, to use the Google Fonts package, add this:

`import 'package:google_fonts/google_fonts.dart';`

DartPad handles the pubspec details for you, so all you need is the import statement. You can use suggested completions to change fonts and then rerun the app, just like you would in an IDE.

<DashImage src="images/05iMRgkKlQGK6fJx3.png" />


## How package support works

Here’s a quick overview of how package support works in DartPad. The DartPad server takes the set of supported packages and uses `**flutter pub get**` to fetch the latest compatible version of each package. Then the server uses these package versions during analysis and compilation of your DartPad script.

This release also supports the most popular Firebase packages, so you can access a suite of backend services without ever leaving DartPad. All necessary Firebase JavaScript SDKs are loaded into the output panel before running the compiled app.

Here’s a [simple chat app](https://dartpad.dev/?id=d57c6c898dabb8c6fb41018588b8cf73&null_safety=true) that uses Firebase:

<DashImage src="images/05QSzuPZeeo3tb0R1.png" />


This multi-user chat app is implemented with only client-side Dart code running (and written) in the browser, and uses the Firestore database to share messages between users. While it might seem dangerous to open your database directly to users, it’s actually secured by only allowing chat messages that use a very specific set of words. Read the comments in [the code](https://gist.github.com/flutterdevrelgists/d57c6c898dabb8c6fb41018588b8cf73) to learn more about how it works.

To expand the chat app, you could implement sign-in to identify who said what by adding Firebase Authentication. We plan to add many more Firebase features to expand what you can do with Firebase in DartPad.

## Supported packages

This first phase of the rollout supports a defined set of popular packages. To see what packages are available (and in what version), click the info icon at the lower right corner of the screen.

<DashImage src="images/0GiZCsPVISutlBMSG.png" />


## Give it a try!

Give DartPad package support a try today on [dartpad.dev](https://dartpad.dev), and share any [feedback](https://github.com/dart-lang/dart-pad/issues) with our team. We’ll continue to expand the list of supported packages over time. If you have any preference regarding which packages you’d like to see added, [search for the issue](https://github.com/dart-lang/dart-pad/issues) that contains the desired package name, and give it a 👍 “thumbs up” reaction. If there’s no issue for the package you want, please [create an issue](https://github.com/dart-lang/dart-pad/issues/new?template=everything-else.md) and put the package name in the title.

We hope package support on DartPad empowers you to build and showcase your Flutter designs, ideas, vignettes, and more. We can’t wait to see what you build next!