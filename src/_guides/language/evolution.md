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
For example, to use null safety, which was [supported starting in 2.12][],
the `pubspec.yaml` file can have 2.12.0 as the lower constraint:

```yaml
environment:
  sdk: ">=2.12.0 <3.0.0"
```

[supported starting in 2.12]: #dart-212
[SDK constraints]: /tools/pub/pubspec#sdk-constraints
[language versioning section]: #language-versioning

{{site.alert.tip}}
  For a peek into current features being
  discussed, investigated, and added to the Dart language,
  see the [language funnel][] tracker in the Dart language GitHub repo.
{{site.alert.end}}


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
**new tool, `dart2native`,** for compiling Dart code to
native executables.
This functionality has since been folded into the [`dart compile`][] command.

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
analogous to the Flutter SDK's [`flutter` tool][].

### Dart 2.12

Dart 2.12 added support for **[sound null safety][]**.
When you opt into null safety, types in your code are non-nullable by default,
meaning that variables can’t contain null unless you say they can.
With null safety, your runtime null-dereference errors
turn into edit-time analysis errors.

In Dart 2.12, **[Dart FFI][]** graduated from beta to the stable channel.

### Dart 2.13

Dart 2.13 expanded support for **[type aliases][]** (`typedef`),
which used to work only for function types
but now work for any type.
You can use the new name created with a type alias
anywhere the original type could be used.

Dart 2.13 also improved the struct support in **[Dart FFI][]**,
adding support for inline arrays and packed structs.

## Language versioning

A single Dart SDK can simultaneously support
multiple versions of the Dart language.
The compiler determines what version the code is targeting,
and it interprets the code according to that version.

Language versioning is important on the rare occasions
when Dart introduces an incompatible feature like [null safety][].
Code that used to compile cleanly before null safety
(but perhaps crash at runtime)
might no longer compile once null safety is enabled.
Because migrating your apps and packages
— and all the packages they depend on —
to null safety might take a while,
Dart uses language versioning to support
using non-null-safe code alongside null-safe code.

{% comment %}
  Once /null-safety/migrating-to-null-safety exists,
  the previous paragraph should link to it.
{% endcomment %}

Each package has a default language version,
equal to the `<major>.<minor>` part of the
**lower SDK constraint** in the pubspec.
For example, the following entry in a `pubspec.yaml` file
indicates that this package uses the Dart 2.7 language version.

```yaml
environment:
  sdk: ">=2.7.0 <3.0.0"
```


### Language version numbers

Dart language versions are identified by a major and minor number
that match the first two components of the Dart SDK.
For example, the latest language version supported by
the 2.7.3 Dart SDK is Dart 2.7.
Each Dart SDK supports all of the language versions covered
by its major version number.
That means that the 2.7.3 Dart SDK supports language
versions 2.7, 2.6, 2.5, and so on, down to 2.0.

Deriving the language version from the SDK version
implies the following:

* Whenever a minor version of the SDK ships,
  a new language version appears.
  In practice, many of these language versions are very similar to
  and entirely compatible with previous versions.
  For example, the Dart 2.9 language is essentially identical to
  the Dart 2.8 language.

* When a patch version of the SDK ships,
  it cannot introduce any language features.
  For example, because 2.7.2 is language version 2.7,
  it must be completely compatible with 2.7.1 and 2.7.0.


### Per-library language version selection

By default, every Dart file
in a package uses the same language version —
the language version indicated by
the lower SDK constraint in the pubspec.
Sometimes, however, a Dart file
might need to use an older language version.
For example,
you might not be able to migrate all the files in a package
to null safety at the same time.

The Dart 2.8 compiler introduced support for
per-library language version selection.
A [Dart library][] can opt to have a different language version
by using a comment of the following form:

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

For more information about how language versioning works, see the
[language versioning specification][language versioning feature].

[2.8 breaking changes]: https://github.com/dart-lang/sdk/issues/40686
[calling native C code]: /guides/libraries/c-interop
[collection for]: /guides/language/language-tour#collection-operators
[collection if]: /guides/language/language-tour#collection-operators
[Dart library]: /guides/libraries/create-library-packages#organizing-a-library-package
[`dart compile`]: /tools/dart-compile
[Dart FFI]: /guides/libraries/c-interop
[dart-tool]: /tools/dart-tool
[extension methods]: /guides/language/extension-methods
[`flutter` tool]: {{site.flutter}}/docs/reference/flutter-cli
[language funnel]: https://github.com/dart-lang/language/projects/1
[language specification]: /guides/language/spec
[language tour]: /guides/language/language-tour
[language versioning feature]: https://github.com/dart-lang/language/blob/master/accepted/future-releases/language-versioning/feature-specification.md#dart-language-versioning
[migrated to Dart 2]: /dart-2
[null safety]: /null-safety
[pub outdated]: /tools/pub/cmd/pub-outdated
[set literals]: /guides/language/language-tour#sets
[sound null safety]: /null-safety
[sound type system]: /guides/language/type-system
[spread operator]: /guides/language/language-tour#spread-operator
[type aliases]: /guides/language/language-tour#typedefs
