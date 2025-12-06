// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/file_tree.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';
import 'package:path/path.dart' as path;

import 'jaspr_options.dart'; // Generated. Do not remove or edit.
import 'src/archive/archive_table.dart';
import 'src/components/common/card.dart';
import 'src/components/common/tabs.dart';
import 'src/components/common/youtube_embed.dart';
import 'src/extensions/registry.dart';
import 'src/layouts/doc_layout.dart';
import 'src/layouts/homepage_layout.dart';
import 'src/layouts/learn_layout.dart';
import 'src/loaders/data_processor.dart';
import 'src/markdown/markdown_parser.dart';
import 'src/pages/custom_pages.dart';
import 'src/pages/diagnostic_index.dart';
import 'src/pages/lint_index.dart';
import 'src/pages/robots_txt.dart';
import 'src/templating/dash_template_engine.dart';
import 'src/util.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(options: defaultJasprOptions);

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
    templateEngine: DashTemplateEngine(
      partialDirectoryPath: path.canonicalize(
        path.join(siteSrcDirectoryPath, '_includes'),
      ),
    ),
    parsers: const [
      DashMarkdownParser(),
      HtmlParser(),
    ],
    rawOutputPattern: RegExp(r'.*\.(txt|json)$'),
    extensions: allNodeProcessingExtensions,
    components: _embeddableComponents,
    layouts: const [DocLayout(), HomepageLayout(), LearnLayout()],
    theme: const ContentTheme.none(),
    secondaryOutputs: [
      const RobotsTxtOutput(),

      MarkdownOutput(
        createHeader: (page) {
          final header = StringBuffer();
          if (page.data.page['title'] case final String title
              when title.isNotEmpty) {
            header.writeln('# $title');

            if (page.data.page['description'] case final String description
                when description.isNotEmpty) {
              header.writeln();
              header.writeln('> $description');
            }
          }

          return header.toString();
        },
      ),
    ],
  ),
);

/// Custom "components" that can be used from Markdown files.
List<CustomComponent> get _embeddableComponents => [
  const DashTabs(),
  const YoutubeEmbed(),
  const FileTree(),
  CustomComponent(
    pattern: RegExp('ArchiveTable'),
    builder: (_, attrs, _) => ArchiveTable.fromAttributes(attrs),
  ),
  CustomComponent(
    pattern: RegExp('LintRuleIndex', caseSensitive: false),
    builder: (_, _, _) => const LintRuleIndex(),
  ),
  CustomComponent(
    pattern: RegExp('DiagnosticIndex', caseSensitive: false),
    builder: (_, _, _) => const DiagnosticIndex(),
  ),
  CustomComponent(
    pattern: RegExp('Card', caseSensitive: false),
    builder: (_, attrs, child) => Card.fromAttributes(attrs, child),
  ),
];
