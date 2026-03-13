---
title: "Dart declaration-site variance"
description: "A deep dive into an experimental feature"
publishDate: 2019-12-19
author: kallentu
image: images/0XcEdm2vmIBW8Wovr.png
category: other
tags:
  - programming
  - variance
  - programming-languages
  - dartlang
layout: blog
---


<DashImage src="images/0XcEdm2vmIBW8Wovr.png" />


Declaration-site variance was my internship project on the Dart team, and I’ve documented my personal experience on the team in the article [Life as a Dart intern](https://medium.com/dartlang/life-as-a-dart-intern-a62cb8db2414). As the primary implementer of the [declaration-site variance feature](https://github.com/dart-lang/language/issues/524), I want to share the usages and benefits of sound variance.

We’ll discuss how to use variance, why we want to use the modifiers, how the feature can build on top of classes that don’t use the modifiers, and what benefits this feature provides us.

***Note:** The implementation of variance isn’t finished yet. Although you can play with it by enabling the experiment (instructions below), the feature might change before it’s finalized.*

Before diving into Dart’s declaration-site variance feature, we’ll take a quick detour to discuss what variance means and how it’s used.

## **What is variance?**

To briefly introduce variance, we can look at this example:

```dart
main() {
  Iterable<Object> objectIterable = <int>[1, 2, 3];
}
```

From this, an `Iterable` of integers can be substituted as an `Iterable` of `Object`s because an integer *is* an `Object` and can be used in an `Iterable` in every place an `Object` would be. The language allows this by saying that two instantiations of the same generic type (like `Iterable&lt;int&gt;` and `Iterable&lt;Object&gt;` here) are considered subtypes if their type arguments (`int` and `Object`) are. This subtyping relation is considered **covariance**.

This is convenient and logical. It makes sense, that is, until you take a look at the variance of the parameters of a method. Say you want to make a `objectWriter` in Dart:

```dart
class Writer<T> {
  void write(T x) => print(x);
}

main() {
  Writer<Object> objectWriter = Writer<int>();
  objectWriter.write(2);
}
```

Then you eagerly have your `objectWriter` write a `String` to discover that it produces a runtime error. The compiler allows this code, but when you run it, it throws an exception.

```dart
main() {
  // ...
  // Runtime error!
  // Unhandled exception: type 'String' is not a subtype of type 'int' of 'x'
  objectWriter.write("Hello world!");
}
```

Why is this? With **contravariance,** the subtyping relation is reversed compared to covariance. We need to be able to *write* any `Object` to the `objectWriter`, but from earlier we know that the `objectWriter` is actually a disguised writer of integers.

The final variant type you will need to know about is **invariance**. Invariant subtyping relation means no subtype relation between two invariant types unless they are the *exact same* type.

```dart
class ReaderWriter<T> {
  void write(T x) => print(x);
  T read() => null;
}

main() {
  ReaderWriter<int> intRW = ReaderWriter<Object>();
  
  // Any object can be returned, not just integers. This is unsafe.
  intRW.read(); 

  ReaderWriter<Object> anotherObjectRW = ReaderWriter<int>();
  
  // We actually have an integer ReaderWriter. Error!
  anotherObjectRW.write(“Hello world!”); 
}
```

## **What is the variance feature in Dart?**

Since the Dart team proposed to add explicit variance modifiers to the language, we’ll preview some of the changes to expect.

Dart will have variance modifiers that can be applied to type parameters in classes and mixins. The syntax is similar to variance modifiers in C#.

You can use the keywords `out`, `in`*,* and `inout`to declare a covariant, contravariant, and invariant type parameter respectively. This is used with generic types as such:

```dart
class MyContravariantClass<in T> {}
mixin MyInvariantMixin<inout T> {}
```

## **Why define explicit variance for generic types? Why do we want this feature?**

Dart’s static type system currently treats all type parameters as covariant. That’s correct and convenient for generics where the type is used in a safely covariant place like a return type. But it’s wrong when the type argument should be contravariant or invariant:

```dart
class Writer<T> {
  void write(T x) => print(x);
}

main() {
  Writer<Object> objectWriter = Writer<int>();
  objectWriter.write(“I’m a string!”);
}
```

When you use `objectWriter`, you *expect* to be able to write any `Object`. Unfortunately, the `objectWriter` only writes integers. The compiler doesn’t know any better and when you run the code, you receive the dreaded runtime error. To avoid unsoundness, Dart throws an error at runtime if you use a type argument in an unsafe way.

Fortunately, adding a variance modifier turns this incorrect use from a runtime error into a compile-time error.

```dart
// Add a contravariant variance modifier
class Writer<in T> {  
  void write(T x) => print(x);
}

main() {
  // Compile-time error: The constructor returns type 'Writer<int>'
  // that isn't of expected type 'Writer<Object>'.
  Writer<Object> objectWriter = Writer<int>();
}
```

This is much better. Long before you write `objectWriter.write("I'm a string!")`, the compiler will notify you that there’s something wrong.

Now, let’s take a look at what adding safely typed parameters using a variance modifier provides you.

## **Type parameters in members**

If you mark a generic type parameter with `out`, the compiler emits a static error if you use that type in a method or field in a place that isn’t safely covariant like a return type. Likewise, a type parameter marked `in` can only be used in a place that is safely contravariant like a method parameter type. Type parameters marked `inout` can be used anywhere.

Here are some method variance position errors and correct usages that you may find helpful. The same error checking also occurs for mixins.

```dart
class Reader<out T> {
  // Compile-time error: Can't use 'out' type variable 'T' in an 'in' position.
  void write(T x) => print(x);

  // OK
  T read() => null;
}

class Writer<in T> {
  // Compile-time error: Can't use 'in' type variable 'T' in an 'out' position
  // in the return type.
  T read() => null;

  // OK
  void write(T x) => print(x); 
}

class ReaderWriter<inout T> {
  // Both OK
  void write(T value) => print(x);
  T read() => null;
}
```

Errors can be emitted in fields as well.

```dart
class Reader<out T> {
  // Compile-time error: Can't use 'out' type variable 'T' in an 'in' position.
  T readableWritableValue;
  
  // OK
  final T readableValue; 
}

class Writer<in T> {
  // Compile-time error: Can't use 'in' type variable 'T' in an 'out' position.
  T readableWritableValue;
  
  // Compile-time error: Can't use 'in' type variable 'T' in an 'out' position.
  final T readableValue;
}

class ReaderWriter<inout T> {
  // Both OK
  T readableWritableValue;
  final T readableValue; 
}
```

## **Assignment and subtyping**

The errors the compiler reports for misusing type parameters help the generic class author **write** correct code. The other half is the set of errors that help others **use** the class correctly. One of the changes that come with sound variance modifiers is the subtyping change that we can see through assignment.

If a generic type parameter is covariant, then you can assign it when its type argument is a subtype of the expected type’s type argument. For example, you can assign a `Reader&lt;int&gt;` to something that expects a `Reader&lt;Object&gt;`.

```dart
class Reader<out T> { /* ... */ }
main() {
  Reader<Object> objectReader = Reader<int>();
}
```

Likewise, if a generic type parameter is contravariant, assignment is allowed when its type argument is a supertype of the expected type’s type argument. You can assign a `Writer&lt;Object&gt;` to something that expects a `Writer&lt;int&gt;`, as such:

```dart
class Writer<in T> { /* ... */ }
main() {
  Writer<int> intWriter = Writer<Object>();
}
```

For invariant parameters, the type argument must be the same type.

```dart
class ReaderWriter<inout T> { /* ... */ }
main() {
  ReaderWriter<int> intReader = ReaderWriter<int>();
}
```

## **Interface inheritance**

So you might be asking, “*Can we opt into stronger compile time checking with variance even when extending older classes?”* The good news is that you can; however, there are a few restrictions.

`out` parameters can only extend parameter positions that are covariant or have default Dart type variance.

Keep in mind that any methods inherited from legacy classes could still be unsoundly variant, and hence may still cause runtime errors. Otherwise, all new methods in a subclass with type parameters that have variance modifiers will emit errors if the types are in unsound positions.

```dart
class LegacyReader<T> {}
class NewReader<out T> extends LegacyReader<T> {} // OK

class Reader<out T> {}
class IntegerReader<out T> extends Reader<T> {} // OK
```

`in` parameters can only extend parameter positions that are contravariant.

```dart
class Writer<in T> {}
class StringWriter<in T> extends Writer<T> {} // OK
```

`inout` parameters can extend all parameter positions. However, a parameter that is defined as `inout` can only be inherited by other invariant positions.

```dart
class ReaderWriter<inout T> {}
class NewReaderWriter<inout T> extends LegacyReader<T> {} // OK
class IntegerReaderWriter<inout T> extends Reader<T> {} // OK
class StringReaderWriter<inout T> extends Writer<T> {} // OK
```

## How can I give feedback on the variance feature?

We recommend trying the variance feature using the [latest dev channel](https://dart.dev/get-dart#about-release-channels-and-version-strings). Play around with this example to get a grasp on how variance works and what it can do for you.

```dart
class Writer<in T> {
  void write(T value) => print(value);
}

class Reader<out T> {
  final T value;
  Reader(this.value);
  T read() => value;
}

main() {
  Writer<int> intWriter = Writer<Object>();
  intWriter.write(2);

  Reader<Object> objectReader =
    Reader<String>("Wow, this is soundly variant!");
  print(objectReader.value);
}
```

Because the variance feature is still being implemented, you need to set an experimental flag to enable it:

```
dart --enable-experiment=variance variance_example.dart
```


We appreciate any and all feedback! You can let us know what you think in [this GitHub issue](https://github.com/dart-lang/language/issues/524).

## **Summary**

Existing Dart generics are covariant by default, which makes it easy to start writing new classes and to get started. This means, however, that more errors appear at runtime rather than at compile time. The user is also paying for the cost of additional runtime checks. The main idea behind variance is to provide users with more informative error checking at compile time.

Variance is defined only for the parameters of generic classes and mixins. Users can use the variance feature by adding one of the `in`, `out` or `inout` keywords before a type parameter.

Additionally, new generic interfaces with these modifiers can extend legacy interfaces with no variance modifiers.

Declaration-site variance allows you to reap a bunch of new benefits, including:

* Compile-time variant position checking within members of the interface

* Removal of pesky runtime errors that occur with down and up casting

* Additional subtyping changes based on the variance declared

* More informative and accessible error checking

Now you won’t have to worry if that `objectWriter` is *truly* a writer of any object. You *know* it is.