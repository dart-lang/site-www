---
title: Migrating to null safety
description: How to move your existing Dart code to the world of null safety
---

When we decided to add [null safety][] to Dart,
we wanted to get as much value out of it as possible.
That meant designing a fully sound system that guarantees
you will not see a null reference error.
This lets our compilers optimize code
knowing that `null` cannot flow into certain places.
The challenge is that the world's existing Dart code
is not designed for that level of strictness.
How do we give users sound null safety without
breaking all of the existing Dart code in the world?

[null safety]: /null-safety

Our answer is that we let you *migrate* your code to null safety
when *you* want to.
This document explains how that works,
and how to get your code into the new magical land of null safety.

## The goal

Our goal is that eventually the entire Dart ecosystem will
move all of their Dart code to null safety.
**Null unsafe** Dart code that doesn't use null safety
is still supported for compatibility but
is not a language we want users to be programming in forever.
We think null-safe Dart is a better language and
want everyone to eventually be using it.
At some point in the future,
anyone surveying the Dart landscape should not realize that
a null unsafe version of Dart ever existed.

That's the place we want to reach.
But we can't get there by breaking all of your code.
It's not enough for us to settle *ourselves* on a
new tropical island paradise.
We have to build a bridge to the one
you are all on and help you cross over.

## Language versioning

The fundamental tool we use to ship null safety without
breaking existing code is a feature we call **language versioning**.
Previously, Dart tools assumed that any Dart code they processed
may use all of the syntax and features supported by that version of the tool.

For example, if you use the [Dart 2.7.0 SDK][2.7],
the compiler assumes your code may contain extension methods,
even if you wrote it years before extension methods were added to the language.
This works fine when language changes are backwards compatible.
Adding support for extensions did not break any existing code,
so it was safe to treat older Dart code as "supporting" extension methods.
In other words, it's as if the Dart 2.7.0 SDK
*only* supports compiling and running Dart 2.7.0 code.
It just happens to be the case that all Dart code written prior to Dart 2.7.0
is also valid Dart 2.7.0 code and everything works out.

[2.7]: https://dart.dev/guides/language/evolution#dart-27

Assuming backwards compatibility does *not* work with
a change like null safety where the same Dart code today
means something different than it did in an earlier version of the language.
Before null safety, this was a perfectly valid Dart program:

```
main() {
  int i;
  print(i); // "null".
}
```

With null safety, this program has a compile-time error because
you're trying to access an uninitialized non-nullable variable.
If a Dart SDK supporting null safety treated
all null-unsafe Dart code as using null safety,
there would be breakage everywhere.

Our solution is that a single Dart SDK simultaneously supports
*multiple different versions of the Dart language*.
When you compile some Dart code,
the tool figures out what version of Dart the code is targeting.
If your program targets a version of Dart before null safety,
you get the old behavior and your existing code keeps working.
If your program targets the later null-safe version of Dart,
you opt in to the new type system and features.

It's sort of like how the monolithic GCC compiler can
compile code written in a number of different languages.
It figures out what language each file is written in and
compiles it appropriately.

### Language version numbers

Dart language versions are identified by a major and minor number that
match the first two components of the Dart SDK.
So, for example, the latest language version supported by
Dart SDK 2.7.3 is Dart 2.7.
We promise that each Dart SDK supports *all* of the language versions
covered by its major version number.
So Dart SDK 2.7.3 supports language 2.7, 2.6, 2.5, etc.
Until we ship Dart 3.0.0,
every SDK will continue to support null-unsafe code that
does *not* use null safety.

Since the language version is derived from the SDK version, it implies:

*   Whenever we ship a minor version of the SDK,
    a new language version appears.
    In practice, many of these language versions are
    very similar to and entirely compatible with previous versions.
    For example, Dart 2.9 (the language) is essentially identical to 2.8.

*   When we ship a patch version of the SDK,
    it cannot contain any backwards incompatible language changes.
    Since a patch SDK release (like 2.7.2) does not
    introduce a new language version (2.7) over
    the previous SDK (2.7.1, also language 2.7),
    there would be no way to avoid breaking user code if we did.

### Specifying language version

Every Dart SDK from 2.11.0 and later supports null safety.
But those SDKs also all still support older null-unsafe code.
To keep that code running, Dart just needs to know that the code is
targeting an older language version.
How do you tell the compiler that?

We wanted to make the process of pinning your code to a language version
as lightweight as possible.
We wouldn't want to, say, use a different file extension like `.dartx`
and make you rename every single one of your files
every time a new language version came out.
Instead, we build on top of what the tools already
know about the package containing your code.

Your [pubspec][] probably already has an [SDK constraint][] like:

[pubspec]: https://dart.dev/tools/pub/pubspec
[sdk constraint]: https://dart.dev/tools/pub/pubspec#sdk-constraints

```dart
environment:
  sdk: '>=2.6.0 <3.0.0'
```

Here, your package claims that it can be run using any Dart SDK
from 2.5.0 or later, until 3.0.0.
For that to be true, your package can't be using any features that
were introduced after 2.6.0.
If you used, say, extension methods (released in 2.7.0),
then your package wouldn't work if someone tried
to run it on a Dart 2.6.0 SDK,
which your own pubspec claims is supported.

Our tools are smart enough to understand
what that SDK constraint implies and
use that to infer a language version for the libraries in your package.
The rule is simple:
**The default Dart language version for a package is
the lowest language version covered by its SDK constraint.**
So, in this case, Dart tools assume the code in your package
is targeting Dart 2.6 and
won't let you use any features not supported by that version.

Almost every existing pubspec out there has an SDK constraint
whose range includes Dart SDKs prior to null safety.
Using those lower bounds to select the language version
automatically opts all of them out of null safety,
which keeps them running just as they did before.

### Language comment markers

Note that I said the *default* language version for code in your package.
Tools use your pubspec
(or more precisely, the package config file generated from your pubspec)
to select a language version when they
don't have any other more precise information.
**The SDK constraint is the main way you select
a language version for your package.**

But sometimes you don't want every file in your package
to be at the same language version.
You can override the package default on a per-library basis by
using a special comment, like this:

```dart
// @dart=2.5
```

A line comment starting with `@dart=` followed by a language version
tells Dart tools to process the library at that language version.
There are a couple of restrictions when using these markers:

*   This comment must be on a line by itself and
    must occur before any code in the file.
    It's OK to have other comments or blank lines before it.
    Since language versions may change syntax,
    we wouldn't a tool to have to parse some Dart code,
    *then* discover the language version marker and then
    potentially have to re-parse code it already parsed.

*   The comment applies to an entire *library*.
    If the library uses part files,
    they also *all* must have identical version comments.
    We require the redundant markers in all part files so that
    Dart tools that work on a per-file basis can
    still unambiguously determine what version a part file is at without
    having to find the corresponding library file.

*   The marker should only move the library to a *lower* language version than
    the default version specified by the pubspec.
    If you could opt a library into a version *higher* than the pubspec allows,
    you could get into a situation where a user of an older Dart SDK would
    attempt to use your package even though it contains libraries
    whose language version isn't supported by their SDK.

    For example, say your package's SDK constraint is `>=2.6.0 <3.0.0`,
    giving you a default language version of 2.6.
    Someone using Dart SDK 2.6.0 might be using your package.
    If you have a marker like `// @dart=2.5`,
    everything is fine because Dart SDK 2.6.0 also supports language 2.5.
    But if you were to try to put `// @dart=2.7` there,
    you would end up with a library whose version isn't supported
    by the 2.6.0 SDK the use has.

    In terms of null safety, this rule means
    you'll use the pubspec SDK constraint to
    opt your package *in* to null safety and
    can then use comment markers to
    opt individual libraries *out* if needed.

### New code and the default default language version

Dart doesn't require you to put all of your code inside a pub package,
though most Dart code is.
Pub also doesn't require your pubspec to have an SDK constraint.
In either of those cases, what language version do you get?

Since our goal is a world where all Dart code is modern and null safe,
you get the latest language version in this case.
That means if you sit down with a text editor,
make a brand new `.dart` file, and run it, you get null safety.
Add a pubspec and you're still using null safety.
Unless you write an SDK constraint that
explicitly opts you *out* of null safety,
we keep you in the new world.

When you start depending on other packages,
pub keeps you in that new world.
If your package is using null safety,
then pub tries to only give you packages that also use null safety.

## Mixed-mode programs

What if your null-safe app depends on a package that
isn't null safe?
More generally, what happens when your program contains
some libraries at a null-safe language version and
others that are using a null-unsafe language?
Is this allowed?

The answer is "yes".
We called these **mixed-mode programs.**
In the context of null safety,
this means a program can contain some libraries that
are null safe and some that aren't.

A mixed-mode program is still get a perfectly meaningful Dart program that
you can run and use.
Except for esoteric edge cases
(think `is` tests on instances of generic types from
closures that cross the boundary between unsafe and safe libraries),
it should do exactly what you expect.

This is very valuable because it lets you
*incrementally* migrate your program to null safety.
Critically, it means that packages you depend on
can migrate to null safety before you do.
You can even upgrade to those migrated null-safe versions before you migrate.
This frees package maintainers to migrate their code knowing that
even legacy users will still be able to take any
bug fixes or other improvements they ship.

### Unsound and sound null safety

Dart provides sound null safety through a combination of
static checks (compile-time errors) and
runtime checks (exceptions thrown from code like the `!` or `as` operators).
Each Dart library that opts in to null safety gets
all the static checks and stricter compile errors.
This is true even in a mixed-mode program containing
other null-unsafe libraries.
You immediately start getting static safety benefits
as soon as you start migrating some of your code to null safety.

However, we can't give you the same *runtime* soundness guarantees
in a mixed-mode program that we can give you in a fully null-safe application.
It is possible for `null` to leak out of the null-unsafe libraries
into the null-safe code.
Preventing that would break the existing behavior of the unmigrated code.
To maintain runtime compatibility with legacy libraries
while offering soundness to completely null-safe programs,
our tools support two modes:

*   When you run a mixed-mode program,
    it runs with **partial null-safety**.
    That means it is possible for `null` reference errors to occur at runtime,
    but only because a `null` or nullable type escaped from
    some null-unsafe library and got into your null-safe code.

*   Once your program is fully migrated and *all* libraries are null safe
    (in other words, you're no longer in mixed mode),
    then your program automatically runs with **sound null safety**.
    That mode gives you the full null safety experience with
    all of the guarantees and compiler optimizations that soundness enables.

The second mode is the mode you want if possible.
Our tools will automatically run your program in sound mode if
the main entrypoint library of your program has opted into null safety.
If they see that you import a null-unsafe library,
they'll print a warning to let you know that
they can only run with partial null safety.

## Migrating the easy way

That is a lot of background material to cover. Sorry.
You probably just want to start
using the new stuff and get better safety.
I don't blame you. I like the new features too.
But first, you need to make sure it's the right *time* to migrate.

### Waterfall migration

Before you migrate *your* code,
you should wait until all of the packages you depend on have been migrated.
We call this a "waterfall" migration.
Or maybe "bottom-up" depending on how you visualize your dependency graph.
You *can* migrate before a package you depend on does.
But when you do so, your null-safe code will be
calling into unsafe code in that package.
You will have to take a guess as to how you expect
that library to behave under null safety.
Do you think that function you're calling takes
a nullable parameter or a non-nullable one?

At some point in the future, that package will migrate and
you'll upgrade to the null-safe version of it.
If you guessed correctly in all the places you call into their API,
you're fine.
But if you guessed wrong, that upgrade will break your application.
For example, if you thought some function would take a nullable parameter but
they migrated it to be non-nullable,
you passing a nullable argument to it becomes a compile error.

To avoid having to "re-migrate" your code in places like this,
it's safest to wait until you have upgraded to
null-safe versions of all of your dependencies.
How do you tell?
We have a new command for that:

```sh
dart pub outdated --mode=null-safety
```

Run this and it will show you which packages you depend on
have null-safe versions and whether or not you are on them.
If it says you're ready to go,
then it's time to get started.

### The migration tool

It's your turn.
Fortunately, converting null-safe code to null-safe Dart is pretty easy.
Roughly 90% of your code won't need to change at all.
It's probably already correct
(your app isn't crashing all the time, right?)
and with the new [flow analysis][] we do,
the new type system is smart enough to see that too.

[flow analysis]: /null-safety/understanding-null-safety#flow-analysis

Even the code that does need some fixing often
only requires obvious mechanical changes.
If you have a variable that may contain `null`,
you just need to put a `?` on its type.
That named parameter that you don't want to be nullable
just needs to be marked `required`.
In fact, this process is *so* mechanical that
we have a tool that can do almost all of it for you,
with just a few hints on your part.

The Dart SDK ships with a new `migrate` command that
will take a package of null-unsafe Dart code and
convert it to null safety.
It analyzes all of your code.
For every variable, it looks to see how the variable is being used.
If methods are called on it, it's probably not nullable.
Does code check to see if the variable is equal to `null`?
Probably nullable then.

The migration tool propagates what it sees
throughout the rest of the program.
So if it sees an optional parameter (probably nullable)
get assigned to a variable (must be nullable too)
which is then passed to another function,
then that function's parameter is probably nullable too.
The migration tool also takes into account
the null-safe code your code accesses,
which is another reason it's better to wait until
your dependencies are migrated.

You run the migration tool like so:

```sh
dart migrate
```

That spins up a local web server with an interactive UI where you can guide the
process:

![Screenshot of migration tool](/null-safety/migrating-to-null-safety/migration-tool.png)

For every variable and type annotation,
you can see what nullability the tool inferred.
Clicking the type shows you a causality chain to see
why it came to that conclusion.
The analysis gets most things right,
but sometimes it gets confused,
especially in places where you do need to tweak your code to
play nicer with null safety.

In places where analysis infers the wrong nullability,
you can override its choice by inserting temporary `/*?*/` and `/*!*/` markers.
The migration tool's web UI can insert these for you with a click.
You can also switch back to your editor and change your code yourself,
even while the tool is still running.
Just tell it to re-run the analysis when you're done and
it will pick up your changes.
Remember when editing your code to not use new null safety features yet.
Your code is still null-unsafe for now.

Once you get to a point where you like all of the conclusions
the migration tool has come to&mdash;all of the
`?`, `required`, `!`, and other changes it wants to make&mdash;click
"Apply" to tell it to actually save out all of those changes to disk.
Congratulations, your package is migrated!
Now is a good time to run your tests and
make sure everything is behaving as expected.

## Migrating manually

If you prefer a more meticulous, hands-on approach,
you don't have to use the migration tool.
Manual migration can be the right choice if you
want to migrate your package incrementally.
Since Dart supports mixed-mode programs,
you can migrate a library at a time,
while still being able to run your app and its tests
to see what kind of progress you're making.

To do a manual migration, first set your package's minimum SDK constraint
to the null-safe version:

```yaml
environment:
  sdk: >=2.11.0 <3.0.0
```

The run `pub get`.
This generates a [package config][] that
sets the default language version of every library in your package to 2.11.
That opts them all *in* to null safety.
Since you haven't migrated those libraries yet,
that's not what you want.
Next, add a language version comment to the top of every file:

[package config]: https://pub.dev/packages/package_config


```dart
// @dart=2.10
```

This opts every single library back *out* of null safety.
You're right back where you started, which doesn't seem very useful.
But now you can *remove* those comments one a time.
Pick a library to migrate, remove the comment, and
fix any static errors that appear.
Make whatever changes you need to turn the library into
clean, null-safe Dart code.
Sprinkle `?` and `late` as necessary.

Once that library is error-free,
you can run your tests and see if it's working.
If so, move on to the next library.
You can keep working your way through the libraries incrementally like this,
running the tests or trying out your app whenever
you reach a point where there are no static errors.

Just like with package dependencies,
you'll probably want to migrate your libraries "bottom up".
Try not to migrate a library until after
you've migrated the other libraries it imports.
If there are cyclic imports,
you may want to migrate a batch of libraries together.
It's up to you.

## Versioning migrated packages

If your package is uploaded to pub,
now is a good time to publish it.
How should you increment your package's version number?
It is *technically* possible to migrate a package to null safety
in a way that is very unlikely to break any
non-migrated existing users of that package.
But threading that needle is challenging.
Also, it's pretty common to make API changes in the process of migrating.
Maybe instead of making some optional parameter nullable,
you would rather make it required.
That's a breaking API change.

The safest approach is to treat the migrated version of your package as
a breaking change.
That means bumping the major version if your package is
already at 1.0.0 or greater.
If your package hasn't reached 1.0.0 yet,
then bump the minor version.

## Welcome to null safety

If you made it this far,
you should have a fully migrated null-safe Dart package.
If all of the packages you depend on are migrated too,
your program is fully sound with respect to null reference errors.
That's a good feeling.

From all of the Dart team, *thank you* for migrating your code.
We know it can be a lot of work that takes time away from
adding user-visible features or fixing bugs.
But migrating your code gets the entire ecosystem closer to full null safety.
Once we reach that point (or get close enough to it),
we can remove support for legacy null-unsafe Dart from our tools and
ship Dart 3.0.0.
That simplification lets us evolve the language and
improve our tools more quickly,
which directly benefits you.
