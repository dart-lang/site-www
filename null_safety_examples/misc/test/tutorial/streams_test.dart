// ignore_for_file: type_annotate_public_apis
import 'package:test/test.dart';
import 'package:examples/tutorial/sum_stream.dart' as sum_stream;
import 'package:examples/tutorial/sum_stream_with_catch.dart'
    as sum_stream_with_catch;

void main() {
  test('sumStream', () => expect(sum_stream.main, prints('55\n')));
  test('sumStream with catch',
      () => expect(sum_stream_with_catch.main, prints('-1\n')));
}
