---
title: "An intro to immutability with Dart"
description: "It’s impossible to deny that immutability is a hot topic in programming, especially front-end programming. Libraries like Immutable.js and…"
publishDate: 2017-04-24
author: "matanlurey"
category: other
tags:
  - javascript
  - functional-programming
  - dart
  - dartlang
  - immutable
---


It’s impossible to deny that [immutability](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&cad=rja&uact=8&ved=0ahUKEwiM4_LAjLzTAhWDKGMKHbnICLYQFggmMAE&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FImmutable_object&usg=AFQjCNEkdj3g887nk6kENS9SYN-2xsqXpw&sig2=hZqSkCh5MKP-OX2w8YyjvQ) is a hot topic in programming, especially front-end programming. Libraries like [Immutable.js](https://facebook.github.io/immutable-js/) and other concepts like unidirectional data flow have argued it’s easier to reason about data when it doesn’t change underneath you:
> In object-oriented and functional programming, an **immutable** object (unchangeable object) is an object whose state cannot be modified after it is created. This is in contrast to a mutable object (changeable object), which can be modified after it is created.

Well, what about Dart? We have a couple concepts that lend themselves well to immutability and immutable objects built-in, starting with the *const* modifier and *const* constructor. Not to be confused with *const* in ES6, which is merely an immutable binding:

```javascript
// Define USER as a constant and give it an initial value.
const USER = { name: 'Joe'; }

// This will throw an error.
USER = {};

// But this will not.
USER.name = 'Jill';

```

In Dart, *const* is both an immutable binding *and* an immutable object:

```dart
main() {
  const user = const {'name': 'Joe'};
  
  // Static error: "Constant variables cannot be assigned a value".
  user = {};
  
  // Runtime error: "Unsupported operation: Cannot modify unmodifiable Map".
  user['name'] = 'Jill';
}

```

All literals (*Null, String, int, double, num, bool, Map, List, Symbol*) are capable of being *const*, and it’s possible to create user-types with a *const* constructor:

```dart
class User {
  final String name;
  
  const User(this.name);
}

main() {
  const user = const User('Joe');
}

```

Let’s review — *const* instances are both immutable bindings and *enforced* at a language level to be both deeply immutable — and also are *canonicalized* at compile-time — that is, any two instances are considered equivalent, and are only represented by a single instance when running. For example, the following is rather cheap — it only allocates a single instance at runtime:

```dart
class User {
  final String name;
  final List<String> cars;
  
  User(this.name, {this.cars});
}

main() {
  for (var i = 0; i < 100; i++) {
    const users = const {
      'Matan': const User(
        'Matan Lurey',
        cars: const [
          'Truck',
          'Jeep',
          'GoKart',
        ],
      ),
    };
  }
}

```

Want to learn more? [Read the Dart language tour about final and const](https://www.dartlang.org/guides/language/language-tour#final-and-const).

## Further static checking with package:meta

Of course, *const* is a bit restrictive — you must be able to create a class at compile-time — so you couldn’t for example read a database and create *const* objects at runtime. We’ve recently introduced the “immutable” annotation with [package:meta](https://pub.dartlang.org/packages/meta):

```dart
import 'pacakge:meta/meta.dart';

// Error: This class inherits from a class marked as @immutable, and therefore 
// should be immutable (all instance fields must be final).
@immutable
class User {
  String name;
}

```

You can use this annotation to help enforce that developers keep your classes deeply immutable. It won’t be canonicalized like *const*, but can still be quite helpful for developers.

I hope this was a nice introduction to immutability. Please let me know in the comments or on twitter if you’d like to learn more about Dart or immutability.