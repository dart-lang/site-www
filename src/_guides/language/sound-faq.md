---
layout: guide
title: "Sound Dart FAQ"
description: "Questions and answers on how and why to write sound Dart code."
toc: false
---

This page collects some questions and answers about why and how to
write sound Dart code. Be sure to also check out the
[Sound Dart Guide](/guides/language/sound-dart) to learn more about
writing sound Dart code.

### What is "strong mode" ? Is it the same as “sound Dart”?

“Sound Dart”, “strong mode Dart” and “type safe Dart” are sometimes
used interchangeably. Strong mode is Dart’s implementation of a
sound type system. With strong mode enabled, Dart is a type safe language.
A sound language ensures that static type annotations are actually
correct at runtime. Strong mode is an optional mode that you enable in
Dart Analyzer, and we encourage you to start using strong mode for your
libraries and apps. For more information,
see [Sound Dart Guide](/guides/language/sound-dart).

### Why did the Dart team build strong mode?

New tools in development for the Dart language rely on ahead-of-time (AOT)
compilation. AOT compiling benefits significantly from strong type
checking that can be performed at compile time. Strong mode enables
the Dart team to build tools that make for a better development experience.
Also, our developers have told us that they prefer more feedback from
their type system, to help them manage larger code bases and better
understand their code.

### How does strong mode benefit me, the developer?

Strong mode helps you find more bugs at compile time, rather than runtime.
Also, refactoring tools and code completion work better with strong mode.

### How does strong mode benefit my users?

Code that is easier to develop, maintain, and debug is ultimately also
better for your users. It ensures that you catch more bugs before you ship!
In future, sound Dart will allow our compilers to generate smaller,
faster code.

### Yikes, another mode for Dart! So confusing! Why do I need this?

The Dart team is exploring ways of unifying checked mode and
strong mode to simplify things in the future.

### Is strong mode specified? If so, where is the spec?

The strong mode spec has not yet been published. However, the
[Sound Dart Guide](/guides/language/sound-dart) has more information
with links under
[Other references](/guides/language/sound-dart#other-resources)
to docs written by the Dart language team.

### Is strong mode "done" or are there still changes to come?

There may be further changes, but the bulk of the work for strong mode is
done. For example, generic methods have been added to Dart to make it
easier to write sound code. We try to keep changes to a minimum,
particularly breaking changes, and to let developers know well in advance.
For more information on using generic methods now, see
[Using generic methods](/guides/language/language-tour#using-generic-methods).

### What changed in strong mode from Dart's "classic mode"?

Only a few rules have been added to make Dart a sound language.
Primarily, you must learn the rules for when you can substitute a
type with its subtype or supertype. You must use the proper return
types and input parameter types when overriding methods.
Finally, you should never “hide” other types in a dynamic collection
or dynamic instance. See
[Sound type system](sound-dart-guide#sound-type-system)
for an explanation of these changes.

### Can I use strong mode today?

Yes! Strong mode is enforced by Dart Analyzer and can be enabled today.
For more information, see
[How to enable strong mode](sound-dart-guide#how-to-enable-strong-mode).

### How do I use strong mode today?

For information on using strong mode today, see
[How to enable strong mode](sound-dart-guide#how-to-enable-strong-mode).

### Does strong mode affect the runtime behavior of my code?

Strong mode hasn’t affected the runtime behavior for the Dart VM or dart2js.
Strong mode may affect the runtime behavior in DDC if it inserts
runtime type checks to deal with the remaining dynamism in the language.
For more information, see
[Runtime checks](/guides/language/sound-dart#runtime-checks) and
[Strong Mode in the Dart Dev Compiler](https://chromium.googlesource.com/external/github.com/dart-lang/dev_compiler/+/refs/heads/master/doc/RUNTIME_SAFETY.md).

### Does strong mode include type inference?

Yes. The analyzer infers types whenever possible. For more information,
see [Type inference](sound-dart-guide#type-inference).

### Is strong mode a "sound type system" ?

A sound type system guarantees that the types specified in the source
code are the types that show up at runtime. Strong mode is part of
Dart’s implementation of a sound type system. For more information, see
[What constitutes strong mode](/guides/language/sound-dart#what-constitutes-strong-mode).

### Does the analyzer know anything about strong mode?

Yes. Dart Analyzer performs type inference and enforces strong mode.

### Does dart2js know anything about strong mode?

Not yet. Currently, Dart Dev Compiler (DDC) is the only compiler that
uses strong mode, but it will be coming to other tools.

### Does the Dart VM know anything about strong mode?

Not yet. See the answer to the previous question.

### Does DDC know anything about strong mode?

Yes, DDC requires strong mode compliance to perform ahead-of-time compiling.
It is part of the improved tooling experience
including incremental compiles that is under development.

### Is Dart still optionally typed?
Strong mode is optional, so you can continue to write Dart code as before.
However, there are many benefits to sound code, such as finding bugs
at compile time rather than runtime. For more information, see
[The benefits of soundness](/guides/language/sound-dart#the-benefits-of-soundness).

### What is the difference between strong mode and checked mode?

Checked mode performs limited type checking but doesn’t guarantee that
an expression evaluates to a specific type at runtime.
Strong mode performs stronger type checking. For more information, see
[Strong mode vs. checked mode](/guides/language/sound-dart#strong-mode-vs-checked-mode).

### How much work is it to switch to strong mode?

Developers at Google have migrated tens of thousands of lines of
Dart to strong mode. Many of the changes involved adding annotations
to Maps and Lists. Often, making code strong mode clean is a matter
of making good use of generic methods. Finally, code that uses dynamic
types to hold other types must be cleaned up.

### Can some of my code in my app/library be strong mode, and other code be not-strong-mode?

You can exclude files from static analysis. For more information, see
[Excluding files](/guides/language/analysis-options#excluding-files).
However, if you are using DDC, the code must be entirely strong mode clean.

### Are the Dart core libraries compliant with strong mode?

Yes, as of version 1.21.

### Are the packages produced by the Dart team compliant with strong mode?

Many packages have been updated to be strong mode compliant and more
are in the works. Please file an issue against a package that you use
but isn’t yet strong mode compliant.

### What happens if I write strong mode code, but I use packages that are not compliant with strong mode?

Other packages are excluded from static analysis by default. You have
to specify `--show-package-warnings` to see errors in other packages.
As for executing code, the dart2js and Dart VM tools don’t currently
support strong mode so, yes, you can mix and match.
DDC requires strong mode compliance and won’t compile code that is unsound.

### Is strong mode Dart's new type system?

Strong mode is part of the implementation of Dart’s new type system,
which is currently under development. For more information, see
[What constitutes strong mode](/guides/language/sound-dart#what-constitutes-strong-mode).

### Is Dart going to turn into a verbose, cumbersome language where I have to put types everywhere?

No! Strong mode Dart continues to allow `var` and `dynamic` with type
inference in many places. Whenever possible, the analyzer infers a type.
When the analyzer can’t infer a type,
it generates an error and the type must be explicitly defined.

### I liked Dart before. Can I still write Dart code the way I always did?

Yes, you can write Dart code as before because strong mode is optional.
