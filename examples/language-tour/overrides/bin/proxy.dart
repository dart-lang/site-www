@proxy
class A {
  @override
  void noSuchMethod(Invocation mirror) {
    print('handling invocation: ${mirror.memberName}');
  }
}

void main() {
  var a = new A();
  a.doSomething();
}
