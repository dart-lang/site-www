// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/fragment_target.dart';
import '../components/material_icon.dart';
import '../markdown/markdown_parser.dart';
import '../util.dart';

class DiagnosticIndex extends StatelessComponent {
  const DiagnosticIndex();

  @override
  Component build(BuildContext context) {
    final diagnostics = (context.page.data['diagnostics'] as List<Object?>)
        .cast<Map<String, Object?>>()
        .map(_DiagnosticInfo._)
        .toList(growable: false);
    return div(
      id: 'diagnostic-index',
      classes: 'card-list',
      [
        for (final diagnostic in diagnostics) _DiagnosticCard(diagnostic),
      ],
    );
  }
}

class _DiagnosticCard extends StatelessComponent {
  const _DiagnosticCard(this.diagnostic);

  final _DiagnosticInfo diagnostic;

  @override
  Component build(BuildContext context) {
    final diagnosticId = diagnostic.id.trim().toLowerCase();

    return Card(
      outlined: true,
      header: [
        for (final previousName in diagnostic.previousNames)
          FragmentTarget(previousName),
        header(
          id: diagnosticId,
          classes: 'card-title',
          splitByUnderscore(diagnosticId),
        ),
      ],
      content: [
        DashMarkdown(content: diagnostic.description, inline: true),
      ],
      actions: CardActions(
        leading: [
          if (diagnostic.fromLint)
            const MaterialIcon(
              'toggle_on',
              title: 'Diagnostic is from a lint rule.',
            ),
        ],
        trailing: [
          if (diagnostic.hasDocumentation)
            Button.text(
              href: '/tools/diagnostics/$diagnosticId',
              style: ButtonStyle.outlined,
              title: 'Learn more about this diagnostic and how to resolve it.',
              content: 'Learn more',
            ),
          Button.text(
            style: ButtonStyle.filled,
            classes: const ['copy-button', 'hidden'],
            title: 'Copy $diagnosticId to your clipboard.',
            content: 'Copy',
            attributes: {
              'data-copy': diagnosticId,
            },
          ),
        ],
      ),
    );
  }
}

extension type _DiagnosticInfo._(Map<String, Object?> info) {
  String get id => info['id'] as String;
  String get description => info['description'] as String;
  bool get hasDocumentation => info['hasDocumentation'] as bool? ?? false;
  bool get fromLint => info['fromLint'] as bool? ?? false;
  List<String> get previousNames =>
      (info['previousNames'] as List<Object?>).cast<String>();
}
