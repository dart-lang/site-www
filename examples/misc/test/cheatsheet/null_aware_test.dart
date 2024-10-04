// ignore_for_file: unused_local_variable, unnecessary_null_in_if_null_operators, dead_null_aware_expression, unnecessary_null_comparison

import 'package:test/test.dart';

void main() {
  test('null_aware_operators', () {
    void nullAware() {
      // #docregion null-aware-operators
      int? a; // = null
      a ??= 3;
      print(a); // <-- Prints 3.

      a ??= 5;
      print(a); // <-- Still prints 3.
      // #enddocregion null-aware-operators

      // #docregion null-aware-operators-2
      print(1 ?? 3); // <-- Prints 1.
      print(null ?? 12); // <-- Prints 12.
      // #enddocregion null-aware-operators-2
    }

    expect(nullAware, prints('3\n3\n1\n12\n'));
  });

  test('conditional_property_access', () {
    dynamic myObject;
    dynamic result;

    // #docregion conditional-property-access
    result = myObject?.someProperty;
    // #enddocregion conditional-property-access

    expect(result, isNull);

    // #docregion conditional-property-access-equivalent
    result = (myObject != null) ? myObject.someProperty : null;
    // #enddocregion conditional-property-access-equivalent

    expect(result, isNull);

    // #docregion conditional-property-access-multiple
    result = myObject?.someProperty?.someMethod();
    // #enddocregion conditional-property-access-multiple

    expect(result, isNull);
  });
}
