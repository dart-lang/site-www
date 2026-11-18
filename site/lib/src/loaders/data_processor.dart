// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as path;

import '../utils/last_modified.dart';

/// A shared data loader to add data to each loaded page.
///
/// Currently adds data about the last modified date of the page,
/// but can be expanded to add other data as necessary.
final class DataProcessor implements DataLoader {
  @override
  Future<void> loadData(Page page) async {
    final pageLoader = page.loader;
    if (pageLoader is FilesystemLoader) {
      final sourcePath = path.canonicalize(
        path.join(pageLoader.directory, page.path),
      );
      final inputPath = path.relative(sourcePath, from: '..');

      final wordCount = RegExp(r'\w+').allMatches(page.content).length;
      final readingTime = (wordCount / 250).ceil();

      page.apply(
        data: {
          'page': {
            'readingTime': '$readingTime min read',
            'date': ?lastModifiedDateForPath(inputPath),
            'inputPath': inputPath,
            if (page.data.page['sitemap'] == null)
              'sitemap': {
                'lastmod': lastModifiedDateForPath(inputPath),
              },
          },
        },
      );
    }
  }
}
