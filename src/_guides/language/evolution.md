---
title: Dart language evolution
short-title: Language evolution
description: Notable changes and additions to the Dart programming language.
---

This page lists notable changes and additions to the Dart programming language.
If you want details about the currently supported language, see the
[language tour][] or the
[language specification][].

For a peek into current features being discussed, investigated, and added to the
Dart language, see the [language funnel][] tracker in the Dart
language GitHub repo.

## Dart 2.0

Dart 2.0 implemented a new **[sound type system][]**. Before
Dart 2.0, types weren't fully sound, and Dart relied heavily on runtime type
checking. Dart 1.x code had to be [migrated to Dart 2][].

## Dart 2.1

Dart 2.1 added support for **int-to-double conversion**, allowing developers to
set `double` values using integer literals. This feature removed the annoyance
of being forced to use a `double` literal (for example, `4.0`)
when the value was conceptually an integer.
In the following Flutter code, `horizontal` and `vertical` have type `double`:

```dart
padding: const EdgeInsets.symmetric(
  horizontal: 4,
  vertical: 8,
)
```

## Dart 2.2

Dart has always supported literal lists and maps, but
Dart 2.2 added support for **[set literals][]**:

```dart
const Set<String> currencies = {'EUR', 'USD', 'JPY'};
```
## Dart 2.3

Dart 2.3 added three operators designed to improve code that performs
list manipulation, such as declarative UI code.

The **[spread operator][]**
enables unpacking the elements from one list into another.
In the following example, the list returned by `buildMainElements()`
is unpacked into the list being passed to the `children` argument:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Header(),
    ...buildMainElements(),
    Footer(),
  ]);
}
```

The **[collection if][]**
operator enables adding elements conditionally.
The following example adds a `FlatButton` element
unless this is the last page:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    if (page != pages.last)
      FlatButton(child: Text('Next')),
  ]);
}
```

The **[collection for][]**
operator enables building repeated elements.
The following example adds one `HeadingAction`
element for each section in `sections`:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    for (var section in sections)
      HeadingAction(section.heading),
  ]);
}
```

## Dart 2.5

Dart 2.5 didn't add any features to the Dart language, but it did add
support for [calling native C code][] from Dart code
using a new **core library, `dart:ffi`.**

## Dart 2.6

Dart 2.6 didn't add any features to the Dart language, but it did add a
**new tool, [`dart2native`][],** for compiling Dart code to
native executables.

## Dart 2.7

Dart 2.7 added support for **[extension methods][]**,
enabling you to add functionality to any type —
even types you don’t control — with the brevity and auto-complete experience
of regular method calls.

The following example extends the `String` class from `dart:core` with a new
`parseInt()` method:

```dart
extension ParseNumbers on String {
  int parseInt() {
    return int.parse(this);
  }
}

void main() {
  int i = '42'.parseInt();
  print(i);
}
```

[calling native C code]: /guides/libraries/c-interop
[collection for]: /guides/language/language-tour#collection-operators
[collection if]: /guides/language/language-tour#collection-operators
[`dart2native`]: /tools/dart2native
[extension methods]: /guides/language/extension-methods
[language funnel]: https://github.com/dart-lang/language/projects/1
[language specification]: /guides/language/spec
[language tour]: /guides/language/language-tour
[migrated to Dart 2]: /dart-2
[set literals]: /guides/language/language-tour#sets
[sound type system]: /guides/language/sound-dart
[spread operator]: /guides/language/language-tour#spread-operator
