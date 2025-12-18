// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../../../models/changelog_model.dart';
import '../../../util.dart';
import '../../common/client/filtering.dart';
import 'breaking_changes_legend.dart';

@client
class ChangelogFiltersSidebar extends StatefulComponent {
  const ChangelogFiltersSidebar({super.key});

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
                  items:
                      ChangelogFiltersSidebar.filters.availableAreas
                          .where((area) => area != 'Docs')
                          .toList()
                        ..sort(ChangelogFiltersSidebar.filters.compareAreas),
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

class ChangelogFiltersNotifier extends ChangeNotifier {
  Set<ChangelogTag> selectedTags = {};
  Set<String> selectedAreas = {};
  Set<String> selectedVersions = {};

  Set<String> availableAreas = {};
  Set<String> availableVersions = {};

  void populateAvailableFiltersFromDOM() {
    final listContainer = web.document.getElementById('all-changelog-list');
    if (listContainer == null) return;

    var changed = availableAreas.add('Docs');
    final entryCards = listContainer.querySelectorAll('.changelog-card');
    for (var i = 0; i < entryCards.length; i++) {
      final element = entryCards.item(i) as web.Element;
      final area = element.getAttribute('data-area');
      if (area != null && area.isNotEmpty) {
        changed |= availableAreas.add(area);
      }
      final version = element.getAttribute('data-version');
      if (version != null && version.isNotEmpty) {
        changed |= availableVersions.add(
          ChangelogEntry.getShortVersion(version),
        );
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  void setTag(ChangelogTag tag, bool isSelected) {
    if (isSelected) {
      selectedTags.add(tag);
    } else {
      selectedTags.remove(tag);
    }
    notifyListeners();
  }

  void setArea(String area, bool isSelected) {
    if (isSelected) {
      selectedAreas.add(area);
    } else {
      selectedAreas.remove(area);
    }
    notifyListeners();
  }

  void setVersion(String version, bool isSelected) {
    if (!version.contains('.')) {
      // It's a major version (e.g. "3")
      if (isSelected) {
        selectedVersions.add(version);
        // Select all versions starting with this major
        final majorPrefix = '$version.';
        selectedVersions.addAll(
          availableVersions.where((v) => v.startsWith(majorPrefix)),
        );
      } else {
        selectedVersions.remove(version);
        // Deselect all versions starting with this major
        final majorPrefix = '$version.';
        selectedVersions.removeAll(
          availableVersions.where((v) => v.startsWith(majorPrefix)),
        );
      }
    } else {
      if (isSelected) {
        selectedVersions.add(version);
        // Check if all versions of this major are selected
        final major = version.split('.').first;
        final majorPrefix = '$major.';
        final allMajor = availableVersions.where(
          (v) => v.startsWith(majorPrefix),
        );
        if (allMajor.every(selectedVersions.contains)) {
          selectedVersions.add(major);
        }
      } else {
        selectedVersions.remove(version);
        // Deselect the major checkbox if it was selected
        final major = version.split('.').first;
        selectedVersions.remove(major);
      }
    }
    notifyListeners();
  }

  void reset() {
    selectedTags.clear();
    selectedAreas.clear();
    selectedVersions.clear();
    notifyListeners();
  }

  void disposeState({bool notify = true}) {
    selectedTags.clear();
    selectedAreas.clear();
    selectedVersions.clear();
    availableAreas.clear();
    availableVersions.clear();
    if (notify) {
      notifyListeners();
    }
  }

  int compareVersions(String v1, String v2) {
    final p1 = v1.split('.').map(int.parse).toList();
    final p2 = v2.split('.').map(int.parse).toList();

    for (var i = 0; i < max(p1.length, p2.length); i++) {
      final n1 = i < p1.length ? p1[i] : 0;
      final n2 = i < p2.length ? p2[i] : 0;
      if (n1 != n2) return n1.compareTo(n2);
    }
    return 0;
  }

  int compareAreas(String a, String b) {
    if (a == b) return 0;
    // 1. SDK at the top
    if (a == 'SDK') return -1;
    if (b == 'SDK') return 1;
    // 2. Language second
    if (a == 'Language') return -1;
    if (b == 'Language') return 1;
    // 3. Docs at the bottom
    if (a == 'Docs') return 1;
    if (b == 'Docs') return -1;
    // 4. Everything else alphabetical
    return a.compareTo(b);
  }

  List<ChangelogEntry> filterEntries(
    List<ChangelogEntry> entries,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty &&
        selectedTags.isEmpty &&
        selectedAreas.isEmpty &&
        selectedVersions.isEmpty) {
      return List.from(entries);
    }

    final entriesToShow = <ChangelogEntry>[];
    searchQuery = searchQuery.trim().toLowerCase();

    for (final entry in entries) {
      final matchesTags =
          selectedTags.isEmpty || entry.tags.any(selectedTags.contains);
      if (!matchesTags) continue;

      final matchesAreas =
          selectedAreas.isEmpty || selectedAreas.contains(entry.area);
      if (!matchesAreas) continue;

      final matchesVersions =
          selectedVersions.isEmpty ||
          selectedVersions.contains(entry.shortVersion);
      if (!matchesVersions) continue;

      final matchesSearchQuery =
          searchQuery.isEmpty ||
          entry.description.toLowerCase().contains(searchQuery) ||
          entry.area.toLowerCase().contains(searchQuery) ||
          (entry.subArea?.toLowerCase().contains(searchQuery) ?? false) ||
          entry.version.contains(searchQuery);

      if (!matchesSearchQuery) continue;

      entriesToShow.add(entry);
    }

    return entriesToShow;
  }
}
