import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;

void main() async {
  print('Verifying that the diagnostic messages file is up to date...');

  // Uncomment once linter rules are added to website
  // if (!await checkAsset(
  //     'https://raw.githubusercontent.com/dart-lang/linter/gh-pages/lints/machine/rules.json',
  //     '../src/_data/linter_rules.json')) {
  //   print('The linter rules file is outdated.');
  //   exit(1);
  // }

  if (!await checkAsset(
      'https://raw.githubusercontent.com/dart-lang/sdk/master/pkg/analyzer/tool/diagnostics/diagnostics.md',
      '../src/tools/diagnostic-messages.md')) {
    print('The diagnostic messages file is outdated.');
    exit(1);
  }

  print('The diagnostic messages file is up to date.');
}

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
