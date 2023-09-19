---
title: Understanding null safety
description: A deep dive into Dart language and library changes related to null safety.
---

_Written by Bob Nystrom<br>
July 2020_

Null safety is the largest change we've made to Dart since we replaced the
original unsound optional type system with [a sound static type system][strong]
in Dart 2.0. When Dart first launched, compile-time null safety was a rare
feature needing a long introduction. Today, Kotlin, Swift, Rust, and other
languages all have their own answers to what has become a very [familiar
problem.][billion] Here is an example:

[strong]: /language/type-system
[billion]: https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/

```dart
// Without null safety:
bool isEmpty(String string) => string.length == 0;

main() {
  isEmpty(null);
}
```

If you run this Dart program without null safety, it throws a
`NoSuchMethodError` exception on the call to `.length`. The `null` value is an
instance of the `Null` class, and `Null` has no "length" getter. Runtime
failures suck. This is especially true in a language like Dart that is designed
to run on an end-user's device. If a server application fails, you can often
restart it before anyone notices. But when a Flutter app crashes on a user's
phone, they are not happy. When your users aren't happy, you aren't happy.

Developers like statically-typed languages like Dart because they enable the
type checker to find mistakes in code at compile time, usually right in the IDE.
The sooner you find a bug, the sooner you can fix it. When language designers
talk about "fixing null reference errors", they mean enriching the static type
checker so that the language can detect mistakes like the above attempt to call
`.length` on a value that might be `null`.

There is no one true solution to this problem. Rust and Kotlin both have their
own approach that makes sense in the context of those languages. This doc walks
through all the details of our answer for Dart. It includes changes to the
static type system and a suite of other modifications and new language features
to let you not only write null-safe code but hopefully to *enjoy* doing so.

This document is long. If you want something shorter that covers just what you
need to know to get up and running, start with the [overview][]. When you are
ready for a deeper understanding and have the time, come back here so you can
understand *how* the language handles `null`, *why* we designed it that way, and
how to write idiomatic, modern, null-safe Dart. (Spoiler alert: it ends up
surprisingly close to how you write Dart today.)

[overview]: /null-safety

The various ways a language can tackle null reference errors each have their
pros and cons. These principles guided the choices we made:

*   **Code should be safe by default.** If you write new Dart code and don't use
    any explicitly unsafe features, it never throws a null reference error at
    runtime. All possible null reference errors are caught statically. If you
    want to defer some of that checking to runtime to get greater flexibility,
    you can, but you have to choose that by using some feature that is textually
    visible in the code.

    In other words, we aren't giving you a life jacket and leaving it up to you
    to remember to put it on every time you go out on the water. Instead, we
    give you a boat that doesn't sink. You stay dry unless you jump overboard.

*   **Null safe code should be easy to write.** Most existing Dart code is
    dynamically correct and does not throw null reference errors. You like your
    Dart program the way it looks now, and we want you to be able to keep
    writing code that way. Safety shouldn't require sacrificing usability,
    paying penance to the type checker, or having to significantly change the
    way you think.

*   **The resulting null safe code should be fully sound.** "Soundness" in the
    context of static checking means different things to different people. For
    us, in the context of null safety, that means that if an expression has a
    static type that does not permit `null`, then no possible execution of that
    expression can ever evaluate to `null`. The language provides this guarantee
    mostly through static checks, but there can be some runtime checks involved
    too. (Though, note the first principle: any place where those runtime checks
    happen will be your choice.)

    Soundness is important for user confidence. A boat that *mostly* stays
    afloat is not one you're enthused to brave the open seas on. But it's also
    important for our intrepid compiler hackers. When the language makes hard
    guarantees about semantic properties of a program, it means that the
    compiler can perform optimizations that assume those properties are true.
    When it comes to `null`, it means we can generate smaller code that
    eliminates unneeded `null` checks, and faster code that doesn't need to
    verify a receiver is non-`null` before calling methods on it.

    One caveat: We only guarantee soundness in Dart programs that are fully null
    safe. Dart supports programs that contain a mixture of newer null safe code
    and older legacy code. In these mixed-version programs, null reference errors
    may still occur. In a mixed-version program, you get all of the *static* safety
    benefits in the portions that are null safe, but you don't get full runtime
    soundness until the entire application is null safe.

Note that *eliminating* `null` is not a goal. There's nothing wrong with `null`.
On the contrary, it's really useful to be able to represent the *absence* of a
value. Building support for a special "absent" value directly into the language
makes working with absence flexible and usable. It underpins optional
parameters, the handy `?.` null-aware operator, and default initialization. It
is not `null` that is bad, it is having `null` go *where you don't expect it*
that causes problems.

Thus with null safety, our goal is to give you *control* and *insight* into
where `null` can flow through your program and certainty that it can't flow
somewhere that would cause a crash.

## Nullability in the type system

Null safety begins in the static type system because everything else rests upon
that. Your Dart program has a whole universe of types in it: primitive types
like `int` and `String`, collection types like `List`, and all of the classes
and types you and the packages you use define. Before null safety, the static
type system allowed the value `null` to flow into expressions of any of those
types.

In type theory lingo, the `Null` type was treated as a subtype of all types:

<img src="/assets/img/null-safety/understanding-null-safety/hierarchy-before.png" width="335">

The set of operations—getters, setters, methods, and
operators—allowed on some expressions are defined by its type. If the type
is `List`, you can call `.add()` or `[]` on it. If it's `int`, you can call `+`.
But the `null` value doesn't define any of those methods. Allowing `null` to
flow into an expression of some other type means any of those operations can
fail. This is really the crux of null reference errors—every failure comes
from trying to look up a method or property on `null` that it doesn't have.

### Non-nullable and nullable types

Null safety eliminates that problem at the root by changing the type hierarchy.
The `Null` type still exists, but it's no longer a subtype of all types.
Instead, the type hierarchy looks like this:

<img src="/assets/img/null-safety/understanding-null-safety/hierarchy-after.png" width="344">

Since `Null` is no longer a subtype, no type except the special `Null` class
permits the value `null`. We've made all types *non-nullable by default*. If you
have a variable of type `String`, it will always contain *a string*. There,
we've fixed all null reference errors.

If we didn't think `null` was useful at all, we could stop here. But `null` is
useful, so we still need a way to handle it. Optional parameters are a good
illustrative case. Consider this null safe Dart code:

```dart
// Using null safety:
makeCoffee(String coffee, [String? dairy]) {
  if (dairy != null) {
    print('$coffee with $dairy');
  } else {
    print('Black $coffee');
  }
}
```

Here, we want to allow the `dairy` parameter to accept any string, or the value
`null`, but nothing else. To express that, we give `dairy` a *nullable type* by
slapping `?` at the end of the underlying base type `String`. Under the hood,
this is essentially defining a [union][] of the underlying type and the `Null`
type. So `String?` would be a shorthand for `String|Null` if Dart had
full-featured union types.

[union]: https://en.wikipedia.org/wiki/Union_type

### Using nullable types

If you have an expression with a nullable type, what can you do with the result?
Since our principle is safe by default, the answer is not much. We can't let you
call methods of the underlying type on it because those might fail if the value
is `null`:

```dart
// Hypothetical unsound null safety:
bad(String? maybeString) {
  print(maybeString.length);
}

main() {
  bad(null);
}
```

This would crash if we let you run it. The only methods and properties we can
safely let you access are ones defined by both the underlying type and the
`Null` class. That's just `toString()`, `==`, and `hashCode`. So you can use
nullable types as map keys, store them in sets, compare them to other values,
and use them in string interpolation, but that's about it.

How do they interact with non-nullable types? It's always safe to pass a
*non*-nullable type to something expecting a nullable type. If a function
accepts `String?` then passing a `String` is allowed because it won't cause any
problems. We model this by making every nullable type a supertype of its
underlying type. You can also safely pass `null` to something expecting a nullable type, so
`Null` is also a subtype of every nullable type:

<img src="/assets/img/null-safety/understanding-null-safety/nullable-hierarchy.png" width="235">

But going the other direction and passing a nullable type to something expecting
the underlying non-nullable type is unsafe. Code that expects a `String` may
call `String` methods on the value. If you pass a `String?` to it, `null` could
flow in and that could fail:

```dart
// Hypothetical unsound null safety:
requireStringNotNull(String definitelyString) {
  print(definitelyString.length);
}

main() {
  String? maybeString = null; // Or not!
  requireStringNotNull(maybeString);
}
```

This program is not safe and we shouldn't allow it. However, Dart has always had
this thing called *implicit downcasts*. If you, for example, pass a value of
type `Object` to a function expecting an `String`, the type checker allows it:

```dart
// Without null safety:
requireStringNotObject(String definitelyString) {
  print(definitelyString.length);
}

main() {
  Object maybeString = 'it is';
  requireStringNotObject(maybeString);
}
```

To maintain soundness, the compiler silently inserts an `as String` cast on the
argument to `requireStringNotObject()`. That cast could fail and throw an
exception at runtime, but at compile time, Dart says this is OK. Since
non-nullable types are modeled as subtypes of nullable types, implicit downcasts
would let you pass a `String?` to something expecting a `String`. Allowing that
would violate our goal of being safe by default. So with null safety we are
removing implicit downcasts entirely.

This makes the call to `requireStringNotNull()` produce a compile error, which
is what you want. But it also means *all* implicit downcasts become compile
errors, including the call to `requireStringNotObject()`. You'll have to add the
explicit downcast yourself:

```dart
// Using null safety:
requireStringNotObject(String definitelyString) {
  print(definitelyString.length);
}

main() {
  Object maybeString = 'it is';
  requireStringNotObject(maybeString as String);
}
```

We think this is an overall good change. Our impression is that most users never
liked implicit downcasts. In particular, you may have been burned by this
before:

```dart
// Without null safety:
List<int> filterEvens(List<int> ints) {
  return ints.where((n) => n.isEven);
}
```

Spot the bug? The `.where()` method is lazy, so it returns an `Iterable`, not a
`List`. This program compiles but then throws an exception at runtime when it
tries to cast that `Iterable` to the `List` type that `filterEvens` declares it
returns. With the removal of implicit downcasts, this becomes a compile error.

Where were we? Right, OK, so it's as if we've taken the universe of types in
your program and split them into two halves:

<img src="/assets/img/null-safety/understanding-null-safety/bifurcate.png" width="668">

There is a region of non-nullable types. Those types let you access all of the
interesting methods, but can never ever contain `null`. And then there is a
parallel family of all of the corresponding nullable types. Those permit `null`,
but you can't do much with them. We let values flow from the non-nullable side
to the nullable side because doing so is safe, but not the other direction.

That seems like nullable types are basically useless. They have no methods and
you can't get away from them. Don't worry, we have a whole suite of features to
help you move values from the nullable half over to the other side that we will
get to soon.

### Top and bottom

This section is a little esoteric. You can mostly skip it, except for two
bullets at the very end, unless you're into type system stuff. Imagine all the
types in your program with edges between ones that are subtypes and supertypes
of each other. If you were to draw it, like the diagrams in this doc, it would
form a huge directed graph with supertypes like `Object` near the top and leaf
classes like your own types near the bottom.

If that directed graph comes to a point at the top where there is a single type
that is the supertype (directly or indirectly), that type is called the *top
type*. Likewise, if there is a weird type at that bottom that is a subtype of
every type, you have a *bottom type*. (In this case, your directed graph is a
[lattice.][lattice])

[lattice]: https://en.wikipedia.org/wiki/Lattice_(order)

It's convenient if your type system has a top and bottom type, because it means
that type-level operations like least upper bound (which type inference uses to
figure out the type of a conditional expression based on the types of its two
branches) can always produce a type. Before null safety, `Object` was Dart's top
type and `Null` was its bottom type.

Since `Object` is non-nullable now, it is no longer a top type. `Null` is not a
subtype of it. Dart has no *named* top type. If you need a top type, you want
`Object?`. Likewise, `Null` is no longer the bottom type. If it was, everything
would still be nullable. Instead, we've added a new bottom type named `Never`:

<img src="/assets/img/null-safety/understanding-null-safety/top-and-bottom.png" width="360">

In practice, this means:

*   If you want to indicate that you allow a value of any type, use `Object?`
    instead of `Object`. In fact, it becomes pretty unusual to use `Object`
    since that type means "could be any possible value except this one weirdly
    prohibited value `null`".

*   On the rare occasion that you need a bottom type, use
    `Never` instead of `Null`.
    This is particularly useful to indicate a function never returns
    to [help reachability analysis](#never-for-unreachable-code).
    If you don't know if you need a bottom type, you probably don't.

## Ensuring correctness

We divided the universe of types into nullable and non-nullable halves. In order
to maintain soundness and our principle that you can never get a null reference
error at runtime unless you ask for it, we need to guarantee that `null` never
appears in any type on the non-nullable side.

Getting rid of implicit downcasts and removing `Null` as a bottom type covers
all of the main places that types flow through a program across assignments and
from arguments into parameters on function calls. The main remaining places
where `null` can sneak in are when a variable first comes into being and when
you leave a function. So there are some additional compile errors:

### Invalid returns

If a function has a non-nullable return type, then every path through the
function must reach a `return` statement that returns a value. Before null
safety, Dart was pretty lax about missing returns. For example:

```dart
// Without null safety:
String missingReturn() {
  // No return.
}
```

If you analyzed this, you got a gentle *hint* that *maybe* you forgot a return,
but if not, no big deal. That's because if execution reaches the end of a
function body then Dart implicitly returns `null`. Since every type is nullable,
*technically* this function is safe, even though it's probably not what you
want.

With sound non-nullable types, this program is flat out wrong and unsafe. Under
null safety, you get a compile error if a function with a non-nullable return
type doesn't reliably return a value. By "reliably", I mean that the language
analyzes all of the control flow paths through the function. As long as they all
return something, it is satisfied. The analysis is pretty smart, so even this
function is OK:

```dart
// Using null safety:
String alwaysReturns(int n) {
  if (n == 0) {
    return 'zero';
  } else if (n < 0) {
    throw ArgumentError('Negative values not allowed.');
  } else {
    if (n > 1000) {
      return 'big';
    } else {
      return n.toString();
    }
  }
}
```

We'll dive more deeply into the new flow analysis in the next section.

### Uninitialized variables

When you declare a variable, if you don't give it an explicit initializer, Dart
default initializes the variable with `null`. That's convenient, but obviously
totally unsafe if the variable's type is non-nullable. So we have to tighten
things up for non-nullable variables:

*   **Top level variable and static field declarations must have an
    initializer.** Since these can be accessed and assigned from anywhere in the
    program, it's impossible for the compiler to guarantee that the variable has
    been given a value before it gets used. The only safe option is to require
    the declaration itself to have an initializing expression that produces a
    value of the right type:

    ```dart
    // Using null safety:
    int topLevel = 0;

    class SomeClass {
      static int staticField = 0;
    }
    ```

*   **Instance fields must either have an initializer at the declaration, use an
    initializing formal, or be initialized in the constructor's initialization
    list.** That's a lot of jargon. Here are the examples:

    ```dart
    // Using null safety:
    class SomeClass {
      int atDeclaration = 0;
      int initializingFormal;
      int initializationList;

      SomeClass(this.initializingFormal)
          : initializationList = 0;
    }
    ```

    In other words, as long as the field has a value before you reach the
    constructor body, you're good.

*   Local variables are the most flexible case. A non-nullable local variable
    *doesn't* need to have an initializer. This is perfectly fine:

    ```dart
    // Using null safety:
    int tracingFibonacci(int n) {
      int result;
      if (n < 2) {
        result = n;
      } else {
        result = tracingFibonacci(n - 2) + tracingFibonacci(n - 1);
      }

      print(result);
      return result;
    }
    ```

    The rule is only that **a local variable must be *definitely assigned*
    before it is used.** We get to rely on the new flow analysis I alluded to
    for this as well. As long as every path to a variable's use initializes it
    first, the use is OK.

*   **Optional parameters must have a default value.** If you don't pass an
    argument for an optional positional or named parameter, then the language
    fills it in with the default value. If you don't specify a default value,
    the _default_ default value is `null`, and that doesn't fly if the parameter's
    type is non-nullable.

    So, if you want a parameter to be optional, you need to either make it
    nullable or specify a valid non-`null` default value.

These restrictions sound onerous, but they aren't too bad in practice. They are
very similar to the existing restrictions around `final` variables and you've
likely been working with those for years without even really noticing. Also,
remember that these only apply to *non-nullable* variables. You can always make
the type nullable and then get the default initialization to `null`.

Even so, the rules do cause friction. Fortunately, we have a suite of new
language features to lubricate the most common patterns where these new
limitations slow you down. First, though, it's time to talk about flow analysis.

## Flow analysis

[Control flow analysis][] has been around in compilers for years. It's mostly
hidden from users and used during compiler optimization, but some newer
languages have started to use the same techniques for visible language features.
Dart already has a dash of flow analysis in the form of *type promotion*:

```dart
// With (or without) null safety:
bool isEmptyList(Object object) {
  if (object is List) {
    return object.isEmpty; // <-- OK!
  } else {
    return false;
  }
}
```

[control flow analysis]: https://en.wikipedia.org/wiki/Control_flow_analysis

Note how on the marked line, we can call `isEmpty` on `object`. That method is
defined on `List`, not `Object`. This works because the type checker looks at
all of the `is` expressions and the control flow paths in the program. If the
body of some control flow construct only executes when a certain `is` expression
on a variable is true, then inside that body the variable's type is "promoted"
to the tested type.

In the example here, the then branch of the `if` statement only runs when
`object` actually contains a list. Therefore, Dart promotes `object` to type
`List` instead of its declared type `Object`. This is a handy feature, but it's
pretty limited. Prior to null safety, the following functionally identical
program did not work:

```dart
// Without null safety:
bool isEmptyList(Object object) {
  if (object is! List) return false;
  return object.isEmpty; // <-- Error!
}
```

Again, you can only reach the `.isEmpty` call when `object` contains a list, so
this program is dynamically correct. But the type promotion rules were not smart
enough to see that the `return` statement means the second statement can only be
reached when `object` is a list.

For null safety, we've taken this limited analysis and made it [much more
powerful in several ways.][flow analysis]

[flow analysis]: https://github.com/dart-lang/language/blob/main/resources/type-system/flow-analysis.md

### Reachability analysis

First off, we fixed the [long-standing complaint][18921] that type promotion
isn't smart about early returns and other unreachable code paths. When analyzing
a function, it now takes into account `return`, `break`, `throw`, and any other
way execution might terminate early in a function. Under null safety, this function:

[18921]: https://github.com/dart-lang/sdk/issues/18921

```dart
// Using null safety:
bool isEmptyList(Object object) {
  if (object is! List) return false;
  return object.isEmpty;
}
```

Is now perfectly valid. Since the `if` statement will exit the function when
`object` is *not* a `List`, Dart promotes `object` to be `List` on the second
statement. This is a really nice improvement that helps a lot of Dart code, even
stuff not related to nullability.

### Never for unreachable code

You can also *program* this reachability analysis. The new bottom type `Never`
has no values. (What kind of value is simultaneously a `String`, `bool`, and
`int`?) So what does it mean for an expression to have type `Never`? It means
that expression can never successfully finish evaluating. It must throw an
exception, abort, or otherwise ensure that the surrounding code expecting the
result of the expression never runs.

In fact, according to the language, the static type of a `throw` expression is
`Never`. The type `Never` is declared in the core libraries and you can use it
as a type annotation. Maybe you have a helper function to make it easier to
throw a certain kind of exception:

```dart
// Using null safety:
Never wrongType(String type, Object value) {
  throw ArgumentError('Expected $type, but was ${value.runtimeType}.');
}
```

You might use it like so:

```dart
// Using null safety:
class Point {
  final double x, y;

  bool operator ==(Object other) {
    if (other is! Point) wrongType('Point', other);
    return x == other.x && y == other.y;
  }

  // Constructor and hashCode...
}
```

This program analyzes without error. Notice that the last line of the `==`
method accesses `.x` and `.y` on `other`. It has been promoted to `Point` even
though the function doesn't have any `return` or `throw`. The control flow
analysis knows that the declared type of `wrongType()` is `Never` which means
the then branch of the `if` statement *must* abort somehow. Since the second
statement can only be reached when `other` is a `Point`, Dart promotes it.

In other words, using `Never` in your own APIs lets you extend Dart's
reachability analysis.

### Definite assignment analysis

I mentioned this one briefly with local variables. Dart needs to ensure a
non-nullable local variable is always initialized before it is read. We use
*definite assignment analysis* to be as flexible about that as possible. The
language analyzes each function body and tracks the assignments to local
variables and parameters through all control flow paths. As long as the variable
is assigned on every path that reaches some use of a variable, the variable is
considered initialized. This lets you declare a variable with no initializer and
then initialize it afterwards using complex control flow, even when the variable
has a non-nullable type.

We also use definite assignment analysis to make *final* variables more
flexible. Before null safety, it can be difficult to use `final` for local
variables if you need to initialize them in any sort of interesting way:

```dart
// Using null safety:
int tracingFibonacci(int n) {
  final int result;
  if (n < 2) {
    result = n;
  } else {
    result = tracingFibonacci(n - 2) + tracingFibonacci(n - 1);
  }

  print(result);
  return result;
}
```

This would be an error since the `result` variable is `final` but has no
initializer. With the smarter flow analysis under null safety, this program is
fine. The analysis can tell that `result` is definitely initialized exactly once
on every control flow path, so the constraints for marking a variable `final`
are satisfied.

### Type promotion on null checks

The smarter flow analysis helps lots of Dart code, even code not related to
nullability. But it's not a coincidence that we're making these changes now. We
have partitioned types into nullable and non-nullable sets. If you have a value
of a nullable type, you can't really *do* anything useful with it. In cases
where the value *is* `null`, that restriction is good. It's preventing you from
crashing.

But if the value isn't `null`, it would be good to be able to move it over to
the non-nullable side so you can call methods on it. Flow analysis is one of the
primary ways to do this for local variables and parameters. We've extended type
promotion to also look at `== null` and `!= null` expressions.

If you check a local variable with nullable type to see if it is not `null`, 
Dart then promotes the variable to the underlying non-nullable type:

```dart
// Using null safety:
String makeCommand(String executable, [List<String>? arguments]) {
  var result = executable;
  if (arguments != null) {
    result += ' ' + arguments.join(' ');
  }
  return result;
}
```

Here, `arguments` has a nullable type. Normally, that prohibits you from calling
`.join()` on it. But because we have guarded that call in an `if` statement that
checks to ensure the value is not `null`, Dart promotes it from `List<String>?`
to `List<String>` and lets you call methods on it or pass it to functions that
expect non-nullable lists.

This sounds like a fairly minor thing, but this flow-based promotion on null
checks is what makes most existing Dart code work under null safety. Most Dart
code *is* dynamically correct and does avoid throwing null reference errors by
checking for `null` before calling methods. The new flow analysis on null checks
turns that *dynamic* correctness into provable *static* correctness.

It also, of course, works with the smarter analysis we do for reachability. The
above function can be written just as well as:

```dart
// Using null safety:
String makeCommand(String executable, [List<String>? arguments]) {
  var result = executable;
  if (arguments == null) return result;
  return result + ' ' + arguments.join(' ');
}
```

The language is also smarter about what kinds of expressions cause promotion. An
explicit `== null` or `!= null` of course works. But explicit casts using `as`,
or assignments, or the postfix `!` operator we'll get to soon also cause
promotion. The general goal is that if the code is dynamically correct and it's
reasonable to figure that out statically, the analysis should be clever enough
to do so.

Note that type promotion only works on local variables,
not on fields or top-level variables.
For more information about working with non-local variables,
see [Working with nullable fields](#working-with-nullable-fields).

### Unnecessary code warnings

Having smarter reachability analysis and knowing where `null` can flow through
your program helps ensure that you *add* code to handle `null`. But we can also
use that same analysis to detect code that you *don't* need. Before null safety,
if you wrote something like:

```dart
// Using null safety:
String checkList(List<Object> list) {
  if (list?.isEmpty ?? false) {
    return 'Got nothing';
  }
  return 'Got something';
}
```

Dart had no way of knowing if that null-aware `?.` operator is useful or not.
For all it knows, you could pass `null` to the function. But in null safe Dart,
if you have annotated that function with the now non-nullable `List` type, then
it knows `list` will never be `null`. That implies the `?.` will never do
anything useful and you can and should just use `.`.

To help you simplify your code, we've added warnings for unnecessary code like
this now that the static analysis is precise enough to detect it. Using a
null-aware operator or even a check like `== null` or `!= null` on a
non-nullable type gets reported as a warning.

And, of course, this plays with non-nullable type promotion too. Once a
variable has been promoted to a non-nullable type, you get a warning if you
redundantly check it again for `null`:

```dart
// Using null safety:
String checkList(List<Object>? list) {
  if (list == null) return 'No list';
  if (list?.isEmpty ?? false) {
    return 'Empty list';
  }
  return 'Got something';
}
```

You get a warning on the `?.` here because at the point that it executes, we
already know `list` cannot be `null`. The goal with these warnings is not just
to clean up pointless code. By removing *unneeded* checks for `null`, we ensure
that the remaining meaningful checks stand out. We want you to be able to look
at your code and *see* where `null` can flow.

## Working with nullable types

We've now corralled `null` into the set of nullable types. With flow analysis,
we can safely let some non-`null` values hop over the fence to the non-nullable
side where we can use them. That's a big step, but if we stop here, the
resulting system is still painfully restrictive. Flow analysis only helps with
locals and parameters.

To try to regain as much of the flexibility that Dart had before null
safety—and to go beyond it on some places—we have a handful of other
new features.

### Smarter null-aware methods

Dart's null aware operator `?.` is much older than null safety. The runtime
semantics state that if the receiver is `null` then the property access on the
right-hand side is skipped and the expression evaluates to `null`:

```dart
// Without null safety:
String notAString = null;
print(notAString?.length);
```

Instead of throwing an exception, this prints "null". The null-aware operator is
a nice tool for making nullable types usable in Dart. While we can't let you
call methods on nullable types, we can and do let you use null-aware operators
on them. The post-null safety version of the program is:

```dart
// Using null safety:
String? notAString = null;
print(notAString?.length);
```

It works just like the previous one.

However, if you've ever used null-aware operators in Dart, you've probably
encountered an annoyance when using them in method chains. Let's say you want to
see if the length of a potentially absent string is an even number (not a
particularly realistic problem, I know, but work with me here):

```dart
// Using null safety:
String? notAString = null;
print(notAString?.length.isEven);
```

Even though this program uses `?.`, it still throws an exception at runtime. The
problem is that the receiver of the `.isEven` expression is the result of the
entire `notAString?.length` expression to its left. That expression evaluates to
`null`, so we get a null reference error trying to call `.isEven`. If you've
ever used `?.` in Dart, you probably learned the hard way that you have to apply
the null-aware operator to *every* property or method in a chain after you use
it once:

```dart
String? notAString = null;
print(notAString?.length?.isEven);
```

This is annoying, but, worse, it obscures important information. Consider:

```dart
// Using null safety:
showGizmo(Thing? thing) {
  print(thing?.doohickey?.gizmo);
}
```

Here's a question for you: Can the `doohickey` getter on `Thing` return `null`?
It looks like it *could* because you're using `?.` on the result. But it may
just be that the second `?.` is only there to handle cases where `thing` is
`null`, not the result of `doohickey`. You can't tell.

To address this, we borrowed a smart idea from C#'s design of the same feature.
When you use a null-aware operator in a method chain, if the receiver evaluates
to `null`, then *the entire rest of the method chain is short-circuited and
skipped*. This means if `doohickey` has a non-nullable return type, then you
can and should write:

```dart
// Using null safety:
showGizmo(Thing? thing) {
  print(thing?.doohickey.gizmo);
}
```

In fact, you'll get an unnecessary code warning on the second `?.` if you
don't. If you see code like:

```dart
// Using null safety:
showGizmo(Thing? thing) {
  print(thing?.doohickey?.gizmo);
}
```

Then you know for certain it means that `doohickey` itself has a nullable return
type. Each `?.` corresponds to a *unique* path that can cause `null` to flow
into the method chain. This makes null-aware operators in method chains both
more terse and more precise.

While we were at it, we added a couple of other null-aware operators:

```dart
// Using null safety:

// Null-aware cascade:
receiver?..method();

// Null-aware index operator:
receiver?[index];
```

There isn't a null-aware function call operator, but you can write:

```dart
// Allowed with or without null safety:
function?.call(arg1, arg2);
```

### Null assertion operator

The great thing about using flow analysis to move a nullable variable to the
non-nullable side of the world is that doing so is provably safe. You get to
call methods on the previously-nullable variable without giving up any of the
safety or performance of non-nullable types.

But many valid uses of nullable types can't be *proven* to be safe in a way that
pleases static analysis. For example:

```dart
// Using null safety, incorrectly:
class HttpResponse {
  final int code;
  final String? error;

  HttpResponse.ok()
      : code = 200,
        error = null;
  HttpResponse.notFound()
      : code = 404,
        error = 'Not found';

  @override
  String toString() {
    if (code == 200) return 'OK';
    return 'ERROR $code ${error.toUpperCase()}';
  }
}
```

If you try to run this, you get a compile error on the call to `toUpperCase()`.
The `error` field is nullable because it won't have a value in a successful
response. We can see by inspecting the class that we never access the `error`
message when it is `null`. But that requires understanding the relationship
between the value of `code` and the nullability of `error`. The type checker
can't see that connection.

In other words, we human maintainers of the code *know* that error won't be
`null` at the point that we use it and we need a way to assert that. Normally,
you assert types using an `as` cast, and you can do the same thing here:

```dart
// Using null safety:
String toString() {
  if (code == 200) return 'OK';
  return 'ERROR $code ${(error as String).toUpperCase()}';
}
```

Casting `error` to the non-nullable `String` type will throw a runtime exception
if the cast fails. Otherwise, it gives us a non-nullable string that we can then
call methods on.

"Casting away nullability" comes up often enough that we have a new shorthand
syntax. A postfix exclamation mark (`!`) takes the expression on the left and
casts it to its underlying non-nullable type. So the above function is
equivalent to:

```dart
// Using null safety:
String toString() {
  if (code == 200) return 'OK';
  return 'ERROR $code ${error!.toUpperCase()}';
}
```

This one-character "bang operator" is particularly handy when the underlying
type is verbose. It would be really annoying to have to write `as
Map<TransactionProviderFactory, List<Set<ResponseFilter>>>` just to cast away a
single `?` from some type.

Of course, like any cast, using `!` comes with a loss of static safety. The cast
must be checked at runtime to preserve soundness and it may fail and throw an
exception. But you have control over where these casts are inserted, and you can
always see them by looking through your code.

### Late variables

The most common place where the type checker cannot prove the safety of code is
around top-level variables and fields. Here is an example:

```dart
// Using null safety, incorrectly:
class Coffee {
  String _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature + ' coffee';
}

main() {
  var coffee = Coffee();
  coffee.heat();
  coffee.serve();
}
```

Here, the `heat()` method is called before `serve()`. That means `_temperature`
will be initialized to a non-null value before it is used. But it's not feasible
for a static analysis to determine that. (It might be possible for a trivial
example like this one, but the general case of trying to track the state of each
instance of a class is intractable.)

Because the type checker can't analyze uses of fields and top-level variables,
it has a conservative rule that non-nullable fields have to be initialized
either at their declaration (or in the constructor initialization list for
instance fields). So Dart reports a compile error on this class.

You can fix the error by making the field nullable and then using null assertion
operators on the uses:

```dart
// Using null safety:
class Coffee {
  String? _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature! + ' coffee';
}
```

This works fine. But it sends a confusing signal to the maintainer of the class.
By marking `_temperature` nullable, you imply that `null` is a useful,
meaningful value for that field. But that's not the intent. The `_temperature`
field should never be *observed* in its `null` state.

To handle the common pattern of state with delayed initialization, we've added a
new modifier, `late`. You can use it like this:

```dart
// Using null safety:
class Coffee {
  late String _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature + ' coffee';
}
```

Note that the `_temperature` field has a non-nullable type, but is not
initialized. Also, there's no explicit null assertion when it's used. There are
a few models you can apply to the semantics of `late`, but I think of it like
this: The `late` modifier means "enforce this variable's constraints at runtime
instead of at compile time". It's almost like the word "late" describes *when*
it enforces the variable's guarantees.

In this case, since the field is not definitely initialized, every time the
field is read, a runtime check is inserted to make sure it has been assigned a
value. If it hasn't, an exception is thrown. Giving the variable the type
`String` means "you should never see me with a value other than a string" and
the `late` modifier means "verify that at runtime".

In some ways, the `late` modifier is more "magical" than using `?` because any
use of the field could fail, and there isn't anything textually visible at the
use site. But you *do* have to write `late` at the declaration to get this
behavior, and our belief is that seeing the modifier there is explicit enough
for this to be maintainable.

In return, you get better static safety than using a nullable type. Because the
field's type is non-nullable now, it is a *compile* error to try to assign
`null` or a nullable `String` to the field. The `late` modifier lets you *defer*
initialization, but still prohibits you from treating it like a nullable
variable.

### Lazy initialization

The `late` modifier has some other special powers too. It may seem paradoxical,
but you can use `late` on a field that has an initializer:

```dart
// Using null safety:
class Weather {
  late int _temperature = _readThermometer();
}
```

When you do this, the initializer becomes *lazy*. Instead of running it as soon
as the instance is constructed, it is deferred and run lazily the first time the
field is accessed. In other words, it works exactly like an initializer on a
top-level variable or static field. This can be handy when the initialization
expression is costly and may not be needed.

Running the initializer lazily gives you an extra bonus when you use `late` on
an instance field. Usually instance field initializers cannot access `this`
because you don't have access to the new object until all field initializers
have completed. But with a `late` field, that's no longer true, so you *can*
access `this`, call methods, or access fields on the instance.

### Late final variables

You can also combine `late` with `final`:

```dart
// Using null safety:
class Coffee {
  late final String _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature + ' coffee';
}
```

Unlike normal `final` fields, you do not have to initialize the field in its
declaration or in the constructor initialization list. You can assign to it
later at runtime. But you can only assign to it *once*, and that fact is checked
at runtime. If you try to assign to it more than once—like calling both
`heat()` and `chill()` here—the second assignment throws an exception.
This is a great way to model state that gets initialized eventually and is
immutable afterwards.

In other words, the new `late` modifier in combination with Dart's other
variable modifiers covers most of the feature space of `lateinit` in Kotlin and
`lazy` in Swift. You can even use it on local variables if you want a little
local lazy evaluation.

### Required named parameters

To guarantee that you never see a `null` parameter with a non-nullable type, the
type checker requires all optional parameters to either have a nullable type or
a default value. What if you want to have a named parameter with a non-nullable
type and no default value? That would imply that you want to require the caller
to *always* pass it. In other words, you want a parameter that is *named*
but not optional.

I visualize the various kinds of Dart parameters with this table:

```
             mandatory    optional
            +------------+------------+
positional  | f(int x)   | f([int x]) |
            +------------+------------+
named       | ???        | f({int x}) |
            +------------+------------+
```

For unclear reasons, Dart has long supported three corners of this table but
left the combination of named+mandatory empty. With null safety, we filled that
in. You declare a required named parameter by placing `required` before the
parameter:

```dart
// Using null safety:
function({int? a, required int? b, int? c, required int? d}) {}
```

Here, all the parameters must be passed by name. The parameters `a` and `c` are
optional and can be omitted. The parameters `b` and `d` are required and must
be passed. Note that required-ness is independent of nullability. You can have
required named parameters of nullable types, and optional named parameters of
non-nullable types (if they have a default value).

This is another one of those features that I think makes Dart better regardless
of null safety. It simply makes the language feel more complete to me.

### Abstract fields

One of the neat features of Dart is that
it upholds a thing called the [uniform access principle][].
In human terms it means that
fields are indistinguishable from getters and setters.
It's an implementation detail whether a "property" in some Dart class
is computed or stored.
Because of this,
when defining an interface using an abstract class,
it's typical to use a field declaration:

[uniform access principle]: https://en.wikipedia.org/wiki/Uniform_access_principle

```dart
abstract class Cup {
  Beverage contents;
}
```

The intent is that users only implement that class and don't extend it.
The field syntax is simply a shorter way of writing a getter/setter pair:

```dart
abstract class Cup {
  Beverage get contents;
  set contents(Beverage);
}
```

But Dart doesn't *know* that this class will never be used as a concrete type.
It sees that `contents` declaration as a real field.
And, unfortunately, that field is non-nullable and has no initializer,
so you get a compile error.

One fix is to use explicit abstract getter/setter declarations
like in the second example.
But that's a little verbose,
so with null safety
we also added support for explicit abstract field declarations:

```dart
abstract class Cup {
  abstract Beverage contents;
}
```

This behaves exactly like the second example.
It simply declares an abstract getter and setter with the given name and type.

### Working with nullable fields

These new features cover many common patterns and make working with `null`
pretty painless most of the time. But even so, our experience is that nullable
fields can still be difficult. In cases where you can make the field `late` and
non-nullable, you're golden. But in many cases you need to *check* to see if the
field has a value, and that requires making it nullable so you can observe the
`null`.

You might expect this to work:

```dart
// Using null safety, incorrectly:
class Coffee {
  String? _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  void checkTemp() {
    if (_temperature != null) {
      print('Ready to serve ' + _temperature + '!');
    }
  }

  String serve() => _temperature! + ' coffee';
}
```

Inside `checkTemp()`, we check to see if `_temperature` is `null`. If not, we
access it and end up calling `+` on it. Unfortunately, this is not allowed.
Flow-based type promotion does not apply to fields because the static analysis
cannot *prove* that the field's value doesn't change between the point that you
check for `null` and the point that you use it. (Consider that in pathological
cases, the field itself could be overridden by a getter in a subclass that
returns `null` the second time it is called.)

So, since we care about soundness, fields don't promote and the above method
does not compile. This is annoying. In simple cases like here, your best bet is
to slap a `!` on the use of the field. It seems redundant, but that's more or
less how Dart behaves today.

Another pattern that helps is to copy the field to a local variable first and
then use that instead:

```dart
// Using null safety:
void checkTemp() {
  var temperature = _temperature;
  if (temperature != null) {
    print('Ready to serve ' + temperature + '!');
  }
}
```

Since the type promotion does apply to locals, this now works fine. If you need
to *change* the value, just remember to store back to the field and not just the
local.

For more information on handling these and other type promotion issues,
see [Fixing type promotion failures](/tools/non-promotion-reasons).

### Nullability and generics

Like most modern statically-typed languages, Dart has generic classes and
generic methods. They interact with nullability in a few ways that seem
counter-intuitive but make sense once you think through the implications. First
is that "is this type nullable?" is no longer a simple yes or no question.
Consider:

```dart
// Using null safety:
class Box<T> {
  final T object;
  Box(this.object);
}

main() {
  Box<String>('a string');
  Box<int?>(null);
}
```

In the definition of `Box`, is `T` a nullable type or a non-nullable type? As
you can see, it can be instantiated with either kind. The answer is that `T` is a
*potentially nullable type*. Inside the body of a generic class or method, a
potentially nullable type has all of the restrictions of both nullable types
*and* non-nullable types.

The former means you can't call any methods on it except the handful defined on
Object. The latter means that you must initialize any fields or variables of
that type before they're used. This can make type parameters pretty hard to work with.

In practice, a few patterns show up. In collection-like classes where the type
parameter can be instantiated with any type at all, you just have to deal with
the restrictions. In most cases, like the example here, it means ensuring you do
have access to a value of the type argument's type whenever you need to work
with one. Fortunately, collection-like classes rarely call methods on their
elements.

In places where you don't have access to a value, you can make the use of the
type parameter nullable:

```dart
// Using null safety:
class Box<T> {
  T? object;
  Box.empty();
  Box.full(this.object);
}
```

Note the `?` on the declaration of `object`. Now the field has an explicitly
nullable type, so it is fine to leave it uninitialized.

When you make a type parameter type nullable like `T?` here, you may need to
cast the nullability away. The correct way to do that is using an explicit `as
T` cast, *not* the `!` operator:

```dart
// Using null safety:
class Box<T> {
  T? object;
  Box.empty();
  Box.full(this.object);

  T unbox() => object as T;
}
```

The `!` operator *always* throws if the value is `null`. But if the type
parameter has been instantiated with a nullable type, then `null` is a perfectly
valid value for `T`:

```dart
// Using null safety:
main() {
  var box = Box<int?>.full(null);
  print(box.unbox());
}
```

This program should run without error. Using `as T` accomplishes that. Using
`!` would throw an exception.

Other generic types have some bound that restricts the kinds of type arguments
that can be applied:

```dart
// Using null safety:
class Interval<T extends num> {
  T min, max;

  Interval(this.min, this.max);

  bool get isEmpty => max <= min;
}
```

If the bound is non-nullable, then the type parameter is also non-nullable. This
means you have the restrictions of non-nullable types—you can't leave
fields and variables uninitialized. The example class here must have a
constructor that initializes the fields.

In return for that restriction, you can call any methods on values of the type
parameter type that are declared on its bound. Having a non-nullable bound does,
however, prevent *users* of your generic class from instantiating it with a
nullable type argument. That's probably a reasonable limitation for most
classes.

You can also use a nullable *bound*:

```dart
// Using null safety:
class Interval<T extends num?> {
  T min, max;

  Interval(this.min, this.max);

  bool get isEmpty {
    var localMin = min;
    var localMax = max;

    // No min or max means an open-ended interval.
    if (localMin == null || localMax == null) return false;
    return localMax <= localMin;
  }
}
```

This means that in the body of the class you get the flexibility of treating the
type parameter as nullable, but you also have the limitations of nullability. 
You can't call anything on a variable of that type
unless you deal with the nullability first. In the example here, 
we copy the fields in local variables and check those locals for `null` 
so that flow analysis promotes them to non-nullable types before we use `<=`.

Note that a nullable bound does not prevent users from instantiating the class
with non-nullable types. A nullable bound means that the type argument *can* be
nullable, not that it *must*. (In fact, the default bound on type parameters if
you don't write an `extends` clause is the nullable bound `Object?`.) There is
no way to *require* a nullable type argument. If you want uses of the type
parameter to reliably be nullable and be implicitly initialized to `null`, 
you can use `T?` inside the body of the class.

## Core library changes

There are a couple of other tweaks here and there in the language, but they are
minor. Things like the default type of a `catch` with no `on` clause is now
`Object` instead of `dynamic`. Fallthrough analysis in switch statements uses
the new flow analysis.

The remaining changes that really matter to you are in the core libraries.
Before we embarked on the Grand Null Safety Adventure, we worried that it would
turn out there was no way to make our core libraries null safe without massively
breaking the world. It turned out not so dire. There *are* a few significant
changes, but for the most part, the migration went smoothly. Most core libraries
either did not accept `null` and naturally move to non-nullable types, or do and
gracefully accept it with a nullable type.

There are a few important corners, though:

### The Map index operator is nullable

This isn't really a change, but more a thing to know. The index `[]` operator on
the Map class returns `null` if the key isn't present. This implies that the
return type of that operator must be nullable: `V?` instead of `V`.

We could have changed that method to throw an exception when the key isn't
present and then given it an easier-to-use non-nullable return type. But code
that uses the index operator and checks for `null` to see if the key is absent
is very common, around half of all uses based on our analysis. Breaking all of
that code would have set the Dart ecosystem aflame.

Instead, the runtime behavior is the same and thus the return type is obliged
to be nullable. This means you generally cannot immediately use the result of
a map lookup:

```dart
// Using null safety, incorrectly:
var map = {'key': 'value'};
print(map['key'].length); // Error.
```

This gives you a compile error on the attempt to call `.length` on a nullable
string. In cases where you *know* the key is present you can teach the type
checker by using `!`:

```dart
// Using null safety:
var map = {'key': 'value'};
print(map['key']!.length); // OK.
```

We considered adding another method to Map that would do this for you: look up
the key, throw if not found, or return a non-nullable value otherwise. But what
to call it? No name would be shorter than the single-character `!`, and no
method name would be clearer than seeing a `!` with its built-in semantics right
there at the call site. So the idiomatic way to access a known-present element
in a map is to use `[]!`. You get used to it.

### No unnamed List constructor

The unnamed constructor on `List` creates a new list with the given size but
does not initialize any of the elements. This would poke a very large hole in
the soundness guarantees if you created a list of a non-nullable type and then
accessed an element.

To avoid that, we have removed the constructor entirely. It is an error to call
`List()` in null safe code, even with a nullable type. That sounds scary, but
in practice most code creates lists using list literals, `List.filled()`,
`List.generate()`, or as a result of transforming some other collection. For
the edge case where you want to create an empty list of some type, we added a
new `List.empty()` constructor.

The pattern of creating a completely uninitialized list has always felt out of
place in Dart, and now it is even more so. If you have code broken by this,
you can always fix it by using one of the many other ways to produce a list.

### Cannot set a larger length on non-nullable lists

This is little known, but the `length` getter on `List` also has a corresponding
*setter*. You can set the length to a shorter value to truncate the list. And
you can also set it to a *longer* length to pad the list with uninitialized
elements.

If you were to do that with a list of a non-nullable type, you'd violate
soundness when you later accessed those unwritten elements. To prevent that, the
`length` setter will throw a runtime exception if (and only if) the list has a
non-nullable element type *and* you set it to a *longer* length. It is still
fine to truncate lists of all types, and you can grow lists of nullable types.

There is an important consequence of this if you define your own list types that
extend `ListBase` or apply `ListMixin`. Both of those types provide an
implementation of `insert()` that previously made room for the inserted element
by setting the length. That would fail with null safety, so instead we changed
the implementation of `insert()` in `ListMixin` (which `ListBase` shares) to
call `add()` instead. Your custom list class should provide a definition of
`add()` if you want to be able to use that inherited `insert()` method.

### Cannot access Iterator.current before or after iteration

The `Iterator` class is the mutable "cursor" class used to traverse the elements
of a type that implements `Iterable`. You are expected to call `moveNext()`
before accessing any elements to advance to the first element. When that method
returns `false`, you have reached the end and there are no more elements.

It used to be that `current` returned `null` if you called it either before
calling `moveNext()` the first time or after iteration finished. With null
safety, that would require the return type of `current` to be `E?` and not `E`.
That in turn means every element access would require a runtime `null` check.

Those checks would be useless given that almost no one ever accesses the current
element in that erroneous way. Instead, we have made the type of `current` be
`E`. Since there *may* be a value of that type available before or after
iterating, we've left the iterator's behavior undefined if you call it when you
aren't supposed to. Most implementations of `Iterator` throw a `StateError`.

## Summary

That is a very detailed tour through all of the language and library changes
around null safety. It's a lot of stuff, but this is a pretty big language
change. More importantly, we wanted to get to a point where Dart still feels
cohesive and usable. That requires changing not just the type system, but a
number of other usability features around it. We didn't want it to feel like
null safety was bolted on.

The core points to take away are:

*   Types are non-nullable by default and made nullable by adding `?`.

*   Optional parameters must be nullable or have a default value. You can use
    `required` to make named parameters non-optional. Non-nullable top-level
    variables and static fields must have initializers. Non-nullable instance
    fields must be initialized before the constructor body begins.

*   Method chains after null-aware operators short circuit if the receiver is
    `null`. There are new null-aware cascade (`?..`) and index (`?[]`)
    operators. The postfix null assertion "bang" operator (`!`) casts its
    nullable operand to the underlying non-nullable type.

*   Flow analysis lets you safely turn nullable local variables and parameters
    into usable non-nullable ones. The new flow analysis also has smarter rules
    for type promotion, missing returns, unreachable code, and variable
    initialization.

*   The `late` modifier lets you use non-nullable types and `final` in places
    you otherwise might not be able to, at the expense of runtime checking. It
    also gives you lazy-initialized fields.

*   The `List` class is changed to prevent uninitialized elements.

Finally, once you absorb all of that and get your code into the world of null
safety, you get a sound program that the compilers can optimize and where every
place a runtime error can occur is visible in your code. We hope you feel that's
worth the effort to get there.
