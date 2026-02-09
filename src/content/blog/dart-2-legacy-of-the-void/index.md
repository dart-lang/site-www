---
title: "Dart 2: Legacy of the `void`"
description: "One of the questions I see the most asked on StackOverflow, Gitter, and even Google-internal support channels is the difference between the…"
publishDate: 2018-08-30
author: "matanlurey"
image: images/1qGU6soDvCW0RFfDX8vpUow.png
category: other
tags:
  - programming
  - dart
  - flutter
  - dartlang
  - type-safety
---


<DashImage src="images/1qGU6soDvCW0RFfDX8vpUow.png" alt="A semi-accurate depiction of the [universe](https://en.wikipedia.org/wiki/Bo%C3%B6tes_void) of void-like types in Dart2" caption="A semi-accurate depiction of the [universe](https://en.wikipedia.org/wiki/Bo%C3%B6tes_void) of void-like types in Dart2" />


One of the questions I see the most asked on StackOverflow, Gitter, and even Google-internal support channels is the difference between the following built-in types in Dart 2: `Object`, `dynamic`, `void`, and `Null`.

Long-story short, `Null` ([or `Bottom` in other languages](https://en.wikipedia.org/wiki/Bottom_type), i.e. “Nothing”) shouldn’t be used in most real user-code, and I suspect we’ll see more articles and lints in the near future to gently discourage usage.

The rest of the three are not as clear, because something in Dart 2 anything can be `dynamic`, `Object`or `void`at runtime, varying only by the *static* type signature. So let’s look at a few practical examples of *when* you should use which type signature.

## Object

[`Object`](https://api.dartlang.org/stable/2.0.0/dart-core/Object-class.html)is the root class of the Dart class hierarchy, and every other class in Dart is a sub-class of `Object` — including “primitive” types like `int`, `double`, or `bool`. It guarantees a few things: a [`hashCode`property](https://api.dartlang.org/stable/2.0.0/dart-core/Object/hashCode.html), an [`==`operator](https://api.dartlang.org/stable/2.0.0/dart-core/Object/operator_equals.html), a [`toString`method](https://api.dartlang.org/stable/2.0.0/dart-core/Object/toString.html).

Practically speaking, I use `Object`like a poor man’s union type — expecting users to use the `is`operator to determine the real type of something before using it. **I don’t use `dynamic`**, because, as outlined in the next section, it disables important static analysis and more easily allows you to get into an invalid state.

```
Object readProperty(String name) { ... }

void main() {
  var age = readProperty('name');
  if (age is int) {
    print('I am $age years old');
  } else if (age is String) {
    print(age);
  }
}
```


Another option is to use `Object` to declare you *don’t care* what the inner type of a data structure is, for example `List&lt;Object&gt;` might mean “a list of anything”. This comes in handy when, for example, writing a function that combines the `hashCode` of every element in a `List`:

```
int hashList(List<Object> elements) { ... }
```


A nice property of `Object`(compared with `dynamic`) is that you will get immediate analysis and compiler feedback if you try to call a method on it that doesn’t reliably exist. For example, the following produces a *static error*:

```
void main() {
  Object a = 5;
  a.aMethodThatDoesNotExist();
}
```


In practice though, `Object` is fairly(and intentionally) limited. My hope is that [Dart will get support for method overloads](https://github.com/dart-lang/sdk/issues/26488) and that will allow me to dramatically decrease my usage of the `Object` type in real code.

## dynamic

I personally **never** use the `dynamic` type in Dart 2. From my perspective, it is sort of a union of `Object`and a special instruction that tells tools and compilers to *disable static analysis checks*. That is, the following is legal, and will only present an error at runtime (not statically!):

```
void main() {
  dynamic x = 5;
  x.aMethodThatDoesNotExist();
}
```


In Dart 1, `dynamic` was everywhere, and any other static type was for IDE and static analysis support — but the compiler (and runtime) treated everything as `dynamic`. There are still some unfortunate “gotchas” in Dart 2 that can *accidentally* create a `dynamic`-typed variable, though:

```
computeAge() => 5; // Return type is dynamic

void main() {
  var name; // Static type is dynamic
  var animals = []; // Static and runtime type is List<dynamic>
}
```


Worse yet, `dynamic` calls lose type information that is vital in Dart 2:

```
class User {
  String name;
}

void main() {
  var users = []; // Implicitly List<dynamic>, remember?
  users.add(new User()..name = 'Matan');

  // Runtime error: List<dynamic> is not a Iterable<String>
  Iterable<String> names = users.map((u) => u.name);
}
```


The reason for this error is because the actual call here is:

```
users.map((dynamic u) => u.name);
```


… which does not have enough static type information to produce a `Iterable&lt;String&gt;`. By fixing `users` to have the proper type (and avoiding dynamic calls), everything works:

```
void main() {
  // We also could have written `var users = <User>[
  var users = [new User()..name = 'Matan'];

  // OK!
  Iterable<String> names = users.map((u) => u.name);
}
```


## void

Lastly, we have `void`, the newest type in Dart 2. In Dart 1 `void` was only usable as the return type of a function (such as `void main()`), but in Dart 2 it has been *generalized, *and is usable elsewhere, for example `Future&lt;void&gt;`.

A `void` type is semantically similar to `Object`(it could be anything), except with additional restrictions — a `void` type cannot be used for anything (even `==` or `hashCode`), and it is invalid to assign something to a `void` type:

```
void foo() {}

void main() {
  var bar = foo(); // Invalid
}
```


In *practice, *I use `void` to mean “anything and I don’t care about the elements” or, more commonly, to mean “omitted”, such as in `Future&lt;void&gt;` or `Stream&lt;void&gt;`:

```
/// Clear the cache.
Future<void> purgeCache() { ... }
```


In the above code snippet, I don’t want users to try and use the return value of the provided `Future`, as it is not relevant. I’ve seen examples of using `Future&lt;Null&gt;`for this purpose, and that was actually a workaround *before* `Future&lt;void&gt;`was possible.

For example, this is statically OK, but at runtime is invalid in Dart 2:

```
import 'dart:async';

Future<String> _doAThing() async => 'Test';
Future<Null> doAThing() async => _doAThing();

void main() async {
  // Future<String> is not a subtype of type FutureOr<Null>
  await doAThing();
}
```


… where as using `Future&lt;void&gt;`for `doAThing()`is valid and correct.

Another example might be a `Stream` that fires without any event data:

```
/// Fires an event when a user signs-out of the system.
Stream<void> get onLogOut { ... }
```


Another more practical use is implementing a class with generic type arguments you won’t be using. For example, implementing the popular [`Visitor` pattern](https://en.wikipedia.org/wiki/Visitor_pattern), we can ignore the `C`(context) type argument when it isn’t used by passing `void`:

```
abstract class Visitor<N, C> {
  N visitNode(N node, [C context]);
}

class IdentityVisitor<N> extends Visitor<N, void> {
  @override
  N visitNode(N node, [_]) => node;
}
```


I hope this brief article helps you with API decisions around using `Object`, `dynamic`, `void`. Leave comments if you have any other questions or ideas!