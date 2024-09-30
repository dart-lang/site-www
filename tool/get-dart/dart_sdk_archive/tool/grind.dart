// ignore_for_file: unreachable_from_main

import 'dart:convert';
import 'dart:io';

import 'package:dart_sdk_archive/src/generator.dart';
import 'package:dart_style/dart_style.dart';
import 'package:grinder/grinder.dart';

Future<void> main(List<String> args) async => await grind(args);

@DefaultTask('Build SVN Revision JSON')
void buildJson() async {
  print('fetching SVN versions...');
  final filePath = 'lib/src/svn_versions.dart';
  final generator = SvnVersionGenerator();
  final svnVersions = await generator.svnVersions;
  final file = File(filePath);
  final jsonStr = json.encode(svnVersions);
  final fileContents = '''
const Map<String, String> svnVersions = $jsonStr;
  ''';
  final formatted = DartFormatter().format(fileContents);

  file.writeAsBytesSync(utf8.encode(formatted));
  print('$filePath written');
}
