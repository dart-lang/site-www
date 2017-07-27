---
layout: default
permalink: /dart-2.0
title: Dart 2.0 Updates
description: How Dart 2.0 is different than 1.x, and how you can prepare.
---

This page has information about changes that are coming in Dart 2.0.
Some changes may not apply to your target platform.

* [Changes in Dart 2.0](#changes-in-dart-2.0)
  * [Web](#web)
  * [Mobile (Flutter)](#mobile-flutter)
  * [Servers and command line](#servers-and-command-line)
* [What's removed from Dart 2.0](#whats-removed-from-dart-2.0)

---

You can implement these changes now,
but keep watching this page for updates. We'll let you know what you can
do now, and what needs to wait for Dart 2.0.

## Changes in Dart 2.0

Dart 1.x is an optionally typed language, but static typing is required
in Dart 2.0. Strong mode helps you find bugs earlier.
You can migrate your code to strong mode now.
For more information, see [A stronger Dart for
everyone](http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html)
and [Strong Mode Dart.](/guides/language/sound-dart)

Flutter is already strong mode compliant, so this won't affect Flutter
developers.

### Web

Adding strong mode support to  the Dart analyzer (introduced in Dart 1.15),
made it possible to create a new development compiler,
[dartdevc]({{site.webdev}}/tools/dartdevc). To use strong mode in Dart 1.x,
[you must enable it.](/guides/language/sound-dart#how-to-enable-strong-mode)
It won't be optional in Dart 2.0.

You can use dartdevc (also known as DDC) on strong mode-compliant
code to run and debug your Dart web apps in Chrome.
Dartdevc is available as of Dart 1.24, but doesn't
yet work with AngularDart apps. With the introduction of dartdevc,
[Dartium](http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html)
will eventually be phased out.

Other than strong mode, another coming change affects web development:

* Optimize the [structure of your
  libraries](https://www.dartlang.org/guides/libraries/create-library-packages)
  for faster compilation speeds with dartdevc. Place library code that won't be
  _directly_ imported by your `web` code, or by other packages,
  under `lib/src`. You can do this now. The
  [Stagehand](https://github.com/google/stagehand/tree/master/templates)
  templates have already been updated to this directory structure.

### Mobile (Flutter)

The Flutter SDK is already strong mode compliant.
We have no other updates at this time.

### Servers and command line

Strong mode Dart is available as of Dart 1.15.
To use strong mode in Dart 1.x,
[you must enable it.](/guides/language/sound-dart#how-to-enable-strong-mode)
Migrate your code to strong mode now and you may find some bugs
in the process!

We have no other updates at this time.

## What's removed from Dart 2.0

The following features will be removed from Dart 2.0:

Dartium
: The dartdevc development compiler allows you to develop
  using Chrome or other modern browsers, making Dartium obsolete.

Checked mode
: Strong mode provides stronger type checking than checked mode,
  which will be retired.
