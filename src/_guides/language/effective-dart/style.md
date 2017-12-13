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

A surprisingly important part of good code is good style. Consistent naming,
ordering, and formatting helps code that *is* the same *look* the same. It takes
advantage of the powerful pattern-matching hardware most of us have in our
ocular systems.  If we use a consistent style across the entire Dart ecosystem,
it makes it easier for all of us to learn from and contribute to each others'
code.

* TOC
{:toc}

## Identifiers

Identifiers come in three flavors in Dart.

*   `UpperCamelCase` names capitalize the first letter of each word, including
    the first.

*   `lowerCamelCase` names capitalize the first letter of each word, *except*
    the first which is always lowercase, even if it's an acronym.

*   `lowercase_with_underscores` use only lowercase letters, even for acronyms,
    and separate words with `_`.


### DO name types using `UpperCamelCase`.

Classes, enums, typedefs, and type parameters should capitalize the first letter of each word
(including the first word), and use no separators.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (type-names)" replace="/\/\*( \.\.\. )\*\//$1/g"?>
{% prettify dart %}
class SliderMenu { ... }

class HttpRequest { ... }

typedef bool Predicate<T>(T value);
{% endprettify %}

This even includes classes intended to be used in metadata annotations.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (annotation-type-names)" replace="/\/\*( \.\.\. )\*\//$1/g"?>
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
<?code-excerpt "misc/lib/effective_dart/style_good.dart (annotation-const)" replace="/\/\*( \.\.\. )\*\//$1/g"?>
{% prettify dart %}
const foo = const Foo();

@foo
class C { ... }
{% endprettify %}


### DO name libraries and source files using `lowercase_with_underscores`.

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

In new code, use `lowerCamelCase` for constant variables, including enum values.
In existing code that uses `SCREAMING_CAPS`, you may continue to use all caps to
stay consistent.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (const-names)"?>
{% prettify dart %}
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = new RegExp('^([a-z]+):');

class Dice {
  static final numberGenerator = new Random();
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_bad.dart (const-names)"?>
{% prettify dart %}
const PI = 3.14;
const kDefaultTimeout = 1000;
final URL_SCHEME = new RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = new Random();
}
{% endprettify %}

<aside class="alert alert-info" markdown="1">
  **Note:** We initially used Java's `SCREAMING_CAPS` style for constants. We
  changed because:

  *   `SCREAMING_CAPS` looks bad for many cases, particularly enum values for
      things like CSS colors.
  *   Constants are often changed to final non-const variables, which would
      necessitate a name change.
  *   The `values` property automatically defined on an enum type is const and
      lowercase.
</aside>


### DO capitalize acronyms and abbreviations longer than two letters like words.

Capitalized acronyms can be harder to read, and are ambiguous when you have
multiple adjacent acronyms. Given the name `HTTPSFTPConnection`, there's no way
to tell if that's an HTTPS FTP connection or an HTTP SFTP one.

To avoid this, acronyms and abbreviations are capitalized like regular words,
except for two-letter acronyms. (Two-letter *abbreviations* like
ID and Mr. are still capitalized like words.)

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (acronyms and abbreviations)" replace="/,//g"?>
{% prettify dart %}
HttpConnection
uiHandler
IOStream
HttpRequest
Id
DB
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_bad.dart (acronyms and abbreviations)" replace="/,//g"?>
{% prettify dart %}
HTTPConnection
UiHandler
IoStream
HTTPRequest
ID
Db
{% endprettify %}


## Ordering

To keep the preamble of your file tidy, we have a prescribed order that
directives should appear in. Each "section" should be separated by a blank line.


### DO place "dart:" imports before other imports.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (dart-import-first)" replace="/\w+\/effective_dart\///g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:html';

import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
{% endprettify %}


### DO place "package:" imports before relative imports.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (pkg-import-before-local)" replace="/\w+\/effective_dart\///g;/'foo/'util/g"?>
{% prettify dart %}
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'util.dart';
{% endprettify %}


### PREFER placing "third-party" "package:" imports before other imports.

If you have a number of "package:" imports for your own package along with other
third-party packages, place yours in a separate section after the external ones.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (third-party)" replace="/\w+\/effective_dart\///g;/(package):foo(.dart)/$1:my_package\/util$2/g"?>
{% prettify dart %}
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'package:my_package/util.dart';
{% endprettify %}


### DO specify exports in a separate section after all imports.

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

Formatting is tedious work and is particularly time-consuming during
refactoring. Fortunately, you don't have to worry about it. We provide a
sophisticated automated code formatter called [dartfmt][] that does do it for
you. The official whitespace-handling rules for Dart are *whatever
[dartfmt][] produces*.

[dartfmt]: https://github.com/dart-lang/dart_style

### AVOID lines longer than 80 characters.

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

We make an exception for strings containing URIs&mdash;mainly imports and
exports. Those can remain single-line strings even if they go over the line
limit. This makes it easier to search source files for a given path.


### DO use curly braces for all flow control structures.

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

There is one exception to this: `if` statements with no `else` clause that fit
on one line may omit the braces.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (one-line-if)"?>
{% prettify dart %}
if (arg == null) return defaultValue;
{% endprettify %}

These are typically used for "guard" code that returns or breaks if the
condition is met. But they're also fine for expressions, as long as the entire
`if` statement and the expression fit on one line.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (one-line-if-expr)"?>
{% prettify dart %}
if (parameter > limit) parameter = defaultValue;
{% endprettify %}


### DO format your code using `dartfmt`.

[dartfmt][] applies all of the following rules along with a number of other
subtle heuristics. It is faster than you and never makes mistakes. **If you
follow this rule, you can skip reading the rest of this guide.**


### DON'T use tabs.

Using spaces for formatting ensures the code looks the same in everyone's
editor. It also makes sure it looks the same when posted to blogs, or on code
sites like [GitHub](https://github.com/).

Modern editors emulate the behavior of tabs while inserting spaces, giving you
the easy editing of tabs and the consistency of spaces.


### DO place a newline after each statement or declaration.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (newline-after-decl)" replace="/\/\*( \.\.\. )\*\//$1/g"?>
{% prettify dart %}
main() {
  first(statement);
  second(statement);
}

anotherDeclaration() { ... }
{% endprettify %}


### DON'T place a space between the declared name of a method, operator, or setter and its parameter list.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (args-etc-no-spaces)" replace="/\/\*( \.\.\. )\*\//$1/g;/ellipsis/.../g"?>
{% prettify dart %}
log(arg) { ... }
bool operator ==(other) => ...;
set contents(value) { ... }
{% endprettify %}


### DO place a space after the `operator` keyword.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (space-after-operator)" replace="/\/\*( \.\.\. )\*\//$1/g;/ellipsis/.../g"?>
{% prettify dart %}
bool operator ==(other) => ...;
{% endprettify %}


### DO place spaces around binary and ternary operators.

Note that `<` and `>` are considered binary operators when used as expressions,
but not for specifying generic types. Both `is` and `is!` are considered single
binary operators. However, the `.` used to access members is not and should
*not* have spaces around it.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (bin-op)"?>
{% prettify dart %}
average = (a + b) / 2;
largest = a > b ? a : b;
if (obj is! SomeType) print('not SomeType');
{% endprettify %}


### DO place spaces after `,` and `:` when used in a map or named parameter.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (space-after-comma-etc)" replace="/([\]\}\)]),/$1/g"?>
{% prettify dart %}
function(a, b, named: c)
[some, list, literal]
{map: literal}
{% endprettify %}


### DON'T place spaces around unary operators.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (unary-op)" replace="/,//g"?>
{% prettify dart %}
!condition
index++
{% endprettify %}


### DO place spaces around `in`, and after each `;` in a loop.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (for-in-etc)" replace="/\/\*( \.\.\. )\*\//$1/g"?>
{% prettify dart %}
for (var i = 0; i < 100; i++) { ... }

for (final item in collection) { ... }
{% endprettify %}


### DO use a space after flow-control keywords.

This is unlike function and method calls, which do *not* have a space between
the name and the opening parenthesis.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (flow-keyword)" replace="/\/\*( \.\.\. )\*\//$1/g"?>
{% prettify dart %}
while (foo) { ... }

try {
  // ...
} catch (e) {
  // ...
}
{% endprettify %}


### DON'T use a space after `(`, `[`, and `{`, or before `)`, `]`, and `}`.

Also, do not use a space when using `<` and `>` for generic types.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (parentheses-etc)"?>
{% prettify dart %}
var numbers = <int>[1, 2, (3 + 4)];
{% endprettify %}


### DO use a space before `{` in function and method bodies.

When a `{` is used after a parameter list in a function or method, there should
be a space between it and the `)` ending the parameters.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (open-curly-brace-space-after)"?>
{% prettify dart %}
getEmptyFn(a) {
  return () {};
}
{% endprettify %}


### DO place the opening curly brace (`{`) on the same line as what it follows.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (open-curly-brace-same-line)" replace="/(Foo)2/$1/g"?>
{% prettify dart %}
class Foo {
  method() {
    if (someCondition) {
      // ...
    } else {
      // ...
    }
  }
}
{% endprettify %}


### DO place binary operators on the preceding line in a multi-line expression.

There are valid arguments for both styles but most of our code seems to go this
way, and consistency matters most.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (multi-bin-op)" replace="/\/\/!//g"?>
{% prettify dart %}
var bobLikesIt = isDeepFried ||
    (hasPieCrust && !vegan) ||
    containsBacon;

bobLikes() =>
    isDeepFried || (hasPieCrust && !vegan) || containsBacon;
{% endprettify %}


### DO place ternary operators on the next line in a multi-line expression.

Also, if you break the line before one of the operators, break around both.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (ternary-op)" replace="/\/\/!//g"?>
{% prettify dart %}
return someCondition
    ? whenTrue
    : whenFalse;
{% endprettify %}


### DO place the `.` on the next line in a multi-line expression.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (multi-dot)" replace="/\/\/!//g"?>
{% prettify dart %}
someVeryLongVariableName.withAVeryLongPropertyName
    .aReallyLongMethodName(args);
{% endprettify %}


### DO format constructor initialization lists with each field on its own line.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (ctr-field-init)"?>
{% prettify dart %}
MyClass()
    : firstField = 'some value',
      secondField = 'another',
      thirdField = 'last' {
  // ...
}
{% endprettify %}

Note that the `:` should be wrapped to the next line and indented four spaces.
Fields should all line up (so all but the first field end up indented six
spaces).


### PREFER splitting every element in a collection literal if it does not fit on one line.

This means after the opening bracket, before the closing one, and after the `,`
for each element.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (collection-literal)" replace="/\/\/!//g"?>
{% prettify dart %}
mapInsideList([
  {
    'a': 'b',
    'c': 'd'
  },
  {
    'a': 'b',
    'c': 'd'
  },
]);
{% endprettify %}


### DO indent block and collection bodies two spaces.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (block-and-collections)"?>
{% prettify dart %}
if (condition) {
  print('hi');
}

var compoundsWithLongNames = [
  buckminsterfullerene,
  dodecahedrane,
  olympiadane
];
{% endprettify %}


### DO indent switch cases two spaces and case bodies four spaces.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (switch)"?>
{% prettify dart %}
switch (fruit) {
  case 'apple':
    print('delish');
    break;

  case 'durian':
    print('stinky');
    break;
}
{% endprettify %}


### DO indent multi-line method cascades at least two spaces.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (cascade)" replace="/\/\/!//g"?>
{% prettify dart %}
buffer
  ..write('Hello, ')
  ..write(name)
  ..write('!');
{% endprettify %}


### PREFER indenting continued lines with at least four spaces.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (four-spaces)"?>
{% prettify dart %}
someVeryLongVariableName.aReallyLongMethodName(
    arg, anotherArg, wrappedToNextLine);
{% endprettify %}

This includes `=>` as well:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (four-spaces-for-arrow)" replace="/\/\/!//g"?>
{% prettify dart %}
bobLikes() =>
    isDeepFried || (hasPieCrust && !vegan) || containsBacon;
{% endprettify %}

There are exceptions to this when the expression contains multi-line function or
collection literals.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (exceptions-to-four-spaces)" replace="/\/\/!//g"?>
{% prettify dart %}
new Future.delayed(const Duration(seconds: 1), () {
  print('I am a callback');
});

args.addAll([
  '--mode',
  'release',
  '--checked'
]);
{% endprettify %}

Your goal is to balance using indentation to show expression structure while
not wanting to indent large swathes of code unecessarily.
