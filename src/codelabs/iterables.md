---
title: "Iterable collections"
description: An interactive guide to using Iterable objects such as lists and sets.
---

This codelab teaches you how to use collections that implement the 
[Iterable][iterable class] class, for example [List][list class] and
[Set][set class]. Iterables are a basic building block for all
sorts of Dart applications, and you are probably already using them
even without noticing. This codelab will help you take the most out of 
them.

Using the embedded DartPad editors, you can test your
knowledge by running example code and completing exercises.

To get the most out of this codelab, you should have the basic knowledge
of the [Dart syntax](/samples).

This codelab covers the following material:

* How to read elements of an Iterable.
* How to check if the elements of an Iterable match a condition.
* How to filter the contents of an Iterable.
* How to map the contents of an Iterable to a different value.

Estimated time to complete this codelab: 60 minutes.

{{site.alert.note}}
  This page uses embedded DartPads to display examples and exercises.
  {% include dartpads-embedded-troubleshooting.md %}
{{site.alert.end}}

## Why do you need collections

Iterables are a kind of collection. Collections are classes that represented 
a group of objects, also called "elements".

A collection can be empty, or contain many elements in it. Depending on its purpose,
a collection will follow a different data structure and have different implementations.
These are some of the most common collection types:

* [List][list class]: Used to read elements by their index.
* [Set][set class]: Used to contain elements that can only occur once.
* [Map][map class]: Used to read elements using a key.

In Dart, both `List` and `Set` are `Iterable`, meaning that they share the same methods as the 
`Iterable` class. 

`Map` uses a different data structure internally depending on their implementation, 
for example [HashMap][hashmap class] uses a hash-table,
in which the elements (also called values) are obtained using a key. Elements of a `Map` can
also be read as `Iterable`, with the properties `entries` or `values`.

## What is an Iterable?

An `Iterable` is a collection of elements that can be accessed sequentially.

`Iterable`, in Dart, is an abstract class, meaning that you can't instantiate it directly.
However you can create a new `Iterable` by creating a new `List` or a `Set`.
 
This example shows a `List` of `int`, which is also an `Iterable` of `int`:

<?code-excerpt "iterables/bin/iterable_1.dart"?>
{% prettify dart %}
Iterable<int> iterable = [1, 2, 3];
{% endprettify %}

The difference with a `List`, is that with the `Iterable` you can't 
guarantee that reading elements by index will be efficient.
`Iterable`, as opposed as `List`, does not have the `[]` operator.

For example **the following code will give you an error**:

// TODO: Handle bad code?
{:.bad}
{% prettify dart %}
    Iterable<int> iterable = [1, 2, 3];
    var value = iterable[![1]!];
{% endprettify %}

If you read elements with `[]`, the compiler will tell you that
the operator `'[]'` isn't defined for the class `Iterable` which
means that you can't use `[index]` in this case.

You can instead read elements with `elementAt()`, which will step through
the elements of the iterable until reaching that position.

<?code-excerpt "iterables/bin/iterable_2.dart"?>
{% prettify dart %}
Iterable<int> iterable = [1, 2, 3];
int value = iterable.elementAt(1);
{% endprettify %}

Continue to the next section to learn more about how to access elements of an `Iterable`.

## Reading elements

The elements of an `Iterable` can be read sequentially.

One way to do that, is by getting an `Iterator` using the `iterator` getter,
and using it to step through the values. However, it is easier to use the 
`for-in loop`, which internally uses an `Iterator` too.

### Example: Using for-in loop

The following example shows how to read elements using  a `for-in loop`.

[//]: https://gist.github.com/597f152c1df414fc4d7d78d1be22ac22
<iframe
  src="{{site.dartpad-embed}}?id=597f152c1df414fc4d7d78d1be22ac22"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="200"
  width="100%" >
</iframe>

The `for-in loop`, as opposed to the `Iterator`, makes your code easier
to read and understand, and it is less prone to errors.

Here's an example with `Iterator`:

{% prettify dart %}
var it = iterable.iterator;	
while (it.moveNext()) {	
  print(it.current);	
}
{% endprettify %}

{{site.alert.info}}
Stepping with the `Iterator` is done
by calling `Iterator.moveNext`, and if the call returns true, the `Iterator` 
has now moved to the next element, which is then available as `Iterator.current`. 

If the call returns `false`, there are no more elements, and `iterator.current` returns `null`.
{{site.alert.end}}

{{site.alert.secondary}}
**Key terms:**
* **Iterable**: the Dart [Iterable][iterable class] class.
* **Iterator**: used to read elements from an Iterable.
* **for-in loop**: an easy way to sequentially read elements from an Iterable.
{{site.alert.end}}

### Example: Using first and last

In some cases, you only want to access the first or the last element of an `Iterable`.

With the `Iterable` class you can't access to the elements directly, so you can't call
to `iterable[0]` to access the first element. Instead, you can use the method `first`
which will return the first element.

As well, you can't use the operator `[]` to access the last element, but you can use the
method `last`. 

{{site.alert.warn}}
  Because accessing the last element of an iterable requires stepping through all the other elements,
  **`last` can be slow.**
{{site.alert.end}}

Accessing to the `first` or `last` element of an empty `Iterable` will throw a 
[StateError][StateError class].

[//]: https://gist.github.com/f3d96039195566d934a966390ea4ad62
<iframe
  src="{{site.dartpad-embed}}?id=f3d96039195566d934a966390ea4ad62"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="300"
  width="100%" >
</iframe>

In this example you have seen how `first` and `last` can be used to access the first
and the last elements of an `Iterator`, but would it be possible to use a similar method
to find the first element that matches a condition? In the next section you'll learn
how to use `firstWhere` to find the first element that matches certain condition.

### Example: Using firstWhere

You have previously seen that you can access the elements of an `Iterable` sequentially,
and as well, you can easily obtain the first and the last elements with a single method call.

Now you'll learn how to find an element that satisfies certain conditions using the method
`firstWhere`. This method requires you to pass a "predicate", which is a function
that will return true if the input satisfies certain condition.

<?code-excerpt "iterables/bin/firstwhere.dart (firstwhere)"?>
{% prettify dart %}
String element = iterable.firstWhere((element) => element.length > 5);
{% endprettify %}

For example, if you want to find the first `String` that has more than five characters,
you will have to pass a predicate that returns true when the element size is greater than five.

Run the following example to see how `firstWhere` works by writing predicates in a
different way. Do all the functions give the same result?

[//]: https://gist.github.com/8faef6308ed5ae90ff5e8a74fcede768
<iframe
  src="{{site.dartpad-embed}}?id=8faef6308ed5ae90ff5e8a74fcede768"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="500"
  width="100%" >
</iframe>

In this example, you can see three different ways to write a predicate:

* As **expresion**: the test code takes one line using an "arrow" `=>` 
without a return statement or brackets.
* As **block**: the test code takes multiple lines between brackets and a return statement.
* As **function**: the test code is moved into an external function and passed to
the `firstWhere` method as parameter.

There is no right way or wrong way. You should use the way that works best for you, 
and makes your code easier to read and understand.

In the example in `firstWhereWithOrElse`, `firstWhere` is called with the optional named
parameter `orElse`, which provides an alternative when no element is found.
In the example, the text `'None!'` is returned because no element satisfied the provided
condition.

{{site.alert.note}}
  If no element satisfies the test predicate, the method `firstWhere` will throw an
  [StateError][StateError class] if the `orElse` parameter is not provided.
{{site.alert.end}}

{{site.alert.secondary}}
  **Quick review:**
  * Elements of an `Iterable` must be accessed sequentially.
  * Using a `for-in loop` is the easiest way to iterate through all elements.
  * To access the first and last elements, you can use the methods `fist` and `last`.
  * You can also find the first element that matches a condition with `firstWhere`.
  * You can write test predicates as expressions, blocks or functions.

**Key terms:**
* **Predicate**: a function that returns `true` when satisfies certain condition.
{{site.alert.end}}

### Exercise: Practice writing a test predicate

The following exercise is a failing unit test that contains a partially complete code snippet.
Your task is to complete the exercise by writing code to make the tests pass.
You don't need to implement `main()`.

This exercise introduces `singleWhere`. This method works similarly to `firstWhere`, but
in this case it expects that only one element of the `Iterable` matches the predicate.
If more than one or no element in the `Iterable` satisfies the predicate condition, the
method throws a [StateError][StateError class] exception.

{{site.alert.warn}}
  `singleWhere` steps through the whole `Iterable` until the last element, which can cause
  problems if the `Iterable` is infinite or it contains a large collection of elements.
{{site.alert.end}}

Your goal is to implement the predicate for `singleWhere` that satisfies the following condition:

* The element contains the character `'a'`
* The element starts with the character `'M'`

All the elements in the test data are [String][String class], 
you can check the class documentation for help.

[//]: https://gist.github.com/b4897cc97fec87093139a4aab8228af3
<iframe
  src="{{site.dartpad-embed}}?id=b4897cc97fec87093139a4aab8228af3&theme=dark"
  frameborder="no"
  height="250"
  width="100%">
</iframe>

## Checking conditions

When working with `Iterable` sometimes you need to verify that the elements of a collection
satisfy some condition.

You could be tempted to write a solution using a `for-in loop` like this one:

{:.bad}
<?code-excerpt "iterables/bin/every.dart (bad)"?>
{% prettify dart %}
for (var item in items) {
  if (items.length < 5) {
    return false;
  }
}
return true;
{% endprettify %}

However, you can accomplish the same using the `every` method:

<?code-excerpt "iterables/bin/every.dart (good)"?>
{% prettify dart %}
return items.every((element) => element.length >= 5);
{% endprettify %}

Which results in code that is more readable, compact and less error prone.

### Example: Using any and every

Dart `Iterable` provides two methods that can be used to verify conditions:

* `any` which checks if at least one element satisfies the condition.
* `every` which checks that all elements satisfy the condition.

Run this exercise to see them in action.

[//]: https://gist.github.com/9823ba4e7f8344e4a00f1d12d5b2d901
<iframe
  src="{{site.dartpad-embed}}?id=9823ba4e7f8344e4a00f1d12d5b2d901"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="375"
  width="100%" >
</iframe>

In the example, `any` verifies that at least one element contains the
character `a`, and `every` verifies that all elements have length equal
or greater than 5.

After running the code, try changing the predicate of `any` so it
returns false:

<?code-excerpt "iterables/bin/any.dart (any-false)"?>
{% prettify dart %}
if (items.any((element) => element.contains('Z'))) {
  print('At least one element contains "Z"');
} else {
  print('No element contains "Z"');
}
{% endprettify %}

`any` can also be used to verify that no element of an `Iterable`
matches certain condition.


### Exercise: Verify that an Iterable satisfies a condition

The following exercise provides practice using the `any` and `every` methods described
in the previous example. In this case, there's a list of users with the class `User`
with the member field `age`.

<?code-excerpt "iterables/bin/user.dart"?>
{% prettify dart %}
class User {
  String name;
  int age;
}
{% endprettify %}

Use `any` and `every` to implement two methods:

* Part 1: Implement `anyUserUnder18`.
  * It should return `true` if at least one user is 17 years old or younger.
* Part 2: Implement `everyUserOver13`.
  * It should return `true` if all users are 14 years old or older.

<!-- [//]: https://gist.github.com/f9fe58bad32355350900d5343fdb8fd4 -->

<iframe
src="{{site.dartpad-embed}}?id=f9fe58bad32355350900d5343fdb8fd4&theme=dark"
frameborder="no"
height="325"
width="100%" >
</iframe>

{{site.alert.secondary}}
  **Quick review:**
  * While you can use `for-in loops` to check conditions, there's better ways to do that.
  * The method `any` allows you to check if any element matches a condition.
  * The method `every` allows you to verify if all elements match a condition.
{{site.alert.end}}

## Filtering

In the previous sections, you have seen how using methods like `firstWhere` or
`singleWhere` can help you find an element that matches certain predicate.

But what if you want to find all the elements that match certain condition?
You can accomplish that using the `where` method.

<?code-excerpt "iterables/bin/where.dart (where)"?>
{% prettify dart %}
Iterable<int> evenNumbers = numbers.where((number) => number.isEven);
{% endprettify %}

In this example, `numbers` contains an `Iterable` with multiple `int`, and 
`where` finds all the numbers that are even.

The output of `where` is another `Iterable`, and you can use it as such to iterate
over it or apply other `Iterable` methods. In the next example, the output of `where`
is used directly inside the `for-in loop`.

<?code-excerpt "iterables/bin/where.dart (where-for)"?>
{% prettify dart %}
Iterable<int> evenNumbers = numbers.where((number) => number.isEven);
for (var number in evenNumbers) {
  print('$number is even');
}
{% endprettify %}

### Example: Using where

Run this example to see how `where` can be used together with other
methods like `any`.

[//]: https://gist.github.com/7d79929806341338fd2588d11d2c0195
<iframe
  src="{{site.dartpad-embed}}?id=7d79929806341338fd2588d11d2c0195"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="375"
  width="100%" >
</iframe>

In this example, `where` is used to find all numbers that are even, then
`any` is used to check if the results contain a negative number.

Then, in the example, `where` is used again to find all number larger than `1000`.
But since there are none, the result is an empty `Iterable`.

{{site.alert.note}}
  If no element matches the predicate in `where`, the method will return an empty
  `Iterable`. Unlikely `singleWhere` or `firstWhere`, that would throw a
   [StateError][StateError class] exception.
{{site.alert.end}}

### Example: Using takeWhile

The methods `takeWhile` and `skipWhile` can also help you filter elements from an
`Iterable`.

Run this example to see how `takeWhile` and `skipWhile` can split an `Iterable`
containing numbers.

[//]: https://gist.github.com/755d3f4af5ed365c81b2e2a81ae79e46
<iframe
  src="{{site.dartpad-embed}}?id=755d3f4af5ed365c81b2e2a81ae79e46"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="275"
  width="100%" >
</iframe>

In this example, `takeWhile` is returning an `Iterable` that contains all the elements
leading to the element that matches the predicate.
On the other hand, `skipWhile` is going
to return an `Iterable` skipping all the elements before the one that matches the predicate.
Note that the element that matched the predicate is also included.

After running the example, change the `takeWhile` to take elements until it reaches
the first negative number.

<?code-excerpt "iterables/bin/takewhile.dart (takewhile)"?>
{% prettify dart %}
Iterable<int> numbersUntilNegative = numbers.takeWhile((number) => !number.isNegative);
{% endprettify %}

Notice that the condition `number.isNegative` is negated with `!`.

### Exercise: Filtering elements from a list

The following exercise provides practice using the `where` method with 
the class `User` from the previous exercise.

Use `where` to implement two methods:

* Part 1: Implement `filterUnder21`.
  * It should return an `Iterable` of `User` with the age 21 or more.
* Part 2: Implement `findShortNamed`.
  * It should return an `Iterable` of `User` with the names of length 3 or less.
  
[//]: https://gist.github.com/7ea77da468069db721b7363ef03f97c3
<iframe
src="{{site.dartpad-embed}}?id=7ea77da468069db721b7363ef03f97c3&theme=dark"
frameborder="no"
height="325"
width="100%" >
</iframe>

{{site.alert.secondary}}
  **Quick review:**
  * Filter the elements of an `Iterable` with `where`.
  * The output of `where` is another `Iterable`.
  * Use `takeWhile` and `skipWhile` to obtain elements until or after a condition is met.
  * The output of these methods can be an empty `Iterable` too.
{{site.alert.end}} 

## Mapping

Mapping `Iterables` with the method `map` allows you to apply a function
over each one of the elements, replacing each element by a new one.

<?code-excerpt "iterables/bin/map.dart (int)"?>
{% prettify dart %}
Iterable<int> output = numbers.map((number) => number * 10);
{% endprettify %}

In this example, each element of the `Iterable` numbers is multiplied by 10.

You can also use `map` to transform an element into a different object, for example,
to convert all `int` to `String` as you can see in the example below.

<?code-excerpt "iterables/bin/map.dart (string)"?>
{% prettify dart %}
Iterable<String> output = numbers.map((number) => number.toString());
{% endprettify %}

{{site.alert.note}}
  `map` returns a "lazy" `Iterable`, meaning that the supplied function will
  only be called when the elements are iterated.
{{site.alert.end}}

### Example: Using map to change elements

Run this example to see how `map` can be used to multiply all the elements
of an `Iterable` by two. What do you think the output will be?

[//]: https://gist.github.com/ba4352e121b19ecb1b171cce553de72f
<iframe
  src="{{site.dartpad-embed}}?id=ba4352e121b19ecb1b171cce553de72f"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="200"
  width="100%" >
</iframe>

### Exercise: Mapping to a different type

In the previous example you multiplied the elements of an `Iterable` by two.
Both the input and the output of that operation were an `Iterable` of `int`.

In this exercise, you code takes an `Iterable` of `User`, and you need to
return an `Iterable` that contains `String` with the `name` and `age`.

The `String` must follow this format: `'{name} is {age}'`, for example `'Alice is 21'`.

As a reminder, the class `User` contains a member `name` of the type `String` and 
a member `age` of the type `int`.

<?code-excerpt "iterables/bin/user.dart"?>
{% prettify dart %}
class User {
  String name;
  int age;
}
{% endprettify %}

[//]: https://gist.github.com/c2ca9085b2376471b30569d570590894
<iframe
src="{{site.dartpad-embed}}?id=c2ca9085b2376471b30569d570590894&theme=dark"
frameborder="no"
height="325"
width="100%" >
</iframe>

{{site.alert.secondary}}
  **Quick review:**
  * `map` applies a function to all the elements of an `Iterable`.
  * The output of `map` is another `Iterable`.
  * The function is not evaluated until the `Iterable` is iterated.
{{site.alert.end}} 

## Exercise: Putting it all together

It’s time to practice what you’ve learned in one final exercise.

This exercise provides the class `EmailAddress` with a constructor, that takes a `String`.

<?code-excerpt "iterables/bin/email.dart"?>
{% prettify dart %}
class EmailAddress {
  EmailAddress(this.address);

  String address;
}
{% endprettify %}

This exercise also provides the function `isValidEmailAddress` that returns `true` if
an `EmailAddress` is valid.

|--------------------------+-----------------------------------+-------------|
| Function                 | Type signature                    | Description |
|--------------------------|-----------------------------------|-------------|
| isValidEmailAddress()    | `bool isValidEmailAddress(Email)` | Returns `true` if the provided `Email` is valid. | 
|--------------------------+-----------------------------------+-------------|
{:.table}

Write the following code:

**Part 1:** `parseEmailAddresses`
- Write the function `parseEmailAddresses` that takes an `Iterable<String>` containing emails, 
and returns an `Iterable<EmailAddress>`.
- Use the method `map` to map from a `String` to `EmailAddress`.
- Create the `EmailAddress` objects with the constructor `EmailAddress(String)`.

**Part 2:** `anyInvalidEmailAddress`
- Write the function `anyInvalidEmailAddress` that takes an `Iterable<EmailAddress>` and returns `true`
if any `Email` in the `Iterable` is not valid.
- Use the method `any` together with the provided function `isValidEmailAddress()`.

**Part 3:** `validEmailAddresses`
- Write the function `validEmailAddresses` that takes an `Iterable<EmailAddress>` and returns
another `Iterable<EmailAddress>` containing only valid addresses.
- Use the method `where` to filter the `Iterable<EmailAddress>`.
- Use the provided function `isValidEmailAddress` to evaluate if an `EmailAddress` is valid or not.

[//]: https://gist.github.com/bea254b823dd449a0610115405c3c5f7
<iframe
src="{{site.dartpad-embed}}?id=bea254b823dd449a0610115405c3c5f7&theme=dark"
frameborder="no"
height="600"
width="100%" >
</iframe>

## What's next

Congratulations, you've finished the codelab! If you'd like to learn more, here
are some suggestions for where to go next:

* Play with [DartPad]({{site.dartpad}}).
* Try another [codelab](/codelabs).
* Check the [Iterable][iterable class] class to learn the methods not covered by this codelab.

[iterable class]: {{site.dart_api}}/stable/dart-core/Iterable-class.html
[list class]: {{site.dart_api}}/stable/dart-core/List-class.html
[set class]: {{site.dart_api}}/stable/dart-core/Set-class.html
[map class]: {{site.dart_api}}/stable/dart-core/Map-class.html
[hashmap class]: {{site.dart_api}}/stable/dart-collection/HashMap-class.html
[StateError class]: {{site.dart_api}}/stable/dart-core/StateError-class.html
[String class]: {{site.dart_api}}/stable/dart-core/String-class.html
