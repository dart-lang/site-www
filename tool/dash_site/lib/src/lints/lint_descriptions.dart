// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: lines_longer_than_80_chars

/// Returns a short description of the lint with the specified [lintName].
///
/// If the lint doesn't have a description specified, an exception is thrown.
String descriptionOfLint(String lintName) {
  final descriptionForLint = _lintToDescription[lintName];
  if (descriptionForLint == null) {
    throw Exception(
      'Lint `$lintName` doesn\'t have a corresponding '
      'description specified in the `lint_description.dart` file!\n'
      'Please add a description for it and rerun this command.',
    );
  }

  return descriptionForLint;
}

/// A map from each lint rule's name to a one or two sentence description of it.
///
/// Originally copied from each lint rule in the Dart SDK.
final Map<String, String> _lintToDescription = {
  'always_declare_return_types': 'Declare method return types.',
  'always_put_control_body_on_new_line':
      'Separate the control structure expression from its statement.',
  'always_put_required_named_parameters_first':
      'Put required named parameters first.',
  'always_require_non_null_named_parameters':
      'Specify `@required` on named parameters without defaults.',
  'always_specify_types': 'Specify type annotations.',
  'always_use_package_imports': 'Avoid relative imports for files in `lib/`.',
  'annotate_overrides': 'Annotate overridden members.',
  'annotate_redeclares': 'Annotate redeclared members.',
  'avoid_annotating_with_dynamic':
      'Avoid annotating with `dynamic` when not required.',
  'avoid_as': 'Avoid using `as`.',
  'avoid_bool_literals_in_conditional_expressions':
      'Avoid `bool` literals in conditional expressions.',
  'avoid_catches_without_on_clauses': 'Avoid catches without on clauses.',
  'avoid_catching_errors':
      'Don\'t explicitly catch `Error` or types that implement it.',
  'avoid_classes_with_only_static_members':
      'Avoid defining a class that contains only static members.',
  'avoid_double_and_int_checks': 'Avoid `double` and `int` checks.',
  'avoid_dynamic_calls':
      'Avoid method calls or property accesses on a `dynamic` target.',
  'avoid_empty_else': 'Avoid empty statements in else clauses.',
  'avoid_equals_and_hash_code_on_mutable_classes':
      'Avoid overloading operator == and hashCode on classes not marked `@immutable`.',
  'avoid_escaping_inner_quotes':
      'Avoid escaping inner quotes by converting surrounding quotes.',
  'avoid_field_initializers_in_const_classes':
      'Avoid field initializers in const classes.',
  'avoid_final_parameters': 'Avoid `final` for parameter declarations.',
  'avoid_function_literals_in_foreach_calls':
      'Avoid using `forEach` with a function literal.',
  'avoid_futureor_void':
      'Avoid using \'FutureOr<void>\' as the type of a result.',
  'avoid_implementing_value_types':
      'Don\'t implement classes that override `==`.',
  'avoid_init_to_null': 'Don\'t explicitly initialize variables to `null`.',
  'avoid_js_rounded_ints': 'Avoid JavaScript rounded ints.',
  'avoid_multiple_declarations_per_line':
      'Don\'t declare multiple variables on a single line.',
  'avoid_null_checks_in_equality_operators':
      'Don\'t check for `null` in custom `==` operators.',
  'avoid_positional_boolean_parameters': 'Avoid positional boolean parameters.',
  'avoid_print': 'Avoid `print` calls in production code.',
  'avoid_private_typedef_functions': 'Avoid private typedef functions.',
  'avoid_redundant_argument_values': 'Avoid redundant argument values.',
  'avoid_relative_lib_imports': 'Avoid relative imports for files in `lib/`.',
  'avoid_renaming_method_parameters':
      'Don\'t rename parameters of overridden methods.',
  'avoid_return_types_on_setters': 'Avoid return types on setters.',
  'avoid_returning_null':
      'Avoid returning null from members whose return type is bool, double, int, or num.',
  'avoid_returning_null_for_future': 'Avoid returning null for Future.',
  'avoid_returning_null_for_void': 'Avoid returning `null` for `void`.',
  'avoid_returning_this':
      'Avoid returning this from methods just to enable a fluent interface.',
  'avoid_setters_without_getters': 'Avoid setters without getters.',
  'avoid_shadowing_type_parameters': 'Avoid shadowing type parameters.',
  'avoid_single_cascade_in_expression_statements':
      'Avoid single cascade in expression statements.',
  'avoid_slow_async_io': 'Avoid slow asynchronous `dart:io` methods.',
  'avoid_type_to_string':
      'Avoid <Type>.toString() in production code since results may be minified.',
  'avoid_types_as_parameter_names': 'Avoid types as parameter names.',
  'avoid_types_on_closure_parameters':
      'Avoid annotating types for function expression parameters.',
  'avoid_unnecessary_containers': 'Avoid unnecessary containers.',
  'avoid_unstable_final_fields':
      'Avoid overriding a final field to return different values if called multiple times.',
  'avoid_unused_constructor_parameters':
      'Avoid defining unused parameters in constructors.',
  'avoid_void_async': 'Avoid `async` functions that return `void`.',
  'avoid_web_libraries_in_flutter':
      'Avoid using web-only libraries outside Flutter web plugin packages.',
  'await_only_futures': 'Await only futures.',
  'camel_case_extensions': 'Name extensions using UpperCamelCase.',
  'camel_case_types': 'Name types using UpperCamelCase.',
  'cancel_subscriptions':
      'Cancel instances of `dart:async` `StreamSubscription`.',
  'cascade_invocations':
      'Cascade consecutive method invocations on the same reference.',
  'cast_nullable_to_non_nullable':
      'Don\'t cast a nullable value to a non nullable type.',
  'close_sinks': 'Close instances of `dart:core` `Sink`.',
  'collection_methods_unrelated_type':
      'Invocation of various collection methods with arguments of unrelated types.',
  'combinators_ordering': 'Sort combinator names alphabetically.',
  'comment_references': 'Only reference in-scope identifiers in doc comments.',
  'conditional_uri_does_not_exist': 'Missing conditional import.',
  'constant_identifier_names':
      'Prefer using lowerCamelCase for constant names.',
  'control_flow_in_finally': 'Avoid control flow in `finally` blocks.',
  'curly_braces_in_flow_control_structures':
      'DO use curly braces for all flow control structures.',
  'dangling_library_doc_comments':
      'Attach library doc comments to library directives.',
  'depend_on_referenced_packages': 'Depend on referenced packages.',
  'deprecated_consistency': 'Missing deprecated annotation.',
  'deprecated_member_use_from_same_package':
      'Avoid using deprecated elements from within the package in which they are declared.',
  'diagnostic_describe_all_properties':
      'DO reference all public properties in debug methods.',
  'directives_ordering':
      'Adhere to Effective Dart Guide directives sorting conventions.',
  'discarded_futures':
      'There should be no `Future`-returning calls in synchronous functions unless they are assigned or returned.',
  'do_not_use_environment': 'Do not use environment declared variables.',
  'document_ignores': 'Document ignore comments.',
  'empty_catches': 'Avoid empty catch blocks.',
  'empty_constructor_bodies':
      'Use `;` instead of `{}` for empty constructor bodies.',
  'empty_statements': 'Avoid empty statements.',
  'enable_null_safety': 'Do use sound null safety.',
  'eol_at_end_of_file': 'Put a single newline at end of file.',
  'exhaustive_cases':
      'Define case clauses for all constants in enum-like classes.',
  'file_names': 'Name source files using `lowercase_with_underscores`.',
  'flutter_style_todos':
      'Use Flutter TODO format: // TODO(username): message, https://URL-to-issue.',
  'hash_and_equals': 'Always override `hashCode` if overriding `==`.',
  'implementation_imports':
      'Don\'t import implementation files from another package.',
  'implicit_call_tearoffs':
      'Explicitly tear-off `call` methods when using an object as a Function.',
  'implicit_reopen': 'Don\'t implicitly reopen classes.',
  'invalid_case_patterns': 'Use case expressions that are valid in Dart 3.0.',
  'invalid_runtime_check_with_js_interop_types':
      'Avoid runtime type tests with JS interop types where the result might not be platform-consistent.',
  'invariant_booleans':
      'Conditions should not unconditionally evaluate to `true` or to `false`.',
  'iterable_contains_unrelated_type':
      'Invocation of `Iterable<E>.contains` with references of unrelated types.',
  'join_return_with_assignment':
      'Join return statement with assignment when possible.',
  'leading_newlines_in_multiline_strings':
      'Start multiline strings with a newline.',
  'library_annotations': 'Attach library annotations to library directives.',
  'library_names': 'Name libraries using `lowercase_with_underscores`.',
  'library_prefixes':
      'Use `lowercase_with_underscores` when specifying a library prefix.',
  'library_private_types_in_public_api':
      'Avoid using private types in public APIs.',
  'lines_longer_than_80_chars': 'Avoid lines longer than 80 characters.',
  'list_remove_unrelated_type':
      'Invocation of `remove` with references of unrelated types.',
  'literal_only_boolean_expressions':
      'Boolean expression composed only with literals.',
  'matching_super_parameters': 'Use matching super parameter names.',
  'missing_code_block_language_in_doc_comment':
      'A code block is missing a specified language.',
  'missing_whitespace_between_adjacent_strings':
      'Missing whitespace between adjacent strings.',
  'no_adjacent_strings_in_list': 'Don\'t use adjacent strings in list.',
  'no_default_cases': 'No default cases.',
  'no_duplicate_case_values': 'Don\'t use more than one case with same value.',
  'no_leading_underscores_for_library_prefixes':
      'Avoid leading underscores for library prefixes.',
  'no_leading_underscores_for_local_identifiers':
      'Avoid leading underscores for local identifiers.',
  'no_literal_bool_comparisons':
      'Don\'t compare boolean expressions to boolean literals.',
  'no_logic_in_create_state': 'Don\'t put any logic in createState.',
  'no_runtimeType_toString': 'Avoid calling `toString()` on `runtimeType`.',
  'no_self_assignments': 'Don\'t assign a variable to itself.',
  'no_wildcard_variable_uses': 'Don\'t use wildcard parameters or variables.',
  'non_constant_identifier_names':
      'Name non-constant identifiers using lowerCamelCase.',
  'noop_primitive_operations': 'Noop primitive operations.',
  'null_check_on_nullable_type_parameter':
      'Don\'t use `null` check on a potentially nullable type parameter.',
  'null_closures':
      'Do not pass `null` as an argument where a closure is expected.',
  'omit_local_variable_types': 'Omit type annotations for local variables.',
  'omit_obvious_local_variable_types':
      'Omit obvious type annotations for local variables.',
  'omit_obvious_property_types':
      'Omit obvious type annotations for top-level and static variables.',
  'one_member_abstracts':
      'Avoid defining a one-member abstract class when a simple function will do.',
  'only_throw_errors':
      'Only throw instances of classes extending either Exception or Error.',
  'overridden_fields': 'Don\'t override fields.',
  'package_api_docs': 'Provide doc comments for all public APIs.',
  'package_names': 'Use `lowercase_with_underscores` for package names.',
  'package_prefixed_library_names':
      'Prefix library names with the package name and a dot-separated path.',
  'parameter_assignments':
      'Don\'t reassign references to parameters of functions or methods.',
  'prefer_adjacent_string_concatenation':
      'Use adjacent strings to concatenate string literals.',
  'prefer_asserts_in_initializer_lists':
      'Prefer putting asserts in initializer lists.',
  'prefer_asserts_with_message': 'Prefer asserts with message.',
  'prefer_bool_in_asserts': 'Prefer using a boolean as the assert condition.',
  'prefer_collection_literals': 'Use collection literals when possible.',
  'prefer_conditional_assignment':
      'Prefer using `??=` over testing for `null`.',
  'prefer_const_constructors': 'Prefer `const` with constant constructors.',
  'prefer_const_constructors_in_immutables':
      'Prefer declaring `const` constructors on `@immutable` classes.',
  'prefer_const_declarations': 'Prefer `const` over `final` for declarations.',
  'prefer_const_literals_to_create_immutables':
      'Prefer const literals as parameters of constructors on @immutable classes.',
  'prefer_constructors_over_static_methods':
      'Prefer defining constructors instead of static methods to create instances.',
  'prefer_contains': 'Use contains for `List` and `String` instances.',
  'prefer_double_quotes':
      'Prefer double quotes where they won\'t require escape sequences.',
  'prefer_equal_for_default_values':
      'Use `=` to separate a named parameter from its default value.',
  'prefer_expression_function_bodies':
      'Use => for short members whose body is a single return statement.',
  'prefer_final_fields': 'Private field could be `final`.',
  'prefer_final_in_for_each':
      'Prefer final in for-each loop variable if reference is not reassigned.',
  'prefer_final_locals':
      'Prefer final for variable declarations if they are not reassigned.',
  'prefer_final_parameters':
      'Prefer final for parameter declarations if they are not reassigned.',
  'prefer_for_elements_to_map_fromIterable':
      'Prefer `for` elements when building maps from iterables.',
  'prefer_foreach':
      'Use `forEach` to only apply a function to all the elements.',
  'prefer_function_declarations_over_variables':
      'Use a function declaration to bind a function to a name.',
  'prefer_generic_function_type_aliases':
      'Prefer generic function type aliases.',
  'prefer_if_elements_to_conditional_expressions':
      'Prefer if elements to conditional expressions where possible.',
  'prefer_if_null_operators': 'Prefer using `??` operators.',
  'prefer_initializing_formals': 'Use initializing formals when possible.',
  'prefer_inlined_adds': 'Inline list item declarations where possible.',
  'prefer_int_literals': 'Prefer int literals over double literals.',
  'prefer_interpolation_to_compose_strings':
      'Use interpolation to compose strings and values.',
  'prefer_is_empty': 'Use `isEmpty` for `Iterable`s and `Map`s.',
  'prefer_is_not_empty': 'Use `isNotEmpty` for `Iterable`s and `Map`s.',
  'prefer_is_not_operator': 'Prefer is! operator.',
  'prefer_iterable_whereType': 'Prefer to use `whereType` on iterable.',
  'prefer_mixin': 'Prefer using mixins.',
  'prefer_null_aware_method_calls': 'Prefer `null`-aware method calls.',
  'prefer_null_aware_operators': 'Prefer using `null`-aware operators.',
  'prefer_relative_imports': 'Prefer relative imports for files in `lib/`.',
  'prefer_single_quotes':
      'Only use double quotes for strings containing single quotes.',
  'prefer_spread_collections': 'Use spread collections when possible.',
  'prefer_typing_uninitialized_variables':
      'Prefer typing uninitialized variables and fields.',
  'prefer_void_to_null':
      'Don\'t use the Null type, unless you are positive that you don\'t want void.',
  'provide_deprecation_message':
      'Provide a deprecation message, via `@Deprecated("message")`.',
  'public_member_api_docs': 'Document all public members.',
  'recursive_getters': 'Property getter recursively returns itself.',
  'remove_deprecations_in_breaking_versions': 'Deprecation in major version.',
  'require_trailing_commas':
      'Use trailing commas for all parameter lists and argument lists.',
  'secure_pubspec_urls': 'Use secure urls in `pubspec.yaml`.',
  'sized_box_for_whitespace': '`SizedBox` for whitespace.',
  'sized_box_shrink_expand':
      'Use SizedBox shrink and expand named constructors.',
  'slash_for_doc_comments': 'Prefer using `///` for doc comments.',
  'sort_child_properties_last':
      'Sort child properties last in widget instance creations.',
  'sort_constructors_first':
      'Sort constructor declarations before other members.',
  'sort_pub_dependencies': 'Sort pub dependencies alphabetically.',
  'sort_unnamed_constructors_first':
      'Sort unnamed constructor declarations first.',
  'specify_nonobvious_local_variable_types':
      'Specify non-obvious type annotations for local variables.',
  'specify_nonobvious_property_types':
      'Specify non-obvious type annotations for top-level and static variables.',
  'strict_top_level_inference': 'Specify type annotations.',
  'super_goes_last':
      'Place the `super` call last in a constructor initialization list.',
  'switch_on_type': 'Avoid switch statements on a \'Type\'.',
  'test_types_in_equals':
      'Test type of argument in `operator ==(Object other)`.',
  'throw_in_finally': 'Avoid `throw` in `finally` block.',
  'tighten_type_of_initializing_formals':
      'Tighten type of initializing formal.',
  'type_annotate_public_apis': 'Type annotate public APIs.',
  'type_init_formals': 'Don\'t type annotate initializing formals.',
  'type_literal_in_constant_pattern':
      'Don\'t use constant patterns with type literals.',
  'unawaited_futures':
      '`Future` results in `async` function bodies must be `await`ed or marked `unawaited` using `dart:async`.',
  'unintended_html_in_doc_comment':
      'Use of angle brackets in a doc comment is treated as HTML by Markdown.',
  'unnecessary_async': 'No await no async.',
  'unnecessary_await_in_return': 'Unnecessary `await` keyword in return.',
  'unnecessary_brace_in_string_interps':
      'Avoid using braces in interpolation when not needed.',
  'unnecessary_breaks': 'Don\'t use explicit `break`s when a break is implied.',
  'unnecessary_const': 'Avoid `const` keyword.',
  'unnecessary_constructor_name': 'Unnecessary `.new` constructor name.',
  'unnecessary_final': 'Don\'t use `final` for local variables.',
  'unnecessary_getters_setters':
      'Avoid wrapping fields in getters and setters just to be "safe".',
  'unnecessary_ignore': 'Don\'t ignore a diagnostic code that is not produced.',
  'unnecessary_lambdas': 'Don\'t create a lambda when a tear-off will do.',
  'unnecessary_late':
      'Don\'t specify the `late` modifier when it is not needed.',
  'unnecessary_library_directive':
      'Avoid library directives unless they have documentation comments or annotations.',
  'unnecessary_library_name':
      'Don\'t have a library name in a `library` declaration.',
  'unnecessary_new': 'Unnecessary new keyword.',
  'unnecessary_null_aware_assignments':
      'Avoid `null` in `null`-aware assignment.',
  'unnecessary_null_aware_operator_on_extension_on_nullable':
      'Unnecessary null aware operator on extension on a nullable type.',
  'unnecessary_null_checks': 'Unnecessary `null` checks.',
  'unnecessary_null_in_if_null_operators':
      'Avoid using `null` in `??` operators.',
  'unnecessary_nullable_for_final_variable_declarations':
      'Use a non-nullable type for a final variable initialized with a non-nullable value.',
  'unnecessary_overrides':
      'Don\'t override a method to do a super method invocation with the same parameters.',
  'unnecessary_parenthesis': 'Unnecessary parentheses can be removed.',
  'unnecessary_raw_strings': 'Unnecessary raw string.',
  'unnecessary_statements': 'Avoid using unnecessary statements.',
  'unnecessary_string_escapes': 'Remove unnecessary backslashes in strings.',
  'unnecessary_string_interpolations': 'Unnecessary string interpolation.',
  'unnecessary_this':
      'Don\'t access members with `this` unless avoiding shadowing.',
  'unnecessary_to_list_in_spreads': 'Unnecessary `toList()` in spreads.',
  'unnecessary_unawaited': 'Unnecessary use of \'unawaited\'.',
  'unnecessary_underscores': 'Unnecessary underscores can be removed.',
  'unreachable_from_main':
      'Unreachable top-level members in executable libraries.',
  'unrelated_type_equality_checks':
      'Equality operator `==` invocation with references of unrelated types.',
  'unsafe_html': 'Avoid unsafe HTML APIs.',
  'unsafe_variance':
      'Unsafe type: Has a type variable in a non-covariant position.',
  'use_build_context_synchronously':
      'Do not use `BuildContext` across asynchronous gaps.',
  'use_colored_box': 'Use `ColoredBox`.',
  'use_decorated_box': 'Use `DecoratedBox`.',
  'use_enums': 'Use enums rather than classes that behave like enums.',
  'use_full_hex_values_for_flutter_colors':
      'Prefer an 8-digit hexadecimal integer (for example, 0xFFFFFFFF) to instantiate a Color.',
  'use_function_type_syntax_for_parameters':
      'Use generic function type syntax for parameters.',
  'use_if_null_to_convert_nulls_to_bools':
      'Use `??` operators to convert `null`s to `bool`s.',
  'use_is_even_rather_than_modulo':
      'Prefer intValue.isOdd/isEven instead of checking the result of % 2.',
  'use_key_in_widget_constructors': 'Use key in widget constructors.',
  'use_late_for_private_fields_and_variables':
      'Use late for private members with a non-nullable type.',
  'use_named_constants': 'Use predefined named constants.',
  'use_null_aware_elements':
      'If-elements testing for null can be replaced with null-aware elements.',
  'use_raw_strings': 'Use raw string to avoid escapes.',
  'use_rethrow_when_possible': 'Use rethrow to rethrow a caught exception.',
  'use_setters_to_change_properties':
      'Use a setter for operations that conceptually change a property.',
  'use_string_buffers': 'Use string buffers to compose strings.',
  'use_string_in_part_of_directives': 'Use string in part of directives.',
  'use_super_parameters': 'Use super-initializer parameters where possible.',
  'use_test_throws_matchers': 'Use throwsA matcher instead of fail().',
  'use_to_and_as_if_applicable':
      'Start the name of the method with to/_to or as/_as if applicable.',
  'use_truncating_division': 'Use truncating division.',
  'valid_regexps': 'Use valid regular expression syntax.',
  'void_checks': 'Don\'t assign to `void`.',
};
