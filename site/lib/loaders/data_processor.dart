import 'package:collection/collection.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../lints.dart';

final class DataProcessor implements DataLoader {
  @override
  Future<void> loadData(Page page) async {
    final pageData = page.data['page'] as Map<String, Object?>;

    if (pageData['processLints'] == true) {
      final lintRules = loadLints(page.data['linter_rules']);

      final filteredLints = lintRules
          .where(
            (lint) =>
                lint.sinceDartSdk != 'Unreleased' &&
                !lint.sinceDartSdk.contains('wip') &&
                lint.state != 'removed' &&
                lint.state != 'internal',
          )
          .sortedBy((lint) => lint.name);

      page.apply(data: {'lintsToShow': filteredLints});
    }
  }
}
