---
title: Generators
description: Learn about generator functions in Dart.
---

When you need to lazily produce a sequence of values,
consider using a _generator function_.
Dart has built-in support for two kinds of generator functions:

* **Synchronous** generator: Returns an [`Iterable`] object.
* **Asynchronous** generator: Returns a [`Stream`] object.

To implement a **synchronous** generator function,
mark the function body as `sync*`,
and use `yield` statements to deliver values:

<?code-excerpt "misc/test/language_tour/async_test.dart (sync-generator)"?>
```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
```

To implement an **asynchronous** generator function,
mark the function body as `async*`,
and use `yield` statements to deliver values:

<?code-excerpt "misc/test/language_tour/async_test.dart (async-generator)"?>
```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}
```

If your generator is recursive,
you can improve its performance by using `yield*`:

<?code-excerpt "misc/test/language_tour/async_test.dart (recursive-generator)"?>
```dart
Iterable<int> naturalsDownFrom(int n) sync* {
  if (n > 0) {
    yield n;
    yield* naturalsDownFrom(n - 1);
  }
}
```

[`Iterable`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html
[`Stream`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html