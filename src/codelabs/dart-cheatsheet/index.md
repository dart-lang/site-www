---
title: Dart cheatsheet codelab
description: Interactively learn (or relearn) some of Dart's unique features.
---

<style>
  iframe {
    border: 1px solid #ccc;
    width: 100%;
    height: 400px;
  }

  iframe[short] {
    height: 220px;
  }
</style>

<aside class="alert alert-warning">
This codelab is being used to test out some new features of DartPad! You may encounter bugs,
malapropisms, annoyances, and other general weirdness. If that happens, please take a moment to
<a target="_BLANK" href="https://github.com/dart-lang/dart-pad/issues/new">fill out a bug report on GitHub</a>
and let us know. Feature requests and suggestions are also greatly appreciated.
</aside>

Dart is designed to be easy to learn for coders coming from other languages,
but it also has a few unique features.
This codelab will walk you through the most important ones,
and can be a handy place to return for a refresher as you grow your Dart skills.

In addition to explanations and examples,
the codelab includes embedded editors with partially completed code snippets.
You can use these editors to test your knowledge by completing the code and
clicking the **Run** button.



## String interpolation

Dart offers string interpolation to simplify formatting variables and expressions
as strings. You can put the value of an expression inside a string by using
`${expression}`. If the expression is an identifier, you can
skip the `{}`.

Some examples:

* `'${3 + 2}'` becomes `'5'`
* `'${"word".toUpperCase()}'` becomes `'WORD'`
* `'$myObject'` becomes the value of `myObject.toString()`

### Code example

The following function takes two integers as parameters. Add code to make it return
a string containing both numbers separated by a space (e.g.
`2` and `3` become `'2 3'`).

<iframe src="{{site.dartpadx}}?id=43f3db47b0632c557200270807696687"></iframe>


## Null-aware operators


Dart offers some handy operators for dealing with values that might be null. One is the
`??=` assignment operator, which assigns a value to a variable only if that
variable is currently null:

{% prettify dart %}
int a = null;
a ??= 3;
print(a); // <-- Prints 3;

a ??= 5;
print(a); // <-- Still prints 3;
{% endprettify %}

There's also the `??` operator, which returns the expression on its left unless
its value is null, in which case it evaluates and returns the expression on its right:

{% prettify dart %}
    print(1 ?? 3); // <-- Prints 1;
    print(null ?? 12); // <-- Prints 12.
{% endprettify %}

### Code example

Try putting the `??=` and `??`
operators to work below:

<iframe src="{{site.dartpadx}}?id=f8ab52228b9c03aee9504dbdc15d797d"></iframe>


## Conditional property access

To access a property or method on a reference that might be null, you can use
`?.` to guard the call:

{% prettify dart %}
myObject?.someProperty
{% endprettify %}

The above code is equivalent to:

{% prettify dart %}
(myObject != null) ? myObject.someProperty : null
{% endprettify %}

You can chain multiple uses of `?.` together in a single expression:

{% prettify dart %}
myObject?.someProperty?.someMethod()
{% endprettify %}

The above code returns null (and never calls `someMethod`) if either
`myObject` or `myObject.someProperty` is
null.


### Code example

Try using conditional property access to finish the code snippet below:

<iframe src="{{site.dartpadx}}?id=58f14a3d943be6231ae611036fcfc80d"></iframe>


## Collection literals

Dart has built-in support for lists, maps, and sets. You can create them using literals:

{% prettify dart %}
final aListOfStrings = ['one', 'two', 'three'];
final aSetOfStrings = {'one', 'two', 'three'};
final aMapOfStringsToInts = {
  'one': 1,
  'two': 2,
  'three': 3,
};
{% endprettify %}

Dart's type inference is capable of assigning types to these variables for you. In this case, the
inferred types are `List<String>`,
`Set<String>`, and `Map<String, int>`.

You can also specify the type for a collection literal:

{% prettify dart %}
final aListOfInts = <int>[];
final aSetOfInts = <int>{};
final aMapOfIntToDouble = <int, double>{};
{% endprettify %}

Specifying types is handy if you initialize a list with contents of a subtype, but still want the list
itself to be `List<BaseType>`:

{% prettify dart %}
final aListOfBaseType = <BaseType>[SubType(), SubType()];
{% endprettify %}

### Code example

Try setting the following variables to the indicated values:

<iframe src="{{site.dartpadx}}?id=f0d6e5f14e4606befa388f52eebc2647"></iframe>


## Arrow syntax

In the previous examples, you may have noticed an operator that looks like `=>`.
Dart's docs refer to it as "arrow syntax," and it's a way to define a function that executes the
expression to its right and returns its value.

For example, consider this call to the `List` class's
`any` method:

{% prettify dart %}
bool hasEmpty = aListOfStrings.any((s) {
  return s.isEmpty;
});
{% endprettify %}

Here’s a simpler way to write that code:

{% prettify dart %}
bool hasEmpty = aListOfStrings.any((s) => s.isEmpty);
{% endprettify %}

### Code example

Try finishing these statements that use arrow syntax:

<iframe src="{{site.dartpadx}}?id=7c287c55dcc7f414a5dfa5837e3450e3"></iframe>


## Cascades

Cascades (`..`) allow you to make a sequence of operations on the same object.
We've all seen an expression like this:

{% prettify dart %}
myObject.someMethod()
{% endprettify %}


It invokes `someMethod` on `myObject`, and the result of
the expression is the return value of `someMethod`.

The same expression with a cascade, however:

{% prettify dart %}
myObject..someMethod()
{% endprettify %}

Still invokes `someMethod` on `myObject`, but the result
of the expression isn't the return value -- it's a reference to `myObject`! This
way, you can chain together operations that would otherwise require separate statements. For example,
consider this code:

{% prettify dart %}
var button = querySelector('#confirm');
button.text = 'Confirm';
button.classes.add('important');
button.onClick.listen((e) => window.alert('Confirmed!'));
{% endprettify %}

With cascades, the code becomes much shorter, and you don’t need the `button`
variable:

{% prettify dart %}
querySelector('#confirm')
..text = 'Confirm'
..classes.add('important')
..onClick.listen((e) => window.alert('Confirmed!'));
{% endprettify %}

### Code example

Use cascades to create a single statement that sets a `BigObject`’s
`anInt`, `aString`, and `aList`
properties to `1`, `'String!'`, and
`[3.0]`, respectively, and then calls `allDone`:

<iframe src="{{site.dartpadx}}?id=72bde0b4d5c8c6046b4853a3b4053c3a"></iframe>


## Getters and setters

Dart supports getters and setters for properties via the `get` and `set` keywords.
You can use getters and setters to guard access of a private variable:

{% prettify dart %}
class MyClass {
  int _privateField = 0;

  int get privateField => _privateField;

  set privateField(int value) {
    if (value >= 0) {
      _privateField = value;
    }
  }
}
{% endprettify %}

You can also define getters for computed properties like this one:

{% prettify dart %}
class MyClass {
  List<div> _values = [];

  void addValue(int value) {
    _values.add(value);
  }

  int get count {
    return _values.length;
  }
}
{% endprettify %}

### Code example

Imagine you have a shopping cart class that keeps a private `List<double>`
of prices.
Add the following:

* A getter called `total` that returns the sum of the prices
* A setter that replaces the list with a new one,
  as long as the new list doesn't contain any negative prices
  (in which case the setter should throw an `InvalidPriceException`).

<iframe src="{{site.dartpadx}}?id=84561041d263cbd4c92f614eceec85e6"></iframe>


## Optional positional parameters

Dart has two kinds of function parameters: positional and named. Positional parameters are the kind
you're likely familiar with:

{% prettify dart %}
int sumUp(int a, int b, int c) {
  return a + b + c;
}

int total = sumUp(1, 2, 3);
{% endprettify %}

With Dart, you can make these positional parameters optional by wrapping them in brackets:

{% prettify dart %}
int sumUpToFive(int a, [int b, int c, int d, int e]) {
  int sum = a;
  if (b != null) sum += b;
  if (c != null) sum += c;
  if (d != null) sum += d;
  if (e != null) sum += e;
  return sum;
}

int total = sumUptoFive(1, 2);
int otherTotal = sumUpToFive(1, 2, 3, 4, 5);
{% endprettify %}

Optional positional parameters should always be placed last in a function's parameter list. They default
to null, but you can provide default values if desired:

{% prettify dart %}
int sumUpToFive(int a, [int b = 2, int c = 3, int d = 4, int e = 5]) {
  ...
}

int newTotal = sumUpToFive(1);
print(newTotal); // <-- prints 15
{% endprettify %}

### Code example

Implement a function called `joinWithCommas` that accepts at least one and up to
five integers, then returns a string of those numbers separated by commas:

* `joinWithCommas(1)` should return `'1'`.
* `joinWithCommas(1, 2, 3)` should return `'1,2,3'`.
* `joinWithCommas(1, 1, 1, 1, 1)` should return `'1,1,1,1,1'`.
* etc.

<iframe src="{{site.dartpadx}}?id=9e7d5b6b56319b7e3b12b791c0ae27c1"></iframe>


## Optional named parameters

Dart also allows for optional parameters that are referenced by name when the function is invoked. These
are defined using a brace syntax:

{% prettify dart %}
void printName(String firstName, String lastName, {String suffix}) {
  print('$firstName $lastName ${suffix ?? ''}');
}

printName('Avinash', 'Gupta');
printName('Poshmeister', 'Moneybuckets', suffix: 'IV');
{% endprettify %}

Like optional positional parameters they default to null, but it's possible to provide default values as
well:

{% prettify dart %}
void printName(String firstName, String lastName, {String suffix = ''}) {
  print('$firstName $lastName ${suffix}');
}
{% endprettify %}

A function cannot have both optional positional and optional named parameters.


### Code example

Add a `copyWith` instance method to the `MyDataObject`
class. It should take three named parameters:

* `int newInt`
* `String newString`
* `double newDouble`

When called, it should return a new `MyDataObject` based on the current
instance, with data from the above parameters copied into the object's properties (e.g. the value of
`newInt` is copied into `anInt`). Any parameters that
aren't supplied (they'll be null) should be ignored.

<iframe src="{{site.dartpadx}}?id=1dd9cc9654f9e6d080f99bfb9772dae4"></iframe>


## Exceptions

Dart code can throw and catch exceptions. In contrast to Java, all of Dart’s exceptions are unchecked
exceptions. Methods do not declare which exceptions they might throw, and you are not required to catch
any exceptions.

Dart provides `Exception` and `Error` types, but you're
allowed to throw any non-null object:

{% prettify dart %}
throw Exception('Something bad happened.');
throw 'Waaaaaaah!';
{% endprettify %}

There are three keywords to remember for handling exceptions: `try`,
`on`, and `catch`:

{% prettify dart %}
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
{% endprettify %}

The `try` keyword works as it does in most other languages. The
`on` keyword is used to filter for specific exceptions by type, and the
`catch` keyword is used to get a reference to the exception object. They can be
used together or separately, as shown in the previous example.

Exceptions can be rethrown using the `rethrow` keyword:

{% prettify dart %}
try {
  breedMoreLlamas();
} catch (e) {
  print('I was just trying to breed llamas!.');
  rethrow;
}
{% endprettify %}

And if you need to execute code whether or not an exception is thrown, you can do so with
`finally`:

{% prettify dart %}
try {
  breedMoreLlamas();
} catch (e) {
  … handle exception ...
} finally {
  // Always clean up, even if an exception is thrown.
  cleanLlamaStalls();
}
{% endprettify %}

### Code example

Implement `tryFunction` below. It should execute an untrustworthy method and
then do the following:

* If `untrustworthy` throws an `ExceptionWithMessage`,
  `logger.logException` should be called with the exception type and message
  (try using `on` and `catch`).
    
* If `untrustworthy` throws an `Exception`,
  `logger.logException` should be called with the exception type (try using
  `on` for this one).
    
* If `untrustworthy` throws any other object, it shouldn't be caught.
    
* After everything's caught and handled, `logger.doneLogging` should be called
  (try using `finally`).

<iframe src="{{site.dartpadx}}?id=e221e3fd667825e62aac79079b8b5c59"></iframe>


## Using `this` in a constructor

Dart provides a handy shortcut for assigning values to properties in a constructor. Simply use
`this.propertyName` when declaring the constructor:

{% prettify dart %}
class MyColor {
  int red;
  int green;
  int blue;

  MyColor(this.red, this.green, this.blue);
}

final color = MyColor(80, 80, 128);
{% endprettify %}

This works for named parameters as well. Property names become the names of the parameters:

{% prettify dart %}
class MyColor {
  ...

  MyColor({this.red, this.green, this.blue});
}

final color = MyColor(red: 80, green: 80, blue: 80);
{% endprettify %}

Default values work as expected for both parameter types:

{% prettify dart %}
MyColor([this.red = 0, this.green = 0, this.blue = 0]);
// or
MyColor({this.red = 0, this.green = 0, this.blue = 0});
{% endprettify %}

### Code example

Add a one-line constructor to `MyClass` that will use
`this.` syntax to receive and assign values for all three of the class's
properties:

<iframe src="{{site.dartpadx}}?id=2778e81ae2c5729d45c611829f3888c2"></iframe>


## Initializer lists

In between a constructor's signature and its body, you can place an initializer list:

{% prettify dart %}
// Initializer list sets instance variables before
// the constructor body runs.
Point.fromJson(Map<String, num> json)
    : x = json['x'],
      y = json['y'] {
  print('In Point.fromJson(): ($x, $y)');
}
{% endprettify %}

This is a good place to initialize final fields, and it's executed before the constructor body. In
addition, the initializer list is a handy place to put asserts for running in debug mode:

{% prettify dart %}
NonNegativePoint(this.x, this.y)
    : assert(x >= 0),
      assert(y >= 0) {
  print('I just made a NonNegativePoint: ($x, $y)');
}
{% endprettify %}

### Code example

Complete the `FirstTwoLetters` constructor below. It should use an initializer
list to assign the first two characters in `word` to the
`letterOne` and `LetterTwo` properties. You can also
throw in an `assert` to catch words less than two characters in length for extra
credit!

<iframe src="{{site.dartpadx}}?id=4bf47cf7e11bc5902e605a3efc3183ec"></iframe>


## Named constructors

Much like JavaScript, Dart does not support method overloads (two methods with the same name but
different signatures). To allow for classes with multiple constructors, Dart supports named
constructors:

{% prettify dart %}
class Point {
  num x, y;

  Point(this.x, this.y);

  Point.origin() {
    x = 0;
    y = 0;
  }
}
{% endprettify %}

These are invoked using their full name:

{% prettify dart %}
final myPoint = Point.origin();
{% endprettify %}

### Code example

Try giving this class a named constructor called `black` that sets all three
properties to zero.

<iframe src="{{site.dartpadx}}?id=e1a82c77547e659eb24f4e698abf1eca"></iframe>


## Factory constructors

Dart also supports factory constructors, which are named constructors that can return subtypes or even
null. To create one, use the `factory` keyword:

{% prettify dart %}
class Square extends Shape {}

class Circle extends Shape {}

class Shape {
  Shape();

  factory Shape.fromTypeName(String typeName) {
    if (typeName == 'square') return Square();
    if (typeName == 'circle') return Circle();

    print('I don\'t recognize $typeName');
    return null;
  }
}
{% endprettify %}

### Code example

Fill in the factory constructor for `IntegerHolder` below. It should do the
following:

* If there's one value in the list, create an `IntegerSingle` with that value.
* If there are two values, create an `IntegerDouble` with the values in order.
* If there are three values, create an `IntegerTriple` with values in order.
* Otherwise, return null.
    
<iframe src="{{site.dartpadx}}?id=727981a8ece1244b52a3c6dc377a8085"></iframe>


## Redirecting constructors

Sometimes a constructor’s only purpose is to redirect to another constructor in the same class. A
redirecting constructor’s body is empty, with the constructor call appearing after a colon (:).

{% prettify dart %}
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
{% endprettify %}

### Code example

Remember the `Color` class from above? Create a named constructor called
`black`, but rather than manually assigning the properties, redirect it to the
default constructor with zeros as the arguments.

<iframe src="{{site.dartpadx}}?id=94eb1d8be5b64163753c7350f1f09edf"></iframe>


## Const constructors

If your class produces objects that never change, you can make these objects compile-time constants. To
do this, define a `const` constructor and make sure that all instance variables
are final.

{% prettify dart %}
class ImmutablePoint {
  const ImmutablePoint(this.x, this.y);

  final int x;
  final int y;

  static const ImmutablePoint origin =
      ImmutablePoint(0, 0);
}
{% endprettify %}

### Code example

Create a constant constructor for the `Recipe` class below. It should do the
following:

* Have three parameters: `ingredients`, `calories`,
  and `milligramsOfSodium` (in that order).
* Use `this.` syntax to automatically assign the parameter values to the
  object properties of the same name.
* Be constant (use the `const` keyword just before
  `Recipe` when declaring the constructor.

<iframe src="{{site.dartpadx}}?id=c400cb84fab309ddbbb436c1ced90dad"></iframe>
