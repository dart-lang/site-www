---
title: "Iterable Collections in Dart"
description: Learn about and practice using Iterables in Dart!
---

This codelab teaches you how to use collections that implement the 
[Iterable][iterable class] class, for example [List][list class] and
[Set][set class]. Using the embedded DartPad editors, you can test your
knowledge by running example code and completing exercises.

To get the most out of this codelab, you should have the basic knowledge
of the [Dart syntax](/samples).

This codelab covers the following material:

* How to access elements of an Iterable.
* How to check if the elements of an Iterable match a condition.
* How to filter the contents of an Iterable.
* How to map the contents of an Iterable to a different value.

Estimated time to complete this codelab: 60 minutes.

{{site.alert.note}}
  This page uses embedded DartPads to display examples and exercises.
  {% include dartpads-embedded-troubleshooting.md %}
{{site.alert.end}}

## Why do you need collections

Collections are classes that represented a group of objects, also called "elements".

A collection can be empty, or contain many elements in it. Depending on its purpose,
a collection will follow a different data structure and have different implementations.
These are some of the most common collection types:

* [List][list class]: Used to access elements by their index.
* [Set][set class]: Used to contain elements that can only occur once.
* [Map][map class]: Used to access elements using a key.

In Dart, both `List` and `Set` are `Iterable`, meaning that they share the same methods as the 
`Iterable` class. 

## What is an Iterable?

An `Iterable` is a collection of elements that can be accessed sequentially.

`Iterable`, in Dart, is an abstract class, meaning that you cannot instantiate it directly.
However you can create a new `Iterable` by creating a new `List` or a `Set`.
 
This example shows a `List` of `int`, which is also an `Iterable` of `int`:

{% prettify dart %}
    Iterable<int> iterable = [1, 2, 3];
{% endprettify %}

The difference with a `List`, is that with the `Iterable` you cannot 
access elements using their index.
For example **the following code will give you an error**:

{% prettify dart %}
    Iterable<int> iterable = [1, 2, 3];
    var value = iterable[![1]!];
{% endprettify %}

If you access elements by the index, the compiler will tell you that
`The operator '[]' isn't defined for the class 'Iterable'` which
means that you cannot use `[index]` in this case.

Continue to the next section to learn how to access elements of an `Iterable`.

## Accessing elements

The elements of an `Iterable` can be accessed sequentially.

One way to do that, is by getting an `Iterator` using the `iterator` getter,
and using it to step through the values. Stepping with the `Iterator` is done
by calling `Iterator.moveNext`, and if the call returns true, the `Iterator` 
has now moved to the next element, which is then available as `Iterator.current`. 
If the call returns `false`, there are no more elements, and `iterator.current` returns `null`.

However, it is easier to use the `for-in loop`, which internally uses an `Iterator` too.

### Example: Using Iterator and for-in loop

The following example shows how to access elements using an `Iterator`
and a `for-in loop`. These two code snippets give the same results.

[//]: https://gist.github.com/597f152c1df414fc4d7d78d1be22ac22
<iframe
  src="{{site.dartpad-embed}}?id=597f152c1df414fc4d7d78d1be22ac22"
  style="border: 1px solid lightgrey; margin-top: 10px; margin-bottom: 25px"
  frameborder="no"
  height="420"
  width="100%" >
</iframe>

In the example, you can see how accessing elements using `for-in loop`
is more convenient than using the `Iterator`.
The `for-in loop` makes your code easier
to read and understand, and it is less prone to errors.

{{site.alert.secondary}}
**Key terms:**
* **Iterable**: the Dart [Iterable][iterable class] class.
* **Iterator**: used to access elements from an Iterable.
* **for-in loop**: an easy way to sequentially access elements from an Iterable.
{{site.alert.end}}

### Example: Using first and last

In some cases, you only want to access the first or the last element of an `Iterable`.

With the `Iterable` class we cannot access to the elements directly, so you cannot call
to `iterable[0]` to access the first element. Instead, you can use the method `first`
which will return the first element.

As well, you cannot use the operator `[]` to access the last element, but you can use the
method `last`. Be aware that to access the last element of an `Iterable` you need to
step through all the elements of it, which can be a slow operation in a very large collection.

{{site.alert.note}}
  Accessing to the `first` or `last` element of an empty `Iterable` will throw a
  [StateError][StateError class].
{{site.alert.end}}

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

{% prettify dart %}
    var element = iterable.firstWhere((element) => element.length > 5);
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

* As **expresion**: the test code takes one line using a "fat arrow" `=>` 
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
  * To access the first and last elements, we can use the methods `fist` and `last`.
  * We can also find the first element that matches a condition with `firstWhere`.
  * We can write test predicates as expressions, blocks or functions.

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

{% prettify dart %}
    for (var item in items) {
      if (items.length < 5) {
        return false;
      }
    }
    return true;
{% endprettify %}

However, you can accomplish the same using the `every` method:

{% prettify dart %}
  return items.every((element) => element.length >= 5);
{% endprettify %}

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

{% prettify dart %}
  var evenNumbers = numbers.where((number) => number.isEven);
{% endprettify %}

In this example, `numbers` contains an `Iterable` with multiple `int`, and 
`where` finds all the numbers that are even.

The output of `where` is another `Iterable`, and you can use it as such to iterate
over it or apply other `Iterable` methods. In the next example, the output of `where`
is used directly inside the `for-in loop`.

{% prettify dart %}
  var evenNumbers = numbers.where((number) => number.isEven);
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
  `Iterator`. Unlikely `singleWhere` or `firstWhere`, that would throw a
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

{% prettify dart %}
var numbersUntilNegative = numbers.takeWhile((number) => !number.isNegative);
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

{% prettify dart %}
  Iterable<int> output = numbers.map((number) => number * 10);
{% endprettify %}

In this example, each element of the `Iterable` numbers is multiplied by 10.

You can also use `map` to transform an element into a different object, for example,
to convert all `int` to `String` as you can see in the example below.

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
return an `Iterable` that contains the `age` multiplied by two.

As a reminder, the class `User` contains a member `age` of the type `int`.

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

This exercise provides the class `Email` with a constructor, that takes a `String`.

{% prettify dart %}
class Email {
  String address;

  Email(
    this.address,
  );
}
{% endprettify %}

This exercise also provides the function `checkIfEmailInvalid` that returns `true` if
an `Email` is invalid.

|--------------------------+-----------------------------------+-------------|
| Function                 | Type signature                    | Description |
|--------------------------|-----------------------------------|-------------|
| checkIfEmailInvalid()    | `bool checkIfEmailInvalid(Email)` | Returns `true` if the provided `Email` is invalid. | 
|--------------------------+-----------------------------------+-------------|
{:.table .table-striped}

Your goal is:

**Part 1:** `parseEmails`
- Write the function `parseEmails` that takes an `Iterable` of `String` containing emails, 
and returns an `Iterable` of `Email`.
- Use the method `map` to map between the `String` to `Email`.
- Create the `Email` objects with the constructor `Email(String)`.

**Part 2:** `anyInvalidEmail`
- Write the function `anyInvalidEmail` that takes an `Iterable` of `Email` and returns `true`
if any `Email` in the `Iterable` is invalid.
- Use the method `any` together with the provided function `checkIfEmailInvalid`.

**Part 3:** `validEmails`
- Write the function `validEmails` that takes an `Iterable` of `Email` and returns
another `Iterable` of `Email` containing only valid `Emails`.
- Use the method `where` to filter the `Iterable` of `Email`.
- Use the provided function `checkIfEmailInvalid` to evaluate if an `Email` is valid or not.

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
[StateError class]: {{site.dart_api}}/stable/dart-core/StateError-class.html
[String class]: {{site.dart_api}}/stable/dart-core/String-class.html
