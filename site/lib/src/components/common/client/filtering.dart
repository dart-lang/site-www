// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

/// A group of checkboxes for filtering a list of items.
///
/// [T] must implement [Object.==] and [Object.hashCode] for correct
/// selection tracking.
class CheckboxFilterGroup<T> extends StatelessComponent {
  const CheckboxFilterGroup({
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onToggle,
    required this.labelProvider,
    required this.idProvider,
    this.isCheckedProvider,
    super.key,
  });

  /// The title to display above the group.
  final String title;

  /// The list of items to display options for.
  final List<T> items;

  /// The currently selected items.
  ///
  /// This set is checked against [items] using [Object.==].
  final Set<T> selectedItems;

  /// Callback when an item is toggled.
  final void Function(T item, bool checked) onToggle;

  /// Returns the display label for an item.
  final String Function(T item) labelProvider;

  /// Returns a unique ID string for an item, used for HTML IDs and attributes.
  final String Function(T item) idProvider;

  /// Optional provider to determine if an item is checked.
  /// Overrides [selectedItems] containment check if provided.
  final bool Function(T item)? isCheckedProvider;

  @override
  Component build(BuildContext context) {
    return div([
      h4([.text(title)]),
      _FilterCheckboxList(
        items: items,
        selectedItems: selectedItems,
        onToggle: onToggle,
        labelProvider: labelProvider,
        idProvider: idProvider,
        isCheckedProvider: isCheckedProvider,
      ),
    ]);
  }
}

/// A collapsible group of checkboxes for filtering.
///
/// [T] must implement [Object.==] and [Object.hashCode] for correct
/// selection tracking.
class CollapsibleFilterGroup<T> extends StatefulComponent {
  const CollapsibleFilterGroup({
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onToggle,
    required this.labelProvider,
    required this.idProvider,
    this.isCheckedProvider,
    super.key,
  });

  /// The title to display in the summary.
  final String title;

  /// The list of items to display options for.
  final List<T> items;

  /// The currently selected items.
  ///
  /// This set is checked against [items] using [Object.==].
  final Set<T> selectedItems;

  /// Callback when an item is toggled.
  final void Function(T item, bool checked) onToggle;

  /// Returns the display label for an item.
  final String Function(T item) labelProvider;

  /// Returns a unique ID string for an item, used for HTML IDs and attributes.
  final String Function(T item) idProvider;

  /// Optional provider to determine if an item is checked.
  final bool Function(T item)? isCheckedProvider;

  @override
  State<CollapsibleFilterGroup<T>> createState() =>
      _CollapsibleFilterGroupState<T>();
}

class _CollapsibleFilterGroupState<T> extends State<CollapsibleFilterGroup<T>> {
  bool _isOpen = false;

  void _onToggle(web.Event event) {
    final target = event.target as web.HTMLDetailsElement;
    _isOpen = target.open;
  }

  @override
  Component build(BuildContext context) {
    return details(
      [
        summary([.text(component.title)]),
        _FilterCheckboxList(
          items: component.items,
          selectedItems: component.selectedItems,
          onToggle: component.onToggle,
          labelProvider: component.labelProvider,
          idProvider: component.idProvider,
          isCheckedProvider: component.isCheckedProvider,
        ),
      ],
      classes: 'version-group',
      open: _isOpen,
      events: {'toggle': _onToggle},
    );
  }
}

/// A private helper component to render a list of checkboxes.
///
/// Refactored to centralize list rendering and optimization logic.
class _FilterCheckboxList<T> extends StatelessComponent {
  const _FilterCheckboxList({
    required this.items,
    required this.selectedItems,
    required this.onToggle,
    required this.labelProvider,
    required this.idProvider,
    this.isCheckedProvider,
  });

  final List<T> items;
  final Set<T> selectedItems;
  final void Function(T item, bool checked) onToggle;
  final String Function(T item) labelProvider;
  final String Function(T item) idProvider;
  final bool Function(T item)? isCheckedProvider;

  @override
  Component build(BuildContext context) {
    return ul([
      ...items.map((item) {
        final itemId = 'filter-${idProvider(item)}';
        return li([
          input(
            type: InputType.checkbox,
            attributes: {
              'name': itemId,
              'autocomplete': 'off',
            },
            id: itemId,
            checked:
                isCheckedProvider?.call(item) ?? selectedItems.contains(item),
            onChange: (checked) => onToggle(item, checked as bool),
          ),
          label(
            attributes: {'for': itemId},
            [.text(labelProvider(item))],
          ),
        ]);
      }),
    ]);
  }
}

/// A toolbar component containing a search bar, result count, and actions.
///
/// Used to construct the header area of filter views.
class FilterToolbar extends StatelessComponent {
  const FilterToolbar({
    required this.searchBar,
    required this.resultCount,
    this.actions = const [],
    this.trailingActions = const [],
    this.id,
    super.key,
  });

  /// The search bar component.
  final Component searchBar;

  /// The result count component.
  final Component resultCount;

  /// List of action components to display in the top row.
  final List<Component> actions;

  /// List of action components to display in the bottom row.
  final List<Component> trailingActions;

  /// Optional ID for the toolbar container.
  final String? id;

  @override
  Component build(BuildContext context) {
    return div(id: id, classes: 'chip-filters-group', [
      div(classes: 'top-row', [
        searchBar,
        ...actions,
      ]),
      div(classes: 'label-row', [
        resultCount,
        ...trailingActions,
      ]),
    ]);
  }
}
