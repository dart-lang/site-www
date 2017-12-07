import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import '../bin/hello_world_server.dart' as hello_world_server;

void main() {
  test('hello_world_server', () async {
    _test() async {
      expect(await getString('localhost', 4040), 'Hello, world!');
    }

    await Future.any([
      hello_world_server.main(),
      _test(),
    ]);
  });
}

Future<String> getString(String host, int port, [String path = '']) async {
  final request = await new HttpClient().get(host, port, path);
  final response = await request.close();
  final data = await response.transform(UTF8.decoder).toList();
  return data.join('');
}
