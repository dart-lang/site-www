---
title: "Effective Dart: Usage"
description: Guidelines for using language features to write maintainable code.
nextpage:
  url: /guides/language/effective-dart/design
  title: Design
prevpage:
  url: /guides/language/effective-dart/documentation
  title: Documentation
---
<?code-excerpt replace="/([A-Z]\w*)\d\b/$1/g"?>
<?code-excerpt path-base="../null_safety_examples/misc/lib/effective_dart"?>

You can use these guidelines every day in the bodies of your Dart code. *Users*
of your library may not be able to tell that you've internalized the ideas here,
but *maintainers* of it sure will.

## Libraries

These guidelines help you compose your program out of multiple files in a
consistent, maintainable way. To keep these guidelines brief, they use "import"
to cover `import` and `export` directives. The guidelines apply equally to both.

### DO use strings in `part of` directives.

Many Dart developers avoid using `part` entirely. They find it easier to reason
about their code when each library is a single file. If you do choose to use
`part` to split part of a library out into another file, Dart requires the other
file to in turn indicate which library it's a part of. For legacy reasons, Dart
allows this `part of` directive to use the *name* of the library it's a part of.
That makes it harder for tools to physically find the main library file, and can
make it ambiguous which library the part is actually part of.

The preferred, modern syntax is to use a URI string that points directly to the
library file, just like you use in other directives. If you have some library,
`my_library.dart`, that contains:

<?code-excerpt "my_library.dart"?>
{% prettify dart tag=pre+code %}
library my_library;

part 'some/other/file.dart';
{% endprettify %}

Then the part file should look like:

{:.good}
<?code-excerpt "some/other/file.dart"?>
{% prettify dart tag=pre+code %}
part of '../../my_library.dart';
{% endprettify %}

And not:

{:.bad}
<?code-excerpt "some/other/file_2.dart"?>
{% prettify dart tag=pre+code %}
part of my_library;
{% endprettify %}

### DON'T import libraries that are inside the `src` directory of another package.

{% include linter-rule.html rule="implementation_imports" %}

The `src` directory under `lib` [is specified][package guide] to contain
libraries private to the package's own implementation. The way package
maintainers version their package takes this convention into account. They are
free to make sweeping changes to code under `src` without it being a breaking
change to the package.

[package guide]: /tools/pub/package-layout

That means that if you import some other package's private library, a minor,
theoretically non-breaking point release of that package could break your code.


### DON'T allow an import path to reach into or out of `lib`.

{% include linter-rule.html rule="avoid_relative_lib_imports" %}

A `package:` import lets you access
a library inside a package's `lib` directory
without having to worry about where the package is stored on your computer.
For this to work, you cannot have imports that require the `lib`
to be in some location on disk relative to other files.
In other words, a relative import path in a file inside `lib`
can't reach out and access a file outside of the `lib` directory,
and a library outside of `lib` can't use a relative path
to reach into the `lib` directory.
Doing either leads to confusing errors and broken programs.

For example, say your directory structure looks like this:

```text
my_package
└─ lib
   └─ api.dart
   test
   └─ api_test.dart
```

And say `api_test.dart` imports `api.dart` in two ways:

{:.bad}
{% prettify dart tag=pre+code %}
import 'package:my_package/api.dart';
import '../lib/api.dart';
{% endprettify %}

Dart thinks those are imports of two completely unrelated libraries.
To avoid confusing Dart and yourself, follow these two rules:

* Don't use `/lib/` in import paths.
* Don't use `../` to escape the `lib` directory.

Instead, when you need to reach into a package's `lib` directory
(even from the same package's `test` directory
or any other top-level directory),
use a `package:` import.

{:.good}
{% prettify dart tag=pre+code %}
import 'package:my_package/api.dart';
{% endprettify %}

A package should never reach *out* of its `lib` directory and
import libraries from other places in the package.


### PREFER relative import paths.

{% include linter-rule.html rule="prefer_relative_imports" %}

Whenever the previous rule doesn't come into play, follow this one.
When an import does *not* reach across `lib`, prefer using relative imports.
They're shorter.
For example, say your directory structure looks like this:

```text
my_package
└─ lib
   ├─ src
   │  └─ stuff.dart
   │  └─ utils.dart
   └─ api.dart
   test
   │─ api_test.dart
   └─ test_utils.dart
```

Here is how the various libraries should import each other:

**lib/api.dart:**

{:.good}
{% prettify dart tag=pre+code %}
import 'src/stuff.dart';
import 'src/utils.dart';
{% endprettify %}

**lib/src/utils.dart:**

{:.good}
{% prettify dart tag=pre+code %}
import '../api.dart';
import 'stuff.dart';
{% endprettify %}

**test/api_test.dart:**

{:.good}
{% prettify dart tag=pre+code %}
import 'package:my_package/api.dart'; // Don't reach into 'lib'.

import 'test_utils.dart'; // Relative within 'test' is fine.
{% endprettify %}


## Null


### DON'T explicitly initialize variables to `null`.

{% include linter-rule.html rule="avoid_init_to_null" %}

If a variable has a non-nullable type, Dart reports a compile error if you try
to use it before it has been definitely initialized. If the variable is
nullable, then it is implicitly initialized to `null` for you. There's no
concept of "uninitialized memory" in Dart and no need to explicitly initialize a
variable to `null` to be "safe".

{:.good}
<?code-excerpt "usage_good.dart (no-null-init)"?>
{% prettify dart tag=pre+code %}
Item? bestDeal(List<Item> cart) {
  Item? bestItem;

  for (var item in cart) {
    if (bestItem == null || item.price < bestItem.price) {
      bestItem = item;
    }
  }

  return bestItem;
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (no-null-init)" replace="/ = null/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
Item? bestDeal(List<Item> cart) {
  Item? bestItem[! = null!];

  for (var item in cart) {
    if (bestItem == null || item.price < bestItem.price) {
      bestItem = item;
    }
  }

  return bestItem;
}
{% endprettify %}


### DON'T use an explicit default value of `null`.

{% include linter-rule.html rule="avoid_init_to_null" %}

If you make a nullable parameter optional but don't give it a default value, the
language implicitly uses `null` as the default, so there's no need to write it.

{:.good}
<?code-excerpt "usage_good.dart (default-value-null)"?>
{% prettify dart tag=pre+code %}
void error([String? message]) {
  stderr.write(message ?? '\n');
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (default-value-null)"?>
{% prettify dart tag=pre+code %}
void error([String? message = null]) {
  stderr.write(message ?? '\n');
}
{% endprettify %}


### PREFER using `??` to convert `null` to a boolean value.

This rule applies when an expression can evaluate to `true`, `false`, or `null`,
and you need to pass the result to something that expects a non-nullable boolean
value. A common case is using the result of a null-aware method call as a
condition. You can "convert" `null` to `true` or `false` using `==`, but we
recommend using `??`:

{:.good}
<?code-excerpt "usage_good.dart (convert-null-aware)"?>
{% prettify dart tag=pre+code %}
// If you want null to be false:
if (optionalThing?.isEnabled ?? false) {
  print('Have enabled thing.');
}

// If you want null to be true:
if (optionalThing?.isEnabled ?? true) {
  print('Have enabled thing or nothing.');
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (convert-null-equals)"?>
{% prettify dart tag=pre+code %}
// If you want null to be false:
if (optionalThing?.isEnabled == true) {
  print('Have enabled thing.');
}

// If you want null to be true:
if (optionalThing?.isEnabled != false) {
  print('Have enabled thing or nothing.');
}
{% endprettify %}

Both operations produce the same result and do the right thing, but `??` is
preferred for three main reasons:

*   The `??` operator signals that the code has something to do with `null`.

*   The `== true` looks like a common mistake where the equality operator is
    redundant and can be removed. That's true when the boolean expression on the
    left will not produce `null`, but not when it can.

*   The `?? false` and `?? true` clearly show what value will be used when the
    expression is `null`. With `== true`, you have to think through the boolean
    logic to realize that means that a `null` gets converted to *false*.

**Exception:** Using a null-aware operator on a variable inside a condition
doesn't promote the variable to a non-nullable type. If you want the variable
to be promoted inside the body of the `if` statement, it might be better to use
an explicit `!= null` check instead of `?.` followed by `??`:

{:.good}
<?code-excerpt "usage_good.dart (null-aware-promote)"?>
{% prettify dart tag=pre+code %}
int measureMessage(String? message) {
  if (message != null && message.isNotEmpty) {
    // message is promoted to String.
    return message.length;
  }

  return 0;
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (null-aware-promote)"?>
{% prettify dart tag=pre+code %}
int measureMessage(String? message) {
  if (message?.isNotEmpty ?? false) {
    // message is not promoted to String.
    return message!.length;
  }

  return 0;
}
{% endprettify %}


### AVOID `late` variables if you need to check whether they are initialized.

Dart offers no way to tell if a `late` variable
has been initialized or assigned to.
If you access it, it either immediately runs the initializer
(if it has one) or throws an exception.
Sometimes you have some state that's lazily initialized
where `late` might be a good fit,
but you also need to be able to *tell* if the initialization has happened yet.

Although you could detect initialization by storing the state in a `late` variable
and having a separate boolean field
that tracks whether the variable has been set,
that's redundant because Dart *internally*
maintains the initialized status of the `late` variable.
Instead, it's usually clearer to make the variable non-`late` and nullable.
Then you can see if the variable has been initialized
by checking for `null`.

Of course, if `null` is a valid initialized value for the variable,
then it probably does make sense to have a separate boolean field.


### CONSIDER copying a nullable field to a local variable to enable type promotion.

Checking that a nullable variable is not equal to `null` promotes the variable
to a non-nullable type. That lets you access members on the variable and pass it
to functions expecting a non-nullable type. Unfortunately, promotion is only
sound for local variables and parameters, so fields and top-level variables
aren't promoted.

One pattern to work around this is to copy the field's value to a local
variable. Null checks on that variable do promote, so you can safely treat
it as non-nullable.

{:.good}
<?code-excerpt "usage_good.dart (copy-nullable-field)"?>
{% prettify dart tag=pre+code %}
class UploadException {
  final Response? response;

  UploadException([this.response]);

  @override
  String toString() {
    var response = this.response;
    if (response != null) {
      return 'Could not complete upload to ${response.url} '
          '(error code ${response.errorCode}): ${response.reason}.';
    }

    return 'Could not upload (no response).';
  }
}
{% endprettify %}

Copying to a local variable can be cleaner and safer than using `!` every place
the field or top-level variable is used:

{:.bad}
<?code-excerpt "usage_bad.dart (copy-nullable-field)" replace="/!\./[!!!]./g"?>
{% prettify dart tag=pre+code %}
class UploadException {
  final Response? response;

  UploadException([this.response]);

  @override
  String toString() {
    if (response != null) {
      return 'Could not complete upload to ${response[!!!].url} '
          '(error code ${response[!!!].errorCode}): ${response[!!!].reason}.';
    }

    return 'Could not upload (no response).';
  }
}
{% endprettify %}

Be careful when using a local copy. If you need to write back to the field,
then make sure you do so, and don't just write to the local variable. Also, if
the field might change while the local is still in scope, then the local might
have a stale value. Sometimes it's best to simply use `!` on the field.


## Strings

Here are some best practices to keep in mind when composing strings in Dart.

### DO use adjacent strings to concatenate string literals.

{% include linter-rule.html rule="prefer_adjacent_string_concatenation" %}

If you have two string literals&mdash;not values, but the actual quoted literal
form&mdash;you do not need to use `+` to concatenate them. Just like in C and
C++, simply placing them next to each other does it. This is a good way to make
a single long string that doesn't fit on one line.

{:.good}
<?code-excerpt "usage_good.dart (adjacent-strings-literals)"?>
{% prettify dart tag=pre+code %}
raiseAlarm(
    'ERROR: Parts of the spaceship are on fire. Other '
    'parts are overrun by martians. Unclear which are which.');
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (adjacent-strings-literals)"?>
{% prettify dart tag=pre+code %}
raiseAlarm('ERROR: Parts of the spaceship are on fire. Other ' +
    'parts are overrun by martians. Unclear which are which.');
{% endprettify %}

### PREFER using interpolation to compose strings and values.

{% include linter-rule.html rule="prefer_interpolation_to_compose_strings" %}

If you're coming from other languages, you're used to using long chains of `+`
to build a string out of literals and other values. That does work in Dart, but
it's almost always cleaner and shorter to use interpolation:

{:.good}
<?code-excerpt "usage_good.dart (string-interpolation)"?>
{% prettify dart tag=pre+code %}
'Hello, $name! You are ${year - birth} years old.';
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (string-interpolation)"?>
{% prettify dart tag=pre+code %}
'Hello, ' + name + '! You are ' + (year - birth).toString() + ' y...';
{% endprettify %}

### AVOID using curly braces in interpolation when not needed.

{% include linter-rule.html rule="unnecessary_brace_in_string_interps" %}

If you're interpolating a simple identifier not immediately followed by more
alphanumeric text, the `{}` should be omitted.

{:.good}
<?code-excerpt "usage_good.dart (string-interpolation-avoid-curly)"?>
{% prettify dart tag=pre+code %}
var greeting = 'Hi, $name! I love your ${decade}s costume.';
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (string-interpolation-avoid-curly)"?>
{% prettify dart tag=pre+code %}
var greeting = 'Hi, ${name}! I love your ${decade}s costume.';
{% endprettify %}

## Collections

Out of the box, Dart supports four collection types: lists, maps, queues, and sets.
The following best practices apply to collections.

### DO use collection literals when possible.

{% include linter-rule.html rule="prefer_collection_literals" %}

Dart has three core collection types: List, Map, and Set. The Map and Set
classes have unnamed constructors like most classes do. But because these
collections are used so frequently, Dart has nicer built-in syntax for creating
them:

{:.good}
<?code-excerpt "usage_good.dart (collection-literals)"?>
{% prettify dart tag=pre+code %}
var points = <Point>[];
var addresses = <String, Address>{};
var counts = <int>{};
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (collection-literals)"?>
{% prettify dart tag=pre+code %}
var addresses = Map<String, Address>();
var counts = Set<int>();
{% endprettify %}

Note that this guideline doesn't apply to the *named* constructors for those
classes. `List.from()`, `Map.fromIterable()`, and friends all have their uses.
(The List class also has an unnamed constructor, but it is prohibited in null
safe Dart.)

Collection literals are particularly powerful in Dart
because they give you access to the [spread operator][spread]
for including the contents of other collections,
and [`if` and `for`][control] for performing control flow while
building the contents:

[spread]: /guides/language/language-tour#spread-operator
[control]: /guides/language/language-tour#collection-operators

{:.good}
<?code-excerpt "usage_good.dart (spread-etc)"?>
{% prettify dart tag=pre+code %}
var arguments = [
  ...options,
  command,
  ...?modeFlags,
  for (var path in filePaths)
    if (path.endsWith('.dart'))
      path.replaceAll('.dart', '.js')
];
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (spread-etc)"?>
{% prettify dart tag=pre+code %}
var arguments = <String>[];
arguments.addAll(options);
arguments.add(command);
if (modeFlags != null) arguments.addAll(modeFlags);
arguments.addAll(filePaths
    .where((path) => path.endsWith('.dart'))
    .map((path) => path.replaceAll('.dart', '.js')));
{% endprettify %}


### DON'T use `.length` to see if a collection is empty.

{% include linter-rule.html rule1="prefer_is_empty" rule2="prefer_is_not_empty" %}

The [Iterable][] contract does not require that a collection know its length or
be able to provide it in constant time. Calling `.length` just to see if the
collection contains *anything* can be painfully slow.

[iterable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html

Instead, there are faster and more readable getters: `.isEmpty` and
`.isNotEmpty`. Use the one that doesn't require you to negate the result.

{:.good}
<?code-excerpt "usage_good.dart (dont-use-length)"?>
{% prettify dart tag=pre+code %}
if (lunchBox.isEmpty) return 'so hungry...';
if (words.isNotEmpty) return words.join(' ');
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (dont-use-length)"?>
{% prettify dart tag=pre+code %}
if (lunchBox.length == 0) return 'so hungry...';
if (!words.isEmpty) return words.join(' ');
{% endprettify %}


### AVOID using `Iterable.forEach()` with a function literal.

{% include linter-rule.html rule="avoid_function_literals_in_foreach_calls" %}

`forEach()` functions are widely used in JavaScript because the built in
`for-in` loop doesn't do what you usually want. In Dart, if you want to iterate
over a sequence, the idiomatic way to do that is using a loop.

{:.good}
<?code-excerpt "usage_good.dart (avoid-forEach)"?>
{% prettify dart tag=pre+code %}
for (var person in people) {
  ...
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (avoid-forEach)"?>
{% prettify dart tag=pre+code %}
people.forEach((person) {
  ...
});
{% endprettify %}

Note that this guideline specifically says "function *literal*". If you want to
invoke some *already existing* function on each element, `forEach()` is fine.

{:.good}
<?code-excerpt "usage_good.dart (forEach-over-func)"?>
{% prettify dart tag=pre+code %}
people.forEach(print);
{% endprettify %}

Also note that it's always OK to use `Map.forEach()`. Maps aren't iterable, so
this guideline doesn't apply.

### DON'T use `List.from()` unless you intend to change the type of the result.

Given an Iterable, there are two obvious ways to produce a new List that
contains the same elements:

<?code-excerpt "../../test/effective_dart_test.dart (list-from-1)"?>
{% prettify dart tag=pre+code %}
var copy1 = iterable.toList();
var copy2 = List.from(iterable);
{% endprettify %}

The obvious difference is that the first one is shorter. The *important*
difference is that the first one preserves the type argument of the original
object:

{:.good}
<?code-excerpt "../../test/effective_dart_test.dart (list-from-good)"?>
{% prettify dart tag=pre+code %}
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<int>":
print(iterable.toList().runtimeType);
{% endprettify %}

{:.bad}
<?code-excerpt "../../test/effective_dart_test.dart (list-from-bad)"?>
{% prettify dart tag=pre+code %}
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<dynamic>":
print(List.from(iterable).runtimeType);
{% endprettify %}

If you *want* to change the type, then calling `List.from()` is useful:

{:.good}
<?code-excerpt "../../test/effective_dart_test.dart (list-from-3)"?>
{% prettify dart tag=pre+code %}
var numbers = [1, 2.3, 4]; // List<num>.
numbers.removeAt(1); // Now it only contains integers.
var ints = List<int>.from(numbers);
{% endprettify %}

But if your goal is just to copy the iterable and preserve its original type, or
you don't care about the type, then use `toList()`.


### DO use `whereType()` to filter a collection by type.

{% include linter-rule.html rule="prefer_iterable_whereType" %}

Let's say you have a list containing a mixture of objects, and you want to get
just the integers out of it. You could use `where()` like this:

{:.bad}
<?code-excerpt "usage_bad.dart (where-type)"?>
{% prettify dart tag=pre+code %}
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.where((e) => e is int);
{% endprettify %}

This is verbose, but, worse, it returns an iterable whose type probably isn't
what you want. In the example here, it returns an `Iterable<Object>` even though
you likely want an `Iterable<int>` since that's the type you're filtering it to.

Sometimes you see code that "corrects" the above error by adding `cast()`:

{:.bad}
<?code-excerpt "usage_bad.dart (where-type-2)"?>
{% prettify dart tag=pre+code %}
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.where((e) => e is int).cast<int>();
{% endprettify %}

That's verbose and causes two wrappers to be created, with two layers of
indirection and redundant runtime checking. Fortunately, the core library has
the [`whereType()`][where-type] method for this exact use case:

[where-type]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable/whereType.html

{:.good}
<?code-excerpt "../../test/effective_dart_test.dart (whereType)"?>
{% prettify dart tag=pre+code %}
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.whereType<int>();
{% endprettify %}

Using `whereType()` is concise, produces an [Iterable][] of the desired type,
and has no unnecessary levels of wrapping.


### DON'T use `cast()` when a nearby operation will do.

Often when you're dealing with an iterable or stream, you perform several
transformations on it. At the end, you want to produce an object with a certain
type argument. Instead of tacking on a call to `cast()`, see if one of the
existing transformations can change the type.

If you're already calling `toList()`, replace that with a call to
[`List<T>.from()`][list-from] where `T` is the type of resulting list you want.

[list-from]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List/List.from.html

{:.good}
<?code-excerpt "usage_good.dart (cast-list)"?>
{% prettify dart tag=pre+code %}
var stuff = <dynamic>[1, 2];
var ints = List<int>.from(stuff);
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (cast-list)"?>
{% prettify dart tag=pre+code %}
var stuff = <dynamic>[1, 2];
var ints = stuff.toList().cast<int>();
{% endprettify %}

If you are calling `map()`, give it an explicit type argument so that it
produces an iterable of the desired type. Type inference often picks the correct
type for you based on the function you pass to `map()`, but sometimes you need
to be explicit.

{:.good}
<?code-excerpt "usage_good.dart (cast-map)" replace="/\(n as int\)/n/g"?>
{% prettify dart tag=pre+code %}
var stuff = <dynamic>[1, 2];
var reciprocals = stuff.map<double>((n) => 1 / n);
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (cast-map)" replace="/\(n as int\)/n/g"?>
{% prettify dart tag=pre+code %}
var stuff = <dynamic>[1, 2];
var reciprocals = stuff.map((n) => 1 / n).cast<double>();
{% endprettify %}


### AVOID using `cast()`.

This is the softer generalization of the previous rule. Sometimes there is no
nearby operation you can use to fix the type of some object. Even then, when
possible avoid using `cast()` to "change" a collection's type.

Prefer any of these options instead:

*   **Create it with the right type.** Change the code where the collection is
    first created so that it has the right type.

*   **Cast the elements on access.** If you immediately iterate over the
    collection, cast each element inside the iteration.

*   **Eagerly cast using `List.from()`.** If you'll eventually access most of
    the elements in the collection, and you don't need the object to be backed
    by the original live object, convert it using `List.from()`.

    The `cast()` method returns a lazy collection that checks the element type
    on *every operation*. If you perform only a few operations on only a few
    elements, that laziness can be good. But in many cases, the overhead of lazy
    validation and of wrapping outweighs the benefits.

Here is an example of **creating it with the right type:**

{:.good}
<?code-excerpt "usage_good.dart (cast-at-create)"?>
{% prettify dart tag=pre+code %}
List<int> singletonList(int value) {
  var list = <int>[];
  list.add(value);
  return list;
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (cast-at-create)"?>
{% prettify dart tag=pre+code %}
List<int> singletonList(int value) {
  var list = []; // List<dynamic>.
  list.add(value);
  return list.cast<int>();
}
{% endprettify %}

Here is **casting each element on access:**

{:.good}
<?code-excerpt "usage_good.dart (cast-iterate)" replace="/\(n as int\)/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void printEvens(List<Object> objects) {
  // We happen to know the list only contains ints.
  for (var n in objects) {
    if ([!(n as int)!].isEven) print(n);
  }
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (cast-iterate)"?>
{% prettify dart tag=pre+code %}
void printEvens(List<Object> objects) {
  // We happen to know the list only contains ints.
  for (var n in objects.cast<int>()) {
    if (n.isEven) print(n);
  }
}
{% endprettify %}

Here is **casting eagerly using `List.from()`:**

{:.good}
<?code-excerpt "usage_good.dart (cast-from)"?>
{% prettify dart tag=pre+code %}
int median(List<Object> objects) {
  // We happen to know the list only contains ints.
  var ints = List<int>.from(objects);
  ints.sort();
  return ints[ints.length ~/ 2];
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (cast-from)"?>
{% prettify dart tag=pre+code %}
int median(List<Object> objects) {
  // We happen to know the list only contains ints.
  var ints = objects.cast<int>();
  ints.sort();
  return ints[ints.length ~/ 2];
}
{% endprettify %}

These alternatives don't always work, of course, and sometimes `cast()` is the
right answer. But consider that method a little risky and undesirable&mdash;it
can be slow and may fail at runtime if you aren't careful.


## Functions

In Dart, even functions are objects. Here are some best practices
involving functions.


### DO use a function declaration to bind a function to a name.

{% include linter-rule.html rule="prefer_function_declarations_over_variables" %}

Modern languages have realized how useful local nested functions and closures
are. It's common to have a function defined inside another one. In many cases,
this function is used as a callback immediately and doesn't need a name. A
function expression is great for that.

But, if you do need to give it a name, use a function declaration statement
instead of binding a lambda to a variable.

{:.good}
<?code-excerpt "usage_good.dart (func-decl)"?>
{% prettify dart tag=pre+code %}
void main() {
  void localFunction() {
    ...
  }
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (func-decl)"?>
{% prettify dart tag=pre+code %}
void main() {
  var localFunction = () {
    ...
  };
}
{% endprettify %}

### DON'T create a lambda when a tear-off will do.

{% include linter-rule.html rule="unnecessary_lambdas" %}

If you refer to a method on an object but omit the parentheses, Dart gives you
a "tear-off"&mdash;a closure that takes the same parameters as the method and
invokes it when you call it.

If you have a function that invokes a method with the same arguments as are
passed to it, you don't need to manually wrap the call in a lambda.

{:.good}
<?code-excerpt "usage_good.dart (use-tear-off)"?>
{% prettify dart tag=pre+code %}
names.forEach(print);
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (use-tear-off)"?>
{% prettify dart tag=pre+code %}
names.forEach((name) {
  print(name);
});
{% endprettify %}


### DO use `=` to separate a named parameter from its default value.

{% include linter-rule.html rule="prefer_equal_for_default_values" %}

For legacy reasons, Dart allows both `:` and `=` as the default value separator
for named parameters. For consistency with optional positional parameters, use
`=`.

{:.good}
<?code-excerpt "usage_good.dart (default-separator)"?>
{% prettify dart tag=pre+code %}
void insert(Object item, {int at = 0}) { ... }
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (default-separator)"?>
{% prettify dart tag=pre+code %}
void insert(Object item, {int at: 0}) { ... }
{% endprettify %}


## Variables

The following best practices describe how to best use variables in Dart.

### DO follow a consistent rule for `var` and `final` on local variables.

Most local variables shouldn't have type annotations and should be declared
using just `var` or `final`. There are two rules in wide use for when to use one
or the other:

*   Use `final` for local variables that are not reassigned and `var` for those
    that are.

*   Use `var` for all local variables, even ones that aren't reassigned. Never use
    `final` for locals. (Using `final` for fields and top-level variables is
    still encouraged, of course.)

Either rule is acceptable, but pick *one* and apply it consistently throughout
your code. That way when a reader sees `var`, they know whether it means that
the variable is assigned later in the function.


### AVOID storing what you can calculate.

When designing a class, you often want to expose multiple views into the same
underlying state. Often you see code that calculates all of those views in the
constructor and then stores them:

{:.bad}
<?code-excerpt "usage_bad.dart (calc-vs-store1)"?>
{% prettify dart tag=pre+code %}
class Circle {
  double radius;
  double area;
  double circumference;

  Circle(double radius)
      : radius = radius,
        area = pi * radius * radius,
        circumference = pi * 2.0 * radius;
}
{% endprettify %}

This code has two things wrong with it. First, it's likely wasting memory. The
area and circumference, strictly speaking, are *caches*. They are stored
calculations that we could recalculate from other data we already have. They are
trading increased memory for reduced CPU usage. Do we know we have a performance
problem that merits that trade-off?

Worse, the code is *wrong*. The problem with caches is *invalidation*&mdash;how
do you know when the cache is out of date and needs to be recalculated? Here, we
never do, even though `radius` is mutable. You can assign a different value and
the `area` and `circumference` will retain their previous, now incorrect values.

To correctly handle cache invalidation, we would need to do this:

{:.bad}
<?code-excerpt "usage_bad.dart (calc-vs-store2)"?>
{% prettify dart tag=pre+code %}
class Circle {
  double _radius;
  double get radius => _radius;
  set radius(double value) {
    _radius = value;
    _recalculate();
  }

  double _area = 0.0;
  double get area => _area;

  double _circumference = 0.0;
  double get circumference => _circumference;

  Circle(this._radius) {
    _recalculate();
  }

  void _recalculate() {
    _area = pi * _radius * _radius;
    _circumference = pi * 2.0 * _radius;
  }
}
{% endprettify %}

That's an awful lot of code to write, maintain, debug, and read. Instead, your
first implementation should be:

{:.good}
<?code-excerpt "usage_good.dart (calc-vs-store)"?>
{% prettify dart tag=pre+code %}
class Circle {
  double radius;

  Circle(this.radius);

  double get area => pi * radius * radius;
  double get circumference => pi * 2.0 * radius;
}
{% endprettify %}

This code is shorter, uses less memory, and is less error-prone. It stores the
minimal amount of data needed to represent the circle. There are no fields to
get out of sync because there is only a single source of truth.

In some cases, you may need to cache the result of a slow calculation, but only
do that after you know you have a performance problem, do it carefully, and
leave a comment explaining the optimization.


## Members

In Dart, objects have members which can be functions (methods) or data (instance
variables). The following best practices apply to an object's members.

### DON'T wrap a field in a getter and setter unnecessarily.

{% include linter-rule.html rule="unnecessary_getters_setters" %}

In Java and C#, it's common to hide all fields behind getters and setters (or
properties in C#), even if the implementation just forwards to the field. That
way, if you ever need to do more work in those members, you can without needing
to touch the callsites. This is because calling a getter method is different
than accessing a field in Java, and accessing a property isn't binary-compatible
with accessing a raw field in C#.

Dart doesn't have this limitation. Fields and getters/setters are completely
indistinguishable. You can expose a field in a class and later wrap it in a
getter and setter without having to touch any code that uses that field.

{:.good}
<?code-excerpt "usage_good.dart (dont-wrap-field)"?>
{% prettify dart tag=pre+code %}
class Box {
  var contents;
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (dont-wrap-field)"?>
{% prettify dart tag=pre+code %}
class Box {
  var _contents;
  get contents => _contents;
  set contents(value) {
    _contents = value;
  }
}
{% endprettify %}


### PREFER using a `final` field to make a read-only property.

{% include linter-rule.html rule="unnecessary_getters_setters" %}

If you have a field that outside code should be able to see but not assign to, a
simple solution that works in many cases is to simply mark it `final`.

{:.good}
<?code-excerpt "usage_good.dart (final)"?>
{% prettify dart tag=pre+code %}
class Box {
  final contents = [];
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (final)"?>
{% prettify dart tag=pre+code %}
class Box {
  var _contents;
  get contents => _contents;
}
{% endprettify %}

Of course, if you need to internally assign to the field outside of the
constructor, you may need to do the "private field, public getter" pattern, but
don't reach for that until you need to.


### CONSIDER using `=>` for simple members.

{% include linter-rule.html rule="prefer_expression_function_bodies" %}

In addition to using `=>` for function expressions, Dart also lets you define
members with it. That style is a good fit for simple members that just calculate
and return a value.

{:.good}
<?code-excerpt "usage_good.dart (use-arrow)"?>
{% prettify dart tag=pre+code %}
double get area => (right - left) * (bottom - top);

String capitalize(String name) =>
    '${name[0].toUpperCase()}${name.substring(1)}';
{% endprettify %}

People *writing* code seem to love `=>`, but it's very easy to abuse it and end
up with code that's hard to *read*. If your declaration is more than a couple of
lines or contains deeply nested expressions&mdash;cascades and conditional
operators are common offenders&mdash;do yourself and everyone who has to read
your code a favor and use a block body and some statements.

{:.good}
<?code-excerpt "usage_good.dart (arrow-long)"?>
{% prettify dart tag=pre+code %}
Treasure? openChest(Chest chest, Point where) {
  if (_opened.containsKey(chest)) return null;

  var treasure = Treasure(where);
  treasure.addAll(chest.contents);
  _opened[chest] = treasure;
  return treasure;
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (arrow-long)"?>
{% prettify dart tag=pre+code %}
Treasure? openChest(Chest chest, Point where) => _opened.containsKey(chest)
    ? null
    : _opened[chest] = (Treasure(where)..addAll(chest.contents));
{% endprettify %}

You can also use `=>` on members that don't return a value. This is idiomatic
when a setter is small and has a corresponding getter that uses `=>`.

{:.good}
<?code-excerpt "usage_good.dart (arrow-setter)"?>
{% prettify dart tag=pre+code %}
num get x => center.x;
set x(num value) => center = Point(value, center.y);
{% endprettify %}


### DON'T use `this.` except to redirect to a named constructor or to avoid shadowing. {#dont-use-this-when-not-needed-to-avoid-shadowing}

{% include linter-rule.html rule="unnecessary_this" %}

JavaScript requires an explicit `this.` to refer to members on the object whose
method is currently being executed, but Dart&mdash;like C++, Java, and
C#&mdash;doesn't have that limitation.

There are only two times you need to use `this.`. One is when a local variable
with the same name shadows the member you want to access:

{:.bad}
<?code-excerpt "usage_bad.dart (this-dot)"?>
{% prettify dart tag=pre+code %}
class Box {
  var value;

  void clear() {
    this.update(null);
  }

  void update(value) {
    this.value = value;
  }
}
{% endprettify %}

{:.good}
<?code-excerpt "usage_good.dart (this-dot)"?>
{% prettify dart tag=pre+code %}
class Box {
  var value;

  void clear() {
    update(null);
  }

  void update(value) {
    this.value = value;
  }
}
{% endprettify %}

The other time to use `this.` is when redirecting to a named constructor:

{:.bad}
<?code-excerpt "usage_bad.dart (this-dot-constructor)"?>
{% prettify dart tag=pre+code %}
class ShadeOfGray {
  final int brightness;

  ShadeOfGray(int val) : brightness = val;

  ShadeOfGray.black() : this(0);

  // This won't parse or compile!
  // ShadeOfGray.alsoBlack() : black();
}
{% endprettify %}

{:.good}
<?code-excerpt "usage_good.dart (this-dot-constructor)"?>
{% prettify dart tag=pre+code %}
class ShadeOfGray {
  final int brightness;

  ShadeOfGray(int val) : brightness = val;

  ShadeOfGray.black() : this(0);

  // But now it will!
  ShadeOfGray.alsoBlack() : this.black();
}
{% endprettify %}

Note that constructor parameters never shadow fields in constructor initializer
lists:

{:.good}
<?code-excerpt "usage_good.dart (param-dont-shadow-field-ctr-init)"?>
{% prettify dart tag=pre+code %}
class Box extends BaseBox {
  var value;

  Box(value)
      : value = value,
        super(value);
}
{% endprettify %}

This looks surprising, but works like you want. Fortunately, code like this is
relatively rare thanks to initializing formals.


### DO initialize fields at their declaration when possible.

If a field doesn't depend on any constructor parameters, it can and should be
initialized at its declaration. It takes less code and avoids duplication when
the class has multiple constructors.

{:.bad}
<?code-excerpt "usage_bad.dart (field-init-at-decl)"?>
{% prettify dart tag=pre+code %}
class ProfileMark {
  final String name;
  final DateTime start;

  ProfileMark(this.name) : start = DateTime.now();
  ProfileMark.unnamed()
      : name = '',
        start = DateTime.now();
}
{% endprettify %}

{:.good}
<?code-excerpt "usage_good.dart (field-init-at-decl)"?>
{% prettify dart tag=pre+code %}
class ProfileMark {
  final String name;
  final DateTime start = DateTime.now();

  ProfileMark(this.name);
  ProfileMark.unnamed() : name = '';
}
{% endprettify %}

Some fields can't be initialized at their declarations because they need to reference
`this` — to use other fields or call methods, for example. However, if the
field is marked `late`, then the initializer *can* access `this`.

Of course, if a field depends on constructor parameters, or is initialized
differently by different constructors, then this guideline does not apply.


## Constructors

The following best practices apply to declaring constructors for a class.

### DO use initializing formals when possible.

{% include linter-rule.html rule="prefer_initializing_formals" %}

Many fields are initialized directly from a constructor parameter, like:

{:.bad}
<?code-excerpt "usage_bad.dart (field-init-as-param)"?>
{% prettify dart tag=pre+code %}
class Point {
  double x, y;
  Point(double x, double y)
      : x = x,
        y = y;
}
{% endprettify %}

We've got to type `x` _four_ times here to define a field. We can do better:

{:.good}
<?code-excerpt "usage_good.dart (field-init-as-param)"?>
{% prettify dart tag=pre+code %}
class Point {
  double x, y;
  Point(this.x, this.y);
}
{% endprettify %}

This `this.` syntax before a constructor parameter is called an "initializing
formal". You can't always take advantage of it. Sometimes you want to have a
named parameter whose name doesn't match the name of the field you are
initializing. But when you *can* use initializing formals, you *should*.


### DON'T use `late` when a constructor initializer list will do.

Sound null safety requires Dart to ensure that a non-nullable field is
initialized before it can be read. Since fields can be read inside the
constructor body, this means you get an error if you don't initialize a
non-nullable field before the body runs.

You can make this error go away by marking the field `late`. That turns the
compile-time error into a *runtime* error if you access the field before it is
initialized. That's what you need in some cases, but often the right fix is to
initialize the field in the constructor initializer list:

{:.good}
<?code-excerpt "usage_good.dart (late-init-list)"?>
{% prettify dart tag=pre+code %}
class Point {
  double x, y;
  Point.polar(double theta, double radius)
      : x = cos(theta) * radius,
        y = sin(theta) * radius;
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (late-init-list)"?>
{% prettify dart tag=pre+code %}
class Point {
  late double x, y;
  Point.polar(double theta, double radius) {
    x = cos(theta) * radius;
    y = sin(theta) * radius;
  }
}
{% endprettify %}


The initializer list gives you access to constructor parameters and lets you
initialize fields before they can be read. So, if it's possible to use an initializer list,
that's better than making the field `late` and losing some static safety and
performance.


### DO use `;` instead of `{}` for empty constructor bodies.

{% include linter-rule.html rule="empty_constructor_bodies" %}

In Dart, a constructor with an empty body can be terminated with just a
semicolon. (In fact, it's required for const constructors.)

{:.good}
<?code-excerpt "usage_good.dart (semicolon-for-empty-body)"?>
{% prettify dart tag=pre+code %}
class Point {
  double x, y;
  Point(this.x, this.y);
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (semicolon-for-empty-body)"?>
{% prettify dart tag=pre+code %}
class Point {
  double x, y;
  Point(this.x, this.y) {}
}
{% endprettify %}

### DON'T use `new`.

{% include linter-rule.html rule="unnecessary_new" %}

Dart 2 makes the `new` keyword optional. Even in Dart 1, its meaning was never
clear because factory constructors mean a `new` invocation may still not
actually return a new object.

The language still permits `new` in order to make migration less painful, but
consider it deprecated and remove it from your code.

{:.good}
<?code-excerpt "usage_good.dart (no-new)"?>
{% prettify dart tag=pre+code %}
Widget build(BuildContext context) {
  return Row(
    children: [
      RaisedButton(
        child: Text('Increment'),
      ),
      Text('Click!'),
    ],
  );
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (no-new)" replace="/new/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
Widget build(BuildContext context) {
  return [!new!] Row(
    children: [
      [!new!] RaisedButton(
        child: [!new!] Text('Increment'),
      ),
      [!new!] Text('Click!'),
    ],
  );
}
{% endprettify %}


### DON'T use `const` redundantly.

{% include linter-rule.html rule="unnecessary_const" %}

In contexts where an expression *must* be constant, the `const` keyword is
implicit, doesn't need to be written, and shouldn't. Those contexts are any
expression inside:

* A const collection literal.
* A const constructor call
* A metadata annotation.
* The initializer for a const variable declaration.
* A switch case expression&mdash;the part right after `case` before the `:`, not
  the body of the case.

(Default values are not included in this list because future versions of Dart
may support non-const default values.)

Basically, any place where it would be an error to write `new` instead of
`const`, Dart 2 allows you to omit the `const`.

{:.good}
<?code-excerpt "usage_good.dart (no-const)"?>
{% prettify dart tag=pre+code %}
const primaryColors = [
  Color('red', [255, 0, 0]),
  Color('green', [0, 255, 0]),
  Color('blue', [0, 0, 255]),
];
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (no-const)" replace="/ (const)/ [!$1!]/g"?>
{% prettify dart tag=pre+code %}
const primaryColors = [!const!] [
  [!const!] Color('red', [!const!] [255, 0, 0]),
  [!const!] Color('green', [!const!] [0, 255, 0]),
  [!const!] Color('blue', [!const!] [0, 0, 255]),
];
{% endprettify %}

## Error handling

Dart uses exceptions when an error occurs in your program. The following
best practices apply to catching and throwing exceptions.

### AVOID catches without `on` clauses.

{% include linter-rule.html rule="avoid_catches_without_on_clauses" %}

A catch clause with no `on` qualifier catches *anything* thrown by the code in
the try block. [Pokémon exception handling][pokemon] is very likely not what you
want. Does your code correctly handle [StackOverflowError][] or
[OutOfMemoryError][]? If you incorrectly pass the wrong argument to a method in
that try block do you want to have your debugger point you to the mistake or
would you rather that helpful [ArgumentError][] get swallowed? Do you want any
`assert()` statements inside that code to effectively vanish since you're
catching the thrown [AssertionError][]s?

The answer is probably "no", in which case you should filter the types you
catch. In most cases, you should have an `on` clause that limits you to the
kinds of runtime failures you are aware of and are correctly handling.

In rare cases, you may wish to catch any runtime error. This is usually in
framework or low-level code that tries to insulate arbitrary application code
from causing problems. Even here, it is usually better to catch [Exception][]
than to catch all types. Exception is the base class for all *runtime* errors
and excludes errors that indicate *programmatic* bugs in the code.


### DON'T discard errors from catches without `on` clauses.

If you really do feel you need to catch *everything* that can be thrown from a
region of code, *do something* with what you catch. Log it, display it to the
user or rethrow it, but do not silently discard it.


### DO throw objects that implement `Error` only for programmatic errors.

The [Error][] class is the base class for *programmatic* errors. When an object
of that type or one of its subinterfaces like [ArgumentError][] is thrown, it
means there is a *bug* in your code. When your API wants to report to a caller
that it is being used incorrectly throwing an Error sends that signal clearly.

Conversely, if the exception is some kind of runtime failure that doesn't
indicate a bug in the code, then throwing an Error is misleading. Instead, throw
one of the core Exception classes or some other type.


### DON'T explicitly catch `Error` or types that implement it.

{% include linter-rule.html rule="avoid_catching_errors" %}

This follows from the above. Since an Error indicates a bug in your code, it
should unwind the entire callstack, halt the program, and print a stack trace so
you can locate and fix the bug.

Catching errors of these types breaks that process and masks the bug. Instead of
*adding* error-handling code to deal with this exception after the fact, go back
and fix the code that is causing it to be thrown in the first place.


### DO use `rethrow` to rethrow a caught exception.

{% include linter-rule.html rule="use_rethrow_when_possible" %}

If you decide to rethrow an exception, prefer using the `rethrow` statement
instead of throwing the same exception object using `throw`.
`rethrow` preserves the original stack trace of the exception. `throw` on the
other hand resets the stack trace to the last thrown position.

{:.bad}
<?code-excerpt "usage_bad.dart (rethrow)"?>
{% prettify dart tag=pre+code %}
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) throw e;
  handle(e);
}
{% endprettify %}

{:.good}
<?code-excerpt "usage_good.dart (rethrow)" replace="/rethrow/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) [!rethrow!];
  handle(e);
}
{% endprettify %}


## Asynchrony

Dart has several language features to support asynchronous programming.
The following best practices apply to asynchronous coding.

### PREFER async/await over using raw futures.

Asynchronous code is notoriously hard to read and debug, even when using a nice
abstraction like futures. The `async`/`await` syntax improves readability and
lets you use all of the Dart control flow structures within your async code.

{:.good}
<?code-excerpt "usage_good.dart (async-await)" replace="/async|await/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
Future<int> countActivePlayers(String teamName) [!async!] {
  try {
    var team = [!await!] downloadTeam(teamName);
    if (team == null) return 0;

    var players = [!await!] team.roster;
    return players.where((player) => player.isActive).length;
  } catch (e) {
    log.error(e);
    return 0;
  }
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (async-await)"?>
{% prettify dart tag=pre+code %}
Future<int> countActivePlayers(String teamName) {
  return downloadTeam(teamName).then((team) {
    if (team == null) return Future.value(0);

    return team.roster.then((players) {
      return players.where((player) => player.isActive).length;
    });
  }).catchError((e) {
    log.error(e);
    return 0;
  });
}
{% endprettify %}

### DON'T use `async` when it has no useful effect.

It's easy to get in the habit of using `async` on any function that does
anything related to asynchrony. But in some cases, it's extraneous. If you can
omit the `async` without changing the behavior of the function, do so.

{:.good}
<?code-excerpt "usage_good.dart (unnecessary-async)"?>
{% prettify dart tag=pre+code %}
Future<int> fastestBranch(
    Future<int> left, Future<int> right) {
  return Future.any([left, right]);
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (unnecessary-async)"?>
{% prettify dart tag=pre+code %}
Future<int> fastestBranch(Future<int> left, Future<int> right) async {
  return Future.any([left, right]);
}
{% endprettify %}

Cases where `async` *is* useful include:

* You are using `await`. (This is the obvious one.)

* You are returning an error asynchronously. `async` and then `throw` is shorter
  than `return Future.error(...)`.

* You are returning a value and you want it implicitly wrapped in a future.
  `async` is shorter than `Future.value(...)`.

{:.good}
<?code-excerpt "usage_good.dart (async)"?>
{% prettify dart tag=pre+code %}
Future<void> usesAwait(Future<String> later) async {
  print(await later);
}

Future<void> asyncError() async {
  throw 'Error!';
}

Future<void> asyncValue() async => 'value';
{% endprettify %}

### CONSIDER using higher-order methods to transform a stream.

This parallels the above suggestion on iterables. Streams support many of the
same methods and also handle things like transmitting errors, closing, etc.
correctly.

### AVOID using Completer directly.

Many people new to asynchronous programming want to write code that produces a
future. The constructors in Future don't seem to fit their need so they
eventually find the Completer class and use that.

{:.bad}
<?code-excerpt "usage_bad.dart (avoid-completer)"?>
{% prettify dart tag=pre+code %}
Future<bool> fileContainsBear(String path) {
  var completer = Completer<bool>();

  File(path).readAsString().then((contents) {
    completer.complete(contents.contains('bear'));
  });

  return completer.future;
}
{% endprettify %}

Completer is needed for two kinds of low-level code: new asynchronous
primitives, and interfacing with asynchronous code that doesn't use futures.
Most other code should use async/await or [`Future.then()`][then], because
they're clearer and make error handling easier.

[then]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future/then.html

{:.good}
<?code-excerpt "usage_good.dart (avoid-completer)"?>
{% prettify dart tag=pre+code %}
Future<bool> fileContainsBear(String path) {
  return File(path).readAsString().then((contents) {
    return contents.contains('bear');
  });
}
{% endprettify %}

{:.good}
<?code-excerpt "usage_good.dart (avoid-completer-alt)"?>
{% prettify dart tag=pre+code %}
Future<bool> fileContainsBear(String path) async {
  var contents = await File(path).readAsString();
  return contents.contains('bear');
}
{% endprettify %}


### DO test for `Future<T>` when disambiguating a `FutureOr<T>` whose type argument could be `Object`.

Before you can do anything useful with a `FutureOr<T>`, you typically need to do
an `is` check to see if you have a `Future<T>` or a bare `T`. If the type
argument is some specific type as in `FutureOr<int>`, it doesn't matter which
test you use, `is int` or `is Future<int>`. Either works because those two types
are disjoint.

However, if the value type is `Object` or a type parameter that could possibly
be instantiated with `Object`, then the two branches overlap. `Future<Object>`
itself implements `Object`, so `is Object` or `is T` where `T` is some type
parameter that could be instantiated with `Object` returns true even when the
object is a future. Instead, explicitly test for the `Future` case:

{:.good}
<?code-excerpt "usage_good.dart (test-future-or)"?>
{% prettify dart tag=pre+code %}
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is Future<T>) {
    var result = await value;
    print(result);
    return result;
  } else {
    print(value);
    return value;
  }
}
{% endprettify %}

{:.bad}
<?code-excerpt "usage_bad.dart (test-future-or)"?>
{% prettify dart tag=pre+code %}
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is T) {
    print(value);
    return value;
  } else {
    var result = await value;
    print(result);
    return result;
  }
}
{% endprettify %}

In the bad example, if you pass it a `Future<Object>`, it incorrectly treats it
like a bare, synchronous value.

[pokemon]: https://blog.codinghorror.com/new-programming-jargon/
[Error]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Error-class.html
[StackOverflowError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/StackOverflowError-class.html
[OutOfMemoryError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/OutOfMemoryError-class.html
[ArgumentError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/ArgumentError-class.html
[AssertionError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/AssertionError-class.html
[Exception]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Exception-class.html
