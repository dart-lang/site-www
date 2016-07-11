//
// 3/18/2015:
// Below is an example. It does 90% of its work via
// main -> doWork -> foo and 10% of its work via main -> doWork -> bar.
// This is a *conceptual* example of  how to read the profile tree,
// real world profiles are likely to be messier. 
//
// $ dart --observe profile.dart
//


import 'dart:math';

unitOfWork(int i) {
  var d = i.toDouble();
  for (var i = 0; i < 100000; i++) {
    d += d;
  }
  return sqrt(d);
}

foo(int i) => unitOfWork(i);

bar(int i) => unitOfWork(i);

doWork() {
  final total = 100;
  final inFoo = 90;
  var i;
  for (i = 0; i < inFoo; i++) {
    foo(i);
  }
  for (; i < total; i++) {
    bar(i);
  }
}

main() {
  while (true) {
    doWork();
  }

}
