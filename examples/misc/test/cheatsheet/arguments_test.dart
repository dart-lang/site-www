import 'package:examples/cheatsheet/named_parameters.dart';
import 'package:examples/cheatsheet/optional_positional_args.dart'
    as optional_args;
import 'package:examples/cheatsheet/optional_positional_args2.dart'
    as defaulted_args;
import 'package:test/test.dart';

void main() {
  test('print_name', () {
    expect(() {
      printNameTest();
    }, prints('Dash  Dartisan\nJohn Who Smith\nJohn Who Smith\n'));
  });

  // #docregion defaulted-middle
  void printName(String firstName, String lastName, {String middleName = ''}) {
    print('$firstName $middleName $lastName');
  }
  // #enddocregion defaulted-middle

  test('print_name_default', () {
    expect(() {
      printName('Dash', 'Dartisan', middleName: 'Best');
    }, prints('Dash Best Dartisan\n'));

    expect(() {
      printName('Dash', 'Dartisan');
    }, prints('Dash  Dartisan\n'));
  });

  test('optional_positional_args', () {
    expect(() {
      optional_args.mainTest();
    }, prints('6\n3\n15\n'));

    expect(optional_args.sumUpToFive(1, 4, 7), equals(12));
  });

  test('optional_positional_args_defaulted', () {
    expect(() {
      defaulted_args.mainTest();
    }, prints('15\n'));

    expect(defaulted_args.sumUpToFive(1, 1), equals(14));
  });
}
