---
title: Pattern types
description: Pattern type reference in Dart.
---

## Cast

`foo as String`

Cast patterns let you insert a [type cast][] as a pattern is
[destructuring][destructure] values:

```dart
(num, Object) record = (1, "s");
var (i as int, s as String) = record;
```

Cast patterns will [throw][] if the value doesn't have the stated type.
Like the [null-assert pattern](#null-assert), this lets you forcibly assert the
expected type of some destructured value.

## Constant	

`123, null, 'string', math.pi, SomeClass.constant, const Thing(1, 2), const (1 + 2)`

Constant patterns allow simple literals and references to named constants to be
used directly as patterns. They match when the value is equal to the constant.

Some valid constant expressions may not be valid constant patterns. In that case,
to distinguish a constant expression from a constant pattern, prefix the expression
with `const` and wrap it in parenthesis so it is unambiguosly an expression and
not a constant pattern:

```dart
// List or map pattern:
case [a, b]: ...

// List or map literal:
case const [a, b]: ...
```

## Identifier	

`foo, _`

Identifier patterns may behave like a [constant pattern](#constant) or like a
[variable pattern](#variable), depending on the context where it appears:

- [Declaration][] context: declares a new variable with identifier name:
  `var (a, b) = (1, 2);`
- [Assignment][] context: assigns to existing variable with identifier name:
  `(a, b) = (3, 4);`
- [Matching][] context: treated as a named constant pattern (unless its name is `_`):
  ```dart
  const c = 1;
  switch (2) {
    case c: print('match $c');
    default: print('no match');    // Prints "no match".
   }
  ``` 
- [Wildcard](#wildcard) identifier in any context: matches any value and discards it:
  `case [_, var y, _]: print('The middle element is $y');`

## List

`[subpattern1, subpattern2]`

List patterns match values that implement [`List`][], and then recursively match
its subpatterns against the list's elements to destructure them by position.

List patterns require that the pattern match the entire list, but you can use
[rest elements](#rest-element) as a place holder.

### Rest element

List patterns can contain _one_ rest element (`...`) which allows matching lists
of arbitrary lengths.

```dart
var [a, b, ..., c, d] = [1, 2, 3, 4, 5, 6, 7];
print('$a $b $c $d'); // Prints "1 2 6 7".
```

Rest elements can also have subpatterns that collects elements that don't match
the other subpatterns in the list, into a new list:

```dart
var [a, b, ...rest, c, d] = [1, 2, 3, 4, 5, 6, 7];
print('$a $b $rest $c $d'); // Prints "1 2 [3, 4, 5] 6 7".
```

## Logical-and	

`subpattern1 && subpattern2`

A pair of patterns separated by `&&` matches only if both subpatterns match. If the
left branch does not match, the right branch is not evaluated. 

## Logical-or

`subpattern1 || subpattern2`

A pair of patterns separated by `||` matches if either of the branches match.
If the left branch matches, the right branch is not evaluated. 

Logical-or patterns can be nested inside a destructuring pattern. 

```dart
switch (list) {
  // Matches a two-element list whose first element is 'a' or 'b':
  case ['a' || 'b', var c]:
}
```

{% comment %}
[TODO: move the below content to the switch page, doesn't belong here]
{% endcomment %}

Logical-or patterns are useful for having multiple cases share a body in switch
expressions or statements.

```dart
var isPrimary = switch (color) {
  Color.red || Color.yellow || Color.blue => true,
  _ => false
};
```

Switch statements can have multiple cases share a body without using logical-or
patterns, but they are still uniquely useful for allowing multiple cases to share
a guard: 

```dart
switch (shape) {
  case Square(size: var s) || Circle(size: var s) when s > 0:
    print('Non-empty symmetric shape');
}
```

## Map

`{"key": subpattern1, someConst: subpattern2}`

Map patterns match values that implement [`Map`][], and then recursively 
match its subpatterns against the map’s keys to destructure them.

Map patterns don't require the pattern to match the entire map. If a map has
extra keys that te pattern doesn't destructure, it can still match.

## Null-assert	

`subpattern!`

Null-assert patterns permit non-null values to flow through, but [throw][] if the
matched value is null. 

```dart
List<String?> row = // ...

// If the first column is 'user', we expect to have a name after it.
switch (row) {
  case ['user', var name!]:
    // name is a non-nullable string here.
}
```

## Null-check	

`subpattern?`

Null-check patterns match if the value is not null, and then match the inner
pattern against that same value.


```dart
String? maybeString = // ...
switch (maybeString) {
  case var s?:
    // s has type non-nullable String here.
}
```

## Object

`SomeClass(x: subpattern1, y: subpattern2)`

Object patterns checks the matched value against a given named type to destructure
data using the getters the object's class already defines. They are [refuted][]
if the value doesn't have the same type.

The getter name can be omitted and inferred from the [variable pattern](#variable)
or [identifier pattern](#identifier) in the field subpattern:

```dart
var Point(:var x, :var y) = Point(1, 2);
```

Object patterns don't require the pattern to match the entire object.
If an object has extra fields that the pattern doesn't destructure, it can still match.

## Parenthesized

`(subpattern)`

Like parenthesized expressions, parentheses in a pattern let you control pattern
precedence and insert a lower precedence pattern where a higher precedence one is
expected.

## Record

`(subpattern1, subpattern2)`

`(x: subpattern1, y: subpattern2)`

Record patterns match a [record][] object and destructure its fields.
If the value isn't a record with the same [shape][] as the pattern, the match
fails. Otherwise, the field subpatterns are matched against the corresponding
fields in the record.

```dart
// Variable:
var (untyped: untyped, typed: int typed) = // ...
var (:untyped, :int typed) = // ...

switch (obj) {
  case (untyped: var untyped, typed: int typed): // ...
  case (:var untyped, :int typed): // ...
}

// Null-check and null-assert:
switch (obj) {
  case (checked: var checked?, asserted: var asserted!): // ...
  case (:var checked?, :var asserted!): // ...
}

// Cast:
var (field: field as int) = // ...
var (:field as int) = // ...
```

The getter name can be omitted and inferred from the [variable pattern](#variable)
or [identifier pattern](#identifier) in the field subpattern.

Record patterns require that the pattern match the entire record.

## Relational

`== expression`

`< expression`

Relational patterns compare the matched value to a given constant using any of
the equality or relational operators: `==`, `!=`, `<`, `>`, `<=`, and `>=`.

The pattern matches when calling the appropriate operator on the matched value
with the constant as an argument returns `true`.

Relational patterns are useful for matching on numeric ranges, especially when
combined with the [logical-and pattern](#logical-and):

```dart
String asciiCharType(int char) {
  const space = 32;
  const zero = 48;
  const nine = 57;

  return switch (char) {
    < space => 'control',
    == space => 'space',
    > space && < zero => 'punctuation',
    >= zero && <= nine => 'digit'
    // Etc...
  }
}
```

## Variable

`var bar, String str, final int _`

Variable patterns bind new variables to values that have been matched or destructured. 
They usually occur as part of a [destructuring pattern][destructure] in order to
capture a destructured value.

The variables are in scope in a region of code that is only reachable when the
pattern has matched.

```dart
switch ((1, 2)) {
  case (var a, var b): // ...
  // var a and var b are variable patterns that bind to 1 and 2, respectively.
  // They are in scope in the case body.
}
```

A [wildcard pattern](#wildcard) can be used a variable pattern. 

## Wildcard

`_`

A pattern named `_` is a wildcard, either a [variable pattern](#variable) or
[identifier pattern](#identifier), that doesn't bind or assign to any variable.

It's useful as a placeholder in places where you need a subpattern in order to
destructure later positional values:

```dart
var list = [1, 2, 3];
var [_, two, _] = list;
```

A wildcard name with a type annotation is useful when you want to test a value's
type but not bind the value to a name:

```dart
switch (record) {
  case (int _, String _):
    print('First field is int and second is String.');
}
```

[type cast]: /language/operators#type-test-operators
[destructure]: /language/patterns#destructuring
[throw]: /language/error-handling#throw
[Declaration]: /language/patterns#variable-declaration
[Assignment]: /language/patterns#variable-assignment
[Matching]: /language/patterns#matching
[`List`]: /language/collections#lists
[`Map`]: /language/collections#maps
[refuted]: /resources/glossary#refutable-pattern
[record]: /
[shape]: /