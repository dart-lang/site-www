---
title: Extension types
description: Learn how to write a static-only interface for an existing type.
prevpage:
  url: /language/extension-methods
  title: Extension methods
nextpage:
  url: /language/callable-objects
  title: Callable objects
---

An extension type is a compile time abstraction that "wraps"
an existing type with a different, static-only interface.
They allow you to enforce discipline on the set of operations available
to objects of the underlying type, called the *representation type*.
You can choose to use some members, omit others,
replace others, and add new functionality, 
all while getting compile time errors before runtime errors.

The following example wraps the `int` type to create an extension type
that only allows operations that make sense for ID numbers:

```dart
extension type IdNumber(int i) {
  // Wraps the 'int' type's '<' operator:
  operator <(IdNumber other) => i < other.i;
  // Doesn't declare the '+' operator, for example,
  // because addition does not make sense for ID numbers.
}

void main() {
  // Without the discipline of an extension type,
  // 'int' exposes ID numbers to unsafe operations:
  int myUnsafeId = 42424242;
  myUnsafeId = myUnsafeId + 10; // OK, but shouldn't be allowed for IDs.

  var safeId = IdNumber(42424242);
  safeId + 10; // Compile-time error, no '+' operator.
  myUnsafeId = safeId; // Compile-time error, wrong type.
  myUnsafeId = safeId as int; // OK, runtime cast to representation type.
}
```

{{site.alert.note}}
Extension types serve the same purpose as **wrapper classes**,
but don't require the creation of expensive runtime objects.
Because extension types are static-only and compiled away at runtime,
they are essentially zero cost.

[**Extension methods**]() are a static abstraction similar to extension types.
However, an extension method adds functionality to *all* instances
of its underlying type. Extension types are the opposite; 
an extension type's interface only applies to objects
declared with the extension type,
and is distinct from the interface of its underlying type by default. 
Read the [Transparency](#transparency) section for more details. 
{{site.alert.end}}

## Syntax

### Declaration

Define a new extension type with the `extension type` declaration and a name,
followed by the *representation type declaration* in parenthesis:

```dart
extension type E(int i) {
  // Define set of operations
}
```

The representation type declaration specifies that 
the underlying type of extension type `E` is `int`,
and the reference to the *representation object* is named `i`.

The representation object gives access to the underlying type,
the same way declaring a final instance variable of the underlying type
would in a wrapper class.
It's in scope in the extension type body, and
you can access it using its name as a getter:

- Within the extension type body: `this.i`.
- Outside with a property extraction: `e.i` (where `e` is the object of an extension type). 

Extension types declarations can also include [type parameters](generics)
just like classes:

```dart
extension type E<T>(int i) {
  // ...
}
```

### Constructors

You can optionally declare constructors in an extension type's body.
A constructor must be named, because the the representation declaration
already acts as an unnamed constructor for the extension type
that initializes the represenation object.
Any additional constructors must declare the representation object's
instance variable in its initializer list:

```dart
// 'E' has a named constructor 'n',
// as well as its built-in unnamed constructor
extension type E(int i) {
  E.n(this.i, String foo);
}

void main() {
  var named = E.n(3, "Hello");
  var unnamed = E(4);
}
```

### Members

Declare members in the body of an extension type to define its interface. 
Extension type member declarations are identical to class members.
Members can be methods, getters, setters, or operators:

```dart
extension type NumberE(int value) {
  // Operator:
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);
  // Getter:
  NumberE get i => value;
  // Method:
  bool isValid() => !value.isNegative;
}
```

Members of the representation type are not available to the extension type
by default. If you want a member from the representation type to be available
to the extension type, you must write a declaration for it
in the extension type definition, like the `operator +` in `NumberE`.
You also can define new members unrelated to the representation type,
like the `i` getter and `isValid` method.

Extension types can't declare instance fields (unless [`external`](#interop)),
or [abstract members]().

### Implements

You can optionally use the `implements` clause to introduce
a subtype relationship on an extension type, making *all* members
of the representation type available to the extension type:

```dart
extension type NumberI(int i) 
  implements int{
  // ...
}
```

An extension type can only implement its representation type
or a supertype of its representation type.

This is technically NOT an inheritance relationship
like the one `implements` introduces for classes,
but rather an [applicability][] relationship like that between an
extension method and its `on` type.
Members that apply to the supertype are applicable to the subtype,
unless the supertype has a more specific definition for the member.

#### `@redeclare`

Replacing a method that shares a name with a member of the supertype
is not an override relationship for extension types, but a *redeclaration*.
Use the `@redeclare` annotation to tell the compiler you are *knowingly* choosing
to use the same name as a supertype's member definition, not just accidentally
using the same name:

```dart
class C {
  void m() {}
}

extension type E(C c) implements C {
  @redeclare
  void m() {}
}
```

If you don't use the annotation, the compiler will choose the [more specific][]
definition wherever the name is invoked, which might not be the behavior you expect.

## Usage

To use an extension type, create an instance the same as you would with a class:

```dart
extension type NumberE(int value) {
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);

  NumberE get i => value;
  bool isValid() => !value.isNegative;
}

void testE() { 
  var num = NumberE(1);
}
```

Then you can invoke members on the object as you would with a class object.
Any attempt to treat the extension type object as an object
of the representation type, or vice versa, will result in compile time errors
(unless the extension type is [transparent](#transparency)).
For example:

```dart
void testE() { 
  var num = NumberE(1);
  int num2 = NumberE(2); // Error: Can't assign 'NumberE' to 'int'.
  
  num.isValid(); // Ok: Extension member invocation.
  num.isNegative(); // Error: 'NumberE' does not define int member 'isNegative'.
  
  var sum = num + num; // Ok: 'NumberE' defines '+'.
  var diff = num - num; // Error: 'NumberE' does not define int member '-'.
  var diff2 = num.value - 2; // Ok: Can access representation object with reference.
  var sum2 = num + 2; // Error: Can't assign 'int' to parameter type 'NumberE'. 
  
  List<NumberE> numbers = [
    NumberE(1), 
    num.i, // Ok: 'i' getter returns type 'NumberE'.
    1, // Error: Can't assign 'int' element to list type 'NumberE'.
    1 as NumberE, // Ok: Dynamic type cast recognizes representation type.
  ];
}
```

#### Transparency

An extension type that [implements](#implements) its representation type
is considered *transparent* because it gives the extension type access
to *all* members of the representation type. Otherwise,
only the members declared in the extension type body are available to it
(considered a [*somewhat protected*](#type-considerations) extension type).

```dart
extension type NumberT(int value) 
  implements int {
  // Doesn't explicitly include any members of 'int'.
  NumberT get i => NumberT(value);
}

void main () {
  var num = NumberT(1);
  // All OK: Representation type interface is available to extension type:
  int numT = NumberT(2);

  num.i - num;
  numT + num;
  num - 1;
  2 + num;
  // Error: Extension type member not defined for representation type:
  numT.i;
}
```

Transparency is a conceptual decision for the extension type creator to consider.
The section [Provide an *extended* interface](#provide-an-extended-interface-to-an-existing-type)
explains the transparent extension type use case, and the
[Provide a *different* interface](#provide-a-different-interface-to-an-existing-type)
section explains non-transparent extension types types. 

## Use cases for extension types

### Interop with other languages

Extension types enable interoperability between Dart and JavaScript.

Using a JS type, usually `JSObject`, as the representation type and implementing
that type to export its interface lets the compiler know that
any `external` members declared in that extension type are native JavaScript members.

```dart
@JS('Set')
extension type ES6Set._(JSObject _)
    implements JSObject { 
  external ES6Set();

  external ES6Set add(JSAny element);
  external void clear();
  external bool delete(JSAny element);
  external void forEach(
      JSFunction callback);
  external bool has(JSAny element);
}
```

A client using this extension type will have a full implemenation
of the interface of that JS object, and will not need to call any low-level
functions (like `js_util`) to get the same functionality. 

{% comment %}
TODO: Link to JS interop pages when published.
{% endcomment %}

### Provide a *different* interface to an existing type

You can use an extension type to replace the interface of an existing type.
This allows you to model something that benefits from the performance
and convenience of a pre-defined type,
while ensuring that none of the representation type's interface is available to the new type
(similar to the `newtype` mechanism in Haskell and Rust),
and without the cost of wrapping

To provide a different interface for an existing type, so that at compile time
it is distinct-from and incompatible-with the representation type,
declare an extension type WITHOUT implementing the representation type in the declaration,
and without calling any of its members in the extension type member declarations:

```dart
// use int to represent length in inches
extension type Inch(int value) {
  Inch operator +(Inch other) =>
      Inch(value + other.value);
}

// use int to represent length in centimeters
extension type Cm(int value) {
  Cm operator +(Cm other) => 
      Cm(value + other.value);
}

void main() {
  // Despite sharing a representation type, 'Inch' and 'Cm' are
  // incompatible with each other and with their underlying type.
  List<Inch> inches = [
    Inch(1), // OK.
    1 as Inch, // OK.
    1 as Cm, // Compile-time error.
    1, // Compile-time error.
  ];
  // All errors:
  1 + 1.inch; 1.inch + 1; 1.cm + 1.inch;
}
```

This ensures it can't access anything from the representation type that you don't want it to.
This is as close as you can get to the complete protection of a wrapper class
without the cost. 

Keep in mind this distinction is only *somewhat* protected
from the representation type. Read [Type considerations](#type-considerations)
for more information.

### Provide an *extended* interface to an existing type

One use for extension types is adding new methods to an existing type.
This allows you to get all the functionality of the underlying type,
plus whatever additional functionality you want on top.
The new extended interface applies only to instances of the extension type,
not instances of the underlying type.

To extend the interface of an existing type, use it as the representation type
*and* implement it in the extension type declaration:

```dart
extension type WidgetMap<K, V extends Widget>(Map<K, V> map)
  implements Map<K, V> {
  // Auxiliary members.
}
```

This example declaration exports all the members of the `Map`,
so you can invoke any `Map` methods on instances of the `WidgetMap` extension type,
in addition to any auxillary members you define.
The relationship is not inverse, though: auxillary members of `WidgetMap`
are not available to instance of `Map`.

It's also possible to statically extend an existing type's interface with extension *methods*.
However, extension type methods are always visible if the type is accessible
without importing,
and only to visible to objects with access to the extension type (direct instances and subtype instances?)
whereas  regular extensions are only visible if the client imports them. 
Once imported, an extension method then becomes available to every object that
has the same type as the extension method's `on` type, bleeding all over the type.

### Reuse code

Extension types can offer something *like* multiple inheritance when one
implements one or more other extension types, allowing you to reuse 
extension type code.

like extension methods, when you have a receiver that has the more special type, then all the extension methods that are defined for the super type are also invokable on the subtype 

Like extension members, extension type members can be applied to any subtype. 

```dart
class const Point1d(int x);
class const Point2d(super.x, int y) 
    extends Point1d;

int abs(int i) => i < 0 ? -i : i;

extension type P1(Point1d it) {
  bool get remote => abs(it.x) > 10;
  bool get onYAxis => it.x == 0;
}

extension type P2(Point2d it) implements P1 {
  bool get remote =>
      P1(it).remote || abs(it.y) > 10;
}

void main() {
  var p = P2(Point2d(1, 100));
  print(p.remote); // 'true'.
  print(p.onYAxis); // 'false'.
}
```

## Type considerations

Extension types are a compile-time wrapping construct.
At runtime, there is absolutely no trace of the extension type.
Any type query or similar runtime expression works on the representation type.

This makes extension types an *unsafe* abstraction,
because you can always find out the representation type at runtime
and access the underlying object.

Dynamic type tests (`e is T`), casts (`e as T`),
and other runtime type queries (like `switch (e) ...` or `if (e case ...)`)
all evaluate to the underlying representation type. 
That's true when the static type of `e` is an extension type,
and when testing against an extension type (`case MyExtensionType(): ... `).

```dart
void main() {
  var num = NumberE(1);
  
  if (num case int x) {  // True because runtime type is representation type.
    print(x);
  }
  
  switch (num) {
    case (int x): print(x);  // Matches because runtime type is representation type.
  }
}
```

It's important to be aware of this quality when using extension types,
and never rely on them in scenarios where the representation type must be concealed. 
The trade off for using an extension type over a more-secure real object (wrapper class)
is their lightweight implementation, which can greatly improve performance in some scenarios.

[extension methods]: /language/extension-methods
[applicability]: https://github.com/dart-lang/language/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#examples
[more specific]: https://github.com/dart-lang/language/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#specificity
[abstract members]: /language/methods#abstract-methods
[`is` or `as` check]: /language/operators#type-test-operators