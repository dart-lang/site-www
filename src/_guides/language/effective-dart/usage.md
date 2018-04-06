---
layout: guide
title: "Effective Dart: Usage"
description: Guidelines for using language features to write maintainable code.
nextpage:
  url: /guides/language/effective-dart/design
  title: Design
prevpage:
  url: /guides/language/effective-dart/documentation
  title: Documentation
---
<?code-excerpt replace="/([A-Z]\w*)\d\b/$1/g"?>

{% include effective-dart-banner.html %}

This is the most "blue-collar" guide in Effective Dart. You'll apply the
guidelines here every day in the bodies of your Dart code. *Users* of your
library may not be able to tell that you've internalized the ideas here, but
*maintainers* of it sure will.

* TOC
{:toc}

## Libraries

These guidelines help you compose your program out of multiple files in a
consistent, maintainable way. To keep these guidelines brief, they use "import"
to cover `import` and `export` directives. The guidelines apply equally to both.

### DO use strings in `part of` directives.

Many Dart developers avoid using `part` entirely. They find it easier to reason
about their code when each library is a single file. If you do choose to use
`part` to split part of a library out into another file, Dart requires the other
file to in turn indicate which library it's a part of. For legacy reasons, Dart
allows this `part of` directive to use the *name* of the library it's a part of.
That makes it harder for tools to physically find the main library file, and can
make it ambiguous which library the part is actually part of.

The preferred, modern syntax is to use a URI string that points directly to the
library file, just like you use in other directives. If you have some library,
`my_library.dart`, that contains:

<?code-excerpt "misc/lib/effective_dart/my_library.dart"?>
{% prettify dart %}
library my_library;

part "some/other/file.dart";
{% endprettify %}

Then the part file should look like:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/some/other/file.dart"?>
{% prettify dart %}
part of "../../my_library.dart";
{% endprettify %}

And not:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/some/other/file_2.dart"?>
{% prettify dart %}
part of my_library;
{% endprettify %}

### DON'T import libraries inside the `src` directory of another package.

The `src` directory under `lib` is specified to contain libraries private to the
package's own implementation. The way package maintainers version their package
takes this convention into account. They are free to make sweeping changes to
code under `src` without it being a breaking change to the package.

That means that if you import some other package's private library, a minor
theoretically non-breaking point release of that package could break your code.

### PREFER relative paths when importing libraries within your own package's `lib` directory.

When referencing a library inside your package's `lib` directory from another
library in that same package, either a relative URI or an explicit `package:`
will work.

For example, say your directory structure looks like:

```text
my_package
└─ lib
   ├─ src
   │  └─ utils.dart
   └─ api.dart
```

If `api.dart` wants to import `utils.dart`, it should do so using:

{:.good-style}
{% prettify dart %}
import 'src/utils.dart';
{% endprettify %}

And not:

{:.bad-style}
{% prettify dart %}
import 'package:my_package/src/utils.dart';
{% endprettify %}

There is no profound reason to prefer the former—it's just shorter and we want
to be consistent.

The "within your own package's `lib` directory" part is important. Libraries
inside `lib` can import other libraries inside `lib` (or in subdirectories of
it). Libraries outside of `lib` can use relative imports to reach other
libraries outside of `lib`. For example, you may have a test utility library
under `test` that other libraries in `test` import.

But you can't "cross the streams". A library outside of `lib` should never use a
relative import to reach a library under `lib`, or vice versa. Doing so will
break Dart's ability to correctly tell if two library URIs refer to the same
library. Follow these two rules:

* An import path should never contain `/lib/`.
* A library under `lib` should never use `../` to escape the `lib` directory.

## Strings

Here are some best practices to keep in mind when composing strings in Dart.

### DO use adjacent strings to concatenate string literals.

If you have two string literals&mdash;not values, but the actual quoted literal
form&mdash;you do not need to use `+` to concatenate them. Just like in C and
C++, simply placing them next to each other does it. This is a good way to make
a single long string that doesn't fit on one line.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (adjacent-strings-literals)"?>
{% prettify dart %}
raiseAlarm(
    'ERROR: Parts of the spaceship are on fire. Other '
    'parts are overrun by martians. Unclear which are which.');
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (adjacent-strings-literals)"?>
{% prettify dart %}
raiseAlarm('ERROR: Parts of the spaceship are on fire. Other ' +
    'parts are overrun by martians. Unclear which are which.');
{% endprettify %}

### PREFER using interpolation to compose strings and values.

If you're coming from other languages, you're used to using long chains of `+`
to build a string out of literals and other values. That does work in Dart, but
it's almost always cleaner and shorter to use interpolation:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (string-interpolation)"?>
{% prettify dart %}
'Hello, $name! You are ${year - birth} years old.';
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (string-interpolation)"?>
{% prettify dart %}
'Hello, ' + name + '! You are ' + (year - birth).toString() + ' y...';
{% endprettify %}

### AVOID using curly braces in interpolation when not needed.

If you're interpolating a simple identifier not immediately followed by more
alphanumeric text, the `{}` should be omitted.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (string-interpolation-avoid-curly)"?>
{% prettify dart %}
'Hi, $name!'
"Wear your wildest $decade's outfit."
'Wear your wildest ${decade}s outfit.'
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (string-interpolation-avoid-curly)"?>
{% prettify dart %}
'Hi, ${name}!'
"Wear your wildest ${decade}'s outfit."
{% endprettify %}

## Collections

Out of the box, Dart supports four collection types: lists, maps, queues, and sets.
The following best practices apply to collections.

### DO use collection literals when possible.

There are two ways to make an empty growable list: `[]` and `new List()`.
Likewise, there are three ways to make an empty linked hash map: `{}`, `new
Map()`, and `new LinkedHashMap()`.

If you want to create a non-growable list, or some other custom collection type
then, by all means, use a constructor. Otherwise, use the nice literal syntax.
The core library exposes those constructors to ease adoption, but idiomatic Dart
code does not use them.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (collection-literals)"?>
{% prettify dart %}
var points = [];
var addresses = {};
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (collection-literals)"?>
{% prettify dart %}
var points = new List();
var addresses = new Map();
{% endprettify %}

You can even provide a type argument for them if that matters.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (generic-collection-literals)"?>
{% prettify dart %}
var points = <Point>[];
var addresses = <String, Address>{};
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (generic-collection-literals)"?>
{% prettify dart %}
var points = new List<Point>();
var addresses = new Map<String, Address>();
{% endprettify %}

Note that this doesn't apply to the *named* constructors for those classes.
`List.from()`, `Map.fromIterable()`, and friends all have their uses. Likewise,
if you're passing a size to `new List()` to create a non-growable one, then it
makes sense to use that.

### DON'T use `.length` to see if a collection is empty.

The [Iterable][] contract does not require that a collection know its length or
be able to provide it in constant time. Calling `.length` just to see if the
collection contains *anything* can be painfully slow.

[iterable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html

Instead, there are faster and more readable getters: `.isEmpty` and
`.isNotEmpty`. Use the one that doesn't require you to negate the result.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (dont-use-length)"?>
{% prettify dart %}
if (lunchBox.isEmpty) return 'so hungry...';
if (words.isNotEmpty) return words.join(' ');
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (dont-use-length)"?>
{% prettify dart %}
if (lunchBox.length == 0) return 'so hungry...';
if (!words.isEmpty) return words.join(' ');
{% endprettify %}

### CONSIDER using higher-order methods to transform a sequence.

If you have a collection and want to produce a new modified collection from it,
it's often shorter and more declarative to use `.map()`, `.where()`, and the
other handy methods on `Iterable`.

Using those instead of an imperative `for` loop makes it clear that your intent
is to produce a new sequence and not to produce side effects.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (use-higher-order-func)"?>
{% prettify dart %}
var aquaticNames = animals
    .where((animal) => animal.isAquatic)
    .map((animal) => animal.name);
{% endprettify %}

At the same time, this can be taken too far. If you are chaining or nesting
many higher-order methods, it may be clearer to write a chunk of imperative
code.

### AVOID using `Iterable.forEach()` with a function literal.

`forEach()` functions are widely used in JavaScript because the built in
`for-in` loop doesn't do what you usually want. In Dart, if you want to iterate
over a sequence, the idiomatic way to do that is using a loop.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (avoid-forEach)"?>
{% prettify dart %}
for (var person in people) {
  ...
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (avoid-forEach)"?>
{% prettify dart %}
people.forEach((person) {
  ...
});
{% endprettify %}

The exception is if all you want to do is invoke some already existing function
with each element as the argument. In that case, `forEach()` is handy.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (forEach-over-func)"?>
{% prettify dart %}
people.forEach(print);
{% endprettify %}

### DON'T use `List.from()` unless you intend to change the type of the result.

Given an Iterable, there are two obvious ways to produce a new List that
contains the same elements:

<?code-excerpt "misc/test/effective_dart_test.dart (list-from-1)"?>
{% prettify dart %}
var copy1 = iterable.toList();
var copy2 = new List.from(iterable);
{% endprettify %}

The obvious difference is that the first one is shorter. The *important*
difference is that the first one preserves the type argument of the original
object:

<?code-excerpt "misc/test/effective_dart_test.dart (list-from-2)"?>
{% prettify dart %}
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<int>":
print(iterable.toList().runtimeType);

// Prints "List", which means List<dynamic>:
print(new List.from(iterable).runtimeType);
{% endprettify %}

If you *want* to change the type, then calling `List.from()` is useful:

<?code-excerpt "misc/test/effective_dart_test.dart (list-from-3)"?>
{% prettify dart %}
var numbers = [1, 2.3, 4]; // List<num>.
numbers.removeAt(1); // Now it only contains integers.
var ints = new List<int>.from(numbers);
{% endprettify %}

But if your goal is just to copy the iterable and preserve its original type, or
you don't care about the type, then use `toList()`.

## Functions

In Dart, even functions are objects. Here are some best practices
involving functions.

### DO use a function declaration to bind a function to a name.

Modern languages have realized how useful local nested functions and closures
are. It's common to have a function defined inside another one. In many cases,
this function is used as a callback immediately and doesn't need a name. A
function expression is great for that.

But, if you do need to give it a name, use a function declaration statement
instead of binding a lambda to a variable.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (func-decl)"?>
{% prettify dart %}
void main() {
  localFunction() {
    ...
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (func-decl)"?>
{% prettify dart %}
void main() {
  var localFunction = () {
    ...
  };
}
{% endprettify %}

### DON'T create a lambda when a tear-off will do.

If you refer to a method on an object but omit the parentheses, Dart gives you
a "tear-off"&mdash;a closure that takes the same parameters as the method and
invokes it when you call it.

If you have a function that invokes a method with the same arguments as are
passed to it, you don't need to manually wrap the call in a lambda.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (use-tear-off)"?>
{% prettify dart %}
names.forEach(print);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (use-tear-off)"?>
{% prettify dart %}
names.forEach((name) {
  print(name);
});
{% endprettify %}


## Parameters

### DO use `=` to separate a named parameter from its default value.

For legacy reasons, Dart allows both `:` and `=` as the default value separator
for named parameters. For consistency with optional positional parameters, use
`=`.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (default-separator)"?>
{% prettify dart %}
void insert(Object item, {int at = 0}) { ... }
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (default-separator)"?>
{% prettify dart %}
void insert(Object item, {int at: 0}) { ... }
{% endprettify %}


### DON'T use an explicit default value of `null`.

If you make a parameter optional but don't give it a default value, the language
implicitly uses `null` as the default, so there's no need to write it.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (default-value-null)"?>
{% prettify dart %}
void error([String message]) {
  stderr.write(message ?? '\n');
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (default-value-null)"?>
{% prettify dart %}
void error([String message = null]) {
  stderr.write(message ?? '\n');
}
{% endprettify %}

## Variables

The following best practices describe how to best use variables in Dart.

### DON'T explicitly initialize variables to `null`.

In Dart, a variable or field that is not explicitly initialized automatically
gets initialized to `null`. This is reliably specified by the language. There's
no concept of "uninitialized memory" in Dart. Adding `= null` is redundant and
unneeded.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (no-null-init)"?>
{% prettify dart %}
int _nextId;

class LazyId {
  int _id;

  int get id {
    if (_nextId == null) _nextId = 0;
    if (_id == null) _id = _nextId++;

    return _id;
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (no-null-init)"?>
{% prettify dart %}
int _nextId = null;

class LazyId {
  int _id = null;

  int get id {
    if (_nextId == null) _nextId = 0;
    if (_id == null) _id = _nextId++;

    return _id;
  }
}
{% endprettify %}


### AVOID storing what you can calculate.

When designing a class, you often want to expose multiple views into the same
underlying state. Often you see code that calculates all of those views in the
constructor and then stores them:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cacl-vs-store1)"?>
{% prettify dart %}
class Circle {
  num radius;
  num area;
  num circumference;

  Circle(num radius)
      : radius = radius,
        area = pi * radius * radius,
        circumference = pi * 2.0 * radius;
}
{% endprettify %}

This code has two things wrong with it. First, it's likely wasting memory. The
area and circumference, strictly speaking, are *caches*. They are stored
calculations that we could recalculate from other data we already have. They are
trading increased memory for reduced CPU usage. Do we know we have a performance
problem that merits that trade-off?

Worse, the code is *wrong*. The problem with caches is *invalidation*&mdash;how
do you know when the cache is out of date and needs to be recalculated? Here, we
never do, even though `radius` is mutable. You can assign a different value and
the `area` and `circumference` will retain their previous, now incorrect values.

To correctly handle cache invalidation, we need to do this:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cacl-vs-store2)"?>
{% prettify dart %}
class Circle {
  num _radius;
  num get radius => _radius;
  set radius(num value) {
    _radius = value;
    _recalculate();
  }

  num _area;
  num get area => _area;

  num _circumference;
  num get circumference => _circumference;

  Circle(this._radius) {
    _recalculate();
  }

  void _recalculate() {
    _area = pi * _radius * _radius;
    _circumference = pi * 2.0 * _radius;
  }
}
{% endprettify %}

That's an awful lot of code to write, maintain, debug, and read. Instead, your
first implementation should be:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cacl-vs-store)"?>
{% prettify dart %}
class Circle {
  num radius;

  Circle(this.radius);

  num get area => pi * radius * radius;
  num get circumference => pi * 2.0 * radius;
}
{% endprettify %}

This code is shorter, uses less memory, and is less error-prone. It stores the
minimal amount of data needed to represent the circle. There are no fields to
get out of sync because there is only a single source of truth.

In some cases, you may need to cache the result of a slow calculation, but only
do that after you know you have a performance problem, do it carefully, and
leave a comment explaining the optimization.


### CONSIDER omitting the types for local variables.

Method bodies in modern code tend to be short, and the types of local variables
are almost always trivially inferrable from the initializing expression, so
explicit type annotations are usually just visual noise.

Dart comes with powerful static analysis tools that will infer the type of local
variables and still provide the auto-complete and tooling support you expect.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (omit-types-on-locals)"?>
{% prettify dart %}
Map<int, List<Person>> groupByZip(Iterable<Person> people) {
  var peopleByZip = <int, List<Person>>{};
  for (var person in people) {
    peopleByZip.putIfAbsent(person.zip, () => <Person>[]);
    peopleByZip[person.zip].add(person);
  }
  return peopleByZip;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (omit-types-on-locals)"?>
{% prettify dart %}
Map<int, List<Person>> groupByZip(Iterable<Person> people) {
  Map<int, List<Person>> peopleByZip = <int, List<Person>>{};
  for (Person person in people) {
    peopleByZip.putIfAbsent(person.zip, () => <Person>[]);
    peopleByZip[person.zip].add(person);
  }
  return peopleByZip;
}
{% endprettify %}


## Members

In Dart, objects have members which can be functions (methods) or data (instance
variables). The following best practices apply to an object's members.

### DON'T wrap a field in a getter and setter unnecessarily.

In Java and C#, it's common to hide all fields behind getters and setters (or
properties in C#), even if the implementation just forwards to the field. That
way, if you ever need to do more work in those members, you can without needing
to touch the callsites. This is because calling a getter method is different
than accessing a field in Java, and accessing a property isn't binary-compatible
with accessing a raw field in C#.

Dart doesn't have this limitation. Fields and getters/setters are completely
indistinguishable. You can expose a field in a class and later wrap it in a
getter and setter without having to touch any code that uses that field.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (dont-wrap-field)"?>
{% prettify dart %}
class Box {
  var contents;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (dont-wrap-field)"?>
{% prettify dart %}
class Box {
  var _contents;
  get contents => _contents;
  set contents(value) {
    _contents = value;
  }
}
{% endprettify %}


### PREFER using a `final` field to make a read-only property.

If you have a field that outside code should be able to see but not assign to, a
simple solution that works in many cases is to simply mark it `final`.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (final)"?>
{% prettify dart %}
class Box {
  final contents = [];
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (final)"?>
{% prettify dart %}
class Box {
  var _contents;
  get contents => _contents;
}
{% endprettify %}

Of course, if you need to internally assign to the field outside of the
constructor, you may need to do the "private field, public getter" pattern, but
don't reach for that until you need to.


### CONSIDER using `=>` for simple members.

In addition to using `=>` for function expressions, Dart also lets you define
members with it. That style is a good fit for simple members that just calculate
and return a value.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (use-arrow)"?>
{% prettify dart %}
double get area => (right - left) * (bottom - top);

bool isReady(num time) => minTime == null || minTime <= time;

String capitalize(String name) =>
    "${name[0].toUpperCase()}${name.substring(1)}";
{% endprettify %}

People *writing* code seem to love `=>`, but it's very easy to abuse it and end
up with code that's hard to *read*. If your declaration is more than a couple of
lines or contains deeply nested expressions&mdash;cascades and conditional
operators are common offenders&mdash;do yourself and everyone who has to read
your code a favor and use a block body and some statements.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (arrow-long)"?>
{% prettify dart %}
Treasure openChest(Chest chest, Point where) {
  if (_opened.containsKey(chest)) return null;

  var treasure = new Treasure(where);
  treasure.addAll(chest.contents);
  _opened[chest] = treasure;
  return treasure;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (arrow-long)"?>
{% prettify dart %}
Treasure openChest(Chest chest, Point where) =>
    _opened.containsKey(chest) ? null : _opened[chest] = new Treasure(where)
      ..addAll(chest.contents);
{% endprettify %}

You can also use `=>` on void members that don't return a value. This is
idiomatic for small setters that have a corresponding getter also using `=>` and
where a block body would make the setter feel separate from its getter.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (arrow-setter)"?>
{% prettify dart %}
int get x => center.x;
void set x(int value) => center = new Point(value, center.y);
{% endprettify %}

It's rarely a good idea to use `=>` for other void members. The `=>` implies
"returns a value", so readers may misinterpret what the void member does if you
use it.


### DON'T use `this.` when not needed to avoid shadowing.

JavaScript requires an explicit `this.` to refer to members on the object whose
method is currently being executed, but Dart&mdash;like C++, Java, and
C#&mdash;doesn't have that limitation.

The only time you need to use `this.` is when a local variable with the same
name shadows the member you want to access.

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (this-dot)"?>
{% prettify dart %}
class Box {
  var value;

  void clear() {
    this.update(null);
  }

  void update(value) {
    this.value = value;
  }
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (this-dot)"?>
{% prettify dart %}
class Box {
  var value;

  void clear() {
    update(null);
  }

  void update(value) {
    this.value = value;
  }
}
{% endprettify %}

Note that constructor parameters never shadow fields in constructor
initialization lists:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (param-dont-shadow-field-ctr-init)"?>
{% prettify dart %}
class Box extends BaseBox {
  var value;

  Box(value)
      : value = value,
        super(value);
}
{% endprettify %}

This looks surprising, but works like you want. Fortunately, code like this is
relatively rare thanks to initializing formals.


### DO initialize fields at their declaration when possible.

If a field doesn't depend on any constructor parameters, it can and should be
initialized at its declaration. It takes less code and makes sure you won't
forget to initialize it if the class has multiple constructors.

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (field-init-at-decl)"?>
{% prettify dart %}
class Folder {
  final String name;
  final List<Document> contents;

  Folder(this.name) : contents = [];
  Folder.temp() : name = 'temporary'; // Oops! Forgot contents.
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (field-init-at-decl)"?>
{% prettify dart %}
class Folder {
  final String name;
  final List<Document> contents = [];

  Folder(this.name);
  Folder.temp() : name = 'temporary';
}
{% endprettify %}

Of course, if a field depends on constructor parameters, or is initialized
differently by different constructors, then this guideline does not apply.


## Constructors

The following best practices apply to declaring constructors for a class.

### DO use initializing formals when possible.

Many fields are initialized directly from a constructor parameter, like:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (field-init-as-param)"?>
{% prettify dart %}
class Point {
  num x, y;
  Point(num x, num y) {
    this.x = x;
    this.y = y;
  }
}
{% endprettify %}

We've got to type `x` _four_ times here define a field. Lame. We can do better:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (field-init-as-param)"?>
{% prettify dart %}
class Point {
  num x, y;
  Point(this.x, this.y);
}
{% endprettify %}

This `this.` syntax before a constructor parameter is called an "initializing
formal". You can't always take advantage of it. In particular, using it means
the parameter is not visible in the initialization list. But, when you can, you
should.


### DON'T type annotate initializing formals.

If a constructor parameter is using `this.` to initialize a field, then the type
of the parameter is understood to be the same type as the field.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (dont-type-init-formals)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(this.x, this.y);
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (dont-type-init-formals)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(int this.x, int this.y);
}
{% endprettify %}


### DO use `;` instead of `{}` for empty constructor bodies.

In Dart, a constructor with an empty body can be terminated with just a
semicolon. (In fact, it's required for const constructors.)

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (semicolon-for-empty-body)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(this.x, this.y);
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (semicolon-for-empty-body)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(this.x, this.y) {}
}
{% endprettify %}


### DO place the `super()` call last in a constructor initialization list.

Field initializers are evaluated in the order that they appear in the
constructor initialization list. If you place a `super()` call in the middle of
an initializer list, the superclass's initializers will be evaluated right then
before evaluating the rest of the subclass's initializers.

What it *doesn't* mean is that the superclass's *constructor body* is executed
then. That always happens after all initializers are run regardless of where
`super()` appears. Placing the `super()` elsewhere is confusing and almost never
useful.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (super-first)"?>
{% prettify dart %}
View(Style style, List children)
    : _children = children,
      super(style);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (super-first)"?>
{% prettify dart %}
View(Style style, List children)
    : super(style),
      _children = children;
{% endprettify %}

{% comment %}update-for-dart-2{% endcomment %}
<div class="alert alert-danger" markdown="1">
**Dart 2 note:** The call to `super()` _must be last_ in Dart 2, otherwise
an error is reported.
</div>

## Error handling

Dart uses exceptions when an error occurs in your program. The following
best practices apply to catching and throwing exceptions.

### AVOID catches without `on` clauses.

A catch clause with no `on` qualifier catches *anything* thrown by the code in
the try block. [Pokémon exception handling][pokemon] is very likely not what you
want. Does your code correctly handle [StackOverflowError][] or
[OutOfMemoryError][]? If you incorrectly pass the wrong argument to a method in
that try block do you want to have your debugger point you to the mistake or
would you rather that helpful [ArgumentError][] get swallowed? Do you want any
`assert()` statements inside that code to effectively vanish since you're
catching the thrown [AssertionError][]s?

The answer is probably "no", in which case you should filter the types you
catch. In most cases, you should have an `on` clause that limits you to the
kinds of runtime failures you are aware of and are correctly handling.

In rare cases, you may wish to catch any runtime error. This is usually in
framework or low-level code that tries to insulate arbitrary application code
from causing problems. Even here, it is usually better to catch [Exception][]
than to catch all types. Exception is the base class for all *runtime* errors
and excludes errors that indicate *programmatic* bugs in the code.


### DON'T discard errors from catches without `on` clauses.

If you really do feel you need to catch *everything* that can be thrown from a
region of code, *do something* with what you catch. Log it, display it to the
user or rethrow it, but do not silently discard it.


### DO throw objects that implement `Error` only for programmatic errors.

The [Error][] class is the base class for *programmatic* errors. When an object
of that type or one of its subinterfaces like [ArgumentError][] is thrown, it
means there is a *bug* in your code. When your API wants to report to a caller
that it is being used incorrectly throwing an Error sends that signal clearly.

Conversely, if the exception is some kind of runtime failure that doesn't
indicate a bug in the code, then throwing an Error is misleading. Instead, throw
one of the core Exception classes or some other type.


### DON'T explicitly catch `Error` or types that implement it.

This follows from the above. Since an Error indicates a bug in your code, it
should unwind the entire callstack, halt the program, and print a stack trace so
you can locate and fix the bug.

[error]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/Error-class.html

Catching errors of these types breaks that process and masks the bug. Instead of
*adding* error-handling code to deal with this exception after the fact, go back
and fix the code that is causing it to be thrown in the first place.


### DO use `rethrow` to rethrow a caught exception.

If you decide to rethrow an exception, prefer using the `rethrow` statement
instead of throwing the same exception object using `throw`.
`rethrow` preserves the original stack trace of the exception. `throw` on the
other hand resets the stack trace to the last thrown position.

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (rethrow)"?>
{% prettify dart %}
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) throw e;
  handle(e);
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (rethrow)" replace="/rethrow/[!$&!]/g"?>
{% prettify dart %}
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) [!rethrow!];
  handle(e);
}
{% endprettify %}


## Asynchrony

Dart has several language features to support asynchronous programming.
The following best practices apply to asynchronous coding.

### PREFER async/await over using raw futures.

Asynchronous code is notoriously hard to read and debug, even when using a nice
abstraction like futures. The `async`/`await` syntax improves readability and
lets you use all of the Dart control flow structures within your async code.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (async-await)" replace="/async|await/[!$&!]/g"?>
{% prettify dart %}
Future<int> countActivePlayers(String teamName) [!async!] {
  try {
    var team = [!await!] downloadTeam(teamName);
    if (team == null) return 0;

    var players = [!await!] team.roster;
    return players.map((player) => player.isActive).length;
  } catch (e) {
    log.error(e);
    return 0;
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (async-await)"?>
{% prettify dart %}
Future<int> countActivePlayers(String teamName) {
  return downloadTeam(teamName).then((team) {
    if (team == null) return new Future.value(0);

    return team.roster.then((players) {
      return players.map((player) => player.isActive).length;
    });
  }).catchError((e) {
    log.error(e);
    return 0;
  });
}
{% endprettify %}

### DON'T use `async` when it has no useful effect.

It's easy to get in the habit of using `async` on any function that does
anything related to asynchrony. But in some cases, it's extraneous. If you can
omit the `async` without changing the behavior of the function, do so.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (unnecessary-async)"?>
{% prettify dart %}
Future afterTwoThings(Future first, Future second) {
  return Future.wait([first, second]);
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (unnecessary-async)"?>
{% prettify dart %}
Future afterTwoThings(Future first, Future second) async {
  return Future.wait([first, second]);
}
{% endprettify %}

Cases where `async` *is* useful include:

* You are using `await`. (This is the obvious one.)

* You are returning an error asynchronously. `async` and then `throw` is shorter
  than `return new Future.error(...)`.

* You are returning a value and you want it implicitly wrapped in a future.
  `async` is shorter than `new Future.value(...)`.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (async)"?>
{% prettify dart %}
Future usesAwait(Future later) async {
  print(await later);
}

Future asyncError() async {
  throw 'Error!';
}

Future asyncValue() async => 'value';
{% endprettify %}

### CONSIDER using higher-order methods to transform a stream.

This parallels the above suggestion on iterables. Streams support many of the
same methods and also handle things like transmitting errors, closing, etc.
correctly.

### AVOID using Completer directly.

Many people new to asynchronous programming want to write code that produces a
future. The constructors in Future don't seem to fit their need so they
eventually find the Completer class and use that.

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (avoid-completer)"?>
{% prettify dart %}
Future<bool> fileContainsBear(String path) {
  var completer = new Completer<bool>();

  new File(path).readAsString().then((contents) {
    completer.complete(contents.contains('bear'));
  });

  return completer.future;
}
{% endprettify %}

Completer is needed for two kinds of low-level code: new asynchronous
primitives, and interfacing with asynchronous code that doesn't use futures.
Most other code should use async/await or [`Future.then()`][then], because
they're clearer and make error handling easier.

[then]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future/then.html

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (avoid-completer)"?>
{% prettify dart %}
Future<bool> fileContainsBear(String path) {
  return new File(path).readAsString().then((contents) {
    return contents.contains('bear');
  });
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (avoid-completer-alt)"?>
{% prettify dart %}
Future<bool> fileContainsBear(String path) async {
  var contents = await new File(path).readAsString();
  return contents.contains('bear');
}
{% endprettify %}

[pokemon]: https://blog.codinghorror.com/new-programming-jargon/
[StackOverflowError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/StackOverflowError-class.html
[OutOfMemoryError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/OutOfMemoryError-class.html
[ArgumentError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/ArgumentError-class.html
[AssertionError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/AssertionError-class.html
[Exception]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Exception-class.html
