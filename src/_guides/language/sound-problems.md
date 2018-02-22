---
title: "Strong Mode Dart: Fixing Common Problems"
description: Common problems you may have when converting to strong mode and how to fix them.
---
{% comment %}Don't show exact file names in analyzer error output.{% endcomment %}
<?code-excerpt replace="/ at (lib|test)\/\w+\.dart:\d+:\d+//g"?>

{% comment %}
The first few questions/answers are for strong mode under Dart 1.x.
update-for-dart-2
{% endcomment %}

If you're having problems converting your code to strong mode,
this page can help. Be sure to also check out
[Strong Mode Dart](/guides/language/sound-dart) for an overview of what "sound
Dart" means, and how strong mode contributes to making Dart a sound
language.

For a complete list of sources about strong mode and sound Dart,
see [other resources](/guides/language/sound-dart#other-resources)
in [Strong Mode Dart](/guides/language/sound-dart).

<aside class="alert alert-info" markdown="1">
**Help us improve this page!**
If you encounter a warning or error that isn't listed here,
please file an issue by clicking the **bug icon** at the top right.
Include the **warning or error message** and,
if possible, the code for both a small reproducible case
and its correct equivalent.
</aside>


## Troubleshooting

<a name="am-i-using-strong-mode"></a>
### Am I really using strong mode?

If you're not seeing strong mode errors or warnings,
make sure that you're using strong mode.
A good test is to add the following code to a file:

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (is-strong-mode-enabled)"?>
{% prettify dart %}
bool b = [0][0];
{% endprettify %}

If you're using strong mode, you'll see the following issue from the analyzer:

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/'int' can't be .* 'bool'.*common_problems/"?>
```nocode
error • A value of type 'int' can't be assigned to a variable of type 'bool' • invalid_assignment
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
- Run the analyzer with the `--strong` option:
{% comment %}Eventually link [`--strong` option] to [dartanalyzer README]{% endcomment %}

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
## Static errors and warnings

This section shows how to fix some of the errors and warnings
you might see from the analyzer or an IDE with strong mode enabled.

Static analysis can't catch all errors.
For help fixing strong-mode errors that appear only at runtime,
see [Runtime errors](#common-errors-and-warnings).

### Undefined member

<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't defined for the class.*common_problems/" replace="/getter/<member\x3E/g; /'\w+'/'...'/g"?>
```nocode
error • The <member> '...' isn't defined for the class '...' • undefined_<member>
```

These errors usually appear in code where a variable is statically known
to be some supertype but the code assumes a subtype.

#### Example

In the following code, the analyzer complains that `context2D` is undefined:

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (canvas-error)" replace="/context2D/[!$&!]/g"?>
{% prettify dart %}
var canvas = querySelector("canvas");
canvas.[!context2D!];
{% endprettify %}

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't defined for the class/"?>
```nocode
error • The getter 'context2D' isn't defined for the class 'Element' • undefined_getter
```

#### **Fix**: Replace the definition of the member with an explicit type declaration or a downcast

The `querySelector()` method statically returns an Element,
but the code assumes it returns the subtype CanvasElement
where `context2D` is defined.
The `canvas` field is declared as `var` which, in classic Dart,
types it as `dynamic` and silences all errors.
Strong mode Dart infers `canvas` to be an Element.

You can fix this error with an explicit type declaration:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (canvas-ok)" replace="/CanvasElement/[!$&!]/g"?>
{% prettify dart %}
[!CanvasElement!] canvas = querySelector("canvas");
canvas.context2D;
{% endprettify %}

The code above passes static analysis when [implicit casts][] are permitted.

You can also use an explicit downcast:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (canvas-as)" replace="/as \w+/[!$&!]/g"?>
{% prettify dart %}
var canvas = querySelector("canvas") [!as CanvasElement!];
canvas.context2D;
{% endprettify %}

{% comment %}
NOTE TO Kathy: I don't think that we should recommend use of dynamic in this case,
so I'm commenting this out. WDYT?

- If you actually want a dynamic type, specify `dynamic`:

  {:.passes-sa}
  <?code-excerpt "strong/lib/common_fixes_analysis.dart (canvas-dynamic)" replace="/dynamic/[!$&!]/g"?>
  {% prettify dart %}
  [!dynamic!] canvas = querySelector("canvas");
  canvas.context2D;
  {% endprettify %}
{% endcomment %}

<hr>

### Invalid method override

<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't a subtype of.*num.*common_problems/" replace="/'[\w\.]+'/'...'/g; /\('.*?'\)//g"?>
```nocode
error • Invalid override. The type of '...'  isn't a subtype of '...'  • strong_mode_invalid_method_override
```

These errors typically occur when a subclass tightens up a method's
parameter types by specifying a subclass of the original class.

<aside class="alert alert-info" markdown="1">
**Note:** This warning can also occur when a generic subclass neglects
to specify a type. For more information, see
[Missing type arguments](#missing-type-arguments).
</aside>

#### Example

In the following example, the parameters to the `add()` method are of type `int`,
a subtype of `num`, which is the parameter type used in the parent class.

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (invalid-method-override)" replace="/int(?= \w\b)/[!$&!]/g"?>
{% prettify dart %}
abstract class NumberAdder {
  num add(num a, num b);
}

class MyAdder extends NumberAdder {
  int add([!int!] a, [!int!] b) => a + b;
}
{% endprettify %}

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't a subtype of.*num.*common_problems/"?>
```nocode
error • Invalid override. The type of 'MyAdder.add' ('(int, int) → int') isn't a subtype of 'NumberAdder.add' ('(num, num) → num') • strong_mode_invalid_method_override
```

Consider the following scenario where floating
point values are passed to an MyAdder:

{:.runtime-fail}
<?code-excerpt "strong/lib/common_problems_analysis.dart (unsafe-method-call)" replace="/\d[\d\.]+/[!$&!]/g"?>
{% prettify dart %}
NumberAdder adder = new MyAdder();
adder.add([!1.2!], [!3.4!]);
{% endprettify %}

If the override were allowed, the code would raise an error at runtime.

#### **Fix:** Widen the method's parameter types

The subclass's method should accept every
object that the superclass's method takes.

Fix the example by widening the types in the subclass:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (valid-method-override)" replace="/num(?= \w\b.*=)/[!$&!]/g"?>
{% prettify dart %}
abstract class NumberAdder {
  num add(num a, num b);
}

class MyAdder extends NumberAdder {
  num add([!num!] a, [!num!] b) => a + b;
}
{% endprettify %}

For more information, see [Use proper input parameter types when overriding methods](/guides/language/sound-dart#use-proper-param-types).

<aside class="alert alert-info" markdown="1">
  **Note:** If you have a valid reason to use a subtype, you can use the
  [covariant keyword](#the-covariant-keyword).
</aside>

<hr>

### Missing type arguments

<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't a subtype of.*dynamic.*common_problems/" replace="/'\S+'/'...'/g; /\('.*?'\)//g"?>
```nocode
error • Invalid override. The type of '...'  isn't a subtype of '...'  • strong_mode_invalid_method_override
```

#### Example

In the following example, `Subclass` extends `Superclass<T>` but doesn't
specify a type argument. The analyzer infers `Subclass<dynamic>`,
which results in an invalid override error on `method(int)`.

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (missing-type-arguments)" replace="/int(?= \w\b)/[!$&!]/g"?>
{% prettify dart %}
class Superclass<T> {
  void method(T t) { ... }
}

class Subclass extends Superclass {
  void method([!int!] i) { ... }
}
{% endprettify %}

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't a subtype of.*dynamic.*common_problems/"?>
```nocode
error • Invalid override. The type of 'Subclass.method' ('(int) → void') isn't a subtype of 'Superclass<dynamic>.method' ('(dynamic) → void') • strong_mode_invalid_method_override
```

#### **Fix:** Specify type arguments for the generic subclass

When a generic subclass neglects to specify a type argument,
the analyzer infers the `dynamic` type. This is likely to cause
errors.

You can fix the example by specifying the type on the subclass:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (type-arguments)" replace="/<int\x3E/[!$&!]/g"?>
{% prettify dart %}
class Superclass<T> {
  void method(T t) { ... }
}

class Subclass extends Superclass[!<int>!] {
  void method(int i) { ... }
}
{% endprettify %}

<hr>

{% comment %}
NOTE TO Kathy: I think that we should consider renaming this section. How about
<a id ="assigning-mismatched-types"></a>
### Unexpected collection element type

If we do make this change, then an anchor below will need to be updated too.
{% endcomment %}
### Assigning mismatched types

<?code-excerpt "strong/analyzer-2-results.txt" retain="/'double' can't be assigned to a variable of type 'int'.*common_problems/" replace="/'\S+'/'...'/g"?>
```nocode
error • A value of type '...' can't be assigned to a variable of type '...' • invalid_assignment
```

This sometimes happens when you create a simple dynamic collection
and the analyzer infers the type in a way you didn't expect.
When you later add values of a different type,
the analyzer produces a warning.

#### Example

The following code initializes a map with several
(String, int) pairs. The analyzer infers that map to be of type
`<String, int>` but the code assumes `<String, dynamic>`.
When the code adds a (String, float) pair, the analyzer complains:

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (inferred-collection-types)" replace="/1.5/[!$&!]/g"?>
{% prettify dart %}
// Inferred as Map<String, int>
var map = {'a': 1, 'b': 2, 'c': 3};
map['d'] = [!1.5!]; // a double is not an int
{% endprettify %}

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/'double' can't be assigned to a variable of type 'int'.*common_problems/"?>
```nocode
error • A value of type 'double' can't be assigned to a variable of type 'int' • invalid_assignment
```

#### **Fix:** Specify the type explicitly

The example can be fixed by explicitly defining the map's type to be
`<String, num>`.

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (inferred-collection-types)" replace="/<.*?\x3E/[!$&!]/g"?>
{% prettify dart %}
var map = [!<String, num>!]{'a': 1, 'b': 2, 'c': 3};
map['d'] = 1.5;
{% endprettify %}

Alternatively, if you want this map to accept any value, specify the type as `<String, dynamic>`.

<hr>

<a id="constructor-initialization-list"></a>
### Constructor initialization list super() call

<?code-excerpt "strong/analyzer-2-results.txt" retain="/super call must be last.*common_problems/" replace="/'\S+'/'...'/g"?>
```nocode
error • super call must be last in an initializer list (see https://goo.gl/EY6hDP): '...' • strong_mode_invalid_super_invocation
```

This error occurs when the `super()` call is not last in a constructor's
initialization list.

#### Example

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (super-goes-last)" replace="/super/[!$&!]/g"?>
{% prettify dart %}
HoneyBadger(Eats food, String name)
    : [!super!](food),
      _name = name { ... }
{% endprettify %}

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/super call must be last.*common_problems/"?>
```nocode
error • super call must be last in an initializer list (see https://goo.gl/EY6hDP): 'super(food)' • strong_mode_invalid_super_invocation
```

#### **Fix:** Put the `super()` call last

The compiler can generate simpler code if it relies on the `super()` call appearing last.

Fix this error by moving the `super()` call:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (super-goes-last)" replace="/super/[!$&!]/g"?>
{% prettify dart %}
HoneyBadger(Eats food, String name)
    : _name = name,
      [!super!](food) { ... }
{% endprettify %}

For more information, see [DO place the super() call last in a
constructor initialization list](/guides/language/effective-dart/usage#do-place-the-super-call-last-in-a-constructor-initialization-list)
in [Effective Dart](/guides/language/effective-dart/).

<hr>

<a name="uses-dynamic-as-bottom"></a>
### A function of type ... can't be assigned

<?code-excerpt "strong/analyzer-2-results.txt" retain="/A function of type.*common_problems/" replace="/'\S+ → \S+'/'...'/g"?>
```nocode
warning • A function of type '...' can't be assigned to a location of type '...' • strong_mode_uses_dynamic_as_bottom
```

In Dart 1.x `dynamic` was both a [top type][] (supertype of all types) and a
[bottom type][]  (subtype of all types)
depending on the context. This meant it was legal to assign, for example,
a function with a parameter of type `String` to a place that expected a
function type with a parameter of `dynamic`.

However, in Dart 2 passing something other than `dynamic` (or another _top_
type, such as `Object`, or a specific bottom type, such as `Null`) fails at
compile-time.

#### Example

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (func-dynamic)" replace="/String/[!$&!]/g"?>
{% prettify dart %}
typedef bool Filter(dynamic any);
Filter filter = ([!String!] x) => x.contains('Hello');
{% endprettify %}

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/A function of type.*common_problems/"?>
```nocode
warning • A function of type '(String) → bool' can't be assigned to a location of type '(dynamic) → bool' • strong_mode_uses_dynamic_as_bottom
```

#### **Fix:** Add generic type parameters _or_ cast from dynamic explicitly instead

When possible, fix this error by adding type parameters:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (func-T)" replace="/<\w+\x3E/[!$&!]/g"?>
{% prettify dart %}
typedef bool Filter[!<T>!](T any);
Filter[!<String>!] filter = (String x) => x.contains('Hello');
{% endprettify %}

If not possible, an alternative is casting:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (func-cast)" replace="/([Ff]ilter)1/$1/g; /as \w+/[!$&!]/g"?>
{% prettify dart %}
typedef bool Filter(dynamic any);
Filter filter = (x) => (x [!as String!]).contains('Hello');
{% endprettify %}

<hr>

<a id="common-errors-and-warnings"></a>
## Runtime errors

Unlike Dart 1.x, Dart 2 enforces a sound type system. Roughly, this means
you can't get into a situation where the value stored in a variable is
different than the variable's static type. Like most modern statically
typed langauges, Dart accomplishes this with a combination of static
(compile-time) and dynamic (runtime) checking.

For example, the following type error is detected at compile-time
(when the [implicit casts][] option is disabled):

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (int-not-string)" replace="/string[^;]*/[!$&!]/g"?>
{% prettify dart %}
List<int> numbers = [1, 2, 3];
List<String> [!string = numbers!];
{% endprettify %}

Since neither `List<int>` nor `List<String>` is a subtype of the other,
Dart rules this out statically. You can see other examples of these
static analysis errors in [Assigning Mismatched Types](#assigning-mismatched-types).

The strong-mode errors discussed in the remainder of this section are reported when
you use a [strong mode runtime](sound-dart#runtime-checks).

### Invalid casts

To ensure type safety, Dart needs to insert _runtime_ checks in some cases. Consider:

{:.passes-sa}
<?code-excerpt "strong/test/strong_test.dart (downcast-check)" replace="/string = objects/[!$&!]/g"?>
{% prettify dart %}
assumeStrings(List<Object> objects) {
  List<String> strings = objects; // Runtime downcast check
  String string = strings[0]; // Expect a String value
}
{% endprettify %}

The assignment to `strings` is _downcasting_ the `List<Object>` to `List<String>`
implicitly (as if you wrote `as List<String>`), so if the value you pass in
`objects` at runtime is a `List<String>`, then the cast succeeds.

Otherwise, the cast will fail at runtime:

{:.runtime-fail}
<?code-excerpt "strong/test/strong_test.dart (fail-downcast-check)" replace="/\[.*\]/[!$&!]/g"?>
{% prettify dart %}
assumeStrings(<int>[![1, 2, 3]!]);
{% endprettify %}

{:.console-output}
<?code-excerpt "strong/test/strong_test.dart (downcast-check-msg)" replace="/final msg = ./Exception: /g; /.;//g"?>
```nocode
Exception: type 'List<int>' is not a subtype of type 'List<String>'
```

<aside class="alert alert-warning" markdown="1">
  **Note for `dartdevc` users:**
  The `dartdevc` compiler in `2.0.0-dev` releases currently ignores _some_
  common type errors to make migrations easier. We expect to enforce all
  errors by the final release.
</aside>

{% comment %}
update-for-dart-2
TODO: Update that link once 2.0 is stable. Maybe create/use a macro for dev API docs.
{% endcomment %}

#### **Fix:** Tighten or correct types

Sometimes, lack of a type, especially with empty collections, means that a `<dynamic>`
collection is created, instead of the typed one you intended. Adding an explicit
type argument can help:

{:.runtime-success}
<?code-excerpt "strong/test/strong_test.dart (typed-list-lit)" replace="/<String\x3E/[!$&!]/g"?>
{% prettify dart %}
var list = [!<String>!][];
list.add('a string');
list.add('another');
assumeStrings(list);
{% endprettify %}

You can also more precisely type the local variable, and let inference help:

{:.runtime-success}
<?code-excerpt "strong/test/strong_test.dart (typed-list)" replace="/<String\x3E/[!$&!]/g"?>
{% prettify dart %}
List[!<String>!] list = [];
list.add('a string');
list.add('another');
assumeStrings(list);
{% endprettify %}

In cases where you are working with a collection that you don't create, such
as from JSON or an external data source, you can use the
[cast()]({{site.dart_api}}/dev/dart-core/List/cast.html) method
provided by `List` and other collection classes.

Here's an example of the preferred solution: tightening the object's type.

{:.runtime-success}
<?code-excerpt "strong/test/strong_test.dart (cast)" replace="/cast/[!$&!]/g"?>
{% prettify dart %}
Map<String, dynamic> json = getFromExternalSource();
var names = json['names'] as List;
assumeStrings(names.[!cast!]<String>());
{% endprettify %}

<aside class="alert alert-info" markdown="1">
  **Version note:**
  The `cast()` method was introduced in 2.0.0-dev.22.0.
</aside>

If you can't tighten the type or use `cast`, you can copy the object
in a different way. For example:

{:.runtime-success}
<?code-excerpt "strong/test/strong_test.dart (create-new-object)" replace="/\.map.*\.toList../[!$&!]/g"?>
{% prettify dart %}
Map<String, dynamic> json = getFromExternalSource();
var names = json['names'] as List;
// Use `as` and `toList` until 2.0.0-dev.22.0, when `cast` is available:
assumeStrings(names[!.map((name) => name as String).toList()!]);
{% endprettify %}

{% comment %}
## Known issues
Do we have any known issues or bugs to list here?
{% endcomment %}

## Appendix

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

{:.passes-sa}
<?code-excerpt "strong/lib/covariant.dart" replace="/covariant/[!$&!]/g"?>
{% prettify dart %}
class Animal {
  void chase(Animal x) { ... }
}

class Mouse extends Animal { ... }

class Cat extends Animal {
  void chase([!covariant!] Mouse x) { ... }
}
{% endprettify %}

Although this example shows using `covariant` in the subtype,
the `covariant` keyword can be placed in either the superclass
or the subclass method.
Usually the superclass method is the best place to put it.
The `covariant` keyword applies to a single parameter and is
also supported on setters and fields.

[bottom type]: https://en.wikipedia.org/wiki/Bottom_type
[dartanalyzer README]: https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer
[implicit casts]: sound-dart#call-dartanalyzer-with-strong-mode-enabled
[top type]: https://en.wikipedia.org/wiki/Top_type
