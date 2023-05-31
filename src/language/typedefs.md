---
title: Typedefs
description: Learn about type aliases in Dart.
toc: false
prevpage:
  url: /language/generics
  title: Generics
nextpage:
  url: /language/type-system
  title: Type system
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

A type alias—often called a _typedef_ because
it's declared with the keyword `typedef`—is
a concise way to refer to a type.
Here's an example of declaring and using a type alias named `IntList`:

<?code-excerpt "misc/lib/language_tour/typedefs/misc.dart (int-list)"?>
```dart
typedef IntList = List<int>;
IntList il = [1, 2, 3];
```

A type alias can have type parameters:

<?code-excerpt "misc/lib/language_tour/typedefs/misc.dart (list-mapper)"?>
```dart
typedef ListMapper<X> = Map<X, List<X>>;
Map<String, List<String>> m1 = {}; // Verbose.
ListMapper<String> m2 = {}; // Same thing but shorter and clearer.
```

{{site.alert.version-note}}
  Before 2.13, typedefs were restricted to function types.
  Using the new typedefs requires a [language version][] of at least 2.13.
{{site.alert.end}}

We recommend using [inline function types][] instead of typedefs for functions,
in most situations.
However, function typedefs can still be useful:

<?code-excerpt "misc/lib/language_tour/typedefs/misc.dart (compare)"?>
```dart
typedef Compare<T> = int Function(T a, T b);

int sort(int a, int b) => a - b;

void main() {
  assert(sort is Compare<int>); // True!
}
```

[language version]: /guides/language/evolution#language-versioning
[inline function types]: /effective-dart/design#prefer-inline-function-types-over-typedefs
