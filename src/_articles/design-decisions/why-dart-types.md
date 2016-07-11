---
layout: article
title: "Why Dart Types Are Optional and Unsound"
description: "A review of why Dart has optional static type annotations."
written: 2011-12-01
category: design-decisions
---

_Written by Eli Brandt<br>
December 2011_

Dart uses types in a way that might seem strange.  Most popular languages
  that offer a type system use it very differently.  If you're familiar with
  types in Java, Haskell, Scala, or any statically typed language, you may
  wonder why on earth Dart makes the choices that it does.

I wondered, too.  Let me try to explain where Dart is coming from.

This document is intended for people who are interested in types and have
  some knowledge of modern strongly-typed languages, but aren't necessarily
  deep into type theory.  (For example, me.)  It assumes that you know
  <em>what</em> Dart's optional types are doing, and are asking <em>why</em>;
  for a review of the <em>what</em>, see <a href="/articles/language/optional-types">Optional
  Types in Dart</a>.

## Background: Dart is a dynamically typed language, and proud of it

Dart is dynamically typed, in the tradition of LISP, Smalltalk, Python, and JavaScript.  Users of dynamically typed languages, and in particular users of JavaScript for web programming, will understand why we chose this.  If you are more of a static typing person, you may not be convinced&mdash;but let's save this for another discussion.  For now, let's take this as a starting point: Dart is dynamically typed.

In a dynamically typed language, any variable may be bound to a value of any type.  Each value carries a tag identifying its type (or at least we can think of the implementation that way).

Dart adds some static typing, but it maintains the goal to have programmers take full advantage of its dynamic typing.  The static type heuristics will not restrict them.  (We talk about "type heuristics" because you really don't want to think of it as a "type system", not even an unsound type system.)
So we want the static type checking to be <em>optimistic</em>:
assume code is valid unless we can be statically sure it isn't.


This goal drives many of Dart's decisions.  If we look at some snippets of code, our requirement that they pass static type checking will pin down certain aspects of the type heuristics.

## Before we start: Code used in this article


The code in this article assumes these declarations of a little type hierarchy, and some variables:


{% prettify dart %}
class Mammal {}
class Cow extends Mammal { String moo() => 'moo!'; }
class Pig extends Mammal { String oink() => 'oink!'; }

Mammal mammal = new Mammal();
Cow cow = new Cow();
Pig pig = new Pig();
{% endprettify %}




## Why is the static typing unsound?


Given our goal that Dart's static checks should be optimistic,
we very soon find that these static checks will be unsound.


### Optimism on down-assignments


Consider some code with a valid "down-assignment", assigning a supertype to a subtype:


{% prettify dart %}
mammal = cow;  // [1]
cow = mammal;  // [2] cow holds a Cow.
print(cow.moo());
{% endprettify %}

An up-assignment like [1] is always valid, so we make them pass static type checking.  A down-assignment could be valid, as [2] is, or invalid.  Because down-assignments <em>may</em> be valid and Dart is optimistic that you know what you're doing, we make them pass static checking too.  This gives us the assignment rule in the language spec:
<blockquote>A type T <em>may be assigned to</em> a type S, written  T &hArr; S, iff either T &lt;: S or S &lt;: T.
</blockquote>

### Here we are, unsound


Already we have designed ourselves an unsound type rule.


{% prettify dart %}
mammal = cow;      // [1]
pig = mammal;      // [2] Checks OK statically;
                   //     at runtime fails only in checked mode.

//In unchecked mode, pig now holds a Cow.
print(pig.oink()); // [3] NoSuchMethodException if we get this far.
{% endprettify %}

Down-assignment [2] was not valid, leading to a dynamic type error if they are enabled, or else an exception when the <code>Cow</code> stored in <code>pig</code> can't <code>Oink()</code>.

How did we get here again?  Every language with subtyping has to decide what to do with down-assignments.  You can't afford a type system powerful enough to distinguish the valid ones from the invalid, so you have to make a choice on a blend of the two.  The "pessimistic" choice is to make them all a type error, since they can't be guaranteed valid.  Dart takes the "optimistic" choice instead.

### Unsound but not unsafe

"Unsound" is a spooky-sounding word.  All it means, though, is that the type checker lets through some programs that at runtime turn out to fail with an error related to a value's type, such as <code>cow.oink()</code> throwing <code>NoSuchMethodException</code>.  Really, this is normal.  Languages with subtyping (common OO languages with "polymorphism") do this all the time.  Those whose type rules disallow direct down-assignment will normally let you do an explicit downcast, and that can fail at runtime.  You can write that runtime test in Dart code if you feel you must, but normally you'd get that effect by executing under Dart's "checked mode", which checks against the <em>static</em> types wherever they were declared.

Even when checked mode is off, running Dart involves checks against values' <em>dynamic</em> types as needed to execute safely, such as to find fields and dispatch methods.  There is never any "type pun" misinterpretation of a value's machine representation, and you can't crash the VM&mdash;assuming, as for any execution guarantee, that the VM is written correctly.  Correctness is easier to achieve for a VM that doesn't rely on static soundness guarantees, because you don't need the complexity of bytecode verification.

### Dart adds soundness to dynamic typing

You could look at JavaScript as having a trivial static type system that says "everything is the same type".  This type system never complains about anything, so you could say it's as unsound as you can get.  Dart's static typing is more sound than that, in that it statically rejects more bad programs.



## Why are generics covariant?


The following code snippet will work in the absence of type checks.  So Dart would like for it to pass both static and dynamic type checks:


{% prettify dart %}
// Uses "list" covariantly.
Mammal peekMammalList(List<Mammal> list) {
  return list[2];
}

main() {
  List<Cow> cowList = new List<Cow>(4);
  peekMammalList(cowList);
  // Covariant use:
  // * static type checking OK
  // * dynamic type checking OK
  // * runs happily
}
{% endprettify %}

Some generics that people write are strictly covariant on a type argument.  For example, a <code>ReadOnlyReference&lt;Cow&gt;</code> is substitutable for a <code>ReadOnlyReference&lt;Mammal&gt;</code>: someone expecting the latter will encounter no surprises if given the former.  Some generics are contravariant on a type argument, such as a <code>WriteOnlyReference&lt;T&gt;</code>.  And many are neither, so they're invariant.  Generics taking multiple type arguments may have different variances on each one.

On top of this, a generic that is invariant may be used in a way that's covariant or contravariant.  For example, <code>List&lt;T&gt;</code> is generally invariant on <code>T</code>, but using it in a read-only way is covariant: if you are expecting to read from a <code>List&lt;Mammal&gt;</code>, a <code>List&lt;Cow&gt;</code> works, since a <code>Cow</code> read from it does everything a <code>Mammal</code> can.  On the other hand, if you are expecting to write to a <code>List&lt;Cow&gt;</code>, a <code>List&lt;Mammal&gt;</code> works, since it can safely hold a <code>Cow</code>, for the same reason.

Dart's type rules are not able to distinguish between these cases.  This is deliberate, since there do exist ways to design type systems that more or less precisely distinguish variance.  We don't consider any of these ways in current use to be suitable for a language meant to be approachable, and whose type annotations are meant to be simple, lightweight, and optional.  Really very few programmers of any kind find it natural or easy to write variance annotations or wildcarding (I don't myself).  It seems inappropriate to ask this when we want to make it easy to move from JavaScript and add type annotations.  It is particularly hard to justify any significant complexity cost to add soundness to Dart's generics, when Dart has already jumped into unsoundness with both feet with its assignment rule, for the reasons we talked about in the previous section.

So Dart chooses to make generics subtype covariantly.  It  wouldn't fit Dart's optimistic philosophy to make all generics invariant, since many uses of them are read-only and they do act covariantly.

### What happens to contravariance?

An interesting point about this decision is what happens with contravariant use of a generic: static checking lets it pass (because assignability is symmetric), but dynamic checking fails, despite the fact that the code will run correctly in unchecked mode.  Dart's type checking tries not to interfere with anything you could do without the types, but this is an exception.

I found this a little surprising.  But I think the idea is that use of contravariance is not very common (remember <code>Function</code> is not a generic in Dart), and you can use an uninstantiated generic as a workaround.  (Would bivariant generics be less surprising, or more?)

{% prettify dart %}
// Use "list" as an output argument.
//
// This function body works contravariantly -- "list" could be any
// List<T> where T is Cow or a supertype -- but the declaration
// doesn't allow that.
void pokeCowList(List<Cow> list) {
  list[2] = new Cow();
}

// Use "list" as an output argument.
//
// Here we loosen the declaration to allow contravariance --
// "list" can be any List<T> where T is Cow or a supertype --
// but we have to over-loosen it, allowing any List at all.
void pokeCowListWorkaround(List list) {
  list[2] = new Cow();
}

main() {
  List<Mammal> mammalList = new List<Mammal>(4);

  pokeCowListWorkaround(mammalList);
  // Contravariant use with workaround:
  // * static type checking OK
  // * dynamic type checking OK
  // * runs happily

  pokeCowList(mammalList);
  // Contravariant use:
  // * static type checking OK
  // * dynamic type checking fails!
  // * runs happily if dynamic checking is off

  List<int> intList = new List<int>(4);
  pokeCowListWorkaround(intList);
  // Incorrect use, but workaround has silenced type checking:
  // * static type checking OK
  // * dynamic type checking OK
  // * fails at runtime
}
{% endprettify %}


### Couldn't Dart do variance inference, or something?

I wouldn't say the Dart team is in love with covariant generics; it's pragmatic.  Something better could come along, but keep in mind where Dart is coming from in considering what's "better" for it.  We don't want Dart to be a testbed for active programming languages research, but I think we're open to taking up ideas after they become well understood and unsurprising, a.k.a. a little bit boring. And since Dart has already made friends with unsoundness, we're not as motivated as some languages to buy sound generic variance if the cost is complicated type machinery.


## Why are static type annotations optional?

One reason is that for Dart to operate as a dynamically typed language, it needs some way to express that a variable makes no static claims about what types of values it can hold.  We express this as <code>var thing = ...</code>, a declaration with no type annotation.  (The alternative is to require static type annotations on all declarations but allow this type to be <code>Dynamic</code>, which permits any value.  But this adds no value for this case, just code clutter.)

We also think programmers should be able to decide which type annotations are useful and which are too obvious to justify carrying the annotation in the source code.  We use the <code>var</code> declaration form for this case as well:

{% prettify dart %}
var s = "obviously a string";
{% endprettify %}

You could also imagine distinguishing the two cases, "declared as dynamic" versus "I don't care to declare a type, but feel free to infer it and use that" (maybe <code>auto s = ...</code>).  The only reason I see to distinguish them is if inferred types are giving spurious static type warnings that you could suppress by declaring as <code>Dynamic</code>, but we don't intend for type inference to give spurious type warnings.  Also, we do have other mechanisms to suppress them if needed, such as the <code>.dynamic</code> getter.

I would imagine that as we work further on the editor experience, we may think about whether we want <code>var</code> declarations to present always as <code>Dynamic</code>, or always as an inferred type if available, or some combination.  But that's purely speculation.


## Why do type annotations have no effect at runtime?

One reason is that type annotations are optional.  If they affect run-time behavior, then what happens to <code>var</code> declarations?  We might always give them behavior as if they were typed <code>Dynamic</code>, but that would be strange when the programmer knows the type but didn't care to type it out.  We might give them behavior depending on what static type is derived by type inference, but that would make your program behavior depend on how complete the inference manages to be, which can be difficult to predict.

Another reason is that type annotations can be completely erroneous.  The program is still allowed to run, as best it can, if runtime checking is not turned on.  Making its behavior depend on incorrect type declarations would be very strange.

Finally, decoupling the static type annotation system from runtime behavior allows it more freedom to evolve.  Imagine two static analysis modes, one more conservative and one more permissive: it's reasonable for your choice of mode to affect whether a given program compiles warning-free, but it would be unreasonable to assign the program two different runtime meanings.


## Don't you want strong typing for better performance?

That's what I thought, too.  The VM designers say that in practice, type guarantees really don't help them nearly as much as you might think, because type checks are not a major drain on performance.
