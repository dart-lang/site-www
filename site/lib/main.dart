import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';
import 'package:liquify/liquify.dart' show FilterRegistry;
import 'package:path/path.dart' as path;

import 'components/card.dart';

import 'components/glossary.dart';
import 'extensions/attribute_processor.dart';
import 'extensions/code_block_processor.dart';
import 'extensions/header_processor.dart';
import 'extensions/table_processor.dart';
import 'jaspr_options.dart'; // Generated. Do not remove or edit.
import 'layouts/doc_layout.dart';
import 'layouts/homepage_layout.dart';
import 'loaders/data_processor.dart';
import 'markdown/markdown_parser.dart';
import 'pages/lint_rule_pages.dart';
import 'pages/robots_txt.dart';
import 'util.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(options: defaultJasprOptions);

  // TODO(parlough): Eventually migrate away from
  //   the remaining Liquid filter usages.
  FilterRegistry.register('underscoreBreaker', (value, _, _) {
    if (value is! String) return value;

    return value.replaceAll('_', '_<wbr>');
  });

  FilterRegistry.register('slugify', (value, _, _) {
    if (value is! String) return value;

    return slugify(value);
  });

  FilterRegistry.register('arrayToSentenceString', (value, _, _) {
    if (value is! List) return value;

    if (value.isEmpty) {
      return '';
    }

    if (value.length == 1) {
      return value[0];
    }

    final result = StringBuffer();

    for (var i = 0; i < value.length; i++) {
      final item = value[i].toString();
      if (i == value.length - 1) {
        result.write('and $item');
      } else {
        result.write('$item, ');
      }
    }

    return result.toString();
  });

  final siteSrcPath = path.join('..', 'src');

  runApp(
    ContentApp.custom(
      eagerlyLoadAllPages: true,
      loaders: [
        FilesystemLoader(path.join(siteSrcPath, 'content')),
        LintLoader(),
      ],
      configResolver: PageConfig.all(
        dataLoaders: [
          FilesystemDataLoader(path.join(siteSrcPath, 'data')),
          DataProcessor(),
        ],
        templateEngine: LiquidTemplateEngine(
          includesPath: path.join(
            siteSrcPath,
            // TODO(parlough): Figure out why liquid is going back a directory,
            //  requiring this to be duplicated.
            '_includes',
            '_includes',
          ),
        ),
        parsers: [
          MarkdownParser(documentBuilder: (_) => sharedMarkdownDocument),
          const HtmlParser(),
        ],
        rawOutputPattern: RegExp(r'.*\.txt$'),
        extensions: [
          const AttributeProcessor(),
          const TableOfContentsExtension(maxHeaderDepth: 3),
          const HeaderWrapperExtension(),
          const TableWrapperExtension(),
          const CodeBlockProcessor(),
        ],
        components: [
          CustomComponent(
            pattern: RegExp('Card', caseSensitive: false),
            builder: (name, attributes, child) {
              return ContentCard(
                title: attributes['title']!,
                link: attributes['link'],
                child: child!,
              );
            },
          ),
          CustomComponent(
            pattern: RegExp('Glossary', caseSensitive: false),
            builder: (_, _, _) {
              return const GlossaryIndex();
            },
          ),
          CustomComponent(
            pattern: RegExp('YouTubeEmbed', caseSensitive: false),
            builder: (name, attributes, child) {
              // TODO(parlough): This likely shouldn't be implemented here.
              final rawVideoId = attributes['id'] as String;
              final videoTitle = attributes['title'] as String;
              final playlistId = attributes['playlist'];

              final String videoId;
              final int startTime;
              if (rawVideoId.contains('?')) {
                videoId = rawVideoId.split('?')[0];

                final idAndStartTime = videoId.split('start=');
                startTime = int.parse(idAndStartTime[1]);
              } else {
                startTime = 0;
                videoId = rawVideoId;
              }

              return raw('''
<lite-youtube videoid="$videoId" videotitle="$videoTitle" videoStartAt="$startTime" ${playlistId != null ? 'playlistid="$playlistId"' : ''}>
  <a class="lite-youtube-fallback" href="https://www.youtube.com/watch/$videoId" target="_blank" rel="noopener">Watch on YouTube in a new tab: "$videoTitle"</a>
</lite-youtube>
''');
            },
          ),
        ],
        layouts: [const DocLayout(), const HomepageLayout()],
        theme: const ContentTheme.none(),
        secondaryOutputs: [RobotsTxtOutput()],
      ),
    ),
  );
}
