// Copyright 2025 The Dart Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../../../models/changelog_model.dart';
import '../../common/client/filtering.dart';
import '../../common/search.dart';
import 'changelog_filters_sidebar.dart';

@client
class ChangelogFilters extends StatefulComponent {
  const ChangelogFilters({super.key});

  @override
  State<ChangelogFilters> createState() => _ChangelogFiltersState();
}

class _ChangelogFiltersState extends State<ChangelogFilters> {
  String searchQuery = '';

  ChangelogFiltersNotifier get filters => ChangelogFiltersSidebar.filters;

  final List<ChangelogEntry> entries = [];
  int filteredEntriesCount = 0;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      filters.addListener(setFilters);

      final listContainer = web.document.getElementById('all-changelog-list');
      if (listContainer == null) {
        return;
      }

      final entryCards = listContainer.querySelectorAll('.changelog-card');
      recreateEntries(entryCards);
    }
  }

  void recreateEntries(web.NodeList entryCards) {
    for (var i = 0; i < entryCards.length; i++) {
      final element = entryCards.item(i) as web.Element;
      final entry = ChangelogEntry.fromElement(element);
      entries.add(entry);
    }
    filteredEntriesCount = entries.length;
  }

  void setFilters([void Function()? callback]) {
    setState(callback ?? () {});

    final entriesToShow = filters.filterEntries(entries, searchQuery);
    filteredEntriesCount = entriesToShow.length;

    final listContainer = web.document.getElementById('all-changelog-list');
    if (listContainer != null) {
      final entryCards = listContainer.querySelectorAll('.changelog-card');
      for (var i = 0; i < entryCards.length; i++) {
        final element = entryCards.item(i) as web.HTMLElement;
        // Use index to find the corresponding original entry object.
        if (i < entries.length) {
          final entry = entries[i];
          if (entriesToShow.contains(entry)) {
            element.classList.remove('hidden');
          } else {
            element.classList.add('hidden');
          }
        }
      }
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      filters.removeListener(setFilters);
    }
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return FilterToolbar(
      id: 'changelog-search-group',
      searchBar: SearchBar(
        placeholder: 'Search changelog...',
        label: 'Search changelog',
        value: searchQuery,
        onInput: (value) {
          setFilters(() {
            searchQuery = value;
          });
        },
      ),
      resultCount: label(
        attributes: {'for': 'changelog-search'},
        [
          text('Showing '),
          span([text('$filteredEntriesCount')]),
          text(' / '),
          span([text('${entries.length}')]),
        ],
      ),
      actions: [
        button(
          classes: 'icon-button show-filters-button',
          onClick: () {
            final toggle =
                web.document.getElementById('open-filter-toggle')
                    as web.HTMLInputElement?;
            if (toggle != null) {
              toggle.checked = !toggle.checked;
            }
          },
          [
            span(classes: 'material-symbols-outlined', [text('filter_list')]),
          ],
        ),
      ],
      bottomActions: [
        button(
          attributes: {
            if (searchQuery.isEmpty &&
                filters.selectedTags.isEmpty &&
                filters.selectedAreas.isEmpty &&
                filters.selectedVersions.isEmpty)
              'disabled': 'true',
          },
          onClick: () {
            // Update search query and reset filters.
            // We call setFilters to ensure the UI updates even if filters.reset()
            // doesn't trigger a change (e.g. only search query was active).
            searchQuery = '';
            filters.reset();
            setFilters();
          },
          [
            span(classes: 'material-symbols-outlined', [text('close_small')]),
            span([text('Clear filters')]),
          ],
        ),
      ],
    );
  }
}
