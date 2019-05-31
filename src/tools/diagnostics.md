---
title: Diagnostics
description: Details for diagnostics produced by the Dart analyzer.
---

This page lists all diagnostic messages produced by the Dart analyzer,
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


## Compile-time errors

The analyzer produces the following diagnostics when [PENDING...].

### AMBIGUOUS_SET_OR_MAP_LITERAL_BOTH

#### Message

This literal contains both 'Map' and 'Iterable' spreads, which makes it impossible to determine whether the literal is a map or a set.

#### Description

Because map and set literals use the same delimiters (`{` and `}`), the analyzer looks at the type arguments and the elements to determine which kind of literal you meant. When there are no type arguments and all of the elements are spread elements (which are allowed in both kinds of literals), then the analyzer uses the types of the expressions that are being spread. If all of the expressions have the type `Iterable`, then it's a set literal; if they all have the type `Map`, then it's a map literal.

The analyzer produces this diagnostic when some of the expressions being spread have the type `Iterable` and others have the type `Map`, making it impossible for the analyzer to determine whether you are writing a map literal or a set literal.

#### Example

The following code produces this diagnostic:

{% prettify dart %}
union(Map<String, String> a, List<String> b, Map<String, String> c) => [!{...a, ...b, ...c}!];
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

#### Message

This literal must be either a map or a set, but the elements don't have enough type information for type inference to work.

#### Description

Because map and set literals use the same delimiters (`‘{` and `}`), the analyzer looks at the type arguments and the elements to determine which kind of literal you meant. When there are no type arguments and all of the elements are spread elements (which are allowed in both kinds of literals) then the analyzer uses the types of the expressions that are being spread to decide. If all of the expressions have the type `Iterable`, then it's a set literal, if they all have the type `Map`, then it's a map literal.

This diagnostic is produced when none of the expressions being spread has a type that allows the analyzer to decide whether you were writing a map literal or a set literal.

#### Example
The following code produces this diagnostic:

{% prettify dart %}
union(a, b) => [!{...a, ...b}!];
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

#### Message

Required named parameters can't have a default value.

#### Description
The analyzer produces this diagnostic when a named parameter has both the `required` modifier and a default value. If the parameter is required, then a value for the parameter is always provided at the call sites, so the default value can never be used.

#### Example
The following code generates this diagnostic:

{% prettify dart %}
void log({required String [!message!] = 'no message'}) {}
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

### EXPRESSION_IN_MAP

#### Message

Expressions can't be used in a map literal.

#### Description

The analyzer produces this diagnostic when the analyzer finds an expression, rather than a map entry, in what appears to be a map literal.

#### Example

The following code generates this diagnostic:

{% prettify dart %}
var map = {'a' : 0, 'b' : 1, [!'c'!]};
{% endprettify %}

#### Common fixes

If the expression is intended to compute either a key or a value in an entry, fix the issue by completing the code:

```dart
var map = {'a' : 0, 'b' : 1, 'c' : 2};
```

If the expression was added by mistake, fix the issue by removing the expression.

### MISSING_DEFAULT_VALUE_FOR_PARAMETER

#### Message

The parameter '{0}' can't have a value of 'null' because of its type, so it must either be a required parameter or have a default value.

#### Description

The analyzer produces this diagnostic when an optional parameter doesn't have a default value, but has a type that allows it to be used as if it were non-nullable.

#### Example

The following code generates this diagnostic:

{% prettify dart %}
void log({String [!message!]}) {}
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

#### Message

A spread operator is required in order to add the contents of one collection to another.

#### Description

The analyzer produces this diagnostic when two conditions are met. First a list, map, or set literal (the outer collection) contains an element that can't be added to the collection. Second, that element is a collection (the inner collection) that contains elements that could be added to the outer collection by using a spread operator.

The most common reason for this diagnostic is forgetting to add the spread operator before a collection that's being added to another collection.

#### Example

The following code produces this diagnostic:

{% prettify dart %}
var inner = <int>[3, 4, 5];
var outer = <int>[1, 2, [!inner!], 6];
{% endprettify %}

The highlighted element is a list of integers, while the outer collection is declared to contain integers, not lists of integers.

#### Common fixes

The most common fix for this issue is to add a spread operator before the inner collection:

```dart
var inner = <int>[3, 4, 5];
var outer = <int>[1, 2, ...inner, 6];
```

### NOT_ITERABLE_SPREAD

#### Message
Spread elements in list or set literals must implement 'Iterable'.

#### Description

The analyzer produces this diagnostic when the static type of the expression of a spread element that appears in either a list literal or a set literal doesn't implement the type `Iterable`.

#### Example

The following code generates this diagnostic:

{% prettify dart %}
Map<String, int> m = {'a' : 0, 'b' : 1};
Set<String> s = {[!...m!]};
{% endprettify %}

#### Common fixes

[PENDING: supply here]

### NULLABLE_TYPE_IN_EXTENDS_CLAUSE

#### Message

A class can't extend a nullable type.

#### Description

The analyzer produces this diagnostic when a class declaration uses an extends clause to specify a superclass, and the type that's specified is a nullable type.

The reason the supertype is a _type_ rather than a class name is to allow you to control the signatures of the members to be inherited from the supertype, such as by specifying type arguments. However, the nullability of a type doesn't change the signatures of any members, so there isn't any reason to allow the nullability to be specified when used in the extends clause.

#### Example

The following code generates this diagnostic:

{% prettify dart %}
class Invalid extends [!Duration?!] {}
{% endprettify %}

#### Common fixes

The most common fix is to remove the question mark:

```dart
class Invalid extends Duration {}
```

## Hints

### DEPRECATED_MEMBER_USE

#### Message

'{0}' is deprecated and shouldn't be used.

#### Description

The analyzer produces this diagnostic when a deprecated library or class member is used in a different package.

#### Example

If the method `m` in the class `C` is annotated with `@deprecated`, then the following code produces this diagnostic:

{% prettify dart %}
void f(C c) {
  c.[!m!]();
}
{% endprettify %}

#### Common fixes

The documentation for elements that are annotated with `@deprecated` should have documentation to indicate what code to use in place of the deprecated code.

### INVALID_LITERAL_ANNOTATION

#### Message

Only const constructors can have the `@literal` annotation.

#### Description

This diagnostic occurs when the `@literal` annotation is on anything that isn't a const constructor. The annotation is defined to apply to const constructors, so its use anywhere else doesn't have a well defined meaning.

The meaning of the `@literal` annotation is only defined when it's applied to a const constructor.

#### Example

The following code produces this diagnostic:

{% prettify dart %}
[!@literal!]
var x;
{% endprettify %}

#### Common fixes

Remove the annotation:

```dart
var x;
```

### SDK_VERSION_SET_LITERAL

#### Message

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
var s = [!<int>{}!];
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

{% comment %}

CompileTimeErrorCode.CONST_SPREAD_EXPECTED_LIST_OR_SET ***
  A list or a set is expected in this spread.
  null

CompileTimeErrorCode.CONST_SPREAD_EXPECTED_MAP ***
  A map is expected in this spread.
  null

CompileTimeErrorCode.EQUAL_KEYS_IN_CONST_MAP ***
  Two keys in a constant map literal can't be equal.
  null

CompileTimeErrorCode.EQUAL_ELEMENTS_IN_CONST_SET ***
  Two values in a constant set can't be equal.
  null

CompileTimeErrorCode.MAP_ENTRY_NOT_IN_MAP ***
  Map entries can only be used in a map literal.
  Try converting the collection to a map or removing the map entry.

CompileTimeErrorCode.NON_CONSTANT_MAP_ELEMENT ***
  The elements in a const map literal must be constant.
  Try removing the keyword 'const' from the map literal.

CompileTimeErrorCode.NON_CONSTANT_SPREAD_EXPRESSION_FROM_DEFERRED_LIBRARY ***
  Constant values from a deferred library can't be spread into a const literal.
  Try making the deferred import non-deferred.

CompileTimeErrorCode.NON_CONSTANT_IF_ELEMENT_CONDITION_FROM_DEFERRED_LIBRARY ***
  Constant values from a deferred library can't be used as values in an if condition inside a const collection literal.
  Try making the deferred import non-deferred.

CompileTimeErrorCode.NOT_ITERABLE_SPREAD ***
  Spread elements in list or set literals must implement 'Iterable'.
  null

CompileTimeErrorCode.NOT_MAP_SPREAD ***
  Spread elements in map literals must implement 'Map'.
  null

CompileTimeErrorCode.NULLABLE_TYPE_IN_CATCH_CLAUSE ***
  A nullable type can't be used in an 'on' clause because it isn't valid to throw 'null'.
  Try removing the question mark.

CompileTimeErrorCode.NULLABLE_TYPE_IN_IMPLEMENTS_CLAUSE ***
  A class or mixin can't implement a nullable type
  Try removing the question mark.

CompileTimeErrorCode.NULLABLE_TYPE_IN_ON_CLAUSE ***
  A mixin can't have a nullable type as a superclass constraint.
  Try removing the question mark.

CompileTimeErrorCode.NULLABLE_TYPE_IN_WITH_CLAUSE ***
  A class or mixin can't mix in a nullable type.
  Try removing the question mark.

StaticTypeWarningCode.UNDEFINED_PREFIXED_NAME ***
  The name '{0}' is being referenced through the prefix '{1}', but it isn't defined in any of the libraries imported using that prefix.
  Try correcting the prefix or importing the library that defines '{0}'.

HintCode.DEPRECATED_FUNCTION_CLASS_DECLARATION ***
  Declaring a class named 'Function' is deprecated.
  Try renaming the class.

HintCode.DEPRECATED_MEMBER_USE_FROM_SAME_PACKAGE ***
  '{0}' is deprecated and shouldn't be used.
  Try replacing the use of the deprecated member with the replacement.

HintCode.INFERENCE_FAILURE_ON_UNINITIALIZED_VARIABLE ***
  The type of {0} can't be inferred without either a type or initializer.
  Try specifying the type of the variable.

HintCode.INVALID_LITERAL_ANNOTATION
  Add correction:
  Try removing the annotation.

HintCode.INVALID_VISIBILITY_ANNOTATION ***
  The member '{0}' is annotated with '{1}', but this annotation is only meaningful on declarations of public members.
  Add correction:
  Try removing the annotation.

HintCode.MIXIN_ON_SEALED_CLASS ***
  The class '{0}' shouldn't be used as a mixin constraint because it's sealed, and any class mixing in this mixin has '{0}' as a superclass.
  Try composing with this class, or refer to its documentation for more information.

HintCode.NON_CONST_CALL_TO_LITERAL_CONSTRUCTOR ***
  This instance creation must be 'const', because the {0} constructor is marked as '@literal'.
  Try adding a 'const' keyword.

HintCode.NON_CONST_CALL_TO_LITERAL_CONSTRUCTOR_USING_NEW ***
  This instance creation must be 'const', because the {0} constructor is marked as '@literal'.
  Try replacing the 'new' keyword with 'const'.

HintCode.SDK_VERSION_ASYNC_EXPORTED_FROM_CORE ***
  The class '{0}' wasn't exported from 'dart:core' until version 2.1, but this code is required to be able to run on earlier versions.
  Try either importing 'dart:async' or updating the SDK constraints.

HintCode.SDK_VERSION_AS_EXPRESSION_IN_CONST_CONTEXT ***
  The use of an as expression in a constant expression wasn't supported until version 2.2.2, but this code is required to be able to run on earlier versions.
  Try updating the SDK constraints.

HintCode.SDK_VERSION_BOOL_OPERATOR ***
  Using the operator '{0}' for 'bool's wasn't supported until version 2.2.2, but this code is required to be able to run on earlier versions.
  Try updating the SDK constraints.

HintCode.SDK_VERSION_EQ_EQ_OPERATOR_IN_CONST_CONTEXT ***
  Using the operator '==' for non-primitive types wasn't supported until version 2.2.2, but this code is required to be able to run on earlier versions.
  Try updating the SDK constraints.

HintCode.SDK_VERSION_GT_GT_GT_OPERATOR ***
  The operator '>>>' wasn't supported until version 2.2.2, but this code is required to be able to run on earlier versions.
  Try updating the SDK constraints.

HintCode.SDK_VERSION_IS_EXPRESSION_IN_CONST_CONTEXT ***
  The use of an is expression in a constant expression wasn't supported until version 2.2.2, but this code is required to be able to run on earlier versions.
  Try updating the SDK constraints.

HintCode.SDK_VERSION_SET_LITERAL ***
  Set literals were not supported until version 2.2, but this code is required to be able to run on earlier versions.
  Try updating the SDK constraints.

HintCode.SDK_VERSION_UI_AS_CODE ***
  The for, if and spread elements were not supported until version 2.2.2, but this code is required to be able to run on earlier versions.
  Try updating the SDK constraints.

HintCode.STRICT_RAW_TYPE ***
  The generic type '{0}' should have explicit type arguments but doesn't.
  Use explicit type arguments for '{0}'.

HintCode.SUBTYPE_OF_SEALED_CLASS ***
  The class '{0}' shouldn't be extended, mixed in, or implemented because it's sealed.
  Try composing instead of inheriting, or refer to its documentation for more information.

HintCode.UNNECESSARY_NULL_AWARE_CALL ***
  The target expression can' be null, and so '?.' isn't necessary.
  Replace the '?.' with a '.' in the invocation.

AnalysisOptionsErrorCode.PARSE_ERROR
  {0}
  null
AnalysisOptionsErrorCode.INCLUDED_FILE_PARSE_ERROR
  {3} in {0}({1}..{2})
  null
AnalysisOptionsWarningCode.ANALYSIS_OPTION_DEPRECATED
  The option '{0}' is no longer supported.
  null
AnalysisOptionsWarningCode.INCLUDE_FILE_NOT_FOUND
  The include file {0} in {1} can't be found.
  null
AnalysisOptionsWarningCode.INCLUDED_FILE_WARNING
  Warning in the included options file {0}({1}..{2}): {3}
  null
AnalysisOptionsWarningCode.INVALID_OPTION
  Invalid option specified for '{0}': {1}
  null
AnalysisOptionsWarningCode.INVALID_SECTION_FORMAT
  Invalid format for the '{0}' section.
  null
AnalysisOptionsWarningCode.UNRECOGNIZED_ERROR_CODE
  '{0}' isn't a recognized error code.
  null
AnalysisOptionsWarningCode.UNSUPPORTED_OPTION_WITH_LEGAL_VALUE
  The option '{1}' isn't supported by '{0}'. Try using the only supported option: '{2}'.
  null
AnalysisOptionsWarningCode.UNSUPPORTED_OPTION_WITH_LEGAL_VALUES
  The option '{1}' isn't supported by '{0}'.
  Try using one of the supported options: {2}.
AnalysisOptionsWarningCode.UNSUPPORTED_OPTION_WITHOUT_VALUES
  The option '{1}' isn't supported by '{0}'.
  null
AnalysisOptionsWarningCode.UNSUPPORTED_VALUE
  The value '{1}' isn't supported by '{0}'.
  Try using one of the supported options: {2}.
AnalysisOptionsWarningCode.SPEC_MODE_REMOVED
  The option 'strong-mode: false' is no longer supported.
  It's recommended to remove the 'strong-mode:' setting (and make your code Dart 2 compliant).
AnalysisOptionsHintCode.DEPRECATED_ANALYSIS_OPTIONS_FILE_NAME
  The name of the analysis options file {0} is deprecated; consider renaming it to analysis_options.yaml.
  null
AnalysisOptionsHintCode.PREVIEW_DART_2_SETTING_DEPRECATED
  The 'enablePreviewDart2' setting is deprecated.
  It's no longer necessary to explicitly enable Dart 2.
AnalysisOptionsHintCode.STRONG_MODE_SETTING_DEPRECATED
  The 'strong-mode: true' setting is deprecated.
  It's no longer necessary to explicitly enable strong mode.
AnalysisOptionsHintCode.SUPER_MIXINS_SETTING_DEPRECATED
  The 'enableSuperMixins' setting is deprecated.
  Support has been added to the language for 'mixin' based mixins.

CheckedModeCompileTimeErrorCode.CONST_CONSTRUCTOR_FIELD_TYPE_MISMATCH
  A value of type '{0}' can't be assigned to the field '{1}', which has type '{2}'.
  null
CheckedModeCompileTimeErrorCode.CONST_CONSTRUCTOR_PARAM_TYPE_MISMATCH
  A value of type '{0}' can't be assigned to a parameter of type '{1}'.
  null
CheckedModeCompileTimeErrorCode.CONST_FIELD_INITIALIZER_NOT_ASSIGNABLE
  The initializer type '{0}' can't be assigned to the field type '{1}'.
  null
CheckedModeCompileTimeErrorCode.VARIABLE_TYPE_MISMATCH
  A value of type '{0}' can't be assigned to a variable of type '{1}'.
  null
CompileTimeErrorCode.ABSTRACT_SUPER_MEMBER_REFERENCE
  The {0} '{1}' is always abstract in the supertype.
  null
CompileTimeErrorCode.ACCESS_PRIVATE_ENUM_FIELD
  The private fields of an enum can't be accessed, even within the same library.
  null
CompileTimeErrorCode.AMBIGUOUS_EXPORT
  The name '{0}' is defined in the libraries '{1}' and '{2}'.
  Try removing the export of one of the libraries, or explicitly hiding the name in one of the export directives.

CompileTimeErrorCode.ANNOTATION_WITH_NON_CLASS
  The name '{0}' isn't a class.
  Try importing the library that declares the class, correcting the name to match a defined class, or defining a class with the given name.
CompileTimeErrorCode.ANNOTATION_WITH_TYPE_ARGUMENTS
  An annotation (metadata) can't use type arguments.
  null
CompileTimeErrorCode.ASYNC_FOR_IN_WRONG_CONTEXT
  The asynchronous for-in can only be used in an asynchronous function.
  Try marking the function body with either 'async' or 'async*', or removing the 'await' before the for loop.
CompileTimeErrorCode.AWAIT_IN_WRONG_CONTEXT
  The await expression can only be used in an asynchronous function.
  Try marking the function body with either 'async' or 'async*'.
CompileTimeErrorCode.BUILT_IN_IDENTIFIER_AS_PREFIX_NAME
  The built-in identifier '{0}' can't be used as a prefix name.
  Try choosing a different name for the prefix.
CompileTimeErrorCode.BUILT_IN_IDENTIFIER_AS_TYPE
  The built-in identifier '{0}' can't be used as a type.
  Try correcting the name to match an existing type.
CompileTimeErrorCode.BUILT_IN_IDENTIFIER_AS_TYPEDEF_NAME
  The built-in identifier '{0}' can't be used as a typedef name.
  Try choosing a different name for the typedef.
CompileTimeErrorCode.BUILT_IN_IDENTIFIER_AS_TYPE_NAME
  The built-in identifier '{0}' can't be used as a type name.
  Try choosing a different name for the type.
CompileTimeErrorCode.BUILT_IN_IDENTIFIER_AS_TYPE_PARAMETER_NAME
  The built-in identifier '{0}' can't be used as a type parameter name.
  Try choosing a different name for the type parameter.
CompileTimeErrorCode.CASE_EXPRESSION_TYPE_IMPLEMENTS_EQUALS
  The switch case expression type '{0}' can't override the == operator.
  null
CompileTimeErrorCode.CONFLICTING_CONSTRUCTOR_AND_STATIC_FIELD
  '{0}' can't be used to name both a constructor and a static field in this class.
  Try renaming either the constructor or the field.
CompileTimeErrorCode.CONFLICTING_CONSTRUCTOR_AND_STATIC_METHOD
  '{0}' can't be used to name both a constructor and a static method in this class.
  Try renaming either the constructor or the method.
CompileTimeErrorCode.CONFLICTING_FIELD_AND_METHOD
  Class '{0}' can't define field '{1}' and have method '{2}.{1}' with the same name.
  Try converting the getter to a method, or renaming the field to a name that doesn't conflict.
CompileTimeErrorCode.CONFLICTING_GENERIC_INTERFACES
  The class '{0}' can't implement both '{1}' and '{2}' because the type arguments are different.
  null
CompileTimeErrorCode.CONFLICTING_METHOD_AND_FIELD
  Class '{0}' can't define method '{1}' and have field '{2}.{1}' with the same name.
  Try converting the method to a getter, or renaming the method to a name that doesn't conflict.
CompileTimeErrorCode.CONFLICTING_STATIC_AND_INSTANCE
  Class '{0}' can't define static member '{1}' and have instance member '{2}.{1}' with the same name.
  Try renaming the member to a name that doesn't conflict.
CompileTimeErrorCode.CONFLICTING_TYPE_VARIABLE_AND_CLASS
  '{0}' can't be used to name both a type variable and the class in which the type variable is defined.
  Try renaming either the type variable or the class.
CompileTimeErrorCode.CONFLICTING_TYPE_VARIABLE_AND_MEMBER
  '{0}' can't be used to name both a type variable and a member in this class.
  Try renaming either the type variable or the member.
CompileTimeErrorCode.CONST_CONSTRUCTOR_THROWS_EXCEPTION
  Const constructors can't throw exceptions.
  Try removing the throw statement, or removing the keyword 'const'.
CompileTimeErrorCode.CONST_CONSTRUCTOR_WITH_FIELD_INITIALIZED_BY_NON_CONST
  Can't define the const constructor because the field '{0}' is initialized with a non-constant value.
  Try initializing the field to a constant value, or removing the keyword 'const' from the constructor.
CompileTimeErrorCode.CONST_CONSTRUCTOR_WITH_MIXIN_WITH_FIELD
  Const constructor can't be declared for a class with a mixin that declares an instance field.
  Try removing the 'const' keyword or removing the 'with' clause from the class declaration, or removing fields from the mixin class.
CompileTimeErrorCode.CONST_CONSTRUCTOR_WITH_NON_CONST_SUPER
  Constant constructor can't call non-constant super constructor of '{0}'.
  Try calling a const constructor in the superclass, or removing the keyword 'const' from the constructor.
CompileTimeErrorCode.CONST_CONSTRUCTOR_WITH_NON_FINAL_FIELD
  Can't define a const constructor for a class with non-final fields.
  Try making all of the fields final, or removing the keyword 'const' from the constructor.
CompileTimeErrorCode.CONST_DEFERRED_CLASS
  Deferred classes can't be created with 'const'.
  Try using 'new' to create the instance, or changing the import to not be deferred.
CompileTimeErrorCode.CONST_EVAL_THROWS_EXCEPTION
  Evaluation of this constant expression throws an exception.
  null
CompileTimeErrorCode.CONST_EVAL_THROWS_IDBZE
  Evaluation of this constant expression throws an IntegerDivisionByZeroException.
  null
CompileTimeErrorCode.CONST_EVAL_TYPE_BOOL
  In constant expressions, operands of this operator must be of type 'bool'.
  null
CompileTimeErrorCode.CONST_EVAL_TYPE_BOOL_INT
  In constant expressions, operands of this operator must be of type 'bool' or 'int'.
  null
CompileTimeErrorCode.CONST_EVAL_TYPE_BOOL_NUM_STRING
  In constant expressions, operands of this operator must be of type 'bool', 'num', 'String' or 'null'.
  null
CompileTimeErrorCode.CONST_EVAL_TYPE_INT
  In constant expressions, operands of this operator must be of type 'int'.
  null
CompileTimeErrorCode.CONST_EVAL_TYPE_NUM
  In constant expressions, operands of this operator must be of type 'num'.
  null
CompileTimeErrorCode.CONST_EVAL_TYPE_TYPE
  In constant expressions, operands of this operator must be of type 'Type'.
  null
CompileTimeErrorCode.CONST_FORMAL_PARAMETER
  Parameters can't be const.
  Try removing the 'const' keyword.
CompileTimeErrorCode.CONST_INITIALIZED_WITH_NON_CONSTANT_VALUE
  Const variables must be initialized with a constant value.
  Try changing the initializer to be a constant expression.
CompileTimeErrorCode.CONST_INITIALIZED_WITH_NON_CONSTANT_VALUE_FROM_DEFERRED_LIBRARY
  Constant values from a deferred library can't be used to initialized a const variable.
  Try initializing the variable without referencing members of the deferred library, or changing the import to not be deferred.
CompileTimeErrorCode.CONST_INSTANCE_FIELD
  Only static fields can be declared as const.
  Try declaring the field as final, or adding the keyword 'static'.
CompileTimeErrorCode.CONST_MAP_KEY_EXPRESSION_TYPE_IMPLEMENTS_EQUALS
  The constant map entry key expression type '{0}' can't override the == operator.
  Try using a different value for the key, or removing the keyword 'const' from the map.
CompileTimeErrorCode.CONST_NOT_INITIALIZED
  The const variable '{0}' must be initialized.
  Try adding an initialization to the declaration.
CompileTimeErrorCode.CONST_SET_ELEMENT_TYPE_IMPLEMENTS_EQUALS
  The constant set element type '{0}' can't override the == operator.
  Try using a different value for the element, or removing the keyword 'const' from the set.

CompileTimeErrorCode.CONST_WITH_INVALID_TYPE_PARAMETERS
  The type '{0}' is declared with {1} type parameters, but {2} type arguments were given.
  Try adjusting the number of type arguments to match the number of type parameters.
CompileTimeErrorCode.CONST_WITH_NON_CONST
  The constructor being called isn't a const constructor.
  Try using 'new' to call the constructor.
CompileTimeErrorCode.CONST_WITH_NON_CONSTANT_ARGUMENT
  Arguments of a constant creation must be constant expressions.
  Try making the argument a valid constant, or use 'new' to call the constructor.
CompileTimeErrorCode.CONST_WITH_NON_TYPE
  The name '{0}' isn't a class.
  Try correcting the name to match an existing class.
CompileTimeErrorCode.CONST_WITH_TYPE_PARAMETERS
  A constant creation can't use a type parameter as a type argument.
  Try replacing the type parameter with a different type.
CompileTimeErrorCode.CONST_WITH_UNDEFINED_CONSTRUCTOR
  The class '{0}' doesn't have a constant constructor '{1}'.
  Try calling a different constructor.
CompileTimeErrorCode.CONST_WITH_UNDEFINED_CONSTRUCTOR_DEFAULT
  The class '{0}' doesn't have a default constant constructor.
  Try calling a different constructor.
CompileTimeErrorCode.DEFAULT_VALUE_IN_FUNCTION_TYPED_PARAMETER
  Default values aren't allowed in function typed parameters.
  Try removing the default value.
CompileTimeErrorCode.DEFAULT_VALUE_IN_FUNCTION_TYPE_ALIAS
  Default parameter values aren't allowed in typedefs.
  Try removing the default value.
CompileTimeErrorCode.DEFAULT_VALUE_IN_REDIRECTING_FACTORY_CONSTRUCTOR
  Default values aren't allowed in factory constructors that redirect to another constructor.
  Try removing the default value.
CompileTimeErrorCode.DUPLICATE_CONSTRUCTOR_DEFAULT
  The default constructor is already defined.
  Try giving one of the constructors a name.
CompileTimeErrorCode.DUPLICATE_CONSTRUCTOR_NAME
  The constructor with name '{0}' is already defined.
  Try renaming one of the constructors.
CompileTimeErrorCode.DUPLICATE_DEFINITION
  The name '{0}' is already defined.
  Try renaming one of the declarations.
CompileTimeErrorCode.DUPLICATE_NAMED_ARGUMENT
  The argument for the named parameter '{0}' was already specified.
  Try removing one of the named arguments, or correcting one of the names to reference a different named parameter.
CompileTimeErrorCode.DUPLICATE_PART
  The library already contains a part with the uri '{0}'.
  Try removing all but one of the duplicated part directives.

CompileTimeErrorCode.EXPORT_INTERNAL_LIBRARY
  The library '{0}' is internal and can't be exported.
  null
CompileTimeErrorCode.EXPORT_OF_NON_LIBRARY
  The exported library '{0}' can't have a part-of directive.
  Try exporting the library that the part is a part of.

CompileTimeErrorCode.EXTENDS_DEFERRED_CLASS
  Classes can't extend deferred classes.
  Try specifying a different superclass, or removing the extends clause.
CompileTimeErrorCode.EXTENDS_DISALLOWED_CLASS
  Classes can't extend '{0}'.
  Try specifying a different superclass, or removing the extends clause.
CompileTimeErrorCode.EXTENDS_NON_CLASS
  Classes can only extend other classes.
  Try specifying a different superclass, or removing the extends clause.
CompileTimeErrorCode.EXTRA_POSITIONAL_ARGUMENTS
  Too many positional arguments: {0} expected, but {1} found.
  Try removing the extra arguments.
CompileTimeErrorCode.EXTRA_POSITIONAL_ARGUMENTS_COULD_BE_NAMED
  Too many positional arguments: {0} expected, but {1} found.
  Try removing the extra positional arguments, or specifying the name for named arguments.
CompileTimeErrorCode.FIELD_INITIALIZED_BY_MULTIPLE_INITIALIZERS
  The field '{0}' can't be initialized twice in the same constructor.
  Try removing one of the initializations.
CompileTimeErrorCode.FIELD_INITIALIZED_IN_PARAMETER_AND_INITIALIZER
  Fields can't be initialized in both the parameter list and the initializers.
  Try removing one of the initializations.
CompileTimeErrorCode.FIELD_INITIALIZER_FACTORY_CONSTRUCTOR
  Initializing formal parameters can't be used in factory constructors.
  Try using a normal parameter.
CompileTimeErrorCode.FIELD_INITIALIZER_OUTSIDE_CONSTRUCTOR
  Initializing formal parameters can only be used in constructors.
  Try using a normal parameter.
CompileTimeErrorCode.FIELD_INITIALIZER_REDIRECTING_CONSTRUCTOR
  The redirecting constructor can't have a field initializer.
  Try using a normal parameter.
CompileTimeErrorCode.FINAL_INITIALIZED_MULTIPLE_TIMES
  '{0}' is a final field and so can only be set once.
  Try removing all but one of the initializations.
CompileTimeErrorCode.FOR_IN_WITH_CONST_VARIABLE
  A for-in loop-variable can't be 'const'.
  Try removing the 'const' modifier from the variable, or use a different variable.
CompileTimeErrorCode.GENERIC_FUNCTION_TYPED_PARAM_UNSUPPORTED
  Analysis of generic function typed parameters isn't yet supported.
  Try using an explicit typedef, or changing type parameters to `dynamic`.
CompileTimeErrorCode.GENERIC_FUNCTION_TYPE_CANNOT_BE_BOUND
  Generic function types may not be used as type parameter bounds
  Try making the free variable in the function type part of the larger declaration signature
CompileTimeErrorCode.GENERIC_FUNCTION_TYPE_CANNOT_BE_TYPE_ARGUMENT
  A generic function type can't be a type argument.
  Try removing type parameters from the generic function type, or using 'dynamic' as the type argument here.
CompileTimeErrorCode.IMPLEMENTS_DEFERRED_CLASS
  Classes and mixins can't implement deferred classes.
  Try specifying a different interface, removing the class from the list, or changing the import to not be deferred.
CompileTimeErrorCode.IMPLEMENTS_DISALLOWED_CLASS
  Classes and mixins can't implement '{0}'.
  Try specifying a different interface, or remove the class from the list.
CompileTimeErrorCode.IMPLEMENTS_NON_CLASS
  Classes and mixins can only implement classes.
  Try specifying a class, or remove the name from the list.
CompileTimeErrorCode.IMPLEMENTS_REPEATED
  '{0}' can only be implemented once.
  Try removing all but one occurrence of the class name.
CompileTimeErrorCode.IMPLEMENTS_SUPER_CLASS
  '{0}' can't be used in both 'extends' and 'implements' clauses.
  Try removing one of the occurrences.
CompileTimeErrorCode.IMPLICIT_THIS_REFERENCE_IN_INITIALIZER
  Only static members can be accessed in initializers.
  null
CompileTimeErrorCode.IMPORT_INTERNAL_LIBRARY
  The library '{0}' is internal and can't be imported.
  null
CompileTimeErrorCode.IMPORT_OF_NON_LIBRARY
  The imported library '{0}' can't have a part-of directive.
  Try importing the library that the part is a part of.
CompileTimeErrorCode.INCONSISTENT_CASE_EXPRESSION_TYPES
  Case expressions must have the same types, '{0}' isn't a '{1}'.
  null
CompileTimeErrorCode.INCONSISTENT_INHERITANCE
  Superinterfaces don't have a valid override for '{0}': {1}.
  Try adding an explicit override that's consistent with all of the inherited members.
CompileTimeErrorCode.INCONSISTENT_INHERITANCE_GETTER_AND_METHOD
  '{0}' is inherited as a getter (from '{1}') and also a method (from '{2}').
  Try adjusting the supertypes of this class to remove the inconsistency.
CompileTimeErrorCode.INITIALIZER_FOR_NON_EXISTENT_FIELD
  '{0}' isn't a field in the enclosing class.
  Try correcting the name to match an existing field, or defining a field named '{0}'.
CompileTimeErrorCode.INITIALIZER_FOR_STATIC_FIELD
  '{0}' is a static field in the enclosing class. Fields initialized in a constructor can't be static.
  Try removing the initialization.
CompileTimeErrorCode.INITIALIZING_FORMAL_FOR_NON_EXISTENT_FIELD
  '{0}' isn't a field in the enclosing class.
  Try correcting the name to match an existing field, or defining a field named '{0}'.
CompileTimeErrorCode.INITIALIZING_FORMAL_FOR_STATIC_FIELD
  '{0}' is a static field in the enclosing class. Fields initialized in a constructor can't be static.
  Try removing the initialization.
CompileTimeErrorCode.INSTANCE_MEMBER_ACCESS_FROM_FACTORY
  Instance members can't be accessed from a factory constructor.
  Try removing the reference to the instance member.
CompileTimeErrorCode.INSTANCE_MEMBER_ACCESS_FROM_STATIC
  Instance members can't be accessed from a static method.
  Try removing the reference to the instance member, or .removing the keyword 'static' from the method.
CompileTimeErrorCode.INSTANTIATE_ENUM
  Enums can't be instantiated.
  Try using one of the defined constants.
CompileTimeErrorCode.INTEGER_LITERAL_OUT_OF_RANGE
  The integer literal {0} can't be represented in 64 bits.
  Try using the BigInt class if you need an integer larger than 9,223,372,036,854,775,807 or less than -9,223,372,036,854,775,808.
CompileTimeErrorCode.INTEGER_LITERAL_IMPRECISE_AS_DOUBLE
  The integer literal is being used as a double, but can't be represented as a 64 bit double without overflow and/or loss of precision: {0}
  Try using the BigInt class, or switch to the closest valid double: {1}
CompileTimeErrorCode.INVALID_ANNOTATION
  Annotation must be either a const variable reference or const constructor invocation.
  null
CompileTimeErrorCode.INVALID_ANNOTATION_FROM_DEFERRED_LIBRARY
  Constant values from a deferred library can't be used as annotations.
  Try removing the annotation, or changing the import to not be deferred.
CompileTimeErrorCode.INVALID_ANNOTATION_GETTER
  Getters can't be used as annotations.
  Try using a top-level variable or a field.
CompileTimeErrorCode.INVALID_CONSTANT
  Invalid constant value.
  null
CompileTimeErrorCode.INVALID_CONSTRUCTOR_NAME
  Invalid constructor name.
  null
CompileTimeErrorCode.INVALID_FACTORY_NAME_NOT_A_CLASS
  The name of a factory constructor must be the same as the name of the immediately enclosing class.
  null
CompileTimeErrorCode.INVALID_MODIFIER_ON_CONSTRUCTOR
  The modifier '{0}' can't be applied to the body of a constructor.
  Try removing the modifier.
CompileTimeErrorCode.INVALID_MODIFIER_ON_SETTER
  The modifier '{0}' can't be applied to the body of a setter.
  Try removing the modifier.
CompileTimeErrorCode.INVALID_INLINE_FUNCTION_TYPE
  Inline function types can't be used for parameters in a generic function type.
  Try using a generic function type (returnType 'Function(' parameters ')').
CompileTimeErrorCode.INVALID_OVERRIDE
  '{1}.{0}' ('{2}') isn't a valid override of '{3}.{0}' ('{4}').
  null
CompileTimeErrorCode.INVALID_REFERENCE_TO_THIS
  Invalid reference to 'this' expression.
  null
CompileTimeErrorCode.INVALID_TYPE_ARGUMENT_IN_CONST_LIST
  Constant list literals can't include a type parameter as a type argument, such as '{0}'.
  Try replacing the type parameter with a different type.
CompileTimeErrorCode.INVALID_TYPE_ARGUMENT_IN_CONST_MAP
  Constant map literals can't include a type parameter as a type argument, such as '{0}'.
  Try replacing the type parameter with a different type.
CompileTimeErrorCode.INVALID_TYPE_ARGUMENT_IN_CONST_SET
  Constant set literals can't include a type parameter as a type argument, such as '{0}'.
  Try replacing the type parameter with a different type.
CompileTimeErrorCode.INVALID_URI
  Invalid URI syntax: '{0}'.
  null
CompileTimeErrorCode.INVALID_USE_OF_COVARIANT
  The 'covariant' keyword can only be used for parameters in instance methods or before non-final instance fields.
  Try removing the 'covariant' keyword.
CompileTimeErrorCode.LABEL_IN_OUTER_SCOPE
  Can't reference label '{0}' declared in an outer method.
  null
CompileTimeErrorCode.LABEL_UNDEFINED
  Can't reference undefined label '{0}'.
  Try defining the label, or correcting the name to match an existing label.

CompileTimeErrorCode.MEMBER_WITH_CLASS_NAME
  Class members can't have the same name as the enclosing class.
  null
CompileTimeErrorCode.MISSING_CONST_IN_LIST_LITERAL
  List literals must be prefixed with 'const' when used as a constant expression.
  Try adding the keyword 'const' before the literal.
CompileTimeErrorCode.MISSING_CONST_IN_MAP_LITERAL
  Map literals must be prefixed with 'const' when used as a constant expression.
  Try adding the keyword 'const' before the literal.
CompileTimeErrorCode.MISSING_CONST_IN_SET_LITERAL
  Set literals must be prefixed with 'const' when used as a constant expression.
  Try adding the keyword 'const' before the literal.
CompileTimeErrorCode.MISSING_DART_LIBRARY
  Required library '{0}' is missing.
  Check your Dart SDK installation for completeness.
CompileTimeErrorCode.MIXIN_APPLICATION_CONCRETE_SUPER_INVOKED_MEMBER_TYPE
  The super-invoked member '{0}' has the type '{1}', but the concrete member in the class has type '{2}'.
  null
CompileTimeErrorCode.MIXIN_APPLICATION_NOT_IMPLEMENTED_INTERFACE
  The class doesn't implement the required class '{0}'.
  Try extending the class '{0}'.
CompileTimeErrorCode.MIXIN_APPLICATION_NO_CONCRETE_SUPER_INVOKED_MEMBER
  The class doesn't have a concrete implementation of the super-invoked member '{0}'.
  null
CompileTimeErrorCode.MIXIN_CLASS_DECLARES_CONSTRUCTOR
  The class '{0}' can't be used as a mixin because it declares a constructor.
  null
CompileTimeErrorCode.MIXIN_DECLARES_CONSTRUCTOR
  Mixins can't declare constructors.
  null
CompileTimeErrorCode.MIXIN_DEFERRED_CLASS
  Classes can't mixin deferred classes.
  Try changing the import to not be deferred.
CompileTimeErrorCode.MIXIN_INFERENCE_INCONSISTENT_MATCHING_CLASSES
  Type parameters could not be inferred for the mixin '{0}' because the base class implements the mixin's supertype constraint '{1}' in multiple conflicting ways
  null
CompileTimeErrorCode.MIXIN_INFERENCE_NO_MATCHING_CLASS
  Type parameters could not be inferred for the mixin '{0}' because the base class doesn't implement the mixin's supertype constraint '{1}'
  null
CompileTimeErrorCode.MIXIN_INFERENCE_NO_POSSIBLE_SUBSTITUTION
  Type parameters could not be inferred for the mixin '{0}' because no type parameter substitution could be found matching the mixin's supertype constraints
  null
CompileTimeErrorCode.MIXIN_INHERITS_FROM_NOT_OBJECT
  The class '{0}' can't be used as a mixin because it extends a class other than Object.
  null
CompileTimeErrorCode.MIXIN_INSTANTIATE
  Mixins can't be instantiated.
  null
CompileTimeErrorCode.MIXIN_OF_DISALLOWED_CLASS
  Classes can't mixin '{0}'.
  null
CompileTimeErrorCode.MIXIN_OF_NON_CLASS
  Classes can only mixin other classes.
  null
CompileTimeErrorCode.MIXIN_REFERENCES_SUPER
  The class '{0}' can't be used as a mixin because it references 'super'.
  null
CompileTimeErrorCode.MIXIN_SUPER_CLASS_CONSTRAINT_DEFERRED_CLASS
  Deferred classes can't be used as super-class constraints.
  Try changing the import to not be deferred.
CompileTimeErrorCode.MIXIN_SUPER_CLASS_CONSTRAINT_DISALLOWED_CLASS
  '{0}' can't be used as a super-class constraint.
  null
CompileTimeErrorCode.MIXIN_SUPER_CLASS_CONSTRAINT_NON_INTERFACE
  Only classes and mixins can be used as super-class constraints.
  null
CompileTimeErrorCode.MIXIN_WITH_NON_CLASS_SUPERCLASS
  Mixin can only be applied to class.
  null
CompileTimeErrorCode.MULTIPLE_REDIRECTING_CONSTRUCTOR_INVOCATIONS
  Constructors can have at most one 'this' redirection.
  Try removing all but one of the redirections.
CompileTimeErrorCode.MULTIPLE_SUPER_INITIALIZERS
  Constructor may have at most one 'super' initializer.
  Try removing all but one of the 'super' initializers.
CompileTimeErrorCode.NON_CONSTANT_ANNOTATION_CONSTRUCTOR
  Annotation creation can only call a const constructor.
  null
CompileTimeErrorCode.NON_CONSTANT_CASE_EXPRESSION
  Case expressions must be constant.
  null
CompileTimeErrorCode.NON_CONSTANT_CASE_EXPRESSION_FROM_DEFERRED_LIBRARY
  Constant values from a deferred library can't be used as a case expression.
  Try re-writing the switch as a series of if statements, or changing the import to not be deferred.
CompileTimeErrorCode.NON_CONSTANT_DEFAULT_VALUE
  Default values of an optional parameter must be constant.
  null
CompileTimeErrorCode.NON_CONSTANT_DEFAULT_VALUE_FROM_DEFERRED_LIBRARY
  Constant values from a deferred library can't be used as a default parameter value.
  Try leaving the default as null and initializing the parameter inside the function body.
CompileTimeErrorCode.NON_CONSTANT_LIST_ELEMENT
  The values in a const list literal must be constants.
  Try removing the keyword 'const' from the list literal.
CompileTimeErrorCode.NON_CONSTANT_LIST_ELEMENT_FROM_DEFERRED_LIBRARY
  Constant values from a deferred library can't be used as values in a 'const' list.
  Try removing the keyword 'const' from the list literal.
CompileTimeErrorCode.NON_CONSTANT_MAP_KEY
  The keys in a const map literal must be constant.
  Try removing the keyword 'const' from the map literal.
CompileTimeErrorCode.NON_CONSTANT_MAP_KEY_FROM_DEFERRED_LIBRARY
  Constant values from a deferred library can't be used as keys in a const map literal.
  Try removing the keyword 'const' from the map literal.
CompileTimeErrorCode.NON_CONSTANT_MAP_VALUE
  The values in a const map literal must be constant.
  Try removing the keyword 'const' from the map literal.

CompileTimeErrorCode.NON_CONSTANT_MAP_VALUE_FROM_DEFERRED_LIBRARY
  Constant values from a deferred library can't be used as values in a const map literal.
  Try removing the keyword 'const' from the map literal.
CompileTimeErrorCode.NON_CONSTANT_SET_ELEMENT
  The values in a const set literal must be constants.
  Try removing the keyword 'const' from the set literal.
CompileTimeErrorCode.NON_CONSTANT_SET_ELEMENT_FROM_DEFERRED_LIBRARY
  Constant values from a deferred library can't be used as values in a 'const' set.
  Try removing the keyword 'const' from the set literal.

CompileTimeErrorCode.NON_CONSTANT_VALUE_IN_INITIALIZER
  Initializer expressions in constant constructors must be constants.
  null
CompileTimeErrorCode.NON_CONST_MAP_AS_EXPRESSION_STATEMENT
  A non-constant map or set literal without type arguments can't be used as an expression statement.
  null
CompileTimeErrorCode.NON_GENERATIVE_CONSTRUCTOR
  The generative constructor '{0}' expected, but factory found.
  Try calling a different constructor in the superclass, or making the called constructor not be a factory constructor.
CompileTimeErrorCode.NON_SYNC_FACTORY
  Factory bodies can't use 'async', 'async*', or 'sync*'.
  null
CompileTimeErrorCode.NOT_ENOUGH_REQUIRED_ARGUMENTS
  {0} required argument(s) expected, but {1} found.
  Try adding the missing arguments.

CompileTimeErrorCode.NO_ANNOTATION_CONSTRUCTOR_ARGUMENTS
  Annotation creation must have arguments.
  Try adding an empty argument list.
CompileTimeErrorCode.NO_DEFAULT_SUPER_CONSTRUCTOR_EXPLICIT
  The superclass '{0}' doesn't have a zero argument constructor.
  Try declaring a zero argument constructor in '{0}', or explicitly invoking a different constructor in '{0}'.
CompileTimeErrorCode.NO_DEFAULT_SUPER_CONSTRUCTOR_IMPLICIT
  The superclass '{0}' doesn't have a zero argument constructor.
  Try declaring a zero argument constructor in '{0}', or declaring a constructor in {1} that explicitly invokes a constructor in '{0}'.

CompileTimeErrorCode.OBJECT_CANNOT_EXTEND_ANOTHER_CLASS
  The class 'Object' can't extend any other class.
  null
CompileTimeErrorCode.ON_REPEATED
  '{0}' can only be used in super-class constraints only once.
  Try removing all but one occurrence of the class name.
CompileTimeErrorCode.OPTIONAL_PARAMETER_IN_OPERATOR
  Optional parameters aren't allowed when defining an operator.
  Try removing the optional parameters.
CompileTimeErrorCode.PART_OF_NON_PART
  The included part '{0}' must have a part-of directive.
  Try adding a part-of directive to '{0}'.
CompileTimeErrorCode.PREFIX_COLLIDES_WITH_TOP_LEVEL_MEMBER
  The name '{0}' is already used as an import prefix and can't be used to name a top-level element.
  Try renaming either the top-level element or the prefix.
CompileTimeErrorCode.PREFIX_IDENTIFIER_NOT_FOLLOWED_BY_DOT
  The name '{0}' refers to an import prefix, so it must be followed by '.'.
  Try correcting the name to refer to something other than a prefix, or renaming the prefix.
CompileTimeErrorCode.PRIVATE_COLLISION_IN_MIXIN_APPLICATION
  The private name '{0}', defined by '{1}', conflicts with the same name defined by '{2}'.
  Try removing '{1}' from the 'with' clause.
CompileTimeErrorCode.PRIVATE_OPTIONAL_PARAMETER
  Named optional parameters can't start with an underscore.
  null
CompileTimeErrorCode.RECURSIVE_COMPILE_TIME_CONSTANT
  Compile-time constant expression depends on itself.
  null
CompileTimeErrorCode.RECURSIVE_CONSTRUCTOR_REDIRECT
  Cycle in redirecting generative constructors.
  null
CompileTimeErrorCode.RECURSIVE_FACTORY_REDIRECT
  Cycle in redirecting factory constructors.
  null
CompileTimeErrorCode.RECURSIVE_INTERFACE_INHERITANCE
  '{0}' can't be a superinterface of itself: {1}.
  null
CompileTimeErrorCode.RECURSIVE_INTERFACE_INHERITANCE_EXTENDS
  '{0}' can't extend itself.
  null
CompileTimeErrorCode.RECURSIVE_INTERFACE_INHERITANCE_IMPLEMENTS
  '{0}' can't implement itself.
  null
CompileTimeErrorCode.RECURSIVE_INTERFACE_INHERITANCE_ON
  '{0}' can't use itself as a superclass constraint.
  null
CompileTimeErrorCode.RECURSIVE_INTERFACE_INHERITANCE_WITH
  '{0}' can't use itself as a mixin.
  null
CompileTimeErrorCode.REDIRECT_GENERATIVE_TO_MISSING_CONSTRUCTOR
  The constructor '{0}' couldn't be found in '{1}'.
  Try redirecting to a different constructor, or defining the constructor named '{0}'.
CompileTimeErrorCode.REDIRECT_GENERATIVE_TO_NON_GENERATIVE_CONSTRUCTOR
  Generative constructor can't redirect to a factory constructor.
  Try redirecting to a different constructor.
CompileTimeErrorCode.REDIRECT_TO_MISSING_CONSTRUCTOR
  The constructor '{0}' couldn't be found in '{1}'.
  Try redirecting to a different constructor, or define the constructor named '{0}'.
CompileTimeErrorCode.REDIRECT_TO_NON_CLASS
  The name '{0}' isn't a type and can't be used in a redirected constructor.
  Try redirecting to a different constructor.
CompileTimeErrorCode.REDIRECT_TO_NON_CONST_CONSTRUCTOR
  Constant factory constructor can't delegate to a non-constant constructor.
  Try redirecting to a different constructor.
CompileTimeErrorCode.REFERENCED_BEFORE_DECLARATION
  Local variable '{0}' can't be referenced before it's declared.
  Try moving the declaration to before the first use, or renaming the local variable so that it doesn't hide a name from an enclosing scope.
CompileTimeErrorCode.RETHROW_OUTSIDE_CATCH
  Rethrow must be inside of catch clause.
  Try moving the expression into a catch clause, or using a 'throw' expression.
CompileTimeErrorCode.RETURN_IN_GENERATIVE_CONSTRUCTOR
  Constructors can't return values.
  Try removing the return statement or using a factory constructor.
CompileTimeErrorCode.RETURN_IN_GENERATOR
  Can't return a value from a generator function (using the '{0}' modifier).
  Try removing the value, replacing 'return' with 'yield' or changing the method body modifier.
CompileTimeErrorCode.SHARED_DEFERRED_PREFIX
  The prefix of a deferred import can't be used in other import directives.
  Try renaming one of the prefixes.
CompileTimeErrorCode.SUPER_INITIALIZER_IN_OBJECT
  The class 'Object' can't invoke a constructor from a superclass.
  null
CompileTimeErrorCode.SUPER_IN_INVALID_CONTEXT
  Invalid context for 'super' invocation.
  null
CompileTimeErrorCode.SUPER_IN_REDIRECTING_CONSTRUCTOR
  The redirecting constructor can't have a 'super' initializer.
  null
CompileTimeErrorCode.TYPE_ALIAS_CANNOT_REFERENCE_ITSELF
  Typedefs can't reference themselves directly or recursively via another typedef.
  null
CompileTimeErrorCode.TYPE_ARGUMENT_NOT_MATCHING_BOUNDS
  '{0}' doesn't extend '{1}'.
  Try using a type that is or is a subclass of '{1}'.
CompileTimeErrorCode.TYPE_PARAMETER_ON_CONSTRUCTOR
  Constructors can't have type parameters.
  Try removing the type parameters.
CompileTimeErrorCode.UNDEFINED_ANNOTATION
  Undefined name '{0}' used as an annotation.
  Try defining the name or importing it from another library.
CompileTimeErrorCode.UNDEFINED_CLASS
  Undefined class '{0}'.
  Try defining the class.
CompileTimeErrorCode.UNDEFINED_CONSTRUCTOR_IN_INITIALIZER
  The class '{0}' doesn't have a constructor named '{1}'.
  Try defining a constructor named '{1}' in '{0}', or invoking a different constructor.
CompileTimeErrorCode.UNDEFINED_CONSTRUCTOR_IN_INITIALIZER_DEFAULT
  The class '{0}' doesn't have an unnamed constructor.
  Try defining an unnamed constructor in '{0}', or invoking a different constructor.
CompileTimeErrorCode.UNDEFINED_NAMED_PARAMETER
  The named parameter '{0}' isn't defined.
  Try correcting the name to an existing named parameter's name, or defining a named parameter with the name '{0}'.
CompileTimeErrorCode.URI_DOES_NOT_EXIST
  Target of URI doesn't exist: '{0}'.
  Try creating the file referenced by the URI, or Try using a URI for a file that does exist.
CompileTimeErrorCode.URI_HAS_NOT_BEEN_GENERATED
  Target of URI hasn't been generated: '{0}'.
  Try running the generator that will generate the file referenced by the URI.
CompileTimeErrorCode.URI_WITH_INTERPOLATION
  URIs can't use string interpolation.
  null
CompileTimeErrorCode.WRONG_NUMBER_OF_PARAMETERS_FOR_OPERATOR
  Operator '{0}' should declare exactly {1} parameter(s), but {2} found.
  null
CompileTimeErrorCode.WRONG_NUMBER_OF_PARAMETERS_FOR_OPERATOR_MINUS
  Operator '-' should declare 0 or 1 parameter, but {0} found.
  null
CompileTimeErrorCode.WRONG_NUMBER_OF_PARAMETERS_FOR_SETTER
  Setters should declare exactly one required parameter.
  null
CompileTimeErrorCode.YIELD_EACH_IN_NON_GENERATOR
  Yield-each statements must be in a generator function (one marked with either 'async*' or 'sync*').
  Try adding 'async*' or 'sync*' to the enclosing function.
CompileTimeErrorCode.YIELD_IN_NON_GENERATOR
  Yield statements must be in a generator function (one marked with either 'async*' or 'sync*').
  Try adding 'async*' or 'sync*' to the enclosing function.
HintCode.CAN_BE_NULL_AFTER_NULL_AWARE
  The target expression uses '?.', so its value can be null.
  Replace the '.' with a '?.' in the invocation.
HintCode.DEAD_CODE
  Dead code.
  Try removing the code, or fixing the code before it so that it can be reached.
HintCode.DEAD_CODE_CATCH_FOLLOWING_CATCH
  Dead code: catch clauses after a 'catch (e)' or an 'on Object catch (e)' are never reached.
  Try reordering the catch clauses so that they can be reached, or removing the unreachable catch clauses.
HintCode.DEAD_CODE_ON_CATCH_SUBTYPE
  Dead code: this on-catch block will never be executed because '{0}' is a subtype of '{1}' and hence will have been caught above.
  Try reordering the catch clauses so that this block can be reached, or removing the unreachable catch clause.
HintCode.DEPRECATED_EXTENDS_FUNCTION
  Extending 'Function' is deprecated.
  Try removing 'Function' from the 'extends' clause.

HintCode.DEPRECATED_MIXIN_FUNCTION
  Mixing in 'Function' is deprecated.
  Try removing 'Function' from the 'with' clause.
HintCode.DIVISION_OPTIMIZATION
  The operator x ~/ y is more efficient than (x / y).toInt().
  Try re-writing the expression to use the '~/' operator.
HintCode.DUPLICATE_IMPORT
  Duplicate import.
  Try removing all but one import of the library.
HintCode.DUPLICATE_HIDDEN_NAME
  Duplicate hidden name.
  Try removing the repeated name from the list of hidden members.
HintCode.DUPLICATE_SHOWN_NAME
  Duplicate shown name.
  Try removing the repeated name from the list of shown members.
HintCode.FILE_IMPORT_INSIDE_LIB_REFERENCES_FILE_OUTSIDE
  A file in the 'lib' directory shouldn't import a file outside the 'lib' directory.
  Try removing the import, or moving the imported file inside the 'lib' directory.
HintCode.FILE_IMPORT_OUTSIDE_LIB_REFERENCES_FILE_INSIDE
  A file outside the 'lib' directory shouldn't reference a file inside the 'lib' directory using a relative path.
  Try using a package: URI instead.
HintCode.IMPORT_DEFERRED_LIBRARY_WITH_LOAD_FUNCTION
  The library '{0}' defines a top-level function named 'loadLibrary' which is hidden by deferring this library.
  Try changing the import to not be deferred, or rename the function in the imported library.

HintCode.INVALID_FACTORY_ANNOTATION
  Only methods can be annotated as factories.
  null
HintCode.INVALID_FACTORY_METHOD_DECL
  Factory method '{0}' must have a return type.
  null
HintCode.INVALID_FACTORY_METHOD_IMPL
  Factory method '{0}' doesn't return a newly allocated object.
  null
HintCode.INVALID_IMMUTABLE_ANNOTATION
  Only classes can be annotated as being immutable.
  null

HintCode.INVALID_REQUIRED_PARAM
  The type parameter '{0}' is annotated with @required but only named parameters without default value can be annotated with it.
  Remove @required.
HintCode.INVALID_SEALED_ANNOTATION
  The member '{0}' is annotated with '@sealed' but only classes can be annotated with it.
  Remove @sealed.
HintCode.INVALID_USE_OF_PROTECTED_MEMBER
  The member '{0}' can only be used within instance members of subclasses of '{1}'.
  null
HintCode.INVALID_USE_OF_VISIBLE_FOR_TEMPLATE_MEMBER
  The member '{0}' can only be used within '{1}' or a template library.
  null
HintCode.INVALID_USE_OF_VISIBLE_FOR_TESTING_MEMBER
  The member '{0}' can only be used within '{1}' or a test.
  null

HintCode.IS_DOUBLE
  When compiled to JS, this test might return true when the left hand side is an int.
  Try testing for 'num' instead.
HintCode.IS_INT
  When compiled to JS, this test might return true when the left hand side is a double.
  Try testing for 'num' instead.
HintCode.IS_NOT_DOUBLE
  When compiled to JS, this test might return false when the left hand side is an int.
  Try testing for 'num' instead.
HintCode.IS_NOT_INT
  When compiled to JS, this test might return false when the left hand side is a double.
  Try testing for 'num' instead.
HintCode.MISSING_JS_LIB_ANNOTATION
  The @JS() annotation can only be used if it's also declared on the library directive.
  Try adding the annotation to the library directive.
HintCode.MISSING_REQUIRED_PARAM
  The parameter '{0}' is required.
  null
HintCode.MISSING_REQUIRED_PARAM_WITH_DETAILS
  The parameter '{0}' is required. {1}.
  null
HintCode.MISSING_RETURN
  This function has a return type of '{0}', but doesn't end with a return statement.
  Try adding a return statement, or changing the return type to 'void'.

HintCode.MUST_BE_IMMUTABLE
  This class (or a class which this class inherits from) is marked as '@immutable', but one or more of its instance fields are not final: {0}
  null
HintCode.MUST_CALL_SUPER
  This method overrides a method annotated as @mustCallSuper in '{0}', but doesn't invoke the overridden method.
  null

HintCode.NULL_AWARE_BEFORE_OPERATOR
  The left operand uses '?.', so its value can be null.
  null
HintCode.NULL_AWARE_IN_CONDITION
  The value of the '?.' operator can be 'null', which isn't appropriate in a condition.
  Try replacing the '?.' with a '.', testing the left-hand side for null if necessary.
HintCode.NULL_AWARE_IN_LOGICAL_OPERATOR
  The value of the '?.' operator can be 'null', which isn't appropriate as an operand of a logical operator.
  null
HintCode.OVERRIDE_EQUALS_BUT_NOT_HASH_CODE
  The class '{0}' overrides 'operator==', but not 'get hashCode'.
  Try implementing 'hashCode'.
HintCode.OVERRIDE_ON_NON_OVERRIDING_FIELD
  Field doesn't override an inherited getter or setter.
  Try updating this class to match the superclass, or removing the override annotation.
HintCode.OVERRIDE_ON_NON_OVERRIDING_GETTER
  Getter doesn't override an inherited getter.
  Try updating this class to match the superclass, or removing the override annotation.
HintCode.OVERRIDE_ON_NON_OVERRIDING_METHOD
  Method doesn't override an inherited method.
  Try updating this class to match the superclass, or removing the override annotation.
HintCode.OVERRIDE_ON_NON_OVERRIDING_SETTER
  Setter doesn't override an inherited setter.
  Try updating this class to match the superclass, or removing the override annotation.
HintCode.PACKAGE_IMPORT_CONTAINS_DOT_DOT
  A package import shouldn't contain '..'.
  null

HintCode.TYPE_CHECK_IS_NOT_NULL
  Tests for non-null should be done with '!= null'.
  Try replacing the 'is! Null' check with '!= null'.
HintCode.TYPE_CHECK_IS_NULL
  Tests for null should be done with '== null'.
  Try replacing the 'is Null' check with '== null'.
HintCode.UNDEFINED_HIDDEN_NAME
  The library '{0}' doesn't export a member with the hidden name '{1}'.
  Try removing the name from the list of hidden members.
HintCode.UNDEFINED_SHOWN_NAME
  The library '{0}' doesn't export a member with the shown name '{1}'.
  Try removing the name from the list of shown members.
HintCode.UNNECESSARY_CAST
  Unnecessary cast.
  Try removing the cast.
HintCode.UNNECESSARY_NO_SUCH_METHOD
  Unnecessary 'noSuchMethod' declaration.
  Try removing the declaration of 'noSuchMethod'.

HintCode.UNNECESSARY_TYPE_CHECK_FALSE
  Unnecessary type check, the result is always false.
  Try correcting the type check, or removing the type check.
HintCode.UNNECESSARY_TYPE_CHECK_TRUE
  Unnecessary type check, the result is always true.
  Try correcting the type check, or removing the type check.
HintCode.UNUSED_CATCH_CLAUSE
  The exception variable '{0}' isn't used, so the 'catch' clause can be removed.
  Try removing the catch clause.
HintCode.UNUSED_CATCH_STACK
  The stack trace variable '{0}' isn't used and can be removed.
  Try removing the stack trace variable, or using it.
HintCode.UNUSED_ELEMENT
  The {0} '{1}' isn't used.
  Try removing the declaration of '{1}'.
HintCode.UNUSED_FIELD
  The value of the field '{0}' isn't used.
  Try removing the field, or using it.
HintCode.UNUSED_IMPORT
  Unused import: '{0}'.
  Try removing the import directive.
HintCode.UNUSED_LABEL
  The label '{0}' isn't used.
  Try removing the label, or using it in either a 'break' or 'continue' statement.
HintCode.UNUSED_LOCAL_VARIABLE
  The value of the local variable '{0}' isn't used.
  Try removing the variable, or using it.
HintCode.UNUSED_SHOWN_NAME
  The name {0} is shown, but not used.
  Try removing the name from the list of shown members.
ParserErrorCode.ABSTRACT_CLASS_MEMBER
  Members of classes can't be declared to be 'abstract'.
  Try removing the 'abstract' keyword. You can add the 'abstract' keyword before the class declaration.
ParserErrorCode.ABSTRACT_ENUM
  Enums can't be declared to be 'abstract'.
  Try removing the keyword 'abstract'.
ParserErrorCode.ABSTRACT_STATIC_METHOD
  Static methods can't be declared to be 'abstract'.
  Try removing the keyword 'abstract'.
ParserErrorCode.ABSTRACT_TOP_LEVEL_FUNCTION
  Top-level functions can't be declared to be 'abstract'.
  Try removing the keyword 'abstract'.
ParserErrorCode.ABSTRACT_TOP_LEVEL_VARIABLE
  Top-level variables can't be declared to be 'abstract'.
  Try removing the keyword 'abstract'.
ParserErrorCode.ABSTRACT_TYPEDEF
  Typedefs can't be declared to be 'abstract'.
  Try removing the keyword 'abstract'.
ParserErrorCode.ASYNC_KEYWORD_USED_AS_IDENTIFIER
  The keywords 'async', 'await', and 'yield' can't be used as identifiers in an asynchronous or generator function.
  null
ParserErrorCode.BREAK_OUTSIDE_OF_LOOP
  A break statement can't be used outside of a loop or switch statement.
  Try removing the break statement.
ParserErrorCode.CATCH_SYNTAX
  'catch' must be followed by '(identifier)' or '(identifier, identifier)'.
  No types are needed, the first is given by 'on', the second is always 'StackTrace'.
ParserErrorCode.CATCH_SYNTAX_EXTRA_PARAMETERS
  'catch' must be followed by '(identifier)' or '(identifier, identifier)'.
  No types are needed, the first is given by 'on', the second is always 'StackTrace'.
ParserErrorCode.CLASS_IN_CLASS
  Classes can't be declared inside other classes.
  Try moving the class to the top-level.
ParserErrorCode.COLON_IN_PLACE_OF_IN
  For-in loops use 'in' rather than a colon.
  Try replacing the colon with the keyword 'in'.
ParserErrorCode.CONSTRUCTOR_WITH_RETURN_TYPE
  Constructors can't have a return type.
  Try removing the return type.
ParserErrorCode.CONST_AFTER_FACTORY
  The modifier 'const' should be before the modifier 'factory'.
  Try re-ordering the modifiers.
ParserErrorCode.CONST_AND_COVARIANT
  Members can't be declared to be both 'const' and 'covariant'.
  Try removing either the 'const' or 'covariant' keyword.
ParserErrorCode.CONST_AND_FINAL
  Members can't be declared to be both 'const' and 'final'.
  Try removing either the 'const' or 'final' keyword.
ParserErrorCode.CONST_AND_VAR
  Members can't be declared to be both 'const' and 'var'.
  Try removing either the 'const' or 'var' keyword.
ParserErrorCode.CONST_CLASS
  Classes can't be declared to be 'const'.
  Try removing the 'const' keyword. If you're trying to indicate that instances of the class can be constants, place the 'const' keyword on  the class' constructor(s).
ParserErrorCode.CONST_CONSTRUCTOR_WITH_BODY
  Const constructors can't have a body.
  Try removing either the 'const' keyword or the body.
ParserErrorCode.CONST_ENUM
  Enums can't be declared to be 'const'.
  Try removing the 'const' keyword.
ParserErrorCode.CONST_FACTORY
  Only redirecting factory constructors can be declared to be 'const'.
  Try removing the 'const' keyword, or replacing the body with '=' followed by a valid target.
ParserErrorCode.CONST_METHOD
  Getters, setters and methods can't be declared to be 'const'.
  Try removing the 'const' keyword.
ParserErrorCode.CONST_TYPEDEF
  Type aliases can't be declared to be 'const'.
  Try removing the 'const' keyword.
ParserErrorCode.CONTINUE_OUTSIDE_OF_LOOP
  A continue statement can't be used outside of a loop or switch statement.
  Try removing the continue statement.
ParserErrorCode.CONTINUE_WITHOUT_LABEL_IN_CASE
  A continue statement in a switch statement must have a label as a target.
  Try adding a label associated with one of the case clauses to the continue statement.
ParserErrorCode.COVARIANT_AFTER_FINAL
  The modifier 'covariant' should be before the modifier 'final'.
  Try re-ordering the modifiers.
ParserErrorCode.COVARIANT_AFTER_VAR
  The modifier 'covariant' should be before the modifier 'var'.
  Try re-ordering the modifiers.
ParserErrorCode.COVARIANT_AND_STATIC
  Members can't be declared to be both 'covariant' and 'static'.
  Try removing either the 'covariant' or 'static' keyword.
ParserErrorCode.COVARIANT_CONSTRUCTOR
  A constructor can't be declared to be 'covariant'.
  Try removing the keyword 'covariant'.
ParserErrorCode.COVARIANT_MEMBER
  Getters, setters and methods can't be declared to be 'covariant'.
  Try removing the 'covariant' keyword.
ParserErrorCode.COVARIANT_TOP_LEVEL_DECLARATION
  Top-level declarations can't be declared to be covariant.
  Try removing the keyword 'covariant'.
ParserErrorCode.DEFERRED_AFTER_PREFIX
  The deferred keyword should come immediately before the prefix ('as' clause).
  Try moving the deferred keyword before the prefix.
ParserErrorCode.DEFAULT_VALUE_IN_FUNCTION_TYPE
  Parameters in a function type can't have default values
  Try removing the default value.
ParserErrorCode.DIRECTIVE_AFTER_DECLARATION
  Directives must appear before any declarations.
  Try moving the directive before any declarations.
ParserErrorCode.DUPLICATE_DEFERRED
  An import directive can only have one 'deferred' keyword.
  Try removing all but one 'deferred' keyword.
ParserErrorCode.DUPLICATED_MODIFIER
  The modifier '#lexeme' was already specified.
  Try removing all but one occurence of the modifier.
ParserErrorCode.DUPLICATE_LABEL_IN_SWITCH_STATEMENT
  The label '#name' was already used in this switch statement.
  Try choosing a different name for this label.
ParserErrorCode.DUPLICATE_PREFIX
  An import directive can only have one prefix ('as' clause).
  Try removing all but one prefix.
ParserErrorCode.EMPTY_ENUM_BODY
  An enum must declare at least one constant name.
  Try declaring a constant.
ParserErrorCode.ENUM_IN_CLASS
  Enums can't be declared inside classes.
  Try moving the enum to the top-level.
ParserErrorCode.EQUALITY_CANNOT_BE_EQUALITY_OPERAND
  An equality expression can't be an operand of another equality expression.
  Try re-writing the expression.
ParserErrorCode.EXPECTED_CASE_OR_DEFAULT
  Expected 'case' or 'default'.
  Try placing this code inside a case clause.
ParserErrorCode.EXPECTED_CLASS_MEMBER
  Expected a class member.
  Try placing this code inside a class member.

ParserErrorCode.EXPECTED_ELSE_OR_COMMA ***
  Expected 'else' or comma.
  null

ParserErrorCode.EXPECTED_EXECUTABLE
  Expected a method, getter, setter or operator declaration.
  This appears to be incomplete code. Try removing it or completing it.
ParserErrorCode.EXPECTED_INSTEAD
  Expected '#string' instead of this.
  null
ParserErrorCode.EXPECTED_LIST_OR_MAP_LITERAL
  Expected a list or map literal.
  Try inserting a list or map literal, or remove the type arguments.
ParserErrorCode.EXPECTED_STRING_LITERAL
  Expected a string literal.
  null
ParserErrorCode.EXPECTED_TOKEN
  Expected to find '{0}'.
  null
ParserErrorCode.EXPECTED_TYPE_NAME
  Expected a type name.
  null

ParserErrorCode.EXPERIMENT_NOT_ENABLED ***
  This requires the --#string experiment to be enabled.
  Try enabling this experiment by adding it to the command line when compiling and running.

ParserErrorCode.EXPORT_DIRECTIVE_AFTER_PART_DIRECTIVE
  Export directives must precede part directives.
  Try moving the export directives before the part directives.
ParserErrorCode.EXTERNAL_AFTER_CONST
  The modifier 'external' should be before the modifier 'const'.
  Try re-ordering the modifiers.
ParserErrorCode.EXTERNAL_AFTER_FACTORY
  The modifier 'external' should be before the modifier 'factory'.
  Try re-ordering the modifiers.
ParserErrorCode.EXTERNAL_AFTER_STATIC
  The modifier 'external' should be before the modifier 'static'.
  Try re-ordering the modifiers.
ParserErrorCode.EXTERNAL_CLASS
  Classes can't be declared to be 'external'.
  Try removing the keyword 'external'.
ParserErrorCode.EXTERNAL_CONSTRUCTOR_WITH_BODY
  External constructors can't have a body.
  Try removing the body of the constructor, or removing the keyword 'external'.
ParserErrorCode.EXTERNAL_ENUM
  Enums can't be declared to be 'external'.
  Try removing the keyword 'external'.
ParserErrorCode.EXTERNAL_FACTORY_REDIRECTION
  A redirecting factory can't be external.
  Try removing the 'external' modifier.
ParserErrorCode.EXTERNAL_FACTORY_WITH_BODY
  External factories can't have a body.
  Try removing the body of the factory, or removing the keyword 'external'.
ParserErrorCode.EXTERNAL_FIELD
  Fields can't be declared to be 'external'.
  Try removing the keyword 'external'.
ParserErrorCode.EXTERNAL_GETTER_WITH_BODY
  External getters can't have a body.
  Try removing the body of the getter, or removing the keyword 'external'.
ParserErrorCode.EXTERNAL_METHOD_WITH_BODY
  An external or native method can't have a body.
  null
ParserErrorCode.EXTERNAL_OPERATOR_WITH_BODY
  External operators can't have a body.
  Try removing the body of the operator, or removing the keyword 'external'.
ParserErrorCode.EXTERNAL_SETTER_WITH_BODY
  External setters can't have a body.
  Try removing the body of the setter, or removing the keyword 'external'.
ParserErrorCode.EXTERNAL_TYPEDEF
  Typedefs can't be declared to be 'external'.
  Try removing the keyword 'external'.
ParserErrorCode.EXTRANEOUS_MODIFIER
  Can't have modifier '#lexeme' here.
  Try removing '#lexeme'.
ParserErrorCode.FACTORY_TOP_LEVEL_DECLARATION
  Top-level declarations can't be declared to be 'factory'.
  Try removing the keyword 'factory'.
ParserErrorCode.FACTORY_WITHOUT_BODY
  A non-redirecting 'factory' constructor must have a body.
  Try adding a body to the constructor.
ParserErrorCode.FACTORY_WITH_INITIALIZERS
  A 'factory' constructor can't have initializers.
  Try removing the 'factory' keyword to make this a generative constructor, or removing the initializers.
ParserErrorCode.FIELD_INITIALIZER_OUTSIDE_CONSTRUCTOR
  Field formal parameters can only be used in a constructor.
  Try removing 'this.'.
ParserErrorCode.FIELD_INITIALIZED_OUTSIDE_DECLARING_CLASS
  A field can only be initialized in it's declaring class
  Try passing a value into the superclass constructor, or moving the initialization into the constructor body.
ParserErrorCode.FINAL_AND_COVARIANT
  Members can't be declared to be both 'final' and 'covariant'.
  Try removing either the 'final' or 'covariant' keyword.
ParserErrorCode.FINAL_AND_VAR
  Members can't be declared to be both 'final' and 'var'.
  Try removing the keyword 'var'.
ParserErrorCode.FINAL_CLASS
  Classes can't be declared to be 'final'.
  Try removing the keyword 'final'.
ParserErrorCode.FINAL_CONSTRUCTOR
  A constructor can't be declared to be 'final'.
  Try removing the keyword 'final'.
ParserErrorCode.FINAL_ENUM
  Enums can't be declared to be 'final'.
  Try removing the keyword 'final'.
ParserErrorCode.FINAL_METHOD
  Getters, setters and methods can't be declared to be 'final'.
  Try removing the keyword 'final'.
ParserErrorCode.FINAL_TYPEDEF
  Typedefs can't be declared to be 'final'.
  Try removing the keyword 'final'.
ParserErrorCode.FUNCTION_TYPED_PARAMETER_VAR
  Function-typed parameters can't specify 'const', 'final' or 'var' in place of a return type.
  Try replacing the keyword with a return type.
ParserErrorCode.GETTER_IN_FUNCTION
  Getters can't be defined within methods or functions.
  Try moving the getter outside the method or function, or converting the getter to a function.
ParserErrorCode.GETTER_WITH_PARAMETERS
  Getters must be declared without a parameter list.
  Try removing the parameter list, or removing the keyword 'get' to define a method rather than a getter.
ParserErrorCode.ILLEGAL_ASSIGNMENT_TO_NON_ASSIGNABLE
  Illegal assignment to non-assignable expression.
  null
ParserErrorCode.IMPLEMENTS_BEFORE_EXTENDS
  The extends clause must be before the implements clause.
  Try moving the extends clause before the implements clause.
ParserErrorCode.IMPLEMENTS_BEFORE_ON
  The on clause must be before the implements clause.
  Try moving the on clause before the implements clause.
ParserErrorCode.IMPLEMENTS_BEFORE_WITH
  The with clause must be before the implements clause.
  Try moving the with clause before the implements clause.
ParserErrorCode.IMPORT_DIRECTIVE_AFTER_PART_DIRECTIVE
  Import directives must precede part directives.
  Try moving the import directives before the part directives.
ParserErrorCode.INITIALIZED_VARIABLE_IN_FOR_EACH
  The loop variable in a for-each loop can't be initialized.
  Try removing the initializer, or using a different kind of loop.
ParserErrorCode.INVALID_AWAIT_IN_FOR
  The keyword 'await' isn't allowed for a normal 'for' statement.
  Try removing the keyword, or use a for-each statement.
ParserErrorCode.INVALID_CODE_POINT
  The escape sequence '{0}' isn't a valid code point.
  null
ParserErrorCode.INVALID_COMMENT_REFERENCE
  Comment references should contain a possibly prefixed identifier and can start with 'new', but shouldn't contain anything else.
  null
ParserErrorCode.INVALID_CONSTRUCTOR_NAME
  The keyword '{0}' can't be used to name a constructor.
  Try giving the constructor a different name.
ParserErrorCode.INVALID_GENERIC_FUNCTION_TYPE
  Invalid generic function type.
  Try using a generic function type (returnType 'Function(' parameters ')').
ParserErrorCode.INVALID_HEX_ESCAPE
  An escape sequence starting with '\x' must be followed by 2 hexadecimal digits.
  null
ParserErrorCode.INVALID_LITERAL_IN_CONFIGURATION
  The literal in a configuration can't contain interpolation.
  Try removing the interpolation expressions.
ParserErrorCode.INVALID_OPERATOR
  The string '#lexeme' isn't a user-definable operator.
  null
ParserErrorCode.INVALID_OPERATOR_FOR_SUPER
  The operator '{0}' can't be used with 'super'.
  null
ParserErrorCode.INVALID_OPERATOR_QUESTIONMARK_PERIOD_FOR_SUPER
  The operator '?.' can't be used with 'super' because 'super' can't be null.
  Try replacing '?.' with '.'
ParserErrorCode.INVALID_STAR_AFTER_ASYNC
  The modifier 'async*' isn't allowed for an expression function body.
  Try converting the body to a block.
ParserErrorCode.INVALID_SYNC
  The modifier 'sync' isn't allowed for an expression function body.
  Try converting the body to a block.
ParserErrorCode.INVALID_UNICODE_ESCAPE
  An escape sequence starting with '\u' must be followed by 4 hexadecimal digits or from 1 to 6 digits between '{' and '}'.
  null
ParserErrorCode.LIBRARY_DIRECTIVE_NOT_FIRST
  The library directive must appear before all other directives.
  Try moving the library directive before any other directives.
ParserErrorCode.LOCAL_FUNCTION_DECLARATION_MODIFIER
  Local function declarations can't specify any modifiers.
  Try removing the modifier.
ParserErrorCode.MISSING_ASSIGNABLE_SELECTOR
  Missing selector such as '.<identifier>' or '[0]'.
  Try adding a selector.
ParserErrorCode.MISSING_ASSIGNMENT_IN_INITIALIZER
  Expected an assignment after the field name.
  To initialize a field, use the syntax 'name = value'.
ParserErrorCode.MISSING_CATCH_OR_FINALLY
  A try block must be followed by an 'on', 'catch', or 'finally' clause.
  Try adding either a catch or finally clause, or remove the try statement.
ParserErrorCode.MISSING_CLASS_BODY
  A class or mixin definition must have a body, even if it's empty.
  Try adding a body to your class or mixin.
ParserErrorCode.MISSING_CLOSING_PARENTHESIS
  The closing parenthesis is missing.
  Try adding the closing parenthesis.
ParserErrorCode.MISSING_CONST_FINAL_VAR_OR_TYPE
  Variables must be declared using the keywords 'const', 'final', 'var' or a type name.
  Try adding the name of the type of the variable or the keyword 'var'.
ParserErrorCode.MISSING_ENUM_BODY
  An enum definition must have a body with at least one constant name.
  Try adding a body and defining at least one constant.
ParserErrorCode.MISSING_EXPRESSION_IN_INITIALIZER
  Expected an expression after the assignment operator.
  Try adding the value to be assigned, or remove the assignment operator.
ParserErrorCode.MISSING_EXPRESSION_IN_THROW
  Missing expression after 'throw'.
  Add an expression after 'throw' or use 'rethrow' to throw a caught exception
ParserErrorCode.MISSING_FUNCTION_BODY
  A function body must be provided.
  Try adding a function body.
ParserErrorCode.MISSING_FUNCTION_KEYWORD
  Function types must have the keyword 'Function' before the parameter list.
  Try adding the keyword 'Function'.
ParserErrorCode.MISSING_FUNCTION_PARAMETERS
  Functions must have an explicit list of parameters.
  Try adding a parameter list.
ParserErrorCode.MISSING_GET
  Getters must have the keyword 'get' before the getter name.
  Try adding the keyword 'get'.
ParserErrorCode.MISSING_IDENTIFIER
  Expected an identifier.
  null
ParserErrorCode.MISSING_INITIALIZER
  Expected an initializer.
  null
ParserErrorCode.MISSING_KEYWORD_OPERATOR
  Operator declarations must be preceded by the keyword 'operator'.
  Try adding the keyword 'operator'.
ParserErrorCode.MISSING_METHOD_PARAMETERS
  Methods must have an explicit list of parameters.
  Try adding a parameter list.
ParserErrorCode.MISSING_NAME_FOR_NAMED_PARAMETER
  Named parameters in a function type must have a name
  Try providing a name for the parameter or removing the curly braces.
ParserErrorCode.MISSING_NAME_IN_LIBRARY_DIRECTIVE
  Library directives must include a library name.
  Try adding a library name after the keyword 'library', or remove the library directive if the library doesn't have any parts.
ParserErrorCode.MISSING_NAME_IN_PART_OF_DIRECTIVE
  Part-of directives must include a library name.
  Try adding a library name after the 'of'.
ParserErrorCode.MISSING_PREFIX_IN_DEFERRED_IMPORT
  Deferred imports should have a prefix.
  Try adding a prefix to the import.
ParserErrorCode.MISSING_STAR_AFTER_SYNC
  The modifier 'sync' must be followed by a star ('*').
  Try removing the modifier, or add a star.
ParserErrorCode.MISSING_STATEMENT
  Expected a statement.
  null
ParserErrorCode.MISSING_TERMINATOR_FOR_PARAMETER_GROUP
  There is no '{0}' to close the parameter group.
  Try inserting a '{0}' at the end of the group.
ParserErrorCode.MISSING_TYPEDEF_PARAMETERS
  Typedefs must have an explicit list of parameters.
  Try adding a parameter list.
ParserErrorCode.MISSING_VARIABLE_IN_FOR_EACH
  A loop variable must be declared in a for-each loop before the 'in', but none was found.
  Try declaring a loop variable.
ParserErrorCode.MIXED_PARAMETER_GROUPS
  Can't have both positional and named parameters in a single parameter list.
  Try choosing a single style of optional parameters.
ParserErrorCode.MULTIPLE_EXTENDS_CLAUSES
  Each class definition can have at most one extends clause.
  Try choosing one superclass and define your class to implement (or mix in) the others.
ParserErrorCode.MULTIPLE_ON_CLAUSES
  Each mixin definition can have at most one on clause.
  Try combining all of the on clauses into a single clause.
ParserErrorCode.MULTIPLE_IMPLEMENTS_CLAUSES
  Each class or mixin definition can have at most one implements clause.
  Try combining all of the implements clauses into a single clause.
ParserErrorCode.MULTIPLE_LIBRARY_DIRECTIVES
  Only one library directive may be declared in a file.
  Try removing all but one of the library directives.
ParserErrorCode.MULTIPLE_NAMED_PARAMETER_GROUPS
  Can't have multiple groups of named parameters in a single parameter list.
  Try combining all of the groups into a single group.
ParserErrorCode.MULTIPLE_PART_OF_DIRECTIVES
  Only one part-of directive may be declared in a file.
  Try removing all but one of the part-of directives.
ParserErrorCode.MULTIPLE_POSITIONAL_PARAMETER_GROUPS
  Can't have multiple groups of positional parameters in a single parameter list.
  Try combining all of the groups into a single group.
ParserErrorCode.MULTIPLE_VARIABLES_IN_FOR_EACH
  A single loop variable must be declared in a for-each loop before the 'in', but {0} were found.
  Try moving all but one of the declarations inside the loop body.
ParserErrorCode.MULTIPLE_WITH_CLAUSES
  Each class definition can have at most one with clause.
  Try combining all of the with clauses into a single clause.
ParserErrorCode.NAMED_FUNCTION_EXPRESSION
  Function expressions can't be named.
  Try removing the name, or moving the function expression to a function declaration statement.
ParserErrorCode.NAMED_FUNCTION_TYPE
  Function types can't be named.
  Try replacing the name with the keyword 'Function'.
ParserErrorCode.NAMED_PARAMETER_OUTSIDE_GROUP
  Named parameters must be enclosed in curly braces ('{' and '}').
  Try surrounding the named parameters in curly braces.
ParserErrorCode.NATIVE_CLAUSE_IN_NON_SDK_CODE
  Native clause can only be used in the SDK and code that's loaded through native extensions.
  Try removing the native clause.
ParserErrorCode.NATIVE_CLAUSE_SHOULD_BE_ANNOTATION
  Native clause in this form is deprecated.
  Try removing this native clause and adding @native() or @native('native-name') before the declaration.
ParserErrorCode.NATIVE_FUNCTION_BODY_IN_NON_SDK_CODE
  Native functions can only be declared in the SDK and code that's loaded through native extensions.
  Try removing the word 'native'.
ParserErrorCode.NON_CONSTRUCTOR_FACTORY
  Only a constructor can be declared to be a factory.
  Try removing the keyword 'factory'.
ParserErrorCode.NON_IDENTIFIER_LIBRARY_NAME
  The name of a library must be an identifier.
  Try using an identifier as the name of the library.
ParserErrorCode.NON_PART_OF_DIRECTIVE_IN_PART
  The part-of directive must be the only directive in a part.
  Try removing the other directives, or moving them to the library for which this is a part.
ParserErrorCode.NON_STRING_LITERAL_AS_URI
  The URI must be a string literal.
  Try enclosing the URI in either single or double quotes.
ParserErrorCode.NON_USER_DEFINABLE_OPERATOR
  The operator '{0}' isn't user definable.
  null
ParserErrorCode.NORMAL_BEFORE_OPTIONAL_PARAMETERS
  Normal parameters must occur before optional parameters.
  Try moving all of the normal parameters before the optional parameters.
ParserErrorCode.POSITIONAL_AFTER_NAMED_ARGUMENT
  Positional arguments must occur before named arguments.
  Try moving all of the positional arguments before the named arguments.
ParserErrorCode.POSITIONAL_PARAMETER_OUTSIDE_GROUP
  Positional parameters must be enclosed in square brackets ('[' and ']').
  Try surrounding the positional parameters in square brackets.
ParserErrorCode.PREFIX_AFTER_COMBINATOR
  The prefix ('as' clause) should come before any show/hide combinators.
  Try moving the prefix before the combinators.
ParserErrorCode.REDIRECTING_CONSTRUCTOR_WITH_BODY
  Redirecting constructors can't have a body.
  Try removing the body, or not making this a redirecting constructor.
ParserErrorCode.REDIRECTION_IN_NON_FACTORY_CONSTRUCTOR
  Only factory constructor can specify '=' redirection.
  Try making this a factory constructor, or remove the redirection.
ParserErrorCode.SETTER_IN_FUNCTION
  Setters can't be defined within methods or functions.
  Try moving the setter outside the method or function.
ParserErrorCode.STACK_OVERFLOW
  The file has too many nested expressions or statements.
  Try simplifying the code.
ParserErrorCode.STATIC_AFTER_CONST
  The modifier 'static' should be before the modifier 'const'.
  Try re-ordering the modifiers.
ParserErrorCode.STATIC_AFTER_FINAL
  The modifier 'static' should be before the modifier 'final'.
  Try re-ordering the modifiers.
ParserErrorCode.STATIC_AFTER_VAR
  The modifier 'static' should be before the modifier 'var'.
  Try re-ordering the modifiers.
ParserErrorCode.STATIC_CONSTRUCTOR
  Constructors can't be static.
  Try removing the keyword 'static'.
ParserErrorCode.STATIC_GETTER_WITHOUT_BODY
  A 'static' getter must have a body.
  Try adding a body to the getter, or removing the keyword 'static'.
ParserErrorCode.STATIC_OPERATOR
  Operators can't be static.
  Try removing the keyword 'static'.
ParserErrorCode.STATIC_SETTER_WITHOUT_BODY
  A 'static' setter must have a body.
  Try adding a body to the setter, or removing the keyword 'static'.
ParserErrorCode.STATIC_TOP_LEVEL_DECLARATION
  Top-level declarations can't be declared to be static.
  Try removing the keyword 'static'.

ParserErrorCode.INVALID_SUPER_IN_INITIALIZER ***
  Can only use 'super' in an initializer for calling the superclass constructor (e.g. 'super()' or 'super.namedConstructor()')
  null

ParserErrorCode.SWITCH_HAS_CASE_AFTER_DEFAULT_CASE
  The default case should be the last case in a switch statement.
  Try moving the default case after the other case clauses.
ParserErrorCode.SWITCH_HAS_MULTIPLE_DEFAULT_CASES
  The 'default' case can only be declared once.
  Try removing all but one default case.

ParserErrorCode.INVALID_THIS_IN_INITIALIZER ***
  Can only use 'this' in an initializer for field initialization (e.g. 'this.x = something') and constructor redirection (e.g. 'this()' or 'this.namedConstructor())
  null

ParserErrorCode.TOP_LEVEL_OPERATOR
  Operators must be declared within a class.
  Try removing the operator, moving it to a class, or converting it to be a function.
ParserErrorCode.TYPEDEF_IN_CLASS
  Typedefs can't be declared inside classes.
  Try moving the typedef to the top-level.
ParserErrorCode.TYPE_ARGUMENTS_ON_TYPE_VARIABLE
  Can't use type arguments with type variable '#name'.
  Try removing the type arguments.
ParserErrorCode.UNEXPECTED_TERMINATOR_FOR_PARAMETER_GROUP
  There is no '{0}' to open a parameter group.
  Try inserting the '{0}' at the appropriate location.
ParserErrorCode.UNEXPECTED_TOKEN
  Unexpected text '{0}'.
  Try removing the text.
ParserErrorCode.VAR_AND_TYPE
  Variables can't be declared using both 'var' and a type name.
  Try removing 'var.'
ParserErrorCode.VAR_AS_TYPE_NAME
  The keyword 'var' can't be used as a type name.
  null
ParserErrorCode.VAR_CLASS
  Classes can't be declared to be 'var'.
  Try removing the keyword 'var'.
ParserErrorCode.VAR_ENUM
  Enums can't be declared to be 'var'.
  Try removing the keyword 'var'.
ParserErrorCode.VAR_RETURN_TYPE
  The return type can't be 'var'.
  Try removing the keyword 'var', or replacing it with the name of the return type.
ParserErrorCode.VAR_TYPEDEF
  Typedefs can't be declared to be 'var'.
  Try removing the keyword 'var', or replacing it with the name of the return type.
ParserErrorCode.WITH_BEFORE_EXTENDS
  The extends clause must be before the with clause.
  Try moving the extends clause before the with clause.
ParserErrorCode.WRONG_SEPARATOR_FOR_POSITIONAL_PARAMETER
  The default value of a positional parameter should be preceded by '='.
  Try replacing the ':' with '='.
ParserErrorCode.WRONG_TERMINATOR_FOR_PARAMETER_GROUP
  Expected '{0}' to close parameter group.
  Try replacing '{0}' with '{1}'.
ResolverErrorCode.BREAK_LABEL_ON_SWITCH_MEMBER
  Break label resolves to case or default statement
  null
ResolverErrorCode.CONTINUE_LABEL_ON_SWITCH
  A continue label resolves to switch, must be loop or switch member
  null
ResolverErrorCode.PART_OF_UNNAMED_LIBRARY
  Library is unnamed. Expected a URI not a library name '{0}' in the part-of directive.
  Try changing the part-of directive to a URI, or try including a different part.
ScannerErrorCode.EXPECTED_TOKEN
  Expected to find '{0}'.
  null
ScannerErrorCode.ILLEGAL_CHARACTER
  Illegal character '{0}'.
  null
ScannerErrorCode.MISSING_DIGIT
  Decimal digit expected.
  null
ScannerErrorCode.MISSING_HEX_DIGIT
  Hexadecimal digit expected.
  null
ScannerErrorCode.MISSING_IDENTIFIER
  Expected an identifier.
  null
ScannerErrorCode.MISSING_QUOTE
  Expected quote (' or ").
  null
ScannerErrorCode.UNABLE_GET_CONTENT
  Unable to get content of '{0}'.
  null
ScannerErrorCode.UNEXPECTED_DOLLAR_IN_STRING
  A '$' has special meaning inside a string, and must be followed by an identifier or an expression in curly braces ({}).
  Try adding a backslash (\) to escape the '$'.
ScannerErrorCode.UNSUPPORTED_OPERATOR
  The '{0}' operator isn't supported.
  null
ScannerErrorCode.UNTERMINATED_MULTI_LINE_COMMENT
  Unterminated multi-line comment.
  Try terminating the comment with '*/', or removing any unbalanced occurrences of '/*' (because comments nest in Dart).
ScannerErrorCode.UNTERMINATED_STRING_LITERAL
  Unterminated string literal.
  null
StaticTypeWarningCode.EXPECTED_ONE_LIST_TYPE_ARGUMENTS
  List literals require exactly one type argument or none, but {0} found.
  Try adjusting the number of type arguments.
StaticTypeWarningCode.EXPECTED_ONE_SET_TYPE_ARGUMENTS
  Set literals require exactly one type argument or none, but {0} found.
  Try adjusting the number of type arguments.
StaticTypeWarningCode.EXPECTED_TWO_MAP_TYPE_ARGUMENTS
  Map literals require exactly two type arguments or none, but {0} found.
  Try adjusting the number of type arguments.
StaticTypeWarningCode.FOR_IN_OF_INVALID_ELEMENT_TYPE
  The type '{0}' used in the 'for' loop must implement {1} with a type argument that can be assigned to '{2}'.
  null
StaticTypeWarningCode.FOR_IN_OF_INVALID_TYPE
  The type '{0}' used in the 'for' loop must implement {1}.
  null
StaticTypeWarningCode.ILLEGAL_ASYNC_GENERATOR_RETURN_TYPE
  Functions marked 'async*' must have a return type assignable to 'Stream'.
  Try fixing the return type of the function, or removing the modifier 'async*' from the function body.
StaticTypeWarningCode.ILLEGAL_ASYNC_RETURN_TYPE
  Functions marked 'async' must have a return type assignable to 'Future'.
  Try fixing the return type of the function, or removing the modifier 'async' from the function body.
StaticTypeWarningCode.ILLEGAL_SYNC_GENERATOR_RETURN_TYPE
  Functions marked 'sync*' must have a return type assignable to 'Iterable'.
  Try fixing the return type of the function, or removing the modifier 'sync*' from the function body.
StaticTypeWarningCode.INSTANCE_ACCESS_TO_STATIC_MEMBER
  Static {1} '{0}' can't be accessed through an instance.
  Try using the class '{2}' to access the {1}.
StaticTypeWarningCode.INVALID_ASSIGNMENT
  A value of type '{0}' can't be assigned to a variable of type '{1}'.
  Try changing the type of the variable, or casting the right-hand type to '{1}'.
StaticTypeWarningCode.INVOCATION_OF_NON_FUNCTION
  '{0}' isn't a function.
  Try correcting the name to match an existing function, or define a method or function named '{0}'.
StaticTypeWarningCode.INVOCATION_OF_NON_FUNCTION_EXPRESSION
  The expression doesn't evaluate to a function, so it can't be invoked.
  null
StaticTypeWarningCode.NON_BOOL_CONDITION
  Conditions must have a static type of 'bool'.
  Try changing the condition.
StaticTypeWarningCode.NON_BOOL_EXPRESSION
  The expression in an assert must be of type 'bool'.
  Try changing the expression.
StaticTypeWarningCode.NON_BOOL_NEGATION_EXPRESSION
  Negation argument must have a static type of 'bool'.
  Try changing the argument to the '!' operator.
StaticTypeWarningCode.NON_BOOL_OPERAND
  The operands of the '{0}' operator must be assignable to 'bool'.
  null
StaticTypeWarningCode.NON_TYPE_AS_TYPE_ARGUMENT
  The name '{0}' isn't a type so it can't be used as a type argument.
  Try correcting the name to an existing type, or defining a type named '{0}'.
StaticTypeWarningCode.RETURN_OF_INVALID_TYPE
  The return type '{0}' isn't a '{1}', as defined by the method '{2}'.
  null
StaticTypeWarningCode.RETURN_OF_INVALID_TYPE_FROM_CLOSURE
  The return type '{0}' isn't a '{1}', as defined by anonymous closure.
  null
StaticTypeWarningCode.TYPE_ARGUMENT_NOT_MATCHING_BOUNDS
  '{0}' doesn't extend '{1}'.
  Try using a type that is or is a subclass of '{1}'.
StaticTypeWarningCode.TYPE_PARAMETER_SUPERTYPE_OF_ITS_BOUND
  '{0}' can't be a supertype of its upper bound.
  Try using a type that is or is a subclass of '{1}'.
StaticTypeWarningCode.UNDEFINED_ENUM_CONSTANT
  There is no constant named '{0}' in '{1}'.
  Try correcting the name to the name of an existing constant, or defining a constant named '{0}'.
StaticTypeWarningCode.UNDEFINED_FUNCTION
  The function '{0}' isn't defined.
  Try importing the library that defines '{0}', correcting the name to the name of an existing function, or defining a function named '{0}'.
StaticTypeWarningCode.UNDEFINED_GETTER
  The getter '{0}' isn't defined for the class '{1}'.
  Try importing the library that defines '{0}', correcting the name to the name of an existing getter, or defining a getter or field named '{0}'.
StaticTypeWarningCode.UNDEFINED_METHOD
  The method '{0}' isn't defined for the class '{1}'.
  Try correcting the name to the name of an existing method, or defining a method named '{0}'.
StaticTypeWarningCode.UNDEFINED_OPERATOR
  The operator '{0}' isn't defined for the class '{1}'.
  Try defining the operator '{0}'.

StaticTypeWarningCode.UNDEFINED_SETTER
  The setter '{0}' isn't defined for the class '{1}'.
  Try importing the library that defines '{0}', correcting the name to the name of an existing setter, or defining a setter or field named '{0}'.
StaticTypeWarningCode.UNDEFINED_SUPER_GETTER
  The getter '{0}' isn't defined in a superclass of '{1}'.
  Try correcting the name to the name of an existing getter, or defining a getter or field named '{0}' in a superclass.
StaticTypeWarningCode.UNDEFINED_SUPER_METHOD
  The method '{0}' isn't defined in a superclass of '{1}'.
  Try correcting the name to the name of an existing method, or defining a method named '{0}' in a superclass.
StaticTypeWarningCode.UNDEFINED_SUPER_OPERATOR
  The operator '{0}' isn't defined in a superclass of '{1}'.
  Try defining the operator '{0}' in a superclass.
StaticTypeWarningCode.UNDEFINED_SUPER_SETTER
  The setter '{0}' isn't defined in a superclass of '{1}'.
  Try correcting the name to the name of an existing setter, or defining a setter or field named '{0}' in a superclass.
StaticTypeWarningCode.UNQUALIFIED_REFERENCE_TO_NON_LOCAL_STATIC_MEMBER
  Static members from supertypes must be qualified by the name of the defining type.
  Try adding '{0}.' before the name.
StaticTypeWarningCode.WRONG_NUMBER_OF_TYPE_ARGUMENTS
  The type '{0}' is declared with {1} type parameters, but {2} type arguments were given.
  Try adjusting the number of type arguments.
StaticTypeWarningCode.WRONG_NUMBER_OF_TYPE_ARGUMENTS_CONSTRUCTOR
  The constructor '{0}.{1}' doesn't have type parameters.
  Try moving type arguments to after the type name.
StaticTypeWarningCode.WRONG_NUMBER_OF_TYPE_ARGUMENTS_METHOD
  The method '{0}' is declared with {1} type parameters, but {2} type arguments were given.
  Try adjusting the number of type arguments.
StaticTypeWarningCode.YIELD_OF_INVALID_TYPE
  The type '{0}' implied by the 'yield' expression must be assignable to '{1}'.
  null
StaticWarningCode.AMBIGUOUS_IMPORT
  The name '{0}' is defined in the libraries {1}.
  Try using 'as prefix' for one of the import directives, or hiding the name from all but one of the imports.
StaticWarningCode.ARGUMENT_TYPE_NOT_ASSIGNABLE
  The argument type '{0}' can't be assigned to the parameter type '{1}'.
  null
StaticWarningCode.ASSIGNMENT_TO_CONST
  Constant variables can't be assigned a value.
  Try removing the assignment, or remove the modifier 'const' from the variable.
StaticWarningCode.ASSIGNMENT_TO_FINAL
  '{0}' can't be used as a setter because it's final.
  Try finding a different setter, or making '{0}' non-final.
StaticWarningCode.ASSIGNMENT_TO_FINAL_LOCAL
  '{0}', a final variable, can only be set once.
  Try making '{0}' non-final.
StaticWarningCode.ASSIGNMENT_TO_FINAL_NO_SETTER
  No setter named '{0}' in class '{1}'.
  Try correcting the name to reference an existing setter, or declare the setter.
StaticWarningCode.ASSIGNMENT_TO_FUNCTION
  Functions can't be assigned a value.
  null
StaticWarningCode.ASSIGNMENT_TO_METHOD
  Methods can't be assigned a value.
  null
StaticWarningCode.ASSIGNMENT_TO_TYPE
  Types can't be assigned a value.
  null
StaticWarningCode.CASE_BLOCK_NOT_TERMINATED
  The last statement of the 'case' should be 'break', 'continue', 'rethrow', 'return' or 'throw'.
  Try adding one of the required statements.
StaticWarningCode.CAST_TO_NON_TYPE
  The name '{0}' isn't a type, so it can't be used in an 'as' expression.
  Try changing the name to the name of an existing type, or creating a type with the name '{0}'.
StaticWarningCode.CONCRETE_CLASS_WITH_ABSTRACT_MEMBER
  '{0}' must have a method body because '{1}' isn't abstract.
  Try making '{1}' abstract, or adding a body to '{0}'.
StaticWarningCode.CONST_WITH_ABSTRACT_CLASS
  Abstract classes can't be created with a 'const' expression.
  Try creating an instance of a subtype.
StaticWarningCode.EXPORT_DUPLICATED_LIBRARY_NAMED
  The exported libraries '{0}' and '{1}' can't have the same name '{2}'.
  Try adding a hide clause to one of the export directives.
StaticWarningCode.EXTRA_POSITIONAL_ARGUMENTS
  Too many positional arguments: {0} expected, but {1} found.
  Try removing the extra positional arguments.
StaticWarningCode.EXTRA_POSITIONAL_ARGUMENTS_COULD_BE_NAMED
  Too many positional arguments: {0} expected, but {1} found.
  Try removing the extra positional arguments, or specifying the name for named arguments.
StaticWarningCode.FIELD_INITIALIZED_IN_INITIALIZER_AND_DECLARATION
  Fields can't be initialized in the constructor if they are final and have already been initialized at their declaration.
  Try removing one of the initializations.
StaticWarningCode.FINAL_INITIALIZED_IN_DECLARATION_AND_CONSTRUCTOR
  '{0}' is final and was given a value when it was declared, so it can't be set to a new value.
  Try removing one of the initializations.
StaticWarningCode.FIELD_INITIALIZER_NOT_ASSIGNABLE
  The initializer type '{0}' can't be assigned to the field type '{1}'.
  null
StaticWarningCode.FIELD_INITIALIZING_FORMAL_NOT_ASSIGNABLE
  The parameter type '{0}' is incompatible with the field type '{1}'.
  Try changing or removing the parameter's type, or changing the field's type.
StaticWarningCode.FINAL_NOT_INITIALIZED
  The final variable '{0}' must be initialized.
  Try initializing the variable.
StaticWarningCode.FINAL_NOT_INITIALIZED_CONSTRUCTOR_1
  The final variable '{0}' must be initialized.
  Try adding an initializer for the field.
StaticWarningCode.FINAL_NOT_INITIALIZED_CONSTRUCTOR_2
  The final variables '{0}' and '{1}' must be initialized.
  Try adding initializers for the fields.
StaticWarningCode.FINAL_NOT_INITIALIZED_CONSTRUCTOR_3
  The final variables '{0}', '{1}' and '{2}' more must be initialized.
  Try adding initializers for the fields.
StaticWarningCode.IMPORT_DUPLICATED_LIBRARY_NAMED
  The imported libraries '{0}' and '{1}' can't have the same name '{2}'.
  Try adding a hide clause to one of the imports.
StaticWarningCode.IMPORT_OF_NON_LIBRARY
  The imported library '{0}' can't have a part-of directive.
  Try importing the library that the part is a part of.
StaticWarningCode.INVALID_OVERRIDE_DIFFERENT_DEFAULT_VALUES_NAMED
  Parameters can't override default values, this method overrides '{0}.{1}' where '{2}' has a different value.
  Try using the same default value in both methods.
StaticWarningCode.INVALID_OVERRIDE_DIFFERENT_DEFAULT_VALUES_POSITIONAL
  Parameters can't override default values, this method overrides '{0}.{1}' where this positional parameter has a different value.
  Try using the same default value in both methods.
StaticWarningCode.LIST_ELEMENT_TYPE_NOT_ASSIGNABLE
  The element type '{0}' can't be assigned to the list type '{1}'.
  null
StaticWarningCode.MAP_KEY_TYPE_NOT_ASSIGNABLE
  The element type '{0}' can't be assigned to the map key type '{1}'.
  null
StaticWarningCode.MAP_VALUE_TYPE_NOT_ASSIGNABLE
  The element type '{0}' can't be assigned to the map value type '{1}'.
  null
StaticWarningCode.MISMATCHED_GETTER_AND_SETTER_TYPES
  The return type of getter '{0}' is '{1}' which isn't assignable to the type '{2}' of its setter '{3}'.
  Try changing the types so that they are compatible.
StaticWarningCode.MISSING_ENUM_CONSTANT_IN_SWITCH
  Missing case clause for '{0}'.
  Try adding a case clause for the missing constant, or adding a default clause.
StaticWarningCode.MIXED_RETURN_TYPES
  Functions can't include return statements both with and without values.
  Try making all the return statements consistent (either include a value or not).
StaticWarningCode.NEW_WITH_ABSTRACT_CLASS
  Abstract classes can't be created with a 'new' expression.
  Try creating an instance of a subtype.
StaticWarningCode.NEW_WITH_INVALID_TYPE_PARAMETERS
  The type '{0}' is declared with {1} type parameters, but {2} type arguments were given.
  Try adjusting the number of type arguments.
StaticWarningCode.NEW_WITH_NON_TYPE
  The name '{0}' isn't a class.
  Try correcting the name to match an existing class.
StaticWarningCode.NEW_WITH_UNDEFINED_CONSTRUCTOR
  The class '{0}' doesn't have a constructor named '{1}'.
  Try invoking a different constructor, or define a constructor named '{1}'.
StaticWarningCode.NEW_WITH_UNDEFINED_CONSTRUCTOR_DEFAULT
  The class '{0}' doesn't have a default constructor.
  Try using one of the named constructors defined in '{0}'.
StaticWarningCode.NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER_FIVE_PLUS
  Missing concrete implementations of {0}, {1}, {2}, {3} and {4} more.
  Try implementing the missing methods, or make the class abstract.
StaticWarningCode.NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER_FOUR
  Missing concrete implementations of {0}, {1}, {2} and {3}.
  Try implementing the missing methods, or make the class abstract.
StaticWarningCode.NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER_ONE
  Missing concrete implementation of {0}.
  Try implementing the missing method, or make the class abstract.
StaticWarningCode.NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER_THREE
  Missing concrete implementations of {0}, {1} and {2}.
  Try implementing the missing methods, or make the class abstract.
StaticWarningCode.NON_ABSTRACT_CLASS_INHERITS_ABSTRACT_MEMBER_TWO
  Missing concrete implementations of {0} and {1}.
  Try implementing the missing methods, or make the class abstract.
StaticWarningCode.NON_TYPE_IN_CATCH_CLAUSE
  The name '{0}' isn't a type and can't be used in an on-catch clause.
  Try correcting the name to match an existing class.
StaticWarningCode.NON_VOID_RETURN_FOR_OPERATOR
  The return type of the operator []= must be 'void'.
  Try changing the return type to 'void'.
StaticWarningCode.NON_VOID_RETURN_FOR_SETTER
  The return type of the setter must be 'void' or absent.
  Try removing the return type, or define a method rather than a setter.
StaticWarningCode.NOT_A_TYPE
  {0} isn't a type.
  Try correcting the name to match an existing type.
StaticWarningCode.NOT_ENOUGH_REQUIRED_ARGUMENTS
  {0} required argument(s) expected, but {1} found.
  Try adding the additional required arguments.
StaticWarningCode.PART_OF_DIFFERENT_LIBRARY
  Expected this library to be part of '{0}', not '{1}'.
  Try including a different part, or changing the name of the library in the part's part-of directive.
StaticWarningCode.REDIRECT_TO_INVALID_FUNCTION_TYPE
  The redirected constructor '{0}' has incompatible parameters with '{1}'.
  Try redirecting to a different constructor, or directly invoking the desired constructor rather than redirecting to it.
StaticWarningCode.REDIRECT_TO_INVALID_RETURN_TYPE
  The return type '{0}' of the redirected constructor isn't assignable to '{1}'.
  Try redirecting to a different constructor, or directly invoking the desired constructor rather than redirecting to it.
StaticWarningCode.REDIRECT_TO_MISSING_CONSTRUCTOR
  The constructor '{0}' couldn't be found in '{1}'.
  Try correcting the constructor name to an existing constructor, or defining the constructor in '{1}'.
StaticWarningCode.REDIRECT_TO_NON_CLASS
  The name '{0}' isn't a type and can't be used in a redirected constructor.
  Try correcting the name to match an existing class.
StaticWarningCode.RETURN_WITHOUT_VALUE
  Missing return value after 'return'.
  null
StaticWarningCode.SET_ELEMENT_TYPE_NOT_ASSIGNABLE
  The element type '{0}' can't be assigned to the set type '{1}'.
  null
StaticWarningCode.STATIC_ACCESS_TO_INSTANCE_MEMBER
  Instance member '{0}' can't be accessed using static access.
  null
StaticWarningCode.SWITCH_EXPRESSION_NOT_ASSIGNABLE
  Type '{0}' of the switch expression isn't assignable to the type '{1}' of case expressions.
  null
StaticWarningCode.TYPE_ANNOTATION_DEFERRED_CLASS
  The deferred type '{0}' can't be used in a declaration, cast or type test.
  Try using a different type, or changing the import to not be deferred.
StaticWarningCode.TYPE_PARAMETER_REFERENCED_BY_STATIC
  Static members can't reference type parameters of the class.
  Try removing the reference to the type parameter, or making the member an instance member.
StaticWarningCode.TYPE_TEST_WITH_NON_TYPE
  The name '{0}' isn't a type and can't be used in an 'is' expression.
  Try correcting the name to match an existing type.
StaticWarningCode.TYPE_TEST_WITH_UNDEFINED_NAME
  The name '{0}' isn't defined, so it can't be used in an 'is' expression.
  Try changing the name to the name of an existing type, or creating a type with the name '{0}'.
StaticWarningCode.UNDEFINED_CLASS
  Undefined class '{0}'.
  Try changing the name to the name of an existing class, or creating a class with the name '{0}'.
StaticWarningCode.UNDEFINED_CLASS_BOOLEAN
  Undefined class 'boolean'.
  Try using the type 'bool'.
StaticWarningCode.UNDEFINED_IDENTIFIER
  Undefined name '{0}'.
  Try correcting the name to one that's defined, or defining the name.
StaticWarningCode.UNDEFINED_IDENTIFIER_AWAIT
  Undefined name 'await' in function body not marked with 'async'.
  Try correcting the name to one that's defined, defining the name, or adding 'async' to the enclosing function body.
StaticWarningCode.UNDEFINED_NAMED_PARAMETER
  The named parameter '{0}' isn't defined.
  Try correcting the name to an existing named parameter, or defining a new parameter with this name.
StaticWarningCode.USE_OF_VOID_RESULT
  The expression here has a type of 'void', and therefore can't be used.
  Check if you are using the correct API; there may be a function or call that returns void you didn't expect. Also check type parameters and variables which, in rare cases, may be void as well.

StaticWarningCode.UNCHECKED_USE_OF_NULLABLE_VALUE ***
  The expression is nullable and must be null-checked before it can be used.
  Try casting or check the value isn't null before using it.

StrongModeCode.STRONG_MODE_ASSIGNMENT_CAST
  Unsafe implicit cast from '{0}' to '{1}'. This usually indicates that type information was lost and resulted in 'dynamic' and/or a place that will have a failure at runtime.
  Try adding an explicit cast to '{1}' or improving the type of '{0}'.
StrongModeCode.STRONG_MODE_COULD_NOT_INFER
  Couldn't infer type parameter '{0}'.{1}
  null
StrongModeCode.STRONG_MODE_DOWN_CAST_COMPOSITE
  Unsafe implicit cast from '{0}' to '{1}'. This usually indicates that type information was lost and resulted in 'dynamic' and/or a place that will have a failure at runtime.
  Try adding an explicit cast to '{1}' or improving the type of '{0}'.
StrongModeCode.STRONG_MODE_DOWN_CAST_IMPLICIT
  Unsafe implicit cast from '{0}' to '{1}'. This usually indicates that type information was lost and resulted in 'dynamic' and/or a place that will have a failure at runtime.
  Try adding an explicit cast to '{1}' or improving the type of '{0}'.
StrongModeCode.STRONG_MODE_DOWN_CAST_IMPLICIT_ASSIGN
  Unsafe implicit cast from '{0}' to '{1}'. This usually indicates that type information was lost and resulted in 'dynamic' and/or a place that will have a failure at runtime.
  Try adding an explicit cast to '{1}' or improving the type of '{0}'.
StrongModeCode.STRONG_MODE_DYNAMIC_CAST
  Unsafe implicit cast from '{0}' to '{1}'. This usually indicates that type information was lost and resulted in 'dynamic' and/or a place that will have a failure at runtime.
  Try adding an explicit cast to '{1}' or improving the type of '{0}'.
StrongModeCode.STRONG_MODE_DYNAMIC_INVOKE
  '{0}' requires a dynamic invoke.
  null
StrongModeCode.STRONG_MODE_IMPLICIT_DYNAMIC_FIELD
  Missing field type for '{0}'.
  Try adding an explicit type like 'dynamic', or enable implicit-dynamic in your analysis options file.
StrongModeCode.STRONG_MODE_IMPLICIT_DYNAMIC_FUNCTION
  Missing type arguments for generic function '{0}<{1}>'.
  Try adding an explicit type like 'dynamic', or enable implicit-dynamic in your analysis options file.
StrongModeCode.STRONG_MODE_IMPLICIT_DYNAMIC_INVOKE
  Missing type arguments for calling generic function type '{0}'.
  Try adding an explicit type like 'dynamic', or enable implicit-dynamic in your analysis options file.
StrongModeCode.STRONG_MODE_IMPLICIT_DYNAMIC_LIST_LITERAL
  Missing type argument for list literal.
  Try adding an explicit type like 'dynamic', or enable implicit-dynamic in your analysis options file.
StrongModeCode.STRONG_MODE_IMPLICIT_DYNAMIC_MAP_LITERAL
  Missing type arguments for map literal.
  Try adding an explicit type like 'dynamic', or enable implicit-dynamic in your analysis options file.
StrongModeCode.STRONG_MODE_IMPLICIT_DYNAMIC_METHOD
  Missing type arguments for generic method '{0}<{1}>'.
  Try adding an explicit type like 'dynamic', or enable implicit-dynamic in your analysis options file.
StrongModeCode.STRONG_MODE_IMPLICIT_DYNAMIC_PARAMETER
  Missing parameter type for '{0}'.
  Try adding an explicit type like 'dynamic', or enable implicit-dynamic in your analysis options file.
StrongModeCode.STRONG_MODE_IMPLICIT_DYNAMIC_RETURN
  Missing return type for '{0}'.
  Try adding an explicit type like 'dynamic', or enable implicit-dynamic in your analysis options file.
StrongModeCode.STRONG_MODE_IMPLICIT_DYNAMIC_TYPE
  Missing type arguments for generic type '{0}'.
  Try adding an explicit type like 'dynamic', or enable implicit-dynamic in your analysis options file.
StrongModeCode.STRONG_MODE_IMPLICIT_DYNAMIC_VARIABLE
  Missing variable type for '{0}'.
  Try adding an explicit type like 'dynamic', or enable implicit-dynamic in your analysis options file.
StrongModeCode.STRONG_MODE_INFERRED_TYPE
  '{0}' has inferred type '{1}'.
  null
StrongModeCode.STRONG_MODE_INFERRED_TYPE_ALLOCATION
  '{0}' has inferred type '{1}'.
  null
StrongModeCode.STRONG_MODE_INFERRED_TYPE_CLOSURE
  '{0}' has inferred type '{1}'.
  null
StrongModeCode.STRONG_MODE_INFERRED_TYPE_LITERAL
  '{0}' has inferred type '{1}'.
  null
StrongModeCode.STRONG_MODE_INVALID_CAST_LITERAL
  The literal '{0}' with type '{1}' isn't of expected type '{2}'.
  null
StrongModeCode.STRONG_MODE_INVALID_CAST_LITERAL_LIST
  The list literal type '{0}' isn't of expected type '{1}'. The list's type can be changed with an explicit generic type argument or by changing the element types.
  null
StrongModeCode.STRONG_MODE_INVALID_CAST_LITERAL_MAP
  The map literal type '{0}' isn't of expected type '{1}'. The maps's type can be changed with an explicit generic type arguments or by changing the key and value types.
  null
StrongModeCode.STRONG_MODE_INVALID_CAST_LITERAL_SET
  The set literal type '{0}' isn't of expected type '{1}'. The set's type can be changed with an explicit generic type argument or by changing the element types.
  null
StrongModeCode.STRONG_MODE_INVALID_CAST_FUNCTION_EXPR
  The function expression type '{0}' isn't of type '{1}'. This means its parameter or return type doesn't match what is expected. Consider changing parameter type(s) or the returned type(s).
  null
StrongModeCode.STRONG_MODE_INVALID_CAST_NEW_EXPR
  The constructor returns type '{0}' that isn't of expected type '{1}'.
  null
StrongModeCode.STRONG_MODE_INVALID_CAST_METHOD
  The method tear-off '{0}' has type '{1}' that isn't of expected type '{2}'. This means its parameter or return type doesn't match what is expected.
  null
StrongModeCode.STRONG_MODE_INVALID_CAST_FUNCTION
  The function '{0}' has type '{1}' that isn't of expected type '{2}'. This means its parameter or return type doesn't match what is expected.
  null
StrongModeCode.STRONG_MODE_INVALID_PARAMETER_DECLARATION
  Type check failed: '{0}' isn't of type '{1}'.
  null
StrongModeCode.STRONG_MODE_INVALID_SUPER_INVOCATION
  super call must be last in an initializer list (see https://goo.gl/EY6hDP): '{0}'.
  null
StrongModeCode.STRONG_MODE_NON_GROUND_TYPE_CHECK_INFO
  Runtime check on non-ground type '{0}' may throw StrongModeError.
  null
StrongModeCode.STRONG_MODE_NOT_INSTANTIATED_BOUND
  Type parameter bound types must be instantiated.
  Try adding type arguments.
StrongModeCode.STRONG_MODE_TOP_LEVEL_CYCLE
  The type of '{0}' can't be inferred because it depends on itself through the cycle: {1}.
  Try adding an explicit type to one or more of the variables in the cycle in order to break the cycle.
StrongModeCode.STRONG_MODE_TOP_LEVEL_FUNCTION_LITERAL_BLOCK
  The type of the function literal can't be inferred because the literal has a block as its body.
  Try adding an explicit type to the variable.
StrongModeCode.STRONG_MODE_TOP_LEVEL_IDENTIFIER_NO_TYPE
  The type of '{0}' can't be inferred because the type of '{1}' couldn't be inferred.
  Try adding an explicit type to either the variable '{0}' or the variable '{1}'.
StrongModeCode.STRONG_MODE_TOP_LEVEL_INSTANCE_GETTER
  The type of '{0}' can't be inferred because it refers to an instance getter, '{1}', which has an implicit type.
  Add an explicit type for either '{0}' or '{1}'.
StrongModeCode.STRONG_MODE_TOP_LEVEL_INSTANCE_METHOD
  The type of '{0}' can't be inferred because it refers to an instance method, '{1}', which has an implicit type.
  Add an explicit type for either '{0}' or '{1}'.

{% endcomment %}
