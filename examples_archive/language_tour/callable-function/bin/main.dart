class WannabeFunction {
  void call(String a, String b, String c) => a + ' ' + b + ' ' + c + '!';
}

void main() {
  var wf = new WannabeFunction();
  var out = wf("Hi", "there,", "gang");
  print('$out');
}
