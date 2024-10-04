import 'package:examples/cheatsheet/getter_compute.dart' as getters_compute;
import 'package:examples/cheatsheet/getters_setters.dart' as getters_setters;
import 'package:test/test.dart';

void main() {
  test('getters_setters', () {
    getters_setters.MyClass clazz = getters_setters.MyClass();
    clazz.aProperty = 5;

    expect(clazz.aProperty, equals(5));

    clazz.aProperty = -10;

    expect(clazz.aProperty, equals(5));
  });

  test('getter_compute', () {
    getters_compute.MyClass clazz = getters_compute.MyClass();
    clazz.addValue(5);

    expect(clazz.count, equals(1));

    clazz.addValue(7);

    expect(clazz.count, equals(2));
  });
}
