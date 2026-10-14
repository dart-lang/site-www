// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:pub_semver/pub_semver.dart';
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
  Timer? _searchDebounce;
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

    final normalizedQuery = searchQuery.trim().toLowerCase();
    final queryTokens = normalizedQuery.isEmpty
        ? const <String>[]
        : normalizedQuery
              .split(RegExp(r'\s+'))
              .where((t) => t.isNotEmpty)
              .toList();
    final highlightPattern = queryTokens.isEmpty
        ? null
        : RegExp(
            queryTokens.map(RegExp.escape).join('|'),
            caseSensitive: false,
          );

    final entryCards = listContainer.querySelectorAll('.changelog-card');
    for (var i = 0; i < entryCards.length; i++) {
      final element = entryCards.item(i) as web.HTMLElement;
      // Use index to find the corresponding original entry object.
      if (i < entries.length) {
        final entry = entries[i];
        if (entriesToShow.contains(entry)) {
          element.classList.remove('hidden');
          _updateCardHighlights(element, highlightPattern);
        } else {
          element.classList.add('hidden');
          _updateCardHighlights(element, null);
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

  void _updateCardHighlights(web.HTMLElement card, RegExp? pattern) {
    final content = card.querySelector('.card-content');
    if (content == null) return;

    // 1. Unwrap any existing <mark class="search-highlight"> elements.
    final existingMarks = content.querySelectorAll('mark.search-highlight');
    if (existingMarks.length > 0) {
      for (var i = 0; i < existingMarks.length; i++) {
        final mark = existingMarks.item(i) as web.Element;
        final textNode = web.document.createTextNode(mark.textContent ?? '');
        mark.parentNode?.replaceChild(textNode, mark);
      }
      content.normalize();
    }

    if (pattern == null) return;

    // 2. Collect text nodes inside .card-content (excluding .read-more).
    final textNodes = <web.Text>[];
    void collectTextNodes(web.Node node) {
      if (node.nodeType == web.Node.TEXT_NODE) {
        final text = node as web.Text;
        final value = text.nodeValue;
        if (value != null && pattern.hasMatch(value)) {
          textNodes.add(text);
        }
        return;
      }
      if (node.nodeType == web.Node.ELEMENT_NODE) {
        final el = node as web.Element;
        if (el.classList.contains('read-more') ||
            el.classList.contains('release-date')) {
          return;
        }
      }
      final children = node.childNodes;
      for (var i = 0; i < children.length; i++) {
        final child = children.item(i);
        if (child != null) {
          collectTextNodes(child);
        }
      }
    }

    collectTextNodes(content);

    for (final textNode in textNodes) {
      final text = textNode.nodeValue ?? '';
      final matches = pattern.allMatches(text).toList();
      if (matches.isEmpty) continue;

      final fragment = web.document.createDocumentFragment();
      var lastIndex = 0;
      for (final match in matches) {
        if (match.start > lastIndex) {
          fragment.appendChild(
            web.document.createTextNode(text.substring(lastIndex, match.start)),
          );
        }
        final mark = web.document.createElement('mark') as web.HTMLElement
          ..className = 'search-highlight'
          ..textContent = match.group(0);
        fragment.appendChild(mark);
        lastIndex = match.end;
      }
      if (lastIndex < text.length) {
        fragment.appendChild(
          web.document.createTextNode(text.substring(lastIndex)),
        );
      }
      textNode.parentNode?.replaceChild(fragment, textNode);
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
    _searchDebounce?.cancel();
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

  Component _buildUpgradeRangeBar() {
    final sortedVersions = filters.availableVersions.toList()
      ..sort((left, right) => filters.compareVersions(right, left));
    final latestVersion = sortedVersions.isNotEmpty
        ? sortedVersions.first
        : null;
    final v30 = Version(3, 0, 0);

    final isLatestPresetActive =
        latestVersion != null &&
        filters.selectedVersions.length == 1 &&
        filters.selectedVersions.contains(latestVersion) &&
        filters.selectedTags.isEmpty &&
        filters.selectedAreas.isEmpty;

    final isBreakingSince30Active =
        filters.selectedTags.length == 1 &&
        filters.selectedTags.contains(ChangelogTag.breaking) &&
        filters.fromVersion == v30 &&
        filters.toVersion == null;

    final fromValue = filters.fromVersion?.shortVersion ?? '';
    final toValue = filters.toVersion?.shortVersion ?? '';

    return div(classes: 'upgrade-range-bar', [
      div(classes: 'range-selectors', [
        const label(
          attributes: {'for': 'changelog-from-version'},
          [.text('From')],
        ),
        select(
          id: 'changelog-from-version',
          attributes: {'aria-label': 'From Dart version'},
          value: fromValue,
          events: {
            'change': (event) {
              final val = (event.target as web.HTMLSelectElement).value;
              final parsed = val.isEmpty
                  ? null
                  : ChangelogFiltersNotifier.tryParseShortVersion(val);
              filters.setVersionRange(from: parsed, to: filters.toVersion);
            },
          },
          [
            option(
              value: '',
              selected: fromValue.isEmpty,
              [const .text('All versions')],
            ),
            for (final v in sortedVersions)
              option(
                value: v.shortVersion,
                selected: fromValue == v.shortVersion,
                [.text('Dart ${v.shortVersion}')],
              ),
          ],
        ),
        const span(classes: 'range-arrow', [.text('→')]),
        const label(
          attributes: {'for': 'changelog-to-version'},
          [.text('To')],
        ),
        select(
          id: 'changelog-to-version',
          attributes: {'aria-label': 'To Dart version'},
          value: toValue,
          events: {
            'change': (event) {
              final val = (event.target as web.HTMLSelectElement).value;
              final parsed = val.isEmpty
                  ? null
                  : ChangelogFiltersNotifier.tryParseShortVersion(val);
              filters.setVersionRange(from: filters.fromVersion, to: parsed);
            },
          },
          [
            option(
              value: '',
              selected: toValue.isEmpty,
              [const .text('Latest')],
            ),
            for (final v in sortedVersions)
              option(
                value: v.shortVersion,
                selected: toValue == v.shortVersion,
                [.text('Dart ${v.shortVersion}')],
              ),
          ],
        ),
      ]),
      div(classes: 'preset-chips', [
        if (latestVersion != null)
          button(
            type: ButtonType.button,
            classes: 'preset-chip${isLatestPresetActive ? ' active' : ''}',
            attributes: {
              'aria-pressed': '$isLatestPresetActive',
            },
            onClick: () {
              if (isLatestPresetActive) {
                filters.reset();
              } else {
                filters
                  ..selectedTags.clear()
                  ..selectedAreas.clear()
                  ..setVersionRange(from: latestVersion, to: latestVersion);
              }
            },
            [.text("What's new in ${latestVersion.shortVersion}")],
          ),
        button(
          type: ButtonType.button,
          classes: 'preset-chip${isBreakingSince30Active ? ' active' : ''}',
          attributes: {
            'aria-pressed': '$isBreakingSince30Active',
          },
          onClick: () {
            if (isBreakingSince30Active) {
              filters.reset();
            } else {
              filters
                ..selectedAreas.clear()
                ..selectedTags.clear()
                ..selectedTags.add(ChangelogTag.breaking)
                ..setVersionRange(from: v30);
            }
          },
          [const .text('Breaking changes since 3.0')],
        ),
      ]),
    ]);
  }

  @override
  Component build(BuildContext context) {
    final activeFilterCount =
        filters.selectedTags.length +
        filters.selectedAreas.length +
        (filters.selectedVersions.isNotEmpty ? 1 : 0);

    return FilterToolbar(
      id: 'changelog-search-group',
      searchBar: SearchBar(
        placeholder: 'Search changelog...',
        label: 'Search changelog',
        value: searchQuery,
        onInput: (value) {
          setState(() {
            searchQuery = value;
          });
          _searchDebounce?.cancel();
          _searchDebounce = Timer(const Duration(milliseconds: 120), () {
            if (mounted) {
              setFilters();
            }
          });
        },
      ),
      middleRows: [
        if (filters.availableVersions.isNotEmpty) _buildUpgradeRangeBar(),
      ],
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
          content: activeFilterCount > 0 ? '$activeFilterCount' : null,
          classes: ['show-filters-button'],
          onClick: () {
            final toggle = web.document.getElementById(
              'open-filter-toggle',
            ) as web.HTMLInputElement?;
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
            _searchDebounce?.cancel();
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
