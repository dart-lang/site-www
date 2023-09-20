---
title: Null safety codelab
description: Learn about and practice writing null-safe code in DartPad!
js: [{url: 'https://dartpad.dev/inject_embed.dart.js', defer: true}]
---
{% assign useIframe = false -%}
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n)*\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

This codelab teaches you about Dart's [null-safe type system](/null-safety).
Dart introduced null safety as an optional setting in Dart 2.12.
Dart 3 requires null safety.
With null safety, values can't be `null` unless you say they can be.

This codelab covers the following material:

* Nullable and non-nullable types.
* When to add `?` or `!` to indicate nullability or non-nullability.
* Flow analysis and type promotion.
* How and when to use null-aware operators.
* How the `late` keyword affects variables and initialization.

Using embedded DartPad editors, you can test your knowledge by
completing and running exercises. To get the most out of
this codelab, you should have some knowledge of [basic Dart syntax](/language).

{{site.alert.note}}
  This page uses embedded DartPads to display exercises.
  {% include dartpads-embedded-troubleshooting.md %}
{{site.alert.end}}


## Nullable and non-nullable types

With [null safety](/null-safety#enable-null-safety), all types default
to non-nullable. For example, if you have a variable of
type `String`, it always contains a string.

To allow a variable of type `String` to accept any string
or the value `null`, add a question mark (`?`) after the type name.
This changes the type of variable to a nullable type.
For example, a variable of type `String?` can contain a string,
or it can be null.

### Exercise: Non-nullable types

In the following example, the developer declared variable `a` an `int`.
Try changing the value in the assignment to `3` or `145`, but not `null`!

<?code-excerpt "null_safety_codelab/bin/non_nullable_types.dart" replace="/145/null/g"?>
```dart:run-dartpad:ga_id-nonnullable_type
void main() {
  int a;
  a = null;
  print('a is $a.');
}
```

### Exercise: Nullable types

What if you need a variable that *can* hold a null value?
Try changing the type of `a` so that `a` can be either `null` or an `int`:

<?code-excerpt "null_safety_codelab/bin/nullable_types.dart" replace="/int\?/int/g"?>
```dart:run-dartpad:ga_id-nullable_type
void main() {
  int a;
  a = null;
  print('a is $a.');
}
```

### Exercise: Nullable type parameters for generics

Type parameters for generics can also be nullable or non-nullable.
Try adding question marks to correct the type declarations of
`aNullableListOfStrings` and `aListOfNullableStrings`:

<?code-excerpt "null_safety_codelab/bin/more_nullable_types.dart" replace="/String\?/String/g; /\?\ aNull/ aNull/g"?>
```dart:run-dartpad:ga_id-nullable_type_generics
void main() {
  List<String> aListOfStrings = ['one', 'two', 'three'];
  List<String> aNullableListOfStrings;
  List<String> aListOfNullableStrings = ['one', null, 'three'];

  print('aListOfStrings is $aListOfStrings.');
  print('aNullableListOfStrings is $aNullableListOfStrings.');
  print('aListOfNullableStrings is $aListOfNullableStrings.');
}
```

## The null assertion operator (!)

If you're sure an expression with a nullable type doesn't equal `null`,
you can use the [null assertion operator](/null-safety/understanding-null-safety#null-assertion-operator)
(`!`) to make Dart treat it as non-nullable.
By adding `!` after the expression,
you assert two conditions to Dart about the expression:

1. Its value doesn't equal `null`
2. Dart can assign the value to a non-nullable variable

{{site.alert.warn}}
  If the expression does equal `null`, **Dart throws an exception at run-time**.
  This makes the `!` operator _unsafe_.
  Don't use it unless you have no doubt the expression can't equal `null`.
{{site.alert.end}}

### Exercise: Null assertion

In the following code, try adding exclamation points to correct the
broken assignments:

<?code-excerpt "null_safety_codelab/bin/assertion_operator.dart" replace="/first!/first/g; /!.abs/.abs/g"?>
```dart:run-dartpad:ga_id-null_assertion
int? couldReturnNullButDoesnt() => -3;

void main() {
  int? couldBeNullButIsnt = 1;
  List<int?> listThatCouldHoldNulls = [2, null, 4];

  int a = couldBeNullButIsnt;
  int b = listThatCouldHoldNulls.first; // first item in the list
  int c = couldReturnNullButDoesnt().abs(); // absolute value

  print('a is $a.');
  print('b is $b.');
  print('c is $c.');
}
```

## Null-aware operators

If a variable or expression is nullable,
you can use [type promotion](#type-promotion)
to access the type's members.
You can also use null-aware operators to handle nullable values.

Sometimes the flow of the program tells you that the value of an
expression cannot be `null`.
To force Dart to treat that expression as non-nullable,
add the [null assertion operator](#the-null-assertion-operator-) (`!`).
If the value does equal `null`, using this operator throws an exception.

To handle potential `null` values, use the conditional property access
operator (`?.`) or null-coalescing operators (`??`)
to conditionally access a property or
provide a default value if `null` respectively.


### Exercise: Conditional property access

If you don't know that an expression with a nullable type equals `null` or not,
you can use the conditional member access operator (`?.`).
This operator evaluates to `null` if the target expression resolves to `null`.
Otherwise, it accesses the property on the non-null target value.

<?code-excerpt "null_safety_codelab/bin/null_aware_operators.dart (conditional-property-access)"?>
```dart
// The following calls the 'action' method only if nullableObject is not null
nullableObject?.action();
```

In the following code, try using conditional property access
in the `stringLength` method. This fixes the error and
returns the length of the string or `null` if it equals `null`:

```dart:run-dartpad:ga_id-null-safety-conditional-property
{$ begin main.dart $}
int? stringLength(String? nullableString) {
  return nullableString.length;
}
{$ end main.dart $}
{$ begin solution.dart $}
int? stringLength(String? nullableString) {
  return nullableString?.length;
}
{$ end solution.dart $}
{$ begin test.dart $}
void main() {
  const nonNullString = 'testing';
  try {
    final nonNullResult = stringLength(nonNullString);
    if (nonNullResult != nonNullString.length) {
      _result(false, [
        'Tried calling `stringLength`, with the string \'testing\' but '
            'received $nonNullResult instead of the expected ${nonNullString.length}.'
      ]);
      return;
    }

    final nullableResult = stringLength(null);
    if (nullableResult != null) {
      _result(false, [
        'Tried calling `stringLength`, with a `null` value but '
            'received $nullableResult instead of the expected `null`.'
      ]);
      return;
    }
    
    _result(true);
  } on UnimplementedError {
    _result(false, [
      'Tried running `stringLength`, but received an error. Did you implement the method?'
    ]);
    return;
  } catch (e) {
    _result(
        false, ['Tried calling `stringLength`, but received an exception: $e']);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
You can use the conditional property access operator (?.)
to only access a property of if expression is not null otherwise return null.
{$ end hint.txt $}
```

### Exercise: Null-coalescing operators

If you want to provide an alternative value
when the expression evaluates to `null`,
you can specify another expression to evaluate and return instead
with the null-coalescing operator (`??`).

<?code-excerpt "null_safety_codelab/bin/null_aware_operators.dart (null-coalescing)"?>
```dart
// Both of the following print out 'alternate' if nullableString is null
print(nullableString ?? 'alternate');
print(nullableString != null ? nullableString : 'alternate');
```

You can also use the null-coalescing assignment operator (`??=`)
to evaluate and assign an expression result to a variable
only if that variable is currently `null`.

<?code-excerpt "null_safety_codelab/bin/null_aware_operators.dart (null-coalescing-assignment)"?>
```dart
// Both of the following set nullableString to 'alternate' if it is null
nullableString ??= 'alternate';
nullableString = nullableString != null ? nullableString : 'alternate';
```

In the following code, try using these operators to implement
`updateStoredValue` following the logic outlined in its documentation comment:

```dart:run-dartpad:ga_id-null-safety-coalescing-operators
{$ begin main.dart $}
abstract class Store {
  int? storedNullableValue;

  /// If [storedNullableValue] is currently `null`,
  /// set it to the result of [calculateValue] 
  /// or `0` if [calculateValue] returns `null`.
  void updateStoredValue() {
    TODO('Implement following documentation comment');
  }

  /// Calculates a value to be used,
  /// potentially `null`.
  int? calculateValue();
}
{$ end main.dart $}
{$ begin solution.dart $}
abstract class Store {
  int? storedNullableValue;

  /// If [storedNullableValue] is currently `null`,
  /// set it to the result of [calculateValue] 
  /// or `0` if [calculateValue] returns `null`.
  void updateStoredValue() {
    storedNullableValue ??= calculateValue() ?? 0;
  }

  /// Calculates a value to be used,
  /// potentially `null`.
  int? calculateValue();
}
{$ end solution.dart $}
{$ begin test.dart $}
class NullStore extends Store {
  @override
  int? calculateValue() {
    return null;
  }
}

class FiveStore extends Store {
  @override
  int? calculateValue() {
    return 5;
  }
}

void main() {
  try {
    final nullStore = NullStore();
    if (nullStore.storedNullableValue != null) {
      _result(false,
          ['The `storedNullableValue` field should be `null` at first.']);
      return;
    }
    nullStore.updateStoredValue();
    if (nullStore.storedNullableValue != 0) {
      _result(false, [
        'Tried calling `updateStoredValue`, when `calculateValue` returned `null` '
            'but `storedNullableValue` was ${nullStore.storedNullableValue} '
            'instead of the expected 0.'
      ]);
      return;
    }

    final fiveStore = FiveStore();
    fiveStore.updateStoredValue();
    if (fiveStore.storedNullableValue != 5) {
      _result(false, [
        'Tried calling `updateStoredValue`, when `calculateValue` returned `5`'
            'but `storedNullableValue` was ${fiveStore.storedNullableValue} '
            'instead of the expected 5.'
      ]);
      return;
    }

    fiveStore.storedNullableValue = 3;
    if (fiveStore.storedNullableValue != 3) {
      _result(false, [
        'Tried calling `updateStoredValue`, when `storedNullableValue` '
            'was already not `null`'
            'but `storedNullableValue` was still updated when it shouldn\'t be.'
      ]);
      return;
    }

    _result(true);
  } on UnimplementedError {
    _result(false, [
      'Tried running `updateStoredValue`, but received an error. Did you implement the method?'
    ]);
    return;
  } catch (e) {
    _result(false,
        ['Tried calling `updateStoredValue`, but received an exception: $e']);
  }
}
{$ end test.dart $}
{$ begin hint.txt $}
You can think of the null-coalescing operators
as providing an alternative value if the left-hand side is `null`.
{$ end hint.txt $}
```

## Type promotion

Dart's [flow analysis](/null-safety/understanding-null-safety#flow-analysis)
accounts for nullability.
Dart treats nullable variables with no ability to contain null values
as non-nullable variables.
We call this behavior
[type promotion](/null-safety/understanding-null-safety#type-promotion-on-null-checks).

### Exercise: Definite assignment

Dart's type system can track where variables are assigned and read.
It can also verify that the developer assigned values to non-nullable variables
before any code tries to read from those variables.
This process is called
[definite assignment](/null-safety/understanding-null-safety#definite-assignment-analysis).

Try uncommenting the `if`-`else` statement in the following code.
Watch the analyzer errors disappear:

<?code-excerpt "null_safety_codelab/bin/definite_assignment.dart" replace="/if/\/\/if/g; /\ \ text\ =/\/\/  text =/g; /\ \ \}/  \/\/}/g"?>
```dart:run-dartpad:ga_id-definite_assignment
void main() {
  String text;

  //if (DateTime.now().hour < 12) {
  //  text = "It's morning! Let's make aloo paratha!";
  //} else {
  //  text = "It's afternoon! Let's make biryani!";
  //}

  print(text);
  print(text.length);
}
```

### Exercise: Null checking

In the following code, add an `if` statement to the beginning of
`getLength` that returns zero if `str` is `null`:

<?code-excerpt "null_safety_codelab/bin/type_promotion.dart" replace="/.*if\ \(.*\n.*\n.*//g"?>
```dart:run-dartpad:ga_id-null_checking
int getLength(String? str) {
  // Add null check here

  return str.length;
}

void main() {
  print(getLength('This is a string!'));
}
```

### Exercise: Promotion with exceptions

Promotion works with exceptions as well as return statements.
Try a null check that throws an `Exception` instead of returning zero.

<?code-excerpt "null_safety_codelab/bin/promotion_exceptions.dart" replace="/.*if\ \(.*\n.*\n.*//g"?>
```dart:run-dartpad:ga_id-promotion_exceptions
int getLength(String? str) {
  // Try throwing an exception here if `str` is null.

  return str.length;
}

void main() {
  print(getLength(null));
}
```

## The late keyword

Sometimes variables—fields in a class, or top-level variables—should 
be non-nullable, but they can't be
assigned a value immediately. 
For cases like that, use the
[`late` keyword](/null-safety/understanding-null-safety#late-variables).

When you put `late` in front of a variable declaration,
that tells Dart the following about the variable:

- The developer didn't want to assign it a value yet.
- It will get a value later.
- It will have a value _before_ being used.

If you declare a variable `late` and Dart reads the variable before
you assigned a value, Dart throws an error.

### Exercise: Using late

Try using the `late` keyword to correct the following code.
For a little extra fun afterward,
try commenting out the line that sets `description`!

<?code-excerpt "null_safety_codelab/bin/late_keyword.dart" replace="/late\ String\ _description/String _description/g"?>
```dart:run-dartpad:ga_id-late_keyword
class Meal {
  String _description;

  set description(String desc) {
    _description = 'Meal description: $desc';
  }

  String get description => _description;
}

void main() {
  final myMeal = Meal();
  myMeal.description = 'Feijoada!';
  print(myMeal.description);
}
```

### Exercise: Late circular references

The `late` keyword helps with tricky patterns like circular references.
The following code has two objects that need to maintain non-nullable references
to each other. Try using the `late` keyword to fix this code.

You don't need to remove `final`. You can create
[`late final` variables](/null-safety/understanding-null-safety#late-final-variables):
you set their values once, and after that they stay read-only.

<?code-excerpt "null_safety_codelab/bin/late_circular_references.dart" replace="/late\ final\ Team/final Team/g; /late\ final\ Coach/final Coach/g"?>
```dart:run-dartpad:ga_id-late_circular
class Team {
  final Coach coach;
}

class Coach {
  final Team team;
}

void main() {
  final myTeam = Team();
  final myCoach = Coach();
  myTeam.coach = myCoach;
  myCoach.team = myTeam;

  print('All done!');
}
```

### Exercise: Late and lazy

The `late` keyword can help with another pattern:
[lazy initialization](/null-safety/understanding-null-safety#lazy-initialization)
for expensive non-nullable fields.
Try the following:

<ol>
<li>Run this code without changing it, and note the output.</li>
<li>Think: What will change if
  you make <code>_cache</code> a <code>late</code> field?</li>
<li>Make <code>_cache</code> a <code>late</code> field, and run the code.
  Was your prediction correct?</li>
</ol>

<?code-excerpt "null_safety_codelab/bin/late_lazy.dart"?>
```dart:run-dartpad:ga_id-lazy_late
int _computeValue() {
  print('In _computeValue...');
  return 3;
}

class CachedValueProvider {
  final _cache = _computeValue();
  int get value => _cache;
}

void main() {
  print('Calling constructor...');
  var provider = CachedValueProvider();
  print('Getting value...');
  print('The value is ${provider.value}!');
}
```

{{site.alert.info}}
  **Fun fact:**
  After you add `late` to the declaration of `_cache`,
  if you move the   `_computeValue` function into the
  `CachedValueProvider` class, the code still works!
  Initialization expressions for `late` fields can use instance
  methods in their initializers.
{{site.alert.end}}


## What's next?

Congratulations, you've finished the codelab!
To learn more, check out some suggestions for where to go next:

- Learn more about null safety
  -[Overview of null safety](/null-safety).
  -[Deep dive into understanding null safety](/null-safety/understanding-null-safety).
- If you want to improve this codelab, check out [issue #3093][].

[issue #3093]: https://github.com/dart-lang/site-www/issues/3093
