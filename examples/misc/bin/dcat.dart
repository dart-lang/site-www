// Copyright (c) 2013, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// IMPORTANT NOTE:
// 1. If you change this file, ensure that the associated tooltip data remains
//    valid (*_tooltips.html).
// 2. Regenerate the HTML version of this sample, by running
//    tool/create_code_with_tooltips.dart
// 3. To generate the DartPad version: (1) delete lines containly only tip
//    instructions. (2) Trim //!foo markers from the end of the remaining lines,
//    e.g., using this Perl regexp: / ?\/\/!.*//g

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

const lineNumber = 'line-number';

// #docregion arg-processing
ArgResults argResults;
// #enddocregion arg-processing

/// Simple implementation of the *nix cat utility. //!web-only
/// //!web-only
/// Usage: dart dcat.dart [-n] patterns files //!web-only
/// //!web-only
/// `dcat` reads `files` sequentially, writing them to standard output. The //!web-only
/// file operands are processed in command-line order. //!web-only
/// If `files` is absent, `dcat` reads from the standard input until `EOF`. //!web-only
/// //!web-only
/// Unlike the *nix `cat`, `dcat` does not support single dash ('-') arguments. //!web-only
// #docregion arg-processing
//!tip("List<String> arguments")
void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addFlag(lineNumber, negatable: false, abbr: 'n');

  //!tip("argResults = parser.parse(arguments)")
  argResults = parser.parse(arguments);
  final paths = argResults.rest;

  dcat(paths, argResults[lineNumber] as bool);
}
// #enddocregion arg-processing

//!tip("async")
Future dcat(List<String> paths, bool showLineNumbers) async {
  if (paths.isEmpty) {
    // No files provided as arguments. Read from stdin and print each line.
    // #docregion pipe
    //!tip("stdin.pipe(stdout)") //!tip("await")
    await stdin.pipe(stdout);
    // #enddocregion pipe
  } else {
    // #docregion for-path
    for (var path in paths) {
      var lineNumber = 1;
      final lines = utf8.decoder
          //!tip("openRead()") //!tip("File(path)")
          .bind(File(path).openRead())
          //!tip("transform(const LineSplitter())")
          .transform(const LineSplitter());
      //!tip("try")
      try {
        //!tip("await for (var line in lines)")
        await for (var line in lines) {
          // #docregion showLineNumbers
          if (showLineNumbers) {
            stdout.write('${lineNumber++} ');
          }
          stdout.writeln(line);
          // #enddocregion showLineNumbers
        }
        //!tip("catch")
      } catch (_) {
        await _handleError(path);
      }
    }
    // #enddocregion for-path
  }
}

// #docregion _handleError
Future _handleError(String path) async {
  //!tip("await FileSystemEntity.isDirectory(path)")
  // #docregion await-FileSystemEntity
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2; //!tip("exitCode = 2")
  }
  // #enddocregion await-FileSystemEntity
}
