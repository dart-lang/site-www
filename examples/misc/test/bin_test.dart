import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../bin/cat_no_hash.dart' as cat_no_hash;

void main() {
  const pathToQuotes = 'test_data/quote.txt';

  test('cat_no_hash', () {
    final quotes = File(pathToQuotes);
    expect(quotes.readAsStringSync(), contains('#'));

    expect(
        () => cat_no_hash.main([quotes.path]),
        prints(
          isNot(contains('#')),
        ));
  });

  test('dcat', () async {
    final procResult = await Process.run(
        'dart', ['--enable-asserts', 'bin/dcat.dart', '-n', pathToQuotes]);
    expect(
        procResult.stdout,
        allOf(
          startsWith('1'), // Line number
          contains('Dr. Seuss'),
        ));
  });

  test('dcat1', () async {
    const greeting = '¡Hola, Mundo!';
    final process =
        await Process.start('dart', ['--enable-asserts', 'bin/dcat1.dart']);
    process.stdin.writeln(greeting);
    final output = await process.stdout.transform(Utf8Decoder()).join('');
    await process.stderr.drain();
    final exitCode = await process.exitCode;

    expect(exitCode, 0);
    expect(output, contains('You typed: $greeting'));
  });
}
