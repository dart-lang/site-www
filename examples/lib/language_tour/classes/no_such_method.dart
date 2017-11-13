import '../util/print.dart';

void main() {
  dynamic a = new A();
  a.foo();
}

// #docregion
class A {
  // Unless you override noSuchMethod, using a
  // non-existent member results in a NoSuchMethodError.
  @override
  void noSuchMethod(Invocation mirror) {
    $print('You tried to use a non-existent member: ' +
        '${mirror.memberName}');
  }
}
