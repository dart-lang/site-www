// update-for-dart-2
// Dart 2.0: hint • 'proxy' is deprecated and shouldn't be used
// ignore_for_file: deprecated_member_use

void main() {
  dynamic a = new A();
  a.doSomething();
}

// #docregion
@proxy
class A {
  @override
  void noSuchMethod(Invocation invocation) {
    // #enddocregion
    print('handling invocation: ${invocation.memberName}');
    // #docregion
  }
}
