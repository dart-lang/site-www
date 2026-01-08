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
  Set<String> selectedVersions = {};

  Set<String> availableAreas = {};
  Set<String> availableVersions = {};

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
        // Parse version to get consistent short version
        try {
          // Normalize "X.Y" to "X.Y.0" if needed for parsing
          var vStr = version;
          if (RegExp(r'^\d+\.\d+$').hasMatch(vStr)) {
            vStr = '$vStr.0';
          }
          final v = Version.parse(vStr);
          changed |= availableVersions.add(v.shortVersion);
        } catch (_) {
          // Fallback to raw string if parse fails (shouldn't happen with valid data)
          changed |= availableVersions.add(version);
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

  /// Toggles a version filter.
  ///
  /// If a major version (e.g. "3") is toggled:
  /// - Selecting it selects all corresponding minor versions
  ///   (e.g. "3.0", "3.1").
  /// - Deselecting it deselects all corresponding minor versions.
  ///
  /// If a minor version is toggled:
  /// - Selecting it checks if all sibling minor versions are selected; if so,
  ///   the major version is also selected.
  /// - Deselecting it also deselects the parent major version.
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

  /// Compares two version strings using [Version.parse] where possible.
  ///
  /// This implementation normalizes "X.Y" to "X.Y.0" before comparison
  /// to satisfy `pub_semver` strictness.
  /// Falls back to simple string comparison if parsing fails.
  int compareVersions(String v1, String v2) {
    Version? tryParse(String v) {
      try {
        return Version.parse(v);
      } on FormatException {
        // Try normalizing "3.0" -> "3.0.0"
        try {
          if (_versionXyRegex.hasMatch(v)) {
            return Version.parse('$v.0');
          }
        } catch (_) {}
        return null;
      }
    }

    final ver1 = tryParse(v1);
    final ver2 = tryParse(v2);

    if (ver1 != null && ver2 != null) {
      return ver1.compareTo(ver2);
    }
    // Fallback logic
    if (ver1 != null) return 1; // Prioritize valid versions
    if (ver2 != null) return -1;

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
          selectedVersions.contains(entry.shortVersion);
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
