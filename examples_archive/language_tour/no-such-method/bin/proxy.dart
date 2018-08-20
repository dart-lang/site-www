void main() {
  var a = new A();
  a.doSomething();
}

// #docregion
@proxy
class A {
  @override
  void noSuchMethod(Invocation mirror) {
    // #enddocregion
    print('handling invocation: ${mirror.memberName}');
    // #docregion
  }
}
