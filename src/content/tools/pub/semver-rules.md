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

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add a new top-level declaration** (function, class, typedef, enum, extension, constant) | `Minor` | Adding new public symbols is backward-compatible. (While potential name conflicts with wildcard imports exist, SemVer treats this as non-breaking). |
| **Remove a public top-level declaration** | `Major` | Any code referencing the removed symbol will fail to compile. |
| **Rename a public top-level declaration** | `Major` | Equivalent to removing the old name and adding a new one. |
| **Move a declaration to `lib/src/` without re-exporting** | `Major` | Makes a previously public symbol private/inaccessible. |
| **Change the type of a top-level variable or constant** | `Major` | Callers expecting the old type will encounter type errors. |
| **Change a top-level variable from `final` to `var`** | `Minor` | Making a read-only variable mutable is backward-compatible for existing readers. |
| **Change a top-level variable from `var` to `final`** | `Major` | Code assigning to the variable will fail to compile. |

---

## Classes, mixins, and class modifiers

Dart 3 introduced **class modifiers** (`final`, `base`, `interface`, `sealed`,
and `mixin`), allowing package authors to explicitly define how classes can be
used by external consumers. The SemVer impact of adding or modifying members
depends heavily on these modifiers.

### Unmodified classes (`class` and `abstract class`)

By default, an unmodified class in Dart allows external packages to construct,
extend (`extends`), and implement (`implements`) it.

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add any instance method, getter, setter, or field** | `Major` | **Breaking!** Because external code could have written `class MyImpl implements Foo`, any new member in `Foo` causes existing implementations to fail compilation due to missing overrides. |
| **Remove or rename an instance member** | `Major` | Existing callers and subclasses will fail. |
| **Add a static member** | `Minor` | Static members are namespaced to the class and do not affect implementations or subclasses. |
| **Remove a static member** | `Major` | Breaks call sites referencing `Class.member`. |

### `final class` and `abstract final class`

A `final` class cannot be extended, implemented, or mixed in outside of the
defining library. Consumers can only construct it (if not abstract) and call its
members.

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add an instance method, getter, setter, or field** | `Minor` | **Non-breaking!** Since no external code can `implement` or `extend` a `final` class, adding new members is safe for consumers. |
| **Remove or rename an instance member** | `Major` | Existing callers will break. |

### `base class`

A `base` class can be extended (`extends`) outside the library, but cannot be
implemented (`implements`).

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add a concrete instance method, getter, or field** | `Minor` | **Non-breaking!** External subclasses inherit the new default implementation automatically without needing to override it. |
| **Add an abstract method or getter** | `Major` | Existing subclasses will fail to compile because they do not implement the new abstract member. |
| **Remove or rename an instance member** | `Major` | Breaks callers and subclasses. |

### `interface class` and `abstract interface class`

An `interface` class can be implemented (`implements`) outside the library, but
cannot be extended (`extends`).

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add any method, getter, setter, or field** | `Major` | **Breaking!** External implementers will be missing the required implementation. |
| **Remove or rename an instance member** | `Major` | Breaks callers and implementers. |

### `sealed class`

A `sealed` class is implicitly abstract and cannot be extended, implemented, or
mixed in outside the library. It is designed for exhaustive pattern matching.

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add a new direct subtype to a sealed family** | `Major` | **Breaking!** Any external exhaustive `switch` expression or statement on the sealed class will fail to compile due to missing cases. |
| **Add a member to the sealed class** | `Minor` | Non-breaking because external code cannot implement or extend it. |

### `mixin` and `mixin class`

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add a concrete method or field to a `mixin`** | `Minor`* | Non-breaking for consumers using `with Mixin`. (*Note: technically breaking if a consumer used `implements Mixin`). |
| **Add an abstract member to a `mixin`** | `Major` | Requires all applications of the mixin to provide an implementation. |
| **Add or change the `on` type constraint** | `Major` | Tightening the `on` constraint restricts where the mixin can be applied. |

---

## Constructors

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add a new public named constructor or factory** | `Minor` | Adding new ways to instantiate a class is backward-compatible. |
| **Remove or rename a constructor** | `Major` | Breaks code calling `MyClass.named()`. |
| **Add a required positional or named parameter** | `Major` | Existing construction sites will fail to compile. |
| **Add an optional positional or named parameter** | `Minor` | Existing construction sites continue to work. |
| **Change a `const` constructor to non-`const`** | `Major` | Breaks call sites using `const MyClass(...)`. |
| **Change a non-`const` constructor to `const`** | `Minor` | Backward-compatible; existing non-const call sites continue to work. |
| **Add a private constructor `Class._()` to a class with only default constructor** | `Major` | Prevents external instantiation or subclassing if no other public constructors exist. |

---

## Functions, methods, and parameters

### Parameters

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add a required positional parameter** | `Major` | Existing call sites without the argument will fail to compile. |
| **Add a required named parameter** | `Major` | Existing call sites without the named argument will fail to compile. |
| **Add an optional positional parameter** | `Minor`* | Callers can omit it. (*Note: technically breaking if the function was torn off and assigned to an exact function type). |
| **Add an optional named parameter** | `Minor`* | Callers can omit it. (*Note: see tear-off nuance below). |
| **Remove any parameter (required or optional)** | `Major` | Breaks call sites passing that argument. |
| **Rename a named parameter** | `Major` | Breaks call sites passing the argument by name (`foo: value`). |
| **Change a parameter type to a more specific type (subtype)** | `Major` | Narrowing accepted types (e.g. from `num` to `int`) breaks callers passing other valid inputs (e.g. `double`). |
| **Change a parameter type to a more general type (supertype)** | `Minor` / `Major` | **Minor** for callers (accepts more inputs), but **Major** if the method belongs to an interface/class that external code implements or overrides. |
| **Change the default value of an optional parameter** | `Patch` / `Minor` | Behavioral change; does not break compilation, but callers relying on previous default behavior may be affected. |

:::note Tear-offs and optional parameters
In Dart, tearing off a method (e.g. `final fn = obj.myMethod;`) produces a
function whose static type reflects its exact signature. Adding an optional
parameter changes the static type of the tear-off, which can cause a type
mismatch if the consumer assigned it to a specific `typedef`. In practice,
adding optional parameters is standard for `Minor` releases unless a package's
primary contract relies on specific function signatures.
:::

### Return types

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Change return type to a more specific type (subtype)** | `Minor` / `Major` | **Minor** for callers (e.g. `num` to `int` is covariant and safe for callers), but **Major** if the method is overridden in external subclasses or implementers. |
| **Change return type to a more general type (supertype)** | `Major` | Breaks callers expecting the narrower type (e.g. changing `int` to `num`). |
| **Change return type from `void` to a specific type** | `Minor` | Callers ignoring the return value continue to work. |
| **Change return type from a specific type to `void`** | `Major` | Callers using the return value will fail to compile. |

### Generics and type parameters

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add a type parameter with no default / bound** | `Major` | Existing call sites or type annotations lacking the type argument may fail or change behavior. |
| **Tighten a type parameter bound** (e.g. `<T>` to `<T extends num>`) | `Major` | Callers using type arguments outside the new bound will fail. |
| **Loosen a type parameter bound** (e.g. `<T extends int>` to `<T extends num>`) | `Minor` | Permits a wider range of types without breaking existing valid arguments. |

---

## Enums

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add a new enum value** | `Major` | **Breaking!** Exhaustive `switch` statements and pattern matches on the enum without a `default` or wildcard `_` case will fail to compile. |
| **Remove or rename an enum value** | `Major` | Any code referencing `MyEnum.oldValue` will break. |
| **Add a method, getter, or field to an enhanced enum** | `Minor` | Enums cannot be extended or implemented, so adding members is safe. |

---

## Extensions and extension types

### Extension methods (`extension on ...`)

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Add a new extension or extension method** | `Minor` | Non-breaking. (In rare cases, can introduce ambiguity if a consumer has another extension with the same name in scope). |
| **Remove or rename an extension method** | `Major` | Call sites using the extension member will fail. |

### Extension types (`extension type ...`)

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Change the underlying representation type** | `Major` | Breaks all type conversions and compatibility with the underlying representation. |
| **Add a method, getter, or setter** | `Minor` | Extension types cannot be implemented or extended with subtyping, so adding members is non-breaking. |
| **Remove or rename a member** | `Major` | Breaks callers referencing the member. |

---

## Dependencies and SDK constraints

| Change | SemVer Bump | Notes |
| :--- | :--- | :--- |
| **Increase the Dart SDK constraint lower bound** | `Minor` | Safe for a minor release if within the current major Dart SDK line, provided your users have access to that SDK version. |
| **Export a new dependency** (`export 'package:foo/foo.dart'`) | `Minor` | Adds new public API surface to your package. |
| **Remove an exported dependency** | `Major` | Breaks consumers relying on your package re-exporting those symbols. |
| **Update dependencies within existing constraint ranges** | `Patch` / `Minor` | Normal maintenance as long as your package's own public API is unchanged. |

---

## Summary quick reference

| Change | SemVer Bump |
| :--- | :--- |
| Add new top-level class, function, enum, or extension | **Minor** |
| Remove or rename any public top-level declaration | **Major** |
| Add member to unmodified `class` or `abstract class` | **Major** |
| Add member to `final class` or `sealed class` | **Minor** |
| Add concrete member to `base class` | **Minor** |
| Add abstract member to `base class` | **Major** |
| Add member to `interface class` | **Major** |
| Add new subtype to `sealed class` | **Major** |
| Add required parameter to function, method, or constructor | **Major** |
| Add optional parameter to function, method, or constructor | **Minor** |
| Rename named parameter | **Major** |
| Add value to an `enum` | **Major** |
| Remove or rename `enum` value | **Major** |
| Change `const` constructor to non-`const` | **Major** |
| Tighten type bounds or parameter types | **Major** |

[semver]: https://semver.org/spec/v2.0.0-rc.1.html
