@TestOn('vm')
library;

import 'dart:io';

import 'package:dart_skills_lint/dart_skills_lint.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

final String _configFilePath = Directory.current.path.endsWith('site')
    ? 'dart_skills_lint.yaml'
    : 'site/dart_skills_lint.yaml';

void main() {
  test('Run skills linter', () async {
    // Enable logging to see detailed validation errors in test output.
    final oldLevel = Logger.root.level;
    Logger.root.level = Level.ALL;
    final subscription = Logger.root.onRecord.listen(
      (record) => print(record.message),
    );

    try {
      final config = await ConfigParser.loadConfig(
        path: _configFilePath,
      );
      final isValid = await validateSkills(config: config);
      expect(
        isValid,
        isTrue,
        reason: 'Skills validation failed. See above for details.',
      );
    } finally {
      Logger.root.level = oldLevel;
      await subscription.cancel();
    }
  });
}
