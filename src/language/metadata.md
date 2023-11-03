---
title: Metadata
description: Metadata and annotations in Dart.
toc: false
prevpage:
  url: /language/comments
  title: Comments
nextpage:
  url: /language/libraries
  title: Libraries
---


Use metadata to give additional information about your code. A metadata
annotation begins with the character `@`, followed by either a reference
to a compile-time constant (such as `deprecated`) or a call to a
constant constructor.

Four annotations are available to all Dart code: 
[`@Deprecated`][], [`@deprecated`][], [`@override`][], and [`@pragma`][]. 
For examples of using `@override`,
see [Extending a class][].
Here's an example of using the `@Deprecated` annotation:

<?code-excerpt "misc/lib/language_tour/metadata/television.dart (deprecated)" replace="/@Deprecated.*/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
class Television {
  /// Use [turnOn] to turn the power on instead.
  [!@Deprecated('Use turnOn instead')!]
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {...}
  // ···
}
{% endprettify %}

You can use `@deprecated` if you don't want to specify a message.
However, we [recommend][dep-lint] always
specifying a message with `@Deprecated`.

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

<?code-excerpt "misc/lib/language_tour/metadata/misc.dart"?>
```dart
@Todo('Dash', 'Implement this function')
void doSomething() {
  print('Do something');
}
```

Metadata can appear before a library, class, typedef, type parameter,
constructor, factory, function, field, parameter, or variable
declaration and before an import or export directive.

[`@Deprecated`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Deprecated-class.html
[`@deprecated`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/deprecated-constant.html
[`@override`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/override-constant.html
[`@pragma`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/pragma-class.html
[dep-lint]: /tools/linter-rules/provide_deprecation_message
[Extending a class]: /language/extend
