---
title: Class modifiers for API maintainers
description: >-
 How to use the class modifiers added in Dart 3.0
 to make your package's API more robust and maintainable.
prevpage:
  url: /language/class-modifiers
  title: Class modifiers
nextpage:
  url: /language/modifier-reference
  title: Class modifiers reference
---

Dart 3.0 adds a few [new modifiers][class modifiers]
that you can place on class and [mixin declarations][mixin].
If you are the author of a library package,
these modifiers give you more control over what users are allowed to do
with the types that your package exports.
This can make it easier to evolve your package,
and easier to know if a change to your code may break users.

[class modifiers]: /language/class-modifiers
[mixin]: /language/mixins

Dart 3.0 also includes a [breaking change](/resources/dart-3-migration#mixin)
around using classes as mixins.
This change might not break *your* class,
but it could break *users* of your class.

This guide walks you through these changes
so you know how to use the new modifiers,
and how they affect users of your libraries.

## The `mixin` modifier on classes

The most important modifier to be aware of is `mixin`.
Language versions prior to Dart 3.0 allow any class to be used as a mixin
in another class's `with` clause, _UNLESS_ the class:

*   Declares any non-factory constructors.
*   Extends any class other than `Object`.

This makes it easy to accidentally break someone else's code,
by adding a constructor or `extends` clause to a class
without realizing that others are using it in a `with` clause.

Dart 3.0 no longer allows classes to be used as mixins by default.
Instead, you must explicitly opt-in to that behavior by declaring a `mixin class`:

```dart
mixin class Both {}

class UseAsMixin with Both {}
class UseAsSuperclass extends Both {}
```

If you update your package to Dart 3.0 and don't change any of your code,
you may not see any errors.
But you may inadvertently break users of your package
if they were using your classes as mixins.

### Migrating classes as mixins

If the class has a non-factory constructor, an `extends` clause,
or a `with` clause, then it already can't be used as a mixin.
Behavior won't change with Dart 3.0; 
there's nothing to worry about and nothing you need to do.

In practice, this describes about 90% of existing classes.
For the remaining classes that can be used as mixins,
you have to decide what you want to support.

Here are a few questions to help decide. The first is pragmatic:

*   **Do you want to risk breaking any users?** If the answer is a hard "no",
    then place `mixin` before any and all classes that
    [could be used as a mixin](#the-mixin-modifier-on-classes).
    This exactly preserves the existing behavior of your API.

On the other hand, if you want to take this opportunity to rethink the
affordances your API offers, then you may want to *not* turn it into a `mixin
class`. Consider these two design questions:

*   **Do you want users to be able to construct instances of it directly?**
    In other words, is the class deliberately not abstract?

*   **Do you *want* people to be able to use the declaration as a mixin?**
    In other words, do you want them to be able to use it in `with` clauses?

If the answer to both is "yes", then make it a mixin class. If the answer to
the second is "no", then just leave it as a class. If the answer to the first
is "no" and the second is "yes", then change it from a class to a mixin
declaration.

The last two options, leaving it a class or turning it into a pure mixin,
are breaking API changes. You'll want to bump the major version of your package
if you do this.

## Other opt-in modifiers

Handling classes as mixins is the only critical change in Dart 3.0
that affects the API of your package. Once you've gotten this far,
you can stop if you don't want to make other changes
to what your package allows users to do.

Note that if you do continue and use any of the modifiers described below,
it is potentially a breaking change to your package's API which necessitates
a major version increment.

## The `interface` modifier

Dart doesn't have a separate syntax for declaring pure interfaces.
Instead, you declare an abstract class that happens to contain only
abstract methods.
When a user sees that class in your package's API,
they may not know if it contains code they can reuse by extending the class,
or whether it is instead meant to be used as an interface.

You can clarify that by putting the [`interface`](/language/class-modifiers#interface)
modifier on the class.
That allows the class to be used in an `implements` clause,
but prevents it from being used in `extends`.

Even when the class *does* have non-abstract methods, you may want to prevent
users from extending it.
Inheritance is one of the most powerful kinds of coupling in software,
because it enables code reuse.
But that coupling is also [dangerous and fragile][].
When inheritance crosses package boundaries,
it can be hard to evolve the superclass without breaking subclasses.

[dangerous and fragile]: https://en.wikipedia.org/wiki/Fragile_base_class

Marking the class `interface` lets users construct it (unless it's [also marked
`abstract`](/language/class-modifiers#abstract-interface))
and implement the class's interface,
but prevents them from reusing any of its code.

When a class is marked `interface`, the restriction can be ignored within
the library where the class is declared.
Inside the library, you're free to extend it since it's all your code
and presumably you know what you're doing.
The restriction applies to other packages,
and even other libraries within your own package.

## The `base` modifier

The [`base`](/language/class-modifiers#base)
modifier is somewhat the opposite of `interface`.
It allows you to use the class in an `extends` clause,
or use a mixin or mixin class in a `with` clause.
But, it disallows code outside of the class's library
from using the class or mixin in an `implements` clause.

This ensures that every object that is an instance
of your class or mixin's interface inherits your actual implementation.
In particular, this means that every instance will include
all of the private members your class or mixin declares.
This can help prevent runtime errors that might otherwise occur.

Consider this library:

```dart
// a.dart
class A {
  void _privateMethod() {
    print('I inherited from A');
  }
}

void callPrivateMethod(A a) {
  a._privateMethod();
}
```

This code seems fine on its own,
but there's nothing preventing a user from creating another library like this:

```dart
// b.dart
import 'a.dart';

class B implements A {
  // No implementation of _privateMethod()!
}

main() {
  callPrivateMethod(B()); // Runtime exception!
}
```

Adding the `base` modifier to the class can help prevent these runtime errors.
As with `interface`, you can ignore this restriction
in the same library where the `base` class or mixin is declared.
Then subclasses in the same library
will be reminded to implement the private methods.
But note that the next section *does* apply:

### Base transitivity

The goal of marking a class `base` is to ensure that
every instance of that type concretely inherits from it.
To maintain this, the base restriction is "contagious".
Every subtype of a type marked `base` -- *direct or indirect* --
must also prevent being implemented.
That means it must be marked `base`
(or `final` or `sealed`, which we'll get to next).

Applying `base` to a type requires some care, then.
It affects not just what users can do with your class or mixin,
but also the affordances *their* subclasses can offer.
Once you've put `base` on a type, the whole hierarchy under it
is prohibited from being implemented.

That sounds intense, but it's how most other programming languages
have always worked.
Most don't have implicit interfaces at all,
so when you declare a class in Java, C#, or other languages,
you effectively have the same constraint.

## The `final` modifier

If you want all of the restrictions of both `interface` and `base`,
you can mark a class or mixin class [`final`](/language/class-modifiers#final).
This prevents anyone outside of your library from creating
any kind of subtype of it:
no using it in `implements`, `extends`, `with`, or `on` clauses.

This is the most restrictive for users of the class.
All they can do is construct it (unless it's marked `abstract`).
In return, you have the fewest restrictions as the class maintainer.
You can add new methods, turn constructors into factory constructors, etc.
without worrying about breaking any downstream users.

## The `sealed` modifer

The last modifier, [`sealed`](/language/class-modifiers#sealed), is special.
It exists primarily to enable [exhaustiveness checking][] in pattern matching.
If a switch has cases for every direct subtype of a type marked `sealed`,
then the compiler knows the switch is exhaustive.

[exhaustiveness checking]: /language/branches#exhaustiveness-checking

```dart
// amigos.dart
sealed class Amigo {}
class Lucky extends Amigo {}
class Dusty extends Amigo {}
class Ned extends Amigo {}

String lastName(Amigo amigo) =>
    switch (amigo) {
      case Lucky _ => 'Day';
      case Dusty _ => 'Bottoms';
      case Ned _   => 'Nederlander';
    }
```

This switch has a case for each of the subtypes of `Amigo`.
The compiler knows that every instance of `Amigo` must be an instance of one
of those subtypes, so it knows the switch is safely exhaustive and doesn't
require any final default case.

For this to be sound, the compiler enforces two restrictions:

1.  The sealed class can't itself be directly constructible.
    Otherwise, you could have an instance of `Amigo` that isn't
    an instance of *any* of the subtypes.
    So every `sealed` class is implicitly `abstract` too.

2.  Every direct subtype of the sealed type must be in the same library
    where the sealed type is declared.
    This way, the compiler can find them all. It knows that there aren't
    other hidden subtypes floating around that would not match any of the cases.

The second restriction is similar to `final`.
Like `final`, it means that a class marked `sealed` can't be directly
extended, implemented, or mixed in outside of the library where it's declared.
But, unlike `base` and `final`, there is no *transitive* restriction:

```dart
// amigo.dart
sealed class Amigo {}
class Lucky extends Amigo {}
class Dusty extends Amigo {}
class Ned extends Amigo {}

// other.dart

// This is an error:
class Bad extends Amigo {}

// But these are both fine:
class OtherLucky extends Lucky {}
class OtherDusty implements Dusty {}
```

Of course, if you *want* the subtypes of your sealed type
to be restricted as well, you can get that by marking them
using `interface`, `base`, `final`, or `sealed`.

### `sealed` versus `final`

If you have a class that you don't want users to be able to directly subtype,
when should you use `sealed` versus `final`?
A couple of simple rules:

*   If you want users to be able to directly construct instances of the class,
    then it *can't* use `sealed` since sealed types are implicitly abstract.

*   If the class has no subtypes in your library, then there's no point in using
    `sealed` since you get no exhaustiveness checking benefits.

Otherwise, if the class does have some subtypes that you define,
then `sealed` is likely what you want.
If users see that the class has a few subtypes, it's handy to be able
to handle each of them separately as switch cases
and have the compiler know that the entire type is covered.

Using `sealed` does mean that if you later add another subtype to the library,
it's a breaking API change.
When a new subtype appears,
all of those existing switches become non-exhaustive
since they don't handle the new type.
It's exactly like adding a new value to an enum.

Those non-exhaustive switch compile errors are *useful* to users
because they draw the user's attention to places in their code
where they'll need to handle the new type.

But it does mean that whenever you add a new subtype, it's a breaking change.
If you want the freedom to add new subtypes in a non-breaking way,
then it's better to mark the supertype using `final` instead of `sealed`.
That means that when a user switches on a value of that supertype,
even if they have cases for all of the subtypes,
the compiler will force them to add another default case.
That default case will then be what is executed if you add more subtypes later.

## Summary

As an API designer,
these new modifiers give you control over how users work with your code,
and conversely how you are able to evolve your code without breaking theirs.

But these options carry complexity with them:
you now have more choices to make as an API designer.
Also, since these features are new,
we still don't know what the best practices will be.
Every language's ecosystem is different and has different needs.

Fortunately, you don't need to figure it out all at once.
We chose the defaults deliberately so that even if you do nothing,
your classes mostly have the same affordances they had before 3.0.
If you just want to keep your API the way it was,
put `mixin` on the classes that already supported that, and you're done.

Over time, as you get a sense of where you want finer control,
you can consider applying some of the other modifiers:

*   Use `interface` to prevent users from reusing your class's code
    while allowing them to re-implement its interface.

*   Use `base` to require users to reuse your class's code
    and ensure every instance of your class's type is an instance
    of that actual class or a subclass.

*   Use `final` to completely prevent a class from being extended.

*   Use `sealed` to opt in to exhaustiveness checking on a family of subtypes.

When you do, increment the major version when publishing your package,
since these modifiers all imply restrictions that are breaking changes.
