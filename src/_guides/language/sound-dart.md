---
layout: guide
title: "Sound Dart"
description: "."
---

This guide tells you why and how to write sound (type safe) Dart code.
You'll learn how to use strong mode to enable soundness, as well as
how to substitute types safely when overriding methods.

{% comment %}
Not ready yet...
If you are already using strong mode Dart, you might also check out
[Sound Dart: Common Problems](/guides/language/sound-dart-common-problems).
{% endcomment %}

<aside class="alert alert-info" markdown="1">
**Note:** The terms "sound Dart", "strong mode Dart", and "type safe Dart"
are sometimes used interchangeably. _Strong mode_ is Dart's implementation
of a sound type system. With strong mode enabled,
Dart is a type safe language. "Classic Dart" refers to Dart
before soundness was added to the language.
</aside>

By writing sound Dart code today, you'll reap some benefits now,
with more in the near future. Current benefits include finding bugs
at compile time (rather than at runtime) using Dart's static analyzer.
And soon you'll be able to use new tools that quickly and incrementally
compile your sound Dart code, giving you a better overall
developer experience.

Sound Dart adds only a few additional rules beyond that for classic
Dart&mdash;mostly you clarify code where the types are ambiguous or
incorrect. In fact, most strong mode errors can be fixed by adding type
annotations to your Lists and Maps. The following code shows valid
but unsound Dart code. The `fn()` function prints an integer list.
The `main()` function creates a list of integers and passes it to `fn()`:

<div class="fails-sa" markdown="1">
{% prettify dart %}
void fn(List<int> a) {
  print(a);
}

main() {
  var list = [];
  list.add(1);
  list.add("2");
  fn([[highlight]]list[[/highlight]]);
}
{% endprettify %}
</div>

In classic Dart, this code passes analysis with no errors. Once you enable
strong mode, a warning appears on `list` (shown in bold) in the call to
`fn(list)`. The warning states **Unsound implicit cast from List&lt;dynamic&gt;
to List&lt;int&gt;**. The `var list = []` line creates a list of type
`dynamic` because it doesn't have enough information to infer a type.
The `fn` function expects a list of type `int`, causing a mismatch of types.
When specifying a type annotation on creation of the list, as shown in bold,
the static analyzer points out that a string can't be assigned to
the parameter type int.
the list, as shown in bold:

<div class="passes-sa" markdown="1">
{% prettify dart %}
void fn(List<int> a) {
  print(a);
}

void main() {
  var list = [[highlight]]<int>[[/highlight]][];
  list.add(1);
  list.add([[highlight]]2[[/highlight]]);
  fn(list);
}
{% endprettify %}
</div>

{% comment %}
Note: Can't use embedded DP because it does not provide a Strong mode
checkbox.
Gist:  https://gist.github.com/3c7c95683f0c06be8326a2fd3975cd19
DartPad url: https://dartpad.dartlang.org/3c7c95683f0c06be8326a2fd3975cd19
{% endcomment %}

[Try it in DartPad](https://dartpad.dartlang.org/3c7c95683f0c06be8326a2fd3975cd19).

## What is soundness?

Soundness is about the relationship between the code that you write and
the values that show up in the code at runtime. In a sound language,
if the static type of an expression is `int`, once you evaluate the
experssion to a value, you are guaranteed to get an `int` and nothing
else (except possibly null).

Dart was created as an optionally typed language and is not sound.
For example, it is valid to create a list in Dart that contains
integers, strings, and streams. Your program will not fail to compile
or run just because the list contains mixed types, even if the list
is specified as a list of `float` but contains every type except
floating point values.

In classic Dart, the problem occurs at runtime&mdash;fetching a
`Stream` from a list but getting another type results in a runtime
exception and the app crashes. For example, the following code
assigns a list of type `dynamic` (which contains strings) to a list
of type `int`. Iterating through the list and substracting 10 from
each item causes a runtime exception since the minus operator isn't
defined for strings.

<div class="fails-sa" markdown="1">
{% prettify dart %}
main () {
  List<dynamic> strings = ["not", "ints"];
  [[highlight]]List<int> numbers = strings;[[/highlight]]
  for (var number in numbers) {
    [[highlight]]print(number - 10); // <— Boom![[/highlight]]
  }
}
{% endprettify %}
</div>

Once strong mode is enabled, the analyzer warns you that this assignment
is a problem and the runtime error is avoided.

New tools in development for the Dart language rely on ahead-of-time (AOT)
compilation. AOT compiling benefits significantly from strong type
checking that can be performed at compile time. For this reason,
the Dart language now offers strong mode.

Strong mode enables Dart to have a sound type system. Strong mode Dart
won't let a `List<dynamic>` pretend to be a `List<int>` and then let
you pull non-integers out of it.

## The benefits of soundness

A sound type system has several benefits:

* Revealing type-related bugs at compile time.<br>
  A sound type system forces code to be unambiguous about its types,
  so type-related bugs that might be tricky to find at runtime are
  revealed at compile time.

* More readable code.<br>
  Code is easier to read because you can rely on a value actually having
  the specified type. In sound Dart, types can't lie.

* More maintainable code.<br>
  With a sound type system, when you change one piece of code, the
  type system can do a better job of warning you about the other pieces
  of code that just broke.

* Better ahead of time (AOT) compilation.
  While AOT compilation is possible without strong types, the generated
  code is much less efficient.

* Cleaner JavaScript.
  For web apps, strong mode's more restictive typing allows the Dart
  Dev Compiler (DDC) to generate more compact, cleaner JavaScript.

## What constitutes strong mode?

Dart's strong mode implementation, which enables soundness, consists
of three pieces:

* Sound type system
* Runtime checks
* Type inference

### Sound type system

Creating a sound type system requires only a few changes to the code.
With strong mode enabled, Dart Analyzer enforces three additional rules:

* Use proper return types when overriding methods.
* Use proper input parameter types when overriding methods.
* Don't abuse dynamic lists (or other generics).

The following examples use this type hierarchy:

<img src="images/type-hierarchy.png" alt="a hierarchy of animals where the supertype is Animal and the subtypes are Alligator, Cat, and HoneyBadger. Cat has the subtypes of Lion and MaineCoon">

#### Use proper return types when overriding methods <a name="use-proper-return-types"></a>

<br>
Define the return type of the method in the superclass to be a proper
subtype of the return type of the method in the superclass. Consider
the getter method in the Animal class:

{% prettify dart %}
class Animal {
  void chase(Animal a) {}
  [[highlight]]Animal get parent => ...[[/highlight]]
}
{% endprettify %}

The `parent` getter method returns an Animal. In the HoneyBadger subclass,
you can replace the getter's return type with HoneyBadger (a subtype),
but an Alligator is not a likely parent for a HoneyBadger.

<div class="passes-sa" markdown="1">
{% prettify dart %}
class HoneyBadger {
  void chase(Animal a) {}
  [[highlight]]HoneyBadger[[/highlight]] get parent => ...
}
{% endprettify %}
</div>

<div class="fails-sa" markdown="1">
{% prettify dart %}
class HoneyBadger {
  void chase(Animal a) {}
  [[highlight]]Alligator[[/highlight]] get parent => ...
}
{% endprettify %}
</div>

#### Use proper input parameter types when overriding methods <a name="use-proper-param-types"></a>

<br>
Define the input parameter to be the same type, or a supertype of the
corresponding parameter in the superclass. Don't "tighten" the parameter
type by replacing the type with a subtype of the original parameter.

<aside class="alert alert-info" markdown="1">
**Note:** If you have a valid reason to do this, learn about the
[@checked annotation](#checked-annotation).
</aside>

Consider the `chase(Animal)` method for the Animal class:

{% prettify dart %}
class Animal {
  [[highlight]]void chase(Animal a) {}[[/highlight]]
  Animal get parent => ...
}
{% endprettify %}

The `chase()` method takes an Animal. A HoneyBadger chases anything.
It's OK to override the `chase` method to take anything (Object).

<div class="passes-sa" markdown="1">
{% prettify dart %}
class HoneyBadger extends Animal {
  void chase([[highlight]]Object[[/highlight]] a) {}
  Animal get parent => ...
}
{% endprettify %}
</div>

The following code tightens the input parameter on the `chase` method
from Animal to Mouse, a subclass of Animal.

<div class="fails-sa" markdown="1">
{% prettify dart %}
class Animal {
  void chase(Animal x) {}
}

class Mouse extends Animal {}

class Cat extends Animal {
  void chase([[highlight]]Mouse[[/highlight]] x) {}
}
{% endprettify %}
</div>

This code is not type safe because it would then be possible to define
a cat and send it after an alligator:

<div class="fails-sa" markdown="1">
{% prettify dart %}
Animal a = new Cat();
a.chase(new [[highlight]]Alligator[[/highlight]]());   // NOT TYPE SAFE (or feline safe)
{% endprettify %}
</div>

#### Don't abuse dynamic lists (or other generics)

<br>
Don't use a dynamic list to hold other types. The same goes for creating
a dynamic instance of a class and using it to stash other types.
The following code creates a dynamic list of Dog, and assigns it to
a list of type Cat.

<div class="fails-sa" markdown="1">
{% prettify dart %}
class Animal {}

class Dog extends Animal {}

class Cat extends Animal {}

void main() {
  List<Cat> foo = [[highlight]]<dynamic>[[/highlight]][new Dog()];
}
{% endprettify %}
</div>

Using the dynamic type to "hide" other types is prohibited in strong
mode Dart and results in analyzer errors.

## Runtime checks

The changes to Dart's type system as described in this document handle
most of what's needed to make the Dart language sound. However, the
Dart Dev Compiler (DDC) has runtime checks to deal with the remaining
dynamism in the language.

For example, the following code passes strong mode checks in the analyzer:

{% prettify dart %}
class Animal {}

class Dog extends Animal {}

class Cat extends Animal {}

void main() {
  [[highlight]]List<Animal> animals = [new Dog()];[[/highlight]]
  [[highlight]]List<Cat> cats = animals;[[/highlight]]
}
{% endprettify %}

However, the app throws an exception at runtime because it is an error
to assign a list of Dogs to a list of Cats.

<aside class="alert alert-info" markdown="1">
**Note:** As of release 1.21, only DDC implements these runtime checks,
but support in other tools is coming.
</aside>

## Type inference

Does strong mode Dart mean that you _always_ have to specify a type?

Actually, no. Strong mode Dart supports type inference. In some cases,
the analyzer can infer types for fields, methods, local variables,
and generic type arguments.

### Field and method inference

Fields and methods which have types left off of them, and which override
a field or method from the superclass, inherit the type of the
subclass method or field.

Fields that do not get a type via inheritance will get a type inferred
for them from their initializer.

### Static field inference

Static fields and variables get their types inferred from their
initializer. Note that inference fails if it encounters a cycle
(inferring a type for variable `a` directly or indirectly relies
on having a type for `a`).

### Local variable inference

Local variables are inferred from their initializer. Subsequent
assignments are not taken into account. This may mean that too precise
a type may be inferred. If so, you can add a type annotation.

<div class="fails-sa" markdown="1">
{% prettify dart %}
var x = 3;    // x is inferred as an int
x = 4.0;
{% endprettify %}
</div>

<div class="passes-sa" markdown="1">
{% prettify dart %}
num y = 3; // y is defined as num which can be double or int
y = 4.0;
{% endprettify %}
</div>

### Type argument inference

Type arguments to constructor calls and generic method invocations are
inferred based on a combination of downward information from the context
of occurrence, and upwards information from the arguments to the constructor
or generic method. If inference is not doing what you want or expect,
you can always explicitly pass the type arguments.

<div class="passes-sa" markdown="1">
{% prettify dart %}
// Inferred as if you wrote <int>[].
List<int> listOfInt = [];

// Inferred as if you wrote <double>[3.0].
var listOfDouble = [3.0];

// x is inferred as double using downward information.
// Return type of the closure is inferred as int using upwards information.
// Type argument to map() is inferred as <int> using upwards information.
var listOfInt2 = listOfDouble.map((x) => x.toInt());
{% endprettify %}
</div>

## How to enable strong mode

Dart's static analysis engine enforces type safety. You can enable
strong mode using one of the following approaches:

* Use an analysis options file
* Call dartanalyzer with the strong mode flag
* Enable strong mode in DartPad

### Use an analysis options file

Create an analysis options file at the package root of your project.
Besides turning on strong mode, you can also enable any of the
available linter rules. For more information, see
[Customize Static Analysis](/guides/language/analysis-options).

### Call dartanalyzer with strong mode enabled

The [dartanalyzer](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer)
tool supports several flags related to strong mode:

| --[no-]strong | Enable strong static checks |
| --no-implicit-casts | Disable implicit casts in strong mode |
| --no-implicit-dynamic | Disable implicit dynamic |
{:.table .table-striped .nowrap}

For more information on these flags, see
[Specifying strong mode](/guides/language/analysis-options#specifying-strong-mode).

<aside class="alert alert-info" markdown="1">
**Note:** An analysis options file in the same directory where you call
dartanalyzer overrides the command line flag. So, if the analysis options
file disables strong mode, you can't enable it using `--strong`.
</aside>

### Enable strong mode in DartPad

If you use [DartPad](/tools/dartpad) to write and test code, you can
enable strong mode by checking the **Strong mode** box in the lower
right corner. Note that DartPad doesn't support the implicit casts flag,
implicit dynamic flag, or enabling linter rules. For this functionality
you must use DDC or IntelliJ for now.

## Substituting types

When you override a method, you are replacing something of one type
(the old method) with something of a new type (the new method).
Similarly, when you pass an argument to a function,
you are replacing something which has one type (a parameter
with a declared type) with something that has another type
(the actual argument). When can you replace something which
has one type with something that has a subtype or a supertype?

When substituting types, it helps to think in terms of _producers_
and _consumers_. A consumer absorbs a type and a producer generates a type.

**You can replace a consumer's type with a supertype. You can replace
a producer's type with a subtype.**

Let's look at examples of simple type assignment and assignment with
generic types.

### Simple type assignment

When assigning objects to objects, when can you replace a type with a
different type? The answer depends on whether the object is a consumer
or a producer.

Consider the following type hierarchy:

<img src="images/type-hierarchy.png" alt="a hierarchy of animals where the supertype is Animal and the subtypes are Alligator, Cat, and HoneyBadger. Cat has the subtypes of Lion and MaineCoon">

The following diagram shows the consumer and producer for a simple
assignment:

<img src="images/consumer-producer-assignment.png" alt="Cat c = new Cat(), where Cat c is the consumer and new Cat() is the producer">

In a consuming position, it's safe to replace something that consumes a
specific type (Cat) with something that consumes anything (Animal),
so replacing `Cat c` with `Animal c` is allowed, because Animal is
a supertype of Cat.

<div class="passes-sa" markdown="1">
{% prettify dart %}
Animal c = new Cat();
{% endprettify %}
</div>

But replacing `Cat c` with `MaineCoon c` breaks type safety, because the
superclass may provide a type of Cat with different behaviors, such
as Lion:

<div class="fails-sa" markdown="1">
{% prettify dart %}
MaineCoon c = new Cat();
{% endprettify %}
</div>

In a producing position, it's safe to replace something that produces a
type (Cat) with a more specific type (MaineCoon). So, the following
is allowed:

<div class="passes-sa" markdown="1">
{% prettify dart %}
Cat c = new MaineCoon();
{% endprettify %}
</div>

### Generic type assignment

Are the rules the same for generic types? Yes. Consider the hierarchy
of lists of animals&mdash;a List of Cat is a subtype of a List of
Animal, and a supertype of a List of MaineCoon:

<img src="images/type-hierarchy-generics.png" alt="List<Animal> -> List<Cat> -> List<MaineCoon>">

In the following example, you can substitute
`new List<Cat>()` with `new List<MaineCoon>()` because
`List<MaineCoon>` is a subtype of `List<Cat>`.

<div class="passes-sa" markdown="1">
{% prettify dart %}
class Animal {
  void feed() {}
}

class Cat extends Animal {}

class MaineCoon extends Cat {}

void feedAnimals(Iterable<Animal> animals) {
  for (var animal in animals) {
    animal.feed();
  }
}

main(List<String> args) {
  // Was: List<Cat> myCats = new List<Cat>();
  List<Cat> myCats = new List<[[highlight]]MaineCoon[[/highlight]]>();
  Cat muffin = new Cat();
  Cat winky = new Cat();
  Cat bongo = new Cat();
  myCats.addAll([muffin, winky, bongo]);

  feedAnimals(myCats);
}
{% endprettify %}
</div>

{% comment %}
Gist:  https://gist.github.com/4a2a9bc2242042ba5338533d091213c0
DartPad: https://dartpad.dartlang.org/4a2a9bc2242042ba5338533d091213c0

[Try it in DartPad](https://dartpad.dartlang.org/4a2a9bc2242042ba5338533d091213c0).
{% endcomment %}

What about going in the other direction? Can you replace
`new List<Cat>` with `new List<Animal>`?

{% prettify dart %}
// Was: List<Cat> myCats = new List<Cat>();
List<Cat> myCats = new List<Animal>();
{% endprettify %}

This assignment passes static analysis under strong mode,
but it creates an implied cast. It is equivalent to:

{% prettify dart %}
List<Cat> myCats = new List<Animal>() as List<Cat>;
{% endprettify %}

The code may fail at runtime. You can disallow similar implied casts
using the `-no-implicit-casts` flag. For more information, see
[Runtime checks](#runtime-checks).

### Methods

When overriding a method, the producer and consumer rules still apply.
For example:

<img src="images/consumer-producer-methods.png" alt="Animal class showing the chase method as the consumer and the parent getter as the producer">

For a consumer (such as the `chase(Animal)` method), you can replace
the input parameter type with a supertype. For a producer (such as
the `parent` getter method), you can replace the return type with
a subtype.

For more information, see
[Use proper return types when overriding methods](#use-proper-return-types)
and [Use proper input parameter types when overriding methods](#use-proper-param-types).

## The @checked annotation <a name="checked-annotation"></a>

Some (rarely used) coding patterns rely on tightening a type by overriding
an input parameter's type with a subtype, which is illegal in strong
mode Dart. In this case, you can use the `@checked` annotation to
tell the analyzer that you are doing this intentionally.
This removes the static error and instead checks for an invalid
parameter type at runtime.

<aside class="alert alert-info" markdown="1">
**Note:** Don't use `@checked` in DartPad. DartPad doesn't support
importing packages and `@checked` comes from package:meta.
</aside>

The following shows how you might use `@checked`:

{% prettify dart %}
import 'package:meta/meta.dart';

class Animal {
  void chase(Animal x) {}
}

class Mouse extends Animal {}

class Cat extends Animal {
  void chase(@checked Mouse x) {}
}
{% endprettify %}

The annotation applies to a single parameter and can be placed on the
superclass or subclass method.
Usually the superclass method is the best place to put it.
The `@checked` annotation is also supported on setters and fields.

## Strong mode vs. checked mode

You may be familiar with the Dart compiler's checked mode feature.
In checked mode, the compiler inserts dynamic type assertions and
generates a warning if the types don't match up. For example,
the following line of code generates a runtime warning in checked mode:

{% prettify dart %}
String result = 1 + 2;
{% endprettify %}

However, even in checked mode, there is no guarantee that an expression
will evaluate to a specific type at runtime. Checked mode provides some
type checking but does not result in fully sound code. Consider the
following example:

{% prettify dart %}
// util.dart

void info(List<int> list) {
  var length = list.length;
  if (length != 0) print(length + list[0]);
}
{% endprettify %}

It is reasonable to expect the `info` function to print either nothing
(empty list) or a single integer (non-empty list), and that Dart's
static tooling and checked mode would enforce this.

However, in the following context, the info method prints
"helloworld" in checked mode, without any static errors or warnings.

<div class="fails-sa" markdown="1">
{% prettify dart %}
import 'dart:collection';
import 'util.dart';

class MyList extends ListBase<int> implements List {
   Object length;

   MyList(this.length);

   operator[](index) => 'world';
   operator[]=(index, value) {}
}

void main() {
   List<int> list = new MyList('hello');
   info(list);
}
{% endprettify %}
</div>

This code raises no issues when run in checked mode, but generates
numerous errors when analyzed under strong mode.

## Other resources

The following resources have further information on sound Dart and
strong mode:

* [Sound Dart](https://www.youtube.com/watch?v=DKG5CMyol9U) - Leaf
  Peterson's talk from 2016 Dart Summit
* [Customize Static Analysis](/guides/language/analysis-options) - how
  to set up and customize the analyzer and linter using an analysis
  options file

The next four documents are part of the Dart Dev Compiler (DDC) documentation,
but most of the information applies to anyone using strong mode Dart:

* [Strong Mode](https://github.com/dart-lang/dev_compiler/blob/master/STRONG_MODE.md) - motivation for strong mode Dart
* [Strong Mode Static Checking](https://github.com/dart-lang/dev_compiler/blob/master/doc/STATIC_SAFETY.md) - type inference in strong mode Dart
* [Strong Mode in the Dart Dev Compiler](https://chromium.googlesource.com/external/github.com/dart-lang/dev_compiler/+/refs/heads/master/doc/RUNTIME_SAFETY.md) - runtime checks in DDC
* [Prototype Syntax for Generic Methods](https://github.com/dart-lang/dev_compiler/blob/master/doc/GENERIC_METHODS.md) - generic methods were recently introduced to Dart and make it easier to write sound code

