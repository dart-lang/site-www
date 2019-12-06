---
title: Extension methods
description: Learn how to add to existing APIs.
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /([A-Z]\w*)\d\b/$1/g; /\b(main)\d\b/$1/g"?>

Extension methods, introduced in Dart 2.7,
are a way to add functionality to existing libraries.
You might not ever need to _use_ extension methods, much less _create_ them.
But if you generate code or find yourself writing lots of wrappers,
consider using extension methods to reduce
the amount of boilerplate code that you need to write.

You might use extension methods without even knowing it.
For example, when you use code completion in an IDE,
it suggests extension methods alongside regular methods.

{% comment %}
[PENDING: embed video here.]
Watch this video for an introduction to extension methods.
{% endcomment %}

## Overview

When you’re using someone else’s API or
when you implement a library that’s widely used,
it’s often impractical or impossible to change the API.
But you might still want to add some functionality.

For example, consider the following code that parses a string into an integer:

```dart
int.parse('42')
```

It might be nice — shorter and easier to use with tools — to
have that functionality be in the string instead:

```dart
'42'.toInt()
```

To enable that code,
you can import a library that contains an extension of the String class:

```dart
import string_apis.dart';
...
print('42'.toInt());
```

Extensions can define not just methods and getters,
but also other members such as setters and operators.
Also, extensions have names, which can be helpful if an API conflict arises.
Here's how you might implement the extension method `toInt()`,
using an extension (named `ParseNumbers`) that operates on strings:

```dart
extension ParseNumbers on String {
  int toInt() {
    return int.parse(this);
  }
}
```

The next section describes how to _use_ extension methods.
After that are sections about _implementing_ extension methods.


## Using extension methods

Like all Dart code, extension methods are in libraries.
You’ve already seen how to use an extension method —
just import the library it’s in, and use it like an ordinary method:

```dart
// Import a library that contains an extension on String. 
import string_apis.dart';
...
print('42'.padLeft(5)); // Use a String method.
print('42'.toInt()); // Use an extension method.
```

That’s all you usually need to know to use extension methods.
As you write your code, you might also need to know
how extension methods depend on static types (as opposed to `dynamic`) and
how to resolve [API conflicts](#api-conflicts).

### Static types and dynamic

You can’t invoke extension methods on variables of type `dynamic`.
For example, the following code results in a runtime exception:

```dart
dynamic d = '2';
print(d.toInt()); // Runtime exception: NoSuchMethodError
```

Extension methods _do_ work with Dart’s type inference.
The following code is fine because
the variable `v` is inferred to have type `String`:

```dart
var v = '2';
print(v.toInt()); // Output: 2
```

The reason that `dynamic` doesn’t work is that
extension methods are resolved against the static type of the receiver.
For more information about static types and `dynamic`, see
[The Dart type system](/guides/language/sound-dart).

### API conflicts

If an extension member conflicts with
an interface or with another extension member,
then you have a few options.

One option is changing how you import the conflicting extension.
You can use `show` or `hide`, or you can remove the import:

```dart
// Both libraries define the String extension method toInt().
// The extensions might have the same name or different names.
import 'string_apis.dart';
import 'string_apis_2.dart' hide ParseNumbers2;
...
// Use the toInt() defined in 'string_apis.dart'.
print('42'.toInt());
```

Another option is applying the extension explicitly, which results in code that looks as if the extension is a wrapper class:

```dart
// Both libraries define extensions on String that contain toInt(),
// and the extensions have different names.
import 'string_apis.dart'; // Contains ParseNumbers extension.
import 'string_apis_2.dart'; // Contains ParseNumbers2 extension.
...
//  print('42'.toInt()); // Doesn't work.
print(ParseNumbers('42').toInt());
print(ParseNumbers2('42').toInt());
```

If both extensions have the same name,
then you might need to import using a prefix:

```dart
// Both libraries define extensions named ParseNumbers
// that contain the extension method toInt(). One ParseNumbers
// extension (in 'string_apis_3.dart') also defines toNum().
import 'string_apis.dart';
import 'string_apis_3.dart' as rad;
...
//  print('42'.parseInt()); // Doesn't work.

// Use the ParseNumbers extension from string_apis.dart.
print(ParseNumbers('42').toInt());

// Use the ParseNumbers extension from string_apis_3.dart.
print(rad.ParseNumbers('42').toInt());

// Only string_apis_3.dart has toNum().
print('42'.toNum());
```

As the example shows,
you can invoke extension methods implicitly even if you import using a prefix.
The only time you need to use the prefix is
to avoid a name conflict when invoking an extension explicitly.


## Implementing extension methods

Use the following syntax to create an extension:

```
extension <extension name> on <type> {
  (<member definition>)*
}
```

For example, here’s how you might implement an extension of the `String` class:

```dart
// In string_apis.dart:
extension ParseNumbers on String {
  int toInt() {
    return int.parse(this);
  }

  double toDouble() {
    return double.parse(this);
  }
}
```

To create a local extension that’s visible only in
the library where it’s declared,
either omit the extension name or give it a name
that starts with an underscore (`_`).

The members of the extension can be methods, getters, setters, operators.
Extensions can also have static fields and static helper methods.

## Implementing generic extensions

Extensions can have generic type parameters.
For example, here’s some code that extends the built-in `List<T>` type:

```dart
extension MyFancyList<T> on List<T> {
  int get doubleLength => this.length * 2;
  List<T> operator-() => this.reversed.toList();
  List<List<T>> split(int at) => 
      <List<T>>[this.sublist(0, at), this.sublist(at)];
}
```

The type `T` is bound based on the static type of the list that
the methods are called on.
{% comment %}
For example, in the following code, `T` is `PENDING` because PENDING:

[PENDING: example]

[PENDING: why does it matter, in normal usage?]
{% endcomment %}

## Resources

For more information about extension methods, see the following:

* [Article: Dart Extension Methods Fundamentals][article]
* [Feature specification][specification]

{% comment %}
* Video
* 2.7 blog post?
* Release notes?
* Examples?
{% endcomment %}

[specification]: https://github.com/dart-lang/language/blob/master/accepted/2.6/static-extension-members/feature-specification.md#dart-static-extension-methods-design

[article]: https://medium.com/dartlang/extension-methods-2d466cd8b308
