// Copyright 2025 The Dart Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../../models/changelog_model.dart';
import '../../../util.dart';
import '../../common/button.dart';
import 'changelog_filters.dart';
import 'changelog_filters_sidebar.dart';
import '../../../markdown/markdown_parser.dart';

final class ChangelogIndex extends StatelessComponent {
  const ChangelogIndex({super.key});

  @override
  Component build(BuildContext context) {
    // Reset static filters state to prevent SSR state leaks in dev mode.
    ChangelogFiltersSidebar.filters.disposeState(notify: false);

    final changesData = context.page.data['changelog'] as List<Object?>?;

    final changelogEntries = <ChangelogEntry>[];
    if (changesData == null) {
      throw Exception('Changelog data is missing or invalid.');
    }

    for (final change in changesData) {
      changelogEntries.add(
        ChangelogEntry.fromMap(change as Map<String, Object?>),
      );
    }

    return div(id: 'changelog-index-content', [
      div(classes: 'left-col', id: 'changelog-main-content', [
        const ChangelogFilters(),
        div(id: 'all-changelog-list', [
          for (final item in changelogEntries) _ChangelogEntryCard(item),
        ]),
      ]),
      const ChangelogFiltersSidebar(),
    ]);
  }
}

class _ChangelogEntryCard extends StatelessComponent {
  const _ChangelogEntryCard(this.entry);

  final ChangelogEntry entry;

  @override
  Component build(BuildContext context) {
    // Generate a somewhat unique ID for DOM filtering
    final uniqueId = slugify(
      '${entry.version}-${entry.area}-${entry.subArea ?? ''}-${entry.description.substring(0, min(20, entry.description.length))}-${entry.hashCode}',
    );

    return div(
      classes: 'changelog-card card',
      id: uniqueId,
      attributes: {
        'data-version': entry.version,
        if (entry.releaseDate != null) 'data-releasedate': entry.releaseDate!,
        'data-area': entry.area,
        if (entry.subArea != null) 'data-subarea': entry.subArea!,
        'data-tags': entry.tags.map((t) => t.id).join(','),

        if (entry.link != null) 'data-link': entry.link!,
      },
      [
        div(classes: 'card-header', [
          div(classes: 'header-left', [
            span(classes: 'version-badge', [text(entry.shortVersion)]),

            span(classes: 'area-badge', [
              text(
                entry.area +
                    (entry.subArea != null ? ': ${entry.subArea}' : ''),
              ),
            ]),
          ]),
          div(classes: 'tags', [
            for (final tag in entry.tags)
              span(classes: 'tag-label ${tag.id}-tag', [text(tag.label)]),
          ]),
        ]),
        div(classes: 'card-content', [
          if (entry.releaseDate != null)
            p(classes: 'release-date', [
              em([text('Released: ${entry.releaseDate} • v${entry.version}')]),
            ]),
          DashMarkdown(content: entry.description),
          if (entry.link case final entryLink?)
            div(classes: 'read-more', [
              Button(
                href: entryLink,
                content: 'Read more',
                trailingIcon: 'open_in_new',
                attributes: {'target': '_blank'},
              ),
            ]),
        ]),
      ],
    );
  }
}
