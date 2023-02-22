---
title: Variables
description: Learn about variables in Dart.
---

Here’s an example of creating a variable and initializing it:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-decl)"?>
```dart
var name = 'Bob';
```

Variables store references. The variable called `name` contains a
reference to a `String` object with a value of “Bob”.

The type of the `name` variable is inferred to be `String`,
but you can change that type by specifying it.
If an object isn't restricted to a single type,
specify the `Object` type (or `dynamic` if necessary).

<?code-excerpt "misc/lib/language_tour/variables.dart (type-decl)"?>
```dart
Object name = 'Bob';
```

Another option is to explicitly declare the type that would be inferred:

<?code-excerpt "misc/lib/language_tour/variables.dart (static-types)"?>
```dart
String name = 'Bob';
```

{{site.alert.note}}
  This page follows the
  [style guide recommendation](/guides/language/effective-dart/design#types)
  of using `var`, rather than type annotations, for local variables.
{{site.alert.end}}


## Default value

Uninitialized variables that have a nullable type
have an initial value of `null`.
Even variables with numeric types are initially null,
because numbers—like everything else in Dart—are objects.

<?code-excerpt "misc/test/language_tour/variables_test.dart (var-null-init)"?>
```dart
int? lineCount;
assert(lineCount == null);
```

{{site.alert.note}}
  Production code ignores the `assert()` call. During development, on the other
  hand, <code>assert(<em>condition</em>)</code> throws an exception if
  _condition_ is false. For details, check out [Assert][].
{{site.alert.end}}

If you enable null safety, then you must initialize the values
of non-nullable variables before you use them:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-ns-init)"?>
```dart
int lineCount = 0;
```

You don't have to initialize a local variable where it's declared,
but you do need to assign it a value before it's used.
For example, the following code is valid because
Dart can detect that `lineCount` is non-null by the time
it's passed to `print()`:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-ns-flow)"?>
```dart
int lineCount;

if (weLikeToCount) {
  lineCount = countLines();
} else {
  lineCount = 0;
}

print(lineCount);
```

Top-level and class variables are lazily initialized;
the initialization code runs
the first time the variable is used.


## Late variables

The `late` modifier has two use cases:

* Declaring a non-nullable variable that's initialized after its declaration.
* Lazily initializing a variable.

Often Dart's control flow analysis can detect when a non-nullable variable
is set to a non-null value before it's used,
but sometimes analysis fails.
Two common cases are top-level variables and instance variables:
Dart often can't determine whether they're set,
so it doesn't try.

If you're sure that a variable is set before it's used,
but Dart disagrees,
you can fix the error by marking the variable as `late`:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-late-top-level)" replace="/late/[!$&!]/g"?>
```dart
[!late!] String description;

void main() {
  description = 'Feijoada!';
  print(description);
}
```

{{site.alert.warn}}
  If you fail to initialize a `late` variable,
  a runtime error occurs when the variable is used.
{{site.alert.end}}

When you mark a variable as `late` but initialize it at its declaration,
then the initializer runs the first time the variable is used.
This lazy initialization is handy in a couple of cases:

* The variable might not be needed,
  and initializing it is costly.
* You're initializing an instance variable,
  and its initializer needs access to `this`.

In the following example,
if the `temperature` variable is never used,
then the expensive `readThermometer()` function is never called:

<?code-excerpt "misc/lib/language_tour/variables.dart (var-late-lazy)" replace="/late/[!$&!]/g"?>
```dart
// This is the program's only call to readThermometer().
[!late!] String temperature = readThermometer(); // Lazily initialized.
```


## Final and const

If you never intend to change a variable, use `final` or `const`, either
instead of `var` or in addition to a type. A final variable can be set
only once; a const variable is a compile-time constant. (Const variables
are implicitly final.)

{{site.alert.note}}
  [Instance variables][] can be `final` but not `const`.
{{site.alert.end}}

Here's an example of creating and setting a `final` variable:

<?code-excerpt "misc/lib/language_tour/variables.dart (final)"?>
```dart
final name = 'Bob'; // Without a type annotation
final String nickname = 'Bobby';
```

You can't change the value of a `final` variable:

{:.fails-sa}
<?code-excerpt "misc/lib/language_tour/variables.dart (cant-assign-to-final)"?>
```dart
name = 'Alice'; // Error: a final variable can only be set once.
```

Use `const` for variables that you want to be **compile-time constants**. If
the const variable is at the class level, mark it `static const`.
Where you declare the variable, set the value to a compile-time constant
such as a number or string literal, a const
variable, or the result of an arithmetic operation on constant numbers:

<?code-excerpt "misc/lib/language_tour/variables.dart (const)"?>
```dart
const bar = 1000000; // Unit of pressure (dynes/cm2)
const double atm = 1.01325 * bar; // Standard atmosphere
```

The `const` keyword isn't just for declaring constant variables.
You can also use it to create constant _values_,
as well as to declare constructors that _create_ constant values.
Any variable can have a constant value.

<?code-excerpt "misc/lib/language_tour/variables.dart (const-vs-final)"?>
```dart
var foo = const [];
final bar = const [];
const baz = []; // Equivalent to `const []`
```

You can omit `const` from the initializing expression of a `const` declaration,
like for `baz` above. For details, see [DON’T use const redundantly][].

You can change the value of a non-final, non-const variable,
even if it used to have a `const` value:

<?code-excerpt "misc/lib/language_tour/variables.dart (reassign-to-non-final)"?>
```dart
foo = [1, 2, 3]; // Was const []
```

You can't change the value of a `const` variable:

{:.fails-sa}
<?code-excerpt "misc/lib/language_tour/variables.dart (cant-assign-to-const)"?>
```dart
baz = [42]; // Error: Constant variables can't be assigned a value.
```

You can define constants that use
[type checks and casts][] (`is` and `as`),
[collection `if`][],
and [spread operators][] (`...` and `...?`):

<?code-excerpt "misc/lib/language_tour/variables.dart (const-dart-25)"?>
```dart
const Object i = 3; // Where i is a const Object with an int value...
const list = [i as int]; // Use a typecast.
const map = {if (i is int) i: 'int'}; // Use is and collection if.
const set = {if (list is List<int>) ...list}; // ...and a spread.
```

{{site.alert.note}}
  Although a `final` object cannot be modified,
  its fields can be changed. 
  In comparison, a `const` object and its fields
  cannot be changed: they're _immutable_.
{{site.alert.end}}

For more information on using `const` to create constant values, see
[Lists][], [Maps][], and [Classes][].


[Assert]: /language/control-flow#assert
[Instance variables]: /language/classes#instance-variables
[DON’T use const redundantly]: /guides/language/effective-dart/usage#dont-use-const-redundantly
[type checks and casts]: /language/operators#type-test-operators
[collection `if`]: /language/collection-types#collection-operators
[spread operators]: /language/collection-types#spread-operators
[Lists]: /language/collection-types#lists
[Maps]: /language//collection-types#maps
[Classes]: /language/classes