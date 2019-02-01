void showImplicitDynamic(Object someValue) {
  // #docregion implicit-dynamic
  Object o = someValue;
  String s = o; // Implicit downcast
  String s2 = s.substring(1);
  // #enddocregion implicit-dynamic
  print('substring: $s2');
}

void main() {
  showImplicitDynamic(Object());
}
