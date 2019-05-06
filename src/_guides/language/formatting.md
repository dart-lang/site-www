---
title: Formatting code
description: Use dartfmt to format your code, and follow Effective Dart guidelines for what dartfmt doesn't cover.
toc: false
---

As [Effective Dart][] says, when it comes to things like formatting,
arguments about which is better are subjective and impossible to resolve.
What we do know is that being consistent is objectively helpful.
If two pieces of code look different it should be because
they _are_ different in some meaningful way.
When a bit of code stands out and catches your eye, it should do so for a useful reason.

Fortunately, you can use the [dartfmt tool][dartfmt] —
from the command line or in your favorite [Dart-savvy IDE][ide] —
to perform most of the drudge work of formatting your code.
For example, here's how to format all the Dart files
under the current directory's `bin`, `lib`, and `test` directories:

```terminal
$ dartfmt -w bin lib test
```

However, dartfmt can't do it all.
To avoid making changes that might be unsafe, dartfmt affects only whitespace.
For additional guidance, see the Effective Dart
[style guidelines][], especially the [formatting guidelines][]. 

More information:

* [dartfmt][dartfmt]
* [Effective Dart: Style][style guidelines]

[dartfmt]: /tools/dartfmt
[Effective Dart]: /guides/language/effective-dart
[formatting guidelines]: /guides/language/effective-dart/style#formatting
[ide]: /tools/#ides-and-editors
[style guidelines]: /guides/language/effective-dart/style
