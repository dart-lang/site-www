---
title: "Effective Dart: Style"
description: Formatting and naming rules for consistent, readable code.
nextpage:
  url: /effective-dart/documentation
  title: Documentation
prevpage:
  url: /effective-dart
  title: Overview
---
<?code-excerpt plaster="none"?>
<?code-excerpt path-base="misc/lib/effective_dart"?>

A surprisingly important part of good code is good style. Consistent naming,
ordering, and formatting helps code that *is* the same *look* the same. It takes
advantage of the powerful pattern-matching hardware most of us have in our
ocular systems.  If we use a consistent style across the entire Dart ecosystem,
it makes it easier for all of us to learn from and contribute to each others'
code.

## Identifiers

Identifiers come in three flavors in Dart.

*   `UpperCamelCase` names capitalize the first letter of each word, including
    the first.

*   `lowerCamelCase` names capitalize the first letter of each word, *except*
    the first which is always lowercase, even if it's an acronym.

*   `lowercase_with_underscores` names use only lowercase letters,
    even for acronyms,
    and separate words with `_`.


### DO name types using `UpperCamelCase`

{% render 'linter-rule-mention.md', rules:'camel_case_types' %}

Classes, enum types, typedefs, and type parameters should capitalize the first
letter of each word (including the first word), and use no separators.

<?code-excerpt "style_good.dart (type-names)"?>
```dart tag=good
class SliderMenu { ... }

class HttpRequest { ... }

typedef Predicate<T> = bool Function(T value);
```

This even includes classes intended to be used in metadata annotations.

<?code-excerpt "style_good.dart (annotation-type-names)"?>
```dart tag=good
class Foo {
  const Foo([Object? arg]);
}

@Foo(anArg)
class A { ... }

@Foo()
class B { ... }
```

If the annotation class's constructor takes no parameters, you might want to
create a separate `lowerCamelCase` constant for it.

<?code-excerpt "style_good.dart (annotation-const)"?>
```dart tag=good
const foo = Foo();

@foo
class C { ... }
```

### DO name extensions using `UpperCamelCase`

{% render 'linter-rule-mention.md', rules:'camel_case_extensions' %}

Like types, [extensions][] should capitalize the first letter of each word
(including the first word),
and use no separators.

<?code-excerpt "style_good.dart (extension-names)"?>
```dart tag=good
extension MyFancyList<T> on List<T> { ... }

extension SmartIterable<T> on Iterable<T> { ... }
```

[extensions]: /language/extension-methods

<a id="do-name-libraries-and-source-files-using-lowercase_with_underscores"></a>
### DO name packages, directories, and source files using `lowercase_with_underscores` {:#do-name-packages-and-file-system-entities-using-lowercase-with-underscores}

{% render 'linter-rule-mention.md', rules:'file_names, package_names' %}

Some file systems are not case-sensitive, so many projects require filenames to
be all lowercase. Using a separating character allows names to still be readable
in that form. Using underscores as the separator ensures that the name is still
a valid Dart identifier, which may be helpful if the language later supports
symbolic imports.

```plaintext tag=good
my_package
└─ lib
   └─ file_system.dart
   └─ slider_menu.dart
```

```plaintext tag=bad
mypackage
└─ lib
   └─ file-system.dart
   └─ SliderMenu.dart
```


### DO name import prefixes using `lowercase_with_underscores`

{% render 'linter-rule-mention.md', rules:'library_prefixes' %}

<?code-excerpt "style_lib_good.dart (import-as)" replace="/(package):examples\/effective_dart\/foo.dart[^']*/$1:angular_components\/angular_components.dart/g; /(package):examples\/effective_dart\/bar.dart[^']*/$1:js\/js.dart/g"?>
```dart tag=good
import 'dart:math' as math;
import 'package:angular_components/angular_components.dart' as angular_components;
import 'package:js/js.dart' as js;
```

<?code-excerpt "style_lib_good.dart (import-as)" replace="/(package):examples\/effective_dart\/foo.dart[^']*/$1:angular_components\/angular_components.dart/g; /as angular_components/as angularComponents/g; /(package):examples\/effective_dart\/bar.dart[^']*/$1:js\/js.dart/g; / math/ Math/g;/as js/as JS/g"?>
```dart tag=bad
import 'dart:math' as Math;
import 'package:angular_components/angular_components.dart' as angularComponents;
import 'package:js/js.dart' as JS;
```


### DO name other identifiers using `lowerCamelCase`

{% render 'linter-rule-mention.md', rules:'non_constant_identifier_names' %}

Class members, top-level definitions, variables, parameters, and named
parameters should capitalize the first letter of each word *except* the first
word, and use no separators.

<?code-excerpt "style_good.dart (misc-names)"?>
```dart tag=good
var count = 3;

HttpRequest httpRequest;

void align(bool clearItems) {
  // ...
}
```


### PREFER using `lowerCamelCase` for constant names

{% render 'linter-rule-mention.md', rules:'constant_identifier_names' %}

In new code, use `lowerCamelCase` for constant variables, including enum values.

<?code-excerpt "style_good.dart (const-names)"?>
```dart tag=good
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = RegExp('^([a-z]+):');

class Dice {
  static final numberGenerator = Random();
}
```

<?code-excerpt "style_bad.dart (const-names)"?>
```dart tag=bad
const PI = 3.14;
const DefaultTimeout = 1000;
final URL_SCHEME = RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = Random();
}
```

You may use `SCREAMING_CAPS` for consistency with existing code,
as in the following cases:

* When adding code to a file or library that already uses `SCREAMING_CAPS`.
* When generating Dart code that's parallel to Java code—for example, 
  in enumerated types generated from [protobufs.][]

:::note
We initially used Java's `SCREAMING_CAPS` style for constants. We
changed for a few reasons:

*   `SCREAMING_CAPS` looks bad for many cases, particularly enum values for
    things like CSS colors.
*   Constants are often changed to final non-const variables, which would
    necessitate a name change.
*   The `values` property automatically defined on an enum type is const and
    lowercase.
:::

[protobufs.]: {{site.pub-pkg}}/protobuf


### DO capitalize acronyms and abbreviations longer than two letters like words

Capitalized acronyms can be hard to read, and
multiple adjacent acronyms can lead to ambiguous names.
For example, given a name that starts with `HTTPSFTP`, there's no way
to tell if it's referring to HTTPS FTP or HTTP SFTP.

To avoid this, acronyms and abbreviations are capitalized like regular words.

**Exception:** Two-letter *acronyms* like IO (input/output) are fully
capitalized: `IO`. On the other hand, two-letter *abbreviations* like
ID (identification) are still capitalized like regular words: `Id`.

```dart tag=good
class HttpConnection {}
class DBIOPort {}
class TVVcr {}
class MrRogers {}

var httpRequest = ...
var uiHandler = ...
var userId = ...
Id id;
```

```dart tag=bad
class HTTPConnection {}
class DbIoPort {}
class TvVcr {}
class MRRogers {}

var hTTPRequest = ...
var uIHandler = ...
var userID = ...
ID iD;
```


### PREFER using `_`, `__`, etc. for unused callback parameters

Sometimes the type signature of a callback function requires a parameter,
but the callback implementation doesn't _use_ the parameter.
In this case, it's idiomatic to name the unused parameter `_`.
If the function has multiple unused parameters, use additional
underscores to avoid name collisions: `__`, `___`, etc.

<?code-excerpt "style_good.dart (unused-callback-params)"?>
```dart tag=good
futureOfVoid.then((_) {
  print('Operation complete.');
});
```

This guideline is only for functions that are both *anonymous and local*.
These functions are usually used immediately in a context where it's
clear what the unused parameter represents.
In contrast, top-level functions and method declarations don't have that context,
so their parameters must be named so that it's clear what each parameter is for,
even if it isn't used.


### DON'T use a leading underscore for identifiers that aren't private

Dart uses a leading underscore in an identifier to mark members and top-level
declarations as private. This trains users to associate a leading underscore
with one of those kinds of declarations. They see "_" and think "private".

There is no concept of "private" for local variables, parameters, local
functions, or library prefixes. When one of those has a name that starts with an
underscore, it sends a confusing signal to the reader. To avoid that, don't use
leading underscores in those names.


### DON'T use prefix letters

[Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) and
other schemes arose in the time of BCPL, when the compiler didn't do much to
help you understand your code. Because Dart can tell you the type, scope,
mutability, and other properties of your declarations, there's no reason to
encode those properties in identifier names.

```dart tag=good
defaultTimeout
```

```dart tag=bad
kDefaultTimeout
```

### DON'T explicitly name libraries

Appending a name to the `library` directive is technically possible,
but is a legacy feature and discouraged. 

Dart generates a unique tag for each library
based on its path and filename.
Naming libraries overrides this generated URI.
Without the URI, it can be harder for tools to find
the main library file in question. 

<?code-excerpt "usage_bad.dart (library-dir)"?>
```dart tag=bad
library my_library;
```

<?code-excerpt "docs_good.dart (library-doc)"?>
```dart tag=good
/// A really great test library.
@TestOn('browser')
library;
```

## Ordering

To keep the preamble of your file tidy, we have a prescribed order that
directives should appear in. Each "section" should be separated by a blank line.

A single linter rule handles all the ordering guidelines:
[directives_ordering.](/tools/linter-rules/directives_ordering)


### DO place `dart:` imports before other imports

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (dart-import-first)" replace="/\w+\/effective_dart\///g"?>
```dart tag=good
import 'dart:async';
import 'dart:html';

import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
```


### DO place `package:` imports before relative imports

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (pkg-import-before-local)" replace="/\w+\/effective_dart\///g;/'foo/'util/g"?>
```dart tag=good
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'util.dart';
```


### DO specify exports in a separate section after all imports

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (export)"?>
```dart tag=good
import 'src/error.dart';
import 'src/foo_bar.dart';

export 'src/error.dart';
```

<?code-excerpt "style_lib_bad.dart (export)"?>
```dart tag=bad
import 'src/error.dart';
export 'src/error.dart';
import 'src/foo_bar.dart';
```


### DO sort sections alphabetically

{% render 'linter-rule-mention.md', rules:'directives_ordering' %}

<?code-excerpt "style_lib_good.dart (sorted)" replace="/\w+\/effective_dart\///g"?>
```dart tag=good
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'foo.dart';
import 'foo/foo.dart';
```

<?code-excerpt "style_lib_bad.dart (sorted)" replace="/\w+\/effective_dart\///g"?>
```dart tag=bad
import 'package:foo/foo.dart';
import 'package:bar/bar.dart';

import 'foo/foo.dart';
import 'foo.dart';
```


## Formatting

Like many languages, Dart ignores whitespace. However, *humans* don't. Having a
consistent whitespace style helps ensure that human readers see code the same
way the compiler does.


### DO format your code using `dart format`

Formatting is tedious work and is particularly time-consuming during
refactoring. Fortunately, you don't have to worry about it. We provide a
sophisticated automated code formatter called [`dart format`][] that does it for
you. We have [some documentation][dart format docs] on the rules it applies, but the
official whitespace-handling rules for Dart are *whatever `dart format` produces*.

The remaining formatting guidelines are for the few things `dart format` cannot fix
for you.

[`dart format`]: /tools/dart-format
[dart format docs]: {{site.repo.dart.org}}/dart_style/wiki/Formatting-Rules

### CONSIDER changing your code to make it more formatter-friendly

The formatter does the best it can with whatever code you throw at it, but it
can't work miracles. If your code has particularly long identifiers, deeply
nested expressions, a mixture of different kinds of operators, etc. the
formatted output may still be hard to read.

When that happens, reorganize or simplify your code. Consider shortening a local
variable name or hoisting out an expression into a new local variable. In other
words, make the same kinds of modifications that you'd make if you were
formatting the code by hand and trying to make it more readable. Think of
`dart format` as a partnership where you work together, sometimes iteratively, 
to produce beautiful code.


### AVOID lines longer than 80 characters

{% render 'linter-rule-mention.md', rules:'lines_longer_than_80_chars' %}

Readability studies show that long lines of text are harder to read because your
eye has to travel farther when moving to the beginning of the next line. This is
why newspapers and magazines use multiple columns of text.

If you really find yourself wanting lines longer than 80 characters, our
experience is that your code is likely too verbose and could be a little more
compact. The main offender is usually `VeryLongCamelCaseClassNames`. Ask
yourself, "Does each word in that type name tell me something critical or
prevent a name collision?" If not, consider omitting it.

Note that `dart format` does 99% of this for you, but the last 1% is you. 
It does not split long string literals to fit in 80 columns, 
so you have to do that manually.

**Exception:** When a URI or file path occurs in a comment or string (usually in
an import or export), it may remain whole even if it causes the line to go over
80 characters. This makes it easier to search source files for a path.

**Exception:** Multi-line strings can contain lines longer than 80 characters
because newlines are significant inside the string and splitting the lines into
shorter ones can alter the program.

<a id="do-use-curly-braces-for-all-flow-control-structures"></a>
### DO use curly braces for all flow control statements

{% render 'linter-rule-mention.md', rules:'curly_braces_in_flow_control_structures' %}

Doing so avoids the [dangling else][] problem.

[dangling else]: https://en.wikipedia.org/wiki/Dangling_else

<?code-excerpt "style_good.dart (curly-braces)"?>
```dart tag=good
if (isWeekDay) {
  print('Bike to work!');
} else {
  print('Go dancing or read a book!');
}
```

**Exception:** When you have an `if` statement with no `else` clause and the
whole `if` statement fits on one line, you can omit the braces if you prefer:

<?code-excerpt "style_good.dart (one-line-if)"?>
```dart tag=good
if (arg == null) return defaultValue;
```

If the body wraps to the next line, though, use braces:

<?code-excerpt "style_good.dart (one-line-if-wrap)"?>
```dart tag=good
if (overflowChars != other.overflowChars) {
  return overflowChars < other.overflowChars;
}
```

<?code-excerpt "style_bad.dart (one-line-if-wrap)"?>
```dart tag=bad
if (overflowChars != other.overflowChars)
  return overflowChars < other.overflowChars;
```
