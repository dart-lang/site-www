// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:universal_web/web.dart' as web;

import '../../../models/changelog_model.dart';

/// Manages the state of the changelog filters.
class ChangelogFiltersNotifier extends ChangeNotifier {
  static final _versionXyRegex = RegExp(r'^\d+\.\d+$');

  Set<ChangelogTag> selectedTags = {};
  Set<String> selectedAreas = {};
  Set<Version> selectedVersions = {};

  Set<String> availableAreas = {};
  Set<Version> availableVersions = {};

  /// Populates [availableAreas] and [availableVersions] by inspecting the DOM.
  ///
  /// This expects the changelog list to be rendered in the DOM with
  /// `data-area` and `data-version` attributes on entries.
  void populateAvailableFiltersFromDOM() {
    final listContainer = web.document.getElementById('all-changelog-list');
    if (listContainer == null) return;

    // Always include 'Docs' as an available area, even if no entries are
    // currently displayed for it (though usually there are).
    // This ensures the filter option is present.
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
        try {
          // Normalize "X.Y" to "X.Y.0" if needed for parsing
          var vStr = version;
          if (_versionXyRegex.hasMatch(vStr)) {
            vStr = '$vStr.0';
          }
          final v = Version.parse(vStr);
          // Store the short version (major.minor.0)
          final shortVersion = Version(v.major, v.minor, 0);
          changed |= availableVersions.add(shortVersion);
        } catch (_) {
          // Ignore invalid versions
        }
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

  void setVersion(Version version, bool isSelected) {
    if (isSelected) {
      selectedVersions.add(version);
      // Check if all versions of this major are selected
      // Logic for major "check" is now computed in UI, so we just add the individual version
    } else {
      selectedVersions.remove(version);
    }
    notifyListeners();
  }

  void toggleMajor(int major, bool isSelected) {
    final versionsInMajor = availableVersions.where((v) => v.major == major);
    if (isSelected) {
      selectedVersions.addAll(versionsInMajor);
    } else {
      selectedVersions.removeAll(versionsInMajor);
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

  /// Compares two versions used for sorting descending.
  int compareVersions(Version v1, Version v2) {
    return v1.compareTo(v2);
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

  /// Filters [entries] based on [searchQuery] and selected filters.
  ///
  /// Returns a new list containing only the entries that match:
  /// - Any selected tag (or all if none selected)
  /// - Any selected area (or all if none selected)
  /// - Any selected version (or all if none selected)
  /// - The search query (matched against description, area, subarea, or version)
  List<ChangelogEntry> filterEntries(
    List<ChangelogEntry> entries,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty &&
        selectedTags.isEmpty &&
        selectedAreas.isEmpty &&
        selectedVersions.isEmpty) {
      return entries;
    }

    final entriesToShow = <ChangelogEntry>[];
    final normalizedQuery = searchQuery.trim().toLowerCase();

    for (final entry in entries) {
      final matchesTags =
          selectedTags.isEmpty || entry.tags.any(selectedTags.contains);
      if (!matchesTags) continue;

      final matchesAreas =
          selectedAreas.isEmpty || selectedAreas.contains(entry.area);
      if (!matchesAreas) continue;

      final matchesVersions =
          selectedVersions.isEmpty ||
          selectedVersions.contains(
            Version(entry.version.major, entry.version.minor, 0),
          );
      if (!matchesVersions) continue;

      final matchesSearchQuery =
          normalizedQuery.isEmpty ||
          entry.description.toLowerCase().contains(normalizedQuery) ||
          entry.area.toLowerCase().contains(normalizedQuery) ||
          (entry.subArea?.toLowerCase().contains(normalizedQuery) ?? false) ||
          entry.version.toString().contains(normalizedQuery);

      if (!matchesSearchQuery) continue;

      entriesToShow.add(entry);
    }

    return entriesToShow;
  }
}
