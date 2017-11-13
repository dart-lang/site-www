void main() {
  var a = new A();
  a.doSomething();
  a.doSomeOtherThing();
}

class SomeClass {
  void doSomething() {}
}

class SomeOtherClass {
  void doSomeOtherThing() {}
}

// #docregion
class A implements SomeClass, SomeOtherClass {
  @override
  void noSuchMethod(Invocation mirror) {
    // #enddocregion
    print('handling invocation: ${mirror.memberName}');
    // #docregion
  }
}
