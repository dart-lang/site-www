// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr_content/jaspr_content.dart';
import 'package:liquify/liquify.dart';
import 'package:path/path.dart' as path;

import '../util.dart';

/// A template engine for Jaspr Content that
/// uses `package:liquify` to parse and render Liquid templates.
final class DashTemplateEngine implements TemplateEngine {
  DashTemplateEngine({required this.partialDirectoryPath});

  /// The path to the directory containing partial files.
  final String partialDirectoryPath;

  /// The `package:liquify` environment to render templates with.
  final Environment _renderEnvironment = Environment()
    ..registerFilter('slugify', (value, _, _) {
      if (value is! String) return value;

      return slugify(value);
    })
    ..registerFilter('arrayToSentenceString', (value, _, _) {
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

  @override
  Future<void> render(Page page, List<Page> pages) async {
    if (page.data.page['skipTemplateRendering'] == true) {
      return;
    }

    final template = Template.parse(
      page.content,
      data: {
        ...page.data,
        'pages': pages.map((page) => page.data.page).toList(growable: false),
      },
      root: _PartialResolver(
        page: page,
        partialDirectoryPath: partialDirectoryPath,
      ),
      environment: _renderEnvironment,
    );

    page.apply(content: await template.renderAsync());
  }
}

class _PartialResolver implements Root {
  _PartialResolver({required this.page, required this.partialDirectoryPath});

  final Page page;
  final String partialDirectoryPath;

  @override
  Source resolve(String relPath) {
    final filePath = path.join(partialDirectoryPath, relPath);
    final content = page.readPartialSync(filePath);
    return Source(Uri.file(filePath), content, this);
  }

  @override
  Future<Source> resolveAsync(String relPath) async {
    final partialPath = path.join(partialDirectoryPath, relPath);
    final partialContent = await page.readPartial(partialPath);
    return Source(Uri.file(partialPath), partialContent, this);
  }
}
