---
title: Metadata
description: Metadata and annotations in Dart.
prevpage:
  url: /language/functions
  title: Functions
nextpage:
  url: /language/libraries
  title: Libraries & imports
---


Use metadata to provide additional static information about your code.
A metadata annotation begins with the character `@`, followed by either
a reference to a compile-time constant (such as `deprecated`) or
a call to a constant constructor.

Metadata can be attached to most Dart program constructs by
adding annotations before the construct's declaration or directive.

## Built-in annotations

The following annotations are available to all Dart code:

[`@Deprecated`][]
: Marks a declaration as deprecated,
  indicating it should be migrated away from,
  with a message explaining the replacement and potential removal date.

[`@deprecated`][]
: Marks a declaration as deprecated until an unspecified future release.
  Prefer using `@Deprecated` and [providing a deprecation message][].

[`@override`][]
: Marks an instance member as an override or implementation of
  a member with the same name from a parent class or interface.
  For examples of using `@override`, check out [Extend a class][].

[`@pragma`][]
: Provides specific instructions or hints about a declaration to
  Dart tools, such as the compiler or analyzer.

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
[providing a deprecation message]: /tools/linter-rules/provide_deprecation_message
[Extend a class]: /language/extend
[Dart analyzer]: /tools/analysis

## Analyzer-supported annotations

Beyond providing support and analysis for the [built-in annotations][],
the [Dart analyzer][] provides additional support and diagnostics for
a variety of annotations from [`package:meta`][].
Some commonly used annotations the package provides include:

[`@visibleForTesting`][]
: Marks a member of a package as only public so that
  the member can be accessed from the package's tests.
  The analyzer hides the member from autocompletion suggestions
  and warns if it's used from another package.

[`@awaitNotRequired`][]
: Marks variables that have a `Future` type or functions that return a `Future`
  as not requiring the caller to await the `Future`.
  This stops the analyzer from warning callers that don't await the `Future`
  due to the [`discarded_futures`][] or [`unawaited_futures`][] lints.

To learn more about these and the other annotations the package provides,
what they indicate, what functionality they enable, and how to use them,
check out the [`package:meta/meta.dart` API docs][meta-api].

[built-in annotations]: #built-in-annotations
[Dart analyzer]: /tools/analysis
[`@visibleForTesting`]: {{site.pub-api}}/meta/latest/meta/visibleForTesting-constant.html
[`@awaitNotRequired`]: {{site.pub-api}}/meta/latest/meta/awaitNotRequired-constant.html
[`discarded_futures`]: /tools/linter-rules/discarded_futures
[`unawaited_futures`]: /tools/linter-rules/unawaited_futures
[meta-api]: {{site.pub-api}}/meta/latest/meta/meta-library.html

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
```dart highlightLines=1
@Todo('Dash', 'Implement this function')
void doSomething() {
  print('Do something');
}
```

### Specifying supported targets {:.no_toc}

To indicate the type of language constructs that
should be annotated with your annotation,
use the [`@Target`][] annotation from [`package:meta`][].

For example, if you wanted the earlier `@Todo` annotation to
only be allowed on functions and methods,
you'd add the following annotation:

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
