// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:pub_semver/pub_semver.dart';

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
              final groups = <int, List<Version>>{};
              for (final version
                  in ChangelogFiltersSidebar.filters.availableVersions) {
                final major = version.major;
                groups.putIfAbsent(major, () => []).add(version);
              }
              for (final group in groups.values) {
                group.sort(
                  (left, right) => ChangelogFiltersSidebar.filters
                      .compareVersions(right, left),
                );
              }
              final sortedMajors = groups.keys.sorted(
                (left, right) => right.compareTo(left),
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
                    CollapsibleFilterGroup<Object>(
                      key: Key('$major'),
                      title: '$major.x',
                      items: [major, ...groups[major]!],
                      selectedItems: {
                        if (ChangelogFiltersSidebar.filters.isMajorSelected(
                          major,
                        ))
                          major,
                        ...ChangelogFiltersSidebar.filters.selectedVersions,
                      },
                      isCheckedProvider: (item) {
                        if (item is int) {
                          return ChangelogFiltersSidebar.filters
                              .isMajorSelected(item);
                        } else if (item is Version) {
                          return ChangelogFiltersSidebar
                              .filters
                              .selectedVersions
                              .contains(item);
                        }
                        return false;
                      },

                      onToggle: (item, checked) {
                        if (item is int) {
                          ChangelogFiltersSidebar.filters.toggleMajor(
                            item,
                            checked,
                          );
                        } else if (item is Version) {
                          ChangelogFiltersSidebar.filters.setVersion(
                            item,
                            checked,
                          );
                        }
                      },
                      labelProvider: (item) {
                        if (item is int) return '$item';
                        if (item is Version) return item.shortVersion;
                        return '';
                      },
                      idProvider: (item) {
                        if (item is int) return 'version-$item';
                        if (item is Version) {
                          return 'version-${slugify(item.toString())}';
                        }
                        return '';
                      },
                    ),
                ]),
              ]);
            },
          ),
        ]),
      ]),
      BreakingChangesLegend(
        visible: _showLegend,
        onClose: () => setState(() => _showLegend = false),
      ),
    ]);
  }
}
