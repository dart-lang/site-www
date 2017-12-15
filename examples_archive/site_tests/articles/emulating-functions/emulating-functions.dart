typedef BinaryFunction(a,b);

class WannabeFunction {
  call(int a, int b) => a + b;
}

class NsmDummy {
  void foo() {
    print('foo');
  }
}

class NsmTester {

  NsmDummy bar() {
    return new NsmDummy();
  }

  void baz() {
    print('baz: not foo');
  }

  noSuchMethod(Invocation invocation) =>
    invocation.memberName == #foo
      ?  Function.apply(baz,
                        invocation.positionalArguments,
                        invocation.namedArguments)
      : super.noSuchMethod(invocation);
}

void main() {
  var wf = new WannabeFunction();
  assert(wf(3, 4) == 7);

  assert(new WannabeFunction() is BinaryFunction);

  // We describe the signature of apply() in the article. These lines check to
  // make sure that that signature hasn't changed.
  var f = (String arg1, String arg2, {String arg3: '!'}) {};
  var namedArgs = new Map<Symbol, String>();
  namedArgs[const Symbol('arg3')] = '!!';
  Function.apply(f, ['hello', 'world'], namedArgs);

  NsmTester nsm = new NsmTester();
  nsm.foo();  // Produces warning.
  nsm.bleh(); // Produces warning.
}
