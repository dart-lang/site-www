// ignore_for_file: non_constant_identifier_names
// #docregion read-from-stream
// #docregion import
import 'dart:io';
// #enddocregion import
import 'dart:convert';

// #enddocregion read-from-stream
import 'package:test/test.dart';
import 'package:examples/library_tour/io/http_server.dart' as http_server;
import 'package:examples_util/print_matcher.dart' as m;

void main() {
  test('readAsString, readAsLines', () async {
    // #docregion readAsString
    void main() async {
      var config = File('test_data/config.txt');

      // Put the whole file in a single string.
      var stringContents = await config.readAsString();
      print('The file is ${stringContents.length} characters long.');

      // Put each line of the file into its own string.
      var lines = await config.readAsLines();
      print('The file is ${lines.length} lines long.');
    }
    // #enddocregion readAsString

    expect(
        main,
        m.prints(
            ['The file is 58 characters long.', 'The file is 4 lines long.']));
  });

  test('readAsBytes', () {
    // #docregion readAsBytes
    void main() async {
      var config = File('test_data/config.txt');

      var contents = await config.readAsBytes();
      print('The file is ${contents.length} bytes long.');
    }
    // #enddocregion readAsBytes

    expect(main, m.prints('The file is 58 bytes long.'));
  });

  test('try-catch', () {
    // #docregion try-catch
    void main() async {
      var config = File('does-not-exist.txt');
      try {
        var contents = await config.readAsString();
        print(contents);
      } catch (e) {
        print(e);
      }
    }

    // #enddocregion try-catch
    expect(main, prints(contains('Cannot open file')));
  });

  test('read-from-stream', () {
    expect(
        main_test_read_from_stream,
        prints(allOf([
          contains(RegExp(r'Got \d+ characters from stream')),
          contains('file is now closed'),
        ])));
  });

  test('write-file', () async {
    // #docregion write-file
    var logFile = File('test_data/log.txt');
    var sink = logFile.openWrite();
    sink.write('FILE ACCESSED ${DateTime.now()}\n');
    await sink.flush();
    await sink.close();
    // #enddocregion write-file
    try {
      expect(logFile.existsSync(), isTrue);
      expect(logFile.readAsStringSync(), startsWith('FILE ACCESSED'));
    } finally {
      await logFile.delete();
    }
  });

  test('list-dir', () {
    // #docregion list-dir
    void main() async {
      var dir = Directory('test_data');

      try {
        var dirList = dir.list();
        await for (final FileSystemEntity f in dirList) {
          if (f is File) {
            print('Found file ${f.path}');
          } else if (f is Directory) {
            print('Found dir ${f.path}');
          }
        }
      } catch (e) {
        print(e.toString());
      }
    }

    // #enddocregion list-dir
    expect(main, prints(contains('Found file')));
  });

  test('client-server', () async {
    // #docregion client
    Future<void> main() async {
      var url = Uri.parse('http://localhost:8888/dart');
      var httpClient = HttpClient();
      var request = await httpClient.getUrl(url);
      var response = await request.close();
      var data = await utf8.decoder.bind(response).toList();
      print('Response ${response.statusCode}: $data');
      httpClient.close();
    }
    // #enddocregion client

    http_server.stopAfter = 1;
    void clientAndServer() => Future.wait([
          http_server.main(),
          main(),
        ]);
    expect(
        clientAndServer,
        m.prints([
          'Got request for /dart',
          'Response 200: [Hello from the server]'
        ]));
  });
}

// The following function is defined here so that it is left
// aligned with the import statements, which are also
// included in the excerpt.

// #docregion read-from-stream
void main_test_read_from_stream() async {
  var config = File('test_data/config.txt');
  Stream<List<int>> inputStream = config.openRead();

  // #docregion utf8-decoder
  var lines = utf8.decoder.bind(inputStream).transform(const LineSplitter());
  try {
    await for (final line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } catch (e) {
    print(e);
  }
  // #enddocregion utf8-decoder
}
// #enddocregion read-from-stream

/// No tests below this point. Excerpts only illustrate declarations.
void miscDeclAnalyzedButNotTested() {
  {
    var logFile = File('test_data/log.txt');
    // #docregion append
    var sink = logFile.openWrite(mode: FileMode.append);
    // #enddocregion append
    sink.close();
  }
}
