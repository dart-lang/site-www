@TestOn('vm')
library;

import 'package:dart_skills_lint/dart_skills_lint.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  test('Run skills linter', () async {
    // Enable logging to see detailed validation errors in test output.
    final oldLevel = Logger.root.level;
    Logger.root.level = Level.ALL;
    final subscription = Logger.root.onRecord.listen(
      (record) => print(record.message),
    );

    try {
      final isValid = await validateSkills(
        skillDirPaths: ['../.agents/skills'],
        resolvedRules: {
          'check-relative-paths': AnalysisSeverity.error,
          'check-absolute-paths': AnalysisSeverity.error,
          'check-trailing-whitespace': AnalysisSeverity.error,
        },
      );
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
