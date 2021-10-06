import 'package:test/test.dart';
import 'package:examples_util/print_matcher.dart' as m;

import '../bin/async_example.dart' as async_example;
import '../bin/futures_intro.dart' as futures_intro;
import '../bin/get_order_sync_bad.dart' as get_order_sync_bad;
import '../bin/get_order.dart' as get_order;
import '../bin/try_catch.dart' as try_catch;

void main() {
  test('async_example', () {
    final output = '''
      Awaiting user order...
      1
      2
      3
      4
      Your order is: Large Latte
    ''';
    expect(async_example.main, m.printsLines(output));
  });

  test('futures_intro', () {
    final output = '''
      Fetching user order...
      Large Latte
    ''';
    expect(
        () => Future.wait([
              Future.delayed(const Duration(seconds: 4)),
              Future.sync(futures_intro.main),
            ]),
        m.printsLines(output));
  });

  test('get_order_sync_bad', () {
    final output = '''
      Fetching user order...
      Your order is: Instance of 'Future<String>'
    ''';
    expect(get_order_sync_bad.main, m.printsLines(output));
  });

  test('get_order', () {
    final output = '''
      Fetching user order...
      Your order is: Large Latte
    ''';
    expect(get_order.main, m.printsLines(output));
  });

  test('try_catch', () {
    final output = '''
      Awaiting user order...
      Caught error: Cannot locate user order
    ''';
    expect(try_catch.main, m.printsLines(output));
  });
}
