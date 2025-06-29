import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../markdown/markdown_parser.dart';
import '../util.dart';

/// Different types of resources that glossary terms might link to.
enum ResourceType {
  term,
  article,
  tutorial,
  apiDoc,
  video,
  code,
  diagnostic;

  String get icon => switch (this) {
    term => 'dictionary',
    tutorial => 'school',
    apiDoc => 'description',
    video => 'play_arrow',
    code => 'code_blocks',
    diagnostic => 'lightbulb',
    _ => 'article',
  };

  /// Retrieve the most relevant [ResourceType] that
  /// corresponds to the [type] string.
  static ResourceType fromString(String? type) => switch (type?.toLowerCase()) {
    'term' || 'glossary' => ResourceType.term,
    'article' || 'doc' => ResourceType.article,
    'tutorial' => ResourceType.tutorial,
    'api' => ResourceType.apiDoc,
    'video' => ResourceType.video,
    'code' || 'sample' => ResourceType.code,
    'diagnostic' || 'lint' => ResourceType.diagnostic,
    _ => ResourceType.article,
  };
}

/// Represents a single glossary entry with all its metadata.
@immutable
class GlossaryEntry {
  const GlossaryEntry({
    required this.term,
    required this.shortDescription,
    required this.id,
    this.longDescription,
    this.relatedLinks = const [],
    this.labels = const [],
    this.alternate = const [],
  });

  final String term;
  final String shortDescription;
  final String id;
  final String? longDescription;
  final List<RelatedLink> relatedLinks;
  final List<String> labels;
  final List<String> alternate;
}

/// Represents a related link for a glossary entry.
@immutable
class RelatedLink {
  const RelatedLink({
    required this.text,
    required this.link,
    this.type = ResourceType.article,
  });

  final String text;
  final String link;
  final ResourceType type;
}

/// Represents a complete glossary with multiple entries.
@immutable
class Glossary {
  const Glossary({
    required this.entries,
  });

  final List<GlossaryEntry> entries;

  /// Create a [Glossary] from parsed data.
  ///
  /// Expects the format used by `glossary.yml`.
  factory Glossary.fromList(List<Object?> rawData) {
    final entries = <GlossaryEntry>[];

    for (final item in rawData) {
      if (item is Map<String, Object?>) {
        final term = item['term'] as String?;
        final shortDescription = item['short_description'] as String?;

        if (term != null && shortDescription != null) {
          final relatedLinks = <RelatedLink>[];
          final rawLinks = item['related_links'] as List<Object?>?;

          if (rawLinks != null) {
            for (final link in rawLinks) {
              if (link is Map<String, Object?>) {
                relatedLinks.add(
                  RelatedLink(
                    text: link['text'] as String,
                    link: link['link'] as String,
                    type: ResourceType.fromString(link['type'] as String?),
                  ),
                );
              }
            }
          }

          entries.add(
            GlossaryEntry(
              term: term,
              shortDescription: shortDescription,
              id: item['id'] as String? ?? slugify(term),
              longDescription: item['long_description'] as String?,
              relatedLinks: relatedLinks,
              labels:
                  (item['labels'] as List<Object?>?)?.cast<String>() ??
                  const [],
              alternate:
                  (item['alternate'] as List<Object?>?)?.cast<String>() ??
                  const [],
            ),
          );
        }
      }
    }

    // Sort entries alphabetically by term.
    entries.sort(
      (a, b) => a.term.toLowerCase().compareTo(b.term.toLowerCase()),
    );

    return Glossary(entries: entries);
  }
}

/// A glossary component that displays a
/// searchable list of terms and definitions.
class GlossaryIndex extends StatelessComponent {
  const GlossaryIndex({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final glossary = Glossary.fromList(
      context.page.data['glossary'] as List<Object?>,
    );
    yield section(id: 'filter-and-search', [
      div(classes: 'search-row', [
        div(classes: 'search-wrapper', [
          span(
            classes: 'material-symbols leading-icon',
            attributes: {'aria-hidden': 'true'},
            [text('search')],
          ),
          input(
            type: InputType.search,
            attributes: {
              'aria-label': 'Search terms by name...',
              'placeholder': 'Search terms...',
            },
            [],
          ),
        ]),
      ]),
    ]);
    yield section(id: 'content-search-results', [
      div(classes: 'card-list', [
        for (final entry in glossary.entries) GlossaryCard(entry: entry),
      ]),
    ]);
  }
}

class GlossaryCard extends StatelessComponent {
  const GlossaryCard({
    super.key,
    required this.entry,
  });

  final GlossaryEntry entry;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final cardId = entry.id;
    final contentId = '$cardId-content';

    final partialMatches = entry.term.toLowerCase();
    final fullMatches = entry.alternate.map((e) => e.toLowerCase()).join(',');

    yield div(
      id: cardId,
      classes: 'card outlined-card glossary-card expandable-card',
      attributes: {
        'data-partial-matches': partialMatches,
        'data-full-matches': fullMatches,
      },
      [
        div(classes: 'card-header', [
          h2(classes: 'card-title', [text(entry.term)]),
          div(classes: 'card-header-buttons', [
            a(
              href: '#$cardId',
              classes: 'share-button icon-button',
              attributes: {
                'title': 'Link to card',
                'aria-label': 'Link to ${entry.term} card',
              },
              [
                span(
                  classes: 'material-symbols',
                  attributes: {'aria-hidden': 'true'},
                  [text('tag')],
                ),
              ],
            ),

            button(
              classes: 'expand-button icon-button',
              attributes: {
                'aria-expanded': 'true',
                'aria-controls': contentId,
                'title': 'Expand or collapse card',
                'aria-label': 'Expand or collapse ${entry.term} card',
              },
              [
                span(
                  classes: 'material-symbols',
                  attributes: {'aria-hidden': 'true'},
                  [
                    text('keyboard_arrow_up'),
                  ],
                ),
              ],
            ),
          ]),
        ]),

        div(classes: 'initial-content', [
          raw(parseMarkdownToHtml(entry.shortDescription, inline: true)),
        ]),

        div(
          id: contentId,
          classes: 'expandable-content',
          [
            if (entry.longDescription case final longDescription?)
              raw(parseMarkdownToHtml(longDescription)),

            if (entry.relatedLinks.isNotEmpty)
              div([
                h3(classes: 'no_toc details-header', [
                  text('Related docs and resources'),
                ]),
                ul(classes: 'resources-list', [
                  for (final resource in entry.relatedLinks)
                    li([
                      a(
                        href: resource.link,
                        classes: 'filled-button',
                        [
                          span(
                            classes: 'material-symbols',
                            attributes: {'aria-hidden': 'true'},
                            [
                              text(resource.type.icon),
                            ],
                          ),
                          span([text(resource.text)]),
                        ],
                      ),
                    ]),
                ]),
              ]),
            raw('\n'),
          ],
        ),
      ],
    );
  }
}
