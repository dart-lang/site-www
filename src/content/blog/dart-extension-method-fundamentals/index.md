---
title: "Dart extension method fundamentals"
description: "Read about the design considerations behind extension methods, a new feature landing in a future Dart SDK release"
publishDate: 2019-11-05
author: lrhn
image: images/1D57vLbx-SwCUSnLXA9zHRQ.png
category: other
tags:
  - dartlang
  - programming-languages
  - extension-method
layout: blog
---


## Dart Extension Methods Fundamentals

<DashImage src="images/1D57vLbx-SwCUSnLXA9zHRQ.png" />


In a future release, the Dart language is adding a new feature, *extension methods*, which allows you to (pretend to) add new members to existing types. An extension method can be invoked just like a normal method, `o.extensionMethod(42)`, even though it really is just a static function.

Why are we adding extension methods? What are they good for? How do you use them? And why do I call them “extension *methods*” when you can add other members too? (The last one is easy: I personally think of them as extension *members*, but “extension methods” was the working title, and it’s what the similar feature is called in other languages, so in good Dart tradition, we went for the familiar and unsurprising name. I won’t be needing extension getters, setters or operators here, but you can totally add a `%` operator to `String` if you want to, no matter what we call the feature.)

Since I’m one of the people who designed the feature, I’ll opportunistically answer all these questions before anyone else has a chance. (And, because I released this article before we finished the feature, I’ve even gotten to edit out the things that are no longer true!)

But first, a detour!

## What I Would Have Done Before Extension Methods

Assume, purely hypothetically, that I think the [`catchError`](https://api.dartlang.org/stable/2.5.0/dart-async/Future/catchError.html) function on [`Future`](https://api.dartlang.org/stable/2.5.0/dart-async/Future-class.html) is awful and should be replaced by something newer, shinier and better. Say, because it takes a[`Function`](https://api.dartlang.org/stable/2.5.0/dart-core/Function-class.html) as argument instead of a proper function type, which it does for perfectly reasonable *historical* reasons, and that means you won’t get any static type checking. That is bad, and the method should feel bad.

Obviously I can’t remove the function, that would break, like, every serious Dart program *ever*.

Then I’d want to at least add a new method to `Future&lt;T&gt;` so that users can use that one instead, say one like:

```dart
abstract class Future<T> {
  ...
  /// Catches any [error] of type [E].
  Future<T> onError<E>(FutureOr<T> handleError(E error, StackTrace stack)) =>
      this.catchError(...something clever...);
}
```

which you can call as:

```dart
Future<int> eventualInteger = ...;
eventualInteger.onError((FormatException e, s) => ...).then(...);
```

Sadly, I can’t just add that to the `Future` class. If I do that, I also add it to the `Future` interface, and any other class implementing that interface will then be incomplete and will no longer compile. At some point we counted 76 classes implementing `Future`. That was a while ago, and we’ve stopped counting. We still can't break everybody, so that option is also not on the table.

Well, then I’ll use a static helper function:

```dart
Future<T> onFutureError<T, E>(Future<T> source, 
    FutureOr<T> handleError(E error, StackTrace stack)) =>
  source.catchError(...something clever...);
```

which you can call as:

```dart
Future<int> eventualInteger = ...;
onFutureError(eventualInteger, 
    (FormatException e, s) => ...).then(...);
```

Almost as sadly, that simply doesn’t read well. We *like* using `.`-based method chaining because it allows us to read from left to right: “Do this, then do that, then do something more”. Using the static helper function forces us to read it as: “Do that to the following: Do this. After that, do something more” … say what? It just doesn't have the same *flow*, the same *schwung*. It's darn nigh unreadable in practice.

OK then, I’m undeterred in my quest, so instead of improving the `Future` class, I'll introduce a new and improved interface and give users a way to wrap the old interface:

```dart
class MyFuture<T> {
  Future<T> _wrappee;
  MyFuture(Future<T> future) : _wrappee = future;
  Future<T> onError<E>(
      FutureOr<T> handleError(E error, StackTrace stack)) =>
    _wrappee.catchError(...something clever...);
}
```

which you can use as:

```dart
Future<int> eventualInteger = ...;
MyFuture(eventualInteger).onError(
    (FormatException e, s) => ...).then(...);
```

I’d probably even let `MyFuture` implement `Future` and forward all the `Future` members to the `_wrappee` future, and then also let all the methods return a `MyFuture` wrapper again, so I can keep going.

```dart
class MyFuture<T> {
  Future<T> _wrappee;
  MyFuture(Future<T> future) : _wrappee = future;
  MyFuture<R> then<R>(...) => MyFuture(_wrappee.then<R>(...));
  /// Forward other `Future` methods too.
  MyFuture<T> onError<E>(
      FutureOr<T> handleError(E error, StackTrace stack)) =>
    MyFuture(_wrappee.catchError(...something clever...));
}
```

Nice and smooth, if I do say so myself!

This was pretty much as good as it got, back before extension methods … which meant manually adding the wrapper and taking the performance hit from the extra wrapper objects and intermediate forwarding functions.

## What I Will Do With Extension Methods

Once we’re out of the dark no-extension ages, I can use extension methods to get what I really, really want. I’ll write:

```dart
extension MyFuture<T> on Future<T> {
  Future<T> onError<E>(
      FutureOr<T> handleError(E error, StackTrace stack)) =>
    this.catchError(...something clever...);
}
```

and then you can call it as:

```dart
Future<int> eventualInteger = ...;
eventualInteger.onError((FormatException e, s) => ...).then(...);
```

and that is all. Mission accomplished in five lines!

“But how does it *work*?”, you might ask. It works very well, thank you.

In truth, *it behaves almost exactly the same way as the wrapper class*, even though it really is just a static helper function. You can even write `MyFuture(eventualInteger).onError(...)` explicitly, as if the extension was a wrapper class. It isn't, but it looks and acts *almost* as if it was. And you can omit the explicit wrapping and have it *implicitly* applied when the types are right.

## It’s (not) a Wrapper Class

The design of the `extension` declaration is deliberately made so that it looks like a `class` or `mixin` declaration, and it acts just as if it was a wrapper class with a hidden `_wrappee`. You can even have static members in the declaration, and they work just like static members on a `class` or `mixin` declaration.

There is one *improvement* over the wrapper class: You can write `this` inside instance members to refer to the `_wrappee` instead of the wrapper object.

Changing the meaning of `this` was not just an improvement. These are *static* extension methods, and as I said earlier, they are really just a more convenient way to call static functions. That means that there is no wrapper *object*. It never existed, we just pretended that it did, but that means that we can't let `this` refer to the non-existing object.

We also can't allow you to use `MyFuture(eventualInteger)` as a value, so if you try to do `var myFuture = MyFuture(eventualInteger)`, we won't allow it. The only way to use `MyFuture(eventualInteger)` is as the target of an extension member invocation.

```
MyFuture(eventualInteger).onError(...); // GOOD: Use to call method.
var x = MyFuture(eventualInteger); // BAD: Use as stand-alone value.
```


It’s the same as how you can use `super` to call methods, but not for its value. Or just like a library prefix. All you can do is access a member; you cannot treat it as a value because it has no value, and there is no value for it to have.

Because there is no object, you can’t declare *instance fields* in an `extension` declaration. You *can* declare getters and setters though, and perhaps even back them by an [`Expando`](https://api.dartlang.org/stable/2.5.1/dart-core/Expando-class.html). An extension also cannot declare any constructors since nothing is being constructed; it just pretends to have a constructor taking the wrappee object.

## It Does (not) Extend the Type

If you had to write the `MyFuture(...)` wrapping every time you used an extension member, then it wouldn't be much of an improvement. We could probably just write the wrapper classes directly and spend some compiler engineer hours ensuring that we optimize away the intermediate object.

I said above that you can write `eventualInteger.onError(...)`. This works because we *implicitly wrap* expressions based on their static type and the name of the member they call. We automatically wrap `expr.method()` as `Ext(expr).method()` when all of the following are true:

* The static type of `expr` does not have a member with (base-)name `method` (the interface always wins).

* The extension `Ext` is imported or declared in the current library scope (the extension is *accessible*).

* The extension declares a member with base-name `method`, *and* the static type of `expr` is a subtype of the `on` type of the `Ext` declaration (the extension is *applicable*).

If there is more than one accessible and applicable extension for a member invocation, there are rules about which one will win the conflict. In some cases, there’s no way to pick a winner, and then it’s just a compile-time error. These rules depend only on the extension declaration’s `on` type, not on member declaration. (Dart does not have “overloading” — multiple methods with the same name and different signatures, which you choose between based on the argument structure or types — and extension methods do not provide a back-door to get overloading.)

## It Is All Static

I said “s*tatic* extension methods” above, and I did so for a reason!

Dart is statically typed. The compiler knows the type of every expression at compile-time, so if you write `target.member(42)`, and `member` is an extension member, then the compiler needs to figure out *which* extension to implicitly wrap `target` with, in order to find the type of the entire member invocation.

If implicit extension wrapping has to happen *between* finding the type of the target expression *and* finding the type of the member invocation, it seems obvious that “extension inference” has to happen during the increasingly more inaccurately named “type inference” phase. That’s the phase which is mostly known for filling in missing generics.

I did write `eventualInteger.onError((FormatException e, s) {...})`, even though both the `MyFuture` extension and the `onError` method are generic. While doing type inference, the Dart compiler both selects the extension and infers missing type arguments. Here it first decides to use the `MyFuture` extension, then inserts the implicit wrapper, and finally performs type inference for the extension application `MyFuture(eventualInteger).onError((FormatException e, s) {...})` in *exactly the same way* as it would for a corresponding wrapper class:

```dart
class MyFuture<T> {
  Future<T> _wrappee;
  MyFuture(Future<T> future) : _wrappee = future;
  MyFuture<T> onError<E>(
      FutureOr<T> handleError(E error, StackTrace stack)) =>
    _wrappee.catchError(...something clever...);
}
```

In this case, the type inference would infer the following extension application and complete types for the invocation:

```dart
MyFuture<int>(eventualInteger).onError<FormatException>(
    (FormatException e, StackTrace s) {...});
```

This means that *the type arguments to the extension are based on the static type of the wrapped expression*. If you have a `Future&lt;num&gt; fut = Future&lt;int&gt;.value(42);` then `fut.onError(...)` will bind the `T` type parameter of `MyFuture` to `num` at compile-time, not to `int`. It's all static, just as for any other inferred type arguments.

That also means that you will never be able to call an extension member on a target typed as `dynamic`.

## Conflict Resolution

As stated above, there are rules about which extension wins when there is more than one in scope which applies. Basically, the winner is the extension with an `on` type closest to the actual type of the expression you are calling a member on, with some caveats and tie-breakers. It usually “just works” for extensions which are written together. Instead of going into those details, I'll tell you what to do when it *doesn't* just work.

You might have a problem when two different authors have written conflicting extensions for the same type and member name. Say the extensions `Ext1` and `Ext2` both define a `bubbleSort` method that applies to your `List` object, and either there is no clear winner of the conflict, or the one which wins is not the one you actually want to call (say `Ext2` wins and you want to call `Ext1.bubbleSort`). Then you have to do *something*.

The easiest solution is to use an explicit extension application: `Ext1(list).bubbleSort()`. This avoids the automatic resolution and just picks the one that you want. If you only have a few conflicts, then that's both easy and readable.

However, if you have three hundred conflicts in the same file, then you might want to avoid the extra typing. It’s hard to change whether an extension is *applicable* to an invocation, but you can change whether it’s *accessible*.

You do that by *hiding* the conflicting extension (or extension*s,* if you are really unlucky) where you import it: `import "ext2lib.dart" hide Ext2;`. Doing so will prevent the `Ext2` extension from being imported into the current library scope, which makes it not accessible. Obviously, so will not importing `ext2lib.dart` at all, but unless the extension is the only thing you use from that library, that’s not practical.

(Edited Dec. 11th) Here I used to say that you could import one of the conflicting extensions with a *prefix* and that then it would not be available for implicit use. Turns out that some people declare extension methods in the same library as the class they extend, and it is really annoying if that library doesn’t work when imported with a prefix. So we fixed that. Extensions imported with a prefix *do* work implicitly as well. If you really need to use two conflicting extension in the same library, you will have to use explicit extension application everywhere there is a conflict. We may consider adding a different way to disable implicit extensions in the future, at least if conflicting extensions turn out to be a recurring issue.

## Summary

Dart will get *extension methods* in an upcoming release *—* a pretty way to call static functions.

You can define extension members for **instance methods**, **operators**, **setters** and **getters**, but **not fields**.

You can invoke extension methods either explicitly or — when there’s no conflict with an interface member or another extension — implicitly:

```
`Ext1(list).bubbleSort() // Explicit, like it's a wrapper class.
list.bubbleSort()       // Implicitly, like it extends the type.`
```


Implicit invocations work the same as explicit invocations, but they first *infer* which extension is being applied. If extension inference fails due to conflicting extensions, then you can do any one of the following:

* Apply the extension explicitly.

* Don’t import the conflicting extension at all (remove the import or hide the extension).

* (Edited Dec 11th): And that is it (for now).

Extensions are *static*. Everything about them is decided based on static types.

Enjoy responsibly!