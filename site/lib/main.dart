// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';
import 'package:liquify/liquify.dart' show FilterRegistry;
import 'package:path/path.dart' as path;

import 'jaspr_options.dart'; // Generated. Do not remove or edit.
import 'src/archive/archive_table.dart';
import 'src/components/card.dart';
import 'src/components/tabs.dart';
import 'src/extensions/registry.dart';
import 'src/layouts/doc_layout.dart';
import 'src/layouts/homepage_layout.dart';
import 'src/loaders/data_processor.dart';
import 'src/markdown/markdown_parser.dart';
import 'src/pages/custom_pages.dart';
import 'src/pages/diagnostic_index.dart';
import 'src/pages/lint_index.dart';
import 'src/pages/robots_txt.dart';
import 'src/util.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(options: defaultJasprOptions);

  _setUpLiquid();

  runApp(_dartDevSite);
}

Component get _dartDevSite => ContentApp.custom(
  eagerlyLoadAllPages: true,
  loaders: [
    FilesystemLoader(path.join(siteSrcDirectoryPath, 'content')),
    MemoryLoader(pages: allMemoryPages),
  ],
  configResolver: PageConfig.all(
    dataLoaders: [
      FilesystemDataLoader(path.join(siteSrcDirectoryPath, 'data')),
      DataProcessor(),
    ],
    templateEngine: LiquidTemplateEngine(
      includesPath: path.canonicalize(
        path.join(siteSrcDirectoryPath, '_includes'),
      ),
    ),
    parsers: const [
      DashMarkdownParser(),
      HtmlParser(),
    ],
    rawOutputPattern: RegExp(r'.*\.txt$'),
    extensions: allNodeProcessingExtensions,
    components: _embeddableComponents,
    layouts: const [DocLayout(), HomepageLayout()],
    theme: const ContentTheme.none(),
    secondaryOutputs: const [RobotsTxtOutput()],
  ),
);

/// Custom "components" that can be used from Markdown files.
List<CustomComponent> get _embeddableComponents => [
  const DashTabs(),
  CustomComponent(
    pattern: RegExp('ArchiveTable', caseSensitive: false),
    builder: (name, attributes, child) {
      final channel = attributes['channel']!;
      return ArchiveTable(channel: channel);
    },
  ),
  CustomComponent(
    pattern: RegExp('LintRuleIndex', caseSensitive: false),
    builder: (name, attributes, child) {
      return const LintRuleIndex();
    },
  ),
  CustomComponent(
    pattern: RegExp('DiagnosticIndex', caseSensitive: false),
    builder: (name, attributes, child) {
      return const DiagnosticIndex();
    },
  ),
  CustomComponent(
    pattern: RegExp('Card', caseSensitive: false),
    builder: (name, attributes, child) {
      final link = attributes['link'];
      final title = attributes['title']!;
      return Card(
        header: [
          header(classes: 'card-title', [text(title)]),
        ],
        content: [?child],
        link: link,
        filled: link != null,
      );
    },
  ),
  CustomComponent(
    pattern: RegExp('YouTubeEmbed', caseSensitive: false),
    builder: (name, attributes, child) {
      final rawVideoId = attributes['id'] as String;
      final videoTitle = attributes['title'] as String;
      final playlistId = attributes['playlist'];

      final String videoId;
      final int startTime;
      if (rawVideoId.contains('?')) {
        videoId = rawVideoId.split('?')[0];

        final idAndStartTime = videoId.split('start=');
        startTime = int.tryParse(idAndStartTime[1]) ?? 0;
      } else {
        startTime = 0;
        videoId = rawVideoId;
      }

      // Instead of directly including a YouTube embed iframe,
      // we use https://github.com/justinribeiro/lite-youtube which
      // lazily loads the video, significantly reduces page load times,
      // and enables configurability through element attributes.
      return raw('''
<lite-youtube videoid="$videoId" videotitle="$videoTitle" videoStartAt="$startTime" ${playlistId != null ? 'playlistid="$playlistId"' : ''}>
  <a class="lite-youtube-fallback" href="https://www.youtube.com/watch/$videoId" target="_blank" rel="noopener">Watch on YouTube in a new tab: "$videoTitle"</a>
</lite-youtube>
''');
    },
  ),
];

/// Set up the Liquid templating engine from `package:liquify`,
/// adding filters, tags, and other functionality our content relies on.
void _setUpLiquid() {
  // TODO(https://github.com/dart-lang/site-www/issues/6840):
  //  Eventually migrate away from the remaining Liquid filter usages.
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
}
