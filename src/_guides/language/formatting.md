---
title: Formatting code
description: Use `dart format` to format your code, and follow Effective Dart guidelines for what `dart format` doesn't cover.
toc: false
---

As [Effective Dart][] says, when it comes to things like formatting,
arguments about which is better are subjective and impossible to resolve.
What we do know is that being consistent is objectively helpful.
If two pieces of code look different it should be because
they _are_ different in some meaningful way.
When a bit of code stands out and catches your eye, it should do so for a useful reason.

Fortunately, you can use the [`dart format` tool][dart format]—from the 
command line or in your favorite [Dart-savvy IDE][ide]—to 
perform most of the drudge work of formatting your code.
For example, here's how to format all the Dart files
under the current directory's `bin`, `lib`, and `test` directories:

```terminal
$ dart format bin lib test
```

However, dart format can't do it all.
To avoid making changes that might be unsafe, `dart format` affects only whitespace.
For additional guidance, see the Effective Dart
[style guidelines][], especially the [formatting guidelines][]. 

More information:

* [`dart format`][dart format]
* [Effective Dart: Style][style guidelines]

[dart format]: /tools/dart-format
[Effective Dart]: /effective-dart
[formatting guidelines]: /effective-dart/style#formatting
[ide]: /tools/#ides-and-editors
[style guidelines]: /effective-dart/style
