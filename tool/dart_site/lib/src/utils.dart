import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

final bool _runningInCi = Platform.environment['CI'] == 'true';

void groupStart(String text) {
  if (_runningInCi) {
    print('::group::$text');
  } else {
    print('');
  }
}

void groupEnd() {
  if (_runningInCi) {
    print('::endgroup::');
  }
}

int runPubGetIfNecessary(String directory) {
  final pubGetOutput = Process.runSync(
    Platform.executable,
    const ['pub', 'get'],
    workingDirectory: directory,
  );

  if (pubGetOutput.exitCode != 0) {
    final normalOutput = pubGetOutput.stdout.toString();
    final errorOutput = pubGetOutput.stderr.toString();

    stderr.write(normalOutput);
    stderr.write(errorOutput);
    stderr.writeln('Error: Pub get in $directory failed.');
    return 1;
  }

  return 0;
}

extension ArgResultExtensions on ArgResults? {
  T get<T>(String key, T defaultValue) => this?[key] as T? ?? defaultValue;
}

/// A collection of the paths of all Dart projects with
/// a pubspec.yaml file in the `/examples` directory,
/// excluding ones in hidden directories or codelabs.
final List<String> dartProjectExampleDirectories =
    findNestedDirectoriesWithPubspec(
  Directory('examples'),
  skipPaths: {},
  skipHidden: true,
)..sort();

List<String> findNestedDirectoriesWithPubspec(
  Directory rootDirectory, {
  Set<String> skipPaths = const {},
  bool skipHidden = true,
}) {
  final normalizedPath = path.normalize(rootDirectory.path);

  // Base case: Doesn't exist, skipped, or hidden.
  if (skipPaths.contains(normalizedPath) ||
      (skipHidden && path.basename(normalizedPath).startsWith('.')) ||
      !rootDirectory.existsSync()) {
    return const <String>[];
  }

  final directoriesWithPubspec = <String>[];

  for (final entity in rootDirectory.listSync()) {
    if (entity is Directory) {
      // If this entity is a direct, recurse in to it
      // to find any pubspec files.
      directoriesWithPubspec.addAll(findNestedDirectoriesWithPubspec(
        entity,
        skipPaths: skipPaths,
        skipHidden: skipHidden,
      ));
    } else if (entity is File && path.basename(entity.path) == 'pubspec.yaml') {
      // If the directory has a pubspec.yaml file, this directory counts.
      directoriesWithPubspec.add(normalizedPath);
    }
  }

  return directoriesWithPubspec;
}
