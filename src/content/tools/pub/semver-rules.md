---
title: SemVer compatibility and breaking changes
breadcrumb: SemVer rules
description: >-
  A comprehensive guide to what changes are breaking (major), non-breaking
  features (minor), or bug fixes (patch) in Dart packages.
---

When developing and publishing Dart packages, adhering to
[Semantic Versioning (SemVer)][semver] is essential for maintaining a healthy
and predictable package ecosystem.

This guide provides a detailed reference on how various changes to your Dart
code affect the public API surface of your package and what version bump
(`major`, `minor`, or `patch`) is required.

:::tip
For a conceptual overview of pub's version solving algorithm and lockfiles,
see the [Package versioning](/tools/pub/versioning) guide.
:::

## The public API boundary

In Dart packages, the **public API** comprises all declarations accessible to
consumers of your package:

* **Public:** Any library directly inside `lib/` (e.g., `lib/my_package.dart`)
  and any declarations re-exported through `export` directives.
* **Private / Internal:** Any file inside `lib/src/` that is **not**
  re-exported by a public library in `lib/`. Changes to unexported files in
  `lib/src/` are considered internal and do not affect the public SemVer contract.

---

## Top-level declarations

### Add a new top-level declaration `[minor]`

Adding a new public top-level function, class, typedef, enum, extension, or constant is backward-compatible. Existing consumer code will continue to compile and function as before.

```dart
// Added to lib/my_package.dart in a minor release:
void newHelperFunction() {}
```

*Note:* While introducing a new top-level name can theoretically create a naming conflict with a wildcard import (`import 'package:foo/foo.dart';`) in downstream code, SemVer treats top-level additions as non-breaking.

### Remove a public top-level declaration `[major]`

Removing any public top-level declaration is a breaking change. Any downstream code referencing the removed symbol will fail to compile.

### Rename a public top-level declaration `[major]`

Renaming a public symbol is functionally equivalent to removing the original name and introducing a new one. Downstream code referencing the original name will break.

### Move a declaration to `lib/src/` without re-exporting `[major]`

Moving a declaration from the public `lib/` root to `lib/src/` (without an `export` in a public library file) makes it inaccessible to external packages, breaking all existing consumers.

### Change the type of a top-level variable or constant `[major]`

Changing the static type of a top-level variable or constant causes type errors for any callers expecting the previous type.

### Change a top-level variable from `final` to `var` `[minor]`

Allowing reassignment of a previously read-only top-level variable is backward-compatible for existing readers.

### Change a top-level variable from `var` to `final` `[major]`

Making a mutable variable `final` breaks any consumer assigning values to that variable.

---

## Classes, mixins, and class modifiers

Dart 3 introduced **class modifiers** (`final`, `base`, `interface`, `sealed`, and `mixin`), allowing package authors to explicitly define how classes can be used by external consumers. The SemVer impact of adding or modifying members depends heavily on these modifiers.

### Unmodified classes (`class` and `abstract class`)

By default, an unmodified class in Dart allows external packages to construct, extend (`extends`), and implement (`implements`) it.

#### Add an instance member to an unmodified class `[major]`

Adding any instance method, getter, setter, or field to an unmodified `class` or `abstract class` is a breaking change. Because external libraries are permitted to write `class MyImpl implements Foo`, any new member in `Foo` breaks existing implementers due to missing overrides.

```dart
// In package:foo (v1.0.0)
class HttpClient {
  void get(String url) {}
}

// In package:foo (v1.1.0) - BREAKING for implementers!
class HttpClient {
  void get(String url) {}
  void post(String url, Object body) {} // External `implements HttpClient` fails!
}
```

#### Remove or rename an instance member `[major]`

Removing or renaming an instance method, getter, setter, or field breaks all callers, extenders, and implementers.

#### Add a static member to a class `[minor]`

Static members are namespaced to the class (`Class.member`) and do not affect subclasses or external implementations.

#### Remove or rename a static member `[major]`

Breaks call sites referencing `Class.staticMember`.

---

### `final class` and `abstract final class`

A `final` class cannot be extended, implemented, or mixed in outside of the defining library. Consumers can only construct it (if not abstract) and call its members.

#### Add an instance member to a final class `[minor]`

Since external code cannot `extend` or `implement` a `final class`, adding new instance methods, getters, setters, or fields is completely backward-compatible. Consumers only call existing members and cannot be broken by added members.

```dart
// Non-breaking in a final class:
final class Config {
  final String host;
  final int port;
  Config(this.host, this.port);

  // Safe to add in a minor release:
  bool get isSecure => port == 443;
}
```

#### Remove or rename an instance member of a final class `[major]`

Existing callers referencing the removed member will fail to compile.

---

### `base class`

A `base` class can be extended (`extends`) outside the library, but cannot be implemented (`implements`).

#### Add a concrete instance member to a base class `[minor]`

Because external libraries can only `extend` (not `implement`) a `base class`, subclasses automatically inherit the new default implementation without needing to override it.

#### Add an abstract member to a base class `[major]`

Subclasses in external libraries will fail to compile because they do not provide an implementation for the new abstract member.

#### Remove or rename an instance member of a base class `[major]`

Breaks both callers and extending subclasses.

---

### `interface class` and `abstract interface class`

An `interface` class can be implemented (`implements`) outside the library, but cannot be extended (`extends`).

#### Add any member to an interface class `[major]`

External classes can `implement` an `interface class`. Adding any new method, getter, setter, or field requires implementers to provide the new member, breaking compilation.

#### Remove or rename an instance member of an interface class `[major]`

Breaks callers and implementers.

---

### `sealed class`

A `sealed` class is implicitly abstract and cannot be extended, implemented, or mixed in outside the library. It is designed for exhaustive pattern matching.

#### Add a direct subtype to a sealed class family `[major]`

Adding a new subclass to a `sealed` class is a breaking change because exhaustive `switch` statements or pattern matches in consumer code that do not have a wildcard (`_`) or `default` case will fail to compile.

```dart
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

#### Add a member to a sealed class `[minor]`

External code cannot implement or extend a `sealed` class, so adding instance or static members is non-breaking.

---

### `mixin` and `mixin class`

#### Add a concrete member to a mixin `[minor]`

Classes using `with MyMixin` automatically receive the concrete implementation.

*Note:* Adding a member is technically breaking if an external consumer used `implements MyMixin`, but the standard and intended usage of mixins is with `with`.

#### Add an abstract member to a mixin `[major]`

Requires all classes applying the mixin to supply an implementation for the new abstract member.

#### Tighten the `on` constraint on a mixin `[major]`

Restricting the superclass requirements (for example, from `on Object` to `on Widget`) prevents existing classes that do not meet the new requirement from mixing it in.

---

## Constructors

### Add a new public constructor or factory `[minor]`

Adding named constructors (`MyClass.named()`) or factories to an instantiable class provides new construction options without affecting existing callers.

### Remove or rename a constructor `[major]`

Breaks call sites that invoked the removed constructor.

### Add a required parameter to a constructor `[major]`

Existing constructor invocations that omit the new parameter will fail to compile.

### Add an optional parameter to a constructor `[minor]`

Call sites can omit optional parameters (both positional and named).

### Change a `const` constructor to non-`const` `[major]`

Breaks any call site using `const MyClass(...)`.

### Change a non-`const` constructor to `const` `[minor]`

Adding `const` capability does not break existing non-const call sites (`MyClass(...)`).

### Add a private constructor to a class with only the default constructor `[major]`

If a class previously had the default implicit constructor `MyClass()`, adding `MyClass._()` removes the default public constructor and prevents external instantiation or subclassing.

---

## Functions, methods, and parameters

### Parameters

#### Add a required positional or named parameter `[major]`

Existing call sites omitting the parameter will fail to compile.

#### Add an optional parameter (positional or named) `[minor]`

Existing call sites can omit the new optional parameter without issue.

:::note Tear-offs and optional parameters
In Dart, tearing off a method (`final fn = obj.myMethod;`) produces a function whose static type reflects its exact signature. Adding an optional parameter changes the static type of the tear-off, which can cause a type mismatch if the consumer assigned it to a specific `typedef`. In practice, adding optional parameters is standard for `Minor` releases unless a package's primary contract relies on exact function signatures.
:::

#### Remove any parameter `[major]`

Call sites passing the removed argument will fail to compile.

#### Rename a named parameter `[major]`

Call sites passing `func(paramName: value)` will fail to compile when `paramName` is changed.

#### Narrow a parameter type (more specific / subtype) `[major]`

Changing a parameter from `num` to `int` breaks callers that passed `double`.

#### Widen a parameter type (more general / supertype) `[minor / major]`

* **Minor** for top-level functions and `final` class methods, because callers can pass a wider variety of inputs.
* **Major** for methods on an implementable class, because it changes the signature required for external overrides.

#### Change the default value of an optional parameter `[patch / minor]`

Does not break compilation or static type checks, but alters runtime behavior for callers omitting the argument.

---

### Return types

#### Narrow a return type (more specific / subtype) `[minor / major]`

* **Minor** for callers of top-level functions and `final` class methods (for example, returning `int` instead of `num` is covariant and safe for callers).
* **Major** if the method is overridden in external subclasses or implementers.

#### Widen a return type (more general / supertype) `[major]`

Changing a return type from `int` to `num` breaks callers expecting `int` methods and properties on the returned object.

#### Change return type from `void` to a specific type `[minor]`

Existing callers ignoring the return value continue to work.

#### Change return type from a specific type to `void` `[major]`

Callers using the return value will fail to compile.

---

### Generics and type parameters

#### Add a type parameter without a default bound `[major]`

Call sites or type annotations lacking the type argument may fail to compile or change type inference behavior.

#### Tighten a type parameter bound `[major]`

Changing `<T extends Object>` to `<T extends num>` breaks callers using non-number type arguments.

#### Loosen a type parameter bound `[minor]`

Changing `<T extends int>` to `<T extends num>` permits more types while remaining compatible with existing valid usages.

---

## Enums

### Add a new enum value `[major]`

Adding a value to an `enum` breaks exhaustive `switch` statements and pattern matches in consumer code that do not include a `default` or wildcard `_` clause.

### Remove or rename an enum value `[major]`

Any code referencing `MyEnum.oldValue` will fail to compile.

### Add a member to an enhanced enum `[minor]`

Enums cannot be extended or implemented, so adding members to an enhanced enum is safe for consumers.

---

## Extension methods and extension types

### Extension methods (`extension on ...`)

#### Add an extension or extension method `[minor]`

Adding extension methods is backward-compatible. (In rare cases, static ambiguity can occur if consumer code has another extension with the same method name in scope).

#### Remove or rename an extension method `[major]`

Call sites invoking the extension member will fail to compile.

---

### Extension types (`extension type ...`)

#### Change the underlying representation type `[major]`

Changes the underlying type contract and implicit constructors.

#### Add a member to an extension type `[minor]`

Extension types cannot be implemented or extended with subtyping, so adding members is non-breaking.

#### Remove or rename a member of an extension type `[major]`

Breaks call sites referencing the member.

---

## Dependencies and SDK constraints

### Increase the Dart SDK constraint lower bound `[minor]`

Increasing the SDK constraint (for example, `sdk: ^3.5.0` to `sdk: ^3.6.0`) is standard for minor releases to adopt new language features, provided consumers on supported SDKs can resolve it.

### Export a new dependency `[minor]`

Re-exporting another package's library (`export 'package:foo/foo.dart';`) exposes new public API surface.

### Remove an exported dependency `[major]`

Consumers relying on your package re-exporting those symbols will fail to compile.

### Update dependencies within existing constraint ranges `[patch / minor]`

Normal maintenance as long as your package's own public API surface is unchanged.

[semver]: https://semver.org/spec/v2.0.0-rc.1.html
