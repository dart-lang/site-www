import 'package:futures_examples/long_chain.dart' as long_chain;
import 'package:test/test.dart';

void main() {
  test('long future chain prints', () {
    expect(() async {
      long_chain.main();
      await Future.delayed(Duration(milliseconds: 500));
    }, prints('Got error: error from two\nThe value is 42\n'));
  });
}
