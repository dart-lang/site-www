---
title: Diagnostics
description: Details for diagnostics produced by the Dart analyzer.
---

This page lists diagnostic messages produced by the Dart analyzer,
with links to details about what those messages mean
and how you can fix your code.
For more information about the analyzer, see
[Customizing static analysis](/guides/language/analysis-options).

## Glossary

The diagnostics reference the following terms:

* [constant context][]
* [definite assignment][]
* [mixin application][]
* [override inference][]
* [part file][]
* [potentially non-nullable][]
* [public library][]

[constant context]: #constant-context
[definite assignment]: #definite-assignment
[mixin application]: #mixin-application
[override inference]: #override-inference
[part file]: #part-file
[potentially non-nullable]: #potentially-non-nullable
[public library]: #public-library

### Constant context

A _constant context_ is a region of code in which it isn't necessary to include
the `const` keyword because it's implied by the fact that everything in that
region is required to be a constant. The following locations are constant
contexts:

* Everything inside a list, map or set literal that's prefixed by the
  `const` keyword. Example:

  ```dart
  var l = const [/*constant context*/];
  ```

* The arguments inside an invocation of a constant constructor. Example:

  ```dart
  var p = const Point(/*constant context*/);
  ```

* The initializer for a variable that's prefixed by the `const` keyword.
  Example:

  ```dart
  const v = /*constant context*/;
  ```

* Annotations

* The expression in a `case` clause. Example:

  ```dart
  void f(int e) {
    switch (e) {
      case /*constant context*/:
        break;
    }
  }
  ```

### Definite assignment

Definite assignment analysis is the process of determining, for each local
variable at each point in the code, which of the following is true:
- The variable has definitely been assigned a value (_definitely assigned_).
- The variable has definitely not been assigned a value (_definitely
  unassigned_).
- The variable might or might not have been assigned a value, depending on the
  execution path taken to arrive at that point.

Definite assignment analysis helps find problems in code, such as places where a
variable that might not have been assigned a value is being referenced, or
places where a variable that can only be assigned a value one time is being
assigned after it might already have been assigned a value.

For example, in the following code the variable `s` is definitely unassigned
when it’s passed as an argument to `print`:

```dart
void f() {
  String s;
  print(s);
}
```

But in the following code, the variable `s` is definitely assigned:

```dart
void f(String name) {
  String s = 'Hello $name!';
  print(s);
}
```

Definite assignment analysis can even tell whether a variable is definitely
assigned (or unassigned) when there are multiple possible execution paths. In
the following code the `print` function is called if execution goes through
either the true or the false branch of the `if` statement, but because `s` is
assigned no matter which branch is taken, it’s definitely assigned before it’s
passed to `print`:

```dart
void f(String name, bool casual) {
  String s;
  if (casual) {
    s = 'Hi $name!';
  } else {
    s = 'Hello $name!';
  }
  print(s);
}
```

In flow analysis, the end of the `if` statement is referred to as a _join_—a
place where two or more execution paths merge back together. Where there's a
join, the analysis says that a variable is definitely assigned if it’s
definitely assigned along all of the paths that are merging, and definitely
unassigned if it’s definitely unassigned along all of the paths.

Sometimes a variable is assigned a value on one path but not on another, in
which case the variable might or might not have been assigned a value. In the
following example, the true branch of the `if` statement might or might not be
executed, so the variable might or might be assigned a value:

```dart
void f(String name, bool casual) {
  String s;
  if (casual) {
    s = 'Hi $name!';
  }
  print(s);
}
```

The same is true if there is a false branch that doesn’t assign a value to `s`.

The analysis of loops is a little more complicated, but it follows the same
basic reasoning. For example, the condition in a `while` loop is always
executed, but the body might or might not be. So just like an `if` statement,
there's a join at the end of the `while` statement between the path in which the
condition is `true` and the path in which the condition is `false`.

For additional details, see the
[specification of definite assignment][definiteAssignmentSpec].

[definiteAssignmentSpec]: https://github.com/dart-lang/language/blob/master/resources/type-system/flow-analysis.md

### Mixin application

A _mixin application_ is the class created when a mixin is applied to a class.
For example, consider the following declarations:

```dart
class A {}

mixin M {}

class B extends A with M {}
```

The class `B` is a subclass of the mixin application of `M` to `A`, sometimes
nomenclated as `A+M`. The class `A+M` is a subclass of `A` and has members that
are copied from `M`.

You can give an actual name to a mixin application by defining it as:

```dart
class A {}

mixin M {}

class A_M = A with M;
```

Given this declaration of `A_M`, the following declaration of `B` is equivalent
to the declaration of `B` in the original example:

```dart
class B extends A_M {}
```

### Override inference

Override inference is the process by which any missing types in a method
declaration are inferred based on the corresponding types from the method or
methods that it overrides.

If a candidate method (the method that's missing type information) overrides a
single inherited method, then the corresponding types from the overridden method
are inferred. For example, consider the following code:

```dart
class A {
  int m(String s) => 0;
}

class B extends A {
  @override
  m(s) => 1;
}
```

The declaration of `m` in `B` is a candidate because it's missing both the
return type and the parameter type. Because it overrides a single method (the
method `m` in `A`), the types from the overridden method will be used to infer
the missing types and it will be as if the method in `B` had been declared as
`int m(String s) => 1;`.

If a candidate method overrides multiple methods, and the function type one of
those overridden methods, M<sub>s</sub>, is a supertype of the function types of
all of the other overridden methods, then M<sub>s</sub> is used to infer the
missing types. For example, consider the following code:

```dart
class A {
  int m(num n) => 0;
}

class B {
  num m(int i) => 0;
}

class C implements A, B {
  @override
  m(n) => 1;
}
```

The declaration of `m` in `C` is a candidate for override inference because it's
missing both the return type and the parameter type. It overrides both `m` in
`A` and `m` in `B`, so we need to choose one of them from which the missing
types can be inferred. But because the function type of `m` in `A`
(`int Function(num)`) is a supertype of the function type of `m` in `B`
(`num Function(int)`), the function in `A` is used to infer the missing types.
The result is the same as declaring the method in `C` as `int m(num n) => 1;`.

It is an error if none of the overridden methods has a function type that is a
supertype of all the other overridden methods.

### Part file

A part file is a Dart source file that contains a `part of` directive.

### Potentially non-nullable

A type is _potentially non-nullable_ if it's either explicitly non-nullable or
if it's a type parameter.

A type is explicitly non-nullable if it is a type name that isn't followed by a
question mark. Note that there are a few types that are always nullable, such as
`Null` and `dynamic`, and that `FutureOr` is only non-nullable if it isn't
followed by a question mark _and_ the type argument is non-nullable (such as
`FutureOr<String>`).

Type parameters are potentially non-nullable because the actual runtime type
(the type specified as a type argument) might be non-nullable. For example,
given a declaration of `class C<T> {}`, the type `C` could be used with a
non-nullable type argument as in `C<int>`.

### Public library

A public library is a library that is located inside the package's `lib`
directory but not inside the `lib/src` directory.

## Diagnostics

The analyzer produces the following diagnostics for code that
doesn't conform to the language specification or
that might work in unexpected ways.

[abi_specific_integer_invalid](/tools/diagnostics/abi_specific_integer_invalid)

: _Classes extending 'AbiSpecificInteger' must have exactly one const constructor, no other members, and no type parameters._

[abi_specific_integer_mapping_extra](/tools/diagnostics/abi_specific_integer_mapping_extra)

: _Classes extending 'AbiSpecificInteger' must have exactly one 'AbiSpecificIntegerMapping' annotation specifying the mapping from ABI to a 'NativeType' integer with a fixed size._

[abi_specific_integer_mapping_missing](/tools/diagnostics/abi_specific_integer_mapping_missing)

: _Classes extending 'AbiSpecificInteger' must have exactly one 'AbiSpecificIntegerMapping' annotation specifying the mapping from ABI to a 'NativeType' integer with a fixed size._

[abi_specific_integer_mapping_unsupported](/tools/diagnostics/abi_specific_integer_mapping_unsupported)

: _Invalid mapping to '{0}'; only mappings to 'Int8', 'Int16', 'Int32', 'Int64', 'Uint8', 'Uint16', 'UInt32', and 'Uint64' are supported._

[abstract_field_initializer](/tools/diagnostics/abstract_field_initializer)

: _Abstract fields can't have initializers._

[abstract_super_member_reference](/tools/diagnostics/abstract_super_member_reference)

: _The {0} '{1}' is always abstract in the supertype._

[ambiguous_export](/tools/diagnostics/ambiguous_export)

: _The name '{0}' is defined in the libraries '{1}' and '{2}'._

[ambiguous_extension_member_access](/tools/diagnostics/ambiguous_extension_member_access)

: _A member named '{0}' is defined in {1}, and none are more specific._

[ambiguous_import](/tools/diagnostics/ambiguous_import)

: _The name '{0}' is defined in the libraries {1}._

[ambiguous_set_or_map_literal_both](/tools/diagnostics/ambiguous_set_or_map_literal_both)

: _The literal can't be either a map or a set because it contains at least one literal map entry or a spread operator spreading a 'Map', and at least one element which is neither of these._

[ambiguous_set_or_map_literal_either](/tools/diagnostics/ambiguous_set_or_map_literal_either)

: _This literal must be either a map or a set, but the elements don't have enough information for type inference to work._

[annotation_on_pointer_field](/tools/diagnostics/annotation_on_pointer_field)

: _Fields in a struct class whose type is 'Pointer' shouldn't have any annotations._

[argument_must_be_a_constant](/tools/diagnostics/argument_must_be_a_constant)

: _Argument '{0}' must be a constant._

[argument_type_not_assignable](/tools/diagnostics/argument_type_not_assignable)

: _The argument type '{0}' can't be assigned to the parameter type '{1}'._

[argument_type_not_assignable_to_error_handler](/tools/diagnostics/argument_type_not_assignable_to_error_handler)

: _The argument type '{0}' can't be assigned to the parameter type '{1} Function(Object)' or '{1} Function(Object, StackTrace)'._

[assert_in_redirecting_constructor](/tools/diagnostics/assert_in_redirecting_constructor)

: _A redirecting constructor can't have an 'assert' initializer._

[asset_directory_does_not_exist](/tools/diagnostics/asset_directory_does_not_exist)

: _The asset directory '{0}' doesn't exist._

[asset_does_not_exist](/tools/diagnostics/asset_does_not_exist)

: _The asset file '{0}' doesn't exist._

[asset_field_not_list](/tools/diagnostics/asset_field_not_list)

: _The value of the 'asset' field is expected to be a list of relative file paths._

[asset_not_string](/tools/diagnostics/asset_not_string)

: _Assets are required to be file paths (strings)._

[assignment_of_do_not_store](/tools/diagnostics/assignment_of_do_not_store)

: _'{0}' is marked 'doNotStore' and shouldn't be assigned to a field or top-level variable._

[assignment_to_const](/tools/diagnostics/assignment_to_const)

: _Constant variables can't be assigned a value._

[assignment_to_final](/tools/diagnostics/assignment_to_final)

: _'{0}' can't be used as a setter because it's final._

[assignment_to_final_local](/tools/diagnostics/assignment_to_final_local)

: _The final variable '{0}' can only be set once._

[assignment_to_final_no_setter](/tools/diagnostics/assignment_to_final_no_setter)

: _There isn't a setter named '{0}' in class '{1}'._

[assignment_to_function](/tools/diagnostics/assignment_to_function)

: _Functions can't be assigned a value._

[assignment_to_method](/tools/diagnostics/assignment_to_method)

: _Methods can't be assigned a value._

[assignment_to_type](/tools/diagnostics/assignment_to_type)

: _Types can't be assigned a value._

[async_for_in_wrong_context](/tools/diagnostics/async_for_in_wrong_context)

: _The async for-in loop can only be used in an async function._

[await_in_late_local_variable_initializer](/tools/diagnostics/await_in_late_local_variable_initializer)

: _The 'await' expression can't be used in a 'late' local variable's initializer._

[body_might_complete_normally](/tools/diagnostics/body_might_complete_normally)

: _The body might complete normally, causing 'null' to be returned, but the return type, '{0}', is a potentially non-nullable type._

[body_might_complete_normally_catch_error](/tools/diagnostics/body_might_complete_normally_catch_error)

: _This 'onError' handler must return a value assignable to '{0}', but ends without returning a value._

[body_might_complete_normally_nullable](/tools/diagnostics/body_might_complete_normally_nullable)

: _This function has a nullable return type of '{0}', but ends without returning a value._

[break_label_on_switch_member](/tools/diagnostics/break_label_on_switch_member)

: _A break label resolves to the 'case' or 'default' statement._

[built_in_identifier_as_type](/tools/diagnostics/built_in_identifier_as_type)

: _The built-in identifier '{0}' can't be used as a type._

[built_in_identifier_in_declaration](/tools/diagnostics/built_in_identifier_in_declaration)

: _The built-in identifier '{0}' can't be used as an extension name._
: _The built-in identifier '{0}' can't be used as a prefix name._
: _The built-in identifier '{0}' can't be used as a type name._
: _The built-in identifier '{0}' can't be used as a type parameter name._
: _The built-in identifier '{0}' can't be used as a typedef name._

[case_block_not_terminated](/tools/diagnostics/case_block_not_terminated)

: _The last statement of the 'case' should be 'break', 'continue', 'rethrow', 'return', or 'throw'._

[case_expression_type_implements_equals](/tools/diagnostics/case_expression_type_implements_equals)

: _The switch case expression type '{0}' can't override the '==' operator._

[case_expression_type_is_not_switch_expression_subtype](/tools/diagnostics/case_expression_type_is_not_switch_expression_subtype)

: _The switch case expression type '{0}' must be a subtype of the switch expression type '{1}'._

[cast_from_nullable_always_fails](/tools/diagnostics/cast_from_nullable_always_fails)

: _This cast will always throw an exception because the nullable local variable '{0}' is not assigned._

[cast_from_null_always_fails](/tools/diagnostics/cast_from_null_always_fails)

: _This cast always throws an exception because the expression always evaluates to 'null'._

[cast_to_non_type](/tools/diagnostics/cast_to_non_type)

: _The name '{0}' isn't a type, so it can't be used in an 'as' expression._

[collection_element_from_deferred_library](/tools/diagnostics/collection_element_from_deferred_library)

: _Constant values from a deferred library can't be used as keys in a 'const' map literal._
: _Constant values from a deferred library can't be used as values in a 'const' list literal._
: _Constant values from a deferred library can't be used as values in a 'const' set literal._
: _Constant values from a deferred library can't be used as values in a 'const' map literal._

[compound_implements_finalizable](/tools/diagnostics/compound_implements_finalizable)

: _The class '{0}' can't implement Finalizable._

[concrete_class_has_enum_superinterface](/tools/diagnostics/concrete_class_has_enum_superinterface)

: _Concrete classes can't have 'Enum' as a superinterface._

[concrete_class_with_abstract_member](/tools/diagnostics/concrete_class_with_abstract_member)

: _'{0}' must have a method body because '{1}' isn't abstract._

[conflicting_constructor_and_static_member](/tools/diagnostics/conflicting_constructor_and_static_member)

: _'{0}' can't be used to name both a constructor and a static field in this class._
: _'{0}' can't be used to name both a constructor and a static getter in this class._
: _'{0}' can't be used to name both a constructor and a static method in this class._
: _'{0}' can't be used to name both a constructor and a static setter in this class._

[conflicting_generic_interfaces](/tools/diagnostics/conflicting_generic_interfaces)

: _The class '{0}' can't implement both '{1}' and '{2}' because the type arguments are different._

[conflicting_type_variable_and_container](/tools/diagnostics/conflicting_type_variable_and_container)

: _'{0}' can't be used to name both a type variable and the class in which the type variable is defined._
: _'{0}' can't be used to name both a type variable and the enum in which the type variable is defined._
: _'{0}' can't be used to name both a type variable and the extension in which the type variable is defined._
: _'{0}' can't be used to name both a type variable and the mixin in which the type variable is defined._

[conflicting_type_variable_and_member](/tools/diagnostics/conflicting_type_variable_and_member)

: _'{0}' can't be used to name both a type variable and a member in this class._
: _'{0}' can't be used to name both a type variable and a member in this mixin._
: _'{0}' can't be used to name both a type variable and a member in this enum._
: _'{0}' can't be used to name both a type variable and a member in this extension._

[const_constructor_param_type_mismatch](/tools/diagnostics/const_constructor_param_type_mismatch)

: _A value of type '{0}' can't be assigned to a parameter of type '{1}' in a const constructor._

[const_constructor_with_field_initialized_by_non_const](/tools/diagnostics/const_constructor_with_field_initialized_by_non_const)

: _Can't define the 'const' constructor because the field '{0}' is initialized with a non-constant value._

[const_constructor_with_non_const_super](/tools/diagnostics/const_constructor_with_non_const_super)

: _A constant constructor can't call a non-constant super constructor of '{0}'._

[const_constructor_with_non_final_field](/tools/diagnostics/const_constructor_with_non_final_field)

: _Can't define a const constructor for a class with non-final fields._

[const_deferred_class](/tools/diagnostics/const_deferred_class)

: _Deferred classes can't be created with 'const'._

[const_initialized_with_non_constant_value](/tools/diagnostics/const_initialized_with_non_constant_value)

: _Const variables must be initialized with a constant value._

[const_initialized_with_non_constant_value_from_deferred_library](/tools/diagnostics/const_initialized_with_non_constant_value_from_deferred_library)

: _Constant values from a deferred library can't be used to initialize a 'const' variable._

[const_instance_field](/tools/diagnostics/const_instance_field)

: _Only static fields can be declared as const._

[const_map_key_expression_type_implements_equals](/tools/diagnostics/const_map_key_expression_type_implements_equals)

: _The type of a key in a constant map can't override the '==' operator, but the class '{0}' does._

[const_not_initialized](/tools/diagnostics/const_not_initialized)

: _The constant '{0}' must be initialized._

[const_set_element_type_implements_equals](/tools/diagnostics/const_set_element_type_implements_equals)

: _The type of an element in a constant set can't override the '==' operator, but the type '{0}' does._

[const_spread_expected_list_or_set](/tools/diagnostics/const_spread_expected_list_or_set)

: _A list or a set is expected in this spread._

[const_spread_expected_map](/tools/diagnostics/const_spread_expected_map)

: _A map is expected in this spread._

[const_with_non_const](/tools/diagnostics/const_with_non_const)

: _The constructor being called isn't a const constructor._

[const_with_non_constant_argument](/tools/diagnostics/const_with_non_constant_argument)

: _Arguments of a constant creation must be constant expressions._

[const_with_type_parameters](/tools/diagnostics/const_with_type_parameters)

: _A constant creation can't use a type parameter as a type argument._
: _A constant constructor tearoff can't use a type parameter as a type argument._
: _A constant function tearoff can't use a type parameter as a type argument._

[continue_label_invalid](/tools/diagnostics/continue_label_invalid)

: _The label used in a 'continue' statement must be defined on either a loop or a switch member._

[creation_of_struct_or_union](/tools/diagnostics/creation_of_struct_or_union)

: _Subclasses of 'Struct' and 'Union' are backed by native memory, and can't be instantiated by a generative constructor._

[creation_with_non_type](/tools/diagnostics/creation_with_non_type)

: _The name '{0}' isn't a class._

[dead_code](/tools/diagnostics/dead_code)

: _Dead code._

[dead_code_catch_following_catch](/tools/diagnostics/dead_code_catch_following_catch)

: _Dead code: Catch clauses after a 'catch (e)' or an 'on Object catch (e)' are never reached._

[dead_code_on_catch_subtype](/tools/diagnostics/dead_code_on_catch_subtype)

: _Dead code: This on-catch block won't be executed because '{0}' is a subtype of '{1}' and hence will have been caught already._

[dead_null_aware_expression](/tools/diagnostics/dead_null_aware_expression)

: _The left operand can't be null, so the right operand is never executed._

[default_list_constructor](/tools/diagnostics/default_list_constructor)

: _The default 'List' constructor isn't available when null safety is enabled._

[default_value_in_function_type](/tools/diagnostics/default_value_in_function_type)

: _Parameters in a function type can't have default values._

[default_value_in_redirecting_factory_constructor](/tools/diagnostics/default_value_in_redirecting_factory_constructor)

: _Default values aren't allowed in factory constructors that redirect to another constructor._

[default_value_on_required_parameter](/tools/diagnostics/default_value_on_required_parameter)

: _Required named parameters can't have a default value._

[deferred_import_of_extension](/tools/diagnostics/deferred_import_of_extension)

: _Imports of deferred libraries must hide all extensions._

[definitely_unassigned_late_local_variable](/tools/diagnostics/definitely_unassigned_late_local_variable)

: _The late local variable '{0}' is definitely unassigned at this point._

[dependencies_field_not_map](/tools/diagnostics/dependencies_field_not_map)

: _The value of the '{0}' field is expected to be a map._

[deprecated_colon_for_default_value](/tools/diagnostics/deprecated_colon_for_default_value)

: _Using a colon as a separator before a default value is deprecated and will not be supported in language version 3.0 and later._

[deprecated_export_use](/tools/diagnostics/deprecated_export_use)

: _The ability to import '{0}' indirectly is deprecated._

[deprecated_field](/tools/diagnostics/deprecated_field)

: _The '{0}' field is no longer used and can be removed._

[deprecated_member_use](/tools/diagnostics/deprecated_member_use)

: _'{0}' is deprecated and shouldn't be used._
: _'{0}' is deprecated and shouldn't be used. {1}_

[deprecated_member_use_from_same_package](/tools/diagnostics/deprecated_member_use_from_same_package)

: _'{0}' is deprecated and shouldn't be used._
: _'{0}' is deprecated and shouldn't be used. {1}_

[deprecated_new_in_comment_reference](/tools/diagnostics/deprecated_new_in_comment_reference)

: _Using the 'new' keyword in a comment reference is deprecated._

[deprecated_subtype_of_function](/tools/diagnostics/deprecated_subtype_of_function)

: _Extending 'Function' is deprecated._
: _Implementing 'Function' has no effect._
: _Mixing in 'Function' is deprecated._

[disallowed_type_instantiation_expression](/tools/diagnostics/disallowed_type_instantiation_expression)

: _Only a generic type, generic function, generic instance method, or generic constructor can have type arguments._

[division_optimization](/tools/diagnostics/division_optimization)

: _The operator x ~/ y is more efficient than (x / y).toInt()._

[duplicate_constructor](/tools/diagnostics/duplicate_constructor)

: _The constructor with name '{0}' is already defined._
: _The unnamed constructor is already defined._

[duplicate_definition](/tools/diagnostics/duplicate_definition)

: _The name '{0}' is already defined._

[duplicate_export](/tools/diagnostics/duplicate_export)

: _Duplicate export._

[duplicate_field_formal_parameter](/tools/diagnostics/duplicate_field_formal_parameter)

: _The field '{0}' can't be initialized by multiple parameters in the same constructor._

[duplicate_hidden_name](/tools/diagnostics/duplicate_hidden_name)

: _Duplicate hidden name._

[duplicate_ignore](/tools/diagnostics/duplicate_ignore)

: _The diagnostic '{0}' doesn't need to be ignored here because it's already being ignored._

[duplicate_import](/tools/diagnostics/duplicate_import)

: _Duplicate import._

[duplicate_named_argument](/tools/diagnostics/duplicate_named_argument)

: _The argument for the named parameter '{0}' was already specified._

[duplicate_part](/tools/diagnostics/duplicate_part)

: _The library already contains a part with the URI '{0}'._

[duplicate_shown_name](/tools/diagnostics/duplicate_shown_name)

: _Duplicate shown name._

[empty_struct](/tools/diagnostics/empty_struct)

: _The class '{0}' can't be empty because it's a subclass of '{1}'._

[enum_constant_same_name_as_enclosing](/tools/diagnostics/enum_constant_same_name_as_enclosing)

: _The name of the enum constant can't be the same as the enum's name._

[enum_constant_with_non_const_constructor](/tools/diagnostics/enum_constant_with_non_const_constructor)

: _The invoked constructor isn't a 'const' constructor._

[enum_mixin_with_instance_variable](/tools/diagnostics/enum_mixin_with_instance_variable)

: _Mixins applied to enums can't have instance variables._

[enum_with_abstract_member](/tools/diagnostics/enum_with_abstract_member)

: _'{0}' must have a method body because '{1}' is an enum._

[enum_with_name_values](/tools/diagnostics/enum_with_name_values)

: _The name 'values' is not a valid name for an enum._

[equal_elements_in_const_set](/tools/diagnostics/equal_elements_in_const_set)

: _Two elements in a constant set literal can't be equal._

[equal_elements_in_set](/tools/diagnostics/equal_elements_in_set)

: _Two elements in a set literal shouldn't be equal._

[equal_keys_in_const_map](/tools/diagnostics/equal_keys_in_const_map)

: _Two keys in a constant map literal can't be equal._

[equal_keys_in_map](/tools/diagnostics/equal_keys_in_map)

: _Two keys in a map literal shouldn't be equal._

[expected_one_list_type_arguments](/tools/diagnostics/expected_one_list_type_arguments)

: _List literals require one type argument or none, but {0} found._

[expected_one_set_type_arguments](/tools/diagnostics/expected_one_set_type_arguments)

: _Set literals require one type argument or none, but {0} were found._

[expected_two_map_type_arguments](/tools/diagnostics/expected_two_map_type_arguments)

: _Map literals require two type arguments or none, but {0} found._

[export_internal_library](/tools/diagnostics/export_internal_library)

: _The library '{0}' is internal and can't be exported._

[export_legacy_symbol](/tools/diagnostics/export_legacy_symbol)

: _The symbol '{0}' is defined in a legacy library, and can't be re-exported from a library with null safety enabled._

[export_of_non_library](/tools/diagnostics/export_of_non_library)

: _The exported library '{0}' can't have a part-of directive._

[expression_in_map](/tools/diagnostics/expression_in_map)

: _Expressions can't be used in a map literal._

[extends_non_class](/tools/diagnostics/extends_non_class)

: _Classes can only extend other classes._

[extension_as_expression](/tools/diagnostics/extension_as_expression)

: _Extension '{0}' can't be used as an expression._

[extension_conflicting_static_and_instance](/tools/diagnostics/extension_conflicting_static_and_instance)

: _An extension can't define static member '{0}' and an instance member with the same name._

[extension_declares_abstract_member](/tools/diagnostics/extension_declares_abstract_member)

: _Extensions can't declare abstract members._

[extension_declares_constructor](/tools/diagnostics/extension_declares_constructor)

: _Extensions can't declare constructors._

[extension_declares_instance_field](/tools/diagnostics/extension_declares_instance_field)

: _Extensions can't declare instance fields_

[extension_declares_member_of_object](/tools/diagnostics/extension_declares_member_of_object)

: _Extensions can't declare members with the same name as a member declared by 'Object'._

[extension_override_access_to_static_member](/tools/diagnostics/extension_override_access_to_static_member)

: _An extension override can't be used to access a static member from an extension._

[extension_override_argument_not_assignable](/tools/diagnostics/extension_override_argument_not_assignable)

: _The type of the argument to the extension override '{0}' isn't assignable to the extended type '{1}'._

[extension_override_without_access](/tools/diagnostics/extension_override_without_access)

: _An extension override can only be used to access instance members._

[extension_override_with_cascade](/tools/diagnostics/extension_override_with_cascade)

: _Extension overrides have no value so they can't be used as the receiver of a cascade expression._

[external_with_initializer](/tools/diagnostics/external_with_initializer)

: _External fields can't have initializers._
: _External variables can't have initializers._

[extra_annotation_on_struct_field](/tools/diagnostics/extra_annotation_on_struct_field)

: _Fields in a struct class must have exactly one annotation indicating the native type._

[extra_positional_arguments](/tools/diagnostics/extra_positional_arguments)

: _Too many positional arguments: {0} expected, but {1} found._

[extra_positional_arguments_could_be_named](/tools/diagnostics/extra_positional_arguments_could_be_named)

: _Too many positional arguments: {0} expected, but {1} found._

[extra_size_annotation_carray](/tools/diagnostics/extra_size_annotation_carray)

: _'Array's must have exactly one 'Array' annotation._

[field_initialized_by_multiple_initializers](/tools/diagnostics/field_initialized_by_multiple_initializers)

: _The field '{0}' can't be initialized twice in the same constructor._

[field_initialized_in_initializer_and_declaration](/tools/diagnostics/field_initialized_in_initializer_and_declaration)

: _Fields can't be initialized in the constructor if they are final and were already initialized at their declaration._

[field_initialized_in_parameter_and_initializer](/tools/diagnostics/field_initialized_in_parameter_and_initializer)

: _Fields can't be initialized in both the parameter list and the initializers._

[field_initializer_factory_constructor](/tools/diagnostics/field_initializer_factory_constructor)

: _Initializing formal parameters can't be used in factory constructors._

[field_initializer_in_struct](/tools/diagnostics/field_initializer_in_struct)

: _Constructors in subclasses of 'Struct' and 'Union' can't have field initializers._

[field_initializer_not_assignable](/tools/diagnostics/field_initializer_not_assignable)

: _The initializer type '{0}' can't be assigned to the field type '{1}'._
: _The initializer type '{0}' can't be assigned to the field type '{1}' in a const constructor._

[field_initializer_outside_constructor](/tools/diagnostics/field_initializer_outside_constructor)

: _Initializing formal parameters can only be used in constructors._
: _Field formal parameters can only be used in a constructor._

[field_initializer_redirecting_constructor](/tools/diagnostics/field_initializer_redirecting_constructor)

: _The redirecting constructor can't have a field initializer._

[field_initializing_formal_not_assignable](/tools/diagnostics/field_initializing_formal_not_assignable)

: _The parameter type '{0}' is incompatible with the field type '{1}'._

[field_in_struct_with_initializer](/tools/diagnostics/field_in_struct_with_initializer)

: _Fields in subclasses of 'Struct' and 'Union' can't have initializers._

[field_must_be_external_in_struct](/tools/diagnostics/field_must_be_external_in_struct)

: _Fields of 'Struct' and 'Union' subclasses must be marked external._

[final_initialized_in_declaration_and_constructor](/tools/diagnostics/final_initialized_in_declaration_and_constructor)

: _'{0}' is final and was given a value when it was declared, so it can't be set to a new value._

[final_not_initialized](/tools/diagnostics/final_not_initialized)

: _The final variable '{0}' must be initialized._

[final_not_initialized_constructor](/tools/diagnostics/final_not_initialized_constructor)

: _All final variables must be initialized, but '{0}' isn't._
: _All final variables must be initialized, but '{0}' and '{1}' aren't._
: _All final variables must be initialized, but '{0}', '{1}', and {2} others aren't._

[flutter_field_not_map](/tools/diagnostics/flutter_field_not_map)

: _The value of the 'flutter' field is expected to be a map._

[for_in_of_invalid_element_type](/tools/diagnostics/for_in_of_invalid_element_type)

: _The type '{0}' used in the 'for' loop must implement '{1}' with a type argument that can be assigned to '{2}'._

[for_in_of_invalid_type](/tools/diagnostics/for_in_of_invalid_type)

: _The type '{0}' used in the 'for' loop must implement '{1}'._

[for_in_with_const_variable](/tools/diagnostics/for_in_with_const_variable)

: _A for-in loop variable can't be a 'const'._

[generic_method_type_instantiation_on_dynamic](/tools/diagnostics/generic_method_type_instantiation_on_dynamic)

: _A method tear-off on a receiver whose type is 'dynamic' can't have type arguments._

[generic_struct_subclass](/tools/diagnostics/generic_struct_subclass)

: _The class '{0}' can't extend 'Struct' or 'Union' because '{0}' is generic._

[getter_not_subtype_setter_types](/tools/diagnostics/getter_not_subtype_setter_types)

: _The return type of getter '{0}' is '{1}' which isn't a subtype of the type '{2}' of its setter '{3}'._

[illegal_async_generator_return_type](/tools/diagnostics/illegal_async_generator_return_type)

: _Functions marked 'async*' must have a return type that is a supertype of 'Stream<T>' for some type 'T'._

[illegal_async_return_type](/tools/diagnostics/illegal_async_return_type)

: _Functions marked 'async' must have a return type assignable to 'Future'._

[illegal_concrete_enum_member](/tools/diagnostics/illegal_concrete_enum_member)

: _A concrete instance member named '{0}' can't be declared in a class that implements 'Enum'._
: _A concrete instance member named '{0}' can't be inherited from '{1}' in a class that implements 'Enum'._

[illegal_enum_values](/tools/diagnostics/illegal_enum_values)

: _An instance member named 'values' can't be declared in a class that implements 'Enum'._
: _An instance member named 'values' can't be inherited from '{0}' in a class that implements 'Enum'._

[illegal_sync_generator_return_type](/tools/diagnostics/illegal_sync_generator_return_type)

: _Functions marked 'sync*' must have a return type that is a supertype of 'Iterable<T>' for some type 'T'._

[implements_non_class](/tools/diagnostics/implements_non_class)

: _Classes and mixins can only implement other classes and mixins._

[implements_repeated](/tools/diagnostics/implements_repeated)

: _'{0}' can only be implemented once._

[implements_super_class](/tools/diagnostics/implements_super_class)

: _'{0}' can't be used in both the 'extends' and 'implements' clauses._
: _'{0}' can't be used in both the 'extends' and 'with' clauses._

[implicit_super_initializer_missing_arguments](/tools/diagnostics/implicit_super_initializer_missing_arguments)

: _The implicitly invoked unnamed constructor from '{0}' has required parameters._

[implicit_this_reference_in_initializer](/tools/diagnostics/implicit_this_reference_in_initializer)

: _The instance member '{0}' can't be accessed in an initializer._

[import_deferred_library_with_load_function](/tools/diagnostics/import_deferred_library_with_load_function)

: _The imported library defines a top-level function named 'loadLibrary' that is hidden by deferring this library._

[import_internal_library](/tools/diagnostics/import_internal_library)

: _The library '{0}' is internal and can't be imported._

[import_of_legacy_library_into_null_safe](/tools/diagnostics/import_of_legacy_library_into_null_safe)

: _The library '{0}' is legacy, and shouldn't be imported into a null safe library._

[import_of_non_library](/tools/diagnostics/import_of_non_library)

: _The imported library '{0}' can't have a part-of directive._

[inconsistent_inheritance](/tools/diagnostics/inconsistent_inheritance)

: _Superinterfaces don't have a valid override for '{0}': {1}._

[inconsistent_language_version_override](/tools/diagnostics/inconsistent_language_version_override)

: _Parts must have exactly the same language version override as the library._

[initializer_for_non_existent_field](/tools/diagnostics/initializer_for_non_existent_field)

: _'{0}' isn't a field in the enclosing class._

[initializer_for_static_field](/tools/diagnostics/initializer_for_static_field)

: _'{0}' is a static field in the enclosing class. Fields initialized in a constructor can't be static._

[initializing_formal_for_non_existent_field](/tools/diagnostics/initializing_formal_for_non_existent_field)

: _'{0}' isn't a field in the enclosing class._

[instance_access_to_static_member](/tools/diagnostics/instance_access_to_static_member)

: _The static {1} '{0}' can't be accessed through an instance._

[instance_member_access_from_factory](/tools/diagnostics/instance_member_access_from_factory)

: _Instance members can't be accessed from a factory constructor._

[instance_member_access_from_static](/tools/diagnostics/instance_member_access_from_static)

: _Instance members can't be accessed from a static method._

[instantiate_abstract_class](/tools/diagnostics/instantiate_abstract_class)

: _Abstract classes can't be instantiated._

[instantiate_enum](/tools/diagnostics/instantiate_enum)

: _Enums can't be instantiated._

[instantiate_type_alias_expands_to_type_parameter](/tools/diagnostics/instantiate_type_alias_expands_to_type_parameter)

: _Type aliases that expand to a type parameter can't be instantiated._

[integer_literal_imprecise_as_double](/tools/diagnostics/integer_literal_imprecise_as_double)

: _The integer literal is being used as a double, but can't be represented as a 64-bit double without overflow or loss of precision: '{0}'._

[integer_literal_out_of_range](/tools/diagnostics/integer_literal_out_of_range)

: _The integer literal {0} can't be represented in 64 bits._

[invalid_annotation](/tools/diagnostics/invalid_annotation)

: _Annotation must be either a const variable reference or const constructor invocation._

[invalid_annotation_constant_value_from_deferred_library](/tools/diagnostics/invalid_annotation_constant_value_from_deferred_library)

: _Constant values from a deferred library can't be used in annotations._

[invalid_annotation_from_deferred_library](/tools/diagnostics/invalid_annotation_from_deferred_library)

: _Constant values from a deferred library can't be used as annotations._

[invalid_annotation_target](/tools/diagnostics/invalid_annotation_target)

: _The annotation '{0}' can only be used on {1}._

[invalid_assignment](/tools/diagnostics/invalid_assignment)

: _A value of type '{0}' can't be assigned to a variable of type '{1}'._

[invalid_dependency](/tools/diagnostics/invalid_dependency)

: _Publishable packages can't have '{0}' dependencies._

[invalid_exception_value](/tools/diagnostics/invalid_exception_value)

: _The method 'Pointer.fromFunction' can't have an exceptional return value (the second argument) when the return type of the function is either 'void', 'Handle' or 'Pointer'._

[invalid_export_of_internal_element](/tools/diagnostics/invalid_export_of_internal_element)

: _The member '{0}' can't be exported as a part of a package's public API._

[invalid_export_of_internal_element_indirectly](/tools/diagnostics/invalid_export_of_internal_element_indirectly)

: _The member '{0}' can't be exported as a part of a package's public API, but is indirectly exported as part of the signature of '{1}'._

[invalid_extension_argument_count](/tools/diagnostics/invalid_extension_argument_count)

: _Extension overrides must have exactly one argument: the value of 'this' in the extension method._

[invalid_factory_method_decl](/tools/diagnostics/invalid_factory_method_decl)

: _Factory method '{0}' must have a return type._

[invalid_factory_method_impl](/tools/diagnostics/invalid_factory_method_impl)

: _Factory method '{0}' doesn't return a newly allocated object._

[invalid_factory_name_not_a_class](/tools/diagnostics/invalid_factory_name_not_a_class)

: _The name of a factory constructor must be the same as the name of the immediately enclosing class._

[invalid_field_type_in_struct](/tools/diagnostics/invalid_field_type_in_struct)

: _Fields in struct classes can't have the type '{0}'. They can only be declared as 'int', 'double', 'Array', 'Pointer', or subtype of 'Struct' or 'Union'._

[invalid_implementation_override](/tools/diagnostics/invalid_implementation_override)

: _'{1}.{0}' ('{2}') isn't a valid concrete implementation of '{3}.{0}' ('{4}')._
: _The setter '{1}.{0}' ('{2}') isn't a valid concrete implementation of '{3}.{0}' ('{4}')._

[invalid_inline_function_type](/tools/diagnostics/invalid_inline_function_type)

: _Inline function types can't be used for parameters in a generic function type._

[invalid_internal_annotation](/tools/diagnostics/invalid_internal_annotation)

: _Only public elements in a package's private API can be annotated as being internal._

[invalid_language_version_override](/tools/diagnostics/invalid_language_version_override)

: _The language version override can't specify a version greater than the latest known language version: {0}.{1}._
: _The Dart language version override number must begin with '@dart'._
: _The language version override must be specified before any declaration or directive._
: _The Dart language version override comment must be specified with the word 'dart' in all lower case._
: _The Dart language version override comment must be specified with a version number, like '2.0', after the '=' character._
: _The Dart language version override number can't be prefixed with a letter._
: _The Dart language version override comment can't be followed by any non-whitespace characters._
: _The Dart language version override comment must be specified with exactly two slashes._
: _The Dart language version override comment must be specified with an '=' character._

[invalid_literal_annotation](/tools/diagnostics/invalid_literal_annotation)

: _Only const constructors can have the `@literal` annotation._

[invalid_modifier_on_constructor](/tools/diagnostics/invalid_modifier_on_constructor)

: _The modifier '{0}' can't be applied to the body of a constructor._

[invalid_modifier_on_setter](/tools/diagnostics/invalid_modifier_on_setter)

: _Setters can't use 'async', 'async*', or 'sync*'._

[invalid_non_virtual_annotation](/tools/diagnostics/invalid_non_virtual_annotation)

: _The annotation '@nonVirtual' can only be applied to a concrete instance member._

[invalid_null_aware_operator](/tools/diagnostics/invalid_null_aware_operator)

: _The receiver can't be null, so the null-aware operator '{0}' is unnecessary._
: _The receiver can't be null because of short-circuiting, so the null-aware operator '{0}' can't be used._

[invalid_override](/tools/diagnostics/invalid_override)

: _'{1}.{0}' ('{2}') isn't a valid override of '{3}.{0}' ('{4}')._
: _The setter '{1}.{0}' ('{2}') isn't a valid override of '{3}.{0}' ('{4}')._

[invalid_override_of_non_virtual_member](/tools/diagnostics/invalid_override_of_non_virtual_member)

: _The member '{0}' is declared non-virtual in '{1}' and can't be overridden in subclasses._

[invalid_reference_to_generative_enum_constructor](/tools/diagnostics/invalid_reference_to_generative_enum_constructor)

: _Generative enum constructors can only be used as targets of redirection._

[invalid_reference_to_this](/tools/diagnostics/invalid_reference_to_this)

: _Invalid reference to 'this' expression._

[invalid_return_type_for_catch_error](/tools/diagnostics/invalid_return_type_for_catch_error)

: _The return type '{0}' isn't assignable to '{1}', as required by 'Future.catchError'._
: _A value of type '{0}' can't be returned by the 'onError' handler because it must be assignable to '{1}'._

[invalid_sealed_annotation](/tools/diagnostics/invalid_sealed_annotation)

: _The annotation '@sealed' can only be applied to classes._

[invalid_super_formal_parameter_location](/tools/diagnostics/invalid_super_formal_parameter_location)

: _Super parameters can only be used in non-redirecting generative constructors._

[invalid_type_argument_in_const_literal](/tools/diagnostics/invalid_type_argument_in_const_literal)

: _Constant list literals can't include a type parameter as a type argument, such as '{0}'._
: _Constant map literals can't include a type parameter as a type argument, such as '{0}'._
: _Constant set literals can't include a type parameter as a type argument, such as '{0}'._

[invalid_uri](/tools/diagnostics/invalid_uri)

: _Invalid URI syntax: '{0}'._

[invalid_use_of_covariant_in_extension](/tools/diagnostics/invalid_use_of_covariant_in_extension)

: _Can't have modifier '{0}' in an extension._

[invalid_use_of_internal_member](/tools/diagnostics/invalid_use_of_internal_member)

: _The member '{0}' can only be used within its package._

[invalid_use_of_null_value](/tools/diagnostics/invalid_use_of_null_value)

: _An expression whose value is always 'null' can't be dereferenced._

[invalid_use_of_visible_for_overriding_member](/tools/diagnostics/invalid_use_of_visible_for_overriding_member)

: _The member '{0}' can only be used for overriding._

[invalid_use_of_visible_for_testing_member](/tools/diagnostics/invalid_use_of_visible_for_testing_member)

: _The member '{0}' can only be used within '{1}' or a test._

[invalid_visibility_annotation](/tools/diagnostics/invalid_visibility_annotation)

: _The member '{0}' is annotated with '{1}', but this annotation is only meaningful on declarations of public members._

[invalid_visible_for_overriding_annotation](/tools/diagnostics/invalid_visible_for_overriding_annotation)

: _The annotation 'visibleForOverriding' can only be applied to a public instance member that can be overridden._

[invocation_of_extension_without_call](/tools/diagnostics/invocation_of_extension_without_call)

: _The extension '{0}' doesn't define a 'call' method so the override can't be used in an invocation._

[invocation_of_non_function](/tools/diagnostics/invocation_of_non_function)

: _'{0}' isn't a function._

[invocation_of_non_function_expression](/tools/diagnostics/invocation_of_non_function_expression)

: _The expression doesn't evaluate to a function, so it can't be invoked._

[label_in_outer_scope](/tools/diagnostics/label_in_outer_scope)

: _Can't reference label '{0}' declared in an outer method._

[label_undefined](/tools/diagnostics/label_undefined)

: _Can't reference an undefined label '{0}'._

[late_final_field_with_const_constructor](/tools/diagnostics/late_final_field_with_const_constructor)

: _Can't have a late final field in a class with a generative const constructor._

[late_final_local_already_assigned](/tools/diagnostics/late_final_local_already_assigned)

: _The late final local variable is already assigned._

[leaf_call_must_not_return_handle](/tools/diagnostics/leaf_call_must_not_return_handle)

: _FFI leaf call can't return a 'Handle'._

[leaf_call_must_not_take_handle](/tools/diagnostics/leaf_call_must_not_take_handle)

: _FFI leaf call can't take arguments of type 'Handle'._

[list_element_type_not_assignable](/tools/diagnostics/list_element_type_not_assignable)

: _The element type '{0}' can't be assigned to the list type '{1}'._

[main_first_positional_parameter_type](/tools/diagnostics/main_first_positional_parameter_type)

: _The type of the first positional parameter of the 'main' function must be a supertype of 'List<String>'._

[main_has_required_named_parameters](/tools/diagnostics/main_has_required_named_parameters)

: _The function 'main' can't have any required named parameters._

[main_has_too_many_required_positional_parameters](/tools/diagnostics/main_has_too_many_required_positional_parameters)

: _The function 'main' can't have more than two required positional parameters._

[main_is_not_function](/tools/diagnostics/main_is_not_function)

: _The declaration named 'main' must be a function._

[map_entry_not_in_map](/tools/diagnostics/map_entry_not_in_map)

: _Map entries can only be used in a map literal._

[map_key_type_not_assignable](/tools/diagnostics/map_key_type_not_assignable)

: _The element type '{0}' can't be assigned to the map key type '{1}'._

[map_value_type_not_assignable](/tools/diagnostics/map_value_type_not_assignable)

: _The element type '{0}' can't be assigned to the map value type '{1}'._

[mismatched_annotation_on_struct_field](/tools/diagnostics/mismatched_annotation_on_struct_field)

: _The annotation doesn't match the declared type of the field._

[missing_annotation_on_struct_field](/tools/diagnostics/missing_annotation_on_struct_field)

: _Fields of type '{0}' in a subclass of '{1}' must have an annotation indicating the native type._

[missing_dart_library](/tools/diagnostics/missing_dart_library)

: _Required library '{0}' is missing._

[missing_default_value_for_parameter](/tools/diagnostics/missing_default_value_for_parameter)

: _The parameter '{0}' can't have a value of 'null' because of its type, but the implicit default value is 'null'._
: _With null safety, use the 'required' keyword, not the '@required' annotation._

[missing_enum_constant_in_switch](/tools/diagnostics/missing_enum_constant_in_switch)

: _Missing case clause for '{0}'._

[missing_exception_value](/tools/diagnostics/missing_exception_value)

: _The method 'Pointer.fromFunction' must have an exceptional return value (the second argument) when the return type of the function is neither 'void', 'Handle', nor 'Pointer'._

[missing_field_type_in_struct](/tools/diagnostics/missing_field_type_in_struct)

: _Fields in struct classes must have an explicitly declared type of 'int', 'double' or 'Pointer'._

[missing_name](/tools/diagnostics/missing_name)

: _The 'name' field is required but missing._

[missing_override_of_must_be_overridden](/tools/diagnostics/missing_override_of_must_be_overridden)

: _Missing concrete implementation of '{0}'._
: _Missing concrete implementations of '{0}' and '{1}'._
: _Missing concrete implementations of '{0}', '{1}', and {2} more._

[missing_required_argument](/tools/diagnostics/missing_required_argument)

: _The named parameter '{0}' is required, but there's no corresponding argument._

[missing_required_param](/tools/diagnostics/missing_required_param)

: _The parameter '{0}' is required._
: _The parameter '{0}' is required. {1}._

[missing_return](/tools/diagnostics/missing_return)

: _This function has a return type of '{0}', but doesn't end with a return statement._

[missing_size_annotation_carray](/tools/diagnostics/missing_size_annotation_carray)

: _Fields of type 'Array' must have exactly one 'Array' annotation._

[mixin_application_concrete_super_invoked_member_type](/tools/diagnostics/mixin_application_concrete_super_invoked_member_type)

: _The super-invoked member '{0}' has the type '{1}', and the concrete member in the class has the type '{2}'._

[mixin_application_not_implemented_interface](/tools/diagnostics/mixin_application_not_implemented_interface)

: _'{0}' can't be mixed onto '{1}' because '{1}' doesn't implement '{2}'._

[mixin_application_no_concrete_super_invoked_member](/tools/diagnostics/mixin_application_no_concrete_super_invoked_member)

: _The class doesn't have a concrete implementation of the super-invoked setter '{0}'._
: _The class doesn't have a concrete implementation of the super-invoked member '{0}'._

[mixin_class_declares_constructor](/tools/diagnostics/mixin_class_declares_constructor)

: _The class '{0}' can't be used as a mixin because it declares a constructor._

[mixin_inherits_from_not_object](/tools/diagnostics/mixin_inherits_from_not_object)

: _The class '{0}' can't be used as a mixin because it extends a class other than 'Object'._

[mixin_instantiate](/tools/diagnostics/mixin_instantiate)

: _Mixins can't be instantiated._

[mixin_of_non_class](/tools/diagnostics/mixin_of_non_class)

: _Classes can only mix in mixins and classes._

[mixin_on_sealed_class](/tools/diagnostics/mixin_on_sealed_class)

: _The class '{0}' shouldn't be used as a mixin constraint because it is sealed, and any class mixing in this mixin must have '{0}' as a superclass._

[mixin_super_class_constraint_deferred_class](/tools/diagnostics/mixin_super_class_constraint_deferred_class)

: _Deferred classes can't be used as superclass constraints._

[mixin_super_class_constraint_non_interface](/tools/diagnostics/mixin_super_class_constraint_non_interface)

: _Only classes and mixins can be used as superclass constraints._

[multiple_redirecting_constructor_invocations](/tools/diagnostics/multiple_redirecting_constructor_invocations)

: _Constructors can have only one 'this' redirection, at most._

[multiple_super_initializers](/tools/diagnostics/multiple_super_initializers)

: _A constructor can have at most one 'super' initializer._

[must_be_a_native_function_type](/tools/diagnostics/must_be_a_native_function_type)

: _The type '{0}' given to '{1}' must be a valid 'dart:ffi' native function type._

[must_be_a_subtype](/tools/diagnostics/must_be_a_subtype)

: _The type '{0}' must be a subtype of '{1}' for '{2}'._

[must_be_immutable](/tools/diagnostics/must_be_immutable)

: _This class (or a class that this class inherits from) is marked as '@immutable', but one or more of its instance fields aren't final: {0}_

[must_call_super](/tools/diagnostics/must_call_super)

: _This method overrides a method annotated as '@mustCallSuper' in '{0}', but doesn't invoke the overridden method._

[name_not_string](/tools/diagnostics/name_not_string)

: _The value of the 'name' field is required to be a string._

[new_with_undefined_constructor_default](/tools/diagnostics/new_with_undefined_constructor_default)

: _The class '{0}' doesn't have an unnamed constructor._

[non_abstract_class_inherits_abstract_member](/tools/diagnostics/non_abstract_class_inherits_abstract_member)

: _Missing concrete implementations of '{0}', '{1}', '{2}', '{3}', and {4} more._
: _Missing concrete implementations of '{0}', '{1}', '{2}', and '{3}'._
: _Missing concrete implementation of '{0}'._
: _Missing concrete implementations of '{0}', '{1}', and '{2}'._
: _Missing concrete implementations of '{0}' and '{1}'._

[non_bool_condition](/tools/diagnostics/non_bool_condition)

: _Conditions must have a static type of 'bool'._

[non_bool_expression](/tools/diagnostics/non_bool_expression)

: _The expression in an assert must be of type 'bool'._

[non_bool_negation_expression](/tools/diagnostics/non_bool_negation_expression)

: _A negation operand must have a static type of 'bool'._

[non_bool_operand](/tools/diagnostics/non_bool_operand)

: _The operands of the operator '{0}' must be assignable to 'bool'._

[non_constant_annotation_constructor](/tools/diagnostics/non_constant_annotation_constructor)

: _Annotation creation can only call a const constructor._

[non_constant_case_expression](/tools/diagnostics/non_constant_case_expression)

: _Case expressions must be constant._

[non_constant_case_expression_from_deferred_library](/tools/diagnostics/non_constant_case_expression_from_deferred_library)

: _Constant values from a deferred library can't be used as a case expression._

[non_constant_default_value](/tools/diagnostics/non_constant_default_value)

: _The default value of an optional parameter must be constant._

[non_constant_default_value_from_deferred_library](/tools/diagnostics/non_constant_default_value_from_deferred_library)

: _Constant values from a deferred library can't be used as a default parameter value._

[non_constant_list_element](/tools/diagnostics/non_constant_list_element)

: _The values in a const list literal must be constants._

[non_constant_map_element](/tools/diagnostics/non_constant_map_element)

: _The elements in a const map literal must be constant._

[non_constant_map_key](/tools/diagnostics/non_constant_map_key)

: _The keys in a const map literal must be constant._

[non_constant_map_value](/tools/diagnostics/non_constant_map_value)

: _The values in a const map literal must be constant._

[non_constant_set_element](/tools/diagnostics/non_constant_set_element)

: _The values in a const set literal must be constants._

[non_constant_type_argument](/tools/diagnostics/non_constant_type_argument)

: _The type arguments to '{0}' must be known at compile time, so they can't be type parameters._

[non_const_call_to_literal_constructor](/tools/diagnostics/non_const_call_to_literal_constructor)

: _This instance creation must be 'const', because the {0} constructor is marked as '@literal'._

[non_const_generative_enum_constructor](/tools/diagnostics/non_const_generative_enum_constructor)

: _Generative enum constructors must be 'const'._

[non_final_field_in_enum](/tools/diagnostics/non_final_field_in_enum)

: _Enums can only declare final fields._

[non_generative_constructor](/tools/diagnostics/non_generative_constructor)

: _The generative constructor '{0}' is expected, but a factory was found._

[non_generative_implicit_constructor](/tools/diagnostics/non_generative_implicit_constructor)

: _The unnamed constructor of superclass '{0}' (called by the default constructor of '{1}') must be a generative constructor, but factory found._

[non_native_function_type_argument_to_pointer](/tools/diagnostics/non_native_function_type_argument_to_pointer)

: _Can't invoke 'asFunction' because the function signature '{0}' for the pointer isn't a valid C function signature._

[non_positive_array_dimension](/tools/diagnostics/non_positive_array_dimension)

: _Array dimensions must be positive numbers._

[non_sized_type_argument](/tools/diagnostics/non_sized_type_argument)

: _The type '{1}' isn't a valid type argument for '{0}'. The type argument must be a native integer, 'Float', 'Double', 'Pointer', or subtype of 'Struct', 'Union', or 'AbiSpecificInteger'._

[non_sync_factory](/tools/diagnostics/non_sync_factory)

: _Factory bodies can't use 'async', 'async*', or 'sync*'._

[non_type_as_type_argument](/tools/diagnostics/non_type_as_type_argument)

: _The name '{0}' isn't a type, so it can't be used as a type argument._

[non_type_in_catch_clause](/tools/diagnostics/non_type_in_catch_clause)

: _The name '{0}' isn't a type and can't be used in an on-catch clause._

[non_void_return_for_operator](/tools/diagnostics/non_void_return_for_operator)

: _The return type of the operator []= must be 'void'._

[non_void_return_for_setter](/tools/diagnostics/non_void_return_for_setter)

: _The return type of the setter must be 'void' or absent._

[not_assigned_potentially_non_nullable_local_variable](/tools/diagnostics/not_assigned_potentially_non_nullable_local_variable)

: _The non-nullable local variable '{0}' must be assigned before it can be used._

[not_a_type](/tools/diagnostics/not_a_type)

: _{0} isn't a type._

[not_binary_operator](/tools/diagnostics/not_binary_operator)

: _'{0}' isn't a binary operator._

[not_enough_positional_arguments](/tools/diagnostics/not_enough_positional_arguments)

: _1 positional argument expected, but 0 found._
: _{0} positional arguments expected, but {1} found._
: _1 positional argument expected by '{0}', but 0 found._
: _{0} positional arguments expected by '{2}', but {1} found._

[not_initialized_non_nullable_instance_field](/tools/diagnostics/not_initialized_non_nullable_instance_field)

: _Non-nullable instance field '{0}' must be initialized._

[not_initialized_non_nullable_variable](/tools/diagnostics/not_initialized_non_nullable_variable)

: _The non-nullable variable '{0}' must be initialized._

[not_iterable_spread](/tools/diagnostics/not_iterable_spread)

: _Spread elements in list or set literals must implement 'Iterable'._

[not_map_spread](/tools/diagnostics/not_map_spread)

: _Spread elements in map literals must implement 'Map'._

[no_annotation_constructor_arguments](/tools/diagnostics/no_annotation_constructor_arguments)

: _Annotation creation must have arguments._

[no_combined_super_signature](/tools/diagnostics/no_combined_super_signature)

: _Can't infer missing types in '{0}' from overridden methods: {1}._

[no_generative_constructors_in_superclass](/tools/diagnostics/no_generative_constructors_in_superclass)

: _The class '{0}' can't extend '{1}' because '{1}' only has factory constructors (no generative constructors), and '{0}' has at least one generative constructor._

[nullable_type_in_catch_clause](/tools/diagnostics/nullable_type_in_catch_clause)

: _A potentially nullable type can't be used in an 'on' clause because it isn't valid to throw a nullable expression._

[nullable_type_in_extends_clause](/tools/diagnostics/nullable_type_in_extends_clause)

: _A class can't extend a nullable type._

[nullable_type_in_implements_clause](/tools/diagnostics/nullable_type_in_implements_clause)

: _A class or mixin can't implement a nullable type._

[nullable_type_in_on_clause](/tools/diagnostics/nullable_type_in_on_clause)

: _A mixin can't have a nullable type as a superclass constraint._

[nullable_type_in_with_clause](/tools/diagnostics/nullable_type_in_with_clause)

: _A class or mixin can't mix in a nullable type._

[null_argument_to_non_null_type](/tools/diagnostics/null_argument_to_non_null_type)

: _'{0}' shouldn't be called with a null argument for the non-nullable type argument '{1}'._

[null_check_always_fails](/tools/diagnostics/null_check_always_fails)

: _This null-check will always throw an exception because the expression will always evaluate to 'null'._

[obsolete_colon_for_default_value](/tools/diagnostics/obsolete_colon_for_default_value)

: _Using a colon as a separator before a default value is no longer supported._

[on_repeated](/tools/diagnostics/on_repeated)

: _The type '{0}' can be included in the superclass constraints only once._

[optional_parameter_in_operator](/tools/diagnostics/optional_parameter_in_operator)

: _Optional parameters aren't allowed when defining an operator._

[override_on_non_overriding_member](/tools/diagnostics/override_on_non_overriding_member)

: _The field doesn't override an inherited getter or setter._
: _The getter doesn't override an inherited getter._
: _The method doesn't override an inherited method._
: _The setter doesn't override an inherited setter._

[packed_annotation](/tools/diagnostics/packed_annotation)

: _Structs must have at most one 'Packed' annotation._

[packed_annotation_alignment](/tools/diagnostics/packed_annotation_alignment)

: _Only packing to 1, 2, 4, 8, and 16 bytes is supported._

[part_of_different_library](/tools/diagnostics/part_of_different_library)

: _Expected this library to be part of '{0}', not '{1}'._

[part_of_non_part](/tools/diagnostics/part_of_non_part)

: _The included part '{0}' must have a part-of directive._

[part_of_unnamed_library](/tools/diagnostics/part_of_unnamed_library)

: _The library is unnamed. A URI is expected, not a library name '{0}', in the part-of directive._

[path_does_not_exist](/tools/diagnostics/path_does_not_exist)

: _The path '{0}' doesn't exist._

[path_not_posix](/tools/diagnostics/path_not_posix)

: _The path '{0}' isn't a POSIX-style path._

[path_pubspec_does_not_exist](/tools/diagnostics/path_pubspec_does_not_exist)

: _The directory '{0}' doesn't contain a pubspec._

[positional_super_formal_parameter_with_positional_argument](/tools/diagnostics/positional_super_formal_parameter_with_positional_argument)

: _Positional super parameters can't be used when the super constructor invocation has a positional argument._

[prefix_collides_with_top_level_member](/tools/diagnostics/prefix_collides_with_top_level_member)

: _The name '{0}' is already used as an import prefix and can't be used to name a top-level element._

[prefix_identifier_not_followed_by_dot](/tools/diagnostics/prefix_identifier_not_followed_by_dot)

: _The name '{0}' refers to an import prefix, so it must be followed by '.'._

[prefix_shadowed_by_local_declaration](/tools/diagnostics/prefix_shadowed_by_local_declaration)

: _The prefix '{0}' can't be used here because it's shadowed by a local declaration._

[private_collision_in_mixin_application](/tools/diagnostics/private_collision_in_mixin_application)

: _The private name '{0}', defined by '{1}', conflicts with the same name defined by '{2}'._

[private_optional_parameter](/tools/diagnostics/private_optional_parameter)

: _Named parameters can't start with an underscore._

[private_setter](/tools/diagnostics/private_setter)

: _The setter '{0}' is private and can't be accessed outside the library that declares it._

[read_potentially_unassigned_final](/tools/diagnostics/read_potentially_unassigned_final)

: _The final variable '{0}' can't be read because it's potentially unassigned at this point._

[recursive_compile_time_constant](/tools/diagnostics/recursive_compile_time_constant)

: _The compile-time constant expression depends on itself._

[recursive_constructor_redirect](/tools/diagnostics/recursive_constructor_redirect)

: _Constructors can't redirect to themselves either directly or indirectly._

[recursive_interface_inheritance](/tools/diagnostics/recursive_interface_inheritance)

: _'{0}' can't be a superinterface of itself: {1}._
: _'{0}' can't extend itself._
: _'{0}' can't implement itself._
: _'{0}' can't use itself as a superclass constraint._
: _'{0}' can't use itself as a mixin._

[redirect_generative_to_missing_constructor](/tools/diagnostics/redirect_generative_to_missing_constructor)

: _The constructor '{0}' couldn't be found in '{1}'._

[redirect_generative_to_non_generative_constructor](/tools/diagnostics/redirect_generative_to_non_generative_constructor)

: _Generative constructors can't redirect to a factory constructor._

[redirect_to_abstract_class_constructor](/tools/diagnostics/redirect_to_abstract_class_constructor)

: _The redirecting constructor '{0}' can't redirect to a constructor of the abstract class '{1}'._

[redirect_to_invalid_function_type](/tools/diagnostics/redirect_to_invalid_function_type)

: _The redirected constructor '{0}' has incompatible parameters with '{1}'._

[redirect_to_invalid_return_type](/tools/diagnostics/redirect_to_invalid_return_type)

: _The return type '{0}' of the redirected constructor isn't a subtype of '{1}'._

[redirect_to_missing_constructor](/tools/diagnostics/redirect_to_missing_constructor)

: _The constructor '{0}' couldn't be found in '{1}'._

[redirect_to_non_class](/tools/diagnostics/redirect_to_non_class)

: _The name '{0}' isn't a type and can't be used in a redirected constructor._

[redirect_to_non_const_constructor](/tools/diagnostics/redirect_to_non_const_constructor)

: _A constant redirecting constructor can't redirect to a non-constant constructor._

[redirect_to_type_alias_expands_to_type_parameter](/tools/diagnostics/redirect_to_type_alias_expands_to_type_parameter)

: _A redirecting constructor can't redirect to a type alias that expands to a type parameter._

[referenced_before_declaration](/tools/diagnostics/referenced_before_declaration)

: _Local variable '{0}' can't be referenced before it is declared._

[rethrow_outside_catch](/tools/diagnostics/rethrow_outside_catch)

: _A rethrow must be inside of a catch clause._

[return_in_generative_constructor](/tools/diagnostics/return_in_generative_constructor)

: _Constructors can't return values._

[return_in_generator](/tools/diagnostics/return_in_generator)

: _Can't return a value from a generator function that uses the 'async*' or 'sync*' modifier._

[return_of_do_not_store](/tools/diagnostics/return_of_do_not_store)

: _'{0}' is annotated with 'doNotStore' and shouldn't be returned unless '{1}' is also annotated._

[return_of_invalid_type](/tools/diagnostics/return_of_invalid_type)

: _A value of type '{0}' can't be returned from the constructor '{2}' because it has a return type of '{1}'._
: _A value of type '{0}' can't be returned from the function '{2}' because it has a return type of '{1}'._
: _A value of type '{0}' can't be returned from the method '{2}' because it has a return type of '{1}'._

[return_of_invalid_type_from_closure](/tools/diagnostics/return_of_invalid_type_from_closure)

: _The return type '{0}' isn't a '{1}', as required by the closure's context._

[return_without_value](/tools/diagnostics/return_without_value)

: _The return value is missing after 'return'._

[sdk_version_async_exported_from_core](/tools/diagnostics/sdk_version_async_exported_from_core)

: _The class '{0}' wasn't exported from 'dart:core' until version 2.1, but this code is required to be able to run on earlier versions._

[sdk_version_as_expression_in_const_context](/tools/diagnostics/sdk_version_as_expression_in_const_context)

: _The use of an as expression in a constant expression wasn't supported until version 2.3.2, but this code is required to be able to run on earlier versions._

[sdk_version_bool_operator_in_const_context](/tools/diagnostics/sdk_version_bool_operator_in_const_context)

: _The use of the operator '{0}' for 'bool' operands in a constant context wasn't supported until version 2.3.2, but this code is required to be able to run on earlier versions._

[sdk_version_constructor_tearoffs](/tools/diagnostics/sdk_version_constructor_tearoffs)

: _Tearing off a constructor requires the 'constructor-tearoffs' language feature._

[sdk_version_eq_eq_operator_in_const_context](/tools/diagnostics/sdk_version_eq_eq_operator_in_const_context)

: _Using the operator '==' for non-primitive types wasn't supported until version 2.3.2, but this code is required to be able to run on earlier versions._

[sdk_version_extension_methods](/tools/diagnostics/sdk_version_extension_methods)

: _Extension methods weren't supported until version 2.6.0, but this code is required to be able to run on earlier versions._

[sdk_version_gt_gt_gt_operator](/tools/diagnostics/sdk_version_gt_gt_gt_operator)

: _The operator '>>>' wasn't supported until version 2.14.0, but this code is required to be able to run on earlier versions._

[sdk_version_is_expression_in_const_context](/tools/diagnostics/sdk_version_is_expression_in_const_context)

: _The use of an is expression in a constant context wasn't supported until version 2.3.2, but this code is required to be able to run on earlier versions._

[sdk_version_never](/tools/diagnostics/sdk_version_never)

: _The type 'Never' wasn't supported until version 2.12.0, but this code is required to be able to run on earlier versions._

[sdk_version_set_literal](/tools/diagnostics/sdk_version_set_literal)

: _Set literals weren't supported until version 2.2, but this code is required to be able to run on earlier versions._

[sdk_version_ui_as_code](/tools/diagnostics/sdk_version_ui_as_code)

: _The for, if, and spread elements weren't supported until version 2.3.0, but this code is required to be able to run on earlier versions._

[sdk_version_ui_as_code_in_const_context](/tools/diagnostics/sdk_version_ui_as_code_in_const_context)

: _The if and spread elements weren't supported in constant expressions until version 2.5.0, but this code is required to be able to run on earlier versions._

[set_element_type_not_assignable](/tools/diagnostics/set_element_type_not_assignable)

: _The element type '{0}' can't be assigned to the set type '{1}'._

[shared_deferred_prefix](/tools/diagnostics/shared_deferred_prefix)

: _The prefix of a deferred import can't be used in other import directives._

[size_annotation_dimensions](/tools/diagnostics/size_annotation_dimensions)

: _'Array's must have an 'Array' annotation that matches the dimensions._

[static_access_to_instance_member](/tools/diagnostics/static_access_to_instance_member)

: _Instance member '{0}' can't be accessed using static access._

[subtype_of_deferred_class](/tools/diagnostics/subtype_of_deferred_class)

: _Classes and mixins can't implement deferred classes._
: _Classes can't mixin deferred classes._
: _Classes can't extend deferred classes._

[subtype_of_disallowed_type](/tools/diagnostics/subtype_of_disallowed_type)

: _Classes can't extend '{0}'._
: _Classes can't mixin '{0}'._
: _'{0}' can't be used as a superclass constraint._
: _Classes and mixins can't implement '{0}'._

[subtype_of_ffi_class](/tools/diagnostics/subtype_of_ffi_class)

: _The class '{0}' can't extend '{1}'._
: _The class '{0}' can't implement '{1}'._
: _The class '{0}' can't mix in '{1}'._

[subtype_of_sealed_class](/tools/diagnostics/subtype_of_sealed_class)

: _The class '{0}' shouldn't be extended, mixed in, or implemented because it's sealed._

[subtype_of_struct_class](/tools/diagnostics/subtype_of_struct_class)

: _The class '{0}' can't extend '{1}' because '{1}' is a subtype of 'Struct', 'Union', or 'AbiSpecificInteger'._
: _The class '{0}' can't implement '{1}' because '{1}' is a subtype of 'Struct', 'Union', or 'AbiSpecificInteger'._
: _The class '{0}' can't mix in '{1}' because '{1}' is a subtype of 'Struct', 'Union', or 'AbiSpecificInteger'._

[supertype_expands_to_type_parameter](/tools/diagnostics/supertype_expands_to_type_parameter)

: _A type alias that expands to a type parameter can't be used as a superclass._
: _A type alias that expands to a type parameter can't be used as a superclass constraint._
: _A type alias that expands to a type parameter can't be mixed in._
: _A type alias that expands to a type parameter can't be implemented._

[super_formal_parameter_type_is_not_subtype_of_associated](/tools/diagnostics/super_formal_parameter_type_is_not_subtype_of_associated)

: _The type '{0}' of this parameter isn't a subtype of the type '{1}' of the associated super constructor parameter._

[super_formal_parameter_without_associated_named](/tools/diagnostics/super_formal_parameter_without_associated_named)

: _No associated named super constructor parameter._

[super_formal_parameter_without_associated_positional](/tools/diagnostics/super_formal_parameter_without_associated_positional)

: _No associated positional super constructor parameter._

[super_invocation_not_last](/tools/diagnostics/super_invocation_not_last)

: _The superconstructor call must be last in an initializer list: '{0}'._

[super_in_enum_constructor](/tools/diagnostics/super_in_enum_constructor)

: _The enum constructor can't have a 'super' initializer._

[super_in_extension](/tools/diagnostics/super_in_extension)

: _The 'super' keyword can't be used in an extension because an extension doesn't have a superclass._

[super_in_invalid_context](/tools/diagnostics/super_in_invalid_context)

: _Invalid context for 'super' invocation._

[super_in_redirecting_constructor](/tools/diagnostics/super_in_redirecting_constructor)

: _The redirecting constructor can't have a 'super' initializer._

[switch_case_completes_normally](/tools/diagnostics/switch_case_completes_normally)

: _The 'case' shouldn't complete normally._

[switch_expression_not_assignable](/tools/diagnostics/switch_expression_not_assignable)

: _Type '{0}' of the switch expression isn't assignable to the type '{1}' of case expressions._

[tearoff_of_generative_constructor_of_abstract_class](/tools/diagnostics/tearoff_of_generative_constructor_of_abstract_class)

: _A generative constructor of an abstract class can't be torn off._

[text_direction_code_point_in_comment](/tools/diagnostics/text_direction_code_point_in_comment)

: _The Unicode code point 'U+{0}' changes the appearance of text from how it's interpreted by the compiler._

[text_direction_code_point_in_literal](/tools/diagnostics/text_direction_code_point_in_literal)

: _The Unicode code point 'U+{0}' changes the appearance of text from how it's interpreted by the compiler._

[throw_of_invalid_type](/tools/diagnostics/throw_of_invalid_type)

: _The type '{0}' of the thrown expression must be assignable to 'Object'._

[top_level_cycle](/tools/diagnostics/top_level_cycle)

: _The type of '{0}' can't be inferred because it depends on itself through the cycle: {1}._

[type_alias_cannot_reference_itself](/tools/diagnostics/type_alias_cannot_reference_itself)

: _Typedefs can't reference themselves directly or recursively via another typedef._

[type_annotation_deferred_class](/tools/diagnostics/type_annotation_deferred_class)

: _The deferred type '{0}' can't be used in a declaration, cast, or type test._

[type_argument_not_matching_bounds](/tools/diagnostics/type_argument_not_matching_bounds)

: _'{0}' doesn't conform to the bound '{2}' of the type parameter '{1}'._

[type_check_with_null](/tools/diagnostics/type_check_with_null)

: _Tests for non-null should be done with '!= null'._
: _Tests for null should be done with '== null'._

[type_parameter_referenced_by_static](/tools/diagnostics/type_parameter_referenced_by_static)

: _Static members can't reference type parameters of the class._

[type_parameter_supertype_of_its_bound](/tools/diagnostics/type_parameter_supertype_of_its_bound)

: _'{0}' can't be a supertype of its upper bound._

[type_test_with_non_type](/tools/diagnostics/type_test_with_non_type)

: _The name '{0}' isn't a type and can't be used in an 'is' expression._

[type_test_with_undefined_name](/tools/diagnostics/type_test_with_undefined_name)

: _The name '{0}' isn't defined, so it can't be used in an 'is' expression._

[unchecked_use_of_nullable_value](/tools/diagnostics/unchecked_use_of_nullable_value)

: _A nullable expression can't be used in a spread._
: _The function can't be unconditionally invoked because it can be 'null'._
: _The method '{0}' can't be unconditionally invoked because the receiver can be 'null'._
: _The operator '{0}' can't be unconditionally invoked because the receiver can be 'null'._
: _A nullable expression can't be used in a yield-each statement._
: _A nullable expression can't be used as a condition._
: _A nullable expression can't be used as an iterator in a for-in loop._
: _The property '{0}' can't be unconditionally accessed because the receiver can be 'null'._

[undefined_annotation](/tools/diagnostics/undefined_annotation)

: _Undefined name '{0}' used as an annotation._

[undefined_class](/tools/diagnostics/undefined_class)

: _Undefined class '{0}'._

[undefined_constructor_in_initializer](/tools/diagnostics/undefined_constructor_in_initializer)

: _The class '{0}' doesn't have a constructor named '{1}'._
: _The class '{0}' doesn't have an unnamed constructor._

[undefined_enum_constant](/tools/diagnostics/undefined_enum_constant)

: _There's no constant named '{0}' in '{1}'._

[undefined_enum_constructor](/tools/diagnostics/undefined_enum_constructor)

: _The enum doesn't have a constructor named '{0}'._
: _The enum doesn't have an unnamed constructor._

[undefined_extension_getter](/tools/diagnostics/undefined_extension_getter)

: _The getter '{0}' isn't defined for the extension '{1}'._

[undefined_extension_method](/tools/diagnostics/undefined_extension_method)

: _The method '{0}' isn't defined for the extension '{1}'._

[undefined_extension_operator](/tools/diagnostics/undefined_extension_operator)

: _The operator '{0}' isn't defined for the extension '{1}'._

[undefined_extension_setter](/tools/diagnostics/undefined_extension_setter)

: _The setter '{0}' isn't defined for the extension '{1}'._

[undefined_function](/tools/diagnostics/undefined_function)

: _The function '{0}' isn't defined._

[undefined_getter](/tools/diagnostics/undefined_getter)

: _The getter '{0}' isn't defined for the type '{1}'._
: _The getter '{0}' isn't defined for the '{1}' function type._

[undefined_hidden_name](/tools/diagnostics/undefined_hidden_name)

: _The library '{0}' doesn't export a member with the hidden name '{1}'._

[undefined_identifier](/tools/diagnostics/undefined_identifier)

: _Undefined name '{0}'._

[undefined_identifier_await](/tools/diagnostics/undefined_identifier_await)

: _Undefined name 'await' in function body not marked with 'async'._

[undefined_method](/tools/diagnostics/undefined_method)

: _The method '{0}' isn't defined for the type '{1}'._
: _The method '{0}' isn't defined for the '{1}' function type._

[undefined_named_parameter](/tools/diagnostics/undefined_named_parameter)

: _The named parameter '{0}' isn't defined._

[undefined_operator](/tools/diagnostics/undefined_operator)

: _The operator '{0}' isn't defined for the type '{1}'._

[undefined_prefixed_name](/tools/diagnostics/undefined_prefixed_name)

: _The name '{0}' is being referenced through the prefix '{1}', but it isn't defined in any of the libraries imported using that prefix._

[undefined_referenced_parameter](/tools/diagnostics/undefined_referenced_parameter)

: _The parameter '{0}' isn't defined by '{1}'._

[undefined_setter](/tools/diagnostics/undefined_setter)

: _The setter '{0}' isn't defined for the type '{1}'._
: _The setter '{0}' isn't defined for the '{1}' function type._

[undefined_shown_name](/tools/diagnostics/undefined_shown_name)

: _The library '{0}' doesn't export a member with the shown name '{1}'._

[undefined_super_member](/tools/diagnostics/undefined_super_member)

: _The getter '{0}' isn't defined in a superclass of '{1}'._
: _The method '{0}' isn't defined in a superclass of '{1}'._
: _The operator '{0}' isn't defined in a superclass of '{1}'._
: _The setter '{0}' isn't defined in a superclass of '{1}'._

[unnecessary_cast](/tools/diagnostics/unnecessary_cast)

: _Unnecessary cast._

[unnecessary_dev_dependency](/tools/diagnostics/unnecessary_dev_dependency)

: _The dev dependency on {0} is unnecessary because there is also a normal dependency on that package._

[unnecessary_final](/tools/diagnostics/unnecessary_final)

: _The keyword 'final' isn't necessary because the parameter is implicitly 'final'._

[unnecessary_import](/tools/diagnostics/unnecessary_import)

: _The import of '{0}' is unnecessary because all of the used elements are also provided by the import of '{1}'._

[unnecessary_nan_comparison](/tools/diagnostics/unnecessary_nan_comparison)

: _A double can't equal 'double.nan', so the condition is always 'false'._
: _A double can't equal 'double.nan', so the condition is always 'true'._

[unnecessary_non_null_assertion](/tools/diagnostics/unnecessary_non_null_assertion)

: _The '!' will have no effect because the receiver can't be null._

[unnecessary_no_such_method](/tools/diagnostics/unnecessary_no_such_method)

: _Unnecessary 'noSuchMethod' declaration._

[unnecessary_null_comparison](/tools/diagnostics/unnecessary_null_comparison)

: _The operand can't be null, so the condition is always 'false'._
: _The operand can't be null, so the condition is always 'true'._

[unnecessary_question_mark](/tools/diagnostics/unnecessary_question_mark)

: _The '?' is unnecessary because '{0}' is nullable without it._

[unnecessary_type_check](/tools/diagnostics/unnecessary_type_check)

: _Unnecessary type check; the result is always 'false'._
: _Unnecessary type check; the result is always 'true'._

[unqualified_reference_to_non_local_static_member](/tools/diagnostics/unqualified_reference_to_non_local_static_member)

: _Static members from supertypes must be qualified by the name of the defining type._

[unqualified_reference_to_static_member_of_extended_type](/tools/diagnostics/unqualified_reference_to_static_member_of_extended_type)

: _Static members from the extended type or one of its superclasses must be qualified by the name of the defining type._

[unused_catch_clause](/tools/diagnostics/unused_catch_clause)

: _The exception variable '{0}' isn't used, so the 'catch' clause can be removed._

[unused_catch_stack](/tools/diagnostics/unused_catch_stack)

: _The stack trace variable '{0}' isn't used and can be removed._

[unused_element](/tools/diagnostics/unused_element)

: _The declaration '{0}' isn't referenced._
: _A value for optional parameter '{0}' isn't ever given._

[unused_field](/tools/diagnostics/unused_field)

: _The value of the field '{0}' isn't used._

[unused_import](/tools/diagnostics/unused_import)

: _Unused import: '{0}'._

[unused_label](/tools/diagnostics/unused_label)

: _The label '{0}' isn't used._

[unused_local_variable](/tools/diagnostics/unused_local_variable)

: _The value of the local variable '{0}' isn't used._

[unused_result](/tools/diagnostics/unused_result)

: _The value of '{0}' should be used._
: _'{0}' should be used. {1}._

[unused_shown_name](/tools/diagnostics/unused_shown_name)

: _The name {0} is shown, but isn't used._

[uri_does_not_exist](/tools/diagnostics/uri_does_not_exist)

: _Target of URI doesn't exist: '{0}'._

[uri_has_not_been_generated](/tools/diagnostics/uri_has_not_been_generated)

: _Target of URI hasn't been generated: '{0}'._

[uri_with_interpolation](/tools/diagnostics/uri_with_interpolation)

: _URIs can't use string interpolation._

[use_of_native_extension](/tools/diagnostics/use_of_native_extension)

: _Dart native extensions are deprecated and aren't available in Dart 2.15._

[use_of_void_result](/tools/diagnostics/use_of_void_result)

: _This expression has a type of 'void' so its value can't be used._

[values_declaration_in_enum](/tools/diagnostics/values_declaration_in_enum)

: _A member named 'values' can't be declared in an enum._

[variable_type_mismatch](/tools/diagnostics/variable_type_mismatch)

: _A value of type '{0}' can't be assigned to a const variable of type '{1}'._

[wrong_number_of_parameters_for_operator](/tools/diagnostics/wrong_number_of_parameters_for_operator)

: _Operator '{0}' should declare exactly {1} parameters, but {2} found._
: _Operator '-' should declare 0 or 1 parameter, but {0} found._

[wrong_number_of_parameters_for_setter](/tools/diagnostics/wrong_number_of_parameters_for_setter)

: _Setters must declare exactly one required positional parameter._

[wrong_number_of_type_arguments](/tools/diagnostics/wrong_number_of_type_arguments)

: _The type '{0}' is declared with {1} type parameters, but {2} type arguments were given._

[wrong_number_of_type_arguments_constructor](/tools/diagnostics/wrong_number_of_type_arguments_constructor)

: _The constructor '{0}.{1}' doesn't have type parameters._

[wrong_number_of_type_arguments_enum](/tools/diagnostics/wrong_number_of_type_arguments_enum)

: _The enum is declared with {0} type parameters, but {1} type arguments were given._

[wrong_number_of_type_arguments_extension](/tools/diagnostics/wrong_number_of_type_arguments_extension)

: _The extension '{0}' is declared with {1} type parameters, but {2} type arguments were given._

[wrong_number_of_type_arguments_method](/tools/diagnostics/wrong_number_of_type_arguments_method)

: _The method '{0}' is declared with {1} type parameters, but {2} type arguments are given._

[yield_in_non_generator](/tools/diagnostics/yield_in_non_generator)

: _Yield-each statements must be in a generator function (one marked with either 'async*' or 'sync*')._
: _Yield statements must be in a generator function (one marked with either 'async*' or 'sync*')._

[yield_of_invalid_type](/tools/diagnostics/yield_of_invalid_type)

: _The type '{0}' implied by the 'yield*' expression must be assignable to '{1}'._
: _A yielded value of type '{0}' must be assignable to '{1}'._
