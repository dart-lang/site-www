---
title: Iterable collections
description: >-
  An interactive guide to using Iterable objects such as lists and sets.
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

This tutorial teaches you how to use collections that
implement the [Iterable][iterable class] class—for example
[List][list class] and [Set.][set class]
Iterables are basic building blocks for
all sorts of Dart applications,
and you're probably already using them,
even without noticing.
This tutorial helps you make the most out of them.

Using the embedded DartPad editors,
you can test your knowledge by
running example code and completing exercises.

To get the most out of this tutorial,
you should have basic knowledge of [Dart syntax](/language).

This tutorial covers the following material:

* How to read elements of an Iterable.
* How to check if the elements of an Iterable satisfy a condition.
* How to filter the contents of an Iterable.
* How to map the contents of an Iterable to a different value.

Estimated time to complete this tutorial: 60 minutes.

:::note
This page uses embedded DartPads to display examples and exercises.
{% render 'dartpads-embedded-troubleshooting.md' %}
:::

The exercises in this tutorial have partially completed code snippets.
You can use DartPad to test your knowledge by completing the code and
clicking the **Run** button.
**Don't edit the test code in the `main` function or below**.

If you need help, expand the **Hint** or **Solution** dropdown
after each exercise.

## What are collections?

A collection is an object that
represents a group of objects, which are called _elements_. 
Iterables are a kind of collection.

A collection can be empty, or it can contain many elements.
Depending on the purpose,
collections can have different structures and implementations.
These are some of the most common collection types:

* [List:][list class] Used to read elements by their indexes.
* [Set:][set class] Used to contain elements that can occur only once.
* [Map:][map class] Used to read elements using a key.


## What is an Iterable?

An `Iterable` is a collection of elements that can be accessed sequentially.

In Dart, an `Iterable` is an abstract class,
meaning that you can't instantiate it directly.
However, you can create a new `Iterable` by creating a new `List` or `Set`.

Both `List` and `Set` are `Iterable`,
so they have the same methods and properties as the `Iterable` class.

A `Map` uses a different data structure internally,
depending on its implementation.
For example, [HashMap][hashmap class] uses a hash table
in which the elements (also called _values_) are obtained using a key.
Elements of a `Map` can also be read as `Iterable` objects
by using the map's `entries` or `values` property.

This example shows a `List` of `int`,
which is also an `Iterable` of `int`:

<?code-excerpt "iterables/test/iterables_test.dart (iterable)"?>
```dart
Iterable<int> iterable = [1, 2, 3];
```

The difference with a `List` is that with the `Iterable`,
you can't guarantee that reading elements by index will be efficient.
`Iterable`, as opposed to `List`, doesn't have the `[]` operator.

For example, consider the following code, which is **invalid**:

<?code-excerpt "iterables/test/iterables_test.dart (iterable-elementat)" replace="/\.elementAt\(1\)/[![1]!]/g"?>
```dart tag=bad
Iterable<int> iterable = [1, 2, 3];
int value = iterable[![1]!];
```

If you read elements with `[]`,
the compiler tells you that the operator `'[]'`
isn't defined for the class `Iterable`,
which means that you can't use `[index]` in this case.

You can instead read elements with `elementAt()`,
which can step through the items of the iterable until
it reaches the item at that position.

<?code-excerpt "iterables/test/iterables_test.dart (iterable-elementat)"?>
```dart
Iterable<int> iterable = [1, 2, 3];
int value = iterable.elementAt(1);
```

Depending on the iterable implementation and number of items,
`elementAt` can have a linear complexity and be expensive.
If you plan to access specific items repeatedly, then consider
calling `.toList()` on the iterable to convert it to a list once,
then use the `[]` operator.

<?code-excerpt "iterables/test/iterables_test.dart (iterable-to-list)"?>
```dart
final items = veryLargeIterable().toList();

final tenthItem = items[9];
final hundredthItem = items[99];
final thousandthItem = items[999];
final lastItem = items.last;
```

Continue to the next section to learn more about
how to access elements of an `Iterable`.

## Reading elements

You can read the elements of an iterable sequentially,
using a `for-in` loop.

### Example: Using a for-in loop

The following example shows you how to read elements using  a `for-in` loop.

<?code-excerpt "iterables/test/iterables_test.dart (for-in)"?>
```dartpad
void main() {
  const iterable = ['Salad', 'Popcorn', 'Toast'];
  for (final element in iterable) {
    print(element);
  }
}
```

:::note Details
Behind the scenes, the `for-in` loop uses an _iterator._
You rarely see the [Iterator API][iterator class] used directly, however,
because `for-in` is easier to read and understand,
and is less prone to errors.
:::

:::secondary Key terms
* **Iterable**: The Dart [Iterable][iterable class] class.
* **Iterator**: An object used by `for-in` to read elements from
  an `Iterable` object.
* **`for-in` loop**: An easy way to sequentially read elements from
  an `Iterable`.
:::

### Example: Using first and last

In some cases, you want to access only the first or the last element
of an `Iterable`.

With the `Iterable` class, you can't access the elements directly,
so you can't call `iterable[0]` to access the first element.
Instead, you can use `first`,
which gets the first element.

Also, with the `Iterable` class,
you can't use the operator `[]` to access the last element,
but you can use the `last` property.

:::warning
Because accessing the last element of an `Iterable` requires
stepping through all the other elements,
**`last` can be slow.**
Using `first` or `last` on an **empty `Iterable`**
results in a [StateError.][StateError class]
:::

<?code-excerpt "iterables/test/iterables_test.dart (first-last)"?>
```dartpad
void main() {
  Iterable<String> iterable = const ['Salad', 'Popcorn', 'Toast'];
  print('The first element is ${iterable.first}');
  print('The last element is ${iterable.last}');
}
```

In this example you saw how to use `first` and `last` to
get the first and last elements of an `Iterable`.
It's also possible to find the first element that satisfies a condition.
The next section shows how to do that using a method called `firstWhere()`.

### Example: Using firstWhere()

You already saw that you can access the elements of an `Iterable` sequentially,
and you can easily get the first or last element.

Now, you learn how to use `firstWhere()` to find the first element that
satisfies certain conditions.
This method requires you to pass a _predicate_,
which is a function that returns true if
the input satisfies a certain condition.

<?code-excerpt "iterables/test/iterables_test.dart (firstwhere)"?>
```dart
String element = iterable.firstWhere((element) => element.length > 5);
```

For example, if you want to find the first `String` that has
more than 5 characters,
you must pass a predicate that returns true when
the element size is greater than 5.

Run the following example to see how `firstWhere()` works.
Do you think all the functions will give the same result?

<?code-excerpt "iterables/test/iterables_test.dart (first-where-long)"?>
```dartpad
bool predicate(String item) {
  return item.length > 5;
}

void main() {
  const items = ['Salad', 'Popcorn', 'Toast', 'Lasagne'];

  // You can find with a simple expression:
  var foundItem1 = items.firstWhere((item) => item.length > 5);
  print(foundItem1);

  // Or try using a function block:
  var foundItem2 = items.firstWhere((item) {
    return item.length > 5;
  });
  print(foundItem2);

  // Or even pass in a function reference:
  var foundItem3 = items.firstWhere(predicate);
  print(foundItem3);

  // You can also use an `orElse` function in case no value is found!
  var foundItem4 = items.firstWhere(
    (item) => item.length > 10,
    orElse: () => 'None!',
  );
  print(foundItem4);
}
```

In this example, you can see three different ways to write a predicate:

* **As an expression:**
  The test code has one line that uses arrow syntax (`=>`).
* **As a block:**
  The test code has multiple lines between brackets and a return statement.
* **As a function:**
  The test code is in an external function that's passed to
  the `firstWhere()` method as a parameter.

There is no right or wrong way.
Use the way that works best for you, 
and that makes your code easier to read and understand.

The final example calls `firstWhere()` with
the optional named parameter `orElse`,
which provides an alternative when an element isn't found.
In this case, the text `'None!'` is returned because
no element satisfies the provided condition.

:::note
If no element satisfies the test predicate and
the `orElse` parameter isn't provided,
then `firstWhere()` throws a [StateError.][StateError class]
:::

:::secondary Quick review
* The elements of an `Iterable` must be accessed sequentially.
* The easiest way to iterate through all the elements is
  using a `for-in` loop.
* You can use the `first` and `last` getters to get
  the first and last elements.
* You can also find the first element that
  satisfies a condition with `firstWhere()`.
* You can write test predicates as expressions, blocks, or functions.

  **Key terms:**
* **Predicate:**
  A function that returns `true` when a certain condition is satisfied.
:::

### Exercise: Practice writing a test predicate

The following exercise is a failing unit test that
contains a partially complete code snippet.
Your task is to complete the exercise by writing code to make the tests pass.
You don't need to implement `main()`.

This exercise introduces `singleWhere()`
This method works similarly to `firstWhere()`,
but in this case it expects only one element of the `Iterable` to
satisfy the predicate.
If more than one or no element in the `Iterable`
satisfies the predicate condition,
then the method throws a [StateError][StateError class] exception.

:::warning
`singleWhere()` steps through the whole `Iterable` until the last element,
which can cause problems if the `Iterable` is infinite or
contains a large collection of elements.
:::

Your goal is to implement the predicate for `singleWhere()` that
satisfies the following conditions:

* The element contains the character `'a'`.
* The element starts with the character `'M'`.

All the elements in the test data are [strings][String class];
you can check the class documentation for help.

```dartpad theme="dark"
// Implement the predicate of singleWhere
// with the following conditions
// * The element contains the character `'a'`
// * The element starts with the character `'M'`
String singleWhere(Iterable<String> items) {
  return items.singleWhere(TODO('Implement the outlined predicate.'));
}

// The following code is used to provide feedback on your solution.
// There is no need to read or modify it.
void main() {
  const items = [
    'Salad',
    'Popcorn',
    'Milk',
    'Toast',
    'Sugar',
    'Mozzarella',
    'Tomato',
    'Egg',
    'Water',
  ];

  try {
    final str = singleWhere(items);
    if (str == 'Mozzarella') {
      print('Success. All tests passed!');
    } else {
      print(
        'Tried calling singleWhere, but received $str instead of '
        'the expected value \'Mozzarella\'',
      );
    }
  } on StateError catch (stateError) {
    print(
      'Tried calling singleWhere, but received a StateError: ${stateError.message}. '
      'singleWhere will fail if 0 or many elements match the predicate.',
    );
  } on UnimplementedError {
    print(
      'Tried running `singleWhere`, but received an error. '
      'Did you implement the function?',
    );
  } catch (e) {
    print('Tried calling singleWhere, but received an exception: $e');
  }
}
```

<details>
  <summary title="Expand for a hint on the predicate exercise.">Hint</summary>

  Your solution might make use of the `contains` and `startsWith`
  methods from the `String` class.

</details>

<details>
  <summary title="Expand for the solution of the predicate exercise.">Solution</summary>

  ```dart
  String singleWhere(Iterable<String> items) {
    return items.singleWhere(
            (element) => element.startsWith('M') && element.contains('a'));
  }
  ```

</details>

## Checking conditions

When working with `Iterable`, sometimes you need to verify that
all the elements of a collection satisfy some condition.

You might be tempted to write a solution using a `for-in` loop like this one:

<?code-excerpt "iterables/test/iterables_test.dart (every-bad)"?>
```dart tag=bad
for (final item in items) {
  if (item.length < 5) {
    return false;
  }
}
return true;
```

However, you can accomplish the same using the `every()` method:

<?code-excerpt "iterables/test/iterables_test.dart (every-good)"?>
```dart
return items.every((item) => item.length >= 5);
```

Using the `every()` method results in code that is more
readable, compact, and less error-prone.

### Example: Using any() and every()

The `Iterable` class provides two methods that
you can use to verify conditions:

* `any()`: Returns true if at least one element satisfies the condition.
* `every()`: Returns true if all elements satisfy the condition.

Run this exercise to see them in action.

<?code-excerpt "iterables/test/iterables_test.dart (any-every)"?>
```dartpad
void main() {
  const items = ['Salad', 'Popcorn', 'Toast'];

  if (items.any((item) => item.contains('a'))) {
    print('At least one item contains "a"');
  }

  if (items.every((item) => item.length >= 5)) {
    print('All items have length >= 5');
  }
}
```

In the example, `any()` verifies that
at least one element contains the character `a`,
and `every()` verifies that all elements
have a length equal to or greater than 5.

After running the code, try changing the predicate of `any()` so
it returns false:

<?code-excerpt "iterables/test/iterables_test.dart (any-false)"?>
```dart
if (items.any((item) => item.contains('Z'))) {
  print('At least one item contains "Z"');
} else {
  print('No item contains "Z"');
}
```

You can also use `any()` to verify that no element of an `Iterable`
satisfies a certain condition.


### Exercise: Verify that an Iterable satisfies a condition

The following exercise provides practice using the
`any()` and `every()` methods, described in the previous example.
In this case, you work with a group of users,
represented by `User` objects that have the member field `age`.

Use `any()` and `every()` to implement two functions:

* Part 1: Implement `anyUserUnder18()`.
  * Return `true` if at least one user is 17 or younger.
* Part 2: Implement `everyUserOver13()`.
  * Return `true` if all users are 14 or older.

```dartpad
bool anyUserUnder18(Iterable<User> users) {
  // TODO: Implement the anyUserUnder18 function.
}

bool everyUserOver13(Iterable<User> users) {
  // TODO: Implement the everyUserOver13 function.
}

class User {
  final String name;
  final int age;

  User(
    this.name,
    this.age,
  );
}

// The following code is used to provide feedback on your solution.
// There is no need to read or modify it.
void main() {
  final users = [
    User('Alice', 21),
    User('Bob', 17),
    User('Claire', 52),
    User('David', 14),
  ];

  try {
    final out = anyUserUnder18(users);
    if (!out) {
      print('Looks like `anyUserUnder18` is wrong. Keep trying!');
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `anyUserUnder18`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print('Tried running `anyUserUnder18`, but received an exception: $e');
    return;
  }

  try {
    // with only one user older than 18, should be false
    final out = anyUserUnder18([User('Alice', 21)]);
    if (out) {
      print(
          'Looks like `anyUserUnder18` is wrong. What if all users are over 18?');
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `anyUserUnder18`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `anyUserUnder18([User("Alice", 21)])`, '
      'but received an exception: $e',
    );
    return;
  }

  try {
    final out = everyUserOver13(users);
    if (!out) {
      print(
        'Looks like `everyUserOver13` is wrong. '
        'There are no users under 13!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `everyUserOver13`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `everyUserOver13`, '
      'but received an exception: $e',
    );
    return;
  }

  try {
    final out = everyUserOver13([User('Dan', 12)]);
    if (out) {
      print(
        'Looks like `everyUserOver13` is wrong. '
        'There is at least one user under 13!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `everyUserOver13`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `everyUserOver13([User(\'Dan\', 12)])`, '
      'but received an exception: $e',
    );
    return;
  }

  print('Success. All tests passed!');
}
```

<details>
  <summary title="Expand for a hint on the conditional filtering exercise.">Hint</summary>

  Remember to use the `any` and `every` methods from the `Iterable` class.
  For help and examples using these methods, refer to
  the [earlier discussion of them](#example-using-any-and-every).

</details>

<details>
  <summary title="Expand for the solution of the conditional filtering exercise.">Solution</summary>

  ```dart
  bool anyUserUnder18(Iterable<User> users) {
    return users.any((user) => user.age < 18);
  }
  
  bool everyUserOver13(Iterable<User> users) {
    return users.every((user) => user.age > 13);
  }
  ```

</details>

:::secondary Quick review
* Although you can use `for-in` loops to check conditions,
  there are better ways to do that.
* The method `any()` enables you to check whether
  any element satisfies a condition.
* The method `every()` enables you to verify that
  all elements satisfy a condition.
:::

## Filtering

The previous sections cover methods like `firstWhere()` or
`singleWhere()` that can help you find an element that
satisfies a certain predicate.

But what if you want to find all the elements that
satisfy a certain condition?
You can accomplish that using the `where()` method.

<?code-excerpt "iterables/test/iterables_test.dart (where)"?>
```dart
var evenNumbers = numbers.where((number) => number.isEven);
```

In this example,
`numbers` contains an `Iterable` with multiple `int` values, and
`where()` finds all the numbers that are even.

The output of `where()` is another `Iterable`,
and you can use it as such to iterate over it or
apply other `Iterable` methods.
In the next example, the output of `where()`
is used directly inside the `for-in` loop.

<?code-excerpt "iterables/test/iterables_test.dart (where-for)"?>
```dart
var evenNumbers = numbers.where((number) => number.isEven);
for (final number in evenNumbers) {
  print('$number is even');
}
```

### Example: Using where()

Run this example to see how `where()` can be used together with other
methods like `any()`.

<?code-excerpt "iterables/test/iterables_test.dart (numbers-where)"?>
```dartpad
void main() {
  var evenNumbers = const [1, -2, 3, 42].where((number) => number.isEven);

  for (final number in evenNumbers) {
    print('$number is even.');
  }

  if (evenNumbers.any((number) => number.isNegative)) {
    print('evenNumbers contains negative numbers.');
  }

  // If no element satisfies the predicate, the output is empty.
  var largeNumbers = evenNumbers.where((number) => number > 1000);
  if (largeNumbers.isEmpty) {
    print('largeNumbers is empty!');
  }
}
```

In this example, `where()` is used to find all numbers that are even, then
`any()` is used to check if the results contain a negative number.

Later in the example, `where()` is used again to
find all numbers larger than 1000.
Because there are none, the result is an empty `Iterable`.

:::note
If no element satisfies the predicate in `where()`,
then the method returns an empty `Iterable`.
Unlike `singleWhere()` or `firstWhere()`,
`where()` doesn't throw a [StateError][StateError class] exception.
:::

### Example: Using takeWhile

The methods `takeWhile()` and `skipWhile()` can also
help you filter elements from an `Iterable`.

Run this example to see how `takeWhile()` and `skipWhile()` can
split an `Iterable` containing numbers.

<?code-excerpt "iterables/test/iterables_test.dart (take-while-long)"?>
```dartpad
void main() {
  const numbers = [1, 3, -2, 0, 4, 5];

  var numbersUntilZero = numbers.takeWhile((number) => number != 0);
  print('Numbers until 0: $numbersUntilZero');

  var numbersStartingAtZero = numbers.skipWhile((number) => number != 0);
  print('Numbers starting at 0: $numbersStartingAtZero');
}
```

In this example, `takeWhile()` returns an `Iterable` that
contains all the elements before the one that
satisfies the predicate.
On the other hand, `skipWhile()` returns an `Iterable` 
that contains all elements after and including the first one
that _doesn't_ satisfy the predicate.

After running the example,
change `takeWhile()` to take elements until
it reaches the first negative number.

<?code-excerpt "iterables/test/iterables_test.dart (takewhile)"?>
```dart
var numbersUntilNegative = numbers.takeWhile(
  (number) => !number.isNegative,
);
```

Notice that the condition `number.isNegative` is negated with `!`.

### Exercise: Filtering elements from a list

The following exercise provides practice using the `where()` method with 
the class `User` from the previous exercise.

Use `where()` to implement two functions:

* Part 1: Implement `filterOutUnder21()`.
  * Return an `Iterable` containing all users of age 21 or more.
* Part 2: Implement `findShortNamed()`.
  * Return an `Iterable` containing all users with
    names of length 3 or less.

```dartpad theme="dark"
Iterable<User> filterOutUnder21(Iterable<User> users) {
  // TODO: Implement the filterOutUnder21 function.
}

Iterable<User> findShortNamed(Iterable<User> users) {
  // TODO: Implement the findShortNamed function.
}

class User {
  final String name;
  final int age;

  User(
    this.name,
    this.age,
  );
}

// The following code is used to provide feedback on your solution.
// There is no need to read or modify it.
void main() {
  final users = [
    User('Alice', 21),
    User('Bob', 17),
    User('Claire', 52),
    User('Dan', 12),
  ];

  try {
    final out = filterOutUnder21(users);
    if (out.any((user) => user.age < 21) || out.length != 2) {
      print(
        'Looks like `filterOutUnder21` is wrong, there are '
        'exactly two users with age under 21. Keep trying!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `filterOutUnder21`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `filterOutUnder21`, '
      'but received an exception: ${e.runtimeType}',
    );
    return;
  }

  try {
    final out = findShortNamed(users);
    if (out.any((user) => user.name.length > 3) || out.length != 2) {
      print(
        'Looks like `findShortNamed` is wrong, there are '
        'exactly two users with a three letter name. Keep trying!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `findShortNamed`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `findShortNamed`, '
      'but received an exception: ${e.runtimeType}',
    );
    return;
  }

  print('Success. All tests passed!');
}
```

<details>
  <summary title="Expand for a hint on the filtering elements exercise.">Hint</summary>

  Remember to take advantage of the `where` method from the `Iterable` class.
  For help and examples using `where`, refer to
  the [earlier discussion of it](#example-using-where).

</details>

<details>
  <summary title="Expand for the solution of the filtering elements exercise.">Solution</summary>

  ```dart
  Iterable<User> filterOutUnder21(Iterable<User> users) {
    return users.where((user) => user.age >= 21);
  }
  
  Iterable<User> findShortNamed(Iterable<User> users) {
    return users.where((user) => user.name.length <= 3);
  }
  ```

</details>

:::secondary Quick review
* Filter the elements of an `Iterable` with `where()`.
* The output of `where()` is another `Iterable`.
* Use `takeWhile()` and `skipWhile()` to obtain elements until or after
  a condition is met.
* The output of these methods can be an empty `Iterable`.
:::

## Mapping

Mapping `Iterables` with the method `map()` enables you to
apply a function over each of the elements,
replacing each element with a new one.

<?code-excerpt "iterables/test/iterables_test.dart (map-int)"?>
```dart
Iterable<int> output = numbers.map((number) => number * 10);
```

In this example, each element of the `Iterable` numbers is multiplied by 10.

You can also use `map()` 
to transform an element into a different object—for example, 
to convert all `int` to `String`,
as you can see in the following example:

<?code-excerpt "iterables/test/iterables_test.dart (map-string)"?>
```dart
Iterable<String> output = numbers.map((number) => number.toString());
```

:::note
`map()` returns a _lazy_ `Iterable`, meaning that the supplied function
is called only when the elements are iterated.
:::

### Example: Using map to change elements

Run this example to see how to use `map()` to
multiply all the elements of an `Iterable` by 2.
What do you think the output will be?

<?code-excerpt "iterables/test/iterables_test.dart (numbers-by-two)"?>
```dartpad
void main() {
  var numbersByTwo = const [1, -2, 3, 42].map((number) => number * 2);
  print('Numbers: $numbersByTwo');
}
```


### Exercise: Mapping to a different type

In the previous example, you multiplied the elements of an `Iterable` by 2.
Both the input and the output of that operation were an `Iterable` of `int`.

In this exercise, your code takes an `Iterable` of `User`,
and you need to return an `Iterable` that
contains strings containing each user's name and age.

Each string in the `Iterable` must follow this format:
`'{name} is {age}'`—for example `'Alice is 21'`.

```dartpad theme="dark"
Iterable<String> getNameAndAges(Iterable<User> users) {
  // TODO: Implement the getNameAndAges function.
}

class User {
  final String name;
  final int age;

  User(
    this.name,
    this.age,
  );
}

// The following code is used to provide feedback on your solution.
// There is no need to read or modify it.
void main() {
  final users = [
    User('Alice', 21),
    User('Bob', 17),
    User('Claire', 52),
  ];

  try {
    final out = getNameAndAges(users).toList();
    if (!_listEquals(out, ['Alice is 21', 'Bob is 17', 'Claire is 52'])) {
      print(
        'Looks like `getNameAndAges` is wrong. Keep trying! '
        'The output was: $out',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `getNameAndAges`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print('Tried running the function, but received an exception: $e');
    return;
  }

  print('Success. All tests passed!');
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (var index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}
```

<details>
  <summary title="Expand for a hint on the mapping elements exercise.">Hint</summary>

  Remember to take advantage of the `map` method from the `Iterable` class.
  For help and examples using `map`, refer to
  the [earlier discussion of it](#example-using-map-to-change-elements).

  To concatenate multiple values into a single string, consider
  using [string interpolation](/language/built-in-types#string-interpolation).

</details>

<details>
  <summary title="Expand for the solution of the mapping elements exercise.">Solution</summary>

  ```dart
  Iterable<String> getNameAndAges(Iterable<User> users) {
    return users.map((user) => '${user.name} is ${user.age}');
  }
  ```

</details>

:::secondary Quick review
* `map()` applies a function to all the elements of an `Iterable`.
* The output of `map()` is another `Iterable`.
* The function isn't evaluated until the `Iterable` is iterated.
:::

## Exercise: Putting it all together

It's time to practice what you learned, in one final exercise.

This exercise provides the class `EmailAddress`,
which has a constructor that takes a string.
Another provided function is `isValidEmailAddress()`,
which tests whether an email address is valid.

| Constructor/function  | Type signature                           | Description                                             |
|-----------------------|------------------------------------------|---------------------------------------------------------|
| EmailAddress()        | `EmailAddress(String address)`           | Creates an `EmailAddress` for the specified address.    | 
| isValidEmailAddress() | `bool isValidEmailAddress(EmailAddress)` | Returns `true` if the provided `EmailAddress` is valid. |

{:.table .table-striped}

Write the following code:

Part 1: Implement `parseEmailAddresses()`.
- Write the function `parseEmailAddresses()`,
  which takes an `Iterable<String>` containing email addresses, 
  and returns an `Iterable<EmailAddress>`.
- Use the method `map()` to map from a `String` to `EmailAddress`.
- Create the `EmailAddress` objects using
  the constructor `EmailAddress(String)`.

Part 2: Implement `anyInvalidEmailAddress()`.
- Write the function `anyInvalidEmailAddress()`,
  which takes an `Iterable<EmailAddress>` and
  returns `true` if any `EmailAddress` in the `Iterable` isn't valid.
- Use the method `any()` together with
  the provided function `isValidEmailAddress()`.

Part 3: Implement `validEmailAddresses()`.
- Write the function `validEmailAddresses()`,
  which takes an `Iterable<EmailAddress>` and
  returns another `Iterable<EmailAddress>` containing only valid addresses.
- Use the method `where()` to filter the `Iterable<EmailAddress>`.
- Use the provided function `isValidEmailAddress()` to evaluate whether
  an `EmailAddress` is valid.

```dartpad theme="dark"
Iterable<EmailAddress> parseEmailAddresses(Iterable<String> strings) {
  // TODO: Implement the parseEmailAddresses function.
}

bool anyInvalidEmailAddress(Iterable<EmailAddress> emails) {
  // TODO: Implement the anyInvalidEmailAddress function.
}

Iterable<EmailAddress> validEmailAddresses(Iterable<EmailAddress> emails) {
  // TODO: Implement the validEmailAddresses function.
}

class EmailAddress {
  final String address;

  EmailAddress(this.address);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailAddress && address == other.address;

  @override
  int get hashCode => address.hashCode;

  @override
  String toString() => 'EmailAddress{address: $address}';
}

// The following code is used to provide feedback on your solution.
// There is no need to read or modify it.
void main() {
  const input = [
    'ali@gmail.com',
    'bobgmail.com',
    'cal@gmail.com',
  ];

  const correctInput = ['dash@gmail.com', 'sparky@gmail.com'];

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (var index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  final Iterable<EmailAddress> emails;
  final Iterable<EmailAddress> correctEmails;
  try {
    emails = parseEmailAddresses(input);
    correctEmails = parseEmailAddresses(correctInput);
    if (emails.isEmpty) {
      print(
        'Tried running `parseEmailAddresses`, but received an empty list.',
      );
      return;
    }
    if (!_listEquals(emails.toList(), [
      EmailAddress('ali@gmail.com'),
      EmailAddress('bobgmail.com'),
      EmailAddress('cal@gmail.com'),
    ])) {
      print('Looks like `parseEmailAddresses` is wrong. Keep trying!');
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `parseEmailAddresses`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `parseEmailAddresses`, '
      'but received an exception: $e',
    );
    return;
  }

  try {
    final out = anyInvalidEmailAddress(emails);
    if (!out) {
      print(
        'Looks like `anyInvalidEmailAddress` is wrong. Keep trying! '
        'The result should be false with at least one invalid address.',
      );
      return;
    }
    final falseOut = anyInvalidEmailAddress(correctEmails);
    if (falseOut) {
      print(
        'Looks like `anyInvalidEmailAddress` is wrong. Keep trying! '
        'The result should be false with all valid addresses.',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `anyInvalidEmailAddress`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
        'Tried running `anyInvalidEmailAddress`, but received an exception: $e');
    return;
  }

  try {
    final valid = validEmailAddresses(emails);
    if (emails.isEmpty) {
      print('Tried running `validEmailAddresses`, but received an empty list.');
      return;
    }
    if (!_listEquals(valid.toList(), [
      EmailAddress('ali@gmail.com'),
      EmailAddress('cal@gmail.com'),
    ])) {
      print('Looks like `validEmailAddresses` is wrong. Keep trying!');
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `validEmailAddresses`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running the `validEmailAddresses`, '
      'but received an exception: $e',
    );
    return;
  }

  print('Success. All tests passed!');
}

bool isValidEmailAddress(EmailAddress email) {
  return email.address.contains('@');
}
```

<details>
  <summary title="Expand for the solution of the 'Putting it all together' exercise.">Solution</summary>

  ```dart
  Iterable<EmailAddress> parseEmailAddresses(Iterable<String> strings) {
    return strings.map((s) => EmailAddress(s));
  }
  
  bool anyInvalidEmailAddress(Iterable<EmailAddress> emails) {
    return emails.any((email) => !isValidEmailAddress(email));
  }
  
  Iterable<EmailAddress> validEmailAddresses(Iterable<EmailAddress> emails) {
    return emails.where((email) => isValidEmailAddress(email));
  }
  ```

</details>

## What's next

Congratulations, you finished the tutorial!
If you want to learn more,
here are some suggestions for where to go next:

* Play with [DartPad.]({{site.dartpad}})
* Try another [tutorial](/tutorials).
* Read the [Iterable API reference][iterable class]
  to learn about methods that this tutorial doesn't cover.

[hashmap class]: {{site.dart-api}}/dart-collection/HashMap-class.html
[iterable class]: {{site.dart-api}}/dart-core/Iterable-class.html
[iterator class]: {{site.dart-api}}/dart-core/Iterator-class.html
[list class]: {{site.dart-api}}/dart-core/List-class.html
[map class]: {{site.dart-api}}/dart-core/Map-class.html
[set class]: {{site.dart-api}}/dart-core/Set-class.html
[StateError class]: {{site.dart-api}}/dart-core/StateError-class.html
[String class]: {{site.dart-api}}/dart-core/String-class.html
