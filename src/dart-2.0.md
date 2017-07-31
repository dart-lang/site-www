---
layout: default
permalink: /dart-2.0
title: Dart 2.0 Updates
description: How Dart 2.0 is different than 1.x, and how you can prepare.
---

This page has information about changes that are coming in Dart 2.0.

<aside class="alert alert-info" markdown="1">
**Flutter:** You don't need to do anything to prepare Flutter code for Dart 2.0.
If changes become necessary, watch this page for updates.
</aside>

Migration tips for:

* [Web](#migration-tips-web)
* [Servers and command-line scripts](#migration-tips-servers-and-command-line-scripts)

What's different in Dart 2.0:

* [Obsolete features](#obsolete features)
* [Strong mode and static typing](#strong-mode-and-static-typing)

## Migration tips: web

If you develop for the web, you can start migrating to Dart 2.0 now:

Convert your code to be strong mode compliant
: For more information,
  see [Strong mode and static typing](#strong-mode-and-static-typing) below.

Optimize the structure of your libraries
: Place library code that won't be _directly_ imported by your `web` code,
  or by other packages, under `lib/src`. For more information,
  see the documentation for [creating library
  packages.](/guides/libraries/create-library-packages)
  You can find examples of this directory structure in the [Stagehand
  templates.](https://github.com/google/stagehand/tree/master/templates)

{% comment %}
Save this section for when dartdevc is ready to use...
Adding strong mode support to the Dart analyzer (introduced in Dart 1.15),
made it possible to create a new development compiler,
[dartdevc]({{site.webdev}}/tools/dartdevc) (also known as _DDC_).
You can use dartdevc on strong mode-compliant
code to run and debug your Dart web apps in Chrome or other browsers.
With the introduction of dartdevc,
[Dartium](http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html)
will eventually be phased out.
{% endcomment %}

## Migration tips: servers and command-line scripts

If you develop servers or command-line scripts,
you can start migrating to Dart 2.0 now:

* Convert your code to be strong mode compliant. For more information,
  see [Strong mode and static typing](#strong-mode-and-static-typing) below.

## Obsolete features

The following features are redundant and will not be supported by Dart 2.0:

Checked mode
: Strong mode replaces checked mode. To learn how they are different, see
  [What is the difference between strong mode and checked
  mode?](/guides/language/sound-faq#how-is-it-different-than-checked-mode)

Dartium
: The [dartdevc]({{site.webdev}}/tools/dartdevc) compiler
  performs fast compiles to JavaScript,
  thanks to strong mode. Instead of Dartium, you’ll use Chrome
  or other standard browsers for testing. For information on
  Dartium's removal, see [A stronger Dart for
  everyone.](http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html)

## Strong mode and static typing

<aside class="alert alert-info" markdown="1">
**Note about Flutter:**
If you are developing for Flutter, you can skip this section.
Flutter is already strong mode compliant, which has helped the Flutter
team build their widgets and entire framework with Dart at scale.
</aside>

Dart 1.x is an optionally typed language, but types aren't optional in
Dart 2.0. With both static and runtime type checks, Dart 2.0 has a sound type system.

Thanks to [strong mode](/guides/language/sound-dart),
the Dart analyzer can find bugs earlier in the development cycle,
and types are checked at runtime.

<aside class="alert alert-info" markdown="1">
**A quick summary of the gnarly details:**
Dart 2.0 continues to support [type
inference](/guides/language/sound-dart#type-inference) and,
in many cases, infers a type. For example,
the following continues to be valid code in Dart 2.0:

<pre>
var i = 1;   // i is inferred to be int

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
`dynamic` and `num` take much of the burden of specifying types away
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

To use strong mode in Dart 1.x, [you must enable
it.](/guides/language/sound-dart#how-to-enable-strong-mode)
Note that runtime checks are not yet available unless you are developing
for the web and using [dartdevc]({{site.webdev}}/tools/dartdevc).


