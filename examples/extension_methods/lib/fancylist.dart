// #docregion
extension MyFancyList<T> on List<T> {
  int get doubleLength => length * 2;
  List<T> operator -() => reversed.toList();
  List<List<T>> split(int at) => [sublist(0, at), sublist(at)];
}
// #enddocregion

extension MyIntList on List<int> {
  int get tripleLength => length * 3;
}
