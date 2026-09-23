// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'package:pub_semver/pub_semver.dart';

import '../../../markdown/markdown_parser.dart';
import '../../../models/changelog_model.dart';
import '../../../util.dart';

import '../../common/button.dart';
import 'changelog_filters.dart';
import 'changelog_filters_sidebar.dart';

final class ChangelogIndex extends StatelessComponent {
  const ChangelogIndex({super.key});

  /// Renders the changelog data as structured Markdown for `/changelog/index.html.md`.
  static String renderMarkdown(List<Object?> changesData) {
    final changelogEntries = <ChangelogEntry>[
      for (final change in changesData)
        if (change is Map)
          ChangelogEntry.fromMap(Map<String, Object?>.from(change)),
    ];

    final groupedEntries = <Version, List<ChangelogEntry>>{};
    for (final entry in changelogEntries) {
      final groupVersion = Version(entry.version.major, entry.version.minor, 0);
      (groupedEntries[groupVersion] ??= []).add(entry);
    }

    final sortedVersions = groupedEntries.keys.toList()
      ..sort((vA, vB) => vB.compareTo(vA));

    final buffer = StringBuffer();
    for (final version in sortedVersions) {
      buffer.writeln('## Dart ${version.shortVersion}');
      buffer.writeln();
      for (final item in groupedEntries[version]!) {
        final subAreaSuffix = item.subArea != null ? ' — ${item.subArea}' : '';
        final tagsSuffix = item.tags.isNotEmpty
            ? ' (${item.tags.map((t) => t.label).join(', ')})'
            : '';
        final patchPrefix = item.version.patch != 0 ? '[${item.version}] ' : '';
        buffer.writeln(
          '### $patchPrefix[${item.area}]$subAreaSuffix$tagsSuffix',
        );
        if (item.releaseDate != null) {
          buffer.writeln('_Released: ${item.releaseDate}_');
        }
        buffer.writeln();
        buffer.writeln(item.description.trim());
        if (item.link case final link?) {
          buffer.writeln();
          buffer.writeln('Read more: $link');
        }
        buffer.writeln();
      }
    }
    return buffer.toString().trimRight();
  }

  @override
  Component build(BuildContext context) {
    final changesData = context.page.data['changelog'] as List<Object?>?;
    if (changesData == null || changesData.isEmpty) {
      throw Exception('Changelog data is missing or invalid.');
    }

    final changelogEntries = <ChangelogEntry>[
      for (final change in changesData)
        if (change is Map)
          ChangelogEntry.fromMap(Map<String, Object?>.from(change)),
    ];

    final groupedEntries = <Version, List<ChangelogEntry>>{};
    for (final entry in changelogEntries) {
      // Group by major.minor so 3.9.1 and 3.9.0 go under "3.9".
      final groupVersion = Version(entry.version.major, entry.version.minor, 0);
      (groupedEntries[groupVersion] ??= []).add(entry);
    }

    final sortedVersions = groupedEntries.keys.toList()
      ..sort((vA, vB) => vB.compareTo(vA));

    final slugCounts = <String, int>{};
    String nextCardId(ChangelogEntry item) {
      final baseSlug = slugify(
        'v${item.version}-${item.area}'
        '${item.subArea != null ? '-${item.subArea}' : ''}',
      );
      final index = slugCounts.update(
        baseSlug,
        (count) => count + 1,
        ifAbsent: () => 0,
      );
      return '$baseSlug-$index';
    }

    return div(id: 'changelog-index-content', [
      div(classes: 'left-col', id: 'changelog-main-content', [
        const ChangelogFilters(),
        div(id: 'all-changelog-list', [
          for (final version in sortedVersions)
            div(classes: 'version-group', [
              h2(
                id: 'v${version.shortVersion.replaceAll('.', '-')}',
                classes: 'version-header',
                [
                  span(classes: 'version-badge', [.text(version.shortVersion)]),
                ],
              ),
              div(classes: 'version-items', [
                for (final item in groupedEntries[version]!)
                  _ChangelogEntryCard(item, cardId: nextCardId(item)),
              ]),
            ]),
        ]),
      ]),
      const ChangelogFiltersSidebar(),
    ]);
  }
}

class _ChangelogEntryCard extends StatelessComponent {
  const _ChangelogEntryCard(this.entry, {required this.cardId});

  final ChangelogEntry entry;
  final String cardId;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'changelog-card card',
      id: cardId,
      attributes: {
        'data-version': entry.version.toString(),
        'data-releasedate': ?entry.releaseDate,
        'data-area': entry.area,
        'data-subarea': ?entry.subArea,
        'data-tags': entry.tags.map((t) => t.id).join(','),
        'data-link': ?entry.link,
      },
      [
        div(classes: 'card-header', [
          div(classes: 'header-left', [
            span(classes: 'area-badge', [
              .text(entry.area),
            ]),
            if (entry.subArea case final subArea?)
              span(classes: 'entry-title', [
                DashMarkdown(content: subArea, inline: true),
              ]),
          ]),
          div(classes: 'tags', [
            for (final tag in entry.tags)
              span(
                classes: 'tag-label ${tag.id}-tag',
                attributes: {'title': tag.description},
                [.text(tag.label)],
              ),
          ]),
        ]),
        div(classes: 'card-content', [
          if (entry.releaseDate != null)
            p(classes: 'release-date', [
              em([.text('Released: ${entry.releaseDate}')]),
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
