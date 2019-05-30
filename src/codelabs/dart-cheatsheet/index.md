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

The Dart language is designed to be easy to learn for
coders coming from other languages,
but it has a few unique features.
This codelab — which is based on a 
[Dart language cheatsheet](/guides/language/cheatsheet)
written by and for Google engineers —
walks you through the most important of these language features.

The embedded editors in this codelab have partially completed code snippets.
You can use these editors to test your knowledge by completing the code and
clicking the **Run** button.
If you need help, click the **Hint** button.
To run the code formatter ([dartfmt](/tools/dartfmt)), click **Format**.
The **Reset** button erases your work and
restores the editor to its original state.

<aside class="alert alert-warning">
The embedded editors use an experimental version of DartPad.
If you find a DartPad bug or have suggestions for DartPad, please
<a target="_BLANK" href="https://github.com/dart-lang/dart-pad/issues/new">create a DartPad issue.</a>
If you have suggestions for the text or examples in this codelab,
you can create a site issue by clicking the bug icon
at the top right of this page.
</aside>


## String interpolation

To put the value of an expression inside a string, use `${expression}`.
If the expression is an identifier, you can omit the `{}`.

Here are some examples of using string interpolation:

| String                      | | Result |
|-----------------------------+-+ -------|
| `'${3 + 2}'`                | | `'5'` |
| `'${"word".toUpperCase()}'` | | `'WORD'` |
| `'$myObject'`               | | The value of `myObject.toString()` |

### Code example

The following function takes two integers as parameters.
Make it return a string containing both integers separated by a space.
For example, `stringify(2, 3)` should return `'2 3'`.

<iframe src="{{site.dartpadx}}?id=43f3db47b0632c557200270807696687"></iframe>


## Null-aware operators


Dart offers some handy operators for dealing with values that might be null. One is the
`??=` assignment operator, which assigns a value to a variable only if that
variable is currently null:

{% comment %}
TBD: Make this and all non-trivial snippets testable.
I found an error in one of the getter/setter snippets.
{% endcomment %}

{% prettify dart %}
int a; // The initial value of any object is null.
a ??= 3;
print(a); // <-- Prints 3.

a ??= 5;
print(a); // <-- Still prints 3.
{% endprettify %}

Another null-aware operator is `??`,
which returns the expression on its left unless that expression's value is null,
in which case it evaluates and returns the expression on its right:

{% prettify dart %}
    print(1 ?? 3); // <-- Prints 1.
    print(null ?? 12); // <-- Prints 12.
{% endprettify %}

### Code example

Try putting the `??=` and `??` operators to work below.

<iframe src="{{site.dartpadx}}?id=ee3d441f60acc95a07d73762a61b3b98"></iframe>


## Conditional property access

To guard access to a property or method of an object that might be null,
put a question mark (`?`) before the dot (`.`):

{% prettify dart %}
myObject?.someProperty
{% endprettify %}

The preceding code is equivalent to the following:

{% prettify dart %}
(myObject != null) ? myObject.someProperty : null
{% endprettify %}

You can chain multiple uses of `?.` together in a single expression:

{% prettify dart %}
myObject?.someProperty?.someMethod()
{% endprettify %}

The preceding code returns null (and never calls `someMethod`) if either
`myObject` or `myObject.someProperty` is
null.


### Code example

Try using conditional property access to finish the code snippet below.

<iframe src="{{site.dartpadx}}?id=58f14a3d943be6231ae611036fcfc80d"></iframe>


## Collection literals

Dart has built-in support for lists, maps, and sets.
You can create them using literals:

{% prettify dart %}
final aListOfStrings = ['one', 'two', 'three'];
final aSetOfStrings = {'one', 'two', 'three'};
final aMapOfStringsToInts = {
  'one': 1,
  'two': 2,
  'three': 3,
};
{% endprettify %}

Dart's type inference can assign types to these variables for you.
In this case, the inferred types are `List<String>`,
`Set<String>`, and `Map<String, int>`.

Or you can specify the type yourself:

{% prettify dart %}
final aListOfInts = <int>[];
final aSetOfInts = <int>{};
final aMapOfIntToDouble = <int, double>{};
{% endprettify %}

Specifying types is handy when you initialize a list with contents of a subtype,
but still want the list to be `List<BaseType>`:

{% prettify dart %}
final aListOfBaseType = <BaseType>[SubType(), SubType()];
{% endprettify %}

### Code example

Try setting the following variables to the indicated values.

<iframe src="{{site.dartpadx}}?id=8ba5e98559ff2a2e92e58ac5a28f1cff"></iframe>


## Arrow syntax

You might have seen the `=>` symbol in Dart code.
This arrow syntax is a way to define a function that executes the
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

Try finishing the following statements, which use arrow syntax.

<iframe src="{{site.dartpadx}}?id=7c287c55dcc7f414a5dfa5837e3450e3"></iframe>

{% comment %}
ISSUE: The analysis output kept getting in the way of my typing for the
last part of this code. Also, how are they supposed to know to use the
join() method?

TBD: The comments in "Your code" are in the form of doc comments,
but they don't use `///`, and they end in `:`, not `.`.
{% endcomment %}

## Cascades

To perform a sequence of operations on the same object, use cascades (`..`).
We've all seen an expression like this:

{% prettify dart %}
myObject.someMethod()
{% endprettify %}

It invokes `someMethod` on `myObject`, and the result of
the expression is the return value of `someMethod`.

Here's the same expression with a cascade:

{% prettify dart %}
myObject..someMethod()
{% endprettify %}

Although it still invokes `someMethod` on `myObject`, the result
of the expression **isn't** the return value — it's a reference to `myObject`!
Using cascades, you can chain together operations that
would otherwise require separate statements.
For example, consider this code:

{% prettify dart %}
var button = querySelector('#confirm');
button.text = 'Confirm';
button.classes.add('important');
button.onClick.listen((e) => window.alert('Confirmed!'));
{% endprettify %}

With cascades, the code becomes much shorter,
and you don’t need the `button` variable:

{% prettify dart %}
querySelector('#confirm')
..text = 'Confirm'
..classes.add('important')
..onClick.listen((e) => window.alert('Confirmed!'));
{% endprettify %}

### Code example

Use cascades to create a single statement that
sets the `anInt`, `aString`, and `aList` properties of a `BigObject`
to `1`, `'String!'`, and `[3.0]` (respectively)
and then calls `allDone()`.

<iframe src="{{site.dartpadx}}?id=72bde0b4d5c8c6046b4853a3b4053c3a"></iframe>


## Getters and setters

You can define getters and setters
whenever you need more control over a property
than a simple field allows.

For example, you can make sure a property's value is valid:

{% prettify dart %}
class MyClass {
  int _aProperty = 0;

  int get aProperty => _aProperty;

  set aProperty(int value) {
    if (value >= 0) {
      _aProperty = value;
    }
  }
}
{% endprettify %}

You can also use a getter to define a computed property:

{% prettify dart %}
class MyClass {
  List<int> _values = [];

  void addValue(int value) {
    _values.add(value);
  }

  // A computed property.
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

Optional positional parameters are always last
in a function's parameter list.
Their default value is null unless you provide another default value:

{% prettify dart %}
int sumUpToFive(int a, [int b = 2, int c = 3, int d = 4, int e = 5]) {
  ...
}

int newTotal = sumUpToFive(1);
print(newTotal); // <-- prints 15
{% endprettify %}

### Code example

Implement a function called `joinWithCommas` that accepts one to
five integers, then returns a string of those numbers separated by commas.
Here are some examples of function calls and returned values:

| Function call                   | | Returned value |
|---------------------------------+-+----------------|
| `joinWithCommas(1)`             | | `'1'`          |
| `joinWithCommas(1, 2, 3)`       | | `'1,2,3'`      |
| `joinWithCommas(1, 1, 1, 1, 1)` | | `'1,1,1,1,1'`  |

<br>

<iframe src="{{site.dartpadx}}?id=9e7d5b6b56319b7e3b12b791c0ae27c1"></iframe>


## Optional named parameters

Using a curly brace syntax,
you can define optional parameters that have names.

{% prettify dart %}
void printName(String firstName, String lastName, {String suffix}) {
  print('$firstName $lastName ${suffix ?? ''}');
}

printName('Avinash', 'Gupta');
printName('Poshmeister', 'Moneybuckets', suffix: 'IV');
{% endprettify %}

As you might expect, the value of these parameters is null by default,
but you can provide default values:

{% prettify dart %}
void printName(String firstName, String lastName, {String suffix = ''}) {
  print('$firstName $lastName ${suffix}');
}
{% endprettify %}

A function can't have both optional positional and optional named parameters.


### Code example

Add a `copyWith` instance method to the `MyDataObject`
class. It should take three named parameters:

* `int newInt`
* `String newString`
* `double newDouble`

When called, `copyWith` should return a new `MyDataObject`
based on the current instance,
with data from the preceding parameters (if any)
copied into the object's properties.
For example, if `newInt` is non-null,
then copy its value into `anInt`.

<iframe src="{{site.dartpadx}}?id=1dd9cc9654f9e6d080f99bfb9772dae4"></iframe>


## Exceptions

Dart code can throw and catch exceptions. In contrast to Java, all of Dart’s exceptions are unchecked
exceptions. Methods don't declare which exceptions they might throw, and you aren't required to catch
any exceptions.

Dart provides `Exception` and `Error` types, but you're
allowed to throw any non-null object:

{% prettify dart %}
throw Exception('Something bad happened.');
throw 'Waaaaaaah!';
{% endprettify %}

Use the `try`, `on`, and `catch` keywords when handling exceptions:

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

The `try` keyword works as it does in most other languages.
Use the `on` keyword to filter for specific exceptions by type,
and the `catch` keyword to get a reference to the exception object.

If you can't completely handle the exception, use the `rethrow` keyword
to propagate the exception:

{% prettify dart %}
try {
  breedMoreLlamas();
} catch (e) {
  print('I was just trying to breed llamas!.');
  rethrow;
}
{% endprettify %}

To execute code whether or not an exception is thrown,
use `finally`:

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
  call `logger.logException` with the exception type and message
  (try using `on` and `catch`).
* If `untrustworthy` throws an `Exception`,
  call `logger.logException` with the exception type
  (try using `on` for this one).
* If `untrustworthy` throws any other object, don't catch the exception.
* After everything's caught and handled, call `logger.doneLogging`
  (try using `finally`).

<iframe src="{{site.dartpadx}}?id=e221e3fd667825e62aac79079b8b5c59"></iframe>

{% comment %}
I was confused about the text saying "call... with the exception type" but
using only on for it (since how would you know the type without the exception
object?). I used on catch at first, and that worked. Then I looked at the
solution and changed to what it used, and it did NOT work! Here's what I saw:

Untrustworthy threw an Exception, but a different type was logged: Exception.

(Looking at the test code, I see the type it looks for is actually _Exception.)

Both the text & the test need to be changed.

ISSUE: Solution doesn't exactly match the comments in "Your code", so the
line count is off.

ISSUE: When I select all in the Solution and then switch to the Your code tab,
everything in THAT tab looks selected, too. The same is NOT true of the
Test code tab. After I reloaded, this behavior stopped.
{% endcomment %}


## Using `this` in a constructor

Dart provides a handy shortcut for assigning
values to properties in a constructor:
use `this.propertyName` when declaring the constructor:

{% prettify dart %}
class MyColor {
  int red;
  int green;
  int blue;

  MyColor(this.red, this.green, this.blue);
}

final color = MyColor(80, 80, 128);
{% endprettify %}

This technique works for named parameters, too.
Property names become the names of the parameters:

{% prettify dart %}
class MyColor {
  ...

  MyColor({this.red, this.green, this.blue});
}

final color = MyColor(red: 80, green: 80, blue: 80);
{% endprettify %}

For optional parameters, default values work as expected:

{% prettify dart %}
MyColor([this.red = 0, this.green = 0, this.blue = 0]);
// or
MyColor({this.red = 0, this.green = 0, this.blue = 0});
{% endprettify %}

### Code example

Add a one-line constructor to `MyClass` that uses
`this.` syntax to receive and assign values for
all three properties of the class.

<iframe src="{{site.dartpadx}}?id=2778e81ae2c5729d45c611829f3888c2"></iframe>

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

{% prettify dart %}
Point.fromJson(Map<String, num> json)
    : x = json['x'],
      y = json['y'] {
  print('In Point.fromJson(): ($x, $y)');
}
{% endprettify %}

The initializer list is also a handy place to put asserts,
which run only during development:

{% prettify dart %}
NonNegativePoint(this.x, this.y)
    : assert(x >= 0),
      assert(y >= 0) {
  print('I just made a NonNegativePoint: ($x, $y)');
}
{% endprettify %}

### Code example

Complete the `FirstTwoLetters` constructor below.
Use an initializer list to assign the first two characters in `word` to
the `letterOne` and `LetterTwo` properties.
For extra credit, add an `assert` to catch words of less than two characters.

{% comment %}
ISSUE: The test was broken. I've fixed it in my gist.

Is the assert even executed? I can't see any effect on the test,
which makes me think asserts are ignored.
Also, the test just checks for the presence of any exception, not for
an AssertionError.

Also, my print() wasn't visible in the Output until I fixed my code and/or
the test. That was unexpected.
It'd be cool if Output appeared only if you want it, like Solution does.
{% endcomment %}

<iframe src="{{site.dartpadx}}?id=df45dfc1af2e6af712930c331115eb78"></iframe>


## Named constructors

{% comment %}
Much like JavaScript, Dart doesn't support method overloads
(two methods with the same name but different signatures).
[ISSUE: methods & constructors aren't the same thing,
so I deleted that. We can add it back if we can word it better.]
{% endcomment %}
To allow classes to have multiple constructors,
Dart supports named constructors:

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

To use a named constructor, invoke it using its full name:

{% prettify dart %}
final myPoint = Point.origin();
{% endprettify %}

### Code example

Give the Color class a constructor named `Color.black`
that sets all three properties to zero.

{% comment %}
ISSUE: comment says "a named constructor called "black"", which sounds
wrong to me. I fixed it in the text but not in the example.
{% endcomment %}

<iframe src="{{site.dartpadx}}?id=e1a82c77547e659eb24f4e698abf1eca"></iframe>


## Factory constructors

Dart supports factory constructors,
which can return subtypes or even null.
To create a factory constructor, use the `factory` keyword:

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

Fill in the factory constructor named `IntegerHolder.fromList`,
making it do the following:

* If the list has **one** value,
  create an `IntegerSingle` with that value.
* If the list has **two** values,
  create an `IntegerDouble` with the values in order.
* If the list has **three** values,
  create an `IntegerTriple` with the values in order.
* Otherwise, return null.
    
{% comment %}
TODO: Fix the comment to not say "named".
ISSUE: The hint acts like you don't already have the signature for the constructor.
{% endcomment %}
<iframe src="{{site.dartpadx}}?id=727981a8ece1244b52a3c6dc377a8085"></iframe>


## Redirecting constructors

Sometimes a constructor’s only purpose is to redirect to
another constructor in the same class.
A redirecting constructor’s body is empty,
with the constructor call appearing after a colon (`:`).

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

Modify the `Recipe` class so its instances can be constants,
and create a constant constructor that does the following:

* Has three parameters: `ingredients`, `calories`,
  and `milligramsOfSodium` (in that order).
* Uses `this.` syntax to automatically assign the parameter values to the
  object properties of the same name.
* Is constant, with the `const` keyword just before
  `Recipe` in the constructor declaration.

<iframe src="{{site.dartpadx}}?id=c400cb84fab309ddbbb436c1ced90dad"></iframe>

{% comment %}
TODO: Copy edit the hint.
{% endcomment %}

## What next?

We hope you enjoyed using this codelab to learn or test your knowledge of
some of the most interesting features of the Dart language.
Here are some suggestions for what to do now:

* Try [other Dart codelabs](/codelabs).
* Read the [Dart language tour](/guides/language/language-tour).
* Play with [DartPad.]({{site.dartpad}})
* [Get the Dart SDK](/get-dart).
