---
layout: default
permalink: /dart-2
title: Dart 2 Updates
description: How Dart 2 is different from Dart 1.x, and how you can convert your code to work with Dart 2.
---

This page has information about changes in Dart 2,
and how you can migrate your code from Dart 1.x and
older 2.0.0-dev releases.

<aside class="alert alert-warning" markdown="1">
**Dart 2 is still landing.**
For information about what to expect, see the
[Dart 2 changes][] section of the
[Dart Language Specification][] page.
For a complete list of committed (but not necessarily released)
changes, see the
[dart-lang/sdk CHANGELOG.][dart-lang/sdk CHANGELOG]
</aside>

* Migration tips
  * [Flutter](#migration-tips-flutter)
  * [Web](#migration-tips-web)
  * [Servers and command-line scripts](#migration-tips-servers-and-command-line-scripts)
  * [Packages](#migration-tips-packages)
* [Testing with Dart 2 pre-releases](#testing)
* Dart 2 differences
  * [Obsolete features](#obsolete-features)
  * [Strong mode and static typing](#strong-mode-and-static-typing)
* [Resources](#resources)


## Migration tips: Flutter

See the [detailed instructions on the Flutter Wiki](https://github.com/flutter/flutter/wiki/Trying-the-preview-of-Dart-2-in-Flutter).

## Migration tips: web

If you develop for the web, you can start migrating to Dart 2 now:

Convert your code to be strong mode compliant.
: For more information,
  see [Strong mode and static typing](#strong-mode-and-static-typing), below.

Optimize the structure of your libraries.
: Place library code that won't be _directly_ imported by your `web` code,
  or by other packages, under `lib/src`. For more information, see the
  documentation for [creating library packages.][creating library packages]
  You can find examples of this directory structure in the
  [Stagehand templates.][Stagehand templates]

{% comment %}
Save this section for when dartdevc is ready to use...
Adding strong mode support to the Dart analyzer,
made it possible to create a new development compiler,
[dartdevc][] (also known as _DDC_).
You can use dartdevc on strong mode-compliant
code to run and debug your Dart web apps in Chrome or other browsers.
With the introduction of dartdevc,
[Dartium][Dartium news]
will eventually be phased out.
{% endcomment %}

## Migration tips: servers and command-line scripts

If you develop servers or command-line scripts,
you can start migrating to Dart 2 now:

Convert your code to be strong mode compliant.
: For more information, see [Strong mode and static
  typing](#strong-mode-and-static-typing), below.

## Migration tips: packages

As a package owner, you need to do the following:

* Follow the migration tips for the platforms that your package supports
  (see above).
* Make sure your package's users know how to report issues.
* Respond quickly to issue reports.
* If code changes aren't backward compatible,
  update the lower SDK constraint.


### Changes and backward compatibility

If you have to change your package's code,
**try to make it work in 1.x**, as well as Dart 2.
For example, you might be able to add type annotations
or (if an API has been removed) to use an alternative 1.x API.

If a backward-compatible change isn't possible,
**update the lower [SDK constraint.][SDK constraints]**

<aside class="alert alert-warning" markdown="1">
  **Specify SDK constraints carefully!**
  Incorrect lower constraints can cause problems for users of the stable SDK.
</aside>

[Test your changes][testing] to make sure that your package works as expected.


### Upper constraints on the SDK version

Don't update an already-published package
solely to indicate that it can be used with Dart 2 pre-releases.
As long as a package has either no [SDK constraints][]
or an upper constraint of `<2.0.0`,
`pub get` and similar pub commands in any Dart 2 pre-release
can download the package.
(The package won't be usable with Dart 2 stable releases,
but you can fix that later.)

When you update an existing package or publish a new one,
specify an upper constraint of `<2.0.0` for the SDK version. Examples:

```yaml
# Works in 1.20.1+; might work in 2.0.0-dev:
sdk: '>=1.20.1 <2.0.0'       

# Backward incompatible change requires at least 2.0.0-dev.1.2:
sdk: '>=2.0.0-dev.1.2 <2.0.0'
```

Eventually, you'll need to publish new versions of your packages to
declare Dart 2 compatibility, most likely using a `<3.0.0` SDK constraint.
Because incompatible changes might occur in any Dart 2 pre-release,
don't declare Dart 2 compatibility until we announce that it's safe to do so.

### Summary

If you publish packages, get ready for Dart 2:

* Make it easy for users to report issues.
* Respond quickly to issues.
* Avoid unnecessary incompatibility.
* Specify the correct SDK constraints.
* Test your packages.


## Testing with Dart 2 pre-releases {#testing}

To test your code with Dart 2, you can use a
[pre-release][]
of the Dart 2 SDK.

When running `pub get`, `pub upgrade`, or other pub commands
from a Dart 2 pre-release, you might get packages that
haven’t been verified to work with Dart 2.
If you find a package that has Dart 2 issues,
please report those issues immediately to the package maintainer,
and let the Dart community know about any workarounds you find.


## Obsolete features

The following features are redundant and won't be in Dart 2:

Checked mode
: Strong mode replaces checked mode. To learn how they differ, see
  [What is the difference between strong mode and checked
  mode?][strong vs checked]

Dartium
: The [dartdevc][] compiler
  performs fast compiles to JavaScript,
  thanks to strong mode. Instead of Dartium, you’ll use Chrome
  or other standard browsers for testing. For information on
  Dartium's removal, see [A stronger Dart for
  everyone.][Dartium news]

## Strong mode and static typing

In Dart 1.x, types are optional. You can remove all type annotations
from a Dart 1.x program without affecting its behavior.

In Dart 2, _types_ are mandatory,
but type _annotations_ are still optional.
When a type annotation is absent, tools infer the type.
With both static and runtime type checks,
Dart 2 has a sound type system.
This type system enables better tooling, as well as
clearer, earlier feedback when you write code.

You can prepare for Dart 2 by using Dart 1.x with
[strong mode][sound Dart].


<aside class="alert alert-info" markdown="1">
**A quick summary of the gnarly details:**
Dart 2 supports [type inference][]
and, in many cases, doesn't require type annotations. For example,
the following is valid code in both Dart 1.x and Dart 2:

<pre>
var i = 1;   // In Dart 2, inferred to be int;
             // previously, inferred to be dynamic.

dynamic x = 1;
x = "Hello";
</pre>

As the example shows, you can use the static `dynamic` type
to indicate that the runtime type is unknown.
One big difference between optionally typed Dart and Dart 2
is that, in the former, the analyzer infers the `dynamic` type.
In Dart 2, tools like the analyzer can often infer
types that are more specific than `dynamic`,
following rules in the language specification.

While Dart 2 is statically typed, type inference and
less precise types such as `dynamic` and `num`
take away much of the burden of specifying exact types.
Dart 2 has the advantages of a strongly typed language,
but requires only a bit more work than Dart 1.x.

To experiment with strong mode,
open [DartPad][]
and check the **Strong mode** box at the lower right.
</aside>

Migrate your code to strong mode, and you may identify some
lurking bugs that are now more easily identifiable and addressable.
You'll also find it much easier to transition to Dart 2.
For more information, see [A stronger Dart for everyone][Dartium news]
and [Strong Mode Dart.][sound Dart]

To use strong mode in Dart 1.x, [you must enable it.][enable strong mode]
Note that runtime checks are not yet available unless you are developing
for the web and using [dartdevc.][dartdevc]


## Resources

* General
  * [Strong mode Dart][sound Dart]
    * [Fixing common problems][Strong Mode Dart: Fixing Common Problems]
    * [FAQ][Strong Mode Dart: FAQ]
  * Dart SDK
    * [dart-lang/sdk CHANGELOG][]
    * [About SDK release channels and version strings][pre-release]
  * Pub and packages
    * [Creating library packages][creating library packages]
    * [pub.dartlang.org][]
    * [Pubspec format][pubspec format]
    * [SDK constraints][]
  * [Dart 2 changes][] section of the [Dart Language Specification][] page
  * [Dart testing][testing]
  * [Stagehand templates][]
{% comment %} update-for-dart-2
  * [DartPad][]
{% endcomment %}
* Flutter
  * [Installing Flutter][]
  * [Upgrading Flutter][]
* Web
  * [Dartium news][]
  * [dartdevc][]
  * [Doc preview of Angular 5.0][]
  * [angular-examples repos][] (see the 5-dev branches for the latest code)


[angular-examples repos]: https://github.com/angular-examples
[creating library packages]: /guides/libraries/create-library-packages
[Dart 2 changes]: /guides/language/spec#dart-2-changes
[Dart Language Specification]: /guides/language/spec
[dart-lang/sdk CHANGELOG]: https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#200
[dartdevc]: {{site.webdev}}/tools/dartdevc
[Dartium news]: http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html
[DartPad]: {{site.custom.dartpad.direct-link}}
[Doc preview of Angular 5.0]: https://webdev-dartlang-org-dev.firebaseapp.com/angular
[enable strong mode]: /guides/language/sound-dart#how-to-enable-strong-mode
[Installing Flutter]: {{site.flutter}}/setup/
[pre-release]: /install#about-sdk-release-channels-and-version-strings
[pub.dartlang.org]: {{site.pub}}
[pubspec format]: /tools/pub/pubspec
[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[sound Dart]: /guides/language/sound-dart
[Stagehand templates]: https://github.com/google/stagehand/tree/master/templates
[Strong Mode Dart: FAQ]: /guides/language/sound-faq
[Strong Mode Dart: Fixing Common Problems]: /guides/language/sound-problems
[strong vs checked]: /guides/language/sound-faq#how-is-it-different-than-checked-mode
[testing]: /guides/testing
[type inference]: /guides/language/sound-dart#type-inference
[Upgrading Flutter]: {{site.flutter}}/upgrading/
