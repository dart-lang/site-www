import 'package:examples/cheatsheet/optional_named_params.dart';
import 'package:examples/cheatsheet/optional_positional_args.dart' as optionalArgs;
import 'package:examples/cheatsheet/optional_positional_args2.dart' as defaultedArgs;
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
      optionalArgs.mainTest();
    }, prints('6\n3\n15\n'));

    expect(optionalArgs.sumUpToFive(1, 4, 7), equals(12));
  });

  test('optional_positional_args_defaulted', () {
    expect(() {
      defaultedArgs.mainTest();
    }, prints('15\n'));
    
    expect(defaultedArgs.sumUpToFive(1, 1), equals(14));
  });
}
