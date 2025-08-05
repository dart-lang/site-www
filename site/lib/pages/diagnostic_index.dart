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
  Iterable<Component> build(BuildContext context) {
    final diagnostics = (context.page.data['diagnostics'] as List<Object?>)
        .cast<Map<String, Object?>>()
        .map(_DiagnosticInfo._)
        .toList(growable: false);
    return [
      div(
        id: 'diagnostic-index',
        classes: 'card-list',
        [
          for (final diagnostic in diagnostics) _DiagnosticCard(diagnostic),
        ],
      ),
    ];
  }
}

class _DiagnosticCard extends StatelessComponent {
  const _DiagnosticCard(this.diagnostic);

  final _DiagnosticInfo diagnostic;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final diagnosticId = diagnostic.id.trim().toLowerCase();

    yield Card(
      outlined: true,
      header: [
        for (final previousName in diagnostic.previousNames)
          FragmentTarget(previousName),
        header(
          id: diagnosticId,
          classes: 'card-title',
          underscoreBreaker(diagnosticId),
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
          Button.text(
            href: '/tools/diagnostics/$diagnosticId',
            style: ButtonStyle.outlined,
            title: 'Learn more about this diagnostic and how to resolve it.',
            content: 'Learn more',
          ),
          Button.text(
            style: ButtonStyle.filled,
            classes: ['copy-button', 'hidden'],
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
  bool get hasDocumentation => info['hasDocumentation'] == 'true';
  bool get fromLint => info['fromLint'] == 'true';
  List<String> get previousNames =>
      (info['previousNames'] as List<Object?>).cast<String>();
}
