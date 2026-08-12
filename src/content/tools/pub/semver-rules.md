---
title: SemVer compatibility and breaking changes
breadcrumb: SemVer rules
description: >-
  A comprehensive guide to what changes are breaking major changes, non-breaking
  minor features, or patch bug fixes in Dart packages.
---

When developing and publishing Dart packages, adhering to
[Semantic Versioning][semver] is essential for maintaining a healthy
and predictable package ecosystem.

This guide provides a detailed reference on how various changes to your Dart
code affect the public API surface of your package and what version bump
is required.

:::tip
For a conceptual overview of pub's version solving algorithm and lockfiles,
see the [Package versioning](/tools/pub/versioning) guide.
:::

## Semantic versioning and `package:pub_semver`

Dart's package manager, pub, follows [Semantic Versioning 2.0.0][semver] as implemented by [`package:pub_semver`][pub_semver].

A standard version number is formatted as `MAJOR.MINOR.PATCH`, such as `1.2.3`:

* **`MAJOR`**: Incompatible breaking changes to the public API.
* **`MINOR`**: Backward-compatible new functionality or features.
* **`PATCH`**: Backward-compatible bug fixes.

### Pre-1.0.0 versions

While standard SemVer 2.0.0 allows any change before version `1.0.0`, pub and [`pub_semver`][pub_semver] enforce a stricter convention so that consumers can safely depend on pre-1.0.0 packages using [caret syntax](/tools/pub/dependencies#caret-syntax):

* **`0.y.z` versions where $y > 0$, such as `0.2.0`:**
  * Bumping `y` from `0.2.0` to `0.3.0` is treated as a **breaking change**, which is equivalent to a major bump.
  * Bumping `z` from `0.2.0` to `0.2.1` is treated as a **backward-compatible change**, which is equivalent to a minor or patch bump.
  * Caret syntax `^0.2.0` allows `>=0.2.0 <0.3.0`.
* **`0.0.z` versions, such as `0.0.1`:**
  * Bumping `z` from `0.0.1` to `0.0.2` is treated as a **breaking change**.
  * Caret syntax `^0.0.1` allows only `>=0.0.1 <0.0.2`.

## The public API boundary

In Dart packages, the **public API** comprises all declarations accessible to
consumers of your package:

* **Public:** Any library directly inside `lib/`, such as `lib/my_package.dart`,
  and any declarations re-exported through `export` directives.
* **Private and internal:** Any file inside `lib/src/` that is **not**
  re-exported by a public library in `lib/`. Changes to unexported files in
  `lib/src/` are considered internal and do not affect the public SemVer contract.

---

## Top-level declarations

### MINOR: Add a new top-level declaration

Adding a new public top-level function, class, typedef, enum, extension, or constant is backward-compatible. Existing consumer code will continue to compile and function as before.

```dart tag=good
// Added to lib/my_package.dart in a minor release:
void newHelperFunction() {}
```

*Note:* While introducing a new top-level name can theoretically create a naming conflict with a wildcard import like `import 'package:foo/foo.dart';` in downstream code, SemVer treats top-level additions as non-breaking.

### MAJOR: Remove a public top-level declaration

Removing any public top-level declaration is a breaking change. Any downstream code referencing the removed symbol will fail to compile.

### MAJOR: Rename a public top-level declaration

Renaming a public symbol is functionally equivalent to removing the original name and introducing a new one. Downstream code referencing the original name will break.

### MAJOR: Move a declaration to `lib/src/` without re-exporting

Moving a declaration from the public `lib/` root to `lib/src/`, without an `export` in a public library file, makes it inaccessible to external packages, breaking all existing consumers.

### MAJOR: Widen or change the type of a `const` or `final` variable

Changing a `const` or `final` variable to a broader type, such as changing `const int maxRetries` to `const num maxRetries`, or to an incompatible type breaks callers expecting members of the more specific type.

### MINOR: Narrow the type of a `const` or `final` variable

Narrowing the static type of a read-only `const` or `final` variable to a more specific subtype, such as changing `const num timeout` to `const int timeout` or `const Object key` to `const String key`, is backward-compatible. Because consumers only read the value, a more specific subtype satisfies all existing type expectations while providing additional type safety.

### MAJOR: Change the type of a mutable top-level variable

For mutable `var` variables that can be both read from and written to, changing the static type in either direction is a breaking change:
* Narrowing the type, such as `num` to `int`, breaks callers assigning a `double` into the variable.
* Widening the type, such as `int` to `num`, breaks callers expecting `int` methods when reading the variable.

### MAJOR: Change a top-level variable from `var` to `final`

Making a mutable variable `final` breaks any consumer assigning values to that variable.

---

## Classes, mixins, and class modifiers

Dart 3 introduced class modifiers: `final`, `base`, `interface`, `sealed`, and `mixin`. These allow package authors to explicitly define how classes can be used by consumers. The SemVer impact of adding or modifying members depends on these modifiers.

### Changing modifiers on existing classes

Changing the modifier on an already-published class alters what external packages are permitted to do with it:

#### MAJOR: Change a concrete class to an abstract class

Changing a concrete class to `abstract class` prevents external consumers from instantiating the class directly using `new MyClass()`, causing compile errors.

#### MINOR: Change an abstract class to a concrete class

Making an abstract class concrete enables external instantiation without breaking existing subclasses or implementers.

#### MAJOR: Add the `base` modifier to an existing class

Prevents external consumers from implementing the class using `implements MyClass`, breaking all existing external implementers.

#### MAJOR: Add the `interface` modifier to an existing class

Prevents external consumers from extending the class using `extends MyClass`, breaking all existing external subclasses.

#### MAJOR: Add the `final` or `sealed` modifier to an existing class

Prevents external consumers from extending, implementing, or mixing in the class, breaking all existing external subtypes.

#### MAJOR: Remove the `mixin` modifier from a `mixin class`

Prevents external consumers from using the class as a mixin using `with MyClass`.

#### MINOR: Remove `base`, `interface`, or `final` from a class

Loosens restrictions on consumers, granting new capabilities without invalidating existing code.

---

### Unmodified classes: `class` and `abstract class`

An unmodified class in Dart allows external packages to construct, extend using `extends`, and implement using `implements`.

#### MAJOR: Add an instance member to an unmodified class

Adding any instance method, getter, setter, or field to an unmodified `class` or `abstract class` is a breaking change. Because external libraries are permitted to write `class MyImpl implements Foo`, any new member in `Foo` breaks existing implementers due to missing overrides.

```dart tag=bad
// In package:foo (v1.1.0) - BREAKING for external implementers:
abstract class HttpClient {
  void get(String url);
  void post(String url, Object body); // External `implements HttpClient` fails!
}
```

#### MAJOR: Remove or rename an instance member

Removing or renaming an instance method, getter, setter, or field breaks all callers, extenders, and implementers.

#### MINOR: Add a static member to a class

Static members are namespaced to the class, such as `Class.member`, and do not affect subclasses or external implementations.

#### MAJOR: Remove or rename a static member

Breaks call sites referencing `Class.staticMember`.

---

### `final class` and `abstract final class`

A `final` class cannot be extended, implemented, or mixed in outside of the defining library.

#### MINOR: Add an instance member to a final class

Since external code cannot extend or implement a `final class`, adding new instance methods, getters, setters, or fields is completely backward-compatible. Consumers only call existing members and cannot be broken by added members.

```dart tag=good
// Safe to add in a minor release:
final class Config {
  final String host;
  final int port;
  Config(this.host, this.port);

  bool get isSecure => port == 443;
}
```

#### MAJOR: Remove or rename an instance member of a final class

Existing callers referencing the removed member will fail to compile.

---

### `base class`

A `base` class can be extended outside the library, but cannot be implemented using `implements`.

#### MINOR: Add a concrete instance member to a base class

Because external libraries can only extend rather than implement a `base class`, subclasses automatically inherit the new default implementation without needing to override it.

#### MAJOR: Add an abstract member to a base class

Subclasses in external libraries will fail to compile because they do not provide an implementation for the new abstract member.

#### MAJOR: Remove or rename an instance member of a base class

Breaks both callers and extending subclasses.

---

### `interface class` and `abstract interface class`

An `interface` class can be implemented outside the library, but cannot be extended using `extends`.

#### MAJOR: Add any member to an interface class

External classes can implement an `interface class`. Adding any new method, getter, setter, or field requires implementers to provide the new member, breaking compilation.

#### MAJOR: Remove or rename an instance member of an interface class

Breaks callers and implementers.

---

### `sealed class`

A `sealed` class is implicitly abstract and cannot be extended, implemented, or mixed in outside the library. It is designed for exhaustive pattern matching.

#### MAJOR: Add a direct subtype to a sealed class family

Adding a new subclass to a `sealed` class is a breaking change because exhaustive `switch` statements or pattern matches in consumer code that do not have a wildcard `_` or `default` case will fail to compile.

```dart tag=bad
sealed class Result {}
class Success extends Result {}
class Failure extends Result {}

// Adding `class Pending extends Result {}` breaks exhaustive switches:
// switch (result) {
//   case Success(): ...
//   case Failure(): ...
//   // Error: Switch is no longer exhaustive!
// }
```

#### MINOR: Add a member to a sealed class

External code cannot implement or extend a `sealed` class, so adding instance or static members is non-breaking.

---

### `mixin` and `mixin class`

#### MINOR: Add a concrete member to a mixin

Classes using `with MyMixin` automatically receive the concrete implementation.

*Note:* Adding a member is technically breaking if an external consumer used `implements MyMixin`, but the standard and intended usage of mixins is with the `with` keyword.

#### MAJOR: Add an abstract member to a mixin

Requires all classes applying the mixin to supply an implementation for the new abstract member.

#### MAJOR: Tighten the `on` constraint on a mixin

Restricting the superclass requirements, such as from `on Object` to `on Widget`, prevents existing classes that do not meet the new requirement from mixing it in.

---

## Type aliases: `typedef`

Type aliases define names for function types, records, or existing class types.

### MINOR: Add a new type alias

Adding a new public `typedef` exposes a new type name without affecting existing code.

### MAJOR: Remove or rename a type alias

Any downstream code referencing the removed `typedef` name will fail to compile.

### MAJOR: Change the aliased type in a type alias

Changing the underlying type that a type alias references, such as changing `typedef Callback = void Function(int);` to `typedef Callback = void Function(String);`, alters the expected type everywhere the alias is used, breaking consumers.

### MAJOR: Replace a `typedef` with a class or vice versa

Replacing a type alias with a class, or a class with a type alias of the same name, is a breaking change:

* **Function type alias $\rightarrow$ class:** In Dart, closure literals are function types, not class instances. Code assigning a closure like `Callback cb = (x) => ...;` will fail to compile against `class Callback`.
* **Class type alias $\rightarrow$ subclass:** If `typedef A = B;` is replaced with `class A extends B {}`, `B` is no longer assignable to `A`, and bidirectional type identity is lost.

---

## Constructors

### MINOR: Add a new public constructor or factory

Adding named constructors, such as `MyClass.named()`, or factories to an instantiable class provides new construction options without affecting existing callers.

### MAJOR: Remove or rename a constructor

Breaks call sites that invoked the removed constructor.

### MAJOR: Add a required parameter to a constructor

Existing constructor invocations that omit the new parameter will fail to compile.

### MINOR: Add an optional parameter to a constructor

Call sites can omit optional parameters, both positional and named.

### MAJOR: Change a `const` constructor to non-`const`

Breaks any call site using `const MyClass(...)`.

### MINOR: Change a non-`const` constructor to `const`

Adding `const` capability does not break existing non-const call sites using `MyClass(...)`.

### MAJOR: Add a private constructor to a class with only the default constructor

If a class previously had the default implicit constructor `MyClass()`, adding `MyClass._()` removes the default public constructor and prevents external instantiation or subclassing.

---

## Functions, methods, and parameters

### Parameters

#### MAJOR: Add a required positional or named parameter

Existing call sites omitting the parameter will fail to compile.

#### MINOR: Add an optional parameter

Existing call sites can omit the new optional parameter without issue.

:::note Tear-offs and optional parameters
In Dart, tearing off a method like `final fn = obj.myMethod;` produces a function whose static type reflects its exact signature. Adding an optional parameter changes the static type of the tear-off, which can cause a type mismatch if the consumer assigned it to a specific `typedef`. In practice, adding optional parameters is standard for `MINOR` releases unless a package's primary contract relies on exact function signatures.
:::

#### MAJOR: Remove any parameter

Call sites passing the removed argument will fail to compile.

#### MAJOR: Rename a named parameter

Call sites passing `func(paramName: value)` will fail to compile when `paramName` is changed.

#### MAJOR: Reorder positional parameters

Reordering positional parameters changes the expected argument positions at call sites. Even if the parameter types are identical, it causes callers to pass arguments to the wrong parameters, altering behavior or causing compile-time type errors.

#### MAJOR: Narrow a parameter type

Changing a parameter from `num` to `int` breaks callers that passed `double`.

#### Widen a parameter type

* **MINOR** for top-level functions and `final` class methods, because callers can pass a wider variety of inputs, such as widening a parameter from `Future<T>` to `FutureOr<T>` or from `int` to `num`.
* **MAJOR** for methods on an implementable class, because it changes the signature required for external overrides.

#### MINOR: Change the default value of an optional parameter

Does not break compilation or static type checks, but alters runtime behavior for callers omitting the argument.

---

### Return types

Return types in Dart are **covariant**: callers expect a return value conforming to at least the declared type, while subclasses overriding a method must return a subtype of the superclass method's return type.

#### Narrow a return type

Moving down the type lattice to a more specific subtype, such as `num` to `int`, `Object?` to `String`, `void` to a specific type, or any type to `Never`:

* **MINOR for callers of top-level functions and `final` class methods:**
  * **Direct invocations:** Callers receive a more specific type with additional available members and tighter type safety.
  * **Top types:** Changing a return type from `void` to a specific type `T` is a form of narrowing from the top type. Callers ignoring the return value continue to work, and callbacks passed to `void Function(...)` continue to compile because Dart treats `T Function(...)` as a subtype of `void Function(...)` for any type `T`.
  * **Bottom type:** For functions that unconditionally throw or exit, narrowing the return type to `Never` is backward-compatible because `Never` is a universal subtype of all Dart types.
* **MAJOR if the method is overridden in external subclasses or implementers:**
  * External subclasses that declared the previous wider return type, such as `@override num method()` or `@override void method()`, will fail to compile with an override error, because the subclass's wider return type is not a valid subtype of the new narrower return type.

#### MAJOR: Widen a return type

Moving up the type lattice to a broader supertype, such as `int` to `num`, `Future<T>` to `FutureOr<T>`, or a specific type `T` to `void`:

* **MAJOR for callers:**
  * Callers expecting specific members on the returned object, like `int` methods or `.then()` on a `Future<T>`, will fail to compile.
  * Changing a return type from a specific type `T` to `void` is a form of widening to the top type, breaking any callers attempting to read or use the returned value.
* Subclasses that already returned a narrower subtype remain valid overrides.

---

### Generics and type parameters

#### MAJOR: Add a bound to an unconstrained type parameter

Adding a type parameter constraint, such as changing `class Store<T>` to `class Store<T extends State>`, breaks existing consumers using type arguments that do not conform to the new bound, like `Store<String>`.

#### MAJOR: Tighten a type parameter bound

Changing `<T extends Object>` to `<T extends num>` breaks callers using non-number type arguments.

#### MINOR: Loosen or remove a type parameter bound

Changing `<T extends int>` to `<T extends num>` or removing a bound permits more types while remaining compatible with existing valid usages.

#### MAJOR: Add a type parameter without a default bound

Call sites or type annotations lacking the type argument may fail to compile or change type inference behavior.

---

## Enums

### MAJOR: Add a new enum value

Adding a value to an `enum` breaks exhaustive `switch` statements and pattern matches in consumer code that do not include a `default` or wildcard `_` clause.

### MAJOR: Remove or rename an enum value

Any code referencing `MyEnum.oldValue` will fail to compile.

### MAJOR: Reorder enum values

Reordering enum declarations does not cause static compilation errors, but alters each value's `.index` property at runtime. If your package or downstream users serialize enums by index, like in databases or network protocols, reordering values is a breaking runtime change.

### MINOR: Add a member to an enhanced enum

Enums cannot be extended or implemented, so adding members to an enhanced enum is safe for consumers.

---

## Extension methods and extension types

### Extension methods: `extension on`

#### MINOR: Add an extension or extension method

Adding extension methods is backward-compatible. Static ambiguity can occasionally occur if consumer code already has another extension in scope with the same method name.

#### MAJOR: Remove or rename an extension method

Call sites invoking the extension member will fail to compile.

#### MAJOR: Change the extended type: the `on` clause

Changing the target type of an extension, such as changing `extension Helpers on String` to `extension Helpers on int`, removes the extension members from instances of the original type, breaking all existing call sites.

#### MINOR: Widen the extended type

Widening the extended type, such as from `on int` to `on num`, allows the extension to be used on more types while preserving all existing call sites.

---

### Extension types: `extension type`

#### MAJOR: Change the underlying representation type

Changes the underlying type contract and implicit constructors.

#### MINOR: Add a member to an extension type

Extension types cannot be implemented or extended with subtyping, so adding members is non-breaking.

#### MAJOR: Remove or rename a member of an extension type

Breaks call sites referencing the member.

---

## Errors and exceptions

In Dart, all errors and exceptions are unchecked at compile time, meaning functions do not declare a `throws` clause in their signature. Determining the SemVer impact of changing thrown errors or exceptions depends on the distinction between [programmatic errors][effective_dart_errors] and [runtime exceptions][effective_dart_errors], as well as your documented API contract.

### Documented exceptions

When a library explicitly documents that a function or method throws a specific exception, such as `/// Throws [AuthException] on invalid credentials.`:

#### MAJOR: Change or remove a documented exception type

Changing the thrown exception, such as throwing `SecurityException` instead of `AuthException`, breaks downstream code with `try ... on AuthException catch (e)` handlers. The new exception will bypass the handler and crash at runtime.

#### MINOR: Throw a subtype of the documented exception

Throwing a more specific subtype, such as throwing `ExpiredTokenException extends AuthException`, is backward-compatible. Existing callers catching `on AuthException` continue to catch the new subtype without changes.

#### MAJOR: Throw an exception on previously succeeding inputs or states

Throwing an exception in scenarios where the function previously succeeded alters control flow and breaks working consumer code.

#### MINOR: Stop throwing an exception by succeeding instead

Handling an edge case or providing a fallback so that a function succeeds instead of throwing is backward-compatible. Existing `try-catch` blocks will simply not be triggered.

---

### Programmatic errors: `Error` subclasses

Subclasses of `Error`, such as `ArgumentError`, `StateError`, `RangeError`, and `AssertionError`, indicate a bug in the caller's code, representing contract violations or invalid arguments. Consumers should not catch `Error` types in application logic.

#### MAJOR: Throw an `ArgumentError` or `StateError` on previously valid inputs

Throwing an error for inputs or states that were previously valid and supported narrows the acceptable input domain, breaking existing callers.

#### PATCH: Add or refine `Error` checks for invalid arguments

Throwing a clear `ArgumentError` or `StateError` on invalid inputs that previously caused undefined behavior, corrupted state, or internal unhandled exceptions, such as `TypeError` or `NoSuchMethodError`, is a bug fix or hardening improvement.

#### MINOR: Support previously invalid arguments without throwing an `Error`

Expanding the acceptable input domain, such as accepting negative numbers or null values where an `ArgumentError` was previously thrown, is a backward-compatible feature addition.

---

## Dependencies and SDK constraints

### MINOR: Increase the Dart SDK constraint lower bound

Increasing the SDK constraint, such as from `sdk: ^3.5.0` to `sdk: ^3.6.0`, is standard for minor releases to adopt new language features, provided consumers on supported SDKs can resolve it.

### MINOR: Export a new dependency

Re-exporting another package's library using `export 'package:foo/foo.dart';` exposes new public API surface.

### MAJOR: Remove an exported dependency

Consumers relying on your package re-exporting those symbols will fail to compile.

### PATCH: Update dependencies within existing constraint ranges

Normal maintenance as long as your package's own public API surface is unchanged.

[effective_dart_errors]: /effective-dart/usage#error-handling
[pub_semver]: {{site.pub-pkg}}/pub_semver
[semver]: https://semver.org/spec/v2.0.0-rc.1.html
