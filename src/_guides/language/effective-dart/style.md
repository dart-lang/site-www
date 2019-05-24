---
title: "Effective Dart: Style"
description: Formatting and naming rules for consistent, readable code.
nextpage:
  url: /guides/language/effective-dart/documentation
  title: Documentation
prevpage:
  url: /guides/language/effective-dart
  title: Overview
---
<?code-excerpt plaster="none"?>

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

*   `lowercase_with_underscores` use only lowercase letters, even for acronyms,
    and separate words with `_`.


### DO name types using `UpperCamelCase`.

{% include linter-rule.html rule="camel_case_types" %}

Classes, enums, typedefs, and type parameters should capitalize the first letter
of each word (including the first word), and use no separators.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (type-names)"?>
{% prettify dart %}
class SliderMenu { ... }

class HttpRequest { ... }

typedef Predicate<T> = bool Function(T value);
{% endprettify %}

This even includes classes intended to be used in metadata annotations.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (annotation-type-names)"?>
{% prettify dart %}
class Foo {
  const Foo([arg]);
}

@Foo(anArg)
class A { ... }

@Foo()
class B { ... }
{% endprettify %}

If the annotation class's constructor takes no parameters, you might want to
create a separate `lowerCamelCase` constant for it.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (annotation-const)"?>
{% prettify dart %}
const foo = Foo();

@foo
class C { ... }
{% endprettify %}

[camel_case_types]: http://dart-lang.github.io/linter/lints/camel_case_types.html
[Linter rule]: /guides/language/analysis-options#the-analysis-options-file

### DO name libraries, packages, directories, and source files using `lowercase_with_underscores`. {#do-name-libraries-and-source-files-using-lowercase_with_underscores}

{% include linter-rule.html rule1="library_names" rule2="file_names" %}
<!-- source for rules (update these if you update the guideline):
https://github.com/dart-lang/linter/blob/master/lib/src/rules/library_names.dart
https://github.com/dart-lang/linter/blob/master/lib/src/rules/file_names.dart -->

Some file systems are not case-sensitive, so many projects require filenames to
be all lowercase. Using a separating character allows names to still be readable
in that form. Using underscores as the separator ensures that the name is still
a valid Dart identifier, which may be helpful if the language later supports
symbolic imports.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart" replace="/foo\///g"?>
{% prettify dart %}
library peg_parser.source_scanner;

import 'file_system.dart';
import 'slider_menu.dart';
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart" replace="/foo\///g;/file./file-/g;/slider_menu/SliderMenu/g;/source_scanner/SourceScanner/g;/peg_parser/pegparser/g"?>
{% prettify dart %}
library pegparser.SourceScanner;

import 'file-system.dart';
import 'SliderMenu.dart';
{% endprettify %}

<aside class="alert alert-info" markdown="1">
  **Note:** This guideline specifies *how* to name a library *if you choose to
  name it*. It is fine to _omit_ the library directive in a file if you want.
</aside>


### DO name import prefixes using `lowercase_with_underscores`.

{% include linter-rule.html rule="library_prefixes" %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (import-as)" replace="/(package):examples[^']*/$1:angular_components\/angular_components/g"?>
{% prettify dart %}
import 'dart:math' as math;
import 'package:angular_components/angular_components'
    as angular_components;
import 'package:js/js.dart' as js;
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (import-as)" replace="/(package):examples[^']*/$1:angular_components\/angular_components/g;/as angular_components/as angularComponents/g;/ math/ Math/g;/as js/as JS/g"?>
{% prettify dart %}
import 'dart:math' as Math;
import 'package:angular_components/angular_components'
    as angularComponents;
import 'package:js/js.dart' as JS;
{% endprettify %}


### DO name other identifiers using `lowerCamelCase`.

{% include linter-rule.html rule="non_constant_identifier_names" %}

Class members, top-level definitions, variables, parameters, and named
parameters should capitalize the first letter of each word *except* the first
word, and use no separators.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (misc-names)"?>
{% prettify dart %}
var item;

HttpRequest httpRequest;

void align(bool clearItems) {
  // ...
}
{% endprettify %}


### PREFER using `lowerCamelCase` for constant names.

{% include linter-rule.html rule="constant_identifier_names" %}

In new code, use `lowerCamelCase` for constant variables, including enum values.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (const-names)"?>
{% prettify dart %}
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = RegExp('^([a-z]+):');

class Dice {
  static final numberGenerator = Random();
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_bad.dart (const-names)"?>
{% prettify dart %}
const PI = 3.14;
const DefaultTimeout = 1000;
final URL_SCHEME = RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = Random();
}
{% endprettify %}

You may use `SCREAMING_CAPS` for consistency with existing code,
as in the following cases:

* When adding code to a file or library that already uses `SCREAMING_CAPS`.
* When generating Dart code that's parallel to Java code —
  for example, in enumerated types generated from [protobufs.][]

<aside class="alert alert-info" markdown="1">
  **Note:** We initially used Java's `SCREAMING_CAPS` style for constants. We
  changed for a few reasons:

  *   `SCREAMING_CAPS` looks bad for many cases, particularly enum values for
      things like CSS colors.
  *   Constants are often changed to final non-const variables, which would
      necessitate a name change.
  *   The `values` property automatically defined on an enum type is const and
      lowercase.
</aside>

[protobufs.]: {{site.pub-pkg}}/protobuf


### DO capitalize acronyms and abbreviations longer than two letters like words.

Capitalized acronyms can be hard to read, and
multiple adjacent acronyms can lead to ambiguous names.
For example, given a name that starts with `HTTPSFTP`, there's no way
to tell if it's referring to HTTPS FTP or HTTP SFTP.

To avoid this, acronyms and abbreviations are capitalized like regular words,
except for two-letter acronyms. (Two-letter *abbreviations* like
ID and Mr. are still capitalized like words.)

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (acronyms and abbreviations)" replace="/,//g"?>
{% prettify dart %}
HttpConnectionInfo
uiHandler
IOStream
HttpRequest
Id
DB
{% endprettify %}

{:.bad-style}
{% prettify dart %}
HTTPConnection
UiHandler
IoStream
HTTPRequest
ID
Db
{% endprettify %}


### DON’T use prefix letters.

[Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) and
other schemes arose in the time of BCPL, when the compiler didn't do much to
help you understand your code. Because Dart can tell you the type, scope,
mutability, and other properties of your declarations, there's no reason to
encode those properties in identifier names.

{:.good-style}
{% prettify dart %}
defaultTimeout
{% endprettify %}

{:.bad-style}
{% prettify dart %}
kDefaultTimeout
{% endprettify %}


## Ordering

To keep the preamble of your file tidy, we have a prescribed order that
directives should appear in. Each "section" should be separated by a blank line.

A single linter rule handles all the ordering guidelines:
[directives_ordering.]({{ site.lints }}/directives_ordering.html)


### DO place "dart:" imports before other imports.

{% include linter-rule.html rule="directives_ordering" %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (dart-import-first)" replace="/\w+\/effective_dart\///g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:html';

import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
{% endprettify %}


### DO place "package:" imports before relative imports.

{% include linter-rule.html rule="directives_ordering" %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (pkg-import-before-local)" replace="/\w+\/effective_dart\///g;/'foo/'util/g"?>
{% prettify dart %}
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'util.dart';
{% endprettify %}


### PREFER placing external "package:" imports before other imports. {#prefer-placing-third-party-package-imports-before-other-imports}

{% include linter-rule.html rule="directives_ordering" %}

If you have a number of "package:" imports for your own package along with other
external packages, place yours in a separate section after the external ones.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (third-party)" replace="/\w+\/effective_dart\///g;/(package):foo(.dart)/$1:my_package\/util$2/g"?>
{% prettify dart %}
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'package:my_package/util.dart';
{% endprettify %}


### DO specify exports in a separate section after all imports.

{% include linter-rule.html rule="directives_ordering" %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (export)"?>
{% prettify dart %}
import 'src/error.dart';
import 'src/foo_bar.dart';

export 'src/error.dart';
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_bad.dart (export)"?>
{% prettify dart %}
import 'src/error.dart';
export 'src/error.dart';
import 'src/foo_bar.dart';
{% endprettify %}


### DO sort sections alphabetically.

{% include linter-rule.html rule="directives_ordering" %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (sorted)" replace="/\w+\/effective_dart\///g"?>
{% prettify dart %}
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'foo.dart';
import 'foo/foo.dart';
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_bad.dart (sorted)" replace="/\w+\/effective_dart\///g"?>
{% prettify dart %}
import 'package:foo/foo.dart';
import 'package:bar/bar.dart';

import 'foo/foo.dart';
import 'foo.dart';
{% endprettify %}


## Formatting

Like many languages, Dart ignores whitespace. However, *humans* don't. Having a
consistent whitespace style helps ensure that human readers see code the same
way the compiler does.


### DO format your code using `dartfmt`.

Formatting is tedious work and is particularly time-consuming during
refactoring. Fortunately, you don't have to worry about it. We provide a
sophisticated automated code formatter called [dartfmt][] that does do it for
you. We have [some documentation][dartfmt docs] on the rules it applies, but the
official whitespace-handling rules for Dart are *whatever dartfmt produces*.

The remaining formatting guidelines are for the few things dartfmt cannot fix
for you.

[dartfmt]: https://github.com/dart-lang/dart_style
[dartfmt docs]: https://github.com/dart-lang/dart_style/wiki/Formatting-Rules

### CONSIDER changing your code to make it more formatter-friendly.

The formatter does the best it can with whatever code you throw at it, but it
can't work miracles. If your code has particularly long identifiers, deeply
nested expressions, a mixture of different kinds of operators, etc. the
formatted output may still be hard to read.

When that happens, reorganize or simplify your code. Consider shortening a local
variable name or hoisting out an expression into a new local variable. In other
words, make the same kinds of modifications that you'd make if you were
formatting the code by hand and trying to make it more readable. Think of
dartfmt as a partnership where you work together, sometimes iteratively, to
produce beautiful code.


### AVOID lines longer than 80 characters.

{% include linter-rule.html rule="lines_longer_than_80_chars" %}

Readability studies show that long lines of text are harder to read because your
eye has to travel farther when moving to the beginning of the next line. This is
why newspapers and magazines use multiple columns of text.

If you really find yourself wanting lines longer than 80 characters, our
experience is that your code is likely too verbose and could be a little more
compact. The main offender is usually `VeryLongCamelCaseClassNames`. Ask
yourself, "Does each word in that type name tell me something critical or
prevent a name collision?" If not, consider omitting it.

Note that dartfmt does 99% of this for you, but the last 1% is you. It does not
split long string literals to fit in 80 columns, so you have to do that
manually.

We make an exception for URIs and file paths. When those occur in comments or
strings (usually in imports and exports), they may remain on a single line even
if they go over the line limit. This makes it easier to search source files for
a given path.


### DO use curly braces for all flow control structures.

{% include linter-rule.html rule="curly_braces_in_flow_control_structures" %}

Doing so avoids the [dangling else][] problem.

[dangling else]: http://en.wikipedia.org/wiki/Dangling_else

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (curly-braces)"?>
{% prettify dart %}
if (isWeekDay) {
  print('Bike to work!');
} else {
  print('Go dancing or read a book!');
}
{% endprettify %}

There is one exception to this: an `if` statement with no `else` clause where
the entire `if` statement and the then body all fit in one line. In that case,
you may leave off the braces if you prefer:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (one-line-if)"?>
{% prettify dart %}
if (arg == null) return defaultValue;
{% endprettify %}

If the body wraps to the next line, though, use braces:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (one-line-if-wrap)"?>
{% prettify dart %}
if (overflowChars != other.overflowChars) {
  return overflowChars < other.overflowChars;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_bad.dart (one-line-if-wrap)"?>
{% prettify dart %}
if (overflowChars != other.overflowChars)
  return overflowChars < other.overflowChars;
{% endprettify %}
