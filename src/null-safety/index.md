---
title: Sound null safety
description: Information about Dart's upcoming null safety feature
---

Sound null safety is coming to the Dart language!
When you opt into null safety,
types in your code are non-nullable by default, meaning that
values can’t be null _unless you say they can be._
With null safety, your **runtime** null-dereference errors
turn into **edit-time** analysis errors.

With null safety,
the Dart analyzer enforces good practices.
For example, it makes sure you check for null before
reading a nullable variable.
And because Dart null safety is sound,
Dart compilers and runtimes can optimize away internal null checks,
so apps can be faster and smaller.

{{ site.alert.important }}
  Because null safety is still in tech preview,
  **don't use null safety in production code.**
  But please do test the feature and [give us feedback.][]
{{ site.alert.end }}

New operators and keywords related to null safety
include `?`, `!`, and `late`.
If you've used Kotlin, TypeScript, or C#,
the syntax for null safety might look familiar.
That's by design: the Dart language aims to be unsurprising.

You can practice using null safety in the web app
[DartPad with Null Safety,][nullsafety.dartpad.dev]
shown in the following screenshot.
Or try null safety in your normal development environment,
using the instructions and configuration files in the
[null safety sample.][calculate_lix]

![Screenshot of DartPad null safety snippet with analysis errors](/null-safety/dartpad-snippet.png)
{% comment %}
[TODO: update that screenshot]
{% endcomment %}


## Creating variables

When creating a variable,
you can use `?` and `late`
to inform Dart of the variable's nullability.

Here are some examples of declaring **non-nullable variables**
(assuming you’ve opted into null safety):

```dart
// In null-safe Dart, none of these can ever be null.
var i = 42; // Inferred to be an int.
String name = getFileName();
final b = Foo();
```

If the variable _can_ have the value `null`,
**add `?`** to its type declaration:

```dart
int? aNullableInt = null;
```

If you know that a non-nullable variable will be
initialized to a non-null value before it's used,
but the Dart analyzer doesn't agree,
**insert `late`** before the variable's type:

```dart
class IntProvider {
  late int aRealInt;
  
  IntProvider() {
    aRealInt = calculate();
  }
}
```

The `late` keyword has two effects:

* The analyzer doesn't require you to immediately initialize
  a `late` variable to a non-null value.
* The runtime lazily initializes the `late` variable.
  For example, if a non-nullable instance variable
  must be calculated,
  adding the `late` modifier delays the calculation
  until the first use of the instance variable.

{% comment %}
PENDING: Say something about `late` variable initialization being lazy?

PENDING: Uncomment the following once we're ready to offer more guidance.

{{ site.alert.tip }}
  Avoid using `late final` unless you really need it.
  For example, prefer using an [initializer list][]
  to initialize instance variables.
{{ site.alert.end }}

[initializer list]: /guides/language/language-tour#initializer-list
{% endcomment %}


## Using variables and expressions

With null safety, the Dart analyzer generates errors when
it finds a nullable value where a non-null value is required.
That isn't as bad as it sounds:
the analyzer can often recognize when
a variable or expression inside a function has
a nullable type but can't have a null value.

{{site.alert.info}}
  The analyzer can't model the flow of your whole application,
  so it can't predict the values of global variables or class fields.
{{site.alert.end}}

When using a nullable variable or expression,
be sure to handle null values.
For example, you can use an `if` statement, the `??` operator,
or the `?.` operator to handle possible null values.

Here's an example of using the [`??` operator][`??`]
to avoid setting a non-nullable variable to null:

```dart
int value = aNullableInt ?? 0; // 0 if it's null; otherwise, the integer
```

Here's similar code, but with an `if` statement that checks for null:

```dart
int definitelyInt(int? aNullableInt) {
  if (aNullableInt == null) {
    return 0;
  }
  return aNullableInt; // Can't be null!
}
```

If you're sure that an expression with a nullable type isn’t null,
you can add `!` to make Dart treat it as non-nullable:

```dart
int? aNullableInt = 2;
int value = aNullableInt!; // `aNullableInt!` is an int.
// This throws if aNullableInt is null.
```

{{site.alert.important}}
  If you aren't positive that a value is non-null,
  **don't use `!`**.
{{site.alert.end}}

If you need to change the type of a nullable variable —
beyond what the `!` operator can do —
you can use the [typecast operator (`as`)][`as`].
The following example uses `as` to convert a `num?` to an `int`:

```dart
return maybeNum() as int;
```

Once you opt into null safety,
you can't use the [member access operator (`.`)][other operators]
if the operand might be null.
Instead, you can use the null-aware version of that operator (`?.`):

```dart
double? d;  
print(d?.floor()); // Uses `?.` instead of `.` to invoke `floor()`.
```

## Understanding list, set, and map types

Lists, sets, and maps are commonly used collection types in Dart programs,
so you need to know how they interact with null safety.
Here are some examples of how Dart code uses these collection types:

* Flutter layout widgets such as [`Column`][]
  often have a `children` property that’s a
  `List` of `Widget` objects.
* The [Veggie Seasons][] sample uses a `Set` of `VeggieCategory` to
  store a user’s food preferences.
* The [GitHub Dataviz][] sample has a `fromJson()`method that
  creates an object from JSON data that’s supplied in a
  `Map<String, dynamic>`.

[`Column`]: https://api.flutter.dev/flutter/widgets/Column-class.html
[Veggie Seasons]: https://github.com/flutter/samples/tree/master/veggieseasons
[GitHub Dataviz]: https://github.com/flutter/samples/tree/master/web/github_dataviz


### List and set types {#list-and-set-types}

When you’re declaring the type of a list or set,
think about what can be null.
The following table shows the possibilities for a list of strings
if you opt into null safety.

{% assign yes = '<b>Yes</b>' %}

|------------------+----------------------------------+--------------------------+------------|
|Type              | Can the list<br>be null? | Can an item (string)<br>be null? | Description|
|------------------|----------------------------------|--------------------------|------------|
| `List<String>`   | No      | No      | A non-null list that contains<br> non-null strings |
| `List<String>?`  | {{yes}} | No      | A list that **might be null** and that<br> contains non-null strings |
| `List<String?>`  | No      | {{yes}} |  A non-null list that contains<br> strings that **might be null** |
| `List<String?>?` | {{yes}} | {{yes}} | A list that **might be null** and that<br> contains strings that **might be null** |
{:.table .table-striped}

When a literal creates a list or set,
then instead of a type like in the table above,
you typically see a type annotation on the literal.
For example, here’s the code you might use to create
a variable (`nameList`) of type `List<String?>` and
a variable (`nameSet`) of type `Set<String?>`:

```dart
var nameList = <String?>['Andrew', 'Anjan', 'Anya'];
var nameSet = <String?>{'Andrew', 'Anjan', 'Anya'};
```

### Map types {#map-types}

Map types behave mostly like you’d expect, with one exception:
**the returned value of a lookup can be null**.
Null is the value for a key that isn't present in the map.

As an example, look at the following code.
What do you think the value and type of `uhOh` are?

```dart
var myMap = <String, int>{'one': 1};
var uhOh = myMap['two'];
```

The answer is that `uhOh` is null and has type `int?`. 

Like lists and sets, maps can have a variety of types:

|----------------------+-------------------------------+-------------------------|
|Type                  | Can the map<br>be null? | Can an item (int)<br>be null? |
|----------------------|-------------------------------|-------------------------|
| `Map<String, int>`   | No                            | No*                     |
| `Map<String, int>?`  | {{yes}}                       | No*                     |
| `Map<String, int?>`  | No                            | {{yes}}                 |
| `Map<String, int?>?` | {{yes}}                       | {{yes}}                 |
{:.table .table-striped}

_\* Even when all the int values in the map are non-null,
when you use an invalid key to do a map lookup, the returned value is null._

Because map lookups can return null,
you can't assign them to non-nullable variables:

```dart
// Assigning a lookup result to a non-nullable
// variable causes an error.
int value = <String, int>{'one': 1}['one']; // ERROR
```

{% comment %}
**[QUESTION: Will the analyzer ever be able to detect that is non-null?]**
{% endcomment %}

One workaround is to change the type of the variable to be nullable:

```dart
int? value = <String, int>{'one': 1}['one']; // OK
```

Another way to fix the problem —
if you're sure the lookup succeeds —
is to add a `!`:

```dart
int value = <String, int>{'one': 1}['one']!; // OK
```

A safer approach is to use the lookup value only if it's not null.
You can test its value using
an `if` statement or the [`??` operator][`??`].
Here's an example of using the value `0` if the lookup returns a null value:

```dart
var aList = <String, int>{'one': 1};
...
int value = aList['one'] ?? 0;
```


## Where to learn more

For more information about null safety, see the following resources:

* [Dart announcements group][Dart announce]
* [Dart blog][]
* [DartPad with null safety][nullsafety.dartpad.dev]
* [Null safety sample code][calculate_lix]
* [Null safety tracking issue][110]

[`??`]: /guides/language/language-tour#conditional-expressions
[110]: https://github.com/dart-lang/language/issues/110
[Announcing Dart 2.8]: https://medium.com/dartlang/announcing-dart-2-8-7750918db0a
[`as`]: /guides/language/language-tour#type-test-operators
[calculate_lix]: https://github.com/dart-lang/samples/tree/master/null_safety/calculate_lix
[Dart announce]: {{site.group}}/d/forum/announce
[Dart blog]: https://medium.com/dartlang
[give us feedback.]: https://github.com/dart-lang/sdk/issues/new?title=Null%20safety%20feedback:%20[issue%20summary]&labels=NNBD&body=Describe%20the%20issue%20or%20potential%20improvement%20in%20detail%20here
[nullsafety.dartpad.dev]: https://nullsafety.dartpad.dev
[other operators]: /guides/language/language-tour#other-operators
