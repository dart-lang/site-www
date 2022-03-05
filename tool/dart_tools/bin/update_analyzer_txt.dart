import 'dart:io';
import 'package:path/path.dart' as path;

void main(List<String> args) async {
  final channel = await getDartChannel();
  print('updating analyzer text using $channel channel SDK.');

  final currentDirectoryComponents = path.split(Directory.current.path);
  final siteRoot = path.joinAll(currentDirectoryComponents.sublist(
      0, currentDirectoryComponents.length - 2));

  final examplesDir = Directory(path.absolute(path.join(siteRoot, 'examples')));
  final examples = await examplesDir
      .list()
      .where((event) => event is Directory)
      .cast<Directory>()
      .toList();

  for (final example in examples) {
    await writeAnalyzerResultsFile(example, channel);
  }
}

Future<void> writeAnalyzerResultsFile(
    Directory directory, String channel) async {
  print('Running "pub get" in ${directory.path}');
  await Process.run('dart', ['pub', 'get'], workingDirectory: directory.path);
  print('Running "dart analyze" in ${directory.path}');

  final output =
      await Process.run('dart', ['analyze'], workingDirectory: directory.path);

  if (output.exitCode == 0) {
    print('no analyzer results to write.');
    return;
  }
  if (output.exitCode != 3) {
    throw Exception(
        'Unexpected exit code: ${output.exitCode}\n${output.stderr}');
  }

  var analyzerFile =
      File(path.join(directory.path, 'analyzer-results-$channel.txt'));
  if (!await analyzerFile.exists()) {
    analyzerFile = File(path.join(directory.path, 'analyzer-results.txt'));
  }

  print('writing results to ${analyzerFile.path}');
  final stdout = output.stdout;
  if (stdout is! String) {
    return;
  }
  await analyzerFile.writeAsString(stdout);
}

Future<String> getDartChannel() async {
  final version = await Process.run('dart', ['--version']);
  final regex = RegExp(r'version: \S+ \(([a-z]+)\)');
  final stderr = version.stderr;
  if (stderr is! String) {
    return 'missing';
  }
  final match = regex.firstMatch(stderr);
  return match?.group(1) ?? 'missing';
}
