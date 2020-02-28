---
title: Dart language evolution
short-title: Language evolution
description: Notable changes and additions to the Dart programming language.
---

This page lists notable changes and additions to the Dart programming language
that have happened over the years. For the currently supported language, see the
[language tour](/guides/language/language-tour) or the
[language specification](/guides/language/spec).

For a peek into current features being discussed, investigated, and added to the
Dart language, see the [language funnel][language funnel] tracker in the Dart
language GitHub repo.

## Dart 2.0

Dart 2.0 added a new [sound type system](/guides/language/sound-dart). Prior to
Dart 2.0, types were not fully sound, and relied heavily on runtime type
checking. Dart 1.x code had to be [migrated to Dart 2](/dart-2).

## Dart 2.1

Dart 2.1 added support for **int-to-double conversion**, allowing developers to
pass ints to methods that expect doubles. This is convinient in APIs that are
specified to take doubles, but where developers frequently need to call them
with ints, such as the following example from Flutter:

```dart
padding: const EdgeInsets.symmetric(
  horizontal: 4,
  vertical: 8,
)
```

## Dart 2.2

Prior to Dart 2.2 only Lists and Maps could be initialized with literals. Dart
2.2 added support for **Set literals**, allowing for easy and compact
initialization:

```dart
const Set<String> currencies = {'EUR', 'USD', 'JPY'};
```
## Dart 2.3

Dart 2.3 added three new operators designed to improve code that relies of lots
of list manipulations (such as declarative UI code).

The **[spread operator](/guides/language/language-tour#spread-operator)**
enables unpacking the elements from one list into another. In this example the
list returned by `buildMainElements()` is unpacked into the list being passed to
the `children` argument:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Header(),
    ...buildMainElements(),
    Footer(),
  ]);
}
```

The **[collection if](/guides/language/language-tour#collection-operators)**
operator enables adding elements conditionally. In this example the `FlatButton`
element is being added to the list passed to the `children` argument only when
`page` isn't equal to `page.last`:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    if (page != pages.last)
      FlatButton(child: Text('Next')),
  ]);
}
```

The **[collection for](/guides/language/language-tour#collection-operators)**
operator enables building repeated elements. In this example an `HeadingAction`
element is added for every section in `sections`:

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

Dart 2.5 didn't add any new features in the core Dart language, but it did add
support for [calling native C code](/guides/libraries/c-interop) from Dart code
using **`dart:ffi`**.

## Dart 2.6

Dart 2.5 didn't add any new features in the core Dart language, but it did add a
new **[`dart2native`](/tools/dart2native)** compiler for compiling Dart code to
native executables.

## Dart 2.7

Dart 2.7 added support for **[extension methods](/guides/language/extension-methods)**
enabling you to add newfunctionality to any type -- even types you don’t control
-- with the brevity and auto-complete experience of regular method calls.

In this example we extend the `String` class from `dart:core` with a new
`parseInt()` method:

```dart
extension ParseNumbers on String {
  int parseInt() {
    return int.parse(this);
  }
  double parseDouble() {
    return double.parse(this);
  }
}
main() {
  int i = '42'.parseInt();
  print(i);
}
```


[language funnel]: https://github.com/dart-lang/language/projects/1
