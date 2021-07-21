import 'dart:convert';
import 'dart:io';

import 'package:dart_sdk_archive/src/generator.dart';
import 'package:grinder/grinder.dart';
import 'package:dart_style/dart_style.dart';

void main(List<String> args) => grind(args);

@DefaultTask('Build SVN Revision JSON')
void buildJson() async {
  print('fetching SVN versions...');
  var filePath = 'lib/src/svn_versions.dart';
  var generator = SvnVersionGenerator();
  var svnVersions = await generator.svnVersions;
  var file = File(filePath);
  var jsonStr = json.encode(svnVersions);
  var fileContents = '''
const Map<String, String> svnVersions = $jsonStr;
  ''';
  var formatted = DartFormatter().format(fileContents);

  file.writeAsBytesSync(utf8.encode(formatted));
  print('$filePath written');
}
