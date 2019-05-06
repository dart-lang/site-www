---
title: Fixing common type problems
description: Common type issues you may have and how to fix them.
---
{% comment %}Don't show exact file names in analyzer error output.{% endcomment %}
<?code-excerpt replace="/ at (lib|test)\/\w+\.dart:\d+:\d+//g"?>
<?code-excerpt plaster="none"?>

If you're having problems with type checks,
this page can help. To learn more, read about
[Dart's type system](/guides/language/sound-dart),
and see [these other resources](/guides/language/sound-dart#other-resources).

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
### Am I really using type-safe Dart?

If you're not seeing expected errors or warnings,
make sure that you're using the latest version of Dart.

Alternatively, try adding the following code to a file:

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (is-strong-mode-enabled)"?>
{% prettify dart %}
bool b = [0][0];
{% endprettify %}

With type-safe Dart, the analyzer produces the following error:

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/'int' can't be .* 'bool'.*common_problems/"?>
```nocode
error • A value of type 'int' can't be assigned to a variable of type 'bool' • invalid_assignment
```


<a name="common-errors"></a>
## Static errors and warnings

This section shows how to fix some of the errors and warnings
you might see from the analyzer or an IDE.

Static analysis can't catch all errors.
For help fixing errors that appear only at runtime,
see [Runtime errors](#common-errors-and-warnings).

### Undefined member

<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't defined for the class.*common_problems/" replace="/getter/<member\x3E/g; /'\w+'/'...'/g"?>
```nocode
error • The <member> '...' isn't defined for the class '...' • undefined_<member>
```

These errors can appear under the following conditions:

- A variable is statically known to be some supertype, but the code assumes a subtype.
- A generic class has a bounded type parameter, but an instance creation
  expression of the class omits the type argument.

#### Example 1: A variable is statically known to be some supertype, but the code assumes a subtype

In the following code, the analyzer complains that `context2D` is undefined:

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (canvas-error)" replace="/context2D/[!$&!]/g"?>
{% prettify dart %}
var canvas = querySelector('canvas');
canvas.[!context2D!].lineTo(x, y);
{% endprettify %}

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/context2D.*isn't defined for the class/"?>
```nocode
error • The getter 'context2D' isn't defined for the class 'Element' • undefined_getter
```

#### Fix: Replace the definition of the member with an explicit type declaration or a downcast

The `querySelector()` method statically returns an Element,
but the code assumes it returns the subtype CanvasElement
where `context2D` is defined.
The `canvas` field is declared as `var` which,
in Dart 1.x versions without strong mode,
types it as `dynamic` and silences all errors.
Dart infers `canvas` to be an Element.

You can fix this error with an explicit type declaration:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (canvas-ok)" replace="/CanvasElement/[!$&!]/g"?>
{% prettify dart %}
[!CanvasElement!] canvas = querySelector('canvas');
canvas.context2D.lineTo(x, y);
{% endprettify %}

The code above passes static analysis when [implicit casts][] are permitted.

You can also use an explicit downcast:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (canvas-as)" replace="/as \w+/[!$&!]/g"?>
{% prettify dart %}
var canvas = querySelector('canvas') [!as CanvasElement!];
canvas.context2D.lineTo(x, y);
{% endprettify %}

Otherwise, use `dynamic` in situations where you cannot use a single type:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (canvas-dynamic)" replace="/dynamic/[!$&!]/g"?>
{% prettify dart %}
[!dynamic!] canvasOrImg = querySelector('canvas, img');
var width = canvasOrImg.width;
{% endprettify %}

#### Example 2: Omitted type parameters default to their type bounds

Consider the following **generic class** with a **bounded type parameter** that extends
`Iterable`:

<?code-excerpt "strong/lib/bounded/my_collection.dart"?>
{% prettify dart %}
class C<T extends Iterable> {
  final T collection;
  C(this.collection);
}
{% endprettify %}

The following code creates a new instance of this class (omitting the type
argument) and accesses its `collection` member:

{:.fails-sa}
<?code-excerpt "strong/lib/bounded/instantiate_to_bound.dart (undefined_method)" replace="/c\..*;/[!$&!]/g"?>
{% prettify dart %}
var c = C(Iterable.empty()).collection;
[!c.add(2);!]
{% endprettify %}

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/add.*isn't defined for the class/"?>
```nocode
error • The method 'add' isn't defined for the class 'Iterable' at lib/bounded/instantiate_to_bound.dart:7:5 • undefined_method
```

While the [List][] type has an `add()` method, [Iterable][] does not.

#### Fix: Specify type arguments or fix downstream errors

In Dart 1.x, when a generic class is instantiated without explicit type
arguments, `dynamic` is assumed. That is why, in the code excerpt above, `c` is
of type `dynamic` and no error is reported for `c.add()`.

In Dart 2, when a generic class is instantiated without explicit type arguments,
each type parameter defaults to its type bound (`Iterable` in this example) if
one is explicitly given, or `dynamic` otherwise.

You need to approach fixing such errors on a case-by-case basis. It helps to
have a good understanding of the original design intent.

Explicitly passing type arguments is an effective way to help identify type
errors. For example, if you change the code to specify `List` as a type
argument, the analyzer can detect the type mismatch in the constructor argument.
Fix the error by providing a constructor argument of the appropriate type:

{:.passes-sa}
<?code-excerpt "strong/test/strong_test.dart (add-type-arg)" replace="/.List.|\[\]/[!$&!]/g"?>
{% prettify dart %}
var c = C[!<List>!]([![]!]).collection;
c.add(2);
{% endprettify %}

{% comment %}
TODO: remove this commentted out code once Kathy gives a thumbs up. Also remove the code excerpt from the original source.

If you actually meant `collection` to be an `Iterable`, then subsequent uses of
`c` are an error and need to be fixed:

{:.passes-sa}
<?code-excerpt "strong/test/strong_test.dart (use-iterable)" replace="/Use.*\.\.\./[!$&!]/g"?>
{% prettify dart %}
var c = C(Iterable.empty()).collection;
// [!Use c as an iterable...!]
{% endprettify %}
{% endcomment %}

<hr>

### Invalid method override

<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't a valid override of.*num.*common_problems/" replace="/'[\w\.]+'/'...'/g; /\('.*?'\)//g"?>
```nocode
error • '...'  isn't a valid override of '...'  • invalid_override
```

These errors typically occur when a subclass tightens up a method's
parameter types by specifying a subclass of the original class.

<aside class="alert alert-info" markdown="1">
**Note:** This issue can also occur when a generic subclass neglects
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
<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't a valid override of.*num.*common_problems/"?>
```nocode
error • 'MyAdder.add' ('(int, int) → int') isn't a valid override of 'NumberAdder.add' ('(num, num) → num') • invalid_override
```

Consider the following scenario where floating
point values are passed to an MyAdder:

{:.runtime-fail}
<?code-excerpt "strong/lib/common_problems_analysis.dart (unsafe-method-call)" replace="/\d[\d\.]+/[!$&!]/g"?>
{% prettify dart %}
NumberAdder adder = MyAdder();
adder.add([!1.2!], [!3.4!]);
{% endprettify %}

If the override were allowed, the code would raise an error at runtime.

#### Fix: Widen the method's parameter types

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

<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't a valid override of.*dynamic.*common_problems/" replace="/'\S+'/'...'/g; /\('.*?'\)//g"?>
```nocode
error • '...'  isn't a valid override of '...'  • invalid_override
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
<?code-excerpt "strong/analyzer-2-results.txt" retain="/isn't a valid override of.*dynamic.*common_problems/"?>
```nocode
error • 'Subclass.method' ('(int) → void') isn't a valid override of 'Superclass.method' ('(dynamic) → void') • invalid_override
```

#### Fix: Specify type arguments for the generic subclass

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

<a id ="assigning-mismatched-types"></a>
### Unexpected collection element type

<?code-excerpt "strong/analyzer-2-results.txt" retain="/'double' can't be assigned to a variable of type 'int'.*common_problems/" replace="/'\S+'/'...'/g"?>
```nocode
error • A value of type '...' can't be assigned to a variable of type '...' • invalid_assignment
```

This sometimes happens when you create a simple dynamic collection
and the analyzer infers the type in a way you didn't expect.
When you later add values of a different type, the analyzer reports an issue.

#### Example

The following code initializes a map with several
(String, int) pairs. The analyzer infers that map to be of type
`<String, int>` but the code seems to assume either `<String, dynamic>` or `<String, num>`.
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

#### Fix: Specify the type explicitly

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

#### Fix: Put the `super()` call last

The compiler can generate simpler code if it relies on the `super()` call appearing last.

Fix this error by moving the `super()` call:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (super-goes-last)" replace="/super/[!$&!]/g"?>
{% prettify dart %}
HoneyBadger(Eats food, String name)
    : _name = name,
      [!super!](food) { ... }
{% endprettify %}

<hr>

<a name="uses-dynamic-as-bottom"></a>
### A function of type ... can't be assigned

<?code-excerpt "strong/analyzer-2-results.txt" retain="/The function expression type.*common_problems/" replace="/'\S+ → \S+'/'...'/g"?>
```nocode
error • The function expression type '...' isn't of type '...'. This means its parameter or return type does not match what is expected. Consider changing parameter type(s) or the returned type(s) • strong_mode_invalid_cast_function_expr
```

In Dart 1.x `dynamic` was both a [top type][] (supertype of all types) and a
[bottom type][]  (subtype of all types)
depending on the context. This meant it was valid to assign, for example,
a function with a parameter of type `String` to a place that expected a
function type with a parameter of `dynamic`.

However, in Dart 2 passing something other than `dynamic` (or another _top_
type, such as `Object`, or a specific bottom type, such as `Null`) results
in a compile-time error.

#### Example

{:.fails-sa}
<?code-excerpt "strong/lib/common_problems_analysis.dart (func-dynamic)" replace="/String/[!$&!]/g"?>
{% prettify dart %}
typedef Filter = bool Function(dynamic any);
Filter filter = ([!String!] x) => x.contains('Hello');
{% endprettify %}

{:.console-output}
<?code-excerpt "strong/analyzer-2-results.txt" retain="/type '\(String\) → bool'.*common_problems/"?>
```nocode
error • A value of type '(String) → bool' can't be assigned to a variable of type '(dynamic) → bool' • invalid_assignment
error • The function expression type '(String) → bool' isn't of type '(dynamic) → bool'. This means its parameter or return type does not match what is expected. Consider changing parameter type(s) or the returned type(s) • strong_mode_invalid_cast_function_expr
```

#### Fix: Add type parameters _or_ cast from dynamic explicitly

When possible, avoid this error by adding type parameters:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (func-T)" replace="/<\w+\x3E/[!$&!]/g"?>
{% prettify dart %}
typedef Filter[!<T>!] = bool Function(T any);
Filter[!<String>!] filter = (String x) => x.contains('Hello');
{% endprettify %}

Otherwise use casting:

{:.passes-sa}
<?code-excerpt "strong/lib/common_fixes_analysis.dart (func-cast)" replace="/([Ff]ilter)1/$1/g; /as \w+/[!$&!]/g"?>
{% prettify dart %}
typedef Filter = bool Function(dynamic any);
Filter filter = (x) => (x [!as String!]).contains('Hello');
{% endprettify %}

<hr>

<a id="common-errors-and-warnings"></a>
## Runtime errors

Unlike Dart 1.x, Dart 2 enforces a sound type system. Roughly, this means
you can't get into a situation where the value stored in a variable is
different than the variable's static type. Like most modern statically
typed languages, Dart accomplishes this with a combination of static
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
static analysis errors in [Unexpected collection element type](#unexpected-collection-element-type).

The errors discussed in the remainder of this section are reported at
[runtime](sound-dart#runtime-checks).

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

#### Fix: Tighten or correct types

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
[cast()]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List/cast.html) method
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
by overriding a parameter's type with a subtype, which is invalid.
In this case, you can use the `covariant` keyword to
tell the analyzer that you are doing this intentionally.
This removes the static error and instead checks for an invalid
argument type at runtime.

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
[Iterable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html
[implicit casts]: /guides/language/analysis-options#enabling-additional-type-checks
[List]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html
[top type]: https://en.wikipedia.org/wiki/Top_type
