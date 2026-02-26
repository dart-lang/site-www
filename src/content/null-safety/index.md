---
title: Sound null safety
breadcrumb: Null safety
description: An introduction to null safety in Dart.
---

The Dart language enforces sound null safety,
making it impossible to unintentionally access a member on a `null` value.

In Dart, types are non-nullable by default.
Variables of non-nullable types must be initialized
and can only be assigned non-null values.

The Dart analyzer and compilers catch unsafe usage
of potentially `null` values at edit time,
turning what would be **runtime errors** in other languages
into **analysis errors** you can fix before deploying.

<a id="creating-variables" aria-hidden="true"></a>
<a id="introduction-through-examples" aria-hidden="true"></a>

## Examples

None of the variables in the following code can be `null`:

```dart
// None of these can ever be null.
var i = 42; // Inferred to be an int.
String name = getFileName();
final b = Foo();
```

To indicate that a variable can have the value `null`,
add `?` to its type declaration:

```dart
int? aNullableInt = null;
```

- For interactive examples, try the [Dart cheatsheet][].
- To learn more about null safety, check out
  [Understanding null safety][].

[Dart cheatsheet]: /resources/dart-cheatsheet
[Understanding null safety]: /null-safety/understanding-null-safety

## Null safety principles

Null safety in Dart is built on two core design principles:

**Non-nullable by default**
: Unless you explicitly tell Dart that a variable can be null,
  it's considered non-nullable.
  This default was chosen after research found that
  non-null was by far the most common choice in APIs.

**Fully sound**
: If the type system determines that
  a variable or expression has a non-nullable type,
  it's guaranteed that it can never evaluate to `null` at runtime.

Together, these principles result in
fewer bugs, smaller binaries, and faster execution.

<a id="dart-3-and-null-safety" aria-hidden="true"></a>
<a id="enable-null-safety" aria-hidden="true"></a>
<a id="where-to-learn-more" aria-hidden="true"></a>

## Historical migration resources {:#migrate}

Dart has enforced sound null safety since Dart 3, released in May 2023.
If you still need to migrate your apps or packages to null safety,
check out the archived documentation in the
[`dart-community/migrate-to-null-safety`][] repository.

[`dart-community/migrate-to-null-safety`]: https://github.com/dart-community/migrate-to-null-safety#migrate-to-dart-null-safety
