/// Simple implementation of the *nix cat utility.
///
/// Usage: `dart run dcat.dart [-n] patterns files`
///
/// `dcat` reads `files` sequentially, writing them to standard output.
/// The file operands are processed in command-line order.
/// If `files` is absent, `dcat` reads from the standard input until `EOF`.
/// Unlike the *nix `cat`, `dcat` does not support single dash ('-') arguments.
library;

// #docregion dcat-app
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

const lineNumber = 'line-number';

// #docregion arg-processing
void main(List<String> arguments) {
  exitCode = 0; // Presume success
  final parser = ArgParser()..addFlag(lineNumber, negatable: false, abbr: 'n');

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  dcat(paths, showLineNumbers: argResults[lineNumber] as bool);
}
// #enddocregion arg-processing

Future<void> dcat(List<String> paths, {bool showLineNumbers = false}) async {
  if (paths.isEmpty) {
    // No files provided as arguments. Read from stdin and print each line.
    // #docregion pipe
    await stdin.pipe(stdout);
    // #enddocregion pipe
  } else {
    // #docregion for-path
    for (final path in paths) {
      var lineNumber = 1;
      final lines = utf8.decoder
          .bind(File(path).openRead())
          .transform(const LineSplitter());
      try {
        await for (final line in lines) {
          // #docregion showLineNumbers
          if (showLineNumbers) {
            stdout.write('${lineNumber++} ');
          }
          stdout.writeln(line);
          // #enddocregion showLineNumbers
        }
      } catch (_) {
        await _handleError(path);
      }
    }
    // #enddocregion for-path
  }
}

// #docregion handle-error
Future<void> _handleError(String path) async {
  // #docregion await-entity
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
  // #enddocregion await-entity
}
// #enddocregion handle-error
// #enddocregion dcat-app
