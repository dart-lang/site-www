// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:jaspr/jaspr.dart' show Component, a, p, span, text;
import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as path;

import '../components/common/tags.dart';
import '../markdown/markdown_parser.dart';
import '../models/diagnostic_model.dart';
import '../models/lints.dart';
import 'glossary.dart';

/// All pages that should be loaded from memory rather than
/// from content loaded from the file system.
List<MemoryPage> get allMemoryPages => [
  _glossaryPage,
  _allLinterRulesPage,
  _allLinterRulesJson,
  ..._lintMemoryPages,
  ..._diagnosticMemoryPages,
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

/// The date the diagnostic and lint docs were last extracted from the SDK.
/// Should be in `yyyy-mm-dd` format.
const String _diagnosticsLastUpdated = '2025-12-07';

/// The individual diagnostic message pages,
/// rendered at `/tools/diagnostics/<name>`.
List<MemoryPage> get _diagnosticMemoryPages {
  final diagnostics = readAndLoadDiagnostics();

  return [
    for (final diagnostic in diagnostics.where((d) => d.hasDocumentation)) ...[
      MemoryPage.builder(
        path: path.join(
          'tools',
          'diagnostics',
          '${diagnostic.id}.md',
        ),
        initialData: {
          'page': <String, Object?>{
            'title': diagnostic.id,
            'underscore_breaker_titles': true,
            'description':
                'Details about the \'${diagnostic.id}\' diagnostic '
                'produced by the Dart analyzer.',
            'bodyClass': 'highlight-diagnostics',
            'sitemap': {
              'lastmod': _diagnosticsLastUpdated,
            },
          },
        },
        builder: (context) {
          return Component.fragment(
            [
              if (diagnostic.fromLint)
                Tags([
                  Tag(
                    'Lint rule',
                    icon: 'toggle_on',
                    title:
                        'Learn about the lint rule that '
                        'enables this diagnostic.',
                    link: '/tools/linter-rules/${diagnostic.id}',
                  ),
                ]),
              DashMarkdown(
                content: [
                  if (diagnostic.previousNames.isNotEmpty)
                    diagnostic.previousNames
                        .map((oldName) => '_(Previously known as `$oldName`._)')
                        .join('\n\n'),
                  diagnostic.description,
                  ?diagnostic.documentation,
                ].where((s) => s.isNotEmpty).join('\n\n'),
              ),
            ],
          );
        },
      ),
      for (final previousDiagnosticName in diagnostic.previousNames)
        MemoryPage.builder(
          path: path.join(
            'tools',
            'diagnostics',
            '$previousDiagnosticName.md',
          ),
          initialData: {
            'page': <String, Object?>{
              'title': previousDiagnosticName,
              'underscore_breaker_titles': true,
              'description':
                  'Details about the \'$previousDiagnosticName\' diagnostic '
                  'produced by the Dart analyzer.',
              'canonical':
                  'https://dart.dev/tools/diagnostics/${diagnostic.id}',
              'redirectTo': '/tools/diagnostics/${diagnostic.id}',
              'noindex': true,
              'sitemap': false,
            },
          },
          builder: (context) {
            return p([
              span([text('Diagnostic renamed to: ')]),
              a(href: '/tools/diagnostics/${diagnostic.id}', [
                text(diagnostic.id),
              ]),
            ]);
          },
        ),
    ],
  ];
}

/// The individual linter rules pages, rendered to `/tools/linter-rules/<name>`.
List<MemoryPage> get _lintMemoryPages {
  final lintRules = readAndLoadLints();

  return [
    for (final lint in lintRules)
      MemoryPage.builder(
        path: path.join(
          'tools',
          'linter-rules',
          '${lint.id}.md',
        ),
        initialData: {
          'page': <String, Object?>{
            'title': lint.name,
            'underscore_breaker_titles': true,
            'description': 'Learn about the ${lint.name} linter rule.',
            if (lint.state == 'removed') ...const {
              'noindex': true,
              'sitemap': false,
            } else
              'sitemap': {
                'lastmod': _diagnosticsLastUpdated,
              },
          },
        },
        builder: (context) {
          final incompatibleLintsText = StringBuffer();
          if (lint.incompatibleLints.isNotEmpty) {
            incompatibleLintsText.writeln('## Incompatible rules\n');
            incompatibleLintsText.writeln(
              'The `${lint.id}` lint is incompatible with the following rules:',
            );
            incompatibleLintsText.writeln();
            for (final incompatibleLint in lint.incompatibleLints) {
              incompatibleLintsText.writeln(
                '- [`$incompatibleLint`](/tools/linter-rules/$incompatibleLint)',
              );
            }
          }

          return Component.fragment(
            [
              Tags([
                if (lint.sinceDartSdk == 'Unreleased' ||
                    lint.sinceDartSdk.contains('-wip'))
                  const Tag(
                    'Unreleased',
                    icon: 'pending',
                    color: 'orange',
                    title: 'Lint is unreleased or work in progress.',
                  )
                else if (lint.state == 'experimental')
                  const Tag(
                    'Experimental',
                    icon: 'science',
                    color: 'orange',
                    title: 'Lint is experimental.',
                  )
                else if (lint.state == 'deprecated')
                  const Tag(
                    'Deprecated',
                    icon: 'report',
                    color: 'orange',
                    title: 'Lint is deprecated.',
                  )
                else if (lint.state == 'removed')
                  const Tag(
                    'Removed',
                    icon: 'error',
                    color: 'red',
                    title: 'Lint has been removed.',
                  )
                else
                  const Tag(
                    'Stable',
                    icon: 'verified_user',
                    color: 'green',
                    title: 'Lint is stable.',
                  ),

                if (lint.lintSets.contains('core'))
                  const Tag(
                    'Core',
                    icon: 'circles',
                    title: 'Lint is included in the core set of rules.',
                  )
                else if (lint.lintSets.contains('recommended'))
                  const Tag(
                    'Recommended',
                    icon: 'thumb_up',
                    title: 'Lint is included in the recommended set of rules.',
                  )
                else if (lint.lintSets.contains('flutter'))
                  const Tag(
                    'Flutter',
                    icon: 'flutter',
                    title: 'Lint is included in the Flutter set of rules.',
                  ),

                if (lint.fixStatus == 'hasFix')
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

${lint.docs}

$incompatibleLintsText
''',
              ),
              DashMarkdown(
                content:
                    '''
<a id="usage" aria-hidden="true"></a>
## Enable

To enable the `${lint.id}` rule, add `${lint.id}` under
**linter > rules** in your [`analysis_options.yaml`](/tools/analysis) file:

```yaml title="analysis_options.yaml"
linter:
  rules:
    - ${lint.id}
```

If you're instead using the YAML map syntax to configure linter rules,
add `${lint.id}: true` under **linter > rules**:

```yaml title="analysis_options.yaml"
linter:
  rules:
    ${lint.id}: true
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
    .where(
      (lint) =>
          lint.sinceDartSdk != 'Unreleased' &&
          !lint.sinceDartSdk.contains('wip') &&
          lint.state != 'removed' &&
          lint.state != 'internal',
    )
    .sortedBy((lint) => lint.name)
    .toList(growable: false);

/// The `/tools/linter-rules/all` page that includes an example
/// `analysis_options.yaml` file that enables all linter rules
/// that are available in the current stable release.
MemoryPage get _allLinterRulesPage {
  final allLinterRulesListAsString = linterRulesToShow
      .map((lint) => '    - ${lint.id}')
      .join('\n');

  return MemoryPage(
    path: 'tools/linter-rules/all.md',
    initialData: const {
      'page': <String, Object?>{
        'title': 'All linter rules',
        'description':
            'Auto-generated configuration enabling all linter rules.',
        'sitemap': {
          'lastmod': _diagnosticsLastUpdated,
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
            'id': lint.id,
          },
      ]),
);
