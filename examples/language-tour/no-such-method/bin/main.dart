void main() {
  var a = new A();
  //a.bar();
  //a.baz;
}

//BEGIN
class A {
  // Unless you override noSuchMethod, using a
  // non-existent member results in a NoSuchMethodError.
  @override
  void noSuchMethod(Invocation mirror) {
    print('You tried to use a non-existent member:' + '${mirror.memberName}');
  }
}
//END
