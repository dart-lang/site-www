import 'package:markdown/markdown.dart' as md;

/// A custom Markdown block syntax for alerts that are
/// opened and closed with `:::`.
///
/// Example:
///
/// ```md
/// :::important The title of my alert
/// The content of my alert.
/// :::
/// ```
///
/// This renders as HTML similar to:
/// ```html
/// <aside class="alert alert-important">
///   <div class="alert-header">
///     <span class="material-symbols" aria-hidden="true">important_icon</span>
///     <span>The title of my alert</span>
///   </div>
///   <div class="alert-content">
///     <p>The content of my alert.</p>
///   </div>
/// </aside>
/// ```
final class AlertBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^:::([a-zA-Z-]+)(?:\s+(.*))?$');

  const AlertBlockSyntax();

  @override
  bool canParse(md.BlockParser parser) {
    return pattern.hasMatch(parser.current.content);
  }

  @override
  md.Node? parse(md.BlockParser parser) {
    final match = pattern.firstMatch(parser.current.content);
    if (match == null) return null;

    final alertType = match.group(1)!.toLowerCase();
    var title = match.group(2)?.trim();

    if (title == null || title.isEmpty) {
      title = _defaultTitleForType(alertType);
    }

    // Advance past the opening line.
    parser.advance();

    // Collect content lines until we find the closing :::.
    final contentLines = <String>[];
    while (!parser.isDone) {
      final line = parser.current.content;
      if (line.trim() == ':::') {
        // Consume the closing line.
        parser.advance();
        break;
      }
      contentLines.add(line);
      parser.advance();
    }

    // Create a new BlockParser with the same document context.
    // This preserves link references and other document-level state.
    final contentNodes = md.BlockParser(
      contentLines.map(md.Line.new).toList(growable: false),
      parser.document,
    ).parseLines(parentSyntax: this);

    final alertChildren = <md.Node>[];

    // If title is provided, create and add a header.
    if (title != null && title.isNotEmpty) {
      final headerChildren = <md.Node>[];

      // If the type is any but 'secondary', add an icon.
      if (alertType != 'secondary') {
        final iconElement =
            md.Element('span', [md.Text(_iconIdForType(alertType))])
              ..attributes['class'] = 'material-symbols'
              ..attributes['aria-hidden'] = 'true';
        headerChildren.add(iconElement);
      }

      // Parse the title as inline Markdown to support links, emphasis, etc.
      final titleNodes = parser.document.parseInline(title);
      headerChildren.add(md.Element('span', titleNodes));

      alertChildren.add(
        md.Element('div', headerChildren)..attributes['class'] = 'alert-header',
      );
    }

    final contentElement = md.Element('div', contentNodes)
      ..attributes['class'] = 'alert-content';
    alertChildren.add(contentElement);

    final alertElement = md.Element('aside', alertChildren)
      ..attributes['class'] = 'alert ${_cssClassForType(alertType)}';

    return alertElement;
  }

  /// Returns the default title for the given [alertType].
  String? _defaultTitleForType(String alertType) => switch (alertType) {
    'note' => 'Note',
    'flutter-note' => 'Flutter note',
    'version-note' => 'Version note',
    'tip' => 'Tip',
    'recommend' => 'Recommended',
    'important' => 'Important',
    'warning' => 'Warning',
    'caution' => 'Caution',
    'secondary' || _ => null,
  };

  /// Returns the appropriate CSS class for the given [alertType].
  String _cssClassForType(String alertType) => switch (alertType) {
    'note' || 'version-note' || 'flutter-note' => 'alert-info',
    'tip' || 'recommend' => 'alert-success',
    'important' => 'alert-important',
    'warning' => 'alert-warning',
    'caution' => 'alert-danger',
    _ => 'alert-secondary',
  };

  /// Returns the appropriate icon name for the given [alertType].
  String _iconIdForType(String alertType) => switch (alertType) {
    'note' => 'info',
    'flutter-note' => 'flutter',
    'version_note' => 'merge_type',
    'tip' => 'lightbulb',
    'recommend' => 'bolt',
    'important' => 'feedback',
    'warning' => 'warning',
    'caution' => 'error',
    _ => 'info',
  };
}
