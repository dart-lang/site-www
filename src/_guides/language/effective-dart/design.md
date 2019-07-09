---
title: "Effective Dart: Design"
description: Design consistent, usable libraries.
prevpage:
  url: /guides/language/effective-dart/usage
  title: Usage
---
<?code-excerpt replace="/([A-Z]\w*)\d\b/$1/g"?>
<?code-excerpt plaster="none"?>

Here are some guidelines for writing consistent, usable APIs for libraries.

## Names

Naming is an important part of writing readable, maintainable code.
The following best practices can help you achieve that goal.

### DO use terms consistently.

Use the same name for the same thing, throughout your code. If a precedent
already exists outside your API that users are likely to know, follow that
precedent.

{:.good-style}
{% prettify dart %}
pageCount         // A field.
updatePageCount() // Consistent with pageCount.
toSomething()     // Consistent with Iterable's toList().
asSomething()     // Consistent with List's asMap().
Point             // A familiar concept.
{% endprettify %}

{:.bad-style}
{% prettify dart %}
renumberPages()      // Confusingly different from pageCount.
convertToSomething() // Inconsistent with toX() precedent.
wrappedAsSomething() // Inconsistent with asX() precedent.
Cartesian            // Unfamiliar to most users.
{% endprettify %}

The goal is to take advantage of what the user already knows. This includes
their knowledge of the problem domain itself, the conventions of the core
libraries, and other parts of your own API. By building on top of those, you
reduce the amount of new knowledge they have to acquire before they can be
productive.


### AVOID abbreviations.

Unless the abbreviation is more common than the unabbreviated term, don't
abbreviate. If you do abbreviate, [capitalize it correctly][caps].

[caps]: /guides/language/effective-dart/style#identifiers

{:.good-style}
{% prettify dart %}
pageCount
buildRectangles
IOStream
HttpRequest
{% endprettify %}

{:.bad-style}
{% prettify dart %}
numPages    // "num" is an abbreviation of number(of)
buildRects
InputOutputStream
HypertextTransferProtocolRequest
{% endprettify %}


### PREFER putting the most descriptive noun last.

The last word should be the most descriptive of what the thing is. You can
prefix it with other words, such as adjectives, to further describe the thing.

{:.good-style}
{% prettify dart %}
pageCount             // A count (of pages).
ConversionSink        // A sink for doing conversions.
ChunkedConversionSink // A ConversionSink that's chunked.
CssFontFaceRule       // A rule for font faces in CSS.
{% endprettify %}

{:.bad-style}
{% prettify dart %}
numPages                  // Not a collection of pages.
CanvasRenderingContext2D  // Not a "2D".
RuleFontFaceCss           // Not a CSS.
{% endprettify %}


### CONSIDER making the code read like a sentence.

When in doubt about naming, write some code that uses your API, and try to read
it like a sentence.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (code-like-prose)"?>
{% prettify dart %}
// "If errors is empty..."
if (errors.isEmpty) ...

// "Hey, subscription, cancel!"
subscription.cancel();

// "Get the monsters where the monster has claws."
monsters.where((monster) => monster.hasClaws);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (code-like-prose)" replace="/ as bool//g"?>
{% prettify dart %}
// Telling errors to empty itself, or asking if it is?
if (errors.empty) ...

// Toggle what? To what?
subscription.toggle();

// Filter the monsters with claws *out* or include *only* those?
monsters.filter((monster) => monster.hasClaws);
{% endprettify %}

It's helpful to try out your API and see how it "reads" when used in code, but
you can go too far. It's not helpful to add articles and other parts of speech
to force your names to *literally* read like a grammatically correct sentence.

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (code-like-prose-overdone)"?>
{% prettify dart %}
if (theCollectionOfErrors.isEmpty) ...

monsters.producesANewSequenceWhereEach((monster) => monster.hasClaws);
{% endprettify %}


### PREFER a noun phrase for a non-boolean property or variable.

The reader's focus is on *what* the property is. If the user cares more about
*how* a property is determined, then it should probably be a method with a
verb phrase name.

{:.good-style}
{% prettify dart %}
list.length
context.lineWidth
quest.rampagingSwampBeast
{% endprettify %}

{:.bad-style}
{% prettify dart %}
list.deleteItems
{% endprettify %}


### PREFER a non-imperative verb phrase for a boolean property or variable.

Boolean names are often used as conditions in control flow, so you want a name
that reads well there. Compare:

{% prettify dart %}
if (window.closeable) ...  // Adjective.
if (window.canClose) ...   // Verb.
{% endprettify %}

Good names tend to start with one of a few kinds of verbs:

*   a form of "to be": `isEnabled`, `wasShown`, `willFire`. These are, by far,
    the most common.

*   an [auxiliary verb][]: `hasElements`, `canClose`,
    `shouldConsume`, `mustSave`.

*   an active verb: `ignoresInput`, `wroteFile`. These are rare because they are
    usually ambiguous. `loggedResult` is a bad name because it could mean
    "whether or not a result was logged" or "the result that was logged".
    Likewise, `closingConnection` could be "whether the connection is closing"
    or "the connection that is closing". Active verbs are allowed when the name
    can *only* be read as a predicate.

[auxiliary verb]: https://en.wikipedia.org/wiki/Auxiliary_verb

What separates all these verb phrases from method names is that they are not
*imperative*. A boolean name should never sound like a command to tell the
object to do something, because accessing a property doesn't change the object.
(If the property *does* modify the object in a meaningful way, it should be a
method.)

{:.good-style}
{% prettify dart %}
isEmpty
hasElements
canClose
closesWindow
canShowPopup
hasShownPopup
{% endprettify %}

{:.bad-style}
{% prettify dart %}
empty         // Adjective or verb?
withElements  // Sounds like it might hold elements.
closeable     // Sounds like an interface.
              // "canClose" reads better as a sentence.
closingWindow // Returns a bool or a window?
showPopup     // Sounds like it shows the popup.
{% endprettify %}

<aside class="alert alert-info" markdown="1">
There is one exception to this rule. Input properties in [Angular][]
components sometimes use imperative verbs for boolean setters because these
setters are invoked in templates, not from other Dart code.

[angular]: {{site.angulardart}}
</aside>


### CONSIDER omitting the verb for a named boolean *parameter*.

This refines the previous rule. For named parameters that are boolean, the name
is often just as clear without the verb, and the code reads better at the call
site.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (omit-verb-for-bool-param)"?>
{% prettify dart %}
Isolate.spawn(entryPoint, message, paused: false);
var copy = List.from(elements, growable: true);
var regExp = RegExp(pattern, caseSensitive: false);
{% endprettify %}


### PREFER the "positive" name for a boolean property or variable.

Most boolean names have conceptually "positive" and "negative" forms where the
former feels like the fundamental concept and the latter is its
negation&mdash;"open" and "closed", "enabled" and "disabled", etc. Often the
latter name literally has a prefix that negates the former: "visible" and
"*in*-visible", "connected" and "*dis*-connected", "zero" and "*non*-zero".

When choosing which of the two cases that `true` represents &mdash; and thus
which case the property is named for &mdash; prefer the positive or more
fundamental one. Boolean members are often nested inside logical expressions,
including negation operators. If your property itself reads like a negation,
it's harder for the reader to mentally perform the double negation and
understand what the code means.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (positive)"?>
{% prettify dart %}
if (socket.isConnected && database.hasData) {
  socket.write(database.read());
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (positive)"?>
{% prettify dart %}
if (!socket.isDisconnected && !database.isEmpty) {
  socket.write(database.read());
}
{% endprettify %}

An exception to this rule is properties where the negative form is what users
overwhelmingly need to use. Choosing the positive case would force them to
negate the property with `!` everywhere. Instead, it may be better to use the
negative case for that property.

For some properties, there is no obvious positive form. Is a document that has
been flushed to disk "saved" or "*un*-changed"? Is a document that *hasn't* been
flushed "*un*-saved" or "changed"? In ambiguous cases, lean towards the choice
that is less likely to be negated by users or has the shorter name.


### PREFER an imperative verb phrase for a function or method whose main purpose is a side effect.

Callable members can return a result to the caller and perform other work or
side effects. In an imperative language like Dart, members are often called
mainly for their side effect: they may change an object's internal state,
produce some output, or talk to the outside world.

Those kinds of members should be named using an imperative verb phrase that
clarifies the work the member performs.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (verb-for-func-with-side-effect)"?>
{% prettify dart %}
list.add("element");
queue.removeFirst();
window.refresh();
{% endprettify %}

This way, an invocation reads like a command to do that work.


### PREFER a noun phrase or non-imperative verb phrase for a function or method if returning a value is its primary purpose.

Other callable members have few side effects but return a useful result to the
caller. If the member needs no parameters to do that, it should generally be a
getter. But, sometimes a logical "property" needs some parameters. For example,
`elementAt()` returns a piece of data from a collection, but it needs a
parameter to know *which* piece of data to return.

This means the member is *syntactically* a method, but *conceptually* it is a
property, and should be named as such using a phrase that describes *what* the
member returns.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (noun-for-func-returning-value)"?>
{% prettify dart %}
var element = list.elementAt(3);
var first = list.firstWhere(test);
var char = string.codeUnitAt(4);
{% endprettify %}

This guideline is deliberately softer than the previous one. Sometimes a method
has no side effects but is still simpler to name with a verb phrase like
`list.take()` or `string.split()`.


### CONSIDER an imperative verb phrase for a function or method if you want to draw attention to the work it performs.

When a member produces a result without any side effects, it should usually be a
getter or a method with a noun phrase name describing the result it returns.
However, sometimes the work required to produce that result is important. It may
be prone to runtime failures, or use heavyweight resources like networking or
file I/O. In cases like this, where you want the caller to think about the work
the member is doing, give the member a verb phrase name that describes that
work.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (verb-for-func-with-work)"?>
{% prettify dart %}
var table = database.downloadData();
var packageVersions = packageGraph.solveConstraints();
{% endprettify %}

Note, though, that this guideline is softer than the previous two. The work an
operation performs is often an implementation detail that isn't relevant to the
caller, and performance and robustness boundaries change over time. Most of the
time, name your members based on *what* they do for the caller, not *how* they
do it.


### AVOID starting a method name with `get`.

In most cases, the method should be a getter with `get` removed from the name.
For example, instead of a method named `getBreakfastOrder()`, define a getter
named `breakfastOrder`.

Even if the member does need to be a method because it takes arguments or
otherwise isn't a good fit for a getter, you should still avoid `get`. Like the
previous guidelines state, either:

* Simply drop `get` and [use a noun phrase name][noun] like `breakfastOrder()`
  if the caller mostly cares about the value the method returns.

* [Use a verb phrase name][verb] if the caller cares about the work being done,
  but pick a verb that more precisely describes the work than `get`, like
  `create`, `download`, `fetch`, `calculate`, `request`, `aggregate`, etc.

[noun]: #prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose

[verb]: #consider-an-imperative-verb-phrase-for-a-function-or-method-if-you-want-to-draw-attention-to-the-work-it-performs


### PREFER naming a method `to___()` if it copies the object's state to a new object.

{% include linter-rule.html rule="use_to_and_as_if_applicable" %}

A *conversion* method is one that returns a new object containing a copy of
almost all of the state of the receiver but usually in some different form or
representation. The core libraries have a convention that these methods are
named starting with `to` followed by the kind of result.

If you define a conversion method, it's helpful to follow that convention.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (to___)"?>
{% prettify dart %}
list.toSet();
stackTrace.toString();
dateTime.toLocal();
{% endprettify %}


### PREFER naming a method `as___()` if it returns a different representation backed by the original object.

{% include linter-rule.html rule="use_to_and_as_if_applicable" %}

Conversion methods are "snapshots". The resulting object has its own copy of the
original object's state. There are other conversion-like methods that return
*views*&mdash;they provide a new object, but that object refers back to the
original. Later changes to the original object are reflected in the view.

The core library convention for you to follow is `as___()`.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (as___)"?>
{% prettify dart %}
var map = table.asMap();
var list = bytes.asFloat32List();
var future = subscription.asFuture();
{% endprettify %}


### AVOID describing the parameters in the function's or method's name.

The user will see the argument at the callsite, so it usually doesn't help
readability to also refer to it in the name itself.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (avoid-desc-param-in-func)"?>
{% prettify dart %}
list.add(element);
map.remove(key);
{% endprettify %}

{:.bad-style}
{% prettify dart %}
list.addElement(element)
map.removeKey(key)
{% endprettify %}

However, it can be useful to mention a parameter to disambiguate it from other
similarly-named methods that take different types:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (desc-param-in-func-ok)"?>
{% prettify dart %}
map.containsKey(key);
map.containsValue(value);
{% endprettify %}


### DO follow existing mnemonic conventions when naming type parameters.

Single letter names aren't exactly illuminating, but almost all generic types
use them. Fortunately, they mostly use them in a consistent, mnemonic way.
The conventions are:

*   `E` for the **element** type in a collection:

    {:.good-style}
    <?code-excerpt "misc/lib/effective_dart/design_good.dart (type-parameter-e)" replace="/\n\n/\n/g"?>
    {% prettify dart %}
    class IterableBase<E> {}
    class List<E> {}
    class HashSet<E> {}
    class RedBlackTree<E> {}
    {% endprettify %}

*   `K` and `V` for the **key** and **value** types in an associative
    collection:

    {:.good-style}
    <?code-excerpt "misc/lib/effective_dart/design_good.dart (type-parameter-k-v)" replace="/\n\n/\n/g"?>
    {% prettify dart %}
    class Map<K, V> {}
    class Multimap<K, V> {}
    class MapEntry<K, V> {}
    {% endprettify %}

*   `R` for a type used as the **return** type of a function or a class's
    methods. This isn't common, but appears in typedefs sometimes and in classes
    that implement the visitor pattern:

    {:.good-style}
    <?code-excerpt "misc/lib/effective_dart/design_good.dart (type-parameter-r)"?>
    {% prettify dart %}
    abstract class ExpressionVisitor<R> {
      R visitBinary(BinaryExpression node);
      R visitLiteral(LiteralExpression node);
      R visitUnary(UnaryExpression node);
    }
    {% endprettify %}

*   Otherwise, use `T`, `S`, and `U` for generics that have a single type
    parameter and where the surrounding type makes its meaning obvious. There
    are multiple letters here to allow nesting without shadowing a surrounding
    name. For example:

    {:.good-style}
    <?code-excerpt "misc/lib/effective_dart/design_good.dart (type-parameter-t)"?>
    {% prettify dart %}
    class Future<T> {
      Future<S> then<S>(FutureOr<S> onValue(T value)) => ...
    }
    {% endprettify %}

    Here, the generic method `then<S>()` uses `S` to avoid shadowing the `T`
    on `Future<T>`.

If none of the above cases are a good fit, then either another single-letter
mnemonic name or a descriptive name is fine:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (type-parameter-graph)"?>
{% prettify dart %}
class Graph<N, E> {
  final List<N> nodes = [];
  final List<E> edges = [];
}

class Graph<Node, Edge> {
  final List<Node> nodes = [];
  final List<Edge> edges = [];
}
{% endprettify %}

In practice, the existing conventions cover most type parameters.

## Libraries

A leading underscore character ( `_` ) indicates that a member is private to its
library. This is not mere convention, but is built into the language itself.

### PREFER making declarations private.

A public declaration in a library&mdash;either top level or in a class&mdash;is
a signal that other libraries can and should access that member. It is also a
commitment on your library's part to support that and behave properly when it
happens.

If that's not what you intend, add the little `_` and be happy. Narrow public
interfaces are easier for you to maintain and easier for users to learn. As a
nice bonus, the analyzer will tell you about unused private declarations so you
can delete dead code. It can't do that if the member is public because it
doesn't know if any code outside of its view is using it.


### CONSIDER declaring multiple classes in the same library.

Some languages, such as Java, tie the organization of files to the organization of
classes&mdash;each file may only define a single top level class. Dart does not
have that limitation. Libraries are distinct entities separate from classes.
It's perfectly fine for a single library to contain multiple classes, top level
variables, and functions if they all logically belong together.

Placing multiple classes together in one library can enable some useful
patterns. Since privacy in Dart works at the library level, not the class level,
this is a way to define "friend" classes like you might in C++. Every class
declared in the same library can access each other's private members, but code
outside of that library cannot.

Of course, this guideline doesn't mean you *should* put all of your classes into
a huge monolithic library, just that you are allowed to place more than one
class in a single library.


## Classes

Dart is a "pure" object-oriented language in that all objects are instances of
classes. But Dart does not require all code to be defined inside a
class&mdash;you can define top-level variables, constants, and functions like
you can in a procedural or functional language.

### AVOID defining a one-member abstract class when a simple function will do.

{% include linter-rule.html rule="one_member_abstracts" %}

Unlike Java, Dart has first-class functions, closures, and a nice light syntax
for using them. If all you need is something like a callback, just use a
function. If you're defining a class and it only has a single abstract member
with a meaningless name like `call` or `invoke`, there is a good chance you
just want a function.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (one-member-abstract-class)"?>
{% prettify dart %}
typedef Predicate<E> = bool Function(E element);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (one-member-abstract-class)"?>
{% prettify dart %}
abstract class Predicate<E> {
  bool test(E element);
}
{% endprettify %}


### AVOID defining a class that contains only static members.

{% include linter-rule.html rule="avoid_classes_with_only_static_members" %}

In Java and C#, every definition *must* be inside a class, so it's common to see
"classes" that exist only as a place to stuff static members. Other classes are
used as namespaces&mdash;a way to give a shared prefix to a bunch of members to
relate them to each other or avoid a name collision.

Dart has top-level functions, variables, and constants, so you don't *need* a
class just to define something. If what you want is a namespace, a library is a
better fit. Libraries support import prefixes and show/hide combinators. Those
are powerful tools that let the consumer of your code handle name collisions in
the way that works best for *them*.

If a function or variable isn't logically tied to a class, put it at the top
level. If you're worried about name collisions, give it a more precise name or
move it to a separate library that can be imported with a prefix.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (class-only-static)"?>
{% prettify dart %}
DateTime mostRecent(List<DateTime> dates) {
  return dates.reduce((a, b) => a.isAfter(b) ? a : b);
}

const _favoriteMammal = 'weasel';
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (class-only-static)"?>
{% prettify dart %}
class DateUtils {
  static DateTime mostRecent(List<DateTime> dates) {
    return dates.reduce((a, b) => a.isAfter(b) ? a : b);
  }
}

class _Favorites {
  static const mammal = 'weasel';
}
{% endprettify %}

In idiomatic Dart, classes define *kinds of objects*. A type that is never
instantiated is a code smell.

However, this isn't a hard rule. With constants and enum-like types, it may be
natural to group them in a class.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (class-only-static-exception)"?>
{% prettify dart %}
class Color {
  static const red = '#f00';
  static const green = '#0f0';
  static const blue = '#00f';
  static const black = '#000';
  static const white = '#fff';
}
{% endprettify %}


### AVOID extending a class that isn't intended to be subclassed.

If a constructor is changed from a generative constructor to a factory
constructor, any subclass constructor calling that constructor will break.
Also, if a class changes which of its own methods it invokes on `this`, that
may break subclasses that override those methods and expect them to be called
at certain points.

Both of these mean that a class needs to be deliberate about whether or not it
wants to allow subclassing. This can be communicated in a doc comment, or by
giving the class an obvious name like `IterableBase`. If the author of the class
doesn't do that, it's best to assume you should *not* extend the class.
Otherwise, later changes to it may break your code.


### DO document if your class supports being extended.

This is the corollary to the above rule. If you want to allow subclasses of your
class, state that. Suffix the class name with `Base`, or mention it in the
class's doc comment.


### AVOID implementing a class that isn't intended to be an interface.

Implicit interfaces are a powerful tool in Dart to avoid having to repeat the
contract of a class when it can be trivially inferred from the signatures of an
implementation of that contract.

But implementing a class's interface is a very tight coupling to that class. It
means virtually *any* change to the class whose interface you are implementing
will break your implementation. For example, adding a new member to a class is
usually a safe, non-breaking change. But if you are implementing that class's
interface, now your class has a static error because it lacks an implementation
of that new method.

Library maintainers need the ability to evolve existing classes without breaking
users. If you treat every class like it exposes an interface that users are free
implement, then changing those classes becomes very difficult. That difficulty
in turn means the libraries you rely on are slower to grow and adapt to new
needs.

To give the authors of the classes you use more leeway, avoid implementing
implicit interfaces except for classes that are clearly intended to be
implemented. Otherwise, you may introduce a coupling that the author doesn't
intend, and they may break your code without realizing it.

### DO document if your class supports being used as an interface.

If your class can be used as an interface, mention that in the class's doc
comment.


### AVOID mixing in a class that isn't intended to be a mixin.

If a constructor is added to a class that previously did not define any, that
breaks any other classes that are mixing it in. This is a seemingly innocuous
change in the class, and the restrictions around mixins aren't widely known.
It's likely an author may add a constructor without realizing it will break your
class that's mixing it in.

Like with subclassing, this means a class needs to be deliberate about whether
or not it wants to allow being used as a mixin. If the class doesn't have a doc
comment or an obvious name like `IterableMixin`, you should assume you cannot
mix in the class.


### DO document if your class supports being used as a mixin.

Mention in the class's doc comment whether the class can or must be used as a
mixin. If your class is designed for use only as a mixin, then consider adding
`Mixin` to the end of the class name.


## Constructors

Dart constructors are created by declaring a function with the same name as the
class and, optionally, an additional identifier. The latter are called *named
constructors*.


### CONSIDER making your constructor `const` if the class supports it.

If you have a class where all the fields are final, and the constructor does
nothing but initialize them, you can make that constructor `const`. That lets
users create instances of your class in places where constants are
required&mdash;inside other larger constants, switch cases, default parameter
values, etc.

If you don't explicitly make it `const`, they aren't able to do that.

Note, however, that a `const` constructor is a commitment in your public API. If
you later change the constructor to non-`const`, it will break users that are
calling it in constant expressions. If you don't want to commit to that, don't
make it `const`. In practice, `const` constructors are most useful for simple,
immutable data record sorts of classes.


## Members

A member belongs to an object and can be either methods or instance variables.

### PREFER making fields and top-level variables `final`.

{% include linter-rule.html rule="prefer_final_fields" %}

State that is not *mutable*&mdash;that does not change over time&mdash;is
easier for programmers to reason about. Classes and libraries that minimize the
amount of mutable state they work with tend to be easier to maintain.

Of course, it is often useful to have mutable data. But, if you don't need it,
your default should be to make fields and top-level variables `final` when you
can.


### DO use getters for operations that conceptually access properties.

Deciding when a member should be a getter versus a method is a challenging,
subtle, but important part of good API design, hence this very long guideline.
Some other language's cultures shy away from getters. They only use them when
the operation is almost exactly like a field&mdash;it does a miniscule amount of
calculation on state that lives entirely on the object. Anything more complex or
heavyweight than that gets `()` after the name to signal "computation goin' on
here!" because a bare name after a `.` means "field".

Dart is *not* like that. In Dart, *all* dotted names are member invocations that
may do computation. Fields are special&mdash;they're getters whose
implementation is provided by the language. In other words, getters are not
"particularly slow fields" in Dart; fields are "particularly fast getters".

Even so, choosing a getter over a method sends an important signal to the
caller. The signal, roughly, is that the operation is "field-like". The
operation, at least in principle, *could* be implemented using a field, as far
as the caller knows. That implies:

*   **The operation does not take any arguments and returns a result.**

*   **The caller cares mostly about the result.** If you want the caller to
    worry about *how* the operation produces its result more than they do the
    result being produced, then give the operation a verb name that describes
    the work and make it a method.

    This does *not* mean the operation has to be particularly fast in order to
    be a getter. `IterableBase.length` is `O(n)`, and that's OK. It's fine for a
    getter to do significant calculation. But if it does a *surprising* amount
    of work, you may want to draw their attention to that by making it a method
    whose name is a verb describing what it does.

    {:.bad-style}
    {% prettify dart %}
    connection.nextIncomingMessage; // Does network I/O.
    expression.normalForm; // Could be exponential to calculate.
    {% endprettify %}

*   **The operation does not have user-visible side effects.** Accessing a real
    field does not alter the object or any other state in the program. It
    doesn't produce output, write files, etc. A getter shouldn't do those things
    either.

    The "user-visible" part is important. It's fine for getters to modify hidden
    state or produce out of band side effects. Getters can lazily calculate and
    store their result, write to a cache, log stuff, etc. As long as the caller
    doesn't *care* about the side effect, it's probably fine.

    {:.bad-style}
    {% prettify dart %}
    stdout.newline; // Produces output.
    list.clear; // Modifies object.
    {% endprettify %}

*   **The operation is *idempotent*.** "Idempotent" is an odd word that, in this
    context, basically means that calling the operation multiple times produces
    the same result each time, unless some state is explicitly modified between
    those calls. (Obviously, `list.length` produces different results if you add
    an element to the list between calls.)

    "Same result" here does not mean a getter must literally produce an
    identical object on successive calls. Requiring that would force many
    getters to have brittle caching, which negates the whole point of using a
    getter. It's common, and perfectly fine, for a getter to return a new future
    or list each time you call it. The important part is that the future
    completes to the same value, and the list contains the same elements.

    In other words, the result value should be the same *in the aspects that the
    caller cares about.*

    {:.bad-style}
    {% prettify dart %}
    DateTime.now; // New result each time.
    {% endprettify %}

*   **The resulting object doesn't expose all of the original object's state.**
    A field exposes only a piece of an object. If your operation returns a
    result that exposes the original object's entire state, it's likely better
    off as a [`to___()`][to] or [`as___()`][as] method.

[to]: #prefer-naming-a-method-to___-if-it-copies-the-objects-state-to-a-new-object
[as]: #prefer-naming-a-method-as___-if-it-returns-a-different-representation-backed-by-the-original-object

If all of the above describe your operation, it should be a getter. It seems
like few members would survive that gauntlet, but surprisingly many do. Many
operations just do some computation on some state and most of those can and
should be getters.

{:.good-style}
{% prettify dart %}
rectangle.area;
collection.isEmpty;
button.canShow;
dataSet.minimumValue;
{% endprettify %}


### DO use setters for operations that conceptually change properties.

{% include linter-rule.html rule="use_setters_to_change_properties" %}

Deciding between a setter versus a method is similar to deciding between a
getter versus a method. In both cases, the operation should be "field-like".

For a setter, "field-like" means:

*   **The operation takes a single argument and does not produce a result
    value.**

*   **The operation changes some state in the object.**

*   **The operation is idempotent.** Calling the same setter twice with the same
    value should do nothing the second time as far as the caller is concerned.
    Internally, maybe you've got some cache invalidation or logging going on.
    That's fine. But from the caller's perspective, it appears that the second
    call does nothing.

{:.good-style}
{% prettify dart %}
rectangle.width = 3;
button.visible = false;
{% endprettify %}


### DON'T define a setter without a corresponding getter.

{% include linter-rule.html rule="avoid_setters_without_getters" %}

Users think of getters and setters as visible properties of an object. A
"dropbox" property that can be written to but not seen is confusing and
confounds their intuition about how properties work. For example, a setter
without a getter means you can use `=` to modify it, but not `+=`.

This guideline does *not* mean you should add a getter just to permit the setter
you want to add. Object's shouldn't generally expose more state than they need
to. If you have some piece of an object's state that can be modified but not
exposed in the same way, use a method instead.

<aside class="alert alert-info" markdown="1">
There is one exception to this rule. An [Angular][] component class may expose
setters that are invoked from a template to initialize the component. Often,
these setters are not intended to be invoked from Dart code and don't need a
corresponding getter. (If they are used from Dart code, they *should* have a
getter.)

[angular]: {{site.angulardart}}
</aside>

### AVOID returning `null` from members whose return type is `bool`, `double`, `int`, or `num`.

{% include linter-rule.html rule="avoid_returning_null" %}

Even though all types are nullable in Dart, users assume those types almost
never contain `null`, and the lowercase names encourage a "Java primitive"
mindset.

It can be occasionally useful to have a "nullable primitive" type in your API,
for example to indicate the absence of a value for some key in a map, but these
should be rare.

If you do have a member of this type that may return `null`, document it very
clearly, including the conditions under which `null` will be returned.


### AVOID returning `this` from methods just to enable a fluent interface.

{% include linter-rule.html rule="avoid_returning_this" %}

Method cascades are a better solution for chaining method calls.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (cascades)"?>
{% prettify dart %}
var buffer = StringBuffer()
  ..write('one')
  ..write('two')
  ..write('three');
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (cascades)"?>
{% prettify dart %}
var buffer = StringBuffer()
    .write('one')
    .write('two')
    .write('three');
{% endprettify %}


## Types

When you write down a type in your program, you constrain the kinds of values
that flow into different parts of your code. Types can appear in two kinds of
places: *type annotations* on declarations and type arguments to *generic
invocations*.

Type annotations are what you normally think of when you think of "static
types". You can type annotate a variable, parameter, field, or return type. In
the following example, `bool` and `String` are type annotations. They hang off
the static declarative structure of the code and aren't "executed" at runtime.

<?code-excerpt "misc/lib/effective_dart/design_good.dart (annotate-declaration)"?>
{% prettify dart %}
bool isEmpty(String parameter) {
  bool result = parameter.isEmpty;
  return result;
}
{% endprettify %}

A generic invocation is a collection literal, a call to a generic class's
constructor, or an invocation of a generic method. In the next example, `num`
and `int` are type arguments on generic invocations. Even though they are types,
they are first-class entities that get reified and passed to the invocation at
runtime.

<?code-excerpt "misc/lib/effective_dart/design_good.dart (annotate-invocation)"?>
{% prettify dart %}
var lists = <num>[1, 2];
lists.addAll(List<num>.filled(3, 4));
lists.cast<int>();
{% endprettify %}

We stress the "generic invocation" part here, because type arguments can *also*
appear in type annotations:

<?code-excerpt "misc/lib/effective_dart/design_good.dart (annotate-type-arg)"?>
{% prettify dart %}
List<int> ints = [1, 2];
{% endprettify %}

Here, `int` is a type argument, but it appears inside a type annotation, not a
generic invocation. You usually don't need to worry about this distinction, but
in a couple of places, we have different guidance for when a type is used in a
generic invocation as opposed to a type annotation.

In most places, Dart allows you to omit a type annotation and infers a type for
you based on the nearby context, or defaults to the `dynamic` type. The fact
that Dart has both type inference and a `dynamic` type leads to some confusion
about what it means to say code is "untyped". Does that mean the code is
dynamically typed, or that you didn't *write* the type? To avoid that confusion,
we avoid saying "untyped" and instead use the following terminology:

*   If the code is *type annotated*, the type was explicitly written in the
    code.

*   If the code is *inferred*, no type annotation was written, and Dart
    successfully figured out the type on its own. Inference can fail, in which
    case the guidelines don't consider that inferred. In some places, inference
    failure is a static error. In others, Dart uses `dynamic` as the fallback
    type.

*   If the code is *dynamic*, then its static type is the special `dynamic`
    type. Code can be explicitly annotated `dynamic` or it can be inferred.

In other words, whether some code is annotated or inferred is orthogonal to
whether it is `dynamic` or some other type.

Inference is a powerful tool to spare you the effort of writing and reading
types that are obvious or uninteresting. Omitting types in obvious cases also
draws the reader's attention to explicit types when those types are important,
for things like casts.

Explicit types are also a key part of robust, maintainable code. They define the
static shape of an API. They document and enforce what kinds of values are
allowed to reach different parts of the program.

The guidelines here strike the best balance we've found between brevity and
explicitness, flexibility and safety. When deciding which types to write, you
need to answer two questions:

* Which types should I write because I think it's best for them to be visible in
  the code?
* Which types should I write because inference can't provide them for me?

These guidelines help you answer the first question:

* [PREFER type annotating public fields and top-level variables if the type isn't obvious.](#prefer-type-annotating-public-fields-and-top-level-variables-if-the-type-isnt-obvious)
* [CONSIDER type annotating private fields and top-level variables if the type isn't obvious.](#consider-type-annotating-private-fields-and-top-level-variables-if-the-type-isnt-obvious)
* [AVOID type annotating initialized local variables.](#avoid-type-annotating-initialized-local-variables)
* [AVOID annotating inferred parameter types on function expressions.](#avoid-annotating-inferred-parameter-types-on-function-expressions)
* [AVOID redundant type arguments on generic invocations.](#avoid-redundant-type-arguments-on-generic-invocations)

These cover the second:

* [DO annotate when Dart infers the wrong type.](#do-annotate-when-dart-infers-the-wrong-type)
* [PREFER annotating with `dynamic` instead of letting inference fail.](#prefer-annotating-with-dynamic-instead-of-letting-inference-fail)

The remaining guidelines cover other more specific questions around types.


### PREFER type annotating public fields and top-level variables if the type isn't obvious.

{% include linter-rule.html rule="prefer_typing_uninitialized_variables" %}

Type annotations are important documentation for how a library should be used.
They form boundaries between regions of a program to isolate the source of a
type error. Consider:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (type_annotate_public_apis)"?>
{% prettify dart %}
install(id, destination) => ...
{% endprettify %}

Here, it's unclear what `id` is. A string? And what is `destination`? A string
or a `File` object? Is this method synchronous or asynchronous? This is clearer:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (type_annotate_public_apis)"?>
{% prettify dart %}
Future<bool> install(PackageId id, String destination) => ...
{% endprettify %}

In some cases, though, the type is so obvious that writing it is pointless:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (inferred)"?>
{% prettify dart %}
const screenWidth = 640; // Inferred as int.
{% endprettify %}

"Obvious" isn't precisely defined, but these are all good candidates:

* Literals.
* Constructor invocations.
* References to other constants that are explicitly typed.
* Simple expressions on numbers and strings.
* Factory methods like `int.parse()`, `Future.wait()`, etc. that readers are
  expected to be familiar with.

When in doubt, add a type annotation. Even when a type is obvious, you may still
wish to explicitly annotate. If the inferred type relies on values or
declarations from other libraries, you may want to type annotate *your*
declaration so that a change to that other library doesn't silently change the
type of your own API without you realizing.


### CONSIDER type annotating private fields and top-level variables if the type isn't obvious.

{% include linter-rule.html rule="prefer_typing_uninitialized_variables" %}

Type annotations on your public declarations help *users* of your code. Types on
private members help *maintainers*. The scope of a private declaration is
smaller and those who need to know the type of that declaration are also more
likely to be familiar with the surrounding code. That makes it reasonable to
lean more heavily on inference and omit types for private declarations, which is
why this guideline is softer than the previous one.

If you think the initializer expression&mdash;whatever it is&mdash;is
sufficiently clear, then you may omit the annotation. But if you think
annotating helps make the code clearer, then add one.


### AVOID type annotating initialized local variables.

{% include linter-rule.html rule="omit_local_variable_types" %}

Local variables, especially in modern code where functions tend to be small,
have very little scope. Omitting the type focuses the reader's attention on the
more important *name* of the variable and its initialized value.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (omit-types-on-locals)"?>
{% prettify dart %}
List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
  var desserts = <List<Ingredient>>[];
  for (var recipe in cookbook) {
    if (pantry.containsAll(recipe)) {
      desserts.add(recipe);
    }
  }

  return desserts;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (omit-types-on-locals)"?>
{% prettify dart %}
List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
  List<List<Ingredient>> desserts = <List<Ingredient>>[];
  for (List<Ingredient> recipe in cookbook) {
    if (pantry.containsAll(recipe)) {
      desserts.add(recipe);
    }
  }

  return desserts;
}
{% endprettify %}

If the local variable doesn't have an initializer, then its type can't be
inferred. In that case, it *is* a good idea to annotate. Otherwise, you get
`dynamic` and lose the benefits of static type checking.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (uninitialized-local)"?>
{% prettify dart %}
List<AstNode> parameters;
if (node is Constructor) {
  parameters = node.signature;
} else if (node is Method) {
  parameters = node.parameters;
}
{% endprettify %}


### AVOID annotating inferred parameter types on function expressions.

Anonymous functions are almost always immediately passed to a method taking a
callback of some type. (If the function isn't used immediately, it's usually
worth making it a named declaration.) When a function expression is created in a
typed context, Dart tries to infer the function's parameter types based on the
expected type.

For example, when you pass a function expression to `Iterable.map()`, your
function's parameter type is inferred based on the type of callback that `map()`
expects:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (func-expr-no-param-type)"?>
{% prettify dart %}
var names = people.map((person) => person.name);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (func-expr-no-param-type)"?>
{% prettify dart %}
var names = people.map((Person person) => person.name);
{% endprettify %}

In rare cases, the surrounding context is not precise enough to provide a type
for one or more of the function's parameters. In those cases, you may need to
annotate.


### AVOID redundant type arguments on generic invocations.

A type argument is redundant if inference would fill in the same type. If the
invocation is the initializer for a type-annotated variable, or is an argument
to a function, then inference usually fills in the type for you:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (redundant)"?>
{% prettify dart %}
Set<String> things = Set();
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (redundant)"?>
{% prettify dart %}
Set<String> things = Set<String>();
{% endprettify %}

Here, the type annotation on the variable is used to infer the type argument of
constructor call in the initializer.

In other contexts, there isn't enough information to infer the type and then you
should write the type argument:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (explicit)"?>
{% prettify dart %}
var things = Set<String>();
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (explicit)"?>
{% prettify dart %}
var things = Set();
{% endprettify %}

Here, since the variable has no type annotation, there isn't enough context to
determine what kind of `Set` to create, so the type argument should be provided
explicitly.


### DO annotate when Dart infers the wrong type.

Sometimes, Dart infers a type, but not the type you want. For example, you may
want a variable's type to be a supertype of the initializer's type so that you
can later assign some other sibling type to the variable:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (inferred-wrong)"?>
{% prettify dart %}
num highScore(List<num> scores) {
  num highest = 0;
  for (var score in scores) {
    if (score > highest) highest = score;
  }
  return highest;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (inferred-wrong)" replace="/ +\/\/ ignore: .*?\n//g"?>
{% prettify dart %}
num highScore(List<num> scores) {
  var highest = 0;
  for (var score in scores) {
    if (score > highest) highest = score;
  }
  return highest;
}
{% endprettify %}

Here, if `scores` contains doubles, like `[1.2]`, then the assignment to
`highest` will fail since its inferred type is `int`, not `num`. In these cases,
explicit annotations make sense.


### PREFER annotating with `dynamic` instead of letting inference fail.

Dart allows you to omit type annotations in many places and will try to infer a
type for you. In some cases, if inference fails, it silently gives you
`dynamic`. If `dynamic` is the type you want, this is technically the most terse
way to get it.

However, it's not the most *clear* way. A casual reader of your code who sees an
annotation is missing has no way of knowing if you intended it to be `dynamic`,
expected inference to fill in some other type, or simply forgot to write the
annotation.

When `dynamic` is the type you want, writing it explicitly makes your intent
clear.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (prefer-dynamic)"?>
{% prettify dart %}
dynamic mergeJson(dynamic original, dynamic changes) => ...
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (prefer-dynamic)"?>
{% prettify dart %}
mergeJson(original, changes) => ...
{% endprettify %}


<aside class="alert alert-info" markdown="1">

Before Dart 2, this guideline stated the exact opposite: *don't* annotate with
`dynamic` when it is implicit. With the new stronger type system and type
inference, users now expect Dart to behave like an inferred statically-typed
language. With that mental model, it is an unpleasant surprise to discover that
a region of code has silently lost all of the safety and performance of static
types.

</aside>


### PREFER signatures in function type annotations.

The identifier `Function` by itself without any return type or parameter
signature refers to the special [Function][] type. This type is only
marginally more useful than using `dynamic`. If you're going to annotate, prefer
a full function type that includes the parameters and return type of the
function.

[Function]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Function-class.html

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (avoid-Function)" replace="/(void )?Function(\(.*?\))?/[!$&!]/g"?>
{% prettify dart %}
bool isValid(String value, bool [!Function(String)!] test) => ...
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (avoid-Function)" replace="/Function/[!$&!]/g"?>
{% prettify dart %}
bool isValid(String value, [!Function!] test) => ...
{% endprettify %}

[fn syntax]: #prefer-inline-function-types-over-typedefs

One exception to this guideline is if you want a type that represents the union
of multiple different function types. For example, you may accept a function
that takes one parameter or a function that takes two. Since we don't have union
types, there's no way to precisely type that and you'd normally have to use
`dynamic`. `Function` is at least a little more helpful than that:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (function-arity)" replace="/(void )?Function(\(.*?\))?/[!$&!]/g"?>
{% prettify dart %}
void handleError([!void Function()!] operation, [!Function!] errorHandler) {
  try {
    operation();
  } catch (err, stack) {
    if (errorHandler is [!Function(Object)!]) {
      errorHandler(err);
    } else if (errorHandler is [!Function(Object, StackTrace)!]) {
      errorHandler(err, stack);
    } else {
      throw ArgumentError("errorHandler has wrong signature.");
    }
  }
}
{% endprettify %}


### DON'T specify a return type for a setter.

{% include linter-rule.html rule="avoid_return_types_on_setters" %}

Setters always return `void` in Dart. Writing the word is pointless.

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (avoid_return_types_on_setters)"?>
{% prettify dart %}
void set foo(Foo value) { ... }
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (avoid_return_types_on_setters)"?>
{% prettify dart %}
set foo(Foo value) { ... }
{% endprettify %}


### DON'T use the legacy typedef syntax.

{% include linter-rule.html rule="prefer_generic_function_type_aliases" %}

Dart has two notations for defining a named typedef for a function type. The
original syntax looks like:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (old-typedef)"?>
{% prettify dart %}
typedef int Comparison<T>(T a, T b);
{% endprettify %}

That syntax has a couple of problems:

*   There is no way to assign a name to a *generic* function type. In the above
    example, the typedef itself is generic. If you reference `Comparison` in
    your code, without a type argument, you implicitly get the function type
    `int Function(dynamic, dynamic)`, *not* `int Function<T>(T, T)`. This
    doesn't come up in practice often, but it matters in certain corner cases.

*   A single identifier in a parameter is interpreted as the parameter's *name*,
    not its *type*. Given:

    {:.bad-style}
    <?code-excerpt "misc/lib/effective_dart/design_bad.dart (typedef-param)"?>
    {% prettify dart %}
    typedef bool TestNumber(num);
    {% endprettify %}

    Most users expect this to be a function type that takes a `num` and returns
    `bool`. It is actually a function type that takes *any* object (`dynamic`)
    and returns `bool`. The parameter's *name* (which isn't used for anything
    except documentation in the typedef) is "num". This has been a
    long-standing source of errors in Dart.

The new syntax looks like this:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (new-typedef)"?>
{% prettify dart %}
typedef Comparison<T> = int Function(T, T);
{% endprettify %}

If you want to include a parameter's name, you can do that too:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (new-typedef-param-name)"?>
{% prettify dart %}
typedef Comparison<T> = int Function(T a, T b);
{% endprettify %}

The new syntax can express anything the old syntax could express and more, and
lacks the error-prone misfeature where a single identifier is treated as the
parameter's name instead of its type. The same function type syntax after the
`=` in the typedef is also allowed anywhere a type annotation may appear, giving
us a single consistent way to write function types anywhere in a program.

The old typedef syntax is still supported to avoid breaking existing code, but
it's deprecated.


### PREFER inline function types over typedefs.

{% include linter-rule.html rule="avoid_private_typedef_functions" %}

In Dart 1, if you wanted to use a function type for a field, variable, or
generic type argument, you had to first define a typedef for it. Dart 2 supports
a function type syntax that can be used anywhere a type annotation is allowed:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (function-type)"  replace="/(bool|void) Function\(Event\)/[!$&!]/g"?>
{% prettify dart %}
class FilteredObservable {
  final [!bool Function(Event)!] _predicate;
  final List<[!void Function(Event)!]> _observers;

  FilteredObservable(this._predicate, this._observers);

  [!void Function(Event)!] notify(Event event) {
    if (!_predicate(event)) return null;

    [!void Function(Event)!] last;
    for (var observer in _observers) {
      observer(event);
      last = observer;
    }

    return last;
  }
}
{% endprettify %}

It may still be worth defining a typedef if the function type is particularly
long or frequently used. But in most cases, users want to see what the function
type actually is right where it's used, and the function type syntax gives them
that clarity.


### CONSIDER using function type syntax for parameters.

{% include linter-rule.html rule="use_function_type_syntax_for_parameters" %}

Dart has a special syntax when defining a parameter whose type is a function.
Sort of like in C, you surround the parameter's name with the function's return
type and parameter signature:

<?code-excerpt "misc/lib/effective_dart/design_bad.dart (function-type-param)"?>
{% prettify dart %}
Iterable<T> where(bool predicate(T element)) => ...
{% endprettify %}

Before Dart 2 added function type syntax, this was the only way to give a
parameter a function type without defining a typedef. Now that Dart has a
general notation for function types, you can use it for function-typed
parameters as well:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (function-type-param)"?>
{% prettify dart %}
Iterable<T> where(bool Function(T) predicate) => ...
{% endprettify %}

The new syntax is a little more verbose, but is consistent with other locations
where you must use the new syntax.


### DO annotate with `Object` instead of `dynamic` to indicate any object is allowed.

Some operations work with any possible object. For example, a `log()` method
could take any object and call `toString()` on it. Two types in Dart permit all
values: `Object` and `dynamic`. However, they convey different things. If you
simply want to state that you allow all objects, use `Object`, as you would in
Java or C#.

Using `dynamic` sends a more complex signal. It may mean that Dart's type system
isn't sophisticated enough to represent the set of types that are allowed, or
that the values are coming from interop or otherwise outside of the purview of
the static type system, or that you explicitly want runtime dynamism at that
point in the program.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (Object-vs-dynamic)"?>
{% prettify dart %}
void log(Object object) {
  print(object.toString());
}

/// Returns a Boolean representation for [arg], which must
/// be a String or bool.
bool convertToBool(dynamic arg) {
  if (arg is bool) return arg;
  if (arg is String) return arg == 'true';
  throw ArgumentError('Cannot convert $arg to a bool.');
}
{% endprettify %}


### DO use `Future<void>` as the return type of asynchronous members that do not produce values.

When you have a synchronous function that doesn't return a value, you use `void`
as the return type. The asynchronous equivalent for a method that doesn't
produce a value, but that the caller might need to await, is `Future<void>`.

You may see code that uses `Future` or `Future<Null>` instead because older
versions of Dart didn't allow `void` as a type argument. Now that it does, you
should use it. Doing so more directly matches how you'd type a similar
synchronous function, and gives you better error-checking for callers and in the
body of the function.

For asynchronous functions that do not return a useful value and where no
callers need to await the asynchronous work or handle an asynchronous failure,
use a return type of `void`.


### AVOID using `FutureOr<T>` as a return type.

If a method accepts a `FutureOr<int>`, it is [generous in what it
accepts][postel]. Users can call the method with either an `int` or a
`Future<int>`, so they don't need to wrap an `int` in `Future` that you are
going to unwrap anyway.

[postel]: https://en.wikipedia.org/wiki/Robustness_principle

If you *return* a `FutureOr<int>`, users need to check whether get back an `int`
or a `Future<int>` before they can do anything useful. (Or they'll just `await`
the value, effectively always treating it as a `Future`.) Just return a
`Future<int>`, it's cleaner. It's easier for users to understand that a function
is either always asynchronous or always synchronous, but a function that can be
either is hard to use correctly.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (future-or)"?>
{% prettify dart %}
Future<int> triple(FutureOr<int> value) async => (await value) * 3;
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (future-or)"?>
{% prettify dart %}
FutureOr<int> triple(FutureOr<int> value) {
  if (value is int) return value * 3;
  return (value as Future<int>).then((v) => v * 3);
}
{% endprettify %}

The more precise formulation of this guideline is to *only use `FutureOr<T>` in
[contravariant][] positions.* Parameters are contravariant and return types are
covariant. In nested function types, this gets flipped&mdash;if you have a
parameter whose type is itself a function, then the callback's return type is
now in contravariant position and the callback's parameters are covariant. This
means it's OK for a *callback's* type to return `FutureOr<T>`:

[contravariant]: https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science)

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (future-or-contra)" replace="/FutureOr.S./[!$&!]/g"?>
{% prettify dart %}
Stream<S> asyncMap<T, S>(
    Iterable<T> iterable, [!FutureOr<S>!] Function(T) callback) async* {
  for (var element in iterable) {
    yield await callback(element);
  }
}
{% endprettify %}


## Parameters

In Dart, optional parameters can be either positional or named, but not both.


### AVOID positional boolean parameters.

{% include linter-rule.html rule="avoid_positional_boolean_parameters" %}

Unlike other types, booleans are usually used in literal form. Things like
numbers are usually wrapped in named constants, but we usually just pass around
`true` and `false` directly. That can make callsites unreadable if it isn't
clear what the boolean represents:

{:.bad-style}
{% prettify dart %}
new Task(true);
new Task(false);
new ListBox(false, true, true);
new Button(false);
{% endprettify %}

Instead, consider using named arguments, named constructors, or named constants
to clarify what the call is doing.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (avoid-positional-bool-param)"?>
{% prettify dart %}
Task.oneShot();
Task.repeating();
ListBox(scroll: true, showScrollbars: true);
Button(ButtonState.enabled);
{% endprettify %}

Note that this doesn't apply to setters, where the name makes it clear what the
value represents:

{:.good-style}
{% prettify dart %}
listBox.canScroll = true;
button.isEnabled = false;
{% endprettify %}


### AVOID optional positional parameters if the user may want to omit earlier parameters.

Optional positional parameters should have a logical progression such that
earlier parameters are passed more often than later ones. Users should almost
never need to explicitly pass a "hole" to omit an earlier positional argument to
pass later one. You're better off using named arguments for that.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (omit-optional-positional)"?>
{% prettify dart %}
String.fromCharCodes(Iterable<int> charCodes, [int start = 0, int end]);

DateTime(int year,
    [int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0]);

Duration(
    {int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0});
{% endprettify %}


### AVOID mandatory parameters that accept a special "no argument" value.

If the user is logically omitting a parameter, prefer letting them actually omit
it by making the parameter optional instead of forcing them to pass `null`, an
empty string, or some other special value that means "did not pass".

Omitting the parameter is more terse and helps prevent bugs where a sentinel
value like `null` is accidentally passed when the user thought they were
providing a real value.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (avoid-mandatory-param)"?>
{% prettify dart %}
var rest = string.substring(start);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (avoid-mandatory-param)"?>
{% prettify dart %}
var rest = string.substring(start, null);
{% endprettify %}


### DO use inclusive start and exclusive end parameters to accept a range.

If you are defining a method or function that lets a user select a range of
elements or items from some integer-indexed sequence, take a start index, which
refers to the first item and a (likely optional) end index which is one greater
than the index of the last item.

This is consistent with core libraries that do the same thing.

{:.good-style}
<?code-excerpt "misc/test/effective_dart_test.dart (param-range)" replace="/expect\(//g; /, \/\*\*\// \/\//g; /\);//g"?>
{% prettify dart %}
[0, 1, 2, 3].sublist(1, 3) // [1, 2]
'abcd'.substring(1, 3) // 'bc'
{% endprettify %}

It's particularly important to be consistent here because these parameters are
usually unnamed. If your API takes a length instead of an end point, the
difference won't be visible at all at the callsite.


## Equality

Implementing custom equality behavior for a class can be tricky. Users have deep
intuition about how equality works that your objects need to match, and
collection types like hash tables have subtle contracts that they expect
elements to follow.

### DO override `hashCode` if you override `==`.

{% include linter-rule.html rule="hash_and_equals" %}

The default hash code implementation provides an *identity* hash&mdash;two
objects generally only have the same hash code if they are the exact same
object. Likewise, the default behavior for `==` is identity.

If you are overriding `==`, it implies you may have different objects that are
considered "equal" by your class. **Any two objects that are equal must have the
same hash code.** Otherwise, maps and other hash-based collections will fail to
recognize that the two objects are equivalent.

### DO make your `==` operator obey the mathematical rules of equality.

An equivalence relation should be:

* **Reflexive**: `a == a` should always return `true`.

* **Symmetric**: `a == b` should return the same thing as `b == a`.

* **Transitive**: If `a == b` and `b == c` both return `true`, then `a == c`
  should too.

Users and code that uses `==` expect all of these laws to be followed. If your
class can't obey these rules, then `==` isn't the right name for the operation
you're trying to express.

### AVOID defining custom equality for mutable classes.

When you define `==`, you also have to define `hashCode`. Both of those should
take into account the object's fields. If those fields *change* then that
implies the object's hash code can change.

Most hash-based collections don't anticipate that&mdash;they assume an object's
hash code will be the same forever and may behave unpredictably if that isn't
true.

### DON'T check for `null` in custom `==` operators.

{% include linter-rule.html rule="avoid_null_checks_in_equality_operators" %}

The language specifies that this check is done automatically and your `==`
method is called only if the right-hand side is not `null`.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/design_good.dart (eq-dont-check-for-null)" replace="/operator ==/[!$&!]/g" plaster?>
{% prettify dart %}
class Person {
  final String name;
  // ···
  bool [!operator ==!](other) => other is Person && name == other.name;

  int get hashCode => name.hashCode;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/design_bad.dart (eq-dont-check-for-null)" replace="/\w+ != null/[!$&!]/g" plaster?>
{% prettify dart %}
class Person {
  final String name;
  // ···
  bool operator ==(other) => [!other != null!] && ...
}
{% endprettify %}

