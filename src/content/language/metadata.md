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

<?code-excerpt "misc/lib/language_tour/metadata/television.dart (deprecated)"?>
```dart highlightLines=3
class Television {
  /// Use [turnOn] to turn the power on instead.
  @Deprecated('Use turnOn instead')
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {
    // ···
  }
  // ···
}
```

The [Dart analyzer][] provides feedback as diagnostics if
the `@override` annotation is needed and when using
members annotated with `@deprecated` or `@Deprecated`.

[`@Deprecated`]: {{site.dart-api}}/dart-core/Deprecated-class.html
[`@deprecated`]: {{site.dart-api}}/dart-core/deprecated-constant.html
[`@override`]: {{site.dart-api}}/dart-core/override-constant.html
[`@pragma`]: {{site.dart-api}}/dart-core/pragma-class.html
[provide a deprecation message]: /tools/linter-rules/provide_deprecation_message
[Extending a class]: /language/extend
[Dart analyzer]: /tools/analysis

## Custom annotations

You can define your own metadata annotations. Here's an example of
defining a `@Todo` annotation that takes two arguments:

<?code-excerpt "misc/lib/language_tour/metadata/todo.dart (definition)"?>
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

To indicate the type of elements that should be annotated with your annotation,
you can use the [`@Target`][] annotation from [`package:meta`][].

For example, if you wanted the above `@Todo` annotation to
only be allowed on functions, you'd add the following annotation:

<?code-excerpt "misc/lib/language_tour/metadata/todo.dart (target-kinds)"?>
```dart highlightLines=3
import 'package:meta/meta_meta.dart';

@Target({TargetKind.function, TargetKind.method})
class Todo {
  // ···
}
```

With this configuration, the analyzer will warn if `Todo` is used as
an annotation on any declaration besides a top-level function or method.

[`@Target`]: {{site.pub-api}}/meta/latest/meta_meta/Target-class.html
[`package:meta`]: {{site.pub-pkg}}/meta

## Analyzer supported annotations

Beyond providing support and analysis for the [built-in annotations][],
the [Dart analyzer][] provides additional support and diagnostics for
a variety of annotations from [`package:meta`][].
Some of the most commonly used annotations it provides include:

*   [`@visibleForTesting`][]: Mark a public member of a package as
    only public for that package to write tests for it.
    The analyzer hides the member from autocompletion suggestions
    and warns if it's used from another package.
*   [`@awaitNotRequired`][]: Suppress `unawaited_futures` and
    `discarded_futures` lint diagnostics at call sites.

To learn more about these and the other annotations the package provides,
what elements they can be applied to, what they do, and how to use them,
check out the [`package:meta/meta.dart` API docs][meta-api].

[built-in annotations]: #built-in-annotations
[Dart analyzer]: /tools/analysis
[`@visibleForTesting`]: {{site.pub-api}}/meta/latest/meta/visibleForTesting-constant.html
[`@awaitNotRequired`]: {{site.pub-api}}/meta/latest/meta/awaitNotRequired-constant.html
[meta-api]: {{site.pub-api}}/meta/latest/meta/meta-library.html
