---
title: Glossary
description: A glossary reference for terminology used across dart.dev.
---

The following are definitions of terms used across the Dart documentation.

## Constant context

A _constant context_ is a region of code in which it isn't necessary to include
the `const` keyword because it's implied by the fact that everything in that
region is required to be a constant. The following locations are constant
contexts:

* Everything inside a list, map or set literal that's prefixed by the
  `const` keyword. Example:

  ```dart
  var l = const [/*constant context*/];
  ```

* The arguments inside an invocation of a constant constructor. Example:

  ```dart
  var p = const Point(/*constant context*/);
  ```

* The initializer for a variable that's prefixed by the `const` keyword.
  Example:

  ```dart
  const v = /*constant context*/;
  ```

* Annotations

* The expression in a `case` clause. Example:

  ```dart
  void f(int e) {
    switch (e) {
      case /*constant context*/:
        break;
    }
  }
  ```

## Definite assignment

Definite assignment analysis is the process of determining, for each local
variable at each point in the code, which of the following is true:
- The variable has definitely been assigned a value (_definitely assigned_).
- The variable has definitely not been assigned a value (_definitely
  unassigned_).
- The variable might or might not have been assigned a value, depending on the
  execution path taken to arrive at that point.

Definite assignment analysis helps find problems in code, such as places where a
variable that might not have been assigned a value is being referenced, or
places where a variable that can only be assigned a value one time is being
assigned after it might already have been assigned a value.

For example, in the following code the variable `s` is definitely unassigned
when it's passed as an argument to `print`:

```dart
void f() {
  String s;
  print(s);
}
```

But in the following code, the variable `s` is definitely assigned:

```dart
void f(String name) {
  String s = 'Hello $name!';
  print(s);
}
```

Definite assignment analysis can even tell whether a variable is definitely
assigned (or unassigned) when there are multiple possible execution paths. In
the following code the `print` function is called if execution goes through
either the true or the false branch of the `if` statement, but because `s` is
assigned no matter which branch is taken, it's definitely assigned before it's
passed to `print`:

```dart
void f(String name, bool casual) {
  String s;
  if (casual) {
    s = 'Hi $name!';
  } else {
    s = 'Hello $name!';
  }
  print(s);
}
```

In flow analysis, the end of the `if` statement is referred to as a _join_—a
place where two or more execution paths merge back together. Where there's a
join, the analysis says that a variable is definitely assigned if it's
definitely assigned along all of the paths that are merging, and definitely
unassigned if it's definitely unassigned along all of the paths.

Sometimes a variable is assigned a value on one path but not on another, in
which case the variable might or might not have been assigned a value. In the
following example, the true branch of the `if` statement might or might not be
executed, so the variable might or might be assigned a value:

```dart
void f(String name, bool casual) {
  String s;
  if (casual) {
    s = 'Hi $name!';
  }
  print(s);
}
```

The same is true if there is a false branch that doesn't assign a value to `s`.

The analysis of loops is a little more complicated, but it follows the same
basic reasoning. For example, the condition in a `while` loop is always
executed, but the body might or might not be. So just like an `if` statement,
there's a join at the end of the `while` statement between the path in which the
condition is `true` and the path in which the condition is `false`.

For additional details, see the
[specification of definite assignment][definiteAssignmentSpec].

[definiteAssignmentSpec]: https://github.com/dart-lang/language/blob/main/resources/type-system/flow-analysis.md

## Irrefutable pattern

_Irrefutable patterns_ are patterns that always match. 
Irrefutable patterns are the only patterns that can appear in
_irrefutable contexts_: the [_declaration_][] and [_assignment_][] 
pattern contexts.

[_declaration_]: /language/patterns#variable-declaration 
[_assignment_]: /language/patterns#variable-assignment

## Mixin application

A _mixin application_ is the class created when a mixin is applied to a class.
For example, consider the following declarations:

```dart
class A {}

mixin M {}

class B extends A with M {}
```

The class `B` is a subclass of the mixin application of `M` to `A`, sometimes
nomenclated as `A+M`. The class `A+M` is a subclass of `A` and has members that
are copied from `M`.

You can give an actual name to a mixin application by defining it as:

```dart
class A {}

mixin M {}

class A_M = A with M;
```

Given this declaration of `A_M`, the following declaration of `B` is equivalent
to the declaration of `B` in the original example:

```dart
class B extends A_M {}
```

## Override inference

Override inference is the process by which any missing types in a method
declaration are inferred based on the corresponding types from the method or
methods that it overrides.

If a candidate method (the method that's missing type information) overrides a
single inherited method, then the corresponding types from the overridden method
are inferred. For example, consider the following code:

```dart
class A {
  int m(String s) => 0;
}

class B extends A {
  @override
  m(s) => 1;
}
```

The declaration of `m` in `B` is a candidate because it's missing both the
return type and the parameter type. Because it overrides a single method (the
method `m` in `A`), the types from the overridden method will be used to infer
the missing types and it will be as if the method in `B` had been declared as
`int m(String s) => 1;`.

If a candidate method overrides multiple methods, and the function type one of
those overridden methods, M<sub>s</sub>, is a supertype of the function types of
all of the other overridden methods, then M<sub>s</sub> is used to infer the
missing types. For example, consider the following code:

```dart
class A {
  int m(num n) => 0;
}

class B {
  num m(int i) => 0;
}

class C implements A, B {
  @override
  m(n) => 1;
}
```

The declaration of `m` in `C` is a candidate for override inference because it's
missing both the return type and the parameter type. It overrides both `m` in
`A` and `m` in `B`, so we need to choose one of them from which the missing
types can be inferred. But because the function type of `m` in `A`
(`int Function(num)`) is a supertype of the function type of `m` in `B`
(`num Function(int)`), the function in `A` is used to infer the missing types.
The result is the same as declaring the method in `C` as `int m(num n) => 1;`.

It is an error if none of the overridden methods has a function type that is a
supertype of all the other overridden methods.

## Part file

A part file is a Dart source file that contains a `part of` directive.
For usage guidance, visit the [Effective Dart][part] entry.

[part]: /effective-dart/usage#do-use-strings-in-part-of-directives

## Potentially non-nullable

A type is _potentially non-nullable_ if it's either explicitly non-nullable or
if it's a type parameter.

A type is explicitly non-nullable if it is a type name that isn't followed by a
question mark. Note that there are a few types that are always nullable, such as
`Null` and `dynamic`, and that `FutureOr` is only non-nullable if it isn't
followed by a question mark _and_ the type argument is non-nullable (such as
`FutureOr<String>`).

Type parameters are potentially non-nullable because the actual runtime type
(the type specified as a type argument) might be non-nullable. For example,
given a declaration of `class C<T> {}`, the type `C` could be used with a
non-nullable type argument as in `C<int>`.

## Public library

A public library is a library that is located inside the package's `lib`
directory but not inside the `lib/src` directory.

## Refutable pattern

A _refutable pattern_ is a pattern that can be tested against a value to
determine if the pattern matches the value. 
If not, the pattern _refutes_, or denies, the match.
Refutable patterns appear in [_matching contexts_][].

[_matching contexts_]: /language/patterns#matching
