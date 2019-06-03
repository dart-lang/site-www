---
title: Diagnostics
description: Details for diagnostics produced by the Dart analyzer.
---

This page lists diagnostic messages produced by the Dart analyzer,
with details about what those messages mean
and how you can fix your code.
For more information about the analyzer, see
[Customizing static analysis](/guides/language/analysis-options).


## Glossary

This page uses the following terms.

### Element

[PENDING: definition]

### Potentially non-nullable

A type is _potentially non-nullable_ if it's either explicitly non-nullable or
if it's a type parameter.
The latter case is included because
the actual runtime type might be non-nullable.


## List of diagnostics

The analyzer produces the following diagnostics when [PENDING...].

### AMBIGUOUS_SET_OR_MAP_LITERAL_BOTH

This literal contains both 'Map' and 'Iterable' spreads, which makes it impossible to determine whether the literal is a map or a set.

#### Description

Because map and set literals use the same delimiters (`{` and `}`), the analyzer looks at the type arguments and the elements to determine which kind of literal you meant. When there are no type arguments and all of the elements are spread elements (which are allowed in both kinds of literals), then the analyzer uses the types of the expressions that are being spread. If all of the expressions have the type `Iterable`, then it's a set literal; if they all have the type `Map`, then it's a map literal.

The analyzer produces this diagnostic when some of the expressions being spread have the type `Iterable` and others have the type `Map`, making it impossible for the analyzer to determine whether you are writing a map literal or a set literal.

#### Example

The following code produces this diagnostic:

{% prettify dart %}
union(Map<String, String> a, List<String> b, Map<String, String> c) => [[highlight]]{...a, ...b, ...c}[[/highlight]];
{% endprettify %}

The list `b` can only be spread into a set, and the maps `a` and `c` can only be spread into a map, and the literal can't be both.

#### Common fixes

There are two common ways to fix this problem. The first is to remove all of the spread elements of one kind or the other, so that the elements are consistent. In this case, that likely means removing the list (and deciding what to do about the now unused parameter):

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) => {...a, ...c};
```

The second fix is to change the elements of one kind into elements that are consistent with the other elements. For example, you could add the elements of the list as keys that map to themselves:

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) => {...a, for (String s in b) s : s, ...c};
```

### AMBIGUOUS_SET_OR_MAP_LITERAL_EITHER

This literal must be either a map or a set, but the elements don't have enough type information for type inference to work.

#### Description

Because map and set literals use the same delimiters (`‘{` and `}`), the analyzer looks at the type arguments and the elements to determine which kind of literal you meant. When there are no type arguments and all of the elements are spread elements (which are allowed in both kinds of literals) then the analyzer uses the types of the expressions that are being spread to decide. If all of the expressions have the type `Iterable`, then it's a set literal, if they all have the type `Map`, then it's a map literal.

This diagnostic is produced when none of the expressions being spread has a type that allows the analyzer to decide whether you were writing a map literal or a set literal.

#### Example
The following code produces this diagnostic:

{% prettify dart %}
union(a, b) => [[highlight]]{...a, ...b}[[/highlight]];
{% endprettify %}

The problem occurs because there are no type arguments, and there is no information about the type of either `a` or `b`.

#### Common fixes

There are three common ways to fix this problem. The first is to add type arguments to the literal. For example, if the literal is intended to be a map literal, you might write something like this:

```dart
union(a, b) => <String, String>{...a, ...b};
```

The second fix is to add type information so that the expressions have either the type `Iterable` or the type `Map`. You could add an explicit cast or, in this case, add types to the declarations of the two parameters:

```dart
union(List<int> a, List<int> b) => {...a, ...b};
```

The third fix is to add context information. In this case, that means adding a return type to the function:

```dart
Set<String> union(a, b) => {...a, ...b};
```

In other cases, you might add a type somewhere else. For example, say the original code looks like this:

```dart
union(a, b) {
  var x = {...a, ...b};
  return x;
}
```

You might add a type annotation on `x`, like this:

```dart
union(a, b) {
  Map<String, String> x = {...a, ...b};
  return x;
}
```

### DEFAULT_VALUE_ON_REQUIRED_PARAMETER

Required named parameters can't have a default value.

#### Description
The analyzer produces this diagnostic when a named parameter has both the `required` modifier and a default value. If the parameter is required, then a value for the parameter is always provided at the call sites, so the default value can never be used.

#### Example
The following code generates this diagnostic:

{% prettify dart %}
void log({required String [[highlight]]message[[/highlight]] = 'no message'}) {}
{% endprettify %}

#### Common fixes

If the parameter is really required, then remove the default value:

```dart
void log({required String message}) {}
```

If the parameter isn't always required, then remove the `required` modifier:

```dart
void log({String message = 'no message'}) {}
```


### DEPRECATED_MEMBER_USE

'{0}' is deprecated and shouldn't be used.

#### Description

The analyzer produces this diagnostic when a deprecated library or class member is used in a different package.

#### Example

If the method `m` in the class `C` is annotated with `@deprecated`, then the following code produces this diagnostic:

{% prettify dart %}
void f(C c) {
  c.[[highlight]]m[[/highlight]]();
}
{% endprettify %}

#### Common fixes

The documentation for elements that are annotated with `@deprecated` should have documentation to indicate what code to use in place of the deprecated code.

### EXPRESSION_IN_MAP

Expressions can't be used in a map literal.

#### Description

The analyzer produces this diagnostic when the analyzer finds an expression, rather than a map entry, in what appears to be a map literal.

#### Example

The following code generates this diagnostic:

{% prettify dart %}
var map = {'a' : 0, 'b' : 1, [[highlight]]'c'[[/highlight]]};
{% endprettify %}

#### Common fixes

If the expression is intended to compute either a key or a value in an entry, fix the issue by completing the code:

```dart
var map = {'a' : 0, 'b' : 1, 'c' : 2};
```

If the expression was added by mistake, fix the issue by removing the expression.

### INVALID_LITERAL_ANNOTATION

Only const constructors can have the `@literal` annotation.

#### Description

This diagnostic occurs when the `@literal` annotation is on anything that isn't a const constructor. The annotation is defined to apply to const constructors, so its use anywhere else doesn't have a well defined meaning.

The meaning of the `@literal` annotation is only defined when it's applied to a const constructor.

#### Example

The following code produces this diagnostic:

{% prettify dart %}
[[highlight]]@literal[[/highlight]]
var x;
{% endprettify %}

#### Common fixes

Remove the annotation:

```dart
var x;
```

### MISSING_DEFAULT_VALUE_FOR_PARAMETER

The parameter '{0}' can't have a value of 'null' because of its type, so it must either be a required parameter or have a default value.

#### Description

The analyzer produces this diagnostic when an optional parameter doesn't have a default value, but has a type that allows it to be used as if it were non-nullable.

#### Example

The following code generates this diagnostic:

{% prettify dart %}
void log({String [[highlight]]message[[/highlight]]}) {}
{% endprettify %}

#### Common fixes

If the parameter can have the value `null`, then add a question mark after the type annotation:

```dart
void log({String? message}) {}
```

If the parameter can't be null, then either provide a default value:

```dart
void log({String message = ''}) {}
```

or add the `required` modifier to the parameter:

```dart
void log({required String message}) {}
```

### MISSING_SPREAD_OPERATOR

A spread operator is required in order to add the contents of one collection to another.

#### Description

The analyzer produces this diagnostic when two conditions are met. First a list, map, or set literal (the outer collection) contains an element that can't be added to the collection. Second, that element is a collection (the inner collection) that contains elements that could be added to the outer collection by using a spread operator.

The most common reason for this diagnostic is forgetting to add the spread operator before a collection that's being added to another collection.

#### Example

The following code produces this diagnostic:

{% prettify dart %}
var inner = <int>[3, 4, 5];
var outer = <int>[1, 2, [[highlight]]inner[[/highlight]], 6];
{% endprettify %}

The highlighted element is a list of integers, while the outer collection is declared to contain integers, not lists of integers.

#### Common fixes

The most common fix for this issue is to add a spread operator before the inner collection:

```dart
var inner = <int>[3, 4, 5];
var outer = <int>[1, 2, ...inner, 6];
```

### NOT_ITERABLE_SPREAD

Spread elements in list or set literals must implement 'Iterable'.

#### Description

The analyzer produces this diagnostic when the static type of the expression of a spread element that appears in either a list literal or a set literal doesn't implement the type `Iterable`.

#### Example

The following code generates this diagnostic:

{% prettify dart %}
Map<String, int> m = {'a' : 0, 'b' : 1};
Set<String> s = {[[highlight]]...m[[/highlight]]};
{% endprettify %}

#### Common fixes

[PENDING: supply here]

### NULLABLE_TYPE_IN_EXTENDS_CLAUSE

A class can't extend a nullable type.

#### Description

The analyzer produces this diagnostic when a class declaration uses an extends clause to specify a superclass, and the type that's specified is a nullable type.

The reason the supertype is a _type_ rather than a class name is to allow you to control the signatures of the members to be inherited from the supertype, such as by specifying type arguments. However, the nullability of a type doesn't change the signatures of any members, so there isn't any reason to allow the nullability to be specified when used in the extends clause.

#### Example

The following code generates this diagnostic:

{% prettify dart %}
class Invalid extends [[highlight]]Duration?[[/highlight]] {}
{% endprettify %}

#### Common fixes

The most common fix is to remove the question mark:

```dart
class Invalid extends Duration {}
```

### SDK_VERSION_SET_LITERAL

Set literals weren't supported until version 2.2, but this code must be able to run on earlier versions.

#### Description

The analyzer produces this diagnostic when a set literal is found in code that has an SDK constraint whose lower bound is less than 2.2. Set literals were not supported in earlier versions, so this code won't be able to run against earlier versions of the SDK.

#### Example

In a package that defines SDK constraints in the `pubspec.yaml` file that have a lower bound that's less than 2.2:

```dart
environment:
  sdk: '>=2.1.0 <2.4.0'
```

The following code generates this diagnostic:

{% prettify dart %}
var s = [[highlight]]<int>{}[[/highlight]];
{% endprettify %}

#### Common fixes

If you don't need to support older versions of the SDK, then you can increase the SDK constraint to allow the syntax to be used:

```dart
environment:
  sdk: '>=2.2.0 <2.4.0'
```

If you do need to support older versions of the SDK, then replace the set literal with code that creates the set without the use of a literal:

```dart
var s = new Set<int>();
```
