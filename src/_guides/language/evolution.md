---
title: Dart language evolution
short-title: Language evolution
description: Notable changes and additions to the Dart programming language.
---

This page lists notable changes and additions to the Dart programming language.
If you want details about the currently supported language, see the
[language tour][] or the
[language specification][].

To use a language feature that was introduced after 2.0,
specify [SDK constraints][] that are no lower than
the release when the feature was first supported.
(Details are in the [language versioning section][] of this page.)
For example, to use extension methods, which were [supported starting in 2.7][],
the `pubspec.yaml` file can have 2.7.0 as the lower constraint:

```yaml
environment:
  sdk: ">=2.7.0 <3.0.0"
```

[supported starting in 2.7]: #dart-27
[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[language versioning section]: #language-versioning

{{ site.alert.tip }}
  For a peek into current features being
  discussed, investigated, and added to the Dart language,
  see the [language funnel][] tracker in the Dart language GitHub repo.
{{ site.alert.end }}


## Changes in each release

### Dart 2.0

Dart 2.0 implemented a new **[sound type system][]**. Before
Dart 2.0, types weren't fully sound, and Dart relied heavily on runtime type
checking. Dart 1.x code had to be [migrated to Dart 2][].

### Dart 2.1

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

### Dart 2.2

Dart has always supported literal lists and maps, but
Dart 2.2 added support for **[set literals][]**:

```dart
const Set<String> currencies = {'EUR', 'USD', 'JPY'};
```
### Dart 2.3

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

### Dart 2.5

Dart 2.5 didn't add any features to the Dart language, but it did add
support for [calling native C code][] from Dart code
using a new **core library, `dart:ffi`.**

### Dart 2.6

Dart 2.6 didn't add any features to the Dart language, but it did add a
**new tool, [`dart2native`][],** for compiling Dart code to
native executables.

### Dart 2.7

Dart 2.7 added support for **[extension methods][]**,
enabling you to add functionality to any type —
even types you don’t control — with the brevity and auto-complete experience
of regular method calls.
Because the tech preview for this feature was in 2.6,
you can use extension methods without warnings if you
specify 2.6.0 or a later release as the lower SDK constraint.

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

### Dart 2.8

Dart 2.8 didn't add any features to the Dart language, but it did
contain a number of preparatory [breaking changes][2.8 breaking changes] to ensure great
nullability-related usability and performance in the upcoming
[null safety][] feature.

It also contained a faster pub tool, and a new [pub outdated][] command.

### Dart 2.9

Dart 2.9 didn't add any features to the Dart language.

### Dart 2.10

Dart 2.10 didn't add any features to the Dart language,
but it added an expanded [`dart` tool][dart-tool] that's 
analogous to the Flutter SDK's `flutter` tool.

## Language versioning

Before language versioning,
Dart tools assumed that all Dart code could use all features
that were supported by the tool's SDK version.
This assumption causes problems when a package
that uses a _newer_ language feature
has [SDK constraints][] that are too low.
For example, consider a package that uses set literals (2.2)
but has the SDK constraints `">=2.0.0 <3.0.0"`.
People using Dart 2.0.0 or 2.1.0 can download the package,
but their tools can't understand the set literals.

With language versioning,
a single Dart SDK simultaneously supports
multiple different versions of the Dart language.
When you compile some Dart code,
Dart figures out what version the code is targeting,
and you're warned if the code uses a feature
that was introduced after the version in the lower SDK constraint.

On rare occasions, Dart introduces a
backwards-incompatible feature like [null safety][].
Previously valid code might not work with null safety,
so to get the benefits of null safety you'll need to migrate your code.
And because migrating to null safety can't be completely automated,
you'll need to be able to migrate one library
(usually one Dart file) at a time.

{% comment %}
  Once /null-safety/migrating-to-null-safety exists,
  the previous paragraph should link to it.
{% endcomment %}

To enable file-by-file migration,
Dart 2.10 introduced **per-library language version selection**.
**[PENDING: was it really a 2.10 feature?]**
Here's how it works:

* Each package has a default language version,
  which is specified as the **lower SDK constraint** in the pubspec.

* Each Dart library can opt to have a different language version,
  specified using a comment of the following form:

  ```dart
  // @dart = <major>.<minor>
  ```
 
  For example:

  ```dart
  // Description of what's in this file.
  // @dart = 2.7
  import 'dart:math';
  ...
  ```

  The `@dart` string must be in a `//` comment
  (not `///` or `/*`),
  and it must appear before any Dart code in the file.
  Whitespace (tabs and spaces) doesn't matter,
  except within the `@dart` and version strings.
  As the example above shows,
  other comments can appear before the `@dart` comment.

  The library language version is usually lower than
  the package default language version,
  but it doesn't have to be:
  the `@dart` string can use any version up to the
  version of the Dart SDK that you're using.
 
For more information, see the
[language versioning specification][language versioning feature].

[2.8 breaking changes]: https://github.com/dart-lang/sdk/issues/40686
[calling native C code]: /guides/libraries/c-interop
[collection for]: /guides/language/language-tour#collection-operators
[collection if]: /guides/language/language-tour#collection-operators
[`dart2native`]: /tools/dart2native
[dart-tool]: /tools/dart-tool
[extension methods]: /guides/language/extension-methods
[language funnel]: https://github.com/dart-lang/language/projects/1
[language specification]: /guides/language/spec
[language tour]: /guides/language/language-tour
[language versioning feature]: https://github.com/dart-lang/language/blob/master/accepted/future-releases/language-versioning/feature-specification.md#dart-language-versioning
[migrated to Dart 2]: /dart-2
[null safety]: /null-safety
[set literals]: /guides/language/language-tour#sets
[sound type system]: /guides/language/type-system
[spread operator]: /guides/language/language-tour#spread-operator
[pub outdated]: https://dart.dev/tools/pub/cmd/pub-outdated
