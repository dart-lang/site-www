import 'package:examples/cheatsheet/optional_named_params.dart';
import 'package:examples/cheatsheet/optional_positional_args.dart'
    as optional_args;
import 'package:examples/cheatsheet/optional_positional_args2.dart'
    as defaulted_args;
import 'package:test/test.dart';

void main() {
  test('print_name', () {
    expect(() {
      printNameTest();
    }, prints('Avinash Gupta \nPoshmeister Moneybuckets IV\n'));
  });

  test('print_name_default', () {
    // #docregion defaulted-suffix
    void printName(String firstName, String lastName, {String suffix = ''}) {
      print('$firstName $lastName $suffix');
    }
    // #enddocregion defaulted-suffix

    expect(() {
      printName('Dash', 'Dartisan', suffix: 'III');
    }, prints('Dash Dartisan III\n'));

    expect(() {
      printName('Dash', 'Dartisan');
    }, prints('Dash Dartisan \n'));
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
