// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show JsonEncoder;
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../lints/lint_parser.dart';
import '../utils.dart';

final class GenerateLintDocs extends Command<int> {
  @override
  String get description => 'Generate and update lint docs.';

  @override
  String get name => 'generate-lints';

  @override
  Future<int> run() => _updateLintInfo();
}

Future<int> _updateLintInfo() async {
  final client = http.Client();

  /// Fetches content from the specified [url].
  Future<String> fetchUrl(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch $url: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    return response.body;
  }

  try {
    print('Fetching lint-related data files...');
    final lintRules = parseLintRules(
      messagesYaml: await fetchUrl(
        'https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/main/pkg/linter/messages.yaml',
      ),
      fixStatusYaml: await fetchUrl(
        'https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/main/pkg/analysis_server/lib/src/services/correction/error_fix_status.yaml',
      ),
      coreLintsYaml: await fetchUrl(
        'https://raw.githubusercontent.com/dart-lang/core/refs/heads/main/pkgs/lints/lib/core.yaml',
      ),
      recommendedLintsYaml: await fetchUrl(
        'https://raw.githubusercontent.com/dart-lang/core/refs/heads/main/pkgs/lints/lib/recommended.yaml',
      ),
      flutterLintsYaml: await fetchUrl(
        'https://raw.githubusercontent.com/flutter/packages/refs/heads/main/packages/flutter_lints/lib/flutter.yaml',
      ),
    );

    print('Generating JSON file...');
    final outputPath = path.join(
      repositoryRoot,
      'src',
      'data',
      'lint-info.json',
    );
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(lintRules);

    final file = File(outputPath);
    file.writeAsStringSync('$jsonString\n', flush: true);

    print('Successfully generated lint information file at: $outputPath');
    print('Total lint rules: ${lintRules.length}');

    print('Lint information generation completed successfully!');
  } catch (e, _) {
    print('Error generating lint information:\n\n$e');
  } finally {
    client.close();
  }

  return 0;
}
