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

An extension type is a compile-time abstraction that "wraps"
an existing type with a different, static-only interface.
They are a major component of [static JS interop][] because 
they can easily modify an existing type's interface
(crucial for any kind of interop)
without incurring the cost of an actual wrapper.

Extension types enforce discipline on the set of operations (or interface)
available to objects of an underlying type,
called the *representation type*.
When defining the interface of an extension type,
you can choose to reuse some members of the representation type,
omit others, replace others, and add new functionality.

The following example wraps the `int` type to create an extension type
that only allows operations that make sense for ID numbers:

```dart
extension type IdNumber(int id) {
  // Wraps the 'int' type's '<' operator:
  operator <(IdNumber other) => id < other.id;
  // Doesn't declare the '+' operator, for example,
  // because addition does not make sense for ID numbers.
}

void main() {
  // Without the discipline of an extension type,
  // 'int' exposes ID numbers to unsafe operations:
  int myUnsafeId = 42424242;
  myUnsafeId = myUnsafeId + 10; // This works, but shouldn't be allowed for IDs.

  var safeId = IdNumber(42424242);
  safeId + 10; // Compile-time error: No '+' operator.
  myUnsafeId = safeId; // Compile-time error: Wrong type.
  myUnsafeId = safeId as int; // OK: Run-time cast to representation type.
  safeId < IdNumber(42424241); // OK: Uses wrapped '<' operator.
}
```

:::note
Extension types serve the same purpose as **wrapper classes**,
but don't require the creation of an extra run-time object,
which can get expensive when you need to wrap lots of objects.
Because extension types are static-only and compiled away at run time,
they are essentially zero cost.

[**Extension methods**][ext] (also known just as "extensions")
are a static abstraction similar to extension types.
However, an extension method adds functionality *directly*
to every instance of its underlying type.
Extension types are different;
an extension type's interface *only* applies to expressions
whose static type is that extension type.
They are distinct from the interface of their underlying type by default.
:::

## Syntax

### Declaration

Define a new extension type with the `extension type` declaration and a name,
followed by the *representation type declaration* in parenthesis:

```dart
extension type E(int i) {
  // Define set of operations.
}
```

The representation type declaration `(int i)` specifies that 
the underlying type of extension type `E` is `int`,
and that the reference to the *representation object* is named `i`.
The declaration also introduces:
- An implicit getter for the representation object
  with the representation type as the return type: `int get i`.
- An implicit constructor: `E(int i) : i = i`.

The representation object gives the extension type access to an object
at the underlying type.
The object is in scope in the extension type body, and
you can access it using its name as a getter:

- Within the extension type body using `i` (or `this.i` in a constructor).
- Outside with a property extraction using `e.i`
  (where `e` has the extension type as its static type). 

Extension type declarations can also include [type parameters](generics)
just like classes or extensions:

```dart
extension type E<T>(List<T> elements) {
  // ...
}
```

### Constructors

You can optionally declare [constructors][] in an extension type's body.
The representation declaration itself is an implicit constructor,
so by default takes the place of an unnamed constructor for the extension type.
Any additional non-redirecting generative constructors must
initialize the representation object's instance variable
using `this.i` in its initializer list or formal parameters.

```dart
extension type E(int i) {
  E.n(this.i);
  E.m(int j, String foo) : i = j + foo.length;
}

void main() {
  E(4); // Implicit unnamed constructor.
  E.n(3); // Named constructor.
  E.m(5, "Hello!"); // Named constructor with additional parameters.
}
```

Or, you can name the representation declaration constructor,
in which case there is room for an unnamed constructor in the body:

```dart
extension type const E._(int it) {
  E(): this._(42);
  E.otherName(this.it);
}

void main2() {
  E();
  const E._(2);
  E.otherName(3);
}
```

You can also completely hide the constructor, instead of just defining a new one,
using the same private constructor syntax for classes, `_`. For example,
if you only want clients constructing `E` with a `String`, even though
the underlying type is `int`:

```dart
extension type E._(int i) {
  E.fromString(String foo) : i = int.parse(foo);
}
```

You can also declare forwarding generative constructors,
or [factory constructors][factory]
(which can also forward to constructors of sub-extension types).

### Members

Declare members in the body of an extension type to define its interface
the same way you would for class members.
Extension type members can be methods, getters, setters, or operators
(non-[`external`][] [instance variables][] and [abstract members][]
are not allowed):

```dart
extension type NumberE(int value) {
  // Operator:
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);
  // Getter:
  NumberE get myNum => this;
  // Method:
  bool isValid() => !value.isNegative;
}
```

Interface members of the representation type are not interface members
of the extension type [by default](#transparency).
To make a single member of the representation type available
on the extension type, you must write a declaration for it
in the extension type definition, like the `operator +` in `NumberE`.
You also can define new members unrelated to the representation type,
like the `i` getter and `isValid` method.

### Implements

You can optionally use the `implements` clause to:
- Introduce a subtype relationship on an extension type, AND
- Add the members of the representation object to the extension type interface.

The `implements` clause introduces an [applicability][]
relationship like the one between an [extension method][ext] and its `on` type.
Members that are applicable to the supertype are applicable to the
subtype as well, unless the subtype has a declaration with the same
member name.

An extension type can only implement:

- **Its representation type**.
  This makes all members of the representation type implicitly available
  to the extension type.
  
  ```dart
  extension type NumberI(int i) 
    implements int{
    // 'NumberI' can invoke all members of 'int',
    // plus anything else it declares here.
  }
  ```
  
- **A supertype of its representation type**.
  This makes the members of the supertype available,
  while not necessarily all the members of representation type.
  
  ```dart
  extension type Sequence<T>(List<T> _) implements Iterable<T> {
    // Better operations than List.
  }
  
  extension type Id(int _id) implements Object {
    // Makes the extension type non-nullable.
    static Id? tryParse(String source) => int.tryParse(source) as Id?;
  }
  ```
  
- **Another extension type** that is valid on the same representation type.
  This allows you to reuse operations across multiple extension types
  (similar to multiple inheritance).
  
  ```dart
  extension type const Opt<T>._(({T value})? _) { 
    const factory Opt(T value) = Val<T>;
    const factory Opt.none() = Non<T>;
  }
  extension type const Val<T>._(({T value}) _) implements Opt<T> { 
    const Val(T value) : this._((value: value));
    T get value => _.value;
  }
  extension type const Non<T>._(Null _) implements Opt<Never> {
    const Non() : this._(null);
  }
  ```

Read the [Usage](#usage) section to learn more about the effect of `implements`
in different scenarios.

#### `@redeclare`

Declaring an extension type member that shares a name with a member of a supertype
is *not* an override relationship like it is between classes,
but rather a *redeclaration*. An extension type member declaration
*completely replaces* any supertype member with the same name. 
It's not possible to provide an alternative implementation
for the same function.

You can use the `@redeclare` annotation to tell the compiler you are
*knowingly* choosing to use the same name as a supertype's member.
The analyzer will then warn you if that's not actually true,
for example if one of the names are mistyped.

```dart
extension type MyString(String _) implements String {
  // Replaces 'String.operator[]'
  @redeclare
  int operator [](int index) => codeUnitAt(index);
}
```

You can also enable the lint [`annotate_redeclares`][lint]
to get a warning if you declare an extension type method
that hides a superinterface member and *isn't* annotated with `@redeclare`.

## Usage

To use an extension type, create an instance the same as you would with a class:
by calling a constructor:

```dart
extension type NumberE(int value) {
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);

  NumberE get next => NumberE(value + 1);
  bool isValid() => !value.isNegative;
}

void testE() { 
  var num = NumberE(1);
}
```

Then, you can invoke members on the object as you would with a class object.

There are two equally valid, but substantially different core use cases
for extension types:

1. Providing an *extended* interface to an existing type.
2. Providing a *different* interface to an existing type.

:::note
In any case, the representation type of an extension type is never its subtype,
so a representation type can't be used interchangeably where the extension type is needed.
:::

<a id="transparency"></a>

### 1. Provide an *extended* interface to an existing type

When an extension type [implements](#implements) its representation type,
you can consider it "transparent", because it allows the extension type
to "see" the underlying type.

A transparent extension type can invoke all members of the
representation type (that aren't [redeclared](#redeclare)),
plus any auxillary members it defines. 
This creates a new, *extended* interface for an existing type.
The new interface is available to expressions
whose static type is the extension type.

This means you *can* invoke members of the representation type
(unlike a [non-transparent](#2-provide-a-different-interface-to-an-existing-type)
extension type), like so:

```dart
extension type NumberT(int value) 
  implements int {
  // Doesn't explicitly declare any members of 'int'.
  NumberT get i => this;
}

void main () {
  // All OK: Transparency allows invoking `int` members on the extension type:
  var v1 = NumberT(1); // v1 type: NumberT
  int v2 = NumberT(2); // v2 type: int
  var v3 = v1.i - v1;  // v3 type: int
  var v4 = v2 + v1; // v4 type: int
  var v5 = 2 + v1; // v5 type: int
  // Error: Extension type interface is not available to representation type
  v2.i;
}
```

You can also have a "mostly-transparent" extension type
that adds new members and adapts others by redeclaring a given member name
from the supertype.
This would allow you to use stricter types on some parameters of a method,
or different default values, for example.

Another mostly-transparent extension type approach is to implement
a type that is a supertype of the representation type.
For example, if the representation type is private but its supertype
defines the part of the interface that matters for clients.

### 2. Provide a *different* interface to an existing type

An extension type that is not [transparent](#transparency)
(that does not [`implement`](#implements) its representation type)
is statically treated as a completely new type,
distinct from its representation type.
You can't assign it to its representation type,
and it doesn't expose its representation type's members.

For example, take the `NumberE` extension type we declared under [Usage](#usage):

```dart
void testE() { 
  var num1 = NumberE(1);
  int num2 = NumberE(2); // Error: Can't assign 'NumberE' to 'int'.
  
  num1.isValid(); // OK: Extension member invocation.
  num1.isNegative(); // Error: 'NumberE' does not define 'int' member 'isNegative'.
  
  var sum1 = num1 + num1; // OK: 'NumberE' defines '+'.
  var diff1 = num1 - num1; // Error: 'NumberE' does not define 'int' member '-'.
  var diff2 = num1.value - 2; // OK: Can access representation object with reference.
  var sum2 = num1 + 2; // Error: Can't assign 'int' to parameter type 'NumberE'. 
  
  List<NumberE> numbers = [
    NumberE(1), 
    num1.next, // OK: 'next' getter returns type 'NumberE'.
    1, // Error: Can't assign 'int' element to list type 'NumberE'.
  ];
}
```

You can use an extension type this way to *replace* the interface
of an existing type. This allows you to model an interface that is
makes sense for the constraints of your new type
(like the `IdNumber` example in the introduction), while also benefitting from
the performance and convenience of a simple pre-defined type, like `int`.

This use case is as close as you can get to the complete encapsulation
of a wrapper class (but is realistically only a
[*somewhat* protected](#type-considerations) abstraction).

## Type considerations

Extension types are a compile-time wrapping construct.
At run time, there is absolutely no trace of the extension type.
Any type query or similar run-time operations work on the representation type.

This makes extension types an *unsafe* abstraction,
because you can always find out the representation type at run time
and access the underlying object.

Dynamic type tests (`e is T`), casts (`e as T`),
and other run-time type queries (like `switch (e) ...` or `if (e case ...)`)
all evaluate to the underlying representation object,
and type check against that object's runtime type. 
That's true when the static type of `e` is an extension type,
and when testing against an extension type (`case MyExtensionType(): ... `).

```dart
void main() {
  var n = NumberE(1);

  // Run-time type of 'n' is representation type 'int'.
  if (n is int) print(n.value); // Prints 1.

  // Can use 'int' methods on 'n' at run time.
  if (n case int x) print(x.toRadixString(10)); // Prints 1.
  switch (n) {
    case int(:var isEven): print("$n (${isEven ? "even" : "odd"})"); // Prints 1 (odd).
  }
}
```

Similarly, the static type of the matched value is that of the extension type
in this example:

```dart
void main() {
  int i = 2;
  if (i is NumberE) print("It is"); // Prints 'It is'.
  if (i case NumberE v) print("value: ${v.value}"); // Prints 'value: 2'.
  switch (i) {
    case NumberE(:var value): print("value: $value"); // Prints 'value: 2'.
  }
}
```

It's important to be aware of this quality when using extension types.
Always keep in mind that an extension type exists and matters at compile time,
but gets erased _during_ compilation.

For example, consider an expression `e` whose static type is the
extension type `E`, and the representation type of `E` is `R`.
Then, the run-time type of the value of `e` is a subtype of `R`.
Even the type itself is erased;
`List<E>` is exactly the same thing as `List<R>` at run time.

In other words, a real wrapper class can encapsulate a wrapped object,
whereas an extension type is just a compile-time view on the wrapped object.
While a real wrapper is safer, the trade-off is extension types
give you the option to avoid wrapper objects, which can greatly
improve performance in some scenarios.

[static JS interop]: /go/next-gen-js-interop
[ext]: /language/extension-methods
[generics]: /language/generics
[constructors]: /language/constructors
[factory]: /language/constructors#factory-constructors
[applicability]: {{site.repo.dart.lang}}/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#examples
[more specific]: {{site.repo.dart.lang}}/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#specificity
[lint]: /tools/linter-rules/annotate_redeclares
[instance variables]: /language/classes#instance-variables
[`external`]: /language/functions#external
[abstract members]: /language/methods#abstract-methods
[`is` or `as` check]: /language/operators#type-test-operators
