---
layout: guide
title: "Sound Dart: Common Problems"
description: "."
---

## Troubleshooting

### Am I really in strong mode?

If you're not seeing strong mode errors or warnings,
make sure that you are in strong mode.
A good test is to add the following code to a file:

{% prettify dart %}
void test() {
  var fruits = ["apple"];
  var fruit = fruits[0];
  int apple = fruit;
}
{% endprettify %}

If you are in strong mode, you'll see the following warning from the analyzer:

{% prettify none %}
[warning] A value of type 'String' can't be assigned to a variable of type 'int'.
{% endprettify %}

### I'm not in strong mode and I think I should be

Strong mode is enforced by Dart Analyzer.
The answer slightly varies depending on whether you are running `dartanalyzer`
from the command line, or via one of the JetBrains IDEs.

#### Command line analyzer

If you are running `dartanalyzer --strong` and you don't see expected
strong mode errors, be sure that you didn't disable strong mode in an
analysis options file in the same directory where you run the analyzer.
If you do, the analysis options file overrides your command line flag.

For more information on how to set up an analysis options file, see
[Customize Static Analysis](/guides/language/analysis-options).

#### JetBrains IDEs

Make sure that you have an analysis options file with
[strong mode turned on](/guides/language/analysis-options#specifying-strong-mode).
This file needs to be placed in a content root, or in a parent
directory of your content root. The steps for viewing a project's
content root varies a bit for WebStorm and IntelliJ.

Note that a large project may have multiple content roots.
The following instructions describe how to see a list of content roots in
WebStorm or IntelliJ.

WebStorm
: In the **Preferences** panel (**WebStorm > Preferences**), click
  **Directories** from the list on the left.
  The **+Add Content Root** button in the column on the far right appears
  above the content roots, shown in bold.

IntelliJ
: In the **Project Structure** panel (**File > Project Structure**),
  **Modules** is selected from the list on the left by default.
  The **+Add Content Root** button in the column on the far right appears
  above the content roots, shown in bold.

For more information on where to put your analysis options file, see
[the analysis options file](g/guides/language/analysis-options#the-analysis-options-file),
part of [Customize Static Analysis](/guides/language/analysis-options).

[Pending: Add this info directly to "Create Static Analysis."]

## Common errors and warnings

How to fix some of the errors and warnings you may see when you
enable strong mode.

### Undefined member

**Error:**
<code>&lt;<em>member</em>&gt; isn't defined for the class &lt;<em>class</em>&gt;</code>

These errors usually appear in code where a variable is statically known
to be some supertype but the code assumes a subtype.

**Fix:** Replace the definition of the member with an explicit type
declaration or a downcast.

For example, the analyzer complains that `context2D` in the following
code is undefined:

<div class="fails-sa" markdown="1">
{% prettify dart %}
var canvas = querySelector("canvas");
canvas.[[highlight]]context2D[[/highlight]]; // <-- Error.
{% endprettify %}
</div>

The `querySelector()` method statically returns an Element,
but the code assumes it returns the subtype CanvasElement
where `context2D` is defined.
The `canvas` field is declared as `var` which, in classic Dart,
types it as `dynamic` and silences all errors.
Strong mode Dart infers `canvas` to be an Element.

Fix this error with an explicit type declaration:

<div class="passes-sa" markdown="1">
{% prettify dart %}
[[highlight]]CanvasElement[[/highlight]] canvas = querySelector("canvas");
canvas.context2D;
{% endprettify %}
</div>

If you actually want a dynamic type, specify `dynamic`:

<div class="passes-sa" markdown="1">
{% prettify dart %}
[[highlight]]dynamic[[/highlight]] canvas = querySelector("canvas");
canvas.context2D;
{% endprettify %}
</div>

<hr>

### Invalid method override

**Error:** <code>Invalid override. The type of &lt;<em>type</em>&gt; is not a subtype of &lt;<em>type</em>&gt;.</code>

These errors typically occur when a subclass tightens up a method's
parameter types by specifying a subclass.

<aside class="alert alert-info" markdown="1">
**Note:** This warning can also occur when a generic subclass neglects
to specify a type. For more information, see
[Missing type arguments](#missing-type-arguments).
</aside>

**Fix:** Widen the types in the method's parameter list.
The subclass's method should accept every
object that the superclass's method takes.

In the following example, the parameters in the `add()` method
are changed from `num` to `int`, a subtype of `num`.
This code passes static analysis in classic Dart,
but is unsafe and fails analysis in strong mode Dart.

<div class="fails-sa" markdown="1">
{% prettify dart %}
abstract class NumberAdder {
  num add(num a, num b);
}

class IntAdder extends NumberAdder {
  int add(int a, int b) => a + b;
}
{% endprettify %}
</div>

Consider the following scenario where floating
point values are passed to an IntAdder:

{% prettify dart %}
NumberAdder adder = new IntAdder(); // Upcast
adder.add(1.2, 3.4);                // Kaboom!
{% endprettify %}

Fix this error by widening the types in the subclass:

{% prettify dart %}
abstract class NumberAdder {
  num add(num a, num b);
}

class IntAdder extends NumberAdder {
  num add(num a, num b) => a + b;
}
{% endprettify %}

For more information, see [Use proper input parameter types when overriding methods](/guides/language/sound-dart#use-proper-input-parameter-types-when-overriding-methods-).

<aside class="alert alert-info" markdown="1">
**Note:**
Some coding patterns require this functionality.
If you have a valid reason to do this,
use the `@checked` annotation. For example:

{% prettify dart %}
[[highlight]]import 'package:meta/meta.dart';[[/highlight]]

abstract class NumberAdder {
  num add([[highlight]]@checked[[/highlight]] num a, [[highlight]]@checked[[/highlight]] num b);
}
{% endprettify %}

Learn more about the
[@checked annotation](/guides/language/sound-dart##checked-annotation).
</aside>

<hr>

### Unsound implicit downcast

**Warning:**
<code>Unsound implicit cast from <em>Class&lt;dynamic&gt;</em> to <em>Class&lt;type&gt;</em>.</code>

Implicit downcasts involving `dynamic` will most likely fail at runtime
in DDC, so the analyzer warns you.

**Fix:** Provide an explicit type or give the analyzer enough information
to properly infer the type.

<aside class="alert alert-info" markdown="1">
**Note:** This warning can also occur when a generic subclass neglects
to specify a type. For more information, see
[Missing type arguments](#missing-type-arguments).
</aside>

For example, the following code generates the warning
**Unsound implicit cast from List&lt;dynamic&gt; to List&lt;String&gt;</code>**.

<div class="fails-sa" markdown="1">
{% prettify dart %}
var stuff = []; // Runtime type is List<dynamic>.
stuff.add("Hi");
List<String> strings = stuff;
{% endprettify %}
</div>

The best way to fix this it to give the analyzer enough information to
correctly infer the list's type:

<div class="passes-sa" markdown="1">
{% prettify dart %}
var stuff = [[highlight]]['Hi'][[/highlight]]; // Runtime type is List<String>.
List<String> strings = stuff;
{% endprettify %}
</div>

You could also explicitly specify the list's type:

<div class="passes-sa" markdown="1">
{% prettify dart %}
var stuff = [[highlight]]<String>[[/highlight]][]; // Runtime type is List<String>.
stuff.add("Hi");
List<String> strings = stuff;
{% endprettify %}
</div>

As a last resort, you can also cast the type using <code>as
<em>Class</em></code>.

<div class="passes-sa" markdown="1">
{% prettify dart %}
var stuff = []; // Runtime type is List<dynamic>.
stuff.add("Hi");
List<String> strings = stuff [[highlight]]as List<String>[[/highlight]];
{% endprettify %}
</div>

This cast silences the static error by inserting a runtime cast
that may fail at runtime. (Currently, only DDC makes strong mode
runtime checks, but it's coming to other tools.)

In more complex situations where this warning appears, you may want
to use a generic method. You can either use existing methods, such
as `Iterable.map()`, or you can define your own.
For more information, see [Using generic methods](/guides/language/language-tour#using-generic-methods)
in the [language tour](/guides/language/language-tour).

<hr>

### Missing type arguments

Leaving off a type argument can cause one of two kinds of problems during
static analysis:

**Error:** <code>Invalid override. The type of &lt;<em>type</em>&gt; is not a subtype of &lt;<em>type</em>&gt;.</code>

OR

**Warning:** <code>Unsound implicit cast from <em>Class&lt;dynamic&gt;</em> to <em>Class&lt;type</em>&gt;</em>.</code>

**Fix:** Specify type arguments for the generic subclass.

When a generic subclass neglects to specify a type argument,
the analyzer infers the `dynamic` type. This is likely to cause
errors like invalid overrides or unsound downcasts.

In the following example, Subclass extends Superclass<T> but doesn't
specify a type argument.

<div class="fails-sa" markdown="1">
{% prettify dart %}
class Superclass<T> {
  void method(T t) {}
}

class Subclass extends Superclass {
  [[highlight]]void method(int i) {}[[/highlight]] // <-- Error.
}
{% endprettify %}
</div>

The analyzer infers Subclass&lt;dynamic&gt; which results in an
invalid override error on `method(int)`. You can fix this by
specifying the type on the subclass:

<div class="passes-sa" markdown="1">
{% prettify dart %}
class Superclass<T> {
  void method(T t) {}
}

class Subclass extends Superclass[[highlight]]<int>[[/highlight]] {
  void method(int i) {}
}
{% endprettify %}
</div>

<hr>

### Assigning mismatched types

**Warning:** <code>A value of type '&lt;<em>type</em>&gt;' cannot be
assigned to a variable of type '<em>type</em>'.</code>

This sometimes happens when you create a simple dynamic Map and the analyzer
Dart infers the type in a way you didn't expect.
When you later add values of a different type,
you get a warning.

**Fix:** Explicitly specify the types.

For example, the following code shows a map pre-loaded with several
Sting,integer pairs. The analyzer infers that map contains
`(String,int)` pairs. When you later add a (String,float) pair,
the analyzer complains.

<div class="fails-sa" markdown="1">
{% prettify dart %}
void main() {
  var map = {
    'a': 7,
    'b': 11,
    'c': 13
  }; // <= inferred to be Map<String, int>

  [[highlight]]map['d'] = 1.5;[[/highlight]]  // but 1.5 is not int!
}
</div>


<hr>

### Constructor initialization list super() call

**Error:**  <code>super call must be last in an initializer list
   (see https://goo.gl/EY6hDP): 'super(style)'.</code>

This error occurs when the `super()` call is not last in a constructor's
initialization list.

**Fix:** Put the `super()` call last.

DDC generates simpler code if it relies on the `super()` call appearing last.
The following example generates an error in strong mode Dart:

<div class="fails-sa" markdown="1">
{% prettify dart %}
HoneyBadger(Eats food, String name)
  : _name = name,
    [[highlight]]super[[/highlight]](food) { ... }
{% endprettify %}
</div>

Fix the error by moving the `super()` call:

<div class="passes-sa" markdown="1">
{% prettify dart %}
HoneyBadger(Eats food, String name)
  : [[highlight]]super[[/highlight]](food),
    _name = name { ... }
{% endprettify %}
</div>

For more information, see [DO place the super() call last in a
constructor initialization list](/guides/language/effective-dart/usage#do-place-the-super-call-last-in-a-constructor-initialization-list)
in [Effective Dart](/guides/language/effective-dart/).

<hr>

{% comment %}
### Invalid field override

Strong mode currently disallows overriding a field with another field or with a getter/setter. Generally speaking making the superclass field into a getter/setter pair is a simple solution.  Note that we do allow an interface which declares a field to be implemented with a field, or with a getter/setter. Overriding a field with another field or with a getter/setter pair generally leaves the old field around using up memory in the object. It’s technically still possible to access the field, but most code simply leaves it around unused.

We will eventually support field overrides in strong mode, but DDC does not support them yet.  For the time being, you can use the @virtual annotation from package:meta to make a field virtual (allowing it to be overridden), but the resulting code will not yet work in DDC.
{% endcomment %}

## Known issues

## Help

## Appendices
