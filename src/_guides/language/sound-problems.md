---
title: Fixing common type problems
description: Common type issues you may have and how to fix them.
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; /. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>
<?code-excerpt plaster="none"?>
<?code-excerpt path-base="type_system"?>

If you're having problems with type checks,
this page can help. To learn more, read about
[Dart's type system](/language/type-system),
and see [these other resources](/language/type-system#other-resources).

{{site.alert.info}}
  **Help us improve this page!** If you encounter a warning or error that isn't
  listed here, please file an issue by clicking the **bug icon** at the top
  right. Include the **warning or error message** and, if possible, the code for
  both a small reproducible case and its correct equivalent.
{{site.alert.end}}

## Troubleshooting

Dart enforces a sound type system. 
This means you can't write code where a
variable's value differs from its static type.
A variable with an `int` type can't store a number with a decimal place.
Dart checks variable values against their types at
[compile-time](#static-errors-and-warnings) and [runtime](#runtime-errors).

You can't get into a situation where the value stored in a variable is
different from the variable's static type. Like most modern statically
typed languages, Dart accomplishes this with a combination of
[static (compile-time)](#static-errors-and-warnings) and [dynamic (runtime)](#runtime-errors) checking.

For example, the following type error is detected at compile-time:

{:.fails-sa}
{% prettify dart tag=pre+code %}
List<int> numbers = [1, 2, 3];
List<String> [!string = numbers!];
{% endprettify %}

Since neither `List<int>` nor `List<String>` is a subtype of the other,
Dart rules this out statically. 

You can see other examples of static analysis errors,
as well as other error types, in the following sections.


## No type errors {#no-type-errors}

If you're not seeing expected errors or warnings,
make sure that you're using the latest version of Dart
and you have properly configured your [IDE or editor](/tools#ides-and-editors).

You can also run analysis on your program using the command line
with the [`dart analyze`](/tools/dart-analyze) command.

To verify that analysis is working as expected,
try adding the following code to a Dart file.

{:.fails-sa}
<?code-excerpt "lib/strong_analysis.dart (static-analysis-enabled)"?>
{% prettify dart tag=pre+code %}
bool b = [0][0];
{% endprettify %}

If properly configured, the analyzer produces the following error:

{:.console-output}
<?code-excerpt "analyzer-results-stable.txt" retain="/'int' can't be .* 'bool'/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - A value of type 'int' can't be assigned to a variable of type 'bool'. Try changing the type of the variable, or casting the right-hand type to 'bool'. - invalid_assignment
```

<a name="common-errors"></a>
## Static errors and warnings

This section shows how to fix some of the errors and warnings
you might see from the analyzer or an IDE.

Static analysis can't catch all errors.
For help fixing errors that appear only at runtime,
see [Runtime errors](#common-errors-and-warnings).

### Undefined member

<?code-excerpt "analyzer-results-stable.txt" retain="/getter.*isn't defined for the type/" replace="/. Try.*.'context2D'. / /g; /getter/<member\x3E/g; /'\w+'/'...'/g; /-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - The <member> '...' isn't defined for the type '...' - undefined_<member>
```

These errors can appear under the following conditions:

- A variable is statically known to be some supertype, but the code assumes a subtype.
- A generic class has a bounded type parameter, but an instance creation
  expression of the class omits the type argument.

#### Example 1: A variable is statically known to be some supertype, but the code assumes a subtype

In the following code, the analyzer complains that `context2D` is undefined:

{:.fails-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (canvas-undefined)" replace="/context2D/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
var canvas = querySelector('canvas')!;
canvas.[!context2D!].lineTo(x, y);
{% endprettify %}

{:.console-output}
<?code-excerpt "analyzer-results-stable.txt" retain="/context2D.*isn't defined for the type/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - The getter 'context2D' isn't defined for the type 'Element'. Try importing the library that defines 'context2D', correcting the name to the name of an existing getter, or defining a getter or field named 'context2D'. - undefined_getter
```

#### Fix: Replace the definition of the member with an explicit type declaration or a downcast

The return type of `querySelector()` is `Element?`
(which the `!` converts to `Element`),
but the code assumes that it's the subtype `CanvasElement`
(which defines `context2D`).
The `canvas` field is declared as `var`,
which allows Dart to infer `canvas` to be an `Element`.

You can fix this error with an explicit downcast:

{:.passes-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (canvas-as)" replace="/as \w+/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
var canvas = querySelector('canvas') [!as CanvasElement!];
canvas.context2D.lineTo(x, y);
{% endprettify %}

Otherwise, use `dynamic` in situations where you cannot use a single type:

{:.passes-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (canvas-dynamic)" replace="/dynamic/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
[!dynamic!] canvasOrImg = querySelector('canvas, img');
var width = canvasOrImg.width;
{% endprettify %}

#### Example 2: Omitted type parameters default to their type bounds

Consider the following **generic class** with a **bounded type parameter**
that extends `Iterable`:

<?code-excerpt "lib/bounded/my_collection.dart"?>
{% prettify dart tag=pre+code %}
class C<T extends Iterable> {
  final T collection;
  C(this.collection);
}
{% endprettify %}

The following code creates a new instance of this class 
(omitting the type argument) and accesses its `collection` member:

{:.fails-sa}
<?code-excerpt "lib/bounded/instantiate_to_bound.dart (undefined_method)" replace="/c\.add\(2\)/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
var c = C(Iterable.empty()).collection;
[!c.add(2)!];
{% endprettify %}

{:.console-output}
<?code-excerpt "analyzer-results-stable.txt" retain="/add.*isn't defined for the type/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - The method 'add' isn't defined for the type 'Iterable'. Try correcting the name to the name of an existing method, or defining a method named 'add'. - undefined_method
```

While the [List][] type has an `add()` method, [Iterable][] does not.

#### Fix: Specify type arguments or fix downstream errors

When a generic class is instantiated without explicit type arguments,
each type parameter defaults to its type bound (`Iterable` in this example) if
one is explicitly given, or `dynamic` otherwise.

You need to approach fixing such errors on a case-by-case basis. It helps to
have a good understanding of the original design intent.

Explicitly passing type arguments is an effective way to help identify type
errors. For example, if you change the code to specify `List` as a type
argument, the analyzer can detect the type mismatch in the constructor argument.
Fix the error by providing a constructor argument of the appropriate type,
such as a list literal:

{:.passes-sa}
<?code-excerpt "test/strong_test.dart (add-type-arg)" replace="/.List.|\[\]/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
var c = C[!<List>!]([![]!]).collection;
c.add(2);
{% endprettify %}

<hr>

### Invalid method override

<?code-excerpt "analyzer-results-stable.txt" retain="/isn't a valid override of.*add/" replace="/'[\w\.]+'/'...'/g; /\('.*?'\)//g; /-(.*?):(.*?):(.*?)-/-/g; /' . -/' -/g"?>
```nocode
error - '...'  isn't a valid override of '...' - invalid_override
```

These errors typically occur when a subclass tightens up a method's
parameter types by specifying a subclass of the original class.

{{site.alert.note}}
  This issue can also occur when a generic subclass neglects to specify a type.
  For more information, see [Missing type arguments](#missing-type-arguments).
{{site.alert.end}}

#### Example

In the following example, the parameters to the `add()` method are of type `int`,
a subtype of `num`, which is the parameter type used in the parent class.

{:.fails-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (invalid-method-override)" replace="/int(?= \w\b.*=)/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
abstract class NumberAdder {
  num add(num a, num b);
}

class MyAdder extends NumberAdder {
  @override
  num add([!int!] a, [!int!] b) => a + b;
}
{% endprettify %}

{:.console-output}
<?code-excerpt "analyzer-results-stable.txt" retain="/isn't a valid override of.*add/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - 'MyAdder.add' ('num Function(int, int)') isn't a valid override of 'NumberAdder.add' ('num Function(num, num)'). - invalid_override
```

Consider the following scenario where floating
point values are passed to an `MyAdder`:

{:.runtime-fail}
<?code-excerpt "lib/common_fixes_analysis.dart (runtime-failure-if-int)" replace="/1.2/[!1.2!]/g/3.4/[!3.4!]/g"?>
{% prettify dart tag=pre+code %}
NumberAdder adder = MyAdder();
adder.add([!1.2!], [!3.4!]);
{% endprettify %}

If the override were allowed, the code would raise an error at runtime.

#### Fix: Widen the method's parameter types

The subclass's method should accept every
object that the superclass's method takes.

Fix the example by widening the types in the subclass:

{:.passes-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (invalid-method-override)" replace="/int(?= \w\b.*=)/[!num!]/g"?>
{% prettify dart tag=pre+code %}
abstract class NumberAdder {
  num add(num a, num b);
}

class MyAdder extends NumberAdder {
  @override
  num add([!num!] a, [!num!] b) => a + b;
}
{% endprettify %}

For more information, see 
[Use proper input parameter types when overriding methods](/language/type-system#use-proper-param-types).

{{site.alert.note}}
  If you have a valid reason to use a subtype, you can use the
  [covariant keyword](#the-covariant-keyword).
{{site.alert.end}}

<hr>

### Missing type arguments

<?code-excerpt "analyzer-results-stable.txt" retain="/isn't a valid override of.*method/" replace="/'\S+'/'...'/g; /\('.*?'\)//g; /-(.*?):(.*?):(.*?)-/-/g; /' . -/' -/g"?>
```nocode
error - '...'  isn't a valid override of '...' - invalid_override
```

#### Example

In the following example, `Subclass` extends `Superclass<T>` but doesn't
specify a type argument. The analyzer infers `Subclass<dynamic>`,
which results in an invalid override error on `method(int)`.

{:.fails-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (type-arguments)" replace="/int/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
class Superclass<T> {
  void method(T param) { ... }
}

class Subclass extends Superclass {
  @override
  void method([!int!] param) { ... }
}
{% endprettify %}

{:.console-output}
<?code-excerpt "analyzer-results-stable.txt" retain="/isn't a valid override of.*method/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - 'Subclass.method' ('void Function(int)') isn't a valid override of 'Superclass.method' ('void Function(dynamic)'). - invalid_override
```

#### Fix: Specify type arguments for the generic subclass

When a generic subclass neglects to specify a type argument,
the analyzer infers the `dynamic` type. This is likely to cause
errors.

You can fix the example by specifying the type on the subclass:

{:.passes-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (type-arguments)" replace="/Superclass /Superclass[!<int\x3E!] /g"?>
{% prettify dart tag=pre+code %}
class Superclass<T> {
  void method(T param) { ... }
}

class Subclass extends Superclass[!<int>!] {
  @override
  void method(int param) { ... }
}
{% endprettify %}

Consider using the analyzer in _strict raw types_ mode,
which ensures that your code specifies generic type arguments.
Here's an example of enabling strict raw types in
your project's `analysis_options.yaml` file:

```yaml
analyzer:
  language:
    strict-raw-types: true
```

To learn more about customizing the analyzer's behavior,
see [Customizing static analysis](/tools/analysis).

<hr>

<a id ="assigning-mismatched-types"></a>
### Unexpected collection element type

<?code-excerpt "analyzer-results-stable.txt" retain="/common_fixes_analysis.*'double' can't be assigned to a variable of type 'int'./" replace="/. Try.*'int'. / /g; /'\S+'/'...'/g; /-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - A value of type '...' can't be assigned to a variable of type '...' - invalid_assignment
```

This sometimes happens when you create a simple dynamic collection
and the analyzer infers the type in a way you didn't expect.
When you later add values of a different type, the analyzer reports an issue.

#### Example

The following code initializes a map with several
(`String`, `int`) pairs. The analyzer infers that map to be of type `<String, int>` 
but the code seems to assume either `<String, dynamic>` or `<String, num>`.
When the code adds a (`String`, `double`) pair, the analyzer complains:

{:.fails-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (inferred-collection-types)" replace="/1.5/[!1.5!]/g"?>
{% prettify dart tag=pre+code %}
// Inferred as Map<String, int>
var map = {'a': 1, 'b': 2, 'c': 3};
map['d'] = [!1.5!];
{% endprettify %}

{:.console-output}
<?code-excerpt "analyzer-results-stable.txt" retain="/common_fixes_analysis.*'double' can't be assigned to a variable of type 'int'/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - A value of type 'double' can't be assigned to a variable of type 'int'. Try changing the type of the variable, or casting the right-hand type to 'int'. - invalid_assignment
```

#### Fix: Specify the type explicitly

The example can be fixed by explicitly defining
the map's type to be `<String, num>`.

{:.passes-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (inferred-collection-types-ok)" replace="/<.*?\x3E/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
var map = [!<String, num>!]{'a': 1, 'b': 2, 'c': 3};
map['d'] = 1.5;
{% endprettify %}

Alternatively, if you want this map to accept any value, 
specify the type as `<String, dynamic>`.

<hr>

<a id="constructor-initialization-list"></a>
### Constructor initialization list super() call

<?code-excerpt "analyzer-results-stable.txt" retain="/The superconstructor call must be last in an initializer list.*/" replace="/Animal/.../g; /-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - The superconstructor call must be last in an initializer list: '...'. - super_invocation_not_last
```

This error occurs when the `super()` call is not last in a constructor's
initialization list.

#### Example

{:.fails-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (super-goes-last)" replace="/super/[!$&!]/g; /_HoneyBadger/HoneyBadger/g"?>
{% prettify dart tag=pre+code %}
HoneyBadger(Eats food, String name)
    : [!super!](food),
      _name = name { ... }
{% endprettify %}

{:.console-output}
<?code-excerpt "analyzer-results-stable.txt" retain="/The superconstructor call must be last in an initializer list.*/" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - The superconstructor call must be last in an initializer list: 'Animal'. - super_invocation_not_last
```

#### Fix: Put the `super()` call last

The compiler can generate simpler code if it relies on the
`super()` call appearing last.

Fix this error by moving the `super()` call:

{:.passes-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (super-goes-last-ok)" replace="/super/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
HoneyBadger(Eats food, String name)
    : _name = name,
      [!super!](food) { ... }
{% endprettify %}

<hr>

<a name="uses-dynamic-as-bottom"></a>
### The argument type ... can't be assigned to the parameter type ...

<?code-excerpt "analyzer-results-stable.txt" retain="/The argument type.*bool Function/" replace="/'bool.*?\)'/'...'/g; /-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - The argument type '...' can't be assigned to the parameter type '...'. - argument_type_not_assignable
```

In Dart 1.x `dynamic` was both a [top type][] (supertype of all types) and a
[bottom type][]  (subtype of all types)
depending on the context. This meant it was valid to assign, for example,
a function with a parameter of type `String` to a place that expected a
function type with a parameter of `dynamic`.

However, in Dart 2 using a parameter type other than `dynamic` (or another _top_
type, such as `Object?`) results in a compile-time error.

#### Example

{:.fails-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (func-fail)" replace="/String/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void filterValues(bool Function(dynamic) filter) {}
filterValues(([!String!] x) => x.contains('Hello'));
{% endprettify %}

{:.console-output}
<?code-excerpt "analyzer-results-stable.txt" retain="/The argument type.*bool Function/" replace="/-(.*?)-/-/g"?>
```nocode
error - The argument type 'bool Function(String)' can't be assigned to the parameter type 'bool Function(dynamic)'. - argument_type_not_assignable
```

#### Fix: Add type parameters _or_ cast from dynamic explicitly

When possible, avoid this error by adding type parameters:

{:.passes-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (func-T)" replace="/<\w+\x3E/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void filterValues[!<T>!](bool Function(T) filter) {}
filterValues[!<String>!]((x) => x.contains('Hello'));
{% endprettify %}

Otherwise use casting:

{:.passes-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (func-cast)" replace="/([Ff]ilter)1/$1/g; /as \w+/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void filterValues(bool Function(dynamic) filter) {}
filterValues((x) => (x [!as String!]).contains('Hello'));
{% endprettify %}

<hr>

### Incorrect type inference

On rare occasions, Dart's type inference might infer the 
wrong type for function literal arguments in a generic constructor invocation.
This primarily affects `Iterable.fold`.

#### Example

In the following code,
type inference will infer that `a` has a type of `Null`:

{:.fails-sa}
<?code-excerpt "lib/common_fixes_analysis.dart (type-inf-null)"?>
{% prettify dart tag=pre+code %}
var ints = [1, 2, 3];
var maximumOrNull = ints.fold(null, (a, b) => a == null || a < b ? b : a);
{% endprettify %}

#### Fix: Supply appropriate type as explicit type argument

{:.passes-sa}
<?code-excerpt "lib/common_fixes_analysis.dart  (type-inf-fix)"?>
{% prettify dart tag=pre+code %}
var ints = [1, 2, 3];
var maximumOrNull =
    ints.fold<int?>(null, (a, b) => a == null || a < b ? b : a);
{% endprettify %}

<hr>

<a id="common-errors-and-warnings"></a>

## Runtime errors

The errors discussed in this section are reported at
[runtime](/language/type-system#runtime-checks).

### Invalid casts

To ensure type safety, Dart needs to insert _runtime_ checks in some cases. 
Consider the following `assumeStrings` method:

{:.passes-sa}
<?code-excerpt "test/strong_test.dart (downcast-check)" replace="/string = objects/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void assumeStrings(dynamic objects) {
  List<String> strings = objects; // Runtime downcast check
  String string = strings[0]; // Expect a String value
}
{% endprettify %}

The assignment to `strings` is _downcasting_ the `dynamic` to `List<String>`
implicitly (as if you wrote `as List<String>`), so if the value you pass in
`objects` at runtime is a `List<String>`, then the cast succeeds.

Otherwise, the cast will fail at runtime:

{:.runtime-fail}
<?code-excerpt "test/strong_test.dart (fail-downcast-check)" replace="/\[.*\]/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
assumeStrings(<int>[![1, 2, 3]!]);
{% endprettify %}

{:.console-output}
<?code-excerpt "test/strong_test.dart (downcast-check-msg)" replace="/const msg = ./Exception: /g; /.;//g"?>
```nocode
Exception: type 'List<int>' is not a subtype of type 'List<String>'
```

#### Fix: Tighten or correct types

Sometimes, lack of a type, especially with empty collections, means that
a `<dynamic>` collection is created, instead of the typed one you intended. 
Adding an explicit type argument can help:

{:.runtime-success}
<?code-excerpt "test/strong_test.dart (typed-list-lit)" replace="/<String\x3E/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
var list = [!<String>!][];
list.add('a string');
list.add('another');
assumeStrings(list);
{% endprettify %}

You can also more precisely type the local variable, and let inference help:

{:.runtime-success}
<?code-excerpt "test/strong_test.dart (typed-list)" replace="/<String\x3E/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
List[!<String>!] list = [];
list.add('a string');
list.add('another');
assumeStrings(list);
{% endprettify %}

In cases where you are working with a collection that you don't create, such
as from JSON or an external data source, you can use the [cast()][] method 
provided by `Iterable` implementations, such as `List`.

Here's an example of the preferred solution: tightening the object's type.

{:.runtime-success}
<?code-excerpt "test/strong_test.dart (cast)" replace="/cast/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
Map<String, dynamic> json = fetchFromExternalSource();
var names = json['names'] as List;
assumeStrings(names.[!cast!]<String>());
{% endprettify %}

## Appendix

### The covariant keyword

Some (rarely used) coding patterns rely on tightening a type
by overriding a parameter's type with a subtype, which is invalid.
In this case, you can use the `covariant` keyword to
tell the analyzer that you are doing this intentionally.
This removes the static error and instead checks for an invalid
argument type at runtime.

The following shows how you might use `covariant`:

{:.passes-sa}
<?code-excerpt "lib/covariant.dart" replace="/covariant/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
class Animal {
  void chase(Animal x) { ... }
}

class Mouse extends Animal { ... }

class Cat extends Animal {
  @override
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
[cast()]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable/cast.html
[Iterable]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html
[List]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html
[top type]: https://en.wikipedia.org/wiki/Top_type
