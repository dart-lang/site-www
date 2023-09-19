---
title: Dart cheatsheet codelab
description: Interactively learn (or relearn) some of Dart's unique features.
js: [{url: 'https://dartpad.dev/inject_embed.dart.js', defer: true}]
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>

The Dart language is designed to be easy to learn for
coders coming from other languages,
but it has a few unique features.
This codelab—which is based on a
[Dart language cheatsheet](/guides/language/cheatsheet)
written by and for Google engineers—walks you through
the most important of these language features.

The embedded editors in this codelab have partially completed code snippets.
You can use these editors to test your knowledge by completing the code and
clicking the **Run** button.
If you need help, click the **Hint** button.
To run the code formatter ([dart format](/tools/dart-format)), click **Format**.
The **Reset** button erases your work and
restores the editor to its original state.

{{site.alert.note}}
  This page uses embedded DartPads to display runnable examples.
  {% include dartpads-embedded-troubleshooting.md %}
{{site.alert.end}}

## String interpolation

To put the value of an expression inside a string, use `${expression}`.
If the expression is an identifier, you can omit the `{}`.

Here are some examples of using string interpolation:

<div class="table-wrapper" markdown="1">
| String                      | | Result |
|-----------------------------+-+ -------|
| `'${3 + 2}'`                | | `'5'` |
| `'${"word".toUpperCase()}'` | | `'WORD'` |
| `'$myObject'`               | | The value of `myObject.toString()` |

</div>

### Code example
{: .no_toc}

The following function takes two integers as parameters.
Make it return a string containing both integers separated by a space.
For example, `stringify(2, 3)` should return `'2 3'`.

```dart:run-dartpad:ga_id-string_interpolation
{$ begin main.dart $}
String stringify(int x, int y) {
  TODO('Return a formatted string here');
}
{$ end main.dart $}
{$ begin solution.dart $}
String stringify(int x, int y) {
  return '$x $y';
}
{$ end solution.dart $}
{$ begin test.dart $}

void main() {
  try {
    final str = stringify(2, 3); 

    if (str == '2 3') {
      _result(true);
    } else if (str == '23') {
      _result(false, ['Test failed. It looks like you forgot the space!']);
    } else {
      _result(false, ['That\'s not quite right. Keep trying!']);
    }
  } on UnimplementedError {
    _result(false, ['Test failed. Did you implement the method?']);
  } catch (e) {
    _result(false, ['Tried calling stringify(2, 3), but received an exception: ${e.runtimeType}']);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
Both x and y are simple values,
and Dart's string interpolation will handle
converting them to string representations.
All you need to do is use the $ operator to
reference them inside single quotes, with a space in between.
{$ end hint.txt $}
```

## Nullable variables

Dart enforces sound null safety.
This means values can't be null unless you say they can be.
In other words, types default to non-nullable.

For example, consider the following code.
With null safety, this code returns an error.
A variable of type `int` can't have the value `null`:

<?code-excerpt "misc/bin/cheatsheet/nullable.dart (invalid-null)" replace="/null;/[!null!];/g"?>
```dart
int a = [!null!]; // INVALID.
```

When creating a variable, add `?` to the type to indicate
that the variable can be `null`:

<?code-excerpt "misc/bin/cheatsheet/nullable.dart (valid-null)" replace="/int\?/[!int?!]/g"?>
```dart
[!int?!] a = null; // Valid.
```

You can simplify that code a bit because, in all versions of Dart,
`null` is the default value for uninitialized variables:

<?code-excerpt "misc/bin/cheatsheet/nullable.dart (simple-null)"?>
```dart
int? a; // The initial value of a is null.
```

To learn more about null safety in Dart,
read the [sound null safety guide](/null-safety).


### Code example
{: .no_toc}

Try to declare two variables below:
- A nullable `String` named `name` with the value `'Jane'`.
- A nullable `String` named `address` with the value `null`.

Ignore all initial errors in the DartPad.

```dart:run-dartpad:ga_id-nullable_variables
{$ begin main.dart $}
// Declare the two variables here
{$ end main.dart $}
{$ begin solution.dart $}
String? name = 'Jane';
String? address;
{$ end solution.dart $}
{$ begin test.dart $}

void main() {
  try {
    if (name == 'Jane' && address == null) {
      // verify that "name" is nullable
      name = null;
      _result(true);
    } else {
      _result(false, ['That\'s not quite right. Keep trying!']);
    }
  } catch (e) {
    _result(false, ['Tried calling stringify(2, 3), but received an exception: ${e.runtimeType}']);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
Declare the two variables as "String" followed by "?".
Then, assign "Jane" to "name"
and leave "address" uninitialized.
{$ end hint.txt $}
```


## Null-aware operators

Dart offers some handy operators for dealing with values that might be null. One is the
`??=` assignment operator, which assigns a value to a variable only if that
variable is currently null:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (null-aware-operators)"?>
```dart
int? a; // = null
a ??= 3;
print(a); // <-- Prints 3.

a ??= 5;
print(a); // <-- Still prints 3.
```

Another null-aware operator is `??`,
which returns the expression on its left unless
that expression's value is null,
in which case it evaluates and returns the expression on its right:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (null-aware-operators-2)"?>
```dart
print(1 ?? 3); // <-- Prints 1.
print(null ?? 12); // <-- Prints 12.
```

### Code example
{: .no_toc}

Try substituting in the `??=` and `??` operators
to implement the described behavior in the following snippet.

Ignore all initial errors in the DartPad.

```dart:run-dartpad:height-255px:ga_id-null_aware
{$ begin main.dart $}
String? foo = 'a string';
String? bar; // = null

// Substitute an operator that makes 'a string' be assigned to baz.
String? baz = foo /* TODO */ bar;

void updateSomeVars() {
  // Substitute an operator that makes 'a string' be assigned to bar.
  bar /* TODO */ 'a string';
}
{$ end main.dart $}
{$ begin solution.dart $}
String? foo = 'a string';
String? bar; // = null

// Substitute an operator that makes 'a string' be assigned to baz.
String? baz = foo ?? bar;

void updateSomeVars() {
  // Substitute an operator that makes 'a string' be assigned to bar.
  bar ??= 'a string';
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final errs = <String>[];
  
  try {
    updateSomeVars();
    
    if (foo != 'a string') {
      errs.add('Looks like foo somehow ended up with the wrong value.');
    } else if (bar != 'a string') {
      errs.add('Looks like bar ended up with the wrong value.');
    } else if (baz != 'a string') {
      errs.add('Looks like baz ended up with the wrong value.');
    }
  } catch (e) {
    errs.add('Tried calling updateSomeVars and received an exception: ${e.runtimeType}.');
  }
  
  if (errs.isEmpty) {
   _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
All you need to do in this exercise is
replace the TODO comments with either ?? or ??=.
Read the codelab text to make sure you understand both,
and then give it a try.
{$ end hint.txt $}
```


## Conditional property access

To guard access to a property or method of an object that might be null,
put a question mark (`?`) before the dot (`.`):

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (conditional-property-access)" replace="/result = //g; /;//g;"?>
```dart
myObject?.someProperty
```

The preceding code is equivalent to the following:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (conditional-property-access-equivalent)" replace="/result = //g; /;//g;"?>
```dart
(myObject != null) ? myObject.someProperty : null
```

You can chain multiple uses of `?.` together in a single expression:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (conditional-property-access-multiple)" replace="/result = //g; /;//g;"?>
```dart
myObject?.someProperty?.someMethod()
```

The preceding code returns null (and never calls `someMethod()`) if either
`myObject` or `myObject.someProperty` is
null.


### Code example
{: .no_toc}

Try using conditional property access to finish the code snippet below.

```dart:run-dartpad:ga_id-conditional-property_access
{$ begin main.dart $}
// This method should return the uppercase version of `str`
// or null if `str` is null.
String? upperCaseIt(String? str) {
  // Try conditionally accessing the `toUpperCase` method here.
}
{$ end main.dart $}
{$ begin solution.dart $}
// This method should return the uppercase version of `str`
// or null if `str` is null.
String? upperCaseIt(String? str) {
  return str?.toUpperCase();
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final errs = <String>[];
  
  try {
    String? one = upperCaseIt(null);

    if (one != null) {
      errs.add('Looks like you\'re not returning null for null inputs.');
    }
  } catch (e) {
    errs.add('Tried calling upperCaseIt(null) and got an exception: ${e.runtimeType}.');
  }
  
  try {
    String? two = upperCaseIt('asdf');

    if (two == null) {
      errs.add('Looks like you\'re returning null even when str has a value.');
    } else if (two != 'ASDF') {
      errs.add('Tried upperCaseIt(\'asdf\'), but didn\'t get \'ASDF\' in response.');
    }
  } catch (e) {
    errs.add('Tried calling upperCaseIt(\'asdf\') and got an exception: ${e.runtimeType}.');
  }
  
  if (errs.isEmpty) {
   _result(true);
  } else {
   _result(false, errs);
  }  
}
{$ end test.dart $}
{$ begin hint.txt $}
If this exercise wanted you to conditionally lowercase a string,
you could do it like this: str?.toLowerCase()
{$ end hint.txt $}
```


## Collection literals

Dart has built-in support for lists, maps, and sets.
You can create them using literals:

<?code-excerpt "misc/test/cheatsheet/collections_test.dart (collection-literals-inferred)"?>
```dart
final aListOfStrings = ['one', 'two', 'three'];
final aSetOfStrings = {'one', 'two', 'three'};
final aMapOfStringsToInts = {
  'one': 1,
  'two': 2,
  'three': 3,
};
```

Dart's type inference can assign types to these variables for you.
In this case, the inferred types are `List<String>`,
`Set<String>`, and `Map<String, int>`.

Or you can specify the type yourself:

<?code-excerpt "misc/test/cheatsheet/collections_test.dart (collection-literals-specified)"?>
```dart
final aListOfInts = <int>[];
final aSetOfInts = <int>{};
final aMapOfIntToDouble = <int, double>{};
```

Specifying types is handy when you initialize a list with contents of a subtype,
but still want the list to be `List<BaseType>`:

<?code-excerpt "misc/test/cheatsheet/collections_test.dart (collection-literals-subtypes)"?>
```dart
final aListOfBaseType = <BaseType>[SubType(), SubType()];
```

### Code example
{: .no_toc}

Try setting the following variables to the indicated values. Replace the existing null values.

```dart:run-dartpad:height-400px:ga_id-collection_literals
{$ begin main.dart $}
// Assign this a list containing 'a', 'b', and 'c' in that order:
final aListOfStrings = null;

// Assign this a set containing 3, 4, and 5:
final aSetOfInts = null;

// Assign this a map of String to int so that aMapOfStringsToInts['myKey'] returns 12:
final aMapOfStringsToInts = null;

// Assign this an empty List<double>:
final anEmptyListOfDouble = null;

// Assign this an empty Set<String>:
final anEmptySetOfString = null;

// Assign this an empty Map of double to int:
final anEmptyMapOfDoublesToInts = null;
{$ end main.dart $}
{$ begin solution.dart $}
// Assign this a list containing 'a', 'b', and 'c' in that order:
final aListOfStrings = ['a', 'b', 'c'];

// Assign this a set containing 3, 4, and 5:
final aSetOfInts = {3, 4, 5};

// Assign this a map of String to int so that aMapOfStringsToInts['myKey'] returns 12:
final aMapOfStringsToInts = {'myKey': 12};

// Assign this an empty List<double>:
final anEmptyListOfDouble = <double>[];

// Assign this an empty Set<String>:
final anEmptySetOfString = <String>{};

// Assign this an empty Map of double to int:
final anEmptyMapOfDoublesToInts = <double, int>{};
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final errs = <String>[];
  
  if (aListOfStrings is! List<String>) {
    errs.add('aListOfStrings should have the type List<String>.');
  } else if (aListOfStrings.length != 3) {
    errs.add('aListOfStrings has ${aListOfStrings.length} items in it, rather than the expected 3.');
  } else if (aListOfStrings[0] != 'a' || aListOfStrings[1] != 'b' || aListOfStrings[2] != 'c') {
    errs.add('aListOfStrings doesn\'t contain the correct values (\'a\', \'b\', \'c\').');
  }

  if (aSetOfInts is! Set<int>) {
    errs.add('aSetOfInts should have the type Set<int>.');
  } else if (aSetOfInts.length != 3) {
    errs.add('aSetOfInts has ${aSetOfInts.length} items in it, rather than the expected 3.');
  } else if (!aSetOfInts.contains(3) || !aSetOfInts.contains(4) || !aSetOfInts.contains(5)) {
    errs.add('aSetOfInts doesn\'t contain the correct values (3, 4, 5).');
  }

  if (aMapOfStringsToInts is! Map<String, int>) {
    errs.add('aMapOfStringsToInts should have the type Map<String, int>.');
  } else if (aMapOfStringsToInts['myKey'] != 12) {
    errs.add('aMapOfStringsToInts doesn\'t contain the correct values (\'myKey\': 12).');
  }

  if (anEmptyListOfDouble is! List<double>) {
    errs.add('anEmptyListOfDouble should have the type List<double>.');
  } else if (anEmptyListOfDouble.isNotEmpty) {
    errs.add('anEmptyListOfDouble should be empty.');
  }

  if (anEmptySetOfString is! Set<String>) {
    errs.add('anEmptySetOfString should have the type Set<String>.');
  } else if (anEmptySetOfString.isNotEmpty) {
    errs.add('anEmptySetOfString should be empty.');
  }

  if (anEmptyMapOfDoublesToInts is! Map<double, int>) {
    errs.add('anEmptyMapOfDoublesToInts should have the type Map<double, int>.');
  } else if (anEmptyMapOfDoublesToInts.isNotEmpty) {
    errs.add('anEmptyMapOfDoublesToInts should be empty.');
  }

  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
This exercise is fairly straightforward.
Just add a list, set, or map literal after each equals sign.
See the codelab text for the correct syntax to use.
{$ end hint.txt $}
```


## Arrow syntax

You might have seen the `=>` symbol in Dart code.
This arrow syntax is a way to define a function that executes the
expression to its right and returns its value.

For example, consider this call to the `List` class's
`any()` method:

<?code-excerpt "misc/test/cheatsheet/arrow_functions_test.dart (has-empty-long)"?>
```dart
bool hasEmpty = aListOfStrings.any((s) {
  return s.isEmpty;
});
```

Here's a simpler way to write that code:

<?code-excerpt "misc/test/cheatsheet/arrow_functions_test.dart (has-empty-short)"?>
```dart
bool hasEmpty = aListOfStrings.any((s) => s.isEmpty);
```

### Code example
{: .no_toc}

Try finishing the following statements, which use arrow syntax.

```dart:run-dartpad:height-345px:ga_id-arrow_syntax
{$ begin main.dart $}
class MyClass {
  int value1 = 2;
  int value2 = 3;
  int value3 = 5;
  
  // Returns the product of the above values:
  int get product => TODO();
  
  // Adds 1 to value1:
  void incrementValue1() => TODO();
  
  // Returns a string containing each item in the
  // list, separated by commas (e.g. 'a,b,c'): 
  String joinWithCommas(List<String> strings) => TODO();
}
{$ end main.dart $}
{$ begin solution.dart $}
class MyClass {
  int value1 = 2;
  int value2 = 3;
  int value3 = 5;

  // Returns the product of the above values:
  int get product => value1 * value2 * value3;
  
  // Adds 1 to value1:
  void incrementValue1() => value1++; 
  
  // Returns a string containing each item in the
  // list, separated by commas (e.g. 'a,b,c'): 
  String joinWithCommas(List<String> strings) => strings.join(',');
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final obj = MyClass();
  final errs = <String>[];
  
  try {
    final product = obj.product;
    
    if (product != 30) {
      errs.add('The product property returned $product instead of the expected value (30).'); 
    } 
  } on UnimplementedError {
    _result(false, ['Tried to use MyClass.product but failed. Did you implement the method?']);
    return;
  } catch (e) {
    _result(false, ['Tried to use MyClass.product, but encountered an exception: ${e.runtimeType}.']);
    return;
  }

  try {
    obj.incrementValue1();
    
    if (obj.value1 != 3) {
      errs.add('After calling incrementValue, value1 was ${obj.value1} instead of the expected value (3).'); 
    } 
  } on UnimplementedError {
    _result(false, ['Tried to use MyClass.incrementValue1 but failed. Did you implement the method?']);
    return;
  } catch (e) {
    _result(false, ['Tried to use MyClass.incrementValue1, but encountered an exception: ${e.runtimeType}.']);
    return;
  }

  try {
    final joined = obj.joinWithCommas(['one', 'two', 'three']);
    
    if (joined != 'one,two,three') {
      errs.add('Tried calling joinWithCommas([\'one\', \'two\', \'three\']) and received $joined instead of the expected value (\'one,two,three\').'); 
    } 
  } on UnimplementedError {
    _result(false, ['Tried to use MyClass.joinWithCommas but failed. Did you implement the method?']);
    return;
  } catch (e) {
    _result(false, ['Tried to use MyClass.joinWithCommas, but encountered an exception: ${e.runtimeType}.']);
    return;
  }

  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
For the product, you can just multiply the three values together.
For incrementValue1, you can use the increment operator (++).
For joinWithCommas, try using the join method found in the List class.
{$ end hint.txt $}
```


## Cascades

To perform a sequence of operations on the same object, use cascades (`..`).
We've all seen an expression like this:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (no-cascade)" replace="/;//g"?>
```dart
myObject.someMethod()
```

It invokes `someMethod()` on `myObject`, and the result of
the expression is the return value of `someMethod()`.

Here's the same expression with a cascade:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (uses-cascade)" replace="/;//g"?>
```dart
myObject..someMethod()
```

Although it still invokes `someMethod()` on `myObject`, the result
of the expression **isn't** the return value—it's a reference to `myObject`!

Using cascades, you can chain together operations that
would otherwise require separate statements.
For example, consider the following code,
which uses the conditional member access operator (`?.`)
to read properties of `button` if it isn't `null`:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (query-without-cascades)"?>
```dart
var button = querySelector('#confirm');
button?.text = 'Confirm';
button?.classes.add('important');
button?.onClick.listen((e) => window.alert('Confirmed!'));
button?.scrollIntoView();
```

To instead use cascades, 
you can start with the _null-shorting_ cascade (`?..`), 
which guarantees that none of the cascade operations
are attempted on a `null` object.
Using cascades shortens the code
and makes the `button` variable unnecessary:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (query-with-cascades)"?>
```dart
querySelector('#confirm')
  ?..text = 'Confirm'
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'))
  ..scrollIntoView();
```

### Code example
{: .no_toc}

Use cascades to create a single statement that
sets the `anInt`, `aString`, and `aList` properties of a `BigObject`
to `1`, `'String!'`, and `[3.0]` (respectively)
and then calls `allDone()`.

```dart:run-dartpad:height-345px:ga_id-cascades
{$ begin main.dart $}
class BigObject {
  int anInt = 0;
  String aString = '';
  List<double> aList = [];
  bool _done = false;
  
  void allDone() {
    _done = true;
  }
}

BigObject fillBigObject(BigObject obj) {
  // Create a single statement that will update and return obj:
  return TODO('obj..');
}
{$ end main.dart $}
{$ begin solution.dart $}
class BigObject {
  int anInt = 0;
  String aString = '';
  List<double> aList = [];
  bool _done = false;
  
  void allDone() {
    _done = true;
  }
}

BigObject fillBigObject(BigObject obj) {
  return obj
    ..anInt = 1
    ..aString = 'String!'
    ..aList.add(3)
    ..allDone();
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  BigObject obj;

  try {
    obj = fillBigObject(BigObject());
  } on UnimplementedError {
    _result(false, ['Tried to call fillBigObject but failed. Did you implement the method?']);
    return;
  } catch (e) {
    _result(false, [
      'Caught an exception of type ${e.runtimeType} while running fillBigObject'
    ]);
    return;
  }

  final errs = <String>[];

  if (obj.anInt != 1) {
    errs.add(
        'The value of anInt was ${obj.anInt} rather than the expected (1).');
  }

  if (obj.aString != 'String!') {
    errs.add(
        'The value of aString was \'${obj.aString}\' rather than the expected (\'String!\').');
  }

  if (obj.aList.length != 1) {
    errs.add(
        'The length of aList was ${obj.aList.length} rather than the expected value (1).');
  } else {
    if (obj.aList[0] != 3.0) {
      errs.add(
          'The value found in aList was ${obj.aList[0]} rather than the expected (3.0).');
    }
  }
  
  if (!obj._done) {
    errs.add('It looks like allDone() wasn\'t called.');
  }

  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
The best solution for this exercise starts with obj.. and
has four assignment operations chained together.
Try starting with `return obj..anInt = 1`,
then add another cascade (..) and start the next assignment.
{$ end hint.txt $}
```


## Getters and setters

You can define getters and setters
whenever you need more control over a property
than a simple field allows.

For example, you can make sure a property's value is valid:

<?code-excerpt "misc/lib/cheatsheet/getters_setters.dart"?>
```dart
class MyClass {
  int _aProperty = 0;

  int get aProperty => _aProperty;

  set aProperty(int value) {
    if (value >= 0) {
      _aProperty = value;
    }
  }
}
```

You can also use a getter to define a computed property:

<?code-excerpt "misc/lib/cheatsheet/getter_compute.dart"?>
```dart
class MyClass {
  final List<int> _values = [];

  void addValue(int value) {
    _values.add(value);
  }

  // A computed property.
  int get count {
    return _values.length;
  }
}
```

### Code example
{: .no_toc}

Imagine you have a shopping cart class that keeps a private `List<double>`
of prices.
Add the following:

* A getter called `total` that returns the sum of the prices
* A setter that replaces the list with a new one,
  as long as the new list doesn't contain any negative prices
  (in which case the setter should throw an `InvalidPriceException`).

Ignore all initial errors in the DartPad.

```dart:run-dartpad:height-240px:ga_id-getters_setters
{$ begin main.dart $}
class InvalidPriceException {}

class ShoppingCart {
  List<double> _prices = [];
  
  // Add a "total" getter here:

  // Add a "prices" setter here:
}
{$ end main.dart $}
{$ begin solution.dart $}
class InvalidPriceException {}

class ShoppingCart {
  List<double> _prices = [];
  
  double get total => _prices.fold(0, (e, t) => e + t);
  
  set prices(List<double> value) {
    if (value.any((p) => p < 0)) {
      throw InvalidPriceException();
    }
    
    _prices = value;
  }
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  var foundException = false;
  
  try {
    final cart = ShoppingCart();
    cart.prices = [12.0, 12.0, -23.0];
  } on InvalidPriceException {
    foundException = true;
  } catch (e) {
    _result(false, ['Tried setting a negative price and received a ${e.runtimeType} instead of an InvalidPriceException.']);
    return;
  }
  
  if (!foundException) {
    _result(false, ['Tried setting a negative price and didn\'t get an InvalidPriceException.']);
    return;
  }
  
  final secondCart = ShoppingCart();
  
  try {
    secondCart.prices = [1.0, 2.0, 3.0];
  } catch(e) {
    _result(false, ['Tried setting prices with a valid list, but received an exception: ${e.runtimeType}.']);
    return;
  }
  
  if (secondCart._prices.length != 3) {
    _result(false, ['Tried setting prices with a list of three values, but _prices ended up having length ${secondCart._prices.length}.']);
    return;
  }

  if (secondCart._prices[0] != 1.0 || secondCart._prices[1] != 2.0 || secondCart._prices[2] != 3.0) {
    final vals = secondCart._prices.map((p) => p.toString()).join(', ');
    _result(false, ['Tried setting prices with a list of three values (1, 2, 3), but incorrect ones ended up in the price list ($vals) .']);
    return;
  }
  
  var sum = 0.0;
  
  try {
    sum = secondCart.total;
  } catch (e) {
    _result(false, ['Tried to get total, but received an exception: ${e.runtimeType}.']);
    return;
  }
  
  if (sum != 6.0) {
    _result(false, ['After setting prices to (1, 2, 3), total returned $sum instead of 6.']);
    return;
  }
  
  _result(true);
}
{$ end test.dart $}
{$ begin hint.txt $}
Two functions are handy for this exercise. 
One is `fold`, which can reduce a list to a single value
(try it to calculate the total).
The other is `any`, which can check each item in a list
with a function you give it
(try using it to check if there are any negative prices in the prices setter).
{$ end hint.txt $}
```


## Optional positional parameters

Dart has two kinds of function parameters: positional and named. 
Positional parameters are the kind you're likely familiar with:

<?code-excerpt "misc/lib/cheatsheet/optional_positional_args.dart (optional-positional-args)"?>
```dart
int sumUp(int a, int b, int c) {
  return a + b + c;
}
// ···
  int total = sumUp(1, 2, 3);
```

With Dart, you can make these positional parameters optional by wrapping them in brackets:

<?code-excerpt "misc/lib/cheatsheet/optional_positional_args.dart (optional-positional-args-2)" replace="/total2/total/g"?>
```dart
int sumUpToFive(int a, [int? b, int? c, int? d, int? e]) {
  int sum = a;
  if (b != null) sum += b;
  if (c != null) sum += c;
  if (d != null) sum += d;
  if (e != null) sum += e;
  return sum;
}
// ···
  int total = sumUpToFive(1, 2);
  int otherTotal = sumUpToFive(1, 2, 3, 4, 5);
```

Optional positional parameters are always last
in a function's parameter list.
Their default value is null unless you provide another default value:

<?code-excerpt "misc/lib/cheatsheet/optional_positional_args2.dart"?>
```dart
int sumUpToFive(int a, [int b = 2, int c = 3, int d = 4, int e = 5]) {
// ···
}
// ···
  int newTotal = sumUpToFive(1);
  print(newTotal); // <-- prints 15
```

### Code example
{: .no_toc}

Implement a function called `joinWithCommas()` that accepts one to
five integers, then returns a string of those numbers separated by commas.
Here are some examples of function calls and returned values:

| Function call                   | | Returned value |
|---------------------------------+-+----------------|
| `joinWithCommas(1)`             | | `'1'`          |
| `joinWithCommas(1, 2, 3)`       | | `'1,2,3'`      |
| `joinWithCommas(1, 1, 1, 1, 1)` | | `'1,1,1,1,1'`  |

<br>

```dart:run-dartpad:ga_id-optional_positional_parameters
{$ begin main.dart $}
String joinWithCommas(int a, [int? b, int? c, int? d, int? e]) {
  return TODO();
}
{$ end main.dart $}
{$ begin solution.dart $}
String joinWithCommas(int a, [int? b, int? c, int? d, int? e]) {
  var total = '$a';
  if (b != null) total = '$total,$b';
  if (c != null) total = '$total,$c';
  if (d != null) total = '$total,$d';
  if (e != null) total = '$total,$e';
  return total;
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final errs = <String>[];
  
  try {
    final value = joinWithCommas(1);
    
    if (value != '1') {
      errs.add('Tried calling joinWithCommas(1) and got $value instead of the expected (\'1\').'); 
    } 
  } on UnimplementedError {
    _result(false, ['Tried to call joinWithCommas but failed. Did you implement the method?']);
    return;
  } catch (e) {
    _result(false, ['Tried calling joinWithCommas(1), but encountered an exception: ${e.runtimeType}.']);
    return;
  }

  try {
    final value = joinWithCommas(1, 2, 3);
    
    if (value != '1,2,3') {
      errs.add('Tried calling joinWithCommas(1, 2, 3) and got $value instead of the expected (\'1,2,3\').'); 
    } 
  } on UnimplementedError {
    _result(false, ['Tried to call joinWithCommas but failed. Did you implement the method?']);
    return;
  } catch (e) {
    _result(false, ['Tried calling joinWithCommas(1, 2 ,3), but encountered an exception: ${e.runtimeType}.']);
    return;
  }

  try {
    final value = joinWithCommas(1, 2, 3, 4, 5);
    
    if (value != '1,2,3,4,5') {
      errs.add('Tried calling joinWithCommas(1, 2, 3, 4, 5) and got $value instead of the expected (\'1,2,3,4,5\').'); 
    } 
  } on UnimplementedError {
    _result(false, ['Tried to call joinWithCommas but failed. Did you implement the method?']);
    return;
  } catch (e) {
    _result(false, ['Tried calling stringify(1, 2, 3, 4 ,5), but encountered an exception: ${e.runtimeType}.']);
    return;
  }

  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
The b, c, d, and e parameters are null if they aren't provided by caller.
The important thing, then, is to check whether those arguments are null
before you add them to the final string.
{$ end hint.txt $}
```

<a id="optional-named-parameters"></a>
## Named parameters

Using a curly brace syntax at the end of the parameter list,
you can define parameters that have names.

Named parameters are optional
unless they're explicitly marked as `required`.

<?code-excerpt "misc/lib/cheatsheet/named_parameters.dart"?>
```dart
void printName(String firstName, String lastName, {String? middleName}) {
  print('$firstName ${middleName ?? ''} $lastName');
}
// ···
  printName('Dash', 'Dartisan');
  printName('John', 'Smith', middleName: 'Who');
  // Named arguments can be placed anywhere in the argument list
  printName('John', middleName: 'Who', 'Smith');
```

As you might expect,
the default value of a nullable named parameter is `null`,
but you can provide a custom default value.

If the type of a parameter is non-nullable,
then you must either provide a default value
(as shown in the following code)
or mark the parameter as `required`
(as shown in the
[constructor section](#using-this-in-a-constructor)).

<?code-excerpt "misc/test/cheatsheet/arguments_test.dart (defaulted-middle)" replace="/ = ''/[! = ''!]/g;"?>
```dart
void printName(String firstName, String lastName, {String middleName[! = ''!]}) {
  print('$firstName $middleName $lastName');
}
```

A function can't have both optional positional and named parameters.


### Code example
{: .no_toc}

Add a `copyWith()` instance method to the `MyDataObject`
class. It should take three named, nullable parameters:

* `int? newInt`
* `String? newString`
* `double? newDouble`

Your `copyWith()` method should return a new `MyDataObject`
based on the current instance,
with data from the preceding parameters (if any)
copied into the object's properties.
For example, if `newInt` is non-null,
then copy its value into `anInt`.

Ignore all initial errors in the DartPad.

```dart:run-dartpad:height-310px:ga_id-optional_named_parameters
{$ begin main.dart $}
class MyDataObject {
  final int anInt;
  final String aString;
  final double aDouble;

  MyDataObject({
     this.anInt = 1,
     this.aString = 'Old!',
     this.aDouble = 2.0,
  });

  // Add your copyWith method here:
}
{$ end main.dart $}
{$ begin solution.dart $}
class MyDataObject {
  final int anInt;
  final String aString;
  final double aDouble;

  MyDataObject({
     this.anInt = 1,
     this.aString = 'Old!',
     this.aDouble = 2.0,
  });

  MyDataObject copyWith({int? newInt, String? newString, double? newDouble}) {
    return MyDataObject(
      anInt: newInt ?? this.anInt,
      aString: newString ?? this.aString,
      aDouble: newDouble ?? this.aDouble,
    );
  }
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final source = MyDataObject();
  final errs = <String>[];
  
  try {
    final copy = source.copyWith(newInt: 12, newString: 'New!', newDouble: 3.0);
    
    if (copy.anInt != 12) {
      errs.add('Called copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0), and the new object\'s anInt was ${copy.anInt} rather than the expected value (12).');
    }
    
    if (copy.aString != 'New!') {
      errs.add('Called copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0), and the new object\'s aString was ${copy.aString} rather than the expected value (\'New!\').');
    }
    
    if (copy.aDouble != 3) {
      errs.add('Called copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0), and the new object\'s aDouble was ${copy.aDouble} rather than the expected value (3).');
    }
  } catch (e) {
    _result(false, ['Called copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0) and got an exception: ${e.runtimeType}']);
  }
  
  try {
    final copy = source.copyWith();
    
    if (copy.anInt != 1) {
      errs.add('Called copyWith(), and the new object\'s anInt was ${copy.anInt} rather than the expected value (1).');
    }
    
    if (copy.aString != 'Old!') {
      errs.add('Called copyWith(), and the new object\'s aString was ${copy.aString} rather than the expected value (\'Old!\').');
    }
    
    if (copy.aDouble != 2) {
      errs.add('Called copyWith(), and the new object\'s aDouble was ${copy.aDouble} rather than the expected value (2).');
    }
  } catch (e) {
    _result(false, ['Called copyWith() and got an exception: ${e.runtimeType}']);
  }
  
  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
The copyWith method shows up in a lot of classes and libraries.
Yours should do a few things:
use optional named parameters,
create a new instance of MyDataObject,
and use the data from the parameters to fill it
(or the data from the current instance if the parameters are null).
This is a chance to get more practice with the ?? operator!
{$ end hint.txt $}
```


## Exceptions

Dart code can throw and catch exceptions. In contrast to Java, all of Dart's exceptions are unchecked
exceptions. Methods don't declare which exceptions they might throw, and you aren't required to catch
any exceptions.

Dart provides `Exception` and `Error` types, but you're
allowed to throw any non-null object:

<?code-excerpt "misc/test/cheatsheet/exceptions_test.dart (simple-throws)"?>
```dart
throw Exception('Something bad happened.');
throw 'Waaaaaaah!';
```

Use the `try`, `on`, and `catch` keywords when handling exceptions:

<?code-excerpt "misc/test/cheatsheet/exceptions_test.dart (try-on-catch)"?>
```dart
try {
  breedMoreLlamas();
} on OutOfLlamasException {
  // A specific exception
  buyMoreLlamas();
} on Exception catch (e) {
  // Anything else that is an exception
  print('Unknown exception: $e');
} catch (e) {
  // No specified type, handles all
  print('Something really unknown: $e');
}
```

The `try` keyword works as it does in most other languages.
Use the `on` keyword to filter for specific exceptions by type,
and the `catch` keyword to get a reference to the exception object.

If you can't completely handle the exception, use the `rethrow` keyword
to propagate the exception:

<?code-excerpt "misc/test/cheatsheet/exceptions_test.dart (try-catch)"?>
```dart
try {
  breedMoreLlamas();
} catch (e) {
  print('I was just trying to breed llamas!');
  rethrow;
}
```

To execute code whether or not an exception is thrown,
use `finally`:

<?code-excerpt "misc/test/cheatsheet/exceptions_test.dart (try-catch-finally)"?>
```dart
try {
  breedMoreLlamas();
} catch (e) {
  // ... handle exception ...
} finally {
  // Always clean up, even if an exception is thrown.
  cleanLlamaStalls();
}
```

### Code example
{: .no_toc}

Implement `tryFunction()` below. It should execute an untrustworthy method and
then do the following:

* If `untrustworthy()` throws an `ExceptionWithMessage`,
  call `logger.logException` with the exception type and message
  (try using `on` and `catch`).
* If `untrustworthy()` throws an `Exception`,
  call `logger.logException` with the exception type
  (try using `on` for this one).
* If `untrustworthy()` throws any other object, don't catch the exception.
* After everything's caught and handled, call `logger.doneLogging`
  (try using `finally`).

```dart:run-dartpad:height-420px:ga_id-exceptions
{$ begin main.dart $}
typedef VoidFunction = void Function();

class ExceptionWithMessage {
  final String message;
  const ExceptionWithMessage(this.message);
}

// Call logException to log an exception, and doneLogging when finished.
abstract class Logger {
  void logException(Type t, [String? msg]);
  void doneLogging();
}

void tryFunction(VoidFunction untrustworthy, Logger logger) {
  // Invoking this method might cause an exception. Catch and handle
  // them using try-on-catch-finally.
  untrustworthy();
}
{$ end main.dart $}
{$ begin solution.dart $}
typedef VoidFunction = void Function();

class ExceptionWithMessage {
  final String message;
  const ExceptionWithMessage(this.message);
}

abstract class Logger {
  void logException(Type t, [String? msg]);
  void doneLogging();
}

void tryFunction(VoidFunction untrustworthy, Logger logger) {
  try {
    untrustworthy();
  } on ExceptionWithMessage catch (e) {
    logger.logException(e.runtimeType, e.message);
  } on Exception {
    logger.logException(Exception);
  } finally {
    logger.doneLogging();
  }
}
{$ end solution.dart $}
{$ begin test.dart $}
class MyLogger extends Logger {
  Type? lastType;
  String lastMessage = '';
  bool done = false;
  
  void logException(Type t, [String? message]) {
    lastType = t;
    lastMessage = message ?? lastMessage;
  }
  
  void doneLogging() => done = true;  
}

void main() {
  final errs = <String>[];
  var logger = MyLogger();
  
  try {
    tryFunction(() => throw Exception(), logger);
  
    if ('${logger.lastType}' != 'Exception' && '${logger.lastType}' != '_Exception') {
      errs.add('Untrustworthy threw an Exception, but a different type was logged: ${logger.lastType}.');
    }
    
    if (logger.lastMessage != '') {
      errs.add('Untrustworthy threw an Exception with no message, but a message was logged anyway: \'${logger.lastMessage}\'.');
    }
    
    if (!logger.done) {
      errs.add('Untrustworthy threw an Exception, and doneLogging() wasn\'t called afterward.');
    }
  } catch (e) {
    _result(false, ['Untrustworthy threw an exception, and an exception of type ${e.runtimeType} was unhandled by tryFunction.']);
  }
  
  logger = MyLogger();
  
  try {
    tryFunction(() => throw ExceptionWithMessage('Hey!'), logger);
  
    if (logger.lastType != ExceptionWithMessage) {
      errs.add('Untrustworthy threw an ExceptionWithMessage(\'Hey!\'), but a different type was logged: ${logger.lastType}.');
    }
    
    if (logger.lastMessage != 'Hey!') {
      errs.add('Untrustworthy threw an ExceptionWithMessage(\'Hey!\'), but a different message was logged: \'${logger.lastMessage}\'.');
    }
    
    if (!logger.done) {
      errs.add('Untrustworthy threw an ExceptionWithMessage(\'Hey!\'), and doneLogging() wasn\'t called afterward.');
    }
  } catch (e) {
    _result(false, ['Untrustworthy threw an ExceptionWithMessage(\'Hey!\'), and an exception of type ${e.runtimeType} was unhandled by tryFunction.']);
  }
  
  logger = MyLogger();
  bool caughtStringException = false;

  try {
    tryFunction(() => throw 'A String', logger);
  } on String {
    caughtStringException = true;
  }

  if (!caughtStringException) {
    errs.add('Untrustworthy threw a string, and it was incorrectly handled inside tryFunction().');
  }
  
  logger = MyLogger();
  
  try {
    tryFunction(() {}, logger);
  
    if (logger.lastType != null) {
      errs.add('Untrustworthy didn\'t throw an Exception, but one was logged anyway: ${logger.lastType}.');
    }
    
    if (logger.lastMessage != '') {
      errs.add('Untrustworthy didn\'t throw an Exception with no message, but a message was logged anyway: \'${logger.lastMessage}\'.');
    }
    
    if (!logger.done) {
      errs.add('Untrustworthy didn\'t throw an Exception, but doneLogging() wasn\'t called afterward.');
    }
  } catch (e) {
    _result(false, ['Untrustworthy didn\'t throw an exception, but an exception of type ${e.runtimeType} was unhandled by tryFunction anyway.']);
  }
  
  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
This exercise looks tricky, but it's really one big `try` statement.
Just call `untrustworthy` inside the `try`, and
then use `on`, `catch`, and `finally` to catch exceptions and
call methods on the logger.
{$ end hint.txt $}
```


## Using `this` in a constructor

Dart provides a handy shortcut for assigning
values to properties in a constructor:
use `this.propertyName` when declaring the constructor:

<?code-excerpt "misc/lib/cheatsheet/this_constructor.dart (required-positional)"?>
```dart
class MyColor {
  int red;
  int green;
  int blue;

  MyColor(this.red, this.green, this.blue);
}

final color = MyColor(80, 80, 128);
```

This technique works for named parameters, too.
Property names become the names of the parameters:

<?code-excerpt "misc/lib/cheatsheet/this_constructor.dart (required-named)" replace="/int.*;/.../g; /olorRN/olor/g;"?>
```dart
class MyColor {
  ...

  MyColor({required this.red, required this.green, required this.blue});
}

final color = MyColor(red: 80, green: 80, blue: 80);
```

In the preceding code, `red`, `green`, and `blue` are marked as `required`
because these `int` values can't be null.
If you add default values, you can omit `required`:

<?code-excerpt "misc/lib/cheatsheet/this_constructor.dart (defaulted)" replace="/olorO/olor/g; /.positional//g; /.named//g;"?>
```dart
MyColor([this.red = 0, this.green = 0, this.blue = 0]);
// or
MyColor({this.red = 0, this.green = 0, this.blue = 0});
```

### Code example
{: .no_toc}

Add a one-line constructor to `MyClass` that uses
`this.` syntax to receive and assign values for
all three properties of the class.

Ignore all initial errors in the DartPad.

```dart:run-dartpad:ga_id-this_constructor
{$ begin main.dart $}
class MyClass {
  final int anInt;
  final String aString;
  final double aDouble;
  
  // Create a constructor here.
}
{$ end main.dart $}
{$ begin solution.dart $}
class MyClass {
  final int anInt;
  final String aString;
  final double aDouble;
  
  MyClass(this.anInt, this.aString, this.aDouble);
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final errs = <String>[];
  
  try {
    final obj = MyClass(1, 'two', 3);
    
    if (obj.anInt != 1) {
      errs.add('Called MyClass(1, \'two\', 3) and got an object with anInt of ${obj.anInt} instead of the expected value (1).');
    }

    if (obj.anInt != 1) {
      errs.add('Called MyClass(1, \'two\', 3) and got an object with aString of \'${obj.aString}\' instead of the expected value (\'two\').');
    }

    if (obj.anInt != 1) {
      errs.add('Called MyClass(1, \'two\', 3) and got an object with aDouble of ${obj.aDouble} instead of the expected value (3).');
    }
  } catch (e) {
    _result(false, ['Called MyClass(1, \'two\', 3) and got an exception of type ${e.runtimeType}.']);
  }
  
  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
This exercise has a one-line solution.
Just declare the constructor with
`this.anInt`, `this.aString`, and `this.aDouble`
as its parameters in that order.
{$ end hint.txt $}
```

{% comment %}
This one seems super easy compared to previous ones.
We've already seen it in the Exceptions example,
and I'd already used it in a previous example.
Move it up higher? Or make it more challenging, somehow?
Maybe require both positional and optional named parameters (with defaults)?
{% endcomment %}

## Initializer lists

Sometimes when you implement a constructor,
you need to do some setup before the constructor body executes.
For example, final fields must have values
before the constructor body executes.
Do this work in an initializer list,
which goes between the constructor's signature and its body:

<?code-excerpt "misc/lib/language_tour/classes/point_alt.dart (initializer-list-no-comment)"?>
```dart
Point.fromJson(Map<String, double> json)
    : x = json['x']!,
      y = json['y']! {
  print('In Point.fromJson(): ($x, $y)');
}
```

The initializer list is also a handy place to put asserts,
which run only during development:

<?code-excerpt "misc/lib/cheatsheet/initializer_lists.dart (assert)"?>
```dart
NonNegativePoint(this.x, this.y)
    : assert(x >= 0),
      assert(y >= 0) {
  print('I just made a NonNegativePoint: ($x, $y)');
}
```

### Code example
{: .no_toc}

Complete the `FirstTwoLetters` constructor below.
Use an initializer list to assign the first two characters in `word` to
the `letterOne` and `LetterTwo` properties.
For extra credit, add an `assert` to catch words of less than two characters.

Ignore all initial errors in the DartPad.

{% comment %}
Is the assert even executed? I can't see any effect on the test,
which makes me think asserts are ignored.
Also, the test just checks for the presence of any exception, not for
an AssertionError.

Also, my print() wasn't visible in the Output until I fixed my code and/or
the test. That was unexpected.
It'd be cool if Output appeared only if you want it, like Solution does.

FINALLY: Suggest using https://pub.dev/packages/characters
if this is a user-entered string.
{% endcomment %}

```dart:run-dartpad:ga_id-initializer_lists
{$ begin main.dart $}
class FirstTwoLetters {
  final String letterOne;
  final String letterTwo;

  // Create a constructor with an initializer list here:
  FirstTwoLetters(String word)
    ...
}
{$ end main.dart $}
{$ begin solution.dart $}
class FirstTwoLetters {
  final String letterOne;
  final String letterTwo;

  FirstTwoLetters(String word)
      : assert(word.length >= 2),
        letterOne = word[0],
        letterTwo = word[1];
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final errs = <String>[];

  try {
    final result = FirstTwoLetters('My String');
    
    if (result.letterOne != 'M') {
      errs.add('Called FirstTwoLetters(\'My String\') and got an object with letterOne equal to \'${result.letterOne}\' instead of the expected value (\'M\').');
    }

    if (result.letterTwo != 'y') {
      errs.add('Called FirstTwoLetters(\'My String\') and got an object with letterTwo equal to \'${result.letterTwo}\' instead of the expected value (\'y\').');
    }
  } catch (e) {
    errs.add('Called FirstTwoLetters(\'My String\') and got an exception of type ${e.runtimeType}.');
  }

  bool caughtException = false;
  
  try {
    FirstTwoLetters('');
  } catch (e) {
    caughtException = true;
  }
  
  if (!caughtException) {
    errs.add('Called FirstTwoLetters(\'\') and didn\'t get an exception from the failed assertion.');
  }
  
  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
Two assignments need to happen:
letterOne should be word[0], and letterTwo should be word[1].
{$ end hint.txt $}
```


## Named constructors

{% comment %}
Much like JavaScript, Dart doesn't support method overloads
(two methods with the same name but different signatures).
[ISSUE: methods & constructors aren't the same thing,
so I deleted that. We can add it back if we can word it better.]
{% endcomment %}
To allow classes to have multiple constructors,
Dart supports named constructors:

<?code-excerpt "misc/lib/cheatsheet/named_constructor.dart (point-class)"?>
```dart
class Point {
  double x, y;

  Point(this.x, this.y);

  Point.origin()
      : x = 0,
        y = 0;
}
```

To use a named constructor, invoke it using its full name:

<?code-excerpt "misc/test/cheatsheet/constructor_test.dart (origin-point)"?>
```dart
final myPoint = Point.origin();
```

### Code example
{: .no_toc}

Give the `Color` class a constructor named `Color.black`
that sets all three properties to zero.

Ignore all initial errors in the DartPad.

```dart:run-dartpad:height-240px:ga_id-named_constructors
{$ begin main.dart $}
class Color {
  int red;
  int green;
  int blue;
  
  Color(this.red, this.green, this.blue);

  // Create a named constructor called "Color.black" here:
}
{$ end main.dart $}
{$ begin solution.dart $}
class Color {
  int red;
  int green;
  int blue;
  
  Color(this.red, this.green, this.blue);

  Color.black()
      : red = 0,
        green = 0,
        blue = 0;
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final errs = <String>[];

  try {
    final result = Color.black();
    
    if (result.red != 0) {
      errs.add('Called Color.black() and got a Color with red equal to ${result.red} instead of the expected value (0).');
    }

    if (result.green != 0) {
      errs.add('Called Color.black() and got a Color with green equal to ${result.green} instead of the expected value (0).');
    }

    if (result.blue != 0) {
  errs.add('Called Color.black() and got a Color with blue equal to ${result.blue} instead of the expected value (0).');
    }
  } catch (e) {
    _result(false, ['Called Color.black() and got an exception of type ${e.runtimeType}.']);
    return;
  }

  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
The declaration for your constructor should be `Color.black() {}`.
Inside the braces, set red, green, and blue to zero.
{$ end hint.txt $}
```


## Factory constructors

Dart supports factory constructors,
which can return subtypes or even null.
To create a factory constructor, use the `factory` keyword:

<?code-excerpt "misc/lib/cheatsheet/factory_constructors.dart"?>
```dart
class Square extends Shape {}

class Circle extends Shape {}

class Shape {
  Shape();

  factory Shape.fromTypeName(String typeName) {
    if (typeName == 'square') return Square();
    if (typeName == 'circle') return Circle();

    throw ArgumentError('Unrecognized $typeName');
  }
}
```

### Code example
{: .no_toc}

Fill in the factory constructor named `IntegerHolder.fromList`,
making it do the following:

* If the list has **one** value,
  create an `IntegerSingle` with that value.
* If the list has **two** values,
  create an `IntegerDouble` with the values in order.
* If the list has **three** values,
  create an `IntegerTriple` with the values in order.
* Otherwise, throw an `Error`.

```dart:run-dartpad:height-415px:ga_id-factory_constructors
{$ begin main.dart $}
class IntegerHolder {
  IntegerHolder();
  
  // Implement this factory constructor.
  factory IntegerHolder.fromList(List<int> list) {
    TODO();
  }
}

class IntegerSingle extends IntegerHolder {
  final int a;
  IntegerSingle(this.a); 
}

class IntegerDouble extends IntegerHolder {
  final int a;
  final int b;
  IntegerDouble(this.a, this.b); 
}

class IntegerTriple extends IntegerHolder {
  final int a;
  final int b;
  final int c;
  IntegerTriple(this.a, this.b, this.c); 
}
{$ end main.dart $}
{$ begin solution.dart $}
class IntegerHolder {
  IntegerHolder();
  
  factory IntegerHolder.fromList(List<int> list) {
    if (list.length == 1) {
      return IntegerSingle(list[0]);
    } else if (list.length == 2) {
      return IntegerDouble(list[0], list[1]);
    } else if (list.length == 3) {
      return IntegerTriple(list[0], list[1], list[2]);
    } else {
      throw Error();
    } 
  }
}

class IntegerSingle extends IntegerHolder {
  final int a;
  IntegerSingle(this.a); 
}

class IntegerDouble extends IntegerHolder {
  final int a;
  final int b;
  IntegerDouble(this.a, this.b); 
}

class IntegerTriple extends IntegerHolder {
  final int a;
  final int b;
  final int c;
  IntegerTriple(this.a, this.b, this.c); 
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final errs = <String>[];

  bool _throwed = false;
  try {
    IntegerHolder.fromList([]);
  } on UnimplementedError {
    _result(false, ['Test failed. Did you implement the method?']);
    return;
  } on Error {
    _throwed = true;
  } catch (e) {
    _result(false, ['Called IntegerSingle.fromList([]) and got an exception of type ${e.runtimeType}.']);
    return;
  }
  
  if (!_throwed) {
    errs.add('Called IntegerSingle.fromList([]) and didn\'t throw Error.');
  } 

  try {
    final obj = IntegerHolder.fromList([1]);
    
    if (obj is! IntegerSingle) {
      errs.add('Called IntegerHolder.fromList([1]) and got an object of type ${obj.runtimeType} instead of IntegerSingle.');
    } else {
      if (obj.a != 1) {
        errs.add('Called IntegerHolder.fromList([1]) and got an IntegerSingle with an \'a\' value of ${obj.a} instead of the expected (1).');
      }
    }
  } catch (e) {
    _result(false, ['Called IntegerHolder.fromList([]) and got an exception of type ${e.runtimeType}.']);
    return;
  }

  try {
    final obj = IntegerHolder.fromList([1, 2]);
    
    if (obj is! IntegerDouble) {
      errs.add('Called IntegerHolder.fromList([1, 2]) and got an object of type ${obj.runtimeType} instead of IntegerDouble.');
    } else {
      if (obj.a != 1) {
        errs.add('Called IntegerHolder.fromList([1, 2]) and got an IntegerDouble with an \'a\' value of ${obj.a} instead of the expected (1).');
      }
      
      if (obj.b != 2) {
        errs.add('Called IntegerHolder.fromList([1, 2]) and got an IntegerDouble with an \'b\' value of ${obj.b} instead of the expected (2).');
      }
    }
  } catch (e) {
    _result(false, ['Called IntegerHolder.fromList([1, 2]) and got an exception of type ${e.runtimeType}.']);
    return;
  }

  try {
    final obj = IntegerHolder.fromList([1, 2, 3]);
    
    if (obj is! IntegerTriple) {
      errs.add('Called IntegerHolder.fromList([1, 2, 3]) and got an object of type ${obj.runtimeType} instead of IntegerTriple.');
    } else {
      if (obj.a != 1) {
        errs.add('Called IntegerHolder.fromList([1, 2, 3]) and got an IntegerTriple with an \'a\' value of ${obj.a} instead of the expected (1).');
      }
      
      if (obj.b != 2) {
        errs.add('Called IntegerHolder.fromList([1, 2, 3]) and got an IntegerTriple with an \'a\' value of ${obj.b} instead of the expected (2).');
      }

      if (obj.c != 3) {
        errs.add('Called IntegerHolder.fromList([1, 2, 3]) and got an IntegerTriple with an \'a\' value of ${obj.b} instead of the expected (2).');
      }
    }
  } catch (e) {
    _result(false, ['Called IntegerHolder.fromList([1, 2, 3]) and got an exception of type ${e.runtimeType}.']);
    return;
  }

  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
Inside the factory constructor,
check the length of the list and create an
IntegerSingle, IntegerDouble, or IntegerTriple as appropriate.
{$ end hint.txt $}
```


## Redirecting constructors

Sometimes a constructor's only purpose is to redirect to
another constructor in the same class.
A redirecting constructor's body is empty,
with the constructor call appearing after a colon (`:`).

<?code-excerpt "misc/lib/cheatsheet/redirecting_constructors.dart (redirecting-constructors)"?>
```dart
class Automobile {
  String make;
  String model;
  int mpg;

  // The main constructor for this class.
  Automobile(this.make, this.model, this.mpg);

  // Delegates to the main constructor.
  Automobile.hybrid(String make, String model) : this(make, model, 60);

  // Delegates to a named constructor
  Automobile.fancyHybrid() : this.hybrid('Futurecar', 'Mark 2');
}
```

### Code example
{: .no_toc}

Remember the `Color` class from above? Create a named constructor called
`black`, but rather than manually assigning the properties, redirect it to the
default constructor with zeros as the arguments.

Ignore all initial errors in the DartPad.

```dart:run-dartpad:height-255px:ga_id-redirecting_constructors
{$ begin main.dart $}
class Color {
  int red;
  int green;
  int blue;
  
  Color(this.red, this.green, this.blue);

  // Create a named constructor called "black" here and redirect it
  // to call the existing constructor
}
{$ end main.dart $}
{$ begin solution.dart $}
class Color {
  int red;
  int green;
  int blue;
  
  Color(this.red, this.green, this.blue);

  Color.black() : this(0, 0, 0);
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final errs = <String>[];

  try {
    final result = Color.black();
    
    if (result.red != 0) {
      errs.add('Called Color.black() and got a Color with red equal to ${result.red} instead of the expected value (0).');
    }

    if (result.green != 0) {
      errs.add('Called Color.black() and got a Color with green equal to ${result.green} instead of the expected value (0).');
    }

    if (result.blue != 0) {
  errs.add('Called Color.black() and got a Color with blue equal to ${result.blue} instead of the expected value (0).');
    }
  } catch (e) {
    _result(false, ['Called Color.black() and got an exception of type ${e.runtimeType}.']);
    return;
  }

  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
Your constructor should redirect to `this(0, 0, 0)`.
{$ end hint.txt $}
```


## Const constructors

If your class produces objects that never change, you can make these objects compile-time constants. To
do this, define a `const` constructor and make sure that all instance variables
are final.

<?code-excerpt "misc/lib/cheatsheet/redirecting_constructors.dart (const-constructors)"?>
```dart
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final int x;
  final int y;

  const ImmutablePoint(this.x, this.y);
}
```

### Code example
{: .no_toc}

Modify the `Recipe` class so its instances can be constants,
and create a constant constructor that does the following:

* Has three parameters: `ingredients`, `calories`,
  and `milligramsOfSodium` (in that order).
* Uses `this.` syntax to automatically assign the parameter values to the
  object properties of the same name.
* Is constant, with the `const` keyword just before
  `Recipe` in the constructor declaration.

Ignore all initial errors in the DartPad.

```dart:run-dartpad:ga_id-const_constructors
{$ begin main.dart $}
class Recipe {
  List<String> ingredients;
  int calories;
  double milligramsOfSodium;
}
{$ end main.dart $}
{$ begin solution.dart $}
class Recipe {
  final List<String> ingredients;
  final int calories;
  final double milligramsOfSodium;

  const Recipe(this.ingredients, this.calories, this.milligramsOfSodium);
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  final errs = <String>[];

  try {
    const obj = Recipe(['1 egg', 'Pat of butter', 'Pinch salt'], 120, 200);
    
    if (obj.ingredients.length != 3) {
      errs.add('Called Recipe([\'1 egg\', \'Pat of butter\', \'Pinch salt\'], 120, 200) and got an object with ingredient list of length ${obj.ingredients.length} rather than the expected length (3).');
    }
    
    if (obj.calories != 120) {
      errs.add('Called Recipe([\'1 egg\', \'Pat of butter\', \'Pinch salt\'], 120, 200) and got an object with a calorie value of ${obj.calories} rather than the expected value (120).');
    }
    
    if (obj.milligramsOfSodium != 200) {
      errs.add('Called Recipe([\'1 egg\', \'Pat of butter\', \'Pinch salt\'], 120, 200) and got an object with a milligramsOfSodium value of ${obj.milligramsOfSodium} rather than the expected value (200).');
    }
  } catch (e) {
    _result(false, ['Tried calling Recipe([\'1 egg\', \'Pat of butter\', \'Pinch salt\'], 120, 200) and received a null.']);
  }
  
  if (errs.isEmpty) {
    _result(true);
  } else {
    _result(false, errs);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
To make the constructor const, you'll need to make all the properties final.
{$ end hint.txt $}
```

## What's next?

We hope you enjoyed using this codelab to learn or test your knowledge of
some of the most interesting features of the Dart language.
Here are some suggestions for what to do now:

* Try [other Dart codelabs](/codelabs).
* Read the [Dart language tour](/language).
* Play with [DartPad.]({{site.dartpad}})
* [Get the Dart SDK](/get-dart).
