// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:site_shared/components/common/button.dart';
import 'package:site_shared/markdown.dart';

import '../../../models/changelog_model.dart';
import '../../../util.dart';
import 'changelog_filters.dart';
import 'changelog_filters_sidebar.dart';

final class ChangelogIndex extends StatelessComponent {
  const ChangelogIndex({super.key});

  /// Parses raw YAML/JSON map entries into typed [ChangelogEntry] objects.
  static List<ChangelogEntry> parseEntries(List<Object?> changesData) {
    return [
      for (final change in changesData)
        if (change is Map)
          ChangelogEntry.fromMap(Map<String, Object?>.from(change)),
    ];
  }

  /// Groups [changelogEntries] by major.minor version, sorted newest first.
  static (List<Version>, Map<Version, List<ChangelogEntry>>)
  groupByMinorVersion(List<ChangelogEntry> changelogEntries) {
    final groupedEntries = <Version, List<ChangelogEntry>>{};
    for (final entry in changelogEntries) {
      // Group by major.minor so 3.9.1 and 3.9.0 go under "3.9".
      final groupVersion = Version(entry.version.major, entry.version.minor, 0);
      (groupedEntries[groupVersion] ??= []).add(entry);
    }

    final sortedVersions = groupedEntries.keys.toList()
      ..sort((vA, vB) => vB.compareTo(vA));

    return (sortedVersions, groupedEntries);
  }

  /// Computes the deterministic HTML anchor slug for [item], updating
  /// [slugCounts] to disambiguate colliding base slugs in iteration order.
  static String nextCardId(
    ChangelogEntry item,
    Map<String, int> slugCounts,
  ) {
    if (item.id case final explicitId? when explicitId.isNotEmpty) {
      return slugify(explicitId);
    }
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

  /// Returns the minor release date from an `x.y.0` entry in [items], or `null`
  /// if no `.0` entry specifies a release date.
  ///
  /// Patch entries carry their own dates on the card, so we don't fall back
  /// to them here or a `3.9.4` date could be shown as the `3.9` release date.
  static String? releaseDateForGroup(List<ChangelogEntry> items) {
    for (final item in items) {
      if (item.version.patch == 0 && item.releaseDate != null) {
        return item.releaseDate;
      }
    }
    return null;
  }

  /// Writes a single [item] as structured Markdown to [buffer].
  ///
  /// Only patch entries include their own release date. The date of an
  /// `x.y.0` entry is written once for its minor version by
  /// [writeReleaseDateMarkdown], matching the cards on the HTML page.
  static void writeEntryMarkdown(StringBuffer buffer, ChangelogEntry item) {
    final subAreaSuffix = item.subArea != null ? ' — ${item.subArea}' : '';
    final tagsSuffix = item.tags.isNotEmpty
        ? ' (${item.tags.map((t) => t.label).join(', ')})'
        : '';
    final patchPrefix = item.version.patch != 0 ? '[${item.version}] ' : '';
    buffer.writeln(
      '### $patchPrefix[${item.area}]$subAreaSuffix$tagsSuffix',
    );
    if (item.version.patch != 0 && item.releaseDate != null) {
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

  /// Writes the release date of a minor version to [buffer],
  /// or nothing if [releaseDate] is `null`.
  static void writeReleaseDateMarkdown(
    StringBuffer buffer,
    String? releaseDate,
  ) {
    if (releaseDate == null) return;
    buffer.writeln('_Released: ${releaseDate}_');
    buffer.writeln();
  }

  /// Renders the changelog data as structured Markdown for `/changelog.md`.
  static String renderMarkdown(List<Object?> changesData) {
    final (sortedVersions, groupedEntries) = groupByMinorVersion(
      parseEntries(changesData),
    );

    final buffer = StringBuffer();
    if (sortedVersions.isNotEmpty) {
      buffer.writeln('## Pre-sliced endpoints');
      buffer.writeln();
      buffer.writeln(
        'For smaller, targeted fetches (such as single releases or upgrade '
        'audits), use the [changelog JSON index](/changelog/index.json) or '
        'fetch a pre-sliced endpoint directly:',
      );
      buffer.writeln();
      buffer.writeln(
        '- **Cross-version slices**: '
        '[Breaking changes](/changelog/tags/breaking.md) '
        '([JSON](/changelog/tags/breaking.json)) | '
        '[Deprecations and removals](/changelog/tags/deprecated-removed.md) '
        '([JSON](/changelog/tags/deprecated-removed.json)) | '
        '[Language changes](/changelog/areas/language.md) '
        '([JSON](/changelog/areas/language.json))',
      );
      final versionLinks = [
        for (final version in sortedVersions)
          '[${version.shortVersion}]'
              '(/changelog/versions/${version.shortVersion}.md)',
      ].join(', ');
      buffer.writeln('- **Per-version slices**: $versionLinks');
      buffer.writeln();
    }

    for (final version in sortedVersions) {
      final items = groupedEntries[version]!;
      buffer.writeln('## Dart ${version.shortVersion}');
      buffer.writeln();
      writeReleaseDateMarkdown(buffer, releaseDateForGroup(items));
      for (final item in items) {
        writeEntryMarkdown(buffer, item);
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

    final (sortedVersions, groupedEntries) = groupByMinorVersion(
      parseEntries(changesData),
    );

    final slugCounts = <String, int>{};

    return div(id: 'changelog-index-content', [
      div(classes: 'left-col', id: 'changelog-main-content', [
        const ChangelogFilters(),
        div(id: 'all-changelog-list', [
          for (final version in sortedVersions)
            div(classes: 'version-group', [
              div(classes: 'header-wrapper', [
                h2(
                  id: 'v${version.shortVersion.replaceAll('.', '-')}',
                  classes: 'version-header',
                  [
                    span(
                      classes: 'version-badge',
                      [.text(version.shortVersion)],
                    ),
                  ],
                ),
                a(
                  classes: 'heading-link',
                  href: '#v${version.shortVersion.replaceAll('.', '-')}',
                  attributes: {
                    'aria-label':
                        "Link to 'Dart ${version.shortVersion}' section",
                  },
                  [const .text('#')],
                ),
                if (releaseDateForGroup(groupedEntries[version]!)
                    case final groupDate?)
                  span(
                    classes: 'version-release-date',
                    [.text('Released $groupDate')],
                  ),
              ]),
              div(classes: 'version-items', [
                for (final item in groupedEntries[version]!)
                  _ChangelogEntryCard(
                    item,
                    cardId: nextCardId(item, slugCounts),
                  ),
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
            if (entry.version.patch != 0)
              span(classes: 'patch-badge', [
                .text(entry.version.toString()),
              ]),
            span(classes: 'area-badge', [
              .text(entry.area),
            ]),
            if (entry.subArea case final subArea?)
              span(classes: 'entry-title', [
                DashMarkdown(content: subArea, inline: true),
              ]),
            a(
              classes: 'heading-link card-anchor',
              href: '#$cardId',
              attributes: {
                'aria-label':
                    "Link to '${entry.version} ${entry.subArea ?? entry.area}' "
                    'changelog entry',
                'title': 'Copy link to this changelog entry',
              },
              [const .text('#')],
            ),
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
          if (entry.version.patch != 0 && entry.releaseDate != null)
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
