// ignore_for_file: one_member_abstracts
// #docregion call-method
class WannabeFunction {
  int call(int a, int b) => a + b;
}
// #enddocregion call-method

abstract class Fooer {
  // Define foo, so we can call NsmTest().foo().
  void foo();
}

class NsmTest extends Fooer {
  void baz() => print('Called baz!');

  // #docregion no-such-method
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return invocation.memberName == #foo
        ? Function.apply(
            baz, invocation.positionalArguments, invocation.namedArguments)
        : super.noSuchMethod(invocation);
  }
  // #enddocregion no-such-method
}

typedef BinaryOperation<T> = T Function(T first, T second);
BinaryOperation<int> add;

void main() {
  // #docregion call-object-as-function
  var wf = WannabeFunction();
  assert(wf(3, 4) == 7);
  // #enddocregion call-object-as-function

  // Confirm that WannabeFunction instances are assignable to
  // BinaryOperations<int>.
  add = wf;
  assert(add(4, 5) == 9);

  // We describe the signature of apply() in the article. These lines check to
  // make sure that that signature hasn't changed.
  var f = (String arg1, String arg2, {String arg3 = '!'}) {
    print('apply worked');
  };
  var namedArgs = Map<Symbol, String>();
  namedArgs[const Symbol('arg3')] = '!!';
  Function.apply(f, ['hello', 'world'], namedArgs);

  // Confirm that the unimplemented method foo() can be called (thanks to
  // noSuchMethod().
  var test = NsmTest();
  test.foo();
}
