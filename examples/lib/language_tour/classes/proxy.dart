// update-for-dart-2
// Dart 2.0: hint • 'proxy' is deprecated and shouldn't be used
// ignore_for_file: deprecated_member_use

import '../util/print.dart';

void main() {
  dynamic a = new A();
  a.doSomething();
}

// #docregion
@proxy
class A {
  @override
  void noSuchMethod(Invocation mirror) {
    // #enddocregion
    $print('handling invocation: ${mirror.memberName}');
    // #docregion
  }
}
