---
title: "Strong Mode Dart: Fixing Common Problems"
description: Common problems you may have when converting to strong mode and how to fix them.
toc: false
---

{% comment %}
The first few questions/answers are for strong mode under Dart 1.x.
update-for-dart-2
{% endcomment %}

If you're having problems converting your code to strong mode,
this page can help. Be sure to also check out
[Strong Mode Dart](/guides/language/sound-dart) for an overview of what "sound
Dart" means, and how strong mode contributes to making Dart a sound
language.

* TOC
{:toc}

For a complete list of sources about strong mode and sound Dart,
see [other resources](/guides/language/sound-dart#other-resources)
in [Strong Mode Dart](/guides/language/sound-dart).

## Troubleshooting

<a name="am-i-using-strong-mode"></a>
### Am I really using strong mode?

If you're not seeing strong mode errors or warnings,
make sure that you're using strong mode.
A good test is to add the following code to a file:

{:.fails-sa}
{% prettify dart %}
void test() {
  bool b = [0][0];
}
{% endprettify %}

If you're using strong mode, you'll see the following warning from the analyzer:

```nocode
[warning] A value of type 'int' can't be assigned to a variable of type 'bool'.
```

<hr>

<a name="not-using-strong-mode"></a>
### I'm not using strong mode and I think I should be

Strong mode is enforced by the Dart analyzer.
How you troubleshoot strong mode depends on whether you are running
`dartanalyzer` from the command line, or via one of the JetBrains IDEs.

#### Command line analyzer

If you are running dartanalyzer from the command line and you don't see
expected strong mode errors, try the following:

- If your project contains an [analysis
  options file,](/guides/language/analysis-options#the-analysis-options-file)
  make sure you've specified `strong mode: true` correctly.
  For more information, see [Specifying strong
  mode.](/guides/language/analysis-options#specifying-strong-mode)
- Run the analyzer with the `--strong` tag:
  ```nocode
  dartanalyzer --strong <file-or-directory>
  ```

For information on how to set up an analysis options file,
see [Customize Static Analysis](/guides/language/analysis-options).

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
[the analysis options file](/guides/language/analysis-options#the-analysis-options-file),
part of [Customize Static Analysis](/guides/language/analysis-options).

<a name="common-errors"></a>
## Common errors and warnings

How to fix some of the errors and warnings you may see from the analyzer
when enabling strong mode.

<a name="undefined-member"></a>
### Undefined member

**Error:** <code>&lt;<em>member</em>&gt; isn't defined for the class &lt;<em>class</em>&gt;</code>

These errors usually appear in code where a variable is statically known
to be some supertype but the code assumes a subtype.

**Fix:** Replace the definition of the member with an explicit type
declaration or a downcast.

For example, the analyzer complains that `context2D` in the following
code is undefined:

{:.fails-sa}
{% prettify dart %}
var canvas = querySelector("canvas");
canvas.[!context2D!]; // <-- Error.
{% endprettify %}

The `querySelector()` method statically returns an Element,
but the code assumes it returns the subtype CanvasElement
where `context2D` is defined.
The `canvas` field is declared as `var` which, in classic Dart,
types it as `dynamic` and silences all errors.
Strong mode Dart infers `canvas` to be an Element.

Fix this error with an explicit type declaration:

{:.passes-sa}
{% prettify dart %}
[!CanvasElement!] canvas = querySelector("canvas");
canvas.context2D;
{% endprettify %}

If you actually want a dynamic type, specify `dynamic`:

{:.passes-sa}
{% prettify dart %}
[!dynamic!] canvas = querySelector("canvas");
canvas.context2D;
{% endprettify %}

<hr>

<a name="invalid-method-override"></a>
### Invalid method override

**Error:** <code>Invalid override. The type of &lt;<em>type</em>&gt; is not a subtype of &lt;<em>type</em>&gt;.</code>

These errors typically occur when a subclass tightens up a method's
parameter types by specifying a subclass of the original class.

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

{:.fails-sa}
{% prettify dart %}
abstract class NumberAdder {
  num add(num a, num b);
}

class IntAdder extends NumberAdder {
  int add([!int!] a, [!int!] b) => a + b;
}
{% endprettify %}

Consider the following scenario where floating
point values are passed to an IntAdder:

{% prettify dart %}
NumberAdder adder = new IntAdder(); // Upcast
adder.add([!1.2!], [!3.4!]); // Kaboom!
{% endprettify %}

If the override were allowed, this code would crash at runtime.

Fix this error by widening the types in the subclass:

{:.passes-sa}
{% prettify dart %}
abstract class NumberAdder {
  num add(num a, num b);
}

class IntAdder extends NumberAdder {
  num add([!num!] a, [!num!] b) => a + b;
}
{% endprettify %}

For more information, see [Use proper input parameter types when overriding methods](/guides/language/sound-dart#use-proper-param-types).

<aside class="alert alert-info" markdown="1">
  **Note:** If you have a valid reason to use a subtype, you can use the
  [covariant keyword](#the-covariant-keyword).
</aside>


<hr>

<a name="missing-type-arguments"></a>
### Missing type arguments

**Error:** <code>Invalid override. The type of &lt;<em>type</em>&gt; is not a subtype of &lt;<em>type</em>&gt;.</code>

**Fix:** Specify type arguments for the generic subclass.

When a generic subclass neglects to specify a type argument,
the analyzer infers the `dynamic` type. This is likely to cause
errors.

In the following example, `Subclass` extends `Superclass<T>` but doesn't
specify a type argument. The analyzer infers `Subclass<dynamic>`,
which results in an invalid override error on `method(int)`.

{:.fails-sa}
{% prettify dart %}
class Superclass<T> {
  void method(T t) {}
}

class Subclass extends Superclass {
  [!void method(int i) {}!] // <-- Error.
}
{% endprettify %}

You can fix this by specifying the type on the subclass:

{:.passes-sa}
{% prettify dart %}
class Superclass<T> {
  void method(T t) {}
}

class Subclass extends Superclass[!<int>!] {
  void method(int i) {}
}
{% endprettify %}

<hr>

<a name="assigning-mismatched-types"></a>
### Assigning mismatched types

**Warning:** <code>A value of type '&lt;<em>type</em>&gt;' cannot be
assigned to a variable of type '<em>type</em>'.</code>

This sometimes happens when you create a simple dynamic collection
and the analyzer Dart infers the type in a way you didn't expect.
When you later add values of a different type,
the analyzer produces a warning.

**Fix:** Specify the type explicitly.

For example, the following code initializes a map with several
(String, integer) pairs. The analyzer infers that map to be of type
`<String, int>` but the code assumes `<String, dynamic>`.
When the code then adds a (String, float) pair, the analyzer complains.

{:.fails-sa}
{% prettify dart %}
void main() {
  var map = {
    'a': 7,
    'b': 11,
    'c': 13
  }; // <= inferred to be Map<String, int>

  [!map['d'] = 1.5;!]  // 1.5 is not int!
}
{% endprettify %}

This can be fixed by explicitly defining the map's type to be
`<String, dynamic>`.

{:.passes-sa}
{% prettify dart %}
void main() {
  var map = [!<String, dynamic>!]{
    'a': 7,
    'b': 11,
    'c': 13
  };

  map['d'] = 1.5;
}
{% endprettify %}

Alternatively, if you only want this map to accept integers and floats,
you can specify the type as `<String, num>`.

<hr>

<a name="constructor-initialization-list"></a>
### Constructor initialization list super() call

**Error:**  <code>super call must be last in an initializer list
   (see https://goo.gl/EY6hDP): 'super(style)'.</code>

This error occurs when the `super()` call is not last in a constructor's
initialization list.

**Fix:** Put the `super()` call last.

The Dart dev compiler generates simpler code if
it relies on the `super()` call appearing last.
The following example generates an error in strong mode Dart:

{:.fails-sa}
{% prettify dart %}
HoneyBadger(Eats food, String name)
  : [!super!](food),
    _name = name { ... }
{% endprettify %}

Fix the error by moving the `super()` call:

{:.passes-sa}
{% prettify dart %}
HoneyBadger(Eats food, String name)
  : _name = name,
    [!super!](food) { ... }
{% endprettify %}

For more information, see [DO place the super() call last in a
constructor initialization list](/guides/language/effective-dart/usage#do-place-the-super-call-last-in-a-constructor-initialization-list)
in [Effective Dart](/guides/language/effective-dart/).

<hr>

{% comment %}
## Known issues
Do we have any known issues or bugs to list here?
{% endcomment %}

<a name="appendix"></a>
## Appendix

<a name="checked-annotation"></a>
### The covariant keyword

Some (rarely used) coding patterns rely on tightening a type
by overriding a parameter's type with a subtype, which is illegal in strong
mode Dart. In this case, you can use the `covariant` keyword to
tell the analyzer that you are doing this intentionally.
This removes the static error and instead checks for an invalid
parameter type at runtime.

<aside class="alert alert-info" markdown="1">
  **Version note:**
  The `covariant` keyword was introduced in 1.22.
  It replaces the `@checked` annotation.
</aside>

The following shows how you might use `covariant`:

{% prettify dart %}
[!import 'package:meta/meta.dart';!]

class Animal {
  void chase(Animal x) {}
}

class Mouse extends Animal {}

class Cat extends Animal {
  void chase([!covariant!] Mouse x) {}
}
{% endprettify %}

Although this example shows using `covariant` in the subtype,
the `covariant` keyword can be placed in either the superclass
or the subclass method.
Usually the superclass method is the best place to put it.
The `covariant` keyword applies to a single parameter and is
also supported on setters and fields.
