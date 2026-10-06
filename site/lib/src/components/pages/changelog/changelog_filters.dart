// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../../../models/changelog_model.dart';
import '../../common/button.dart';
import '../../common/client/filtering.dart';
import '../../common/search.dart';
import 'changelog_filters_notifier.dart';
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

  bool _isApplyingHash = false;
  JSFunction? _hashChangeListener;
  JSFunction? _cardAnchorClickListener;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      filters.addListener(_onFiltersChanged);

      _hashChangeListener = ((web.Event _) {
        _applyUrlHash(web.window.location.hash);
      }).toJS;
      web.window.addEventListener('hashchange', _hashChangeListener);

      final listContainer = web.document.getElementById('all-changelog-list');
      if (listContainer != null) {
        _initializeFromDom(listContainer);
      } else {
        context.binding.addPostFrameCallback(() {
          final deferredContainer = web.document.getElementById(
            'all-changelog-list',
          );
          if (deferredContainer != null && mounted) {
            _initializeFromDom(deferredContainer);
          }
        });
      }
    }
  }

  void _initializeFromDom(web.Element listContainer) {
    final entryCards = listContainer.querySelectorAll('.changelog-card');
    _recreateEntries(entryCards);

    _isApplyingHash = true;
    try {
      filters.populateAvailableFiltersFromDOM();
    } finally {
      _isApplyingHash = false;
    }

    // global_scripts.dart intercepts a.heading-link clicks with replaceState
    // (which does not fire hashchange), so highlight the card on click.
    _cardAnchorClickListener = ((web.Event event) {
      final target = event.target;
      if (target != null && target.isA<web.Element>()) {
        final anchor = (target as web.Element).closest('a.card-anchor');
        final card = anchor?.closest('.changelog-card');
        if (card != null && card.isA<web.HTMLElement>()) {
          _clearHighlightedCards();
          (card as web.HTMLElement).classList.add('highlighted-card');
        }
      }
    }).toJS;
    listContainer.addEventListener('click', _cardAnchorClickListener);

    if (web.window.location.hash.isNotEmpty) {
      _applyUrlHash(web.window.location.hash);
    } else {
      setState(() {});
    }
  }

  void _recreateEntries(web.NodeList entryCards) {
    entries.clear();
    for (var i = 0; i < entryCards.length; i++) {
      final element = entryCards.item(i) as web.Element;
      final entry = ChangelogEntry.fromElement(element);
      entries.add(entry);
    }
    filteredEntriesCount = entries.length;
  }

  void _onFiltersChanged() {
    if (_isApplyingHash) {
      setState(() {});
      return;
    }
    setFilters();
  }

  void _applyUrlHash(String rawHash) {
    _isApplyingHash = true;
    try {
      final result = filters.parseAndApplyUrlFragment(rawHash);
      setState(() {
        searchQuery = result.searchQuery;
      });
      _updateDomVisibility();
      _clearHighlightedCards();

      if (result.targetId case final targetId?) {
        final target = web.document.getElementById(targetId);
        if (target != null && target.isA<web.HTMLElement>()) {
          final targetElement = target as web.HTMLElement;
          targetElement.classList.remove('hidden');
          targetElement.closest('.version-group')?.classList.remove('hidden');
          if (targetElement.classList.contains('changelog-card')) {
            targetElement.classList.add('highlighted-card');
          }
          Future<void>.delayed(Duration.zero, () {
            if (mounted) {
              targetElement.scrollIntoView();
            }
          });
        }
      }
    } finally {
      _isApplyingHash = false;
    }
  }

  void _clearHighlightedCards() {
    final highlighted = web.document.querySelectorAll(
      '.changelog-card.highlighted-card',
    );
    for (var i = 0; i < highlighted.length; i++) {
      (highlighted.item(i) as web.HTMLElement).classList.remove(
        'highlighted-card',
      );
    }
  }

  void setFilters([void Function()? callback]) {
    setState(callback ?? () {});
    _updateDomVisibility();
    _syncUrlHash();
  }

  void _updateDomVisibility() {
    final entriesToShow = filters.filterEntries(entries, searchQuery).toSet();
    filteredEntriesCount = entriesToShow.length;

    final listContainer = web.document.getElementById('all-changelog-list');
    if (listContainer == null) return;

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

    // Hide empty version groups
    final versionGroups = listContainer.querySelectorAll('.version-group');
    for (var i = 0; i < versionGroups.length; i++) {
      final group = versionGroups.item(i) as web.HTMLElement;
      final visibleEntries = group.querySelectorAll(
        '.changelog-card:not(.hidden)',
      );
      if (visibleEntries.length == 0) {
        group.classList.add('hidden');
      } else {
        group.classList.remove('hidden');
      }
    }
  }

  void _syncUrlHash() {
    final hasActiveFilters =
        searchQuery.trim().isNotEmpty ||
        filters.selectedTags.isNotEmpty ||
        filters.selectedAreas.isNotEmpty ||
        filters.selectedVersions.isNotEmpty;
    final highlighted = hasActiveFilters
        ? web.document.querySelector(
            '.changelog-card.highlighted-card:not(.hidden)',
          )
        : null;
    final fragment = filters.toUrlFragment(
      searchQuery: searchQuery,
      targetId: highlighted?.id,
    );
    if (fragment.isNotEmpty) {
      web.window.history.replaceState(null, '', '#$fragment');
    } else if (web.window.location.hash.isNotEmpty) {
      web.window.history.replaceState(
        null,
        '',
        '${web.window.location.pathname}${web.window.location.search}',
      );
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      filters.removeListener(_onFiltersChanged);
      if (_hashChangeListener != null) {
        web.window.removeEventListener('hashchange', _hashChangeListener);
      }
      if (_cardAnchorClickListener != null) {
        web.document
            .getElementById('all-changelog-list')
            ?.removeEventListener('click', _cardAnchorClickListener);
      }
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
          const .text('Showing '),
          span([.text('$filteredEntriesCount')]),
          const .text(' / '),
          span([.text('${entries.length}')]),
        ],
      ),
      actions: [
        Button(
          icon: 'filter_list',
          classes: ['show-filters-button'],
          onClick: () {
            final toggle =
                web.document.getElementById(
                      'open-filter-toggle',
                    )
                    as web.HTMLInputElement?;
            if (toggle != null) {
              toggle.checked = !toggle.checked;
            }
          },
        ),
      ],
      trailingActions: [
        Button(
          icon: 'close_small',
          content: 'Clear filters',
          disabled:
              searchQuery.isEmpty &&
              filters.selectedTags.isEmpty &&
              filters.selectedAreas.isEmpty &&
              filters.selectedVersions.isEmpty,
          onClick: () {
            // Update search query and reset filters.
            // We call setFilters to ensure the UI updates even if
            // filters.reset() doesn't trigger a change,
            // such as if only search query was active.
            searchQuery = '';
            _clearHighlightedCards();
            filters.reset();
            setFilters();
          },
        ),
      ],
    );
  }
}
