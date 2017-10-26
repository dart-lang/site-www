main() {
  throw new FooException();
}

class FooException implements Exception {
  final String msg;
  const FooException([this.msg]);
  String toString() => msg ?? 'FooException (no message)';
}
