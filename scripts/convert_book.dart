#!/usr/bin/env dart

import 'dart:io';
import 'package:path/path.dart' as path;

Directory outputDir;

String frontMatter(title) {
  final yaml = """
---
# WARNING: GENERATED FILE. DO NOT EDIT.
# WANT TO CONTRIBUTE? SEE https://github.com/dart-lang/dart-up-and-running-book
layout: book
title: "${title} from Dart: Up and Running"
description: "Read ${title} of Dart: Up and Running, published by O'Reilly."
---
""";
  return yaml;
}

convertFile(String fileName) {
  print(fileName);
  var file = new File(fileName);
  var contents = file.readAsStringSync();
  var title = new RegExp(r'<title>(.*)</title>').firstMatch(contents)[1];
  var start = contents.indexOf(r'<div class="navheader">');
  var end = contents.lastIndexOf(r'</body></html>');
  var body = contents.substring(start, end);
  var filenameOnly = path.basename(fileName);

  writeFile(filenameOnly, title, body);
}

writeFile(String fileName, String title, String body) {
  var out = new File('${outputDir.path}/${fileName}');
  out.writeAsStringSync(frontMatter(title));
  out.writeAsStringSync(body, mode: FileMode.append);
}

checkDir(Directory dir) {
  if (!dir.existsSync()) {
    print("Directory '${dir.path}' does not exist");
    exit(1);
  }
}

main(List<String> args) {
  //var args = new Options().arguments;
  if (args.length != 2) {
    print("Usage: convert_book.dart dir_of_html output_dir");
    exit(1);
  }

  var inputDir = new Directory(args[0]);
  outputDir = new Directory(args[1]);
  checkDir(inputDir);
  checkDir(outputDir);

  List<FileSystemEntity> filenames = inputDir.listSync();
  filenames
      .map((f) => f.path)
      .where((name) => name.endsWith(".html"))
      .forEach((name) => convertFile(name));
}
