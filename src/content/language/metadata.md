---
title: Metadata
description: Metadata and annotations in Dart.
toc: false
prevpage:
  url: /language/functions
  title: Functions
nextpage:
  url: /language/libraries
  title: Libraries & imports
---


Use metadata to give additional information about your code. A metadata
annotation begins with the character `@`, followed by either a reference
to a compile-time constant (such as `deprecated`) or a call to a
constant constructor.

Metadata can appear before a library, class, typedef, type parameter,
constructor, factory, function, field, parameter, or variable
declaration and before an import or export directive.

## Built-in annotations

The following annotations are available to all Dart code: 

*   [`@awaitNotRequired`][]: Suppress `unawaited_futures` and
    `discarded_futures` lint diagnostics at call sites.
*   [`@Deprecated`][]: Mark a part of your code as no longer
    recommended. Optionally [provide a deprecation message][].
*   [`@deprecated`][]: Mark a part of your code as no longer
    recommended.
*   [`@override`][]: Mark a method as an override for a
    method with the same name from a parent class or
    interface. For examples of using `@override`, see
    [Extending a class][].
*   [`@pragma`][]: Provide specific instructions or hints to
    Dart tools, like the compiler or analyzer.

Here's an example of using the `@Deprecated` annotation:

<?code-excerpt "misc/lib/language_tour/metadata/television.dart (deprecated)" replace="/@Deprecated.*/[!$&!]/g"?>
```dart
class Television {
  /// Use [turnOn] to turn the power on instead.
  [!@Deprecated('Use turnOn instead')!]
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {
    ...
  }
  // ···
}
```

## Custom annotations

You can define your own metadata annotations. Here's an example of
defining a `@Todo` annotation that takes two arguments:

<?code-excerpt "misc/lib/language_tour/metadata/todo.dart"?>
```dart
class Todo {
  final String who;
  final String what;

  const Todo(this.who, this.what);
}
```

And here's an example of using that `@Todo` annotation:

<?code-excerpt "misc/lib/language_tour/metadata/misc.dart (usage)"?>
```dart
@Todo('Dash', 'Implement this function')
void doSomething() {
  print('Do something');
}
```

[`@awaitNotRequired`]: {{site.dart-api}}/dart-core/awaitNotRequired-class.html
[`@Deprecated`]: {{site.dart-api}}/dart-core/Deprecated-class.html
[`@deprecated`]: {{site.dart-api}}/dart-core/deprecated-constant.html
[`@override`]: {{site.dart-api}}/dart-core/override-constant.html
[`@pragma`]: {{site.dart-api}}/dart-core/pragma-class.html
[provide a deprecation message]: /tools/linter-rules/provide_deprecation_message
[Extending a class]: /language/extend
