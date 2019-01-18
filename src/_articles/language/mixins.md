---
title: A Brief History of Mixins in Dart
description: Mixins let you implement functionality once and use it in multiple classes.
original-date: 2012-12-18
date: 2018-06-01
category: language
obsolete: true
---

_Written by Gilad Bracha <br>
December 2012 (updated June 2018)_

This article provides a brief theoretical presentation of
the evolution of mixins in Dart.

<aside class="alert alert-info" markdown="1">
  For information on _using_ or _implementing_ mixins,
  see the language tour:

  **[Adding features to a class: mixins][]**
</aside>

## Mixin support by Dart release

Support for mixins changed in Dart 1.13 and Dart 2.1:

- Dart 1.12 or lower supports mixins that must extend `Object`, and must not
  call `super()`.
- Dart 1.13 or greater supports mixins that can extend from classes
  other than `Object`, and can call `super.method()`. This support is only
  available by default in the Dart VM and in Analyzer behind a flag. More
  specifically, it is behind the `--supermixin` flag in the command-line
  analyzer. It is also available in the analysis server, behind a
  client-configurable option. Dart2js and dartdevc do not support super mixins.
- In Dart 2.1, mixins are expected to have fewer restrictions. For example,
  Flutter supports mixins calling `super()` and extending from a class other
  than `Object`, but the syntax is expected to change before appearing in all
  Dart SDKs. For details, see the [mixin specification.][Dart 2.1 Mixins]

## Basic concepts

If you are familiar with the academic literature on mixins
you can probably skip this section.
Otherwise, please do read it,
as it defines important concepts and notation.
Those wishing to delve deeply into the topic can start with this paper:
[Mixins in Strongtalk](http://www.bracha.org/mixins-paper.pdf).

In a language supporting classes and inheritance,
a class implicitly defines a _mixin_.
The mixin is usually implicit—it is defined by the class body,
and constitutes the delta between the class and its superclass.
The class is in fact a _mixin application_—the
result of applying its implicitly defined mixin to its superclass.

The term _mixin application_ comes from
a close analogy with _function application_.
Mathematically, a mixin _M_ can be seen as a function
from superclass to subclass:
feed _M_ a superclass _S_, and a new subclass of _S_ is returned.
This is often written as _M |> S_ in the research literature.

Based on the notion of function application,
one can define function composition.
The concept carries through to mixin composition;
we define the composition of mixins
<em>M<sub>1</sub></em> and <em>M<sub>2</sub></em>,
written <em>M<sub>1</sub></em> * <em>M<sub>2</sub></em>, as:
<em>(M<sub>1</sub> * M<sub>2</sub>) |> S =
M<sub>1</sub> |> (M<sub>2</sub> |> S)</em>.

Functions are useful because
they can be applied to different arguments.
Likewise mixins.
The mixin implicitly defined by a class
is usually applied only once,
to the superclass given in the class declaration.
To allow mixins to be applied to different superclasses,
we need to be able to either
declare mixins independently of any particular superclass,
or alternately,
to extricate the implicit mixin of a class
and reuse it outside its original declaration.
That is what we propose to do below.

## Syntax and semantics

Mixins are implicitly defined via ordinary class declarations. In
principle, every class defines a mixin that can be extracted from
it. However, in this proposal, a mixin may only be extracted from
a class that has no declared constructors. This restriction avoids
complications that arise due to the need to pass constructor
parameters up the inheritance chain.

Example 1:

{% prettify dart %}
abstract class Collection<E> {
  Collection<E> newInstance();
  Collection<E> map((f) {
    var result = newInstance();
    forEach((E e) { result.add(f(e)); });
    return result;
  });
  void forEach(void f(E element)) {
    // ...
  }
  void add(E element) {
    // ...
  }
}

abstract class DOMElementList<E> = DOMList with Collection<E>;

abstract class DOMElementSet<E> = DOMSet with Collection<E>;

// ... 28 more variants
{% endprettify %}

Here, Collection\<E> is a normal class that is used to declare a mixin.
Both the classes DOMElementList and DOMElementSet are mixin applications.
They are defined by a special form of class declaration that gives them a name
and declares them equal to an application of
a mixin to a superclass, given via a `with` clause.
The class is abstract
because it does not implement the abstract method
newInstance() declared in Collection.

In the above, DOMElementList is effectively
<em>Collection mixin |> DOMList</em>,
while DOMElementSet is <em>Collection mixin |> DOMSet</em>.

The benefit here is that the code in class Collection
can be shared in multiple class hierarchies.
We list two such hierarchies above—one rooted in DOMList
and one rooted in DOMSet.
One need not repeat/copy the code in Collection,
and every change made to Collection will propagate to both hierarchies,
greatly easing maintenance of the code.
This particular example is loosely based on a
real and very acute case in the Dart libraries.

The above examples illustrate one form of mixin application,
where the mixin application specifies a mixin and a superclass
to which it applies,
and provides the application with a name.

In an alternative form, mixin applications appear in
the `with` clause of a class declaration
as a comma-separated list of identifiers.
All the identifiers must denote classes.
In this form, multiple mixins are composed and applied
to the superclass named in the extends clause,
producing an anonymous superclass.
Taking the same examples again, we would have:

{% prettify dart %}
class DOMElementList<E> extends DOMList with Collection<E> {
   DOMElementList<E> newInstance() => new DOMElementList<E>();
}

class DOMElementSet<E> extends DOMSet with Collection<E> {
  DOMElementSet<E> newInstance() => new DOMElementSet<E>();
}
{% endprettify %}

Here, DOMElementList is not the application _Collection mixin |> DOMList._
Instead, it is a new class whose superclass is such an application.
The situation with respect to DOMElementSet is analogous.
Note that in each case,
the abstract method newInstance() is overridden with an implementation,
so these classes can be instantiated directly.

Consider what happens if DOMList has a non-trivial constructor:

{% prettify dart %}
class DOMElementList<E> extends DOMList with Collection<E> {
  DOMElementList<E> newInstance() => new DOMElementList<E>(0);
  DOMElementList(size): super(size);
}
{% endprettify %}

Each mixin has its own constructor called independently,
and so does the superclass.
Since a mixin constructor cannot be declared,
the call to it can be elided in the syntax;
in the underlying implementation,
the call can always be placed at the start of the initialization list.

The constructor would set the values for any fields
and for the generic type parameters.

This rule ensures that these examples run smoothly and also generalize
cleanly once one lifts the restriction on constructors.

The second form is a convenient sugar
that allows multiple mixins to be mixed into a class
without the need to introduce multiple intermediate declarations.
For example:

{% prettify dart %}
class Person {
  String name;
  Person(this.name);
}

class Maestro extends Person with Musical, Aggressive, Demented {
  Maestro(name):super(name);
}
{% endprettify %}

Here, the superclass is the mixin application:

<em>Demented mixin \|> Aggressive mixin \|> Musical mixin \|> Person</em>

We assume that only Person has a constructor with arguments.
Hence _Musical mixin |> Person_ inherits Person's constructors,
and so on until the actual superclass of Maestro,
which is formed by a series of mixin applications.

In reality in this example we'd expect that
Demented, Aggressive, and Musical
actually have interesting properties that are likely to require state.


## Details

We now discuss a few issues in more detail:

* Privacy
* Statics
* Types

### Privacy

A mixin application may well be declared outside the library
that declared the original class.
This does not have any effect on
who can access members of a mixin application instance.
Access to members is determined based on
the library where they were originally declared,
exactly as with ordinary inheritance.
This follows from the semantics of mixin application,
which are determined by the semantics of inheritance
in the underlying language.

### Statics

Can one use the statics of the original class
via the mixin application or not?

Again, the answer (No) follows from the semantics of inheritance.
Statics are not inherited in Dart.

### Types

What is the type of a mixin application instance? In general, it is a
subtype of its superclass, and also a subtype of the type denoted by
the mixin name itself, that is, the type of the original class.

The original class has its own superclass. To ensure that a particular
mixin application is compatible with the original class being mixed in,
Dart places extra requirements on classes that use `with` clauses.

If a class _A_ is defined using a `with` clause that applies a mixin _M_ where
_M_ was derived from a class _K_, then _A_ must support the direct
superinterfaces of _K_.

{% prettify dart %}
class S {
  twice(int x) => 2 * x;
}

abstract class I {
   twice(x);
}

abstract class J {
   thrice(x);
}
class K extends S implements I, J {
  int thrice(x) => 3* x;
}

class B {
  twice(x) => x + x;
}
class A = B with K;
{% endprettify %}

In particular, _A_ must support the implicit interface of the superclass
_S_ of _K_.  This ensures that _A_ is indeed a subtype of _M_, even though
its superclass chain is different. In our example above, _K_ needs to
implement `twice()` to meet the requirements of _I_ and must also implement
`thrice()` in order to satisfy the requirements imposed by _J_. _K_ meets these
requirements because it defines `thrice()` directly, and inherits an
implementation of `twice()` from _S_.

Now when we define _A_, we get the implementation of `thrice()` from
_K_'s mixin. However, the mixin won't provide us with an implementation of
`twice()`.  Fortunately, _B_ does have such an implementation, so overall _A_ does
satisfy the requirements of  _I_, _J_ as well as _S_.

In contrast, given class _D_:

{% prettify dart %}
class D {
   double(x) => x+x;
}

class E = D with K;
{% endprettify %}

we will get a warning, because class _E_ does not have a twice method,
and so does not conform to either _I_ or _S_ and so cannot be used where
a _K_ is expected.

### Generics

If a class has type parameters,
its mixin necessarily has identical type parameters.

[Adding features to a class: mixins]: /guides/language/language-tour#adding-features-to-a-class-mixins
[Dart 2.1 Mixins]: https://github.com/dart-lang/language/blob/master/accepted/2.1/super-mixins/feature-specification.md
