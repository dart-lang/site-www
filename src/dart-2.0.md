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
* [Removed from Dart 2.0](#removed-from-dart-2.0)

---

You can implement these changes now,
but keep watching this page for updates. We'll let you know what you can
do now, and what needs to wait for Dart 2.0.

## Changes in Dart 2.0

Dart 1.x is an optionally typed language, but Dart 2.0 requires static types.
Thanks to [strong mode](/guides/language/sound-dart),
the Dart analyzer can find bugs earlier in the development cycle.
The analyzer is smart about types and can sometimes
[infer](/guides/language/sound-dart#type-inference) a type,
so you don't have to manually type every variable.

Migrate your code to strong mode now, and you may find some bugs in the
process! You'll also find it much easier to transition to Dart 2.0.
For more information, see [A stronger Dart for
everyone](http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html)
and [Strong Mode Dart.](/guides/language/sound-dart)

Flutter is already strong mode compliant, which contributes to Flutter's
fast development cycle. If you develop on Flutter, you are good to go.

### Web

Adding strong mode support to the Dart analyzer (introduced in Dart 1.15),
made it possible to create a new development compiler,
[dartdevc]({{site.webdev}}/tools/dartdevc). To use strong mode in Dart 1.x,
[you must enable it.](/guides/language/sound-dart#how-to-enable-strong-mode)
It won't be optional in Dart 2.0.

You can use dartdevc (also known as _DDC_) on strong mode-compliant
code to run and debug your Dart web apps in Chrome or other browsers.
Dartdevc is available as of Dart 1.24, but doesn't
yet work with AngularDart apps. With the introduction of dartdevc,
[Dartium](http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html)
will eventually be phased out.

Other than strong mode, another coming change affects web developers:

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

We have no other updates at this time.

## Removed from Dart 2.0

The following features are removed from Dart 2.0:

Checked mode
: Strong mode replaces checked mode. To learn how they are different, see
  [What is the difference between strong mode and checked
  mode?](/guides/language/sound-faq#how-is-it-different-than-checked-mode)

Dartium
: The dartdevc compiler performs fast compiles to JavaScript,
  thanks to strong mode. Instead of Dartium, you’ll use Chrome
  or other standard browsers for testing. For information on
  Dartium's removal, see [A stronger Dart for
  everyone.](http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html)


