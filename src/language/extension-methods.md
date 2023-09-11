---
title: Extension methods
description: Learn how to add to existing APIs.
prevpage:
  url: /language/enums
  title: Enums
nextpage:
  url: /language/callable-objects
  title: Callable objects
---

Extension methods add functionality to existing libraries.
You might use extension methods without even knowing it.
For example, when you use code completion in an IDE,
it suggests extension methods alongside regular methods.

<iframe width="560" height="315"
src="https://www.youtube.com/embed/D3j0OSfT9ZI"
frameborder="0"
allow="accelerometer; encrypted-media; gyroscope; picture-in-picture"
allowfullscreen>
</iframe>
_If you like to learn by watching videos,
here's a good overview of extension methods._

## Overview

When you're using someone else's API or
when you implement a library that's widely used,
it's often impractical or impossible to change the API.
But you might still want to add some functionality.

For example, consider the following code that parses a string into an integer:

```dart
int.parse('42')
```

It might be nice—shorter and easier to use with tools—to
have that functionality be on `String` instead:

```dart
'42'.parseInt()
```

To enable that code,
you can import a library that contains an extension of the `String` class:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (basic)" replace="/  print/print/g"?>
```dart
import 'string_apis.dart';
// ···
print('42'.parseInt()); // Use an extension method.
```

Extensions can define not just methods,
but also other members such as getter, setters, and operators.
Also, extensions can have names, which can be helpful if an API conflict arises.
Here's how you might implement the extension method `parseInt()`,
using an extension (named `NumberParsing`) that operates on strings:

<?code-excerpt "extension_methods/lib/string_extensions/string_apis.dart (parseInt)"?>
```dart
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
  // ···
}
```
<div class="prettify-filename">lib/string_apis.dart</div>

The next section describes how to _use_ extension methods.
After that are sections about _implementing_ extension methods.


## Using extension methods

Like all Dart code, extension methods are in libraries.
You've already seen how to use an extension method—just 
import the library it's in, and use it like an ordinary method:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (import-and-use)" replace="/  print/print/g"?>
```dart
// Import a library that contains an extension on String.
import 'string_apis.dart';
// ···
print('42'.padLeft(5)); // Use a String method.
print('42'.parseInt()); // Use an extension method.
```

That's all you usually need to know to use extension methods.
As you write your code, you might also need to know
how extension methods depend on static types (as opposed to `dynamic`) and
how to resolve [API conflicts](#api-conflicts).

### Static types and dynamic

You can't invoke extension methods on variables of type `dynamic`.
For example, the following code results in a runtime exception:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (dynamic)" plaster="none" replace="/  \/\/ print/print/g"?>
```dart
dynamic d = '2';
print(d.parseInt()); // Runtime exception: NoSuchMethodError
```

Extension methods _do_ work with Dart's type inference.
The following code is fine because
the variable `v` is inferred to have type `String`:

<?code-excerpt "extension_methods/lib/string_extensions/usage_simple_extension.dart (var)"?>
```dart
var v = '2';
print(v.parseInt()); // Output: 2
```

The reason that `dynamic` doesn't work is that
extension methods are resolved against the static type of the receiver.
Because extension methods are resolved statically,
they're as fast as calling a static function.

For more information about static types and `dynamic`, see
[The Dart type system](/language/type-system).

### API conflicts

If an extension member conflicts with
an interface or with another extension member,
then you have a few options.

One option is changing how you import the conflicting extension,
using `show` or `hide` to limit the exposed API:

<?code-excerpt "extension_methods/lib/string_extensions/usage_import.dart" replace="/  //g"?>
```dart
// Defines the String extension method parseInt().
import 'string_apis.dart';

// Also defines parseInt(), but hiding NumberParsing2
// hides that extension method.
import 'string_apis_2.dart' hide NumberParsing2;

// ···
// Uses the parseInt() defined in 'string_apis.dart'.
print('42'.parseInt());
```

Another option is applying the extension explicitly,
which results in code that looks as if the extension is a wrapper class:

<?code-excerpt "extension_methods/lib/string_extensions/usage_explicit.dart" replace="/  //g"?>
```dart
// Both libraries define extensions on String that contain parseInt(),
// and the extensions have different names.
import 'string_apis.dart'; // Contains NumberParsing extension.
import 'string_apis_2.dart'; // Contains NumberParsing2 extension.

// ···
// print('42'.parseInt()); // Doesn't work.
print(NumberParsing('42').parseInt());
print(NumberParsing2('42').parseInt());
```

If both extensions have the same name,
then you might need to import using a prefix:

<?code-excerpt "extension_methods/lib/string_extensions/usage_prefix.dart" replace="/  //g"?>
```dart
// Both libraries define extensions named NumberParsing
// that contain the extension method parseInt(). One NumberParsing
// extension (in 'string_apis_3.dart') also defines parseNum().
import 'string_apis.dart';
import 'string_apis_3.dart' as rad;

// ···
// print('42'.parseInt()); // Doesn't work.

// Use the ParseNumbers extension from string_apis.dart.
print(NumberParsing('42').parseInt());

// Use the ParseNumbers extension from string_apis_3.dart.
print(rad.NumberParsing('42').parseInt());

// Only string_apis_3.dart has parseNum().
print('42'.parseNum());
```

As the example shows,
you can invoke extension methods implicitly even if you import using a prefix.
The only time you need to use the prefix is
to avoid a name conflict when invoking an extension explicitly.


## Implementing extension methods

Use the following syntax to create an extension:

```
extension <extension name>? on <type> {
  (<member definition>)*
}
```

For example, here's how you might implement an extension on the `String` class:

<?code-excerpt "extension_methods/lib/string_extensions/string_apis.dart"?>
```dart
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }
}
```
<div class="prettify-filename">lib/string_apis.dart</div>

The members of an extension can be methods, getters, setters, or operators.
Extensions can also have static fields and static helper methods.
To access static members outside the extension declaration, 
invoke them through the declaration name like [class variables and methods][]. 

[class variables and methods]: /language/classes#class-variables-and-methods

### Unnamed extensions

When declaring an extension, you can omit the name.
Unnamed extensions are visible only
in the library where they're declared.
Since they don't have a name,
they can't be explicitly applied
to resolve [API conflicts](#api-conflicts).

<?code-excerpt "extension_methods/lib/string_extensions/string_apis_unnamed.dart (unnamed)"?>
```dart
extension on String {
  bool get isBlank => trim().isEmpty;
}
```

{{site.alert.note}}
  You can invoke an unnamed extension's static members
  only within the extension declaration.
{{site.alert.end}}

## Implementing generic extensions

Extensions can have generic type parameters.
For example, here's some code that extends the built-in `List<T>` type
with a getter, an operator, and a method:

<?code-excerpt "extension_methods/lib/fancylist.dart"?>
```dart
extension MyFancyList<T> on List<T> {
  int get doubleLength => length * 2;
  List<T> operator -() => reversed.toList();
  List<List<T>> split(int at) => [sublist(0, at), sublist(at)];
}
```

The type `T` is bound based on the static type of the list that
the methods are called on.
{% comment %}
TODO (https://github.com/dart-lang/site-www/issues/2171):
Add more info about generic extensions. 
For example, in the following code, `T` is `PENDING` because PENDING:

[PENDING: example]

[PENDING: Explain why it matters in normal usage.]
{% endcomment %}

## Resources

For more information about extension methods, see the following:

* [Article: Dart Extension Methods Fundamentals][article]
* [Feature specification][specification]
* [Extension methods sample][sample]

[specification]: https://github.com/dart-lang/language/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#dart-static-extension-methods-design
[article]: https://medium.com/dartlang/extension-methods-2d466cd8b308
[sample]: https://github.com/dart-lang/samples/tree/main/extension_methods
