void main() {
  dynamic a = A();
  a.foo();
}

// #docregion no-such-method-impl
class A {
  // Unless you override noSuchMethod, using a
  // non-existent member results in a NoSuchMethodError.
  @override
  void noSuchMethod(Invocation invocation) {
    print('You tried to use a non-existent member: '
        '${invocation.memberName}');
  }
}
// #enddocregion no-such-method-impl
