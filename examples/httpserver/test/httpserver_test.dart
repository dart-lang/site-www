import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import '../bin/hello_world_server.dart' as hello_world_server;
import '../bin/number_thinker.dart' as number_thinker;
import '../bin/number_guesser.dart' as number_guesser;
import '../bin/basic_writer_client.dart' as basic_writer_client;
import '../bin/basic_writer_server.dart' as basic_writer_server;

void main() {
  test('hello_world_server', () {
    _test() async {
      expect(await getUrl('localhost', 4040), 'Hello, world!');
    }

    expect(
        () => Future.any([
              hello_world_server.main(),
              _test(),
            ]),
        prints(startsWith('listening on localhost:4040')));
  });

  group('number_thinker and number_guesser:', () {
    // Only resolve the server once for all tests in this group to avoid
    // "binding multiple times on the same (address, port) combination".
    Future _server;
    Future getServer() => _server ??= number_thinker.main();

    test('number_thinker response', () {
      _test() async {
        expect(await getUrl('localhost', 4041), anyOf('true\n', 'false\n'));
      }

      expect(
          () => Future.any([
                getServer(),
                _test(),
              ]),
          prints(allOf(
            startsWith("I'm thinking of a number:"),
            contains('Request handled.'),
          )));
    });

    test('client bad guess', () async {
      expect(
          () => Future.any([
                getServer(),
                number_guesser.checkGuess(99),
              ]),
          prints(allOf(
            contains('Guess is 99.'),
            contains('Bad guess'),
          )));
    });

    test('client good guess', () async {
      _test() async {
        // For now, guess each number in turn
        // (rather than having to mock the int generator).
        for (var i = 0; i < 10; i++) {
          if (await number_guesser.checkGuess(i)) return;
        }
      }

      expect(
          () => Future.any([
                getServer(),
                _test(),
              ]),
          prints(contains('Good guess')));
    });
  });

  group('basic_writer_client and server:', () {
    final file = new File('file.txt');
    final port = 4049;

    // Only resolve the server once for all tests in this group to avoid
    // "binding multiple times on the same (address, port) combination".
    Future server = basic_writer_server.main();

    void deleteTmpFile() {
      if (file.existsSync()) file.delete();
    }

    setUp(deleteTmpFile);
    tearDown(deleteTmpFile);

    test('GET', () async {
      _test() async {
        expect(await getUrl('localhost', port), 'Unsupported request: GET.');
      }

      expect(
        () async => Future.any([
              server,
              _test(),
            ]),
        prints(''),
      );
    });

    test('basic_writer_client and server', () async {
      final expectedJson =
          '{"name":"Han Solo","job":"reluctant hero","BFF":"Chewbacca",'
          '"ship":"Millennium Falcon","weakness":"smuggling debts"}';

      _test() async {
        // Test POST
        await basic_writer_client.main();
        expect(expectedJson, file.readAsStringSync());
      }

      expect(
        () async => Future.any([
              server,
              _test(),
            ]),
        prints('Wrote data for Han Solo.\n'),
      );
    });
  });
}

Future<String> getUrl([
  String host = 'localhost',
  int port = 8080,
  String path = '',
]) async {
  final request = await new HttpClient().get(host, port, path);
  final response = await request.close();
  final data = await response.transform(UTF8.decoder).toList();
  return data.join('');
}
