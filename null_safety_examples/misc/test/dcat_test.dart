import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  const pathToQuotes = 'test_data/quote.txt';

  test('dcat', () async {
    final procResult = await Process.run(
        'dart', ['--enable-asserts', 'bin/dcat/dcat.dart', '-n', pathToQuotes]);
    expect(
        procResult.stdout,
        allOf(
          startsWith('1'), // Line number
          contains('Dr. Seuss'),
          endsWith('Nietzsche\n'),
        ));
  });

  test('dcat1', () async {
    const greeting = '¡Hola, Mundo!';
    final process = await Process.start(
        'dart', ['--enable-asserts', 'bin/dcat/dcat1.dart']);
    process.stdin.writeln(greeting);
    final output = await process.stdout.transform(Utf8Decoder()).join('');
    final errors = await process.stderr.transform(Utf8Decoder()).join('');

    expect(await process.exitCode, 0);
    expect(output, contains('You typed: $greeting'));
    expect(errors, isEmpty);
  });
}
