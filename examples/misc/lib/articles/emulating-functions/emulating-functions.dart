// #docregion call-method
class WannabeFunction {
  int call(int a, int b) => a + b;
}
// #enddocregion call-method

void main() {
  // #docregion call-object-as-function
  var wf = WannabeFunction();
  assert(wf(3, 4) == 7);
  // #enddocregion call-object-as-function

  // We describe the signature of apply() in the article. These lines check to
  // make sure that that signature hasn't changed.
  var f = (String arg1, String arg2, {String arg3 = '!'}) {};
  var namedArgs = Map<Symbol, String>();
  namedArgs[const Symbol('arg3')] = '!!';
  Function.apply(f, ['hello', 'world'], namedArgs);
}
