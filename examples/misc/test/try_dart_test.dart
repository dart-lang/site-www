import 'package:test/test.dart';

import '../bin/try_dart/functions.dart' as functions;
import '../bin/try_dart/classes.dart' as classes;
import '../bin/try_dart/collection_literals.dart' as collection_literals;
import '../bin/try_dart/control_flow.dart' as control_flow;
import '../bin/try_dart/strings.dart' as strings;

void main() {
  test('functions', () {
    expect(functions.main, prints(endsWith('2 x 2 x 2 is 8\n')));
  });

  test('control_flow', () {
    expect(control_flow.main, prints('[0, 2, 4, 6, 8]\n'));
  });

  test('strings', () {
    expect(strings.main, prints(contains('tau is 6.28')));
  });

  test('collection_literals', () {
    expect(collection_literals.main, prints('42\nNeon\n{Tree, Glass}\n'));
  });

  test('classes', () {
    final output = '''
      Instance of 'Chest<Item>' has 2 items.
      Instance of 'DiamondSword' dealt 50 damage.
      Instance of 'Sword' dealt 5 damage.
    '''
        .trimLeft()
        .replaceAll(RegExp(r'\n\s*'), '\n');
    expect(classes.main, prints(output));
  });
}
