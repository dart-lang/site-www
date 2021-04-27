import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

void main() async {
  print(
      'Verifying that the diagnostic messages and linter rules files are up to date...');

  // Check linter's machine generated rules file
  if (!await checkAsset(
      'https://raw.githubusercontent.com/dart-lang/linter/gh-pages/lints/machine/rules.json',
      '../src/_data/linter_rules.json')) {
    print('The linter rules file is outdated.');
    exit(1);
  }

  // Check analyzer's diagnostic messages file
  if (!await checkAsset(
      'https://raw.githubusercontent.com/dart-lang/sdk/master/pkg/analyzer/tool/diagnostics/diagnostics.md',
      '../src/tools/diagnostic-messages.md')) {
    print('The diagnostic messages file is outdated.');
    exit(1);
  }

  print('The diagnostic messages and linter rules files are up to date.');
}

/// Check if the asset as the specified remote [url] and the local [path]
/// share the same contents.
Future<bool> checkAsset(final String url, final String path) async {
  final remote = await http.get(Uri.parse(url));
  if (remote.statusCode == 200) {
    final local = File(path);
    final remoteContent = remote.body;
    final localContent = local.readAsStringSync();
    if (remoteContent.length == localContent.length) {
      return remoteContent == localContent;
    }
  }
  return false;
}
