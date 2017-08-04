---
layout: default
permalink: /dart-2.0
title: Dart 2.0 Updates
description: How Dart 2.0 is different than Dart 1.x, and how you can prepare.
---

This page has information about changes that are coming in Dart 2.0,
and how you can migrate your code from Dart 1.x:

* [Migration tips: web](#migration-tips-web)
* [Migration tips: servers and command-line scripts](#migration-tips-servers-and-command-line-scripts)

<aside class="alert alert-info" markdown="1">
**Flutter note:** You don't need to do anything to prepare Flutter code
for Dart 2.0. If changes become necessary,
we'll add Flutter details to this page.
</aside>

Here's what's different in Dart 2.0:

* [Obsolete features](#obsolete-features)
* [Strong mode and static typing](#strong-mode-and-static-typing)

## Migration tips: web

If you develop for the web, you can start migrating to Dart 2.0 now:

Convert your code to be strong mode compliant.
: For more information,
  see [Strong mode and static typing](#strong-mode-and-static-typing), below.

Optimize the structure of your libraries.
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

Convert your code to be strong mode compliant.
: For more information, see [Strong mode and static
  typing](#strong-mode-and-static-typing), below.

## Obsolete features

The following features are redundant and won't be in Dart 2.0:

Checked mode
: Strong mode replaces checked mode. To learn how they differ, see
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

Dart 1.x is an optionally typed language, but types aren't optional in
Dart 2.0. With both static and runtime type checks, Dart 2.0 has a sound type system.

Thanks to [strong mode](/guides/language/sound-dart),
the Dart analyzer can find bugs earlier in the development cycle,
and types are checked at runtime.

<aside class="alert alert-info" markdown="1">
**A quick summary of the gnarly details:**
Dart 2.0 continues to support [type
inference](/guides/language/sound-dart#type-inference) and,
in many cases, doesn't require type annotations. For example,
the following is valid code in both Dart 1.x and Dart 2.0:

<pre>
var i = 1;   // In 2.0, inferred to be int;
             // previously, inferred to be dynamic.

dynamic x = 1;
x = "Hello";
</pre>

As the example shows, you can use the static `dynamic` type
to indicate that the runtime type is unknown.
One big difference between optionally typed Dart and Dart 2.0
is that, in the former, the analyzer infers the `dynamic` type.
In Dart 2.0, both the analyzer and
the runtime try to infer something more specific than `dynamic`.

While Dart 2.0 is statically typed, type inference and types like
`dynamic` and `num` (which can be `int` or `double`)
take away much of the burden of specifying types.
Dart 2.0 has the advantages of a strongly typed language,
but requires only a bit more work than Dart 1.x.

To experiment with strong mode,
open [DartPad](https://dartpad.dartlang.org/)
and check the **Strong mode** box at the lower right.
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
for the web and using [dartdevc.]({{site.webdev}}/tools/dartdevc)


