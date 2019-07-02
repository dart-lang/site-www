// ignore_for_file: annotate_overrides
// ignore_for_file: inconsistent_method_inheritance # Prior to 2.1-dev
// ignore_for_file: inconsistent_inheritance
// ignore_for_file: invalid_override_from_base
// ignore_for_file: invalid_override, type_annotate_public_apis
// ignore_for_file: conflicting_generic_interfaces
// ignore_for_file: sort_constructors_first
// #docregion MyList-and-main
import 'dart:collection';

class MyList extends ListBase<int> implements List {
  Object length;

  MyList(this.length);

  operator [](index) => 'world';
  operator []=(index, value) {}
}

void main() {
  List<int> list = MyList('hello');
  info(list);
}
// #enddocregion MyList-and-main

// #docregion info
void info(List<int> list) {
  var length = list.length;
  if (length != 0) print(length + list[0]);
}
