---
layout: guide
title: "Effective Dart: Design"
description: "Design consistent, usable libraries."

nextpage:
  url:
  title:
prevpage:
  url: /guides/language/effective-dart/usage
  title: "Usage"
---

Here are some guidelines for writing consistent, usable APIs for libraries.

## Names

Naming is an important part of writing readable, maintainable code.
The following best practices can help you achieve that goal.

### DO use terms consistently.

Use the same name for the same thing, throughout your code. If a precedent
already exists outside your API that your API's users are likely to know, follow
that precedent.

<div class="good">
{% prettify dart %}
pageCount         // A field.
updatePageCount() // Consistent with pageCount.
toSomething()     // Consistent with Iterable's toList().
asSomething()     // Consistent with List's asMap().
Point             // A familiar concept.
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
renumberPages()      // Confusingly different from pageCount.
convertToSomething() // Inconsistent with toX() precedent.
wrappedAsSomething() // Inconsistent with asX() precedent.
Cartesian            // Unfamiliar to most users.
{% endprettify %}
</div>

The goal is to take advantage of what the user already knows. This includes
their knowledge of the problem domain itself, the conventions of the core
libraries, and other parts of your own API. By building on top of those, you
reduce the amount of new knowledge they have to acquire before they can be
productive.


### AVOID abbreviations.

Unless the abbreviation is more common than the unabbreviated term, don't
abbreviate. If you do abbreviate, [capitalize them correctly][caps].

[caps]: /guides/language/effective-dart/style#identifiers

<div class="good">
{% prettify dart %}
pageCount
buildRectangles
IOStream
HttpRequest
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
numPages    // "num" is an abbreviation of number(of)
buildRects
InputOutputStream
HypertextTransferProtocolRequest
{% endprettify %}
</div>


### PREFER putting the most descriptive noun last.

The last word should be the most descriptive of what the thing is. You can
prefix it with other words, such as adjectives, to further describe the thing.

<div class="good">
{% prettify dart %}
pageCount             // A count (of pages).
ConversionSink        // A sink for doing conversions.
ChunkedConversionSink // A ConversionSink that's chunked.
CssFontFaceRule       // A rule for font faces in CSS.
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
numPages                  // Not a collection of pages.
CanvasRenderingContext2D  // Not a "2D".
RuleFontFaceCss           // Not a CSS.
{% endprettify %}
</div>


### CONSIDER making the code read like a sentence.

When in doubt about naming, write some code that uses your API, and try to read
it like a sentence.

<div class="good">
{% prettify dart %}
// "If errors is empty..."
if (errors.isEmpty) ...

// "Hey, _subscription, cancel!"
_subscription.cancel();

// "Get the monsters where the monster has claws."
monsters.where((monster) => monster.hasClaws);
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
// Telling errors to empty itself, or asking if it is?
if (errors.empty) ...

// Toggle what? To what?
_subscription.toggle();

// Filter the monsters with claws *out* or include *only* those?
monsters.filter((monster) => monster.hasClaws);
{% endprettify %}
</div>

It's helpful to try out your API and see how it "reads" when used in code, but
you can go too far. It's not helpful to add articles and other parts of speech
to force your names to *literally* read like a grammatically correct sentence.

<div class="bad">
{% prettify dart %}
if (theCollectionOfErrors.isEmpty) ...

monsters.producesANewSequenceWhereEach((monster) => monster.hasClaws);
{% endprettify %}
</div>


### PREFER a noun phrase for a non-boolean property or variable.

The reader's focus is on *what* the property is. If the user cares more about
*how* a property is determined, then it should probably be a method with a
verb phrase name.

<div class="good">
{% prettify dart %}
list.length
context.lineWidth
quest.rampagingSwampBeast
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
list.deleteItems
{% endprettify %}
</div>


### PREFER a non-imperative verb phrase for a boolean property or variable.

Boolean names are often used as conditions in control flow, so you want a name
that reads well there. Compare:

{% prettify dart %}
if (window.closeable) { ... }   // Adjective.
if (window.canClose) { ... }    // Verb.
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

<div class="good">
{% prettify dart %}
isEmpty
hasElements
canClose
closesWindow
canShowPopup
hasShownPopup
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
empty         // Adjective or verb?
withElements  // Sounds like it might hold elements.
closeable     // Sounds like an interface.
              // "canClose" reads better as a sentence.
closingWindow // Returns a bool or a window?
showPopup     // Sounds like it shows the popup.
{% endprettify %}
</div>


### CONSIDER omitting the verb for a named boolean *parameter*.

This refines the previous rule. For named parameters that are boolean, the name
is often just as clear without the verb and it reads better at the callsite.

<div class="good">
{% prettify dart %}
Isolate.spawn(entryPoint, message, paused: false)
new List.from(elements, growable: true)
new RegExp(pattern, caseSensitive: false)
{% endprettify %}
</div>


### PREFER an imperative verb phrase for a function or method whose main purpose is a side effect.

Callable members can return a result to the caller and perform other work or
side effects. In an imperative language like Dart, members are often called
mainly for their side effect: they may change an object's internal state,
produce some output, or talk to the outside world.

Those kinds of members should be named using an imperative verb phrase that
clarifies the work the member performs.

<div class="good">
{% prettify dart %}
list.add()
queue.removeFirst()
window.refresh()
connection.downloadData()
{% endprettify %}
</div>

This way, an invocation reads like a command to do that work.

### CONSIDER a noun phrase or non-imperative verb phrase for a function or method if returning a value is its primary purpose.

Other callable members have few side effects but return a useful result to the
caller. If the member needs no parameters to do that, it should generally be a
getter. But, sometimes a logical "property" needs some parameters. For example,
`elementAt()` returns a piece of data from a collection, but it needs a
parameter to know *which* piece of data to return.

This means the member is *syntactically* a method, but *conceptually* it is a
property, and should be named as such using a phrase that describes *what* the
member returns.

<div class="good">
{% prettify dart %}
list.elementAt(3)
string.codeUnitAt(4)
{% endprettify %}
</div>

This guideline is deliberately softer than the previous one. Sometimes a method
has no side effects but is still simpler to name with a verb phrase like
`list.take()` or `string.split()`.


### PREFER naming a method `to___()` if it copies the object's state to a new object.

A "conversion" method is one that returns a new object containing a copy of
almost all of the state of the receiver but usually in some different form or
representation. The core libraries have a convention that these methods are
named starting with `to` followed by the kind of result.

If you define a conversion method, it's helpful to follow that convention.

<div class="good">
{% prettify dart %}
list.toSet()
stackTrace.toString()
dateTime.toLocal()
{% endprettify %}
</div>


### PREFER naming a method `as___()` if it returns a different representation backed by the original object.

Conversion methods are "snapshots". The resulting object has its own copy of the
original object's state. There are other conversion-like methods that return
*views*&mdash;they provide a new object, but that object refers back to the
original. Later changes to the original object are reflected in the view.

The core library convention for you to follow is `as___()`.

<div class="good">
{% prettify dart %}
list.asMap()
bytes.asFloat32List()
subscription.asFuture()
{% endprettify %}
</div>


### AVOID describing the parameters in the function's or method's name.

The user will see the argument at the callsite, so it usually doesn't help
readability to also refer to it in the name itself.

<div class="good">
{% prettify dart %}
list.add(element)
map.remove(key)
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
list.addElement(element)
map.removeKey(key)
{% endprettify %}
</div>

However, it can be useful to mention a parameter to disambiguate it from other
similarly-named methods that take different types:

<div class="good">
{% prettify dart %}
map.containsKey(key)
map.containsValue(value)
{% endprettify %}
</div>


## Libraries

The underscore character ( `_` ) to indicates that a member is private to its library.
This distinction is enforced by the Dart tools.

### PREFER making declarations private.

A public declaration in a library&mdash;either top level or in a class&mdash;is
a signal that other libraries can and should access that member. It is also a
commitment on your library's part to support that and behave properly when it
happens.

If that's not what you intend, add the little `_` and be happy. Narrow public
interfaces are easier for you to maintain and easier for users to learn.

As a nice bonus, the analyzer will tell you about unused private declarations so
you can delete dead code. It can't do that if the member is public because it
doesn't know if any code outside of its view is using it.


## Types

Dart supports a variety of built-in types and you can define your own types.
Or, you can choose not to use types at all.

### AVOID defining a one-member abstract class when a simple function will do.

Unlike Java, Dart has first-class functions, closures, and a nice light syntax
for using them. If all you need is something like a callback, just use a
function. If you're defining a class and it only has a single abstract member
with a meaningless name like `call` or `invoke`, there is a good chance you
just want a function.

<div class="good">
{% prettify dart %}
typedef bool Predicate(item);
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
abstract class Predicate {
  bool test(item);
}
{% endprettify %}
</div>


### AVOID defining a class that contains only static members.

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

<div class="good">
{% prettify dart %}
DateTime mostRecent(List<DateTime> dates) {
  return dates.reduce((a, b) => a.isAfter(b) ? a : b);
}

const _favoriteMammal = 'weasel';
{% endprettify %}
</div>

<div class="bad">
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
</div>

In idiomatic Dart, classes define *kinds of objects*. A type that is never
instantiated is a code smell.

However, this isn't a hard rule. With constants and enum-like types, it may be
natural to group them in a class. Even then, it's also reasonable to use a
library instead.

<div class="good">
{% prettify dart %}
class Color {
  const red = '#f00';
  const green = '#0f0';
  const blue = '#00f';
  const black = '#000';
  const white = '#fff';
}
{% endprettify %}
</div>


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


### DO document whether your class supports being extended.

This is the corollary to the above rule. If you want to allow subclasses of your
class, state that. Suffix the class name with `Base`, or mention it in the
class's doc comment.


### AVOID mixing in a class that isn't intended to be a mixin.

If a constructor is added to a class that previously did not define any, that
breaks any other classes that are mixing it in. This is a seemingly innocuous
change in the class and the restrictions around mixins aren't widely known. It's
likely an author may add a constructor without realizing it will break your
class that's mixing it in.

Like with subclassing, this means a class needs to be deliberate about whether
or not it wants to allow being used as a mixin. If the class doesn't have a doc
comment or an obvious name like `IterableMixin`, you should assume you cannot
mix in the class.


### DO document whether your class supports being used as a mixin.

Mention in the class's doc comment whether the class can or must be used as a
mixin. If your class is designed for use only as a mixin, then consider adding
`Mixin` to the end of the class name.


## Constructors

Dart constructors are created by declaring a function with the same name
as the class and, optionally, an additional identifier. These are called
_named constructors_.

### PREFER defining constructors instead of static methods to create instances.

Constructors are invoked using `new` or `const`, which communicates
that the main purpose of the call is to return an instance of the class
(or at least something that implements its interface).

You never _need_ to use a static method to create an instance. Named
constructors let you clarify how the object is created, and factory
constructors let you construct instances of subclasses or
subinterfaces when appropriate.

Still, some methods that technically create a new object don't feel
"constructor-like". For example, [`Uri.parse()`][uri.parse] is a static method
even though it creates a new URI from the given arguments. Likewise, classes
implementing the [Builder pattern][] may read better using static methods.

[uri.parse]: {{site.dart_api}}/dart-core/Uri/parse.html
[builder pattern]: http://en.wikipedia.org/wiki/Builder_pattern

But, in most cases, you should use a constructor even though it's more verbose.
When users want a new instance of your class, they expect a constructor to be
the normal way to create one.

<div class="good">
{% prettify dart %}
class Point {
  num x, y;
  Point(this.x, this.y);
  Point.polar(num theta, num radius)
      : x = radius * math.cos(theta),
        y = radius * math.sin(theta);
}
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
class Point {
  num x, y;
  Point(this.x, this.y);
  static Point polar(num theta, num radius) {
    return new Point(radius * math.cos(theta),
        radius * math.sin(theta));
  }
}
{% endprettify %}
</div>


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

State that is not *mutable*&mdash;that does not change over time&mdash;is
easier for programmers to reason about. Classes and libraries that minimize the
amount of mutable state they work with tend to be easier to maintain.

Of course, it is often useful to have mutable data. But, if you don't need it,
your default should be to make fields and top-level variables `final` when you
can.


### DO use getters for operations that conceptually access properties.

If the name of the method starts with `get` or is a noun phrase like `length` or
`size` that's a sign you're better off using a getter. You
should define a getter instead of a method when all of these are true:

  * **Does not take any arguments.**
  * **Returns a value.**
  * **Is side-effect free.** Invoking a getter shouldn't change any
  externally-visible state (caching internally or lazy initialization is
  OK). Invoking the same getter repeatedly should return the same value
  unless the object is explicitly changed between calls.

<div class="good">
{% prettify dart %}
rect.width
collection.isEmpty
button.canShow
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
DateTime.now;   // Returns different value each call.
window.refresh; // Doesn't return a value.
{% endprettify %}
</div>

Unlike other languages, in Dart we don't require getters to be particularly fast
or have certain complexity guarantees. Calling `length` on an Iterable may be
`O(n)`, and that's OK.


### DO use a setter for operations that conceptually change a property.

If the name of the method starts with `set` that's often a sign that it could be
a setter. More specifically, use a setter instead of a method when it:

*   **Takes a single argument.**

*   **Changes some state in the object.**

*   **Has a corresponding getter.** It feels weird for users to have state that
    they can modify but not see. (The converse is not true; it's fine to have
    getters that don't have setters.)

*   **Is idempotent.** Calling the same setter twice with the same value should
    do nothing the second time.

<div class="good">
{% prettify dart %}
rect.width = 3;
button.visible = false;
{% endprettify %}
</div>


### DON'T define a setter without a corresponding getter.

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

  [angular]: http://angular.io

</aside>

### AVOID returning `null` from members whose return type is `bool`, `double`, `int`, or `num`.

Even though all types are nullable in Dart, users assume those types almost
never contain `null`, and the lowercase names encourage a "Java primitive"
mindset.

It can be occasionally useful to have a "nullable primitive" type in your API,
for example to indicate the absence of a value for some key in a map, but these
should be rare.

If you do have a member of this type that may return `null`, document it very
clearly, including the conditions under which `null` will be returned.


### AVOID returning `this` from methods just to enable a fluent interface.

Method cascades are a better solution for chaining method calls.

<div class="good">
{% prettify dart %}
var buffer = new StringBuffer()
  ..write('one')
  ..write('two')
  ..write('three');
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
var buffer = new StringBuffer()
  .write('one')
  .write('two')
  .write('three');
{% endprettify %}
</div>


## Type annotations

In Dart, adding static types to your variables is optional.

### DO type annotate public APIs.

Type annotations are important documentation for how a library should be used.
Annotating the parameter and return types of public methods and functions helps
users understand what the API expects and what it provides.

Note that if a public API accepts a range of values that Dart's type system
cannot express, then it is acceptable to leave that untyped. In that case, the
implicit `dynamic` *is* the correct type for the API.

For code internal to a library (either private, or things like nested functions)
annotate where you feel it helps, but don't feel that you *must* provide them.

<div class="bad">
{% prettify dart %}
install(id, destination) {
  // ...
}
{% endprettify %}
</div>

Here, it's unclear what `id` is. A string? And what is `destination`? A string
or a `File` object? Is this method synchronous or asynchronous?

<div class="good">
{% prettify dart %}
Future<bool> install(PackageId id, String destination) {
  // ...
}
{% endprettify %}
</div>

With types, all of this is clarified.

### PREFER type annotating private declarations.

Type annotations on your public API help *users* of your code. Nearly as
important is guiding *maintainers* of your code. Adding type annotations to
internal member and variable declarations can future readers of your code
understand it, and help corral bugs.

<div class="good">
{% prettify dart %}
class CallChainVisitor {
  final SourceVisitor _visitor;
  final Expression _target;

  void _writeCall(Expression call) { ... }

  ...
}
{% endprettify %}
</div>


### AVOID annotating types on function expressions.

The value of function expressions is their brevity. If a function is complex
enough that types are needed to understand it, it should probably be a function
statement or a method. Conversely, if it is short enough to be an expression, it
likely doesn't need types.

<div class="good">
{% prettify dart %}
var names = people.map((person) => person.name);
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
var names = people.map((Person person) {
  return person.name;
});
{% endprettify %}
</div>


### AVOID annotating with `dynamic` when not required.

In most places in Dart, a type annotation can be omitted, in which case the type
will automatically be `dynamic`. Thus, omitting the type annotation entirely is
semantically equivalent but more terse.

<div class="good">
{% prettify dart %}
lookUpOrDefault(String name, Map map, defaultValue) {
  var value = map[name];
  if (value != null) return value;
  return defaultValue;
}
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
dynamic lookUpOrDefault(String name, Map map, dynamic defaultValue) {
  var value = map[name];
  if (value != null) return value;
  return defaultValue;
}
{% endprettify %}
</div>


### AVOID annotating with `Function`.

The `Function` type is barely more precise than using no annotation at all. If
you're bothering to annotate, it's better to use a precise function type that
describes the signature and return type of the function.

If you are annotating a field, this does mean you have to create a typedef, but
that's usually worth doing.

<div class="good">
{% prettify dart %}
bool isValidString(String value, bool predicate(String string)) { ... }
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
bool isValidString(String value, Function predicate) { ... }
{% endprettify %}
</div>

One exception is if the variable can be one of several different function types.
For example, it may allow a function that takes one mandatory parameter or a
function that takes two. Since we don't have union types, there's no way to
precisely type that and you'd normally have to use `dynamic`. `Function` is at
least a *little* more precise than that.


### DO annotate with `Object` instead of `dynamic` to indicate any object is accepted.

Some operations will work with any possible object. For example, a log method
could take any object and call `toString()` on it. Two types in Dart permit all
objects: `Object` and `dynamic`. However, they convey two different things.

The `Object` annotation says "I accept any object, and I only require it to have
the methods that `Object` itself defines."

A `dynamic` type annotation means that no type annotation can express what
objects you actually allow. (Or maybe one could, but you don't care to write
it.)

<div class="good">
{% prettify dart %}
// Accepts any object.
void log(Object object) {
  print(object.toString());
}

// Only accepts bool or String, which can't be expressed in a type annotation.
bool convertToBool(arg) {
  if (arg is bool) return arg;
  if (arg is String) return arg == 'true';
  throw new ArgumentError('Cannot convert $arg to a bool.');
}
{% endprettify %}
</div>

## Parameters

In Dart, optional parameters can be either positional or named, but not both.

### AVOID positional boolean parameters.

Unlike other types, booleans are usually used in literal form. Things like
numbers are usually wrapped in named constants, but we usually just pass around
`true` and `false` directly. That can make callsites unreadable if it isn't
clear what the boolean represents:

<div class="bad">
{% prettify dart %}
new Task(true);
new Task(false);
new ListBox(false, true, true);
new Button(false);
{% endprettify %}
</div>

Instead, consider using named arguments, named constructors, or named constants
to clarify what the call is doing.

<div class="good">
{% prettify dart %}
new Task.oneShot();
new Task.repeating();
new ListBox(scroll: true, showScrollbars: true);
new Button(ButtonState.enabled);
{% endprettify %}
</div>

Note that this doesn't apply to setters, where the name makes it clear what the
value represents:

<div class="good">
{% prettify dart %}
listBox.canScroll = true;
button.isEnabled = false;
{% endprettify %}
</div>

### AVOID optional positional parameters if the user may want to omit earlier parameters.

Optional positional parameters should have a logical progression such that
earlier parameters are passed more often than later ones. Users should almost
never need to explicitly pass a "hole" to omit an earlier positional argument to
pass later one. You're better off using named arguments for that.

<div class="good">
{% prettify dart %}
new String.fromCharCodes(Iterable source, [int start = 0, int end])
new DateTime(year, month, day, [hours, minutes, seconds, milliseconds])
new Duration({days: 0, hours: 0, minutes: 0, seconds: 0, milliseconds: 0})
{% endprettify %}
</div>

### AVOID mandatory parameters that permit nonce values.

If the user is logically omitting a parameter, prefer letting them actually omit
it by making the parameter optional instead of forcing them to pass `null`, an
empty string, or some other sentinel value that means "did not pass".

Omitting the parameter is more terse and helps prevent bugs where a sentinel
value like `null` is accidentally passed when the user thought they were
providing a real value.

<div class="good">
{% prettify dart %}
string.substring(start)
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
string.substring(start, null)
{% endprettify %}
</div>


### DO use inclusive start and exclusive end parameters to accept a range.

If you are defining a method or function that lets a user select a range of
elements or items from some integer-indexed sequence, take a start index, which
refers to the first item and a (likely optional) end index which is one greater
than the index of the last item.

This is consistent with core libraries that do the same thing.

<div class="good">
{% prettify dart %}
[0, 1, 2, 3].sublist(1, 3) // [1, 2].
'abcd'.substring(1, 3)     // "bc".
{% endprettify %}
</div>

It's particularly important to be consistent here because these parameters are
usually unnamed. If your API takes a length instead of an end point, the
difference won't be visible at all at the callsite.


## Equality

Implementing custom equality behavior for a class can be tricky. Users have deep
intuition about how equality works that your objects need to match, and
collection types like hash tables have subtle contracts that they expect
elements to follow.

### DO override `hashCode` if you override `==`.

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

The language specifies that this check is done automatically and your `==`
method is called only if the right-hand side is not `null`.

<div class="good">
{% prettify dart %}
class Person {
  final String name;

  operator ==(other) =>
      other is Person && name == other.name;
}
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
class Person {
  final String name;

  operator ==(other) =>
      other != null &&
      other is Person &&
      name == other.name;
}
{% endprettify %}
</div>

