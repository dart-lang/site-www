import 'package:examples/cheatsheet/getter_compute.dart' as getters_compute;
import 'package:examples/cheatsheet/getters_setters.dart' as getters_setters;
import 'package:test/test.dart';

void main() {
  test('getters_setters', () {
    getters_setters.MyClass _class = getters_setters.MyClass();
    _class.aProperty = 5;

    expect(_class.aProperty, equals(5));

    _class.aProperty = -10;

    expect(_class.aProperty, equals(5));
  });

  test('getter_compute', () {
    getters_compute.MyClass _class = getters_compute.MyClass();
    _class.addValue(5);

    expect(_class.count, equals(1));

    _class.addValue(7);

    expect(_class.count, equals(2));
  });
}
