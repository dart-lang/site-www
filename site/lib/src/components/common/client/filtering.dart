// Copyright 2025 The Dart Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

class CheckboxFilterGroup<T> extends StatelessComponent {
  const CheckboxFilterGroup({
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onToggle,
    required this.labelProvider,
    required this.idProvider,
    super.key,
  });

  final String title;
  final List<T> items;
  final Set<T> selectedItems;
  final void Function(T item, bool checked) onToggle;
  final String Function(T item) labelProvider;
  final String Function(T item) idProvider;

  @override
  Component build(BuildContext context) {
    return div([
      h4([.text(title)]),
      ul([
        for (final item in items)
          li([
            input(
              type: InputType.checkbox,
              attributes: {
                'name': 'filter-${idProvider(item)}',
                'autocomplete': 'off',
              },
              id: 'filter-${idProvider(item)}',
              checked: selectedItems.contains(item),
              onChange: (checked) => onToggle(item, checked as bool),
            ),
            label(
              attributes: {'for': 'filter-${idProvider(item)}'},
              [.text(labelProvider(item))],
            ),
          ]),
      ]),
    ]);
  }
}

class CollapsibleFilterGroup<T> extends StatefulComponent {
  const CollapsibleFilterGroup({
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.onToggle,
    required this.labelProvider,
    required this.idProvider,
    super.key,
  });

  final String title;
  final List<T> items;
  final Set<T> selectedItems;
  final void Function(T item, bool checked) onToggle;
  final String Function(T item) labelProvider;
  final String Function(T item) idProvider;

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
        ul([
          for (final item in component.items)
            li([
              input(
                type: InputType.checkbox,
                attributes: {
                  'name': 'filter-${component.idProvider(item)}',
                  'autocomplete': 'off',
                },
                id: 'filter-${component.idProvider(item)}',
                checked: component.selectedItems.contains(item),
                onChange: (checked) =>
                    component.onToggle(item, checked as bool),
              ),
              label(
                attributes: {'for': 'filter-${component.idProvider(item)}'},
                [.text(component.labelProvider(item))],
              ),
            ]),
        ]),
      ],
      classes: 'version-group',
      open: _isOpen,
      events: {'toggle': _onToggle},
    );
  }
}

class FilterToolbar extends StatelessComponent {
  const FilterToolbar({
    required this.searchBar,
    required this.resultCount,
    this.actions = const [],
    this.bottomActions = const [],
    this.id,
    super.key,
  });

  final Component searchBar;
  final Component resultCount;
  final List<Component> actions;
  final List<Component> bottomActions;
  final String? id;

  @override
  Component build(BuildContext context) {
    return div(id: id, classes: 'chip-filters-group', [
      div(classes: 'top-row', [
        searchBar,
        if (actions.isNotEmpty) ...actions,
      ]),
      div(classes: 'label-row', [
        resultCount,
        if (bottomActions.isNotEmpty) ...bottomActions,
      ]),
    ]);
  }
}
