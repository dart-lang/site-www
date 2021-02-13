import 'package:test/test.dart';

import 'package:examples/language_tour/typedefs/misc.dart' as misc;
import 'package:examples/language_tour/typedefs/sorted_collection_1.dart'
    as sorted_collection_1;
import 'package:examples/language_tour/typedefs/sorted_collection_2.dart'
    as sorted_collection_2;

void main() {
  test('sorted_collection_1', () {
    sorted_collection_1.main(); // contains assertions
  });

  test('sorted_collection_2', () {
    sorted_collection_2.main(); // contains assertions
  });

  test('compare', () {
    misc.main(); // contains assertions
  });
}
