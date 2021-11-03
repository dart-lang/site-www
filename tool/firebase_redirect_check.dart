import 'dart:collection';
import 'dart:convert';

import 'dart:io';

Future<void> main() async {
  final firebaseFile = File('../firebase.json');

  if (!(await firebaseFile.exists())) {
    stderr.writeln(
        'Error: Cannot find the firebase.json file in the root directory.');
    exit(1);
  }

  try {
    final firebaseConfigString = await firebaseFile.readAsString();
    final firebaseConfig = await jsonDecode(firebaseConfigString);

    final hostingConfig = firebaseConfig['hosting'];

    if (hostingConfig == null) {
      stderr.writeln(
          "Error: The firebase.json file is missing a top-level 'hosting' entry.");
      exit(1);
    }

    final redirects = hostingConfig['redirects'];

    if (redirects == null) {
      stdout.writeln(
          'There are no redirects specified within the firebase.json file.');
      return;
    }

    if (redirects is! List<dynamic>) {
      stderr.writeln(
          "Error: The firebase.json file's 'redirect' entry is not a list.");
      exit(1);
    }

    if (redirects.isEmpty) {
      return;
    }

    final sources = LinkedHashSet();

    var duplicatesFound = 0;

    for (final redirect in redirects) {
      final source = redirect['source'];
      if (source == null) {
        stderr.writeln(
            "Error: The firebase.json file has a redirect missing a 'source'.");
        exit(1);
      }

      if (source is! String) {
        stderr.writeln(
            "Error: The firebase.json redirect $redirect has a 'source' specified which is not a string.");
        exit(1);
      }

      if (sources.contains(source)) {
        stderr.writeln("Error: Multiple redirects share the '$source' source.");
        duplicatesFound += 1;
      }

      sources.add(source);
    }

    if (duplicatesFound > 0) {
      stderr.writeln(
          'Error: $duplicatesFound duplicate sources found in the firebase.json redirects.');
    }

    final sourcesCopy = List.of(sources, growable: false);
    sourcesCopy.sort();

    var index = 0;
    for (final source in sources) {
      final otherSource = sourcesCopy[index];

      if (source != otherSource) {
        stderr.writeln(
            "Error: The firebase.json file's redirects are not sorted by source:");
        stderr.writeln("Starting with: ${redirects[index]}");
        exit(1);
      }

      index++;
    }

    if (duplicatesFound > 0) {
      exit(1);
    }
  } catch (e) {
    stderr.writeln(
        'Error: Encountered an error when loading the firebase.json file:');
    print(e.toString());
    exit(1);
  }
}
