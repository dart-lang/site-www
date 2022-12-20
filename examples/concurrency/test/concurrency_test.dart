import 'package:concurrency_examples/sync_number_of_keys.dart'
    as sync_number_of_keys;
import 'package:concurrency_examples/async_number_of_keys.dart'
    as async_number_of_keys;
import 'package:concurrency_examples/simple_worker_isolate.dart'
    as simple_worker_isolate;
import 'package:concurrency_examples/simple_isolate_closure.dart'
    as simple_isolate_closure;
import 'package:test/test.dart';

Future<void> main() async {
  test('sync number of keys counts correctly', () {
    expect(() {
      sync_number_of_keys.main();
    }, prints('Number of JSON keys: 3\n'));
  });

  test('async number of keys counts correctly', () {
    expect(() async {
      async_number_of_keys.main();
      await Future.delayed(Duration(milliseconds: 250));
    }, prints('Number of JSON keys: 3\n'));
  });

  test('simple worker isolate counts number of keys correctly', () {
    expect(() async {
      simple_worker_isolate.main();
      await Future.delayed(Duration(milliseconds: 500));
    }, prints('Number of JSON keys: 3\n'));
  });

  test('simple closure isolate counts number of keys correctly', () {
    expect(() async {
      simple_isolate_closure.main();
      await Future.delayed(Duration(milliseconds: 500));
    }, prints('Number of JSON keys: 3\n'));
  });
}
