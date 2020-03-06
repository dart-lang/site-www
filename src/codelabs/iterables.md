---
title: Iterable collections
description: An interactive guide to using Iterable objects such as lists and sets.
---

This codelab teaches you how to use collections that
implement the [Iterable][iterable class] class —
for example [List][list class] and [Set.][set class]
Iterables are basic building blocks for
all sorts of Dart applications,
and you're probably already using them,
even without noticing.
This codelab helps you make the most out of them.

Using the embedded DartPad editors,
you can test your knowledge by
running example code and completing exercises.

To get the most out of this codelab,
you should have basic knowledge of [Dart syntax](/samples).

This codelab covers the following material:

* How to read elements of an Iterable.
* How to check if the elements of an Iterable satisfy a condition.
* How to filter the contents of an Iterable.
* How to map the contents of an Iterable to a different value.

Estimated time to complete this codelab: 60 minutes.

{{site.alert.note}}
  This page uses embedded DartPads to display examples and exercises.
  {% include dartpads-embedded-troubleshooting.md %}
{{site.alert.end}}

## Why do you need collections?

Iterables are a kind of collection.
A collection is an object that
represents a group of objects, which are called _elements_.

A collection can be empty, or it can contain many elements.
Depending on the purpose,
collections can have different structures and implementations.
These are some of the most common collection types:

* [List:][list class] Used to read elements by their indexes.
* [Set:][set class] Used to contain elements that can occur only once.
* [Map:][map class] Used to read elements using a key.

In Dart, both `List` and `Set` are `Iterable`,
so they have the same methods and properties as the `Iterable` class.

A `Map` uses a different data structure internally,
depending on its implementation.
For example, [HashMap][hashmap class] uses a hash table
in which the elements (also called _values_) are obtained using a key.
Elements of a `Map` can also be read as `Iterable` objects
by using the map's `entries` or `values` property.

## What is an Iterable?

An `Iterable` is a collection of elements that can be accessed sequentially.

In Dart, an `Iterable` is an abstract class,
meaning that you can't instantiate it directly.
However, you can create a new `Iterable` by creating a new `List` or `Set`.
 
This example shows a `List` of `int`,
which is also an `Iterable` of `int`:

<?code-excerpt "iterables/test/iterables_test.dart (iterable)"?>
{% prettify dart tag=pre+code %}
Iterable<int> iterable = [1, 2, 3];
{% endprettify %}

The difference with a `List` is that with the `Iterable`,
you can't guarantee that reading elements by index will be efficient.
`Iterable`, as opposed as `List`, doesn't have the `[]` operator.

For example, consider the following code, which is **invalid**:

{:.bad}
<?code-excerpt "iterables/test/iterables_test.dart (iterable-elementat)" replace="/\.elementAt\(1\)/[![1]!]/g"?>
{% prettify dart tag=pre+code %}
Iterable<int> iterable = [1, 2, 3];
int value = iterable[![1]!];
{% endprettify %}

If you read elements with `[]`,
the compiler tells you that the operator `'[]'`
isn't defined for the class `Iterable`,
which means that you can't use `[index]` in this case.

You can instead read elements with `elementAt()`,
which steps through the elements of the iterable until
it reaches that position.

<?code-excerpt "iterables/test/iterables_test.dart (iterable-elementat)"?>
{% prettify dart tag=pre+code %}
Iterable<int> iterable = [1, 2, 3];
int value = iterable.elementAt(1);
{% endprettify %}

Continue to the next section to learn more about
how to access elements of an `Iterable`.

## Reading elements

You can read the elements of an iterable sequentially,
using a `for-in` loop.

### Example: Using a for-in loop

The following example shows you how to read elements using  a `for-in` loop.

[//]: https://gist.github.com/c419f595f95e8317c54192491ae017cd
<iframe
  src="{{site.dartpad-embed}}?id=c419f595f95e8317c54192491ae017cd&ga_id=for_in_loop"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="200"
  width="100%" >
</iframe>

{{site.alert.info}}
Behind the scenes, the `for-in` loop uses an _iterator._
You rarely see the [Iterator API][iterator class] used directly, however,
because `for-in` is easier to read and understand,
and is less prone to errors.
{{site.alert.end}}

{{site.alert.secondary}}
**Key terms:**
* **Iterable**: The Dart [Iterable][iterable class] class.
* **Iterator**: An object used by `for-in` to read elements from
  an `Iterable` object.
* **`for-in` loop**: An easy way to sequentially read elements from
  an `Iterable`.
{{site.alert.end}}

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

{{site.alert.warn}}
  Because accessing the last element of an Iterable requires
  stepping through all the other elements,
  **`last` can be slow.**
  Using `first` or `last` on an **empty `Iterable`**
  results in a [StateError.][StateError class]
{{site.alert.end}}


[//]: https://gist.github.com/f3d96039195566d934a966390ea4ad62
<iframe
  src="{{site.dartpad-embed}}?id=f3d96039195566d934a966390ea4ad62&ga_id=first_and_last"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="300"
  width="100%" >
</iframe>

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
{% prettify dart tag=pre+code %}
String element = iterable.firstWhere((element) => element.length > 5);
{% endprettify %}

For example, if you want to find the first `String` that has
more than 5 characters,
you must pass a predicate that returns true when
the element size is greater than 5.

Run the following example to see how `firstWhere()` works.
Do you think all the functions will give the same result?

[//]: https://gist.github.com/03b4100365c1b871a36b9a1c5781dab1
<iframe
  src="{{site.dartpad-embed}}?id=03b4100365c1b871a36b9a1c5781dab1&ga_id=using_firstwhere"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="500"
  width="100%" >
</iframe>

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

In the example, `firstWhereWithOrElse()` calls `firstWhere()` with
the optional named parameter `orElse`,
which provides an alternative when an element isn't found.
In this case, the text `'None!'` is returned because
no element satisfies the provided condition.

{{site.alert.note}}
  If no element satisfies the test predicate and
  the `orElse` parameter isn't provided,
  then `firstWhere()` throws a [StateError.][StateError class]
{{site.alert.end}}

{{site.alert.secondary}}
  **Quick review:**
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
{{site.alert.end}}

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

{{site.alert.warn}}
  `singleWhere()` steps through the whole `Iterable` until the last element,
  which can cause problems if the `Iterable` is infinite or
  contains a large collection of elements.
{{site.alert.end}}

Your goal is to implement the predicate for `singleWhere()` that
satisfies the following conditions:

* The element contains the character `'a'`.
* The element starts with the character `'M'`.

All the elements in the test data are [strings;][String class]
you can check the class documentation for help.

[//]: https://gist.github.com/241c6bc591f9436a9be0116724222953
<iframe
  src="{{site.dartpad-embed}}?id=241c6bc591f9436a9be0116724222953&theme=dark&ga_id=practice_writing_a_test_predicate"
  frameborder="no"
  height="250"
  width="100%">
</iframe>

## Checking conditions

When working with `Iterable`, sometimes you need to verify that
all of the elements of a collection satisfy some condition.

You might be tempted to write a solution using a `for-in` loop like this one:

{:.bad}
<?code-excerpt "iterables/test/iterables_test.dart (every-bad)"?>
{% prettify dart tag=pre+code %}
for (var item in items) {
  if (item.length < 5) {
    return false;
  }
}
return true;
{% endprettify %}

However, you can accomplish the same using the `every()` method:

<?code-excerpt "iterables/test/iterables_test.dart (every-good)"?>
{% prettify dart tag=pre+code %}
return items.every((element) => element.length >= 5);
{% endprettify %}

Using the `every()` method results in code that is more
readable, compact, and less error prone.

### Example: Using any() and every()

The `Iterable` class provides two methods that
you can use to verify conditions:

* `any()`: Returns true if at least one element satisfies the condition.
* `every()`: Returns true if all elements satisfy the condition.

Run this exercise to see them in action.

[//]: https://gist.github.com/d56963729339cea951e16209e0a26e4c
<iframe
  src="{{site.dartpad-embed}}?id=d56963729339cea951e16209e0a26e4c&ga_id=using_any_and_every"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="375"
  width="100%" >
</iframe>

In the example, `any()` verifies that
at least one element contains the character `a`,
and `every()` verifies that all elements
have a length equal to or greater than 5.

After running the code, try changing the predicate of `any()` so
it returns false:

<?code-excerpt "iterables/test/iterables_test.dart (any-false)"?>
{% prettify dart tag=pre+code %}
if (items.any((element) => element.contains('Z'))) {
  print('At least one element contains "Z"');
} else {
  print('No element contains "Z"');
}
{% endprettify %}

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

<!-- [//]: https://gist.github.com/76dc5c8644652adf4e2032912d974ac3 -->

<iframe
src="{{site.dartpad-embed}}?id=76dc5c8644652adf4e2032912d974ac3&theme=dark&ga_id=verify_iterable"
frameborder="no"
height="325"
width="100%" >
</iframe>

{{site.alert.secondary}}
  **Quick review:**
  * Although you can use `for-in` loops to check conditions,
    there are better ways to do that.
  * The method `any()` enables you to check whether
    any element satisfies a condition.
  * The method `every()` enables you to verify that
    all elements satisfy a condition.
{{site.alert.end}}

## Filtering

The previous sections cover methods like `firstWhere()` or
`singleWhere()` that can help you find an element that
satisfies a certain predicate.

But what if you want to find all the elements that
satisfy a certain condition?
You can accomplish that using the `where()` method.

<?code-excerpt "iterables/test/iterables_test.dart (where)"?>
{% prettify dart tag=pre+code %}
var evenNumbers = numbers.where((number) => number.isEven);
{% endprettify %}

In this example,
`numbers` contains an `Iterable` with multiple `int` values, and
`where()` finds all the numbers that are even.

The output of `where()` is another `Iterable`,
and you can use it as such to iterate over it or
apply other `Iterable` methods.
In the next example, the output of `where()`
is used directly inside the `for-in` loop.

<?code-excerpt "iterables/test/iterables_test.dart (where-for)"?>
{% prettify dart tag=pre+code %}
var evenNumbers = numbers.where((number) => number.isEven);
for (var number in evenNumbers) {
  print('$number is even');
}
{% endprettify %}

### Example: Using where()

Run this example to see how `where()` can be used together with other
methods like `any()`.

[//]: https://gist.github.com/f96f2f630ee327bd69ee7737301d9628
<iframe
  src="{{site.dartpad-embed}}?id=f96f2f630ee327bd69ee7737301d9628&ga_id=using_where"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="375"
  width="100%" >
</iframe>

In this example, `where()` is used to find all numbers that are even, then
`any()` is used to check if the results contain a negative number.

Later in the example, `where()` is used again to
find all numbers larger than 1000.
Because there are none, the result is an empty `Iterable`.

{{site.alert.note}}
  If no element satisfies the predicate in `where()`,
  then the method returns an empty `Iterable`.
  Unlike `singleWhere()` or `firstWhere()`,
  `where()` doesn't throw a [StateError][StateError class] exception.
{{site.alert.end}}

### Example: Using takeWhile

The methods `takeWhile()` and `skipWhile()` can also
help you filter elements from an `Iterable`.

Run this example to see how `takeWhile()` and `skipWhile()` can
split an `Iterable` containing numbers.

[//]: https://gist.github.com/5e3582c858517f93baf160892d131ec9
<iframe
  src="{{site.dartpad-embed}}?id=5e3582c858517f93baf160892d131ec9&ga_id=using_takewhile"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="275"
  width="100%" >
</iframe>

In this example, `takeWhile()` returns an `Iterable` that
contains all the elements leading to the element that
satisfies the predicate.
On the other hand, `skipWhile()` returns an `Iterable` while
skipping all the elements before the one that satisfies the predicate.
Note that the element that satisfies the predicate is also included.

After running the example,
change `takeWhile()` to take elements until
it reaches the first negative number.

<?code-excerpt "iterables/test/iterables_test.dart (takewhile)"?>
{% prettify dart tag=pre+code %}
var numbersUntilNegative =
    numbers.takeWhile((number) => !number.isNegative);
{% endprettify %}

Notice that the condition `number.isNegative` is negated with `!`.

### Exercise: Filtering elements from a list

The following exercise provides practice using the `where()` method with 
the class `User` from the previous exercise.

Use `where()` to implement two functions:

* Part 1: Implement `filterUnder21()`.
  * Return an `Iterable` containing all users of age 21 or more.
* Part 2: Implement `findShortNamed()`.
  * Return an `Iterable` containing all users with
    names of length 3 or less.
  
[//]: https://gist.github.com/8113e2880772456f9036ddf55c517e9e
<iframe
src="{{site.dartpad-embed}}?id=8113e2880772456f9036ddf55c517e9e&theme=dark&ga_id=filtering_elements_from_a_list"
frameborder="no"
height="325"
width="100%" >
</iframe>

{{site.alert.secondary}}
  **Quick review:**
  * Filter the elements of an `Iterable` with `where()`.
  * The output of `where()` is another `Iterable`.
  * Use `takeWhile()` and `skipWhile()` to obtain elements until or after
    a condition is met.
  * The output of these methods can be an empty `Iterable`.
{{site.alert.end}} 

## Mapping

Mapping `Iterables` with the method `map()` enables you to
apply a function over each of the elements,
replacing each element with a new one.

<?code-excerpt "iterables/test/iterables_test.dart (map-int)"?>
{% prettify dart tag=pre+code %}
Iterable<int> output = numbers.map((number) => number * 10);
{% endprettify %}

In this example, each element of the `Iterable` numbers is multiplied by 10.

You can also use `map()` to transform an element into a different object —
for example, to convert all `int` to `String`,
as you can see in the following example.

<?code-excerpt "iterables/test/iterables_test.dart (map-string)"?>
{% prettify dart tag=pre+code %}
Iterable<String> output = numbers.map((number) => number.toString());
{% endprettify %}

{{site.alert.note}}
  `map()` returns a _lazy_ `Iterable`, meaning that the supplied function
  is called only when the elements are iterated.
{{site.alert.end}}

### Example: Using map to change elements

Run this example to see how to use `map()` to
multiply all the elements of an `Iterable` by 2.
What do you think the output will be?

[//]: https://gist.github.com/8c2f129d88c5ce166cca0f4bb9e2a906
<iframe
  src="{{site.dartpad-embed}}?id=8c2f129d88c5ce166cca0f4bb9e2a906&ga_id=using_map"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="200"
  width="100%" >
</iframe>

### Exercise: Mapping to a different type

In the previous example, you multiplied the elements of an `Iterable` by 2.
Both the input and the output of that operation were an `Iterable` of `int`.

In this exercise, your code takes an `Iterable` of `User`,
and you need to return an `Iterable` that
contains strings containing user name and age.

Each string in the `Iterable` must follow this format:
`'{name} is {age}'`—for example `'Alice is 21'`.

[//]: https://gist.github.com/5ce89481a3dc8b14800825c78bd547e2
<iframe
src="{{site.dartpad-embed}}?id=5ce89481a3dc8b14800825c78bd547e2&theme=dark&ga_id=mapping_to_a_different_type"
frameborder="no"
height="325"
width="100%" >
</iframe>

{{site.alert.secondary}}
  **Quick review:**
  * `map()` applies a function to all the elements of an `Iterable`.
  * The output of `map()` is another `Iterable`.
  * The function isn't evaluated until the `Iterable` is iterated.
{{site.alert.end}} 

## Exercise: Putting it all together

It’s time to practice what you learned, in one final exercise.

This exercise provides the class `EmailAddress`,
which has a constructor that takes a string.
Another provided function is `isValidEmailAddress()`,
which tests whether an email address is valid.

|----------------------+-------------------+----------------------------------|
| Constructor/function | Type signature    | Description                       |
|----------------------|-------------------|----------------------------------|
| EmailAddress() | `EmailAddress(String address)` | Creates an `EmailAddress` for the specified address. | 
| isValidEmailAddress() | `bool isValidEmailAddress(EmailAddress)` | Returns `true` if the provided `EmailAddress` is valid. | 
|----------------------+-------------------+----------------------------------|
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

[//]: https://gist.github.com/0be68487b124b4e55927c3e026094547
<iframe
src="{{site.dartpad-embed}}?id=0be68487b124b4e55927c3e026094547&theme=dark&ga_id=putting_it_all_together"
frameborder="no"
height="600"
width="100%" >
</iframe>

## What's next

Congratulations, you finished the codelab!
If you want to learn more,
here are some suggestions for where to go next:

* Play with [DartPad.]({{site.dartpad}})
* Try another [codelab](/codelabs).
* Read the [Iterable API reference][iterable class]
  to learn about methods not covered by this codelab.

[hashmap class]: {{site.dart_api}}/stable/dart-collection/HashMap-class.html
[iterable class]: {{site.dart_api}}/stable/dart-core/Iterable-class.html
[iterator class]: {{site.dart_api}}/stable/dart-core/Iterator-class.html
[list class]: {{site.dart_api}}/stable/dart-core/List-class.html
[map class]: {{site.dart_api}}/stable/dart-core/Map-class.html
[set class]: {{site.dart_api}}/stable/dart-core/Set-class.html
[StateError class]: {{site.dart_api}}/stable/dart-core/StateError-class.html
[String class]: {{site.dart_api}}/stable/dart-core/String-class.html
