// ignore_for_file: sort_constructors_first
class FooException implements Exception {
  final String? msg;

  const FooException([this.msg]);

  @override
  String toString() => msg ?? 'FooException';
}
