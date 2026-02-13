---
title: "Dart and the performance benefits of sound types"
description: "Using soundness and null safety to generate faster, smaller code."
publishDate: 2021-01-19
author: "vijaysmenon"
image: images/1x0UcFY8XwG-3vHe5hYxyQw.png
category: other
tags:
  - dart
  - programming-languages
  - performance
---


### Using soundness and null safety to generate faster, smaller code

<DashImage src="images/1WOmw6jN-nt82uXjGCqRC4g.png" alt="Code generated from the same Dart method in Dart 1.24, 2.0, and 2.12 (left to right) has gotten smaller. To see why (and to see the actual generated code), keep reading." caption="Code generated from the same Dart method in Dart 1.24, 2.0, and 2.12 (left to right) has gotten smaller. To see why (and to see the actual generated code), keep reading." />


We’ve strengthened Dart’s type system over the past few years. The original Dart language (Dart 1) had an unsound, optional type system (similar to typed JavaScript dialects such as Microsoft’s TypeScript or Facebook’s Flow). Dart 2 introduced a stricter, [*sound* type system](https://dart.dev/guides/language/type-system). Over the past two years, we’ve been working on extending the type system further, via [*sound null safety*](https://dart.dev/null-safety).

While a sound type system provides developers with greater confidence, it also enables our compilers to safely use types to optimize generated code. With soundness, our tools guarantee that types are correct via a combination of static and (when needed) runtime checking. Without soundness, type checking can only go so far, and static types may be incorrect at runtime.

In practice, soundness allows our compilers to generate smaller and faster code, particularly in an ahead-of-time (AOT) setting, where we ship precompiled native code to clients.

## An example

The following example method demonstrates how sound types can have a dramatic impact on relatively simple code:

```
**int getAge(Animal a) {
  return a.age;
}**
```


In our last stable Dart 1 version (1.24.3), this method mapped to **26 native x64 instructions** — and that was only after instrumentation and profile-guided optimization, which slowed initial runtime startup. With sound null safety in Dart 2.12, this code maps to just **3 instructions**, without any need for profile-guided optimization.
> Dart compiles to both ARM32/64 and x86/x64 architectures. In the examples below, we use x64, but results are similar on other targets.

The full Dart code and context for the example method are shown at the end of this article, but here are the key points:

* The class `Animal` contains a field `age` of type `int`.

* `Animal` has several subclasses (`Cat`, `Dog`, `Snake`, `Hamster`).

* The method above is called on many of these types at runtime.

## Dart object layout

The Dart class `Animal`, when compiled to native (x64) code, has a simple layout:

<DashImage src="images/1GjL59kevCm5NQ5P9Unn_NA.png" />


The first 8 bytes are a header that provides reified type information (that is, the runtime type of the object). The second 8 bytes contain the `age` field. All subclasses preserve (and potentially add to) this structure: any additional fields are laid out after, preserving the base type’s structure. The `getAge` method, given an instance of `Animal` (or any subclass) should load the field from an 8-byte offset and return it.

## Dart 1: Unsound types

In Dart 1, however, static types weren’t sound and were effectively ignored during compilation. At runtime, we couldn’t assume that the static type was correct (and, therefore, the layout was as expected). The access to `age` might be to a field at a different offset, to a getter that triggered further executable code, or to a non-existent field (triggering a catchable runtime error).

Dart 1 was designed to rely on a just-in-time compiler and virtual machine on the client device, which optimized the code using runtime type information. In this scheme, we actually compiled each method twice: first, to collect information, and second (for hot methods) to generate more optimized code based on the observed runtime behavior.

### Dart 1: First compilation

The first compilation for `getAge` produced the following 47 instructions on x64:

<DashImage src="images/1BmagjRb3ei3C-HjyYfLNyw.png" />


Note that this code is instrumented to determine what happens at runtime. It assumes nothing about the passed object and effectively performs the equivalent of a hash table lookup to correctly find the field, execute a getter, or throw an error.

### Dart 1: Second compilation

In this case, the code is called repeatedly and triggers a second, optimizing compilation that generates the following 26 instructions:

<DashImage src="images/11bEjUe15A0s47XMsZPqdNQ.png" />


This optimized code is still quite large. It’s based on profile information that found the method was only invoked on instances of `Cat`, `Hamster`, and `Dog`, and is optimized with the assumption that the same will be true going forward.

The code in **blue** is the prologue and epilogue for the method (to set up and restore the stack frame). The code in **red** checks for the expected cases — that the instance is non-null and is of one of the previously seen types — and invokes a slow path for other cases. The code in **bold** is the actual work to load the field.

The optimized code may actually be slower if future behavior is different from the past: if `getAge` is invoked on a new instance (such as a `Snake`) the code will perform the extra checks but still fall down the slow path.

### Problems with Dart 1 generated code

The generated code above is very similar in structure to that produced today by V8, the JavaScript engine in Chrome, when given a more-or-less equivalent JavaScript/TypeScript/Flow program. While this approach (and the corresponding generated code) can give good performance in many scenarios, it wasn’t suitable as we began (with Flutter in particular) to target a broader set of client platforms, including mobile devices more sensitive to size and memory footprint:

* First, the cost of client-side compilation increased the overall footprint of Dart applications.

* Second, the cost of two-phase speculative compilation was detrimental to application startup.

* Third, just-in-time compilation isn’t allowed on iOS: we’d need an alternative strategy for at least some targets.

We shifted instead to an ahead-of-time compilation approach, but with Dart 1 it resulted in considerably worse code. Even with sophisticated, whole-program analysis, we couldn’t always determine type information at compilation time, particularly as applications became larger. In addition, the cost of speculation — the red code above — became prohibitive when the entire application was precompiled.

## Dart 2: Sound types

With Dart 2, we introduced soundness, which enabled us to safely compile code based upon type information and reduced our reliance on profiling for performance. With Dart 2, on a single ahead-of-time compile, we generate 10 instructions on x64:

<DashImage src="images/1x0UcFY8XwG-3vHe5hYxyQw.png" />


This code still performs the null check (in red) and calls a helper method if null is found.

## Dart 2.12: Sound null safety

With sound null safety, the type system is richer, and our compiler can leverage that. The compiler can safely rely upon the (now) non-nullable type and eliminate the code in red above. In Dart 2.12 beta, we generate 3 fewer instructions:

<DashImage src="images/1xVdpKVxtt_TtfoXZDlu1Qw.png" />


In fact, as the code has gotten simpler, we’ve also been able to streamline the prologue and epilogue. In our forthcoming stable release, we’ll generate just 3 instructions for the example method:

<DashImage src="images/1JPFuwgxqf2K-7tVD52M5uQ.png" />


With sound null safety, we can reduce the generated code for this method to its essence: a field load. In practice, a call to this method will always be inlined, as it’s now trivial for the compiler to see that inlining is both a performance and code size win. Runtime checking and compensation code are no longer necessary: more of the heavy lifting happens at compile time. We no longer need the startup and memory overhead of client-side compilation. As a result, our users get smaller and faster code.

## Try it!

We encourage you to try out [null safety](https://dart.dev/null-safety). It’s available in Dart 2.12, now in our beta channel. Once your upstream dependencies are migrated, you’ll be able to migrate your own packages and applications. As the example here illustrates, you may not need to change too much.

Remember, to get the performance benefits of null safety, you’ll need a fully migrated application. Once your application is fully migrated, our compilers will automatically take advantage of null safety to generate better, smaller code.

## PS: The code

Here’s the full Dart code that I compiled to generate all the code in this article. While the example here is contrived, the pattern — a field in a class hierarchy — is quite common.

```dart
int N = 1000000;

class Animal {
  int age = 0;
}

class Cat extends Animal {}

class Dog extends Animal {}

class Snake extends Animal {}

class Hamster extends Animal {}

List<Animal> _animals = [
  new Cat()..age = 1,
  new Hamster()..age = 2,
  new Dog()..age = 3
];
List<Animal> listOfA = [];
void init() {
  for (int i = 0; i < N; ++i) {
    listOfA.add(_animals[i % _animals.length]);
  }
}

int sum() {
  int k = 0;
  for (int i = 0; i < N; ++i) {
    k += getAge(listOfA[i]);
  }
  return k;
}

@pragma('vm:never-inline')
int getAge(Animal a) {
  return a.age;
}

void main() {
  init();
  print(sum());
  print(getAge(listOfA[0]));
}
```