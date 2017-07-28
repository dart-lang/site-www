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

Dart 1.x is an optionally typed language, but types aren't optional in
Dart 2.0. With both static and runtime type checks,
Dart 2.0 has a sound type system.

Thanks to [strong mode](/guides/language/sound-dart),
the Dart analyzer can find bugs earlier in the development cycle,
and types are checked at runtime.

<aside class="alert alert-info" markdown="1">
**A quick summary of the gnarly details:**
Dart 2.0 continues to support [type
inference](/guides/language/sound-dart#type-inference) and,
where possible, infers a type. For example,
the following continues to be valid code in Dart 2.0:

<pre>
var i = 1;

dynamic x = 1;
x = "Hello";
</pre>

As shown in the example, you can also continue to use the `dynamic` type.
While `dynamic` is itself a static type, it can contain any type at runtime.
Also, in Dart 2.0, a `num` can either be an
`int` or a `double` at runtime.
The main difference is that, in optionally-typed Dart, the analyzer
infers the `dynamic` type, but in Dart 2.0, both the analyzer and
the runtime try to infer something more specific than `dynamic`.

While Dart 2.0 is statically typed, type inference and types like
`dynamic` and `num`, take much of the burden of specifying types away
from the developer. Dart 2.0 offers the advantages of a strongly typed
language, while only requiring slightly more work compared to Dart 1.x.

To experiment with strong mode,
open [DartPad](https://dartpad.dartlang.org/)
and check the **Enable strong mode** box in the lower right.
</aside>

Migrate your code to strong mode now, and you may identify some
lurking bugs that are now more easily identifiable and addressable.
You'll also find it much easier to transition to Dart 2.0.
For more information, see [A stronger Dart for
everyone](http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html)
and [Strong Mode Dart.](/guides/language/sound-dart)

Flutter is already strong mode compliant, which has helped the Flutter
team build their widgets and entire framework with Dart at scale.
If you develop on Flutter, you are good to go.

### Web

Adding strong mode support to the Dart analyzer (introduced in Dart 1.15),
made it possible to create a new development compiler,
[dartdevc]({{site.webdev}}/tools/dartdevc) (also known as _DDC_).
You can use dartdevc on strong mode-compliant
code to run and debug your Dart web apps in Chrome or other browsers.
Dartdevc is available as of Dart 1.24, but doesn't
yet work with AngularDart apps. With the introduction of dartdevc,
[Dartium](http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html)
will eventually be phased out.

To use strong mode in Dart 1.x, [you must enable
it.](/guides/language/sound-dart#how-to-enable-strong-mode)
Note that runtime checks are not yet available unless you use dartdevc.

Other than strong mode, another coming change affects web developers:

* Optimize the [structure of your
  libraries](https://www.dartlang.org/guides/libraries/create-library-packages)
  for faster compilation speeds with dartdevc. Place library code that won't be
  _directly_ imported by your `web` code, or by other packages,
  under `lib/src`. You can do this now. The
  [Stagehand](https://github.com/google/stagehand/tree/master/templates)
  templates have already been updated to this directory structure.

### Mobile (Flutter)

The Flutter SDK is already strong mode compliant and developers using
Flutter should already be opted-into strong mode.
We have no other updates at this time.

### Servers and command line

Strong mode Dart is available as of Dart 1.15.
To use strong mode in Dart 1.x,
[you must enable it.](/guides/language/sound-dart#how-to-enable-strong-mode)
Note that runtime checks are not yet available in the Dart VM compiler.

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


