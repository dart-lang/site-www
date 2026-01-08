// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../../../models/changelog_model.dart';
import '../../../util.dart';
import '../../common/button.dart';
import '../../common/client/filtering.dart';
import '../../common/material_icon.dart';
import 'breaking_changes_legend.dart';
import 'changelog_filters_notifier.dart';

/// A sidebar component that displays filter groups for the changelog.
///
/// This component:
/// 1. Populates available filters by scraping the DOM for changelog entries.
/// 2. Displays groups for "Type", "Area", and "Version".
/// 3. Communicates with [ChangelogFiltersNotifier] to update selection state.
@client
class ChangelogFiltersSidebar extends StatefulComponent {
  const ChangelogFiltersSidebar({super.key});

  /// The shared notifier for filter state.
  static ChangelogFiltersNotifier filters = ChangelogFiltersNotifier();

  @override
  State<ChangelogFiltersSidebar> createState() =>
      _ChangelogFiltersSidebarState();
}

class _ChangelogFiltersSidebarState extends State<ChangelogFiltersSidebar> {
  bool _showLegend = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // Defer DOM access until the next frame to ensure elements are rendered.
      context.binding.addPostFrameCallback(() {
        ChangelogFiltersSidebar.filters.populateAvailableFiltersFromDOM();
      });
    }
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'right-col', [
      const input(
        type: InputType.checkbox,
        id: 'open-filter-toggle',
        attributes: {'hidden': 'true'},
      ),
      div(id: 'changelog-filter-group-wrapper', [
        div(id: 'changelog-filter-group', [
          const div(classes: 'filter-header', [
            label(
              attributes: {'for': 'open-filter-toggle', 'aria-hidden': 'true'},
              classes: 'close-icon',
              [
                MaterialIcon('close', title: 'Close filters'),
              ],
            ),
          ]),
          div(classes: 'table-title', [
            const .text('Filter by'),
            Button(
              icon: 'info',
              classes: ['info-icon'],
              title: 'About changelog',
              onClick: () {
                setState(() => _showLegend = true);
              },
            ),
          ]),
          ListenableBuilder(
            listenable: ChangelogFiltersSidebar.filters,
            builder: (context) {
              // Group versions by major version (e.g. 3.x, 2.x).
              final groups = <String, List<String>>{};
              for (final version
                  in ChangelogFiltersSidebar.filters.availableVersions) {
                final major = version.split('.').first;
                groups.putIfAbsent(major, () => []).add(version);
              }
              for (final group in groups.values) {
                group.sort(
                  (left, right) => ChangelogFiltersSidebar.filters
                      .compareVersions(right, left),
                );
              }
              final sortedMajors = groups.keys.sorted(
                (left, right) => int.parse(right).compareTo(int.parse(left)),
              );

              return div(classes: 'table-content', [
                CheckboxFilterGroup<ChangelogTag>(
                  title: 'Type',
                  items: ChangelogTag.values
                      .where((tag) => tag != ChangelogTag.none)
                      .toList(),
                  selectedItems: ChangelogFiltersSidebar.filters.selectedTags,
                  onToggle: (tag, checked) =>
                      ChangelogFiltersSidebar.filters.setTag(tag, checked),
                  labelProvider: (tag) => tag.label,
                  idProvider: (tag) => tag.id,
                ),
                CheckboxFilterGroup<String>(
                  title: 'Area',
                  items: ChangelogFiltersSidebar.filters.availableAreas
                      .where((area) => area != 'Docs')
                      .sorted(ChangelogFiltersSidebar.filters.compareAreas),
                  selectedItems: ChangelogFiltersSidebar.filters.selectedAreas,
                  onToggle: (area, checked) =>
                      ChangelogFiltersSidebar.filters.setArea(area, checked),
                  labelProvider: (area) => area,
                  idProvider: (area) => 'area-${slugify(area)}',
                ),
                div([
                  const h4([.text('Version')]),
                  for (final major in sortedMajors)
                    CollapsibleFilterGroup<String>(
                      key: Key(major),
                      title: '$major.x',
                      items: [major, ...groups[major]!],
                      selectedItems:
                          ChangelogFiltersSidebar.filters.selectedVersions,
                      onToggle: (version, checked) => ChangelogFiltersSidebar
                          .filters
                          .setVersion(version, checked),
                      labelProvider: (version) => version,
                      idProvider: (version) => 'version-${slugify(version)}',
                    ),
                ]),
              ]);
            },
          ),
        ]),
      ]),
      if (_showLegend)
        BreakingChangesLegend(
          onClose: () => setState(() => _showLegend = false),
        ),
    ]);
  }
}


