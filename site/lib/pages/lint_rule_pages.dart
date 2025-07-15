import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as p;

import '../lints.dart';

final class LintLoader extends RouteLoaderBase {
  LintLoader();

  @override
  Future<List<PageSource>> loadPageSources() async {
    final lintRulesFile = File(
      p.join('..', 'src', 'data', 'linter_rules.json'),
    );
    final lintRules = loadLints(jsonDecode(await lintRulesFile.readAsString()));

    final sources = <PageSource>[];
    for (final lint in lintRules) {
      sources.add(_LintRulePageSource(
        lint,
        '/tools/linter-rules/${lint.id}.md',
        this,
      ));

      final lowerCaseId = lint.id.toLowerCase();
      if (lint.id != lowerCaseId) {
        sources.add(_LintRulePageSource(
          lint,
          '/tools/linter-rules/$lowerCaseId.md',
          this,
          hide: true,
        ));
      }
    }

    return sources;
  }
}

class _LintRulePageSource extends PageSource {
  _LintRulePageSource(this.lint, super.path, super.loader, {this.hide = false});

  final LintDetails lint;
  final bool hide;

  @override
  Future<Page> buildPage() async {
    final buffer = StringBuffer();
    // TODO(parlough): Migrate the following to one or more Jaspr components.

    buffer.writeln('<div class="tags">');

    if (lint.sinceDartSdk == 'Unreleased' ||
        lint.sinceDartSdk.contains('-wip')) {
      buffer.writeln(
        '<div class="tag-label orange" '
        'title="Lint is unreleased or work in progress." '
        'aria-label="Lint is unreleased or work in progress.">',
      );
      buffer.writeln(
        '<span class="material-symbols" aria-hidden="true">pending</span>',
      );
      buffer.writeln('<span>Unreleased</span>');
      buffer.writeln('</div>');
    } else if (lint.state == 'experimental') {
      buffer.writeln(
        '<div class="tag-label orange" '
        'title="Lint is experimental." '
        'aria-label="Lint is experimental.">',
      );
      buffer.writeln(
        '<span class="material-symbols" aria-hidden="true">science</span>',
      );
      buffer.writeln('<span>Experimental</span>');
      buffer.writeln('</div>');
    } else if (lint.state == 'deprecated') {
      buffer.writeln(
        '<div class="tag-label orange" '
        'title="Lint is deprecated." '
        'aria-label="Lint is deprecated.">',
      );
      buffer.writeln(
        '<span class="material-symbols" aria-hidden="true">report</span>',
      );
      buffer.writeln('<span>Deprecated</span>');
      buffer.writeln('</div>');
    } else if (lint.state == 'removed') {
      buffer.writeln(
        '<div class="tag-label red" '
        'title="Lint has been removed." '
        'aria-label="Lint has been removed.">',
      );
      buffer.writeln(
        '<span class="material-symbols" aria-hidden="true">error</span>',
      );
      buffer.writeln('<span>Removed</span>');
      buffer.writeln('</div>');
    } else {
      buffer.writeln(
        '<div class="tag-label green" '
        'title="Lint is stable." '
        'aria-label="Lint is stable.">',
      );
      buffer.writeln(
        '<span class="material-symbols" aria-hidden="true">verified_user</span>',
      );
      buffer.writeln('<span>Stable</span>');
      buffer.writeln('</div>');
    }

    if (lint.lintSets.contains('core')) {
      buffer.writeln(
        '<div class="tag-label" '
        'title="Lint is included in the core set of rules." '
        'aria-label="Lint is included in the core set of rules.">',
      );
      buffer.writeln(
        '<span class="material-symbols" aria-hidden="true">circles</span>',
      );
      buffer.writeln('<span>Core</span>');
      buffer.writeln('</div>');
    } else if (lint.lintSets.contains('recommended')) {
      buffer.writeln(
        '<div class="tag-label" '
        'title="Lint is included in the recommended set of rules." '
        'aria-label="Lint is included in the recommended set of rules.">',
      );
      buffer.writeln(
        '<span class="material-symbols" aria-hidden="true">thumb_up</span>',
      );
      buffer.writeln('<span>Recommended</span>');
      buffer.writeln('</div>');
    } else if (lint.lintSets.contains('flutter')) {
      buffer.writeln(
        '<div class="tag-label" '
        'title="Lint is included in the Flutter set of rules." '
        'aria-label="Lint is included in the Flutter set of rules.">',
      );
      buffer.writeln(
        '<span class="material-symbols" aria-hidden="true">flutter</span>',
      );
      buffer.writeln('<span>Flutter</span>');
      buffer.writeln('</div>');
    }

    if (lint.fixStatus == 'hasFix') {
      buffer.writeln(
        '<div class="tag-label" '
        'title="Lint has one or more quick fixes available." '
        'aria-label="Lint has one or more quick fixes available.">',
      );
      buffer.writeln(
        '<span class="material-symbols" aria-hidden="true">build</span>',
      );
      buffer.writeln('<span>Fix available</span>');
      buffer.writeln('</div>');
    }

    buffer.writeln('</div>');
    buffer.writeln();

    buffer.writeln(lint.description);
    buffer.writeln();

    buffer.writeln('## Details');
    buffer.writeln();
    buffer.writeln(lint.docs);
    buffer.writeln();

    if (lint.incompatibleLints.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('## Incompatible rules');
      buffer.writeln();
      buffer.writeln(
        'The `${lint.name}` rule is incompatible with the following rules:',
      );
      buffer.writeln();
      for (final incompatible in lint.incompatibleLints) {
        buffer.writeln(
          '- [`$incompatible`](/tools/linter-rules/$incompatible)',
        );
      }
      buffer.writeln();
    }

    buffer.writeln('<a id="usage" aria-hidden="true"></a>');
    buffer.writeln();
    buffer.writeln('## Enable');
    buffer.writeln();
    buffer.writeln('To enable the `${lint.name}` rule,');
    buffer.writeln('add `${lint.name}` under **linter > rules** in your');
    buffer.writeln('[`analysis_options.yaml`](/tools/analysis) file:');
    buffer.writeln();
    buffer.writeln('```yaml title="analysis_options.yaml"');
    buffer.writeln('linter:');
    buffer.writeln('  rules:');
    buffer.writeln('    - ${lint.name}');
    buffer.writeln('```');
    buffer.writeln();
    buffer.writeln(
      'If you\'re instead using the YAML map syntax to configure linter rules,',
    );
    buffer.writeln('add `${lint.name}: true` under **linter > rules**:');
    buffer.writeln();
    buffer.writeln('```yaml title="analysis_options.yaml"');
    buffer.writeln('linter:');
    buffer.writeln('  rules:');
    buffer.writeln('    ${lint.name}: true');
    buffer.writeln('```');
    buffer.writeln();

    return Page(
      path: path,
      url: url,
      content: buffer.toString(),
      initialData: {
        'page': <String, Object?>{
          'title': lint.name,
          'show_breadcrumbs': true,
          'underscore_breaker_titles': true,
          'description': 'Learn about the ${lint.name} linter rule.',
          if (hide) ...{'noindex': true, 'sitemap': false},
        },
      },
      config: config,
      loader: loader,
    );
  }
}
