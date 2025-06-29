import 'package:jaspr/jaspr.dart';

final class WrappedCodeBlock extends StatelessComponent {
  const WrappedCodeBlock({
    super.key,
    required this.content,
    required this.language,
    this.title,
    this.highlightLines = const {},
    this.tag,
    this.initialLineNumber = 1,
    this.showLineNumbers = false,
    this.showCopyButton = true,
  });

  final List<String> content;

  final String language;
  final String? title;

  final Set<int> highlightLines;
  final CodeBlockTag? tag;
  final int initialLineNumber;

  final bool showLineNumbers;
  final bool showCopyButton;

  @override
  Iterable<Component> build(BuildContext context) {
    return [
      div(
        classes: 'code-block-wrapper language-$language',
        [
          if (title case final title?)
            div(
              classes: 'code-block-header',
              [text(title)],
            ),
          div(
            classes: 'code-block-body',
            [
              span(
                classes: 'code-block-language',
                attributes: {'title': 'Language $language'},
                [text(language)],
              ),
              pre(
                classes: [
                  if (showLineNumbers) 'show-line-numbers',
                ].join(' '),
                attributes: {'tabindex': '0'},
                [
                  code(
                    [
                      for (
                        var lineIndex = 0;
                        lineIndex < content.length;
                        lineIndex += 1
                      )
                        span(
                          classes: [
                            'line',
                            if (highlightLines.contains(lineIndex + 1))
                              'highlighted-line',
                          ].join(' '),
                          attributes: {
                            if (showLineNumbers)
                              'data-line': '${initialLineNumber + lineIndex}',
                          },
                          [
                            // TODO(parlough): These should be tokenized spans.
                            span([text(content[lineIndex])]),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }
}

enum CodeBlockTag {
  good,
  bad,
  passesStaticAnalysis,
  failsStaticAnalysis,
  runtimeSuccess,
  runtimeFailure;

  static CodeBlockTag parse(String tag) => switch (tag) {
    'good' => good,
    'bad' => bad,
    'passes-sa' => passesStaticAnalysis,
    'fails-sa' => failsStaticAnalysis,
    'runtime-success' => runtimeSuccess,
    'runtime-fail' => runtimeFailure,
    _ => throw ArgumentError('Unknown tag for code blocks: $tag'),
  };
}
