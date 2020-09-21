import 'dart:io';
import 'package:path/path.dart' as path;

String channel;

void main(List<String> args) async {
  channel = await getDartChannel();
  print('updating analyzer text using $channel channel SDK.');
  var currentDirectoryComponents = path.split(Directory.current.path);
  var siteRoot = path.joinAll(currentDirectoryComponents.sublist(
      0, currentDirectoryComponents.length - 2));
  var examplesDir = Directory(path.absolute(path.join(siteRoot, 'examples')));
  var examples =
      await examplesDir.list().where((event) => event is Directory).toList();
  for (var example in examples) {
    await writeAnalyzerResultsFile(example);
  }
}

Future writeAnalyzerResultsFile(Directory directory) async {
  print('Running "pub get" in ${directory.path}');
  await Process.run('dart', ['pub', 'get'], workingDirectory: directory.path);
  print('Running "dart analyze" in ${directory.path}');

  // TODO @johnpryan: After dart CLI ships in stable, use dart analyze for all channels.
  var output;
  if (channel == 'stable') {
    output = await Process.run('dartanalyzer', ['.'],
        workingDirectory: directory.path);
  } else {
    output = await Process.run('dart', ['analyze'],
        workingDirectory: directory.path);
  }
  if (output.exitCode == 0) {
    print('no analyzer results to write.');
    return;
  }
  if (output.exitCode != 3) {
    throw ('Unexpected exit code: ${output.exitCode}\n${output.stderr}');
  }

  File analyzerFile;
  analyzerFile =
      File(path.join(directory.path, 'analyzer-results-$channel.txt'));
  if (!await analyzerFile.exists()) {
    analyzerFile = File(path.join(directory.path, 'analyzer-results.txt'));
  }
  print('writing results to ${analyzerFile.path}');
  await analyzerFile.writeAsString(output.stdout);
}

Future<String> getDartChannel() async {
  var version = await Process.run('dart', ['--version']);
  var regex = RegExp(r'version: \S+ \(([a-z]+)\)');
  var match = regex.firstMatch(version.stderr);
  return match.group(1);
}
