// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:jaspr/jaspr.dart' show Component;
import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as p;

import '../components/common/tags.dart';
import '../markdown/markdown_parser.dart';
import '../models/lint_rules.dart';
import 'glossary.dart';

/// All pages that should be loaded from memory rather than
/// from content loaded from the file system.
List<MemoryPage> get allMemoryPages => [
  _glossaryPage,
  _allLinterRulesPage,
  _allLinterRulesJson,
  ..._lintMemoryPages,
];

/// The `/resources/glossary` page which hosts the [GlossaryIndex].
MemoryPage get _glossaryPage => MemoryPage.builder(
  path: 'resources/glossary.md',
  initialData: {
    'page': <String, Object?>{
      'title': 'Glossary',
      'showBreadcrumbs': false,
      'description':
          'A glossary reference for terminology '
          'used across dart.dev.',
      'showToc': false,
      'bodyClass': 'glossary-page',
    },
  },
  builder: (_) {
    return const GlossaryIndex();
  },
);

/// The date the lint rule docs were last extracted from the SDK.
/// Should be in `yyyy-mm-dd` format.
const String _lintsLastUpdated = '2025-08-16';

/// The individual linter rules pages, rendered to `/tools/linter-rules/<name>`.
List<MemoryPage> get _lintMemoryPages {
  final lintRules = readAndLoadLints();

  return [
    for (final lint in lintRules)
      MemoryPage.builder(
        path: p.join(
          'tools',
          'linter-rules',
          '${lint.name}.md',
        ),
        initialData: {
          'page': <String, Object?>{
            'title': lint.name,
            'underscore_breaker_titles': true,
            'description': 'Learn about the ${lint.name} linter rule.',
            if (lint.latestState.type == LintStateType.removed) ...const {
              'noindex': true,
              'sitemap': false,
            } else
              'sitemap': {
                'lastmod': _lintsLastUpdated,
              },
          },
        },
        builder: (context) {
          final incompatibleLintsText = StringBuffer();
          if (lint.incompatible.isNotEmpty) {
            incompatibleLintsText.writeln('## Incompatible rules\n');
            incompatibleLintsText.writeln(
              'The `${lint.name}` lint is incompatible with '
              'the following rules:',
            );
            incompatibleLintsText.writeln();
            for (final incompatibleLint in lint.incompatible) {
              incompatibleLintsText.writeln(
                '- [`$incompatibleLint`](/tools/linter-rules/$incompatibleLint)',
              );
            }
          }

          return Component.fragment(
            [
              Tags([
                switch (lint.latestState.type) {
                  LintStateType.deprecated => const Tag(
                    'Deprecated',
                    icon: 'report',
                    color: 'orange',
                    title: 'Lint is deprecated.',
                  ),
                  LintStateType.experimental => const Tag(
                    'Experimental',
                    icon: 'science',
                    color: 'orange',
                    title: 'Lint is experimental.',
                  ),
                  LintStateType.removed => const Tag(
                    'Removed',
                    icon: 'error',
                    color: 'red',
                    title: 'Lint has been removed.',
                  ),
                  LintStateType.stable =>
                    lint.latestState.isReleased
                        ? const Tag(
                            'Stable',
                            icon: 'verified_user',
                            color: 'green',
                            title: 'Lint is stable.',
                          )
                        : const Tag(
                            'Unreleased',
                            icon: 'pending',
                            color: 'orange',
                            title: 'Lint is unreleased or work in progress.',
                          ),
                  LintStateType.internal => throw StateError(
                    'An internal lint shouldn\'t be documented: ${lint.name}',
                  ),
                },

                if (lint.sets.contains('core'))
                  const Tag(
                    'Core',
                    icon: 'circles',
                    title: 'Lint is included in the core set of rules.',
                  )
                else if (lint.sets.contains('recommended'))
                  const Tag(
                    'Recommended',
                    icon: 'thumb_up',
                    title: 'Lint is included in the recommended set of rules.',
                  )
                else if (lint.sets.contains('flutter'))
                  const Tag(
                    'Flutter',
                    icon: 'flutter',
                    title: 'Lint is included in the Flutter set of rules.',
                  ),

                if (lint.fixStatus == LintFixStatus.hasFix)
                  const Tag(
                    'Fix available',
                    icon: 'build',
                    title: 'Lint has one or more quick fixes available.',
                  ),
              ]),
              DashMarkdown(
                content:
                    '''
${lint.description}

## Details

${lint.justification}

$incompatibleLintsText
''',
              ),
              DashMarkdown(
                content:
                    '''
<a id="usage" aria-hidden="true"></a>
## Enable

To enable the `${lint.name}` rule, add `${lint.name}` under
**linter > rules** in your [`analysis_options.yaml`](/tools/analysis) file:

```yaml title="analysis_options.yaml"
linter:
  rules:
    - ${lint.name}
```

If you're instead using the YAML map syntax to configure linter rules,
add `${lint.name}: true` under **linter > rules**:

```yaml title="analysis_options.yaml"
linter:
  rules:
    ${lint.name}: true
```
''',
              ),
            ],
          );
        },
      ),
  ];
}

final linterRulesToShow = readAndLoadLints()
    .where((lint) {
      final latestState = lint.latestState;
      return latestState.isReleased && latestState.type == LintStateType.stable;
    })
    .sortedBy((lint) => lint.name)
    .toList(growable: false);

/// The `/tools/linter-rules/all` page that includes an example
/// `analysis_options.yaml` file that enables all linter rules
/// that are available in the current stable release.
MemoryPage get _allLinterRulesPage {
  final allLinterRulesListAsString = linterRulesToShow
      .map((lint) => '    - ${lint.name}')
      .join('\n');

  return MemoryPage(
    path: 'tools/linter-rules/all.md',
    initialData: const {
      'page': <String, Object?>{
        'title': 'All linter rules',
        'description':
            'Auto-generated configuration enabling all linter rules.',
        'sitemap': {
          'lastmod': _lintsLastUpdated,
        },
      },
    },
    content:
        '''
The following is an auto-generated list of all linter rules
available in the Dart SDK as of version `{{site.sdkVersion}}`.
Add them to your
[`analysis_options.yaml`](/tools/analysis) file
and adjust as you see fit.

```yaml title="analysis_options.yaml"
linter:
  rules:
$allLinterRulesListAsString
```
''',
  );
}

/// A JSON rendered version of [_allLinterRulesPage].
MemoryPage get _allLinterRulesJson => MemoryPage(
  path: 'tools/linter-rules/all.json',
  keepSuffix: true,
  initialData: const {
    'page': <String, Object?>{
      'title': 'All of Dart\'s linter rules in JSON format',
      'description':
          'All released linter rules supported by '
          'the Dart analyzer in JSON format.',
      'sitemap': false,
    },
  },
  content:
      const JsonEncoder.withIndent(
        '  ',
      ).convert([
        for (final lint in linterRulesToShow)
          {
            'id': lint.name,
          },
      ]),
);
