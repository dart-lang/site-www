---
layout: guide
title: "Effective Dart: Style"
description: "Formatting and naming rules for consistent, readable code."

nextpage:
  url: /guides/language/effective-dart/documentation
  title: "Documentation"
prevpage:
  url: /guides/language/effective-dart/
  title: "Overview"
---

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

Classes, enums, typedefs, and type parameters should capitalize the first letter of each word
(including the first word), and use no separators.

<div class="good" markdown="1">
{% prettify dart %}
class SliderMenu { ... }

class HttpRequest { ... }

typedef bool Predicate<T>(T value);
{% endprettify %}
</div>

This even includes classes intended to be used in metadata annotations.

<div class="good">
{% prettify dart %}
class Foo {
  const Foo([arg]);
}

@Foo(anArg)
class A { ... }

@Foo()
class B { ... }
{% endprettify %}
</div>

If the annotation class's constructor takes no parameters, you might want to
create a separate `lowerCamelCase` constant for it.

<div class="good">
{% prettify dart %}
const foo = const Foo();

@foo
class C { ... }
{% endprettify %}
</div>


### DO name libraries and source files using `lowercase_with_underscores`.

Some file systems are not case-sensitive, so many projects require filenames to
be all lowercase. Using a separating character allows names to still be readable
in that form. Using underscores as the separator ensures that the name is still
a valid Dart identifier, which may be helpful if the language later supports
symbolic imports.

<div class="good">
{% prettify dart %}
library peg_parser.source_scanner;

import 'slider_menu.dart';
import 'file_system.dart';
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
library pegparser.SourceScanner;

import 'SliderMenu.dart';
import 'file-system.dart';
{% endprettify %}
</div>

Note that this guideline specifies *how* to name a library *if you choose to
name it*. It is fine to omit the library directive in a file if you want.


### DO name import prefixes using `lowercase_with_underscores`.

<div class="good">
{% prettify dart %}
import 'dart:math' as math;
import 'dart:json' as json;
import 'package:js/js.dart' as js;
import 'package:javascript_utils/javascript_utils.dart' as js_utils;
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
import 'dart:math' as Math;
import 'dart:json' as JSON;
import 'package:js/js.dart' as JS;
import 'package:javascript_utils/javascript_utils.dart' as jsUtils;
{% endprettify %}
</div>


### DO name other identifiers using `lowerCamelCase`.

Class members, top-level definitions, variables, parameters, and named
parameters should capitalize the first letter of each word *except* the first
word, and use no separators.

<div class="good">
{% prettify dart %}
var item;

HttpRequest httpRequest;

align(clearItems) {
  // ...
}
{% endprettify %}
</div>


### PREFER using `lowerCamelCase` for constant names.

In new code, use `lowerCamelCase` for constant variables, including enum values.
In existing code that uses `SCREAMING_CAPS`, you may continue to use all caps to
stay consistent.

<div class="good">
{% prettify dart %}
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = new RegExp('^([a-z]+):');

class Dice {
  static final numberGenerator = new Random();
}
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
const PI = 3.14;
const kDefaultTimeout = 1000;
final URL_SCHEME = new RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = new Random();
}
{% endprettify %}
</div>

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

<div class="good">
{% prettify dart %}
HttpConnection
uiHandler
IOStream
HttpRequest
Id
DB
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
HTTPConnection
UiHandler
IoStream
HTTPRequest
ID
Db
{% endprettify %}
</div>


## Ordering

To keep the preamble of your file tidy, we have a prescribed order that
directives should appear in. Each "section" should be separated by a blank line.


### DO place "dart:" imports before other imports.

<div class="good">
{% prettify dart %}
import 'dart:async';
import 'dart:html';

import 'package:bar/bar.dart'
import 'package:foo/foo.dart'
{% endprettify %}
</div>


### DO place "package:" imports before relative imports.

<div class="good">
{% prettify dart %}
import 'package:bar/bar.dart'
import 'package:foo/foo.dart'

import 'a.dart';
{% endprettify %}
</div>


### PREFER placing "third-party" "package:" imports before other imports.

If you have a number of "package:" imports for your own package along with other
third-party packages, place yours in a separate section after the external ones.

<div class="good">
{% prettify dart %}
import 'package:bar/bar.dart'
import 'package:foo/foo.dart'

import 'package:myapp/io.dart';
import 'package:myapp/util.dart';
{% endprettify %}
</div>


### DO specify exports in a separate section after all imports.

<div class="good">
{% prettify dart %}
import 'src/error.dart';
import 'src/string_source.dart';

export 'src/error.dart';
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
import 'src/error.dart';
export 'src/error.dart';
import 'src/string_source.dart';
{% endprettify %}
</div>


### DO sort sections alphabetically.

Most tools for editing Dart code can do this automatically for you.

<div class="good">
{% prettify dart %}
import 'package:bar/bar.dart'
import 'package:foo/bar.dart'

import 'a.dart';
import 'a/b.dart';
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
import 'package:foo/bar.dart'
import 'package:bar/bar.dart'

import 'a/b.dart';
import 'a.dart';
{% endprettify %}
</div>


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

<div class="good">
{% prettify dart %}
if (true) {
  print('sanity');
} else {
  print('opposite day!');
}
{% endprettify %}
</div>

There is one exception to this: `if` statements with no `else` clause that fit
on one line may omit the braces.

<div class="good">
{% prettify dart %}
if (arg == null) return defaultValue;
{% endprettify %}
</div>

These are typically used for "guard" code that returns or breaks if the
condition is met. But they're also fine for expressions, as long as the entire
`if` statement and the expression fit on one line.

<div class="good">
{% prettify dart %}
if (parameter == null) parameter = defaultValue;
{% endprettify %}
</div>


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

<div class="good">
{% prettify dart %}
main() {
  first(statement);
  second(statement);
}

anotherDeclaration() { ... }
{% endprettify %}
</div>


### DON'T place a space between the declared name of a method, operator, or setter and its parameter list.

<div class="good">
{% prettify dart %}
bool convertToBool(arg) { ... }
bool operator ==(other) { ... }
set contents(value) { ... }
{% endprettify %}
</div>


### DO place a space after the `operator` keyword.

<div class="good">
{% prettify dart %}
bool operator ==(other) => ...;
{% endprettify %}
</div>


### DO place spaces around binary and ternary operators.

Note that `<` and `>` are considered binary operators when used as expressions,
but not for specifying generic types. Both `is` and `is!` are considered single
binary operators. However, the `.` used to access members is not and should
*not* have spaces around it.

<div class="good">
{% prettify dart %}
average = (a + b) / 2;
largest = a > b ? a : b;
if (obj is! SomeType) print('not SomeType');
optional([parameter = defaultValue]) { ... }
{% endprettify %}
</div>


### DO place spaces after `,` and `:` when used in a map or named parameter.

<div class="good">
{% prettify dart %}
function(a, b, named: c);
[some, list, literal];
{map: literal}
{% endprettify %}
</div>


### DON'T place spaces around unary operators.

<div class="good">
{% prettify dart %}
!condition
index++
{% endprettify %}
</div>


### DO place spaces around `in`, and after each `;` in a loop.

<div class="good">
{% prettify dart %}
for (var i = 0; i < 100; i++) ...

for (final item in collection) ...
{% endprettify %}
</div>


### DO use a space after flow-control keywords.

This is unlike function and method calls, which do *not* have a space between
the name and the opening parenthesis.

<div class="good">
{% prettify dart %}
while (foo) ...

try {
  // ...
} catch (e) {
  // ...
}
{% endprettify %}
</div>


### DON'T use a space after `(`, `[`, and `{`, or before `)`, `]`, and `}`.

Also, do not use a space when using `<` and `>` for generic types.

<div class="good">
{% prettify dart %}
var numbers = <int>[1, 2, (3 + 4)];
{% endprettify %}
</div>


### DO use a space before `{` in function and method bodies.

When a `{` is used after a parameter list in a function or method, there should
be a space between it and the `)` ending the parameters.

<div class="good">
{% prettify dart %}
getEmptyFn(a) {
  return () {};
}
{% endprettify %}
</div>


### DO place the opening curly brace (`{`) on the same line as what it follows.

<div class="good">
{% prettify dart %}
class Foo {
  method() {
    if (true) {
      // ...
    } else {
      // ...
    }
  }
}
{% endprettify %}
</div>


### DO place binary operators on the preceding line in a multi-line expression.

There are valid arguments for both styles but most of our code seems to go this
way, and consistency matters most.

<div class="good">
{% prettify dart %}
var bobLikesIt = isDeepFried ||
    (hasPieCrust && !vegan) ||
    containsBacon;

bobLikes() =>
    isDeepFried || (hasPieCrust && !vegan) || containsBacon;
{% endprettify %}
</div>


### DO place ternary operators on the next line in a multi-line expression.

Also, if you break the line before one of the operators, break around both.

<div class="good">
{% prettify dart %}
return someCondition
    ? whenTrue
    : whenFalse;
{% endprettify %}
</div>


### DO place the `.` on the next line in a multi-line expression.

<div class="good">
{% prettify dart %}
someVeryLongVariable.withAVeryLongProperty
    .aMethodOnThatObject();
{% endprettify %}
</div>


### DO format constructor initialization lists with each field on its own line.

<div class="good">
{% prettify dart %}
MyClass()
    : firstField = 'some value',
      secondField = 'another',
      thirdField = 'last' {
  // ...
}
{% endprettify %}
</div>

Note that the `:` should be wrapped to the next line and indented four spaces.
Fields should all line up (so all but the first field end up indented six
spaces).


### PREFER splitting every element in a collection literal if it does not fit on one line.

This means after the opening bracket, before the closing one, and after the `,`
for each element.

<div class="good">
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
</div>


### DO indent block and collection bodies two spaces.

<div class="good">
{% prettify dart %}
if (condition) {
  print('hi');

  [
    long,
    list,
    literal
  ];
}
{% endprettify %}
</div>


### DO indent switch cases two spaces and case bodies four spaces.

<div class="good">
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
</div>


### DO indent multi-line method cascades at least two spaces.

<div class="good">
{% prettify dart %}
buffer
  ..write('Hello, ')
  ..write(name)
  ..write('!');
{% endprettify %}
</div>


### PREFER indenting continued lines with at least four spaces.

<div class="good">
{% prettify dart %}
someLongObject.aReallyLongMethodName(longArg, anotherLongArg,
    wrappedToNextLine);
{% endprettify %}
</div>

This includes `=>` as well:

<div class="good">
{% prettify dart %}
bobLikes() =>
    isDeepFried || (hasPieCrust && !vegan) || containsBacon;
{% endprettify %}
</div>

There are exceptions to this when the expression contains multi-line function or
collection literals.

<div class="good">
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
</div>

Your goal is to balance using indentation to show expression structure while
not wanting to indent large swathes of code unecessarily.

