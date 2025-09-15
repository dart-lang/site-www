// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';

import 'material_icon.dart';

/// A generic button component with different style variants.
class Button extends StatelessComponent {
  /// Creates a button with textual [content] and an optional [icon].
  const Button.text({
    super.key,
    required String this.content,
    this.href,
    this.style = ButtonStyle.text,
    this.icon,
    this.id,
    this.attributes = const {},
    this.classes,
    this.disabled = false,
    this.title,
    this.asRaw = false,
    this.onClick,
  });

  /// Creates an icon button with the specified [icon] and no text.
  const Button.icon({
    super.key,
    required String this.icon,
    this.href,
    this.content,
    this.style = ButtonStyle.text,
    this.id,
    this.attributes = const {},
    this.classes,
    this.disabled = false,
    this.title,
    this.asRaw = false,
    this.onClick,
  });

  final String? content;
  final String? title;
  final ButtonStyle style;
  final String? icon;
  final String? id;
  final String? href;
  final Map<String, String> attributes;
  final bool disabled;
  final bool asRaw;
  final List<String>? classes;
  final void Function()? onClick;

  @override
  Component build(BuildContext context) {
    final mergedAttributes = <String, String>{
      ...attributes,
      if (disabled) 'disabled': 'disabled',
      'title': ?title,
    };

    final mergedClasses = [
      style.cssClass,
      if (icon != null && content == null) 'icon-button',
      ...?classes,
    ].join(' ');

    final children = [
      if (icon case final iconId?) MaterialIcon(iconId),
      if (content case final contentText?)
        asRaw ? raw(contentText) : text(contentText),
    ];

    if (href case final href?) {
      return a(
        id: id,
        href: href,
        classes: mergedClasses,
        attributes: mergedAttributes,
        onClick: onClick,
        children,
      );
    } else {
      return button(
        id: id,
        classes: mergedClasses,
        attributes: mergedAttributes,
        onClick: onClick,
        children,
      );
    }
  }
}

enum ButtonStyle {
  filled,
  outlined,
  text;

  String get cssClass => switch (this) {
    ButtonStyle.filled => 'filled-button',
    ButtonStyle.outlined => 'outlined-button',
    ButtonStyle.text => 'text-button',
  };
}
